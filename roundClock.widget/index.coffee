# Read style section for settings (e.g. retina scaling, colors)

# elements to show or hide
appearance =
  secDigit: true
  secHand : true
  showAMPM: true   # false will use 24-hour time; true will use 12-hour time

appearance: appearance

command: "date +%H,%M,%S"

refreshFrequency: 1000

render: (output) -> """
<svg version="1.1" id="clock" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 215 215" enable-background="new 0 0 215 215" xml:space="preserve">
  <defs>
    <marker id="sec-mk" markerHeight="10" markerWidth="5" refX="0" refY="5" orient="auto">
      <polygon points="0,0 0,10 5,5"/>
    </marker>
    <marker id="hr-mk" markerHeight="10" markerWidth="5" refX="0" refY="5" orient="auto">
      <polygon points="0,0 0,10 5,5"/>
    </marker>
  </defs>

  <path id="min-ln" stroke-width="15" stroke-miterlimit="10" d="M107.5,7.5c55.2,0,100,44.8,100,100s-44.8,100-100,100s-100-44.8-100-100S52.3,7.5,107.5,7.5"/>

  <line id="hr-ln" class="line" marker-end="url(#hr-mk)" stroke-miterlimit="10" x1="107" y1="107.5" x2="107" y2="24.5"/>
  <line id="sec-ln" class="line" marker-end="url(#sec-mk)" stroke-miterlimit="10" x1="107" y1="107.5" x2="107" y2="24.5"/>
</svg>

<div id="digits">
  <span id="hr-dig"></span><span id="min-dig"></span><span id="ampm"></span><div id="sec-dig"></div>
</div>
"""

update: (output) ->
  time = output.split(',')

  circ = Math.PI*2*100

  if @appearance.showAMPM
    if time[0] > 12
      time[0] = time[0] - 12
      $('#ampm').text "pm"
    else
      $('#ampm').text "am"

  $('#hr-dig').text time[0]
  $('#min-dig').text time[1]
  if @appearance.secDigit
    $('#sec-dig').text time[2]

  $('#min-ln').css('stroke-dashoffset',circ - ( ( parseInt(time[1]) + ( time[2] / 60 ) ) / 60 ) * circ)
  $('#sec-ln').css('-webkit-transform','rotate('+( time[2] / 60 ) * 360+'deg)')
  $('#hr-ln').css('-webkit-transform','rotate('+( ( parseInt(time[0] % 12) + ( time[1] / 60 ) ) / 12 ) * 360+'deg)')

style: """
  /* Settings */
  main = #ffffff
  second = rgba(#CC0000, 0.75)
  background = rgba(0, 0, 0, 0.75)
  transitions = false                   // disabled by default to save CPU cycles
  scale = 1                             // set to 2 to scale for retina displays

  /* Styles (mod if you want) */
  box-sizing: border-box

  left: 0%
  bottom: 0%
  margin-left: 10px * scale
  margin-bottom: 10px * scale

  width: 225px * scale
  height: 225px * scale

  padding: 5px * scale
  background: background
  border-radius: 112.5px * scale

  svg
    width: 215px * scale
    height: 215px * scale

  #hr-mk polygon
    fill: main
  #sec-mk polygon
    if #{appearance.secHand}
      fill: second
    else
      fill: none
  .line
    -webkit-transform-origin: 100% 100%    // centers the ticks

    if transitions
      -webkit-transition: -webkit-transform .25s cubic-bezier(0.175, 0.885, 0.32, 1.275)    // this bezier gives the tick a natural bounce
  #min-ln
    stroke: main
    fill: none

    stroke-dasharray: PI*2*100
    stroke-dashoffset: PI*2*100

    if transitions
      -webkit-transition: stroke-dashoffset .5s ease

  #digits
    position: absolute
    left:     50%
    top:      50%
    margin-left: -107.5px * scale
    margin-top: -38px * scale
    width:    215px * scale

    font-family: Futura-Medium
    font-size: 72px * scale
    line-height: 1
    text-align: center
    -webkit-font-smoothing: antialiased    // the transparent bg makes subpixel look bad
    color: main
  #hr-dig
    font-family: Futura-Medium
    letter-spacing: -3px * scale
    margin-right: 3px * scale
  #min-dig
    font-size: 48px * scale
    letter-spacing: -2px * scale
  #ampm
    font-family: Futura-Medium
    font-size: 20px * scale
    margin-left: 3px * scale
  #sec-dig
    font-family: Futura-Medium
    font-size: 24px * scale
    color: second
"""

