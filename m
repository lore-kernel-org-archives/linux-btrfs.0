From: Chris Mason <chris.mason@oracle.com>
Subject: New data=ordered code pushed out to btrfs-unstable
Date: Fri, 18 Jul 2008 12:36:32 -0400
Message-ID: <1216398992.6932.36.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

It took me much longer to chase down races in my new data=ordered code,
but I think I've finally got it, and have pushed it out to the unstable
trees.

There are no disk format changes included.  I need to make minor mods to
the resizing and balancing code, but I wanted to get this stuff out the
door.

In general, I'll call data=ordered any system that prevents seeing stale
data on the disk after a crash.  This would include null bytes from
areas not yet written when we crashed and the contents of old blocks the
filesystem had freed in the past.

The old data=ordered code worked something like this:

file_write: 
	* modify pages in page cache
	* set delayed allocation bits
	* Update in memory and on-disk i_size

writepage:
	* collect a large delalloc region
	* allocate new extent
	* drop existing extents from the metadata
	* insert new extent
	* start the page io

transaction commit:
	* write and wait on any dirty file data to finish
	* commit the new btree pointers

The end result was very large latencies during transaction commit
because it had to wait on all the file data.  A fsync of a single file
was forced to write out all the dirty metadata and dirty data on the FS.
This is how ext3 works today, xfs does something smarter.  ext4 is
moving to something similar to xfs.

With the new code, metadata is not modified in the btree until new
extents are fully on disk.  It now looks something like this:

file write (start, len):
	* wait on pending ordered extents for the start, len range
	* modify pages in the page cache
	* set delayed allocation bits
	* Update in memory only i_size

writepage:
	* collect a large delalloc extent
	* reserve a extent on disk in the allocation tree
	* create an ordered extent record
	* start the page io

At IO completion (done in a kthread):
	* find the corresponding ordered extent record
	* if fully written, remove old extents from the tree,
	  add new extents to the tree, update on disk i_size
	
At commit time:
	* Just do only metadata IO

The end result of all of this is lower commit latencies and a smoother
system.

-chris


