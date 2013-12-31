module.exports = {
  name: 'Tutorial'
  levels: [
    {
      name         : '1'
      instructions : 'Push the box onto the target.<p>(use arrow keys to move)'
      lines        : [
        '#######'
        '#@$  .#'
        '#######'
      ]
    }
    {
      name         : '2'
      instructions : "Try again with two boxes. Note that you can't push two boxes at once.<p>(if you make a mistake, use the 'Restart' or 'Undo' buttons)"
      lines        : [
        '#######'
        '#     #'
        '#     #'
        '#@$$..#'
        '#     #'
        '#     #'
        '#######'
      ]
    }
    {
      name         : '3'
      instructions : "Sometimes you have to move boxes a bit to get around them."
      lines        : [
        '##### #####'
        '#   ###   #'
        '#.@$      #'
        '###########'
      ]
    }
    {
      name         : '4'
      instructions : "Here's a slightly more complicated example."
      lines        : [
        '  ###'
        '  #.# #####'
        '### ###   #'
        '#@$       #'
        '###  ######'
        '  ####'
      ]
    }
  ]
}
