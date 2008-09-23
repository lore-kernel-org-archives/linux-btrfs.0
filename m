From: Chris Mason <chris.mason@oracle.com>
Subject: New disk format in -unstable
Date: Tue, 23 Sep 2008 13:21:00 -0400
Message-ID: <1222190460.7160.147.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've pushed both Yan Zheng's backref patch and Josef Bacik's allocator
changes.  This is a huge amount of work from both of them, and I wanted
to push them out as quickly as possible so they could avoid having to
rediff them.

Josef's work gives us a more efficient allocator, which is also better
able to find free extents of a given size.  It does a better job of
keeping metadata more dense in the block groups, making for a much
faster fsck.

Yan Zheng's patch makes the btree block back references more precise.
Before they only referenced a tree and a rough key where you could find
the reference to a block, and now they reference the exact parent node.
This makes for much less complex space balancing code between devices,
and more orderly failure recovery when things go horribly wrong.

Between the fsync work and these two patches, the unstable tree is a bit
more unstable than usual.  We'll hammer out any problems this week.

-chris


