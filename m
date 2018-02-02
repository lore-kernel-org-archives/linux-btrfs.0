Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:58681 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbeBBITm (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 2 Feb 2018 03:19:42 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 0/7] Chunk allocator unification
Date: Fri,  2 Feb 2018 16:19:22 +0800
Message-Id: <20180202081929.15162-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/libbtrfs_prepare

This patchset unified a large part of chunk allocator (free device
extent search) between kernel and btrfs-progs.

Although there are still differences in the following areas, the goal of
extract common code into libbtrfs is in the reach.

1) Member differences
   Btrfs-progs lacks quite some members of kernel, so something like
   fs_devices->total_rw_bytes still makes difference.

2) @convert parameter for mkfs/convert
   It should be able to extract them into a simpler function.

3) delayed bg creations vs direct bg creation
   Kernel delays block group creation while btrfs-progs directly
   allocates block group.
   This makes kernel __btrfs_alloc_chunk() more or less chunk mapping
   allocation only, while btrfs-progs handles extra chunk, dev extent
   and block group item creation.

   This needs extra function refactor before we really extra code into
   libbtrfs.

Despite the preparation for later libbtrfs, this rework still has some
benefit:

1) No minimal stripe/chunk size
   Unlike the intermediate minimal stripe/chunk size in btrfs-progs,
   kernel doesn't really implement a minimal stripe/chunk size.

   So now we don't have such limit in btrfs-progs side now.
   Although the minimal device size calculation doesn't make any harm so
   it's still kept as is.

2) Slightly less code for chunk allocator
   Just about -60 lines in the last patch.


Qu Wenruo (7):
  btrfs-progs: Refactor parameter of BTRFS_MAX_DEVS() from root to
    fs_info
  btrfs-progs: Merge btrfs_alloc_data_chunk into btrfs_alloc_chunk
  btrfs-progs: Make btrfs_alloc_chunk to handle block group creation
  btrfs-progs: Introduce btrfs_raid_array and related infrastructures
  btrfs-progs: volumes: Allow find_free_dev_extent() to return maximum
    hole size
  btrfs-progs: kernel-lib: Port kernel sort() to btrfs-progs
  btrfs-progs: volumes: Unify free dev extent search behavior between
    kernel and btrfs-progs.

 Makefile          |   3 +-
 convert/main.c    |  10 +-
 ctree.h           |  12 +-
 extent-tree.c     |  12 +-
 kerncompat.h      |   5 +
 kernel-lib/sort.c | 104 +++++++
 kernel-lib/sort.h |  16 ++
 mkfs/main.c       |  27 +-
 volumes.c         | 838 +++++++++++++++++++++++++-----------------------------
 volumes.h         |  42 ++-
 10 files changed, 578 insertions(+), 491 deletions(-)
 create mode 100644 kernel-lib/sort.c
 create mode 100644 kernel-lib/sort.h

-- 
2.16.1

