Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4818 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752558AbaLDCys (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Dec 2014 21:54:48 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB42sQIk003322
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Dec 2014 10:54:26 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/3] Add repair function for btree and missing inode
Date: Thu, 4 Dec 2014 10:52:42 +0800
Message-ID: <1417661565-14595-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a leaf/node is corrupted in fs root, btrfsck will only complain
like "Check tree block failed, wanted=XXX, have=XXX" and skip wrong
leaf.
Such case will cause a lot of err, one of these err will mainly be
I_ERR_NO_INODE_ITEM.

This patchset will info user which leaf of the tree is corrupted and try
it best to recovery the missing inode.
Although this is just a basis for the large use case of
corrupted-leaf/node repair, it is already working if the corrupted leaf
contains no extent data, not to mention the normal inode_item missing
case.

TODO: 
1. Cooperate with extent tree check/recover
   Current extent tree check will not record EXTENT_DATA extents, which
   can be used to improve the inode type recovery.

   Also extent tree repair can't handle EXTENT_DATA extents if the key
   can't be find and cause btrfsck exit.

   Need to cooperate with it to handle leaf recover better.

2. Add file extent recovery function
   In some case, even we recover the inode item, its file extents can
   still discount.
   To provide a fully repair making it pass btrfsck, we still need to
   repair such case.

3. Enhance inode_record
   Need a better inode_record to provide search function about
   inode_ref/dir_index/dir_item for given parent or child inode number,
   to help inode type detection and extent<->inode relation mapping for
   EXTENT_DATA.

Qu Wenruo (3):
  btrfs-progs: record and report leaf/node corruption in fs/subvol tree
  btrfs-progs:fsck: Recover btree with some corrupted leaf/node.
  btrfs-progs: Add inode item rebuild function.

 cmds-check.c | 328 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 ctree.c      |   3 +
 ctree.h      |   3 +
 inode.c      |   6 +-
 4 files changed, 323 insertions(+), 17 deletions(-)

-- 
2.1.3

