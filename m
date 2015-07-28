Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33339 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753927AbbG1Ic4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 04:32:56 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6S8V1gv019630
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2015 16:31:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 00/14] Yet Another In-band(online) deduplication implement
Date: Tue, 28 Jul 2015 16:30:36 +0800
Message-ID: <1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although Liu Bo has already submitted a V10 version of his deduplication
implement, here is another implement for it.

[[CORE FEATURES]]
The main design concept is the following:
1) Controllable memory usage
2) No guarantee to dedup every duplication.
3) No on-disk format change or new format
4) Page size level deduplication

[[IMPLEMENT]]
Implement details includes the following:
1) LRU hash maps to limit the memory usage
   The hash -> extent mapping is control by LRU (or unlimited), to
   get a controllable memory usage (can be tuned by mount option)
   alone with controllable read/write overhead used for hash searching.

2) Reuse existing ordered_extent infrastructure
   For duplicated page, it will still submit a ordered_extent(only one
   page long), to make the full use of all existing infrastructure.
   But only not submit a bio.
   This can reduce the number of code lines.

3) Mount option to control dedup behavior
   Deduplication and its memory usage can be tuned by mount option.
   No need to indicated ioctl interface.
   And further more, it can easily support BTRFS_INODE flag like
   compression, to allow further per file dedup fine tunning.

[[TODO]]
1. Add support for compressed extent
   Shouldn't be quite hard.
2. Try to merge dedup extent to reduce metadata size
   Currently, dedup extent is always in 4K size, although its reference
   source can be quite large.
3. Add support for per file dedup flags
   Much easier, just like compression flags.

[[KNOWN BUG, NEED HELP!]]
On the other hand, since it's still a RFC patch, it must has one or more
problem:
1) Race between __btrfs_free_extent() and dedup ordered_extent.
   The hook in __btrfs_free_extent() will free the corresponding hashes
   of a extent, even there is a dedup ordered_extent referring it.

   The problem will happen like the following case:
======================================================================
   cow_file_range()
     Submit dedup ordered_extent for extent A

   commit_transaction()
     Extent A needs freeing. As the its ref is decreased to 0.
     And dedup ordered_extent can increase only when it hit endio time.

   finish_ordered_io()
     Add reference to Extent A for dedup ordered_extent.
     But it is already freed in previous transaction.
     Causing abort_transaction().
======================================================================
   I'd like to keep the current ordered_extent method, as it adds the
   least number of code lines.
   But I can't find a good idea to either delay transaction until dedup
   ordered_extent is done or things like that.

   Trans->ordered seems to be a good idea, but it seems to cause list
   corruption without extra protection in tree log infrastructure.

That's the only problem spotted yet.
Any early review or advice/question on the design is welcomed.

Thanks.

Qu Wenruo (14):
  btrfs: file-item: Introduce btrfs_setup_file_extent function.
  btrfs: Use btrfs_fill_file_extent to reduce duplicated codes
  btrfs: dedup: Add basic init/free functions for inband dedup.
  btrfs: dedup: Add internal add/remove/search function for btrfs dedup.
  btrfs: dedup: add ordered extent hook for inband dedup
  btrfs: dedup: Apply dedup hook for write time dedup.
  btrfs: extent_map: Add new dedup flag and corresponding hook.
  btrfs: extent-map: Introduce orig_block_start member for extent-map.
  btrfs: dedup: Add inband dedup hook for read extent.
  btrfs: dedup: Introduce btrfs_dedup_free_extent_range function.
  btrfs: dedup: Add hook to free dedup hash at extent free time.
  btrfs: dedup: Add mount option support for btrfs inband deduplication.
  Btrfs: dedup: Support dedup change at remount time.
  btrfs: dedup: Add mount option output for inband dedup.

 fs/btrfs/Makefile       |   2 +-
 fs/btrfs/ctree.h        |  16 ++
 fs/btrfs/dedup.c        | 701 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedup.h        | 132 +++++++++
 fs/btrfs/disk-io.c      |   7 +
 fs/btrfs/extent-tree.c  |  10 +
 fs/btrfs/extent_io.c    |   6 +-
 fs/btrfs/extent_map.h   |   4 +
 fs/btrfs/file-item.c    |  61 +++--
 fs/btrfs/inode.c        | 228 ++++++++++++----
 fs/btrfs/ordered-data.c |  32 ++-
 fs/btrfs/ordered-data.h |   8 +
 fs/btrfs/super.c        |  39 ++-
 13 files changed, 1163 insertions(+), 83 deletions(-)
 create mode 100644 fs/btrfs/dedup.c
 create mode 100644 fs/btrfs/dedup.h

-- 
2.4.6

