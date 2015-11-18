Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62127 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751513AbbKRHYh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:37 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoRt007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:23:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 00/22] Btrfs-convert rework part 1
Date: Wed, 18 Nov 2015 15:22:00 +0800
Message-Id: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here comes the first RFC version of btrfs-convert rework.
Any test is welcomed, and it can already pass the convert test from
btrfs-progs. (Since the test doesn't test rollback function)

The new btrfs-convert has the following bugfix/feature:
1. True separate meta/data chunk
   The converted filesystem will has correct chunk layout, and all ext*
   data will be covered by data chunk and metadata will be covered by
   metadata chunk.
   Allowing converted filesystem to pass latest btrfs check.

2. Structurized make_btrfs_v2()
   Unlike old make_btrfs() which is a mess of hand written codes, new
   make_btrfs_v2() is all structurized and should be easy for later
   expansion.

But it still has something to do:
1) No rollback implement yet
   The implement should be quite easy, but I hope we can check the
   convert patches as soon as possible.

2) No cleanup yet
   I didn't clean up the duplicated codes and unneeded codes yet.

3) Ability to handle TB level filesystem.
   Current implement rely on the initial system chunk to contain all
   chunks until we inserted all data chunks.
   However the initial system chunk are only 32M, in simple calculation,
   it can only hold at most 400K chunks.
   If every chunk is in the smallest size (16M), it can only handle
   less than 6T size in its worst case.
   Better calculate the initial system chunk size according to the
   filesystem size

4) Ability to create DUP metadata chunk without using balance
   Now the data and metadata chunk are all in SINGLE profile.
   User needs to convert metadata to DUP if they want DUP metadata
   profile.

   This is a little hard, as we must do it at make_btrfs() time, where
   we don't have full btrfs facilities to modify the metadata tree.

   This may need another rework on functions like btrfs_search_slot() to
   support temporary btrfs image without btrfs_root structure.

The new btrfs-convert will work like the following:

1) Scan ext2 for all used space

2) Calculate the following tree maps:
   convert_data_chunks:
     Ranges must be covered by data chunks
     Maps are batched to avoid small chunk and avoid reserved ranges
     like the first 1MB of the device and superblock space.
   free_space:
     Ranges that later allocation can allocate from
     With reserved ranges wiped.

3) Reserved space for superblock and system/metadata chunks
   Use free_space above to reserve space

4) Make a temporary btrfs, using above super/system/metadata position
   This is done by the new make_btrfs_v2() function.

5) Open temporary btrfs

6) Insert all data chunks to cover all ext* data

7) Create ext2_save subvolume and image
   Unlike old implement, which did this later, we do this first, as this
   method can reduce the extent fragments, reducing extent tree size.

   And this also calculate all the csum if needed, making later inode
   copy free from calculating csum.

8) Handle reserved ranges
   Copy ext* data in reserved ranges into other places.
   Now the hole ext2_save subvolume and image is created.

9) Copy inodes
   Inode copy will use the ext2_save image as new logical <-> disk
   mapping, to handle reserved ranges.

And yes, these patchset is already huge enough, but considering the
cleanup patches are not here yet, the net line of changes should be
under zero.

Qu Wenruo (22):
  btrfs-progs: extent-cache: Add comments for search/lookup functions
  btrfs-progs: extent-tree: Add add_merge_cache_extent function
  btrfs-progs: Add new init/free function and member for mkfs_config
  btrfs-progs: convert: Read and build up used space tree
  btrfs-progs: utils: Introduce new function to remove reserved ranges
  btrfs-progs: utils: Introduce function to calculate the available
    space
  btrfs-progs: Reserve space for system/meta chunks and superblock
  btrfs-progs: Introduce function to setup temporary superblock
  btrfs-progs: Introduce function to setup temporary tree root
  btrfs-progs: Introduce function to setup temporary chunk root
  btrfs-progs: Introduce function to initialize device tree
  btrfs-progs: Introduce function to initialize fs tree
  btrfs-progs: Introduce function to initialize csum tree
  btrfs-progs: Introduce function to setup temporary extent tree
  btrfs-progs: Introduce function to create convert data chunks
  btrfs-progs: extent-tree: Introduce function to find the first overlap
    extent.
  btrfs-progs: extent-tree: Enhance btrfs_record_file_extent
  btrfs-progs: convert: Introduce new function to create ext2 image
  btrfs-progs: convert: Introduce function to migrate reserved ranges
  btrfs-progs: Enhance record_file_blocks to handle reserved ranges
  btrfs-progs: convert: Introduce init_btrfs_v2 function.
  btrfs-progs: Introduce do_convert_v2 function

 btrfs-convert.c |  787 +++++++++++++++++++++++++++++++++++++++++-
 ctree.c         |   24 ++
 ctree.h         |    3 +
 extent-cache.c  |   57 ++++
 extent-cache.h  |   39 +++
 extent-tree.c   |  217 +++++++++---
 mkfs.c          |    4 +-
 utils.c         | 1013 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h         |   45 +++
 volumes.c       |   46 ++-
 volumes.h       |    2 +-
 11 files changed, 2165 insertions(+), 72 deletions(-)

-- 
2.6.2

