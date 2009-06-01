From: Chris Mason <chris.mason@oracle.com>
Subject: New experimental btrfs branch ready for testing
Date: Mon, 1 Jun 2009 17:04:47 -0400
Message-ID: <20090601210447.GC3890@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Yan Zheng has been doing some major surgery to the back references and
extent allocation code, tackling bottlenecks in the code that tracks
extents.  It scales better with many snapshots and performs better in
the common case of no snapshots at all.

THE NEW CODE IS A FORWARD ROLLING DISK FORMAT CHANGE.  This means it is
compatible with the current btrfs disk format, but once you mount a
filesystem with the new code, it WILL NO LONGER BE MOUNTABLE FROM OLD
KERNELS.  Old kernels spit out an error message when you try them on new
format filesystems.

This is a large change, and I'm hoping to have it stable in time for the
2.6.31 merge window.  I've been testing it for about a week now, and
haven't been able to cause major problems yet.  But, testing the
compatibility with old format filesystems is the hard part, and
everyone that pulls the new code should backup their data first.

I've setup git branches called newformat where you can pull the new code.

For the kernel (based on 2.6.30-rc7):

git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git newformat

For the progs:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git newformat

The main benefit of the new code is that backrefs on the extent
allocation tree use a fuzzier format.  It basically means that we search
for the key in the extent allocation tree instead of providing an exact
backref to the parent block.

This means we can predict how many blocks will be changed when changing
the extent allocation tree, and it makes enospc much less complex.  It
is also significantly faster.

For regular subvolume trees, a similar change is made as long as there
are no snapshots against a given block.  This is the common case, and it
makes COW less expensive overall.

Yan Zheng also worked out a way to free blocks during the transaction
without needing to do an explicit snapshot deletion on the old root when
the transaction was done.  This gets rid of some complex caching code,
and fixes worst-case problems where btrfs could take a very very long
time to unmount.

btrfs-vol -b is faster with the new code as well, he added caching of
high levels in the tree to speed things up.

(Many kudos to Yan Zheng for all of this work!)

-chris

