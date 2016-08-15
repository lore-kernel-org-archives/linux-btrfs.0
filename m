Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19334 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752170AbcHOChG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Aug 2016 22:37:06 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <rgoldwyn@suse.de>, <fdmanana@gmail.com>
Subject: [PATCH v3.1 0/3] Qgroup fix for dirty hack routines
Date: Mon, 15 Aug 2016 10:36:49 +0800
Message-ID: <20160815023652.5348-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset contains fixes for REGRESSION introduced in 4.2.

This patchset introduce 2 fixes for data extent owner hacks.

One can be triggered by balance, another one can be trigged by log replay
after power loss.

Root cause are all similar: EXTENT_DATA owner is changed by dirty
hacks, from swapping tree blocks containing EXTENT_DATA to manually
update extent backref without using inc/dec_extent_ref.

The first patch introduces needed functions, then 2 fixes.

The reproducers have already been merged into xfstests, btrfs/123 and
btrfs/119.

Changelog:
v2:
  Update 2nd patch to handle cases where the whole subtree, not only
  level 2 nodes get updated.
v3:
  Function name update. Thanks Goldwyn.
  Rename 'btrfs_qgroup_insert_dirty_extent()' to
  'btrfs_qgroup_insert_dirty_extent_nolock()'
  Rename 'btrfs_qgroup_record_dirty_extent()' to
  'btrfs_qgroup_insert_dirty_extent()'
v3.1:
  Update commit message for 2nd patch, to identify itself as a regression
  fix patch, suggested by Filipe.
  Removed commented out debug command of 2nd patch.
  Update Tested-by and Reviewed-by tags from Goldwyn.

Qu Wenruo (3):
  btrfs: qgroup: Refactor btrfs_qgroup_insert_dirty_extent()
  btrfs: relocation: Fix leaking qgroups numbers on data extents
  btrfs: qgroup: Fix qgroup incorrectness caused by log replay

 fs/btrfs/delayed-ref.c |   7 +---
 fs/btrfs/extent-tree.c |  37 +++--------------
 fs/btrfs/qgroup.c      |  41 ++++++++++++++++---
 fs/btrfs/qgroup.h      |  33 +++++++++++++--
 fs/btrfs/relocation.c  | 109 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/tree-log.c    |  16 ++++++++
 6 files changed, 190 insertions(+), 53 deletions(-)

-- 
2.9.2



