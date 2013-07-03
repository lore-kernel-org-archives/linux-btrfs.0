Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54910 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab3GCOAb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 10:00:31 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r63DODNs003961
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 21:24:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 00/12] Btrfs-progs: introduce chunk recover function
Date: Wed, 3 Jul 2013 21:25:08 +0800
Message-Id: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset introduced chunk recover function, which was implemented by
scanning the whoel disks in the filesystem. Now, we can recover Single,
Dup, RAID1 chunks, and RAID0, RAID10, RAID5, RAID6 metadata chunks.

Miao Xie (11):
  Btrfs-progs: don't close the file descriptor 0 when closing a device
  Btrfs-progs: Don't free the devices when close the ctree
  Btrfs-progs: cleanup similar code in open_ctree_* and close_ctree
  Btrfs-progs: introduce common insert/search/delete functions for rb-tree
  Btrfs-progs: use rb-tree instead of extent cache tree for fs/file roots
  Btrfs-progs: extend the extent cache for the device extent
  Btrfs-progs: Add block group check funtion
  Btrfs-progs: Add chunk recover function - using old chunk items
  Btrfs-progs: introduce list_{first, next}_entry/list_splice_tail{_init}
  Btrfs-progs: Add chunk rebuild function for RAID1/SINGLE/DUP
  Btrfs-progs: recover raid0/raid10/raid5/raid6 metadata chunk

Wang Shilong (1):
  Btrfs-progs: fix missing recow roots when making btrfs filesystem

 Makefile          |    4 +-
 btrfs-find-root.c |  155 +----
 btrfs-list.c      |   19 +-
 btrfs.c           |    1 +
 btrfsck.h         |  183 ++++++
 cmds-check.c      |  810 +++++++++++++++++++----
 cmds-chunk.c      | 1837 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 commands.h        |    2 +
 ctree.h           |    4 +-
 disk-io.c         |  581 +++++++++--------
 disk-io.h         |   15 +-
 extent-cache.c    |  262 +++++---
 extent-cache.h    |   46 +-
 extent-tree.c     |    6 -
 extent_io.c       |   64 +-
 extent_io.h       |    6 +
 list.h            |   68 +-
 mkfs.c            |   56 +-
 rbtree.c          |   63 ++
 rbtree.h          |   24 +-
 repair.c          |    2 +-
 volumes.c         |   69 +-
 volumes.h         |    9 +-
 23 files changed, 3547 insertions(+), 739 deletions(-)
 create mode 100644 btrfsck.h
 create mode 100644 cmds-chunk.c

-- 
1.8.1.4

