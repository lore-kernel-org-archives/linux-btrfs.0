Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42633 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbeIGMTQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 08:19:16 -0400
Received: by mail-pf1-f193.google.com with SMTP id l9-v6so6602143pff.9
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 00:39:37 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, linux-mm@kvack.org
Subject: [PATCH v6 0/6] Btrfs: implement swap file support
Date: Fri,  7 Sep 2018 00:39:14 -0700
Message-Id: <cover.1536305017.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi,

This series implements swap file support for Btrfs.

Compared to v5 [1], this is pretty much feature-complete. It now
supports:

- Balance (skips block groups containing an active swap file)
- Resize (error if trying to shrink past a block group containing an
  active swap file, allowed otherwise)
- Device delete/replace (as long as the device in question does not
  contain an active swap file)

This implementation Chris and I came up with is much cleaner than my
earlier ideas: instead of adding any counters to struct
btrfs_block_group_cache or struct btrfs_device, we just have a small
red-black tree of block groups and devices which contain an active
swapfile.

I updated the xfstests for this series [2] to test this new
functionality, and put it through the same tests as v5.

Based on v4.19-rc2, please take a look.

Thanks!

1: https://www.spinics.net/lists/linux-btrfs/msg81550.html
2: https://github.com/osandov/xfstests/tree/btrfs-swap

Omar Sandoval (6):
  mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
  mm: export add_swap_extent()
  vfs: update swap_{,de}activate documentation
  Btrfs: prevent ioctls from interfering with a swap file
  Btrfs: rename get_chunk_map() and make it non-static
  Btrfs: support swap files

 Documentation/filesystems/Locking |  17 +-
 Documentation/filesystems/vfs.txt |  12 +-
 fs/btrfs/ctree.h                  |  24 +++
 fs/btrfs/dev-replace.c            |   8 +
 fs/btrfs/disk-io.c                |   4 +
 fs/btrfs/inode.c                  | 316 ++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.c                  |  31 ++-
 fs/btrfs/relocation.c             |  18 +-
 fs/btrfs/volumes.c                |  71 +++++--
 fs/btrfs/volumes.h                |   9 +
 include/linux/swap.h              |  13 +-
 mm/page_io.c                      |   6 +-
 mm/swapfile.c                     |  14 +-
 13 files changed, 492 insertions(+), 51 deletions(-)

-- 
2.18.0
