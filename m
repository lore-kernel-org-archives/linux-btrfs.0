Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:60906 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbeAEIMY (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 5 Jan 2018 03:12:24 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/2] Preparation for later btrfs_alloc_chunk() rework, Part 2
Date: Fri,  5 Jan 2018 16:12:10 +0800
Message-Id: <20180105081212.27175-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset, along with its prerequisite (patchset named:
"[PATCH 0/5] Cleanups for later btrfs_alloc_chunk() rework") can be
fetched from github:
https://github.com/adam900710/btrfs-progs/tree/chunk_alloc_enospc

This patchset can still be treated as cleanup, but brings a much larger
structure modification of btrfs_alloc_chunk().

The first patch will merge the original btrfs_alloc_data_chunk() with
more generic btrfs_alloc_chunk().

And 2nd patch integrate btrfs_make_block_group() into
btrfs_alloc_chunk(), provides the critical basis for later rework.
(Later rework needs to update space info before any tree modification,
so btrfs_make_block_group must be integrated)

Considering the importance of btrfs_alloc_chunk() in btrfs-progs, these
2 patches are separated out for a longer review window before larger
rework.

Qu Wenruo (2):
  btrfs-progs: Merge btrfs_alloc_data_chunk into btrfs_alloc_chunk
  btrfs-progs: Make btrfs_alloc_chunk to handle block group creation

 convert/main.c |  10 +--
 extent-tree.c  |  12 +---
 mkfs/main.c    |  42 ++---------
 volumes.c      | 222 +++++++++++++++++++++++----------------------------------
 volumes.h      |   5 +-
 5 files changed, 102 insertions(+), 189 deletions(-)

-- 
2.15.1

