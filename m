From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH 0/4] Add readonly support to replace BUG_ON phrase
Date: Thu, 25 Nov 2010 17:52:47 +0800
Message-ID: <4CEE31EF.1020102@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs has a number of BUG_ON()s, which may lead btrfs to unpleasant panic.
Meanwhile, they are very ugly and should be handled more propriately.

There are mainly two ways to deal with these BUG_ON()s.

1. For those errors which can be handled well by callers, we just return their
error number to callers.

2. For others, We can force the filesystem readonly when it hits errors, which
 is what this patchset has done. Replaced BUG_ON() with the interface provided
 in this patchset, we will get error infomation via dmesg. Since btrfs is now 
readonly, we can save our data safely and umount it, then a btrfsck is 
recommended.

By these ways, we can protect our filesystem from panic caused by those 
BUG_ONs.

---
 fs/btrfs/ctree.h       |   21 ++++++++++
 fs/btrfs/disk-io.c     |   23 +++++++++++
 fs/btrfs/super.c       |  100 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/transaction.c |    7 +++
 4 files changed, 148 insertions(+), 3 deletions(-)

