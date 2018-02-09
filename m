Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36461 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbeBIHog (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 9 Feb 2018 02:44:36 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2 00/10] Chunk allocator unification
Date: Fri,  9 Feb 2018 15:44:17 +0800
Message-Id: <20180209074428.29187-1-wqu@suse.com>
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

This update only modifies patches 7 and after.

Changelog:
v2:
  Make error handler in patch 7 better.
  New patches to unify more functions used in btrfs_alloc_chunk()

Qu Wenruo (10):
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
  btrfs-progs: Move chunk stripe size calcution function to volumes.h
  btrfs-progs: Use btrfs_device->fs_info to replace
    btrfs_device->dev_root
  btrfs-progs: Refactor btrfs_alloc_chunk to mimic kernel structure and
    behavior

 Makefile          |   3 +-
 check/main.c      |  22 --
 convert/main.c    |  10 +-
 ctree.h           |  12 +-
 extent-tree.c     |  12 +-
 kerncompat.h      |   5 +
 kernel-lib/sort.c | 104 ++++++
 kernel-lib/sort.h |  16 +
 mkfs/main.c       |  27 +-
 utils.c           |   2 +-
 volumes.c         | 927 ++++++++++++++++++++++++++++--------------------------
 volumes.h         |  66 +++-
 12 files changed, 695 insertions(+), 511 deletions(-)
 create mode 100644 kernel-lib/sort.c
 create mode 100644 kernel-lib/sort.h

-- 
2.16.1

