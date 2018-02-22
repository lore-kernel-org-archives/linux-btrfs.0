Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:60937 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752399AbeBVGro (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 22 Feb 2018 01:47:44 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v3 0/9] Chunk allocator unification
Date: Thu, 22 Feb 2018 14:47:24 +0800
Message-Id: <20180222064733.12126-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/libbtrfs_prepare

This patchset unified a large part of chunk allocator (free device
extent search) between kernel and btrfs-progs.
And reuses kernel function structures like btrfs_finish_chunk_alloc()
and btrfs_alloc_dev_extent().

Before the unification:
               Kernel                |              Btrfs-progs
 btrfs_alloc_chunk()                 | btrfs_alloc_chunk()
 |- __btrfs_alloc_chunk()            | |- Do all the work
                                     |
 btrfs_create_pending_block_groups() |
 |- btrfs_insert_item()              |
 |- btrfs_finish_chunk_alloc()       |
    |- btrfs_alloc_dev_extent()      |

After the unification:
               Kernel                |              Btrfs-progs
 btrfs_alloc_chunk()                 | btrfs_alloc_chunk()
 |- __btrfs_alloc_chunk()            | |- __btrfs_alloc_chunk()
                                     | |- btrfs_finish_chunk_alloc()
 btrfs_create_pending_block_groups() |    |- btrfs_alloc_dev_extent()
 |- btrfs_insert_item()              |
 |- btrfs_finish_chunk_alloc()       |

And the similiar functions are share the same code base, with minor
member/functions change.

Changelog:
v2:
  Make error handler in patch 7 better.
  New patches to unify more functions used in btrfs_alloc_chunk()

v3:
  Use standard library function qsort() to replace the kernel sort(),
  suggested by David.

Qu Wenruo (9):
  btrfs-progs: Refactor parameter of BTRFS_MAX_DEVS() from root to
    fs_info
  btrfs-progs: Merge btrfs_alloc_data_chunk into btrfs_alloc_chunk
  btrfs-progs: Make btrfs_alloc_chunk to handle block group creation
  btrfs-progs: Introduce btrfs_raid_array and related infrastructures
  btrfs-progs: volumes: Allow find_free_dev_extent() to return maximum
    hole size
  btrfs-progs: volumes: Unify free dev extent search behavior between
    kernel and btrfs-progs.
  btrfs-progs: Move chunk stripe size calcution function to volumes.h
  btrfs-progs: Use btrfs_device->fs_info to replace
    btrfs_device->dev_root
  btrfs-progs: Refactor btrfs_alloc_chunk to mimic kernel structure and
    behavior

 check/main.c   |  22 --
 convert/main.c |  10 +-
 ctree.h        |  12 +-
 extent-tree.c  |  12 +-
 kerncompat.h   |   5 +
 mkfs/main.c    |  27 +-
 utils.c        |   2 +-
 volumes.c      | 926 ++++++++++++++++++++++++++++++---------------------------
 volumes.h      |  66 +++-
 9 files changed, 572 insertions(+), 510 deletions(-)

-- 
2.16.2

