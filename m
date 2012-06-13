Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7165 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2FMKL5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 06:11:57 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5DABlK3011738
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 18:11:49 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/4 v2][RFC] apply rwlock for extent state
Date: Wed, 13 Jun 2012 18:19:07 +0800
Message-Id: <1339582751-32029-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset is against one of project ideas, RBtree lock contention:
"Btrfs uses a number of rbtrees to index in-memory data structures.
Some of these are dominated by reads, and the lock contention from searching
them is showing up in profiles.  We need to look into an RCU and sequence
counter combination to allow lockless reads."

The goal is to use RCU, but we take it as a long term one, and instead we use
rwlock until we find a mature rcu structure for lockless read.

So what we need to do is to make the code RCU friendly, and the idea mainly
comes from Chris Mason:
Quoted:
"I think the extent_state code can be much more RCU friendly if we separate
the operations on the tree from operations on the individual state.
In general, we can gain a lot of performance if we are able to reduce
the write locks taken at endio time.  Especially for reads, these are
critical."

The patchset is also available in:
	git://github.com/liubogithub/btrfs-work.git rwlock-for-extent-state



I've run through xfstests, and no bugs jump out by then.

I made a simple test to show the difference on my box:
$ cat 6_FIO/fio-4thread-4M-sync-read
[global]
group_reporting
thread
numjobs=4
bs=4M
rw=read
sync=0
ioengine=sync
directory=/mnt/btrfs/

[READ]
filename=foobar
size=4000M

*results:*
                          w/o patch     w patch
READ bandwidth(aggrb)      849MB/s      971MB/s

MORE TESTS ARE WELCOME!

v1->v2: drop changes on invalidatepage() and rebase to the latest btrfs upstream.

Liu Bo (4):
  Btrfs: use radix tree for checksum
  Btrfs: merge adjacent states as much as possible
  Btrfs: use large extent range for read and its endio
  Btrfs: apply rwlock for extent state

 fs/btrfs/extent_io.c |  712 +++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/extent_io.h |    5 +-
 fs/btrfs/inode.c     |    7 +-
 3 files changed, 568 insertions(+), 156 deletions(-)

