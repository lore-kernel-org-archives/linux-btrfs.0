From: Chris Mason <chris.mason@oracle.com>
Subject: New ioctl API pushed out
Date: Fri, 16 Jan 2009 12:38:59 -0500
Message-ID: <1232127539.21473.64.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I had said that a revision of the ioctl API wouldn't be required and
that I'd maintain compatibility even for my simple ioctl calls now.

But, Ryusuke Konishi noticed that I didn't align the ioctl argument
properly and that it was actually different sizes on 32 bit and 64 bit
compiles.

In general, the kernel has a compat ioctl facility to deal with this,
letting us use different code to deal with a 32 bit executable run on 64
bit machines.

But, it is a lot of cruft to carry around for a structure that is 1 byte
off.  I think it is better for the project if I just change the arg now
and release v0.18 of btrfs-progs

I've asked Linus to pull these ioctl changes, and so v2.6.29-rc2 will
require v0.18 of btrfs-progs for the ioctl commands.

The disk format has not changed.  Any filesystems created by v0.17 and
2.6.29-rc1 will still be usable.  The commands to scan devices, add,
remove and balance volumes use these ioctls.  You will need to update
your btrfs-progs if you plan on using those commands in 2.6.29-rc2

Sorry for the trouble on this one, I really should have caught this
simple error.

-chris


