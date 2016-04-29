Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19142 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbcD2HUB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 03:20:01 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: jbacik@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH RFC v2 00/16] Introduce low memory usage btrfsck mode
Date: Fri, 29 Apr 2016 15:18:54 +0800
Message-Id: <1461914350-19875-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The branch can be fetched from my github:
https://github.com/adam900710/btrfs-progs.git low_mem_fsck_rebasing

Original btrfsck checks extent tree in a very efficient method, by
recording every checked extent in extent record tree to ensure every
extent will be iterated for at most 2 times.

However extent records are all stored in heap memory, and consider how
large a btrfs file system can be, it can easily eat up all memory and
cause OOM for TB-sized metadata.

Instead of such heap memory usage, we introduce low memory usage fsck
mode.

In this mode, we will use btrfs_search_slot() only and avoid any heap
memory allocation.

The work flow is:
1) Iterate extent tree
   And check whether the referencer of every backref exists.

2) Iterate other trees
   And check whether the backref of every tree block/data exists in
   extent tree.

So in theory, every extent is iterated twice.
But since we don't have extent record, but use btrfs_search_slot() every
time we check, it may cause extra IO.

I assume the extra IO is reasonable and would make btrfsck able to
handle super large fs.

TODO features:
1) Repair
   Repair should be the same as old btrfsck, but still need to determine
   the repair principle.
   Current repair sometimes uses backref to repair data extent,
   sometimes uses data extent to fix backref.
   We need a consistent principle, or we will screw things up.

2) Replace current fsck code
   We assume the low memory mode has less lines of code, and may be
   easier for review and expand.

   If low memory mode is stable enough, we will consider to replace
   current extent and chunk tree check codes to free a lot of lines.

3) Fs tree check code
   Fs tree check also eats a lot of memory.
   Fixing extent tree check is not a final solution, fs check also needs
   such rework.

Changelog:
  v1.1:
    Fix a typo which makes keyed data backref check always fail
  v2:
    Don't return minus value with error bits. (Suggested by Josef)
    Follow kernel code styling. (Suggested by Josef)
    Enhance check on data backref count. (Slow down check speed though)

Lu Fengqi (16):
  btrfs-progs: fsck: Introduce function to check tree block backref in
    extent tree
  btrfs-progs: fsck: Introduce function to check data backref in extent
    tree
  btrfs-progs: fsck: Introduce function to query tree block level
  btrfs-progs: fsck: Introduce function to check referencer of a backref
  btrfs-progs: fsck: Introduce function to check shared block ref
  btrfs-progs: fsck: Introduce function to check referencer for data
    backref
  btrfs-progs: fsck: Introduce function to check shared data backref
  btrfs-progs: fsck: Introduce function to check an extent
  btrfs-progs: fsck: Introduce function to check dev extent item
  btrfs-progs: fsck: Introduce function to check dev used space
  btrfs-progs: fsck: Introduce function to check block group item
  btrfs-progs: fsck: Introduce function to check chunk item
  btrfs-progs: fsck: Introduce hub function for later fsck
  btrfs-progs: fsck: Introduce function to speed up fs tree check
  btrfs-progs: fsck: Introduce traversal function for fsck
  btrfs-progs: fsck: Introduce low memory mode

 Documentation/btrfs-check.asciidoc |    2 +
 cmds-check.c                       | 1748 +++++++++++++++++++++++++++++++++---
 ctree.h                            |    2 +
 extent-tree.c                      |    2 +-
 4 files changed, 1611 insertions(+), 143 deletions(-)

-- 
2.8.0



