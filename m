Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1352 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab2GYF7k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 01:59:40 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6P5xWGv005253
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 13:59:35 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/6 v3][RFC] rwlock for extent state
Date: Wed, 25 Jul 2012 13:58:36 +0800
Message-Id: <1343195922-31405-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset is against one of project ideas, RBtree lock contention:
"Btrfs uses a number of rbtrees to index in-memory data structures.
Some of these are dominated by reads, and the lock contention from searching
them is showing up in profiles.  We need to look into an RCU and sequence
counter combination to allow lockless reads."

So the real goal is to use RCU, but we take it as a long term one, instead
we use rwlock until we find a mature rcu structure for lockless read.

So what we need to do is to make the code RCU friendly, and the idea mainly
comes from Chris Mason:
Quoted:
"I think the extent_state code can be much more RCU friendly if we separate
the operations on the tree from operations on the individual state.
In general, we can gain a lot of performance if we are able to reduce
the write locks taken at endio time.  Especially for reads, these are
critical."

In this patch set, at least we now make the endio of readpage a write-lock free
path, so our multi-thread read will benefit from this.

ANY TEST and COMMENTs are welcome!

v2->v3: - fix a deadlock bug on state's lock
        - drop the individual radix tree for checksum to get rid of another lock.

v1->v2: drop changes on invalidatepage() and rebase to the latest btrfs
        upstream.

Liu Bo (6):
  Btrfs: merge adjacent states as much as possible
  Btrfs: add helper function to test if we can merge state
  Btrfs: break clear_state_bit into two parts
  Btrfs: apply rwlock for extent state
  Btrfs: batch merge state in readpage endio
  Btrfs: async helper for state merge

 fs/btrfs/ctree.h     |    1 +
 fs/btrfs/disk-io.c   |    6 +
 fs/btrfs/extent_io.c |  476 +++++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/extent_io.h |    4 +-
 fs/btrfs/super.c     |    1 +
 5 files changed, 423 insertions(+), 65 deletions(-)

