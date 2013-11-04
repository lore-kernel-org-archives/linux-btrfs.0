Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51952 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab3KDPMh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 10:12:37 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA4FCUOO031733
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 23:12:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/7] Btrfs: improve the latency of the space reservation
Date: Mon, 4 Nov 2013 23:13:19 +0800
Message-Id: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset improve the latency of the space reservation when doing the
delalloc inode flush. As we know, the current code would wait for
the completion all the ordered extents in the filesystem. It was unnecessary,
we can finish the wait and try to do reservation once again earlier if we
get enough free space. It can reduce the wait time and make the perfermance
up.

We did the buffered write test by the sysbench on my box, the following
is the result.
 Memory:	2GB
 CPU:		2Cores * 1CPU
 Partition:	20GB(SSD)
				w/		w/o
 rndwr-512KB-1Thread-2GB	120.38MB/s	110.08MB/s
 rndwr-512KB-8Threads-2GB	119.43MB/s	110.96MB/s
 seqwr-512KB-1Thread-2GB	99.676MB/s	98.53MB/s
 seqwr-512KB-8Threads-2GB	111.79MB/s	99.176MB/s

 rndwr-128KB-1Thread-2GB	139.23MB/s	95.864MB/s
 rndwr-128KB-8Threads-2GB	126.16MB/s	96.686MB/s
 seqwr-128KB-1Thread-2GB	100.24MB/s	100.95.MB/s
 seqwr-128KB-8Threads-2GB	126.51MB/s	100.26MB/s

rndwr: random write test
seqwr: sequential write test
512KB,128KB: the size of each request
1Thread, 8Threads: the number of the test threads
2GB: The total file size

Miao Xie (7):
  Btrfs: remove unnecessary initialization and memory barrior in shrink_delalloc()
  Btrfs: wait for the ordered extent only when we want
  Btrfs: pick up the code for the item number calculation in flush_space()
  Btrfs: fix the confusion between delalloc bytes and metadata bytes
  Btrfs: don't wait for all the async delalloc when shrinking delalloc
  Btrfs: don't wait for the completion of all the ordered extents
  Btrfs: rename btrfs_start_all_delalloc_inodes

 fs/btrfs/ctree.h        |  3 +--
 fs/btrfs/dev-replace.c  |  6 ++---
 fs/btrfs/extent-tree.c  | 62 ++++++++++++++++++++++++++++++++++---------------
 fs/btrfs/inode.c        |  3 +--
 fs/btrfs/ioctl.c        |  2 +-
 fs/btrfs/ordered-data.c | 22 ++++++++++++++----
 fs/btrfs/ordered-data.h |  4 ++--
 fs/btrfs/relocation.c   |  4 ++--
 fs/btrfs/super.c        |  2 +-
 fs/btrfs/transaction.c  |  4 ++--
 10 files changed, 73 insertions(+), 39 deletions(-)

-- 
1.8.1.4

