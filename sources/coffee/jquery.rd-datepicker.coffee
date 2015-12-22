###*
 * RDDatePicker
 * @license MIT License
###
(($, document, window) ->
  ###*
   * Initial flags
   * @public
  ###
  isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)

  ###*
   * Creates a datepicker.
   * @class RDDatePicker.
   * @public
   * @param {HTMLElement} element - The element to create the datepicker for.
   * @param {Object} [options] - The options
  ###
  class RDDatePicker
    ###*
     * Default options for datepicker.
     * @public
    ###
    Defaults:
      mobile: false
      days: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
      months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
      format: "mm-dd-yyyy"
      prevClass: "rd-datepicker-prev fa-angle-left"
      nextClass: "rd-datepicker-next fa-angle-right"
      prevText: ""
      nextText: ""
      callbacks: null


    constructor: (element, options) ->
      @.options = $.extend(true, {}, @.Defaults, options)
      @.$element = $(element)
      @.$picker = null
      @.$win = $(window)
      @.$doc = $(document)
      if isMobile
        if @.options.mobile
          @.initialize()
      else
        @.initialize()

    ###*
     * Initializes the Parallax.
     * @protected
    ###
    initialize: () ->

      if type = @.$element.attr('type')
        @.$element.attr('type', 'text') if type is 'date'

      @.createPickerDOM()
       .applyHandlers()

      return @

    createPickerDOM: ()->
      ctx = @

      ctx.$picker = $('<div/>', {
        'class': 'rd-datepicker'
      }).data('date', new Date())
        .append("<div class='rd-datepicker-header'>
          <span class='#{ctx.options.prevClass}'>#{ctx.options.prevText}</span>
          <span class='#{ctx.options.nextClass}'>#{ctx.options.nextText}</span>
          <div class='rd-datepicker-title'></div>
        </div><div class='rd-datepicker-body'></div>")

      ctx.$element.after(ctx.$picker)
      ctx.refresh()
      return @

    applyHandlers: ()->
      ctx = @

      ctx.$element.on('focus', $.proxy(ctx.open, ctx))
      ctx.$element.on('input change propertychange', $.proxy(ctx.open, ctx))
      ctx.$doc.find('*').on('focus', (e)->
        target = e.target
        if target isnt ctx.$element[0] and target isnt ctx.$picker[0] and not $(target).parents('.rd-datepicker').length
          $.proxy(ctx.close, ctx)()
      )
      ctx.$picker.on('click', '.rd-datepicker-day', ctx, ctx.pick)
      ctx.$picker.on('click', '.rd-datepicker-next', $.proxy(ctx.next, ctx))
      ctx.$picker.on('click', '.rd-datepicker-prev', $.proxy(ctx.prev, ctx))
      ctx.$doc.on('click', (e)->
        target = e.target
        if target isnt ctx.$element[0] and target isnt ctx.$picker[0] and not $(target).parents('.rd-datepicker').length
          $.proxy(ctx.close, ctx)()
      )

      return ctx

    next: ()->
      date = @.$picker.data('date')

      if date.getMonth() == 11
        date = new Date(date.getFullYear() + 1, 0, 1)
      else
        date = new Date(date.getFullYear(), date.getMonth() + 1, 1)

      @.$picker.data('date', date)
      @.refresh()
      return @

    prev: ()->
      date = @.$picker.data('date')

      if date.getMonth() == 0
        date = new Date(date.getFullYear() - 1, 11, 1)
      else
        date = new Date(date.getFullYear(), date.getMonth() - 1, 1)

      @.$picker.data('date', date)
      @.refresh()

    open: ()->
      @.$picker.addClass('rd-datepicker-open')
      return @

    close: (e)->
      @.$picker.removeClass('rd-datepicker-open')
      return @

    pick: (e)->
      ctx = e.data
      $day = $(@).addClass('selected')
      dayDate = $day.data('date')

      ctx.$picker
        .data('pickedDate', dayDate)
        .find('.rd-datepicker-day')
        .not(@)
        .removeClass('selected')

      ctx.$element.val(dayDate.format(ctx.options.format))
      ctx.$element.focus()
      setTimeout($.proxy(ctx.close, ctx))
      return @

    refresh: ()->
      # current picker states
      date = @.$picker.data("date")
      today = new Date()
      pickedDate = @.$picker.data("pickedDate")
      monthLength = new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate()
      prevMonthLength = new Date(date.getFullYear(), date.getMonth(), 0).getDate()
      firstDay = new Date(date.getFullYear(), date.getMonth(), 1).getDay()
      counter = 1

      # reset today settings
      today.setHours(0)
      today.setMinutes(0)
      today.setSeconds(0)
      today.setMilliseconds(0)

      # build new calendar
      $calendar = $("<table>")

      $week = $("<tr/>")
      for day in @.options.days
        $week.append("<th class='rd-datepicker-week'>#{day}</th>")
      $calendar.append($week)

      for i in [0..6]
        $week = $('<tr/>')
        for j in [0..6]
          day = 7 * i + j + 1
          dayClass = 'rd-datepicker-day'

          # If Month had ended and new week started
          if j == 0 && day > monthLength + firstDay
            break

          # If the day belongs to previous month
          if day - firstDay < 1
            dayText = prevMonthLength + day - firstDay
            dayClass += ' offset'
            dayDate = new Date(date.getFullYear(), date.getMonth() - 1, prevMonthLength + (day - firstDay))

          # If the day belongs to current month
          else if day <= monthLength + firstDay
            dayText = day - firstDay
            dayDate = new Date(date.getFullYear(), date.getMonth(), day - firstDay)

          # If the day belongs to next month
          else
            dayText = counter
            dayClass += ' offset'
            dayDate = new Date(date.getFullYear(), date.getMonth() + 1, counter++)

          # If current day is today
          if dayDate.valueOf() is today.valueOf()
            dayClass += ' today'

          # If current day was selected
          if pickedDate
            if dayDate.valueOf() is pickedDate.valueOf()
              dayClass += ' selected'

          $week.append($('<td/>', {
            'class': dayClass
            'text': dayText
          }).data('date', dayDate))

        $calendar.append($week) if $week.html() isnt ''

      # update picker
      @.$picker
        .find('.rd-datepicker-title').text(@.options.months[date.getMonth()] + " " + date.getFullYear())
        .end()
        .find('.rd-datepicker-body').html($calendar);

      return @

  ###*
   * The jQuery Plugin for the RD Parallax
   * @public
  ###
  $.fn.extend RDDatePicker: (options) ->
    @each ->
      $this = $(this)
      if !$this.data('RDDatePicker')
        $this.data 'RDDatePicker', new RDDatePicker(this, options)

  window.RDDatePicker = RDDatePicker) window.jQuery, document, window


###*
 * The Plugin AMD export
 * @public
###
if module?
  module.exports = window.RDDatePicker
else if typeof define is 'function' && define.amd
  define(["jquery"], () ->
    'use strict'
    return window.RDDatePicker
  )