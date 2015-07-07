Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25001 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756505AbbGGIPd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 04:15:33 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 0/7] mkfs: Remove temporary chunks
Date: Tue, 7 Jul 2015 16:15:21 +0800
Message-ID: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mkfs has a long standing problem, which will always create temporary
chunks.

Normally this is OK and do no harms.
But if someone create a btrfs with RAID0 data/metadata, and then mount
it, do a balance (without extra option) immediately, then the data
system chunk profile will magically turns to SINGLE.

The detailed bug and fix can be found at the last patch.

This patchset will fix it in a quick method.
Just remove the temporary chunks at the end of mkfs time.

But IMHO the fix is not elegant nor perfect.
1) Too many codes
   About 500+ lines to fix the problem.
   Although most of them are missing infrastructure to remove things.

2) Causing holes in devices.
   The removed temporary chunks will leave about 18 megabytes holes at
   the beginning of device 1.

TODO:
The perfect solution would be something like below:
0) Create a bones-only in-memory fs_info.
   To allow us use btrfs infrastructure.

1) Check all devices and add them into in-memory structures.
   Maybe fs_info->devices.

2) Create system chunk first
   We now have all devices, can create one perfect system chunk.

3) Create chunk root into the created chunk root.
   Also setup things like avail_alloc_bits.

4) Create the rest of tree root.
   Metadata chunk will be allocated on demand.

5) Create data chunk.
   Even though it would be empty through the whole mkfs.

But the perfect solution needs a lot of code change as the whole
workflow is changed.

So I took current fix even it's not perfect, but most practice one.

Already rebased to David's devel branch.

Qu Wenruo (7):
  btrfs-progs: disk-io: Support commit transaction on chunk tree.
  btrfs-progs: extent-tree: Introduce free_block_group_item function.
  btrfs-progs: extent-tree: Introduce functions to free dev extents in a
    chunk
  btrfs-progs: extent-tree: Introduce functions to free chunk items
  btrfs-progs: extent-tree: Introduce functions to free in-memory block 
       group cache
  btrfs-progs: extent-tree: Introduce btrfs_free_block_group function.
  btrfs-progs: mkfs: Cleanup temporary chunk to avoid strange balance
    behavior.

 ctree.h       |   2 +
 disk-io.c     |   2 +
 extent-tree.c | 376 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs.c        | 150 +++++++++++++++++++++++
 4 files changed, 530 insertions(+)

-- 
2.4.4

