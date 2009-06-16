From: Chris Mason <chris.mason@oracle.com>
Subject: Btrfs rescue images
Date: Mon, 15 Jun 2009 20:53:19 -0400
Message-ID: <20090616005319.GA3735@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

As Linus discovered, the new btrfs disk format in 2.6.31-git can be
problematic if your FS gets forward rolled to the new format and you end
up bisecting back to the old code.

It would also be nice to have a way to run btrfsck on a root filesystem
and do other assorted tasks.  So, I'm making live boot usb images for
both x86 and x86-64.

They should have enough to get your filesystems mounted and they also
include git, gcc, make and enough to compile the kernel.  These are
based on the Arch 2.6.30 distro with just the btrfs newformat code
added.

I've got the 32 bit image uploaded, and I'll queue up 64 bit overnight.
If anyone is feeling brave, just dd the image onto a usb stick and
rescue boot away.

They work on both of my test boxes, but a little extra testing would be
nice.

-chris

