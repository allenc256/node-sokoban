define [
  'lib/chai'
  'models/board-model'
], (
  chai
  BoardModel
) ->
  assert = chai.assert

  describe 'BoardModel', ->
    b = new BoardModel([
      '######'
      '#@ $.#'
      '######'
    ])

    it 'constructor works', ->
      assert.equal(6, b.attributes.width)
      assert.equal(3, b.attributes.height)
      assert.equal(1, b.attributes.player.attributes.x)
      assert.equal(1, b.attributes.player.attributes.y)
      assert.equal(3, b.attributes.boxes[0].attributes.x)
      assert.equal(1, b.attributes.boxes[0].attributes.y)
      assert.equal(0, b.attributes.history.length)

    it 'movePlayer respects walls', ->
      b.movePlayer(-1, 0)
      assert.equal(0, b.attributes.history.length)

    it 'movePlayer works for empty spot', ->
      b.movePlayer(1, 0)
      assert.equal(2, b.attributes.player.attributes.x)
      assert.equal(1, b.attributes.player.attributes.y)
      assert.equal(1, b.attributes.history.length)

    it 'movePlayer works with boxes', ->
      b.movePlayer(1, 0)
      b.movePlayer(1, 0)
      assert.equal(3, b.attributes.player.attributes.x)
      assert.equal(1, b.attributes.player.attributes.y)
      assert.equal(4, b.attributes.boxes[0].attributes.x)
      assert.equal(1, b.attributes.boxes[0].attributes.y)
      assert.equal(2, b.attributes.history.length)
      assert.equal(1, b.attributes.completed)

    it 'undoLastMove works', ->
      b.movePlayer(1, 0)
      b.movePlayer(1, 0)
      b.undoLastMove()
      assert.equal(2, b.attributes.player.attributes.x)
      assert.equal(1, b.attributes.player.attributes.y)
      assert.equal(3, b.attributes.boxes[0].attributes.x)
      assert.equal(1, b.attributes.boxes[0].attributes.y)
      assert.equal(1, b.attributes.history.length)
      assert.equal(0, b.attributes.completed)
      b.undoLastMove()
      assert.equal(1, b.attributes.player.attributes.x)
      assert.equal(1, b.attributes.player.attributes.y)
      assert.equal(3, b.attributes.boxes[0].attributes.x)
      assert.equal(1, b.attributes.boxes[0].attributes.y)
      assert.equal(0, b.attributes.history.length)
      assert.equal(0, b.attributes.completed)


