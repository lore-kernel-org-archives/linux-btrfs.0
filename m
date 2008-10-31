From: Chris Mason <chris.mason@oracle.com>
Subject: Another new disk format pushed to -unstable
Date: Fri, 31 Oct 2008 12:53:23 -0400
Message-ID: <1225472003.10549.26.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

btrfs-unstable now has Yan Zheng's fallocate support, along with disk
format changes.

I was hoping to roll all of this into a single format change with the
compression code, but there was too much conflict between the two
patches.

The fallocate work is pretty neat, it allows preallocation of extents
and overwrites them without triggering COW as long as there are no
snapshots against the extent.

There should be two sets of disk format changes left before I start
trying to avoid them.  One to rework the way snapshots and subvolumes
are pointed to, and one to put in compat bits so future format changes
are all backwards compatible.  This will also include moving the
superblocks around a bit.

-chris


