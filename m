Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58963 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751370AbbBDHTb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 02:19:31 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t147IBLK020216
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Feb 2015 15:18:11 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/7] Allow btrfsck to reset csum of all tree blocks, AKA dangerous mode.
Date: Wed, 4 Feb 2015 15:16:44 +0800
Message-ID: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs's metadata csum is a good mechanism, keeping bit error away from
sensitive kernel. But such mechanism will also be too sensitive, like
bit error in csum bytes or low all zero bits in nodeptr.
It's a trade using "error tolerance" for stable, and is reasonable for
most cases since there is DUP/RAID1/5/6/10 duplication level.

But in some case, whatever for development purpose or despair user who
can't tolerant all his/her inline data lost, or even crazy QA team
hoping btrfs can survive heavy random bits bombing, there are some guys
want to get rid of the csum protection and face the crucial raw data no
matter what disaster may happen.

So, introduce the new '--dangerous' (or "destruction"/"debug" if you like)
option for btrfsck to reset all csum of tree blocks.

The csum reseting have the following features:
1) Top to down level by level
The csum resetting is done from tree to level 1, and only when all the
csum of nodes in this level is reset and can pass read_tree_block()
check, it will continue to next level.
And all bytenr in nodeptr will be re-aligned, so bit error in the low 12
bits(4K sector size case) can also be repaired without pain.
With this behavior, error in nodeptr has a chance not affecting its
child.

2) No Copy-on-write
COW means we needs to have a valid extent tree, if extent tree is
corrupted COW will only be a BUG_ON blocking us.
So all the r/w in this dangerous mode will use no-cow write. That's why
we export and slightly modified write_tree_block() to do no-cow tree
block write with newly calculated csum.
Since the write is not cowed, if it fails, it will also destroy the last
hope for manual inspection.

Qu Wenruo (7):
  btrfs-progs: Add btrfs_(prev/next)_tree_block() to keep search result
    in     the same level of path->lowest_level.
  btrfs-progs: Introduce btrfs_next_slot() function to iterate to next  
      slot in given level.
  btrfs-progs: Allow btrfs_read_fs_root() to re-read the tree node.
  btrfs-progs: Export write_tree_block() and allow it to do nocow write.
  btrfs-progs: Introduce new function reset_tree_block_csum() for later 
       tree block csum reset.
  btrfs-progs: Introduce new function reset_(one_root/roots)_csum() to  
      reset one/all tree's csum in tree root.
  btrfs-progs: Introduce "--dangerous" option to reset all tree block   
     csum.

 cmds-check.c | 284 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 ctree.c      |  18 ++--
 ctree.h      |  25 +++++-
 disk-io.c    |  55 +++++++++---
 disk-io.h    |   3 +
 5 files changed, 359 insertions(+), 26 deletions(-)

-- 
2.2.2

