; This file has the linked list for the
; Jungle's layout
	.ORIG	x5000
	.FILL	Head
blk2
	.FILL   blk4
        .FILL	#1
	.FILL   #1
	.FILL   x23

Head
	.FILL	blk1
        .FILL   #0
	.FILL   #1
	.FILL   x23

blk1
	.FILL   blk3
	.FILL   #4
	.FILL   #7
	.FILL   x48

blk3
	.FILL   blk2
	.FILL   #2
	.FILL   #1
	.FILL   x49

blk4
	.FILL   blk5
	.FILL   #6
	.FILL   #3
	.FILL   x23

blk7
	.FILL   #0
	.FILL   #5
	.FILL   #6
	.FILL   x23
blk6
	.FILL   blk7
	.FILL   #4
	.FILL   #4
	.FILL   x23
blk5
	.FILL   blk6
	.FILL   #3
	.FILL   #5
	.FILL   x23
	.END	