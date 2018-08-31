Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42628 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbeIACqX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 22:46:23 -0400
Received: by mail-pf1-f193.google.com with SMTP id l9-v6so6114922pff.9
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 15:36:48 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v5 0/6] Btrfs: implement swap file support
Date: Fri, 31 Aug 2018 15:36:35 -0700
Message-Id: <cover.1535754957.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi,

This series implements swap file support for Btrfs.

Changes since v4 [1]:

- Added a kernel doc for btrfs_get_chunk_map()
- Got rid of "Btrfs: push EXCL_OP set into btrfs_rm_device()"
- Made activate error messages more clear and consistent
- Changed clear vs unlock order in activate error case
- Added "mm: export add_swap_extent()" as a separate patch
- Added a btrfs_wait_ordered_range() at the beginning of
  btrfs_swap_activate() to catch newly created files
- Added some Reviewed-bys from Nikolay

I took a stab at adding support for balance when a swap file is active,
but it's a major pain: we need to mark block groups which contain swap
file extents, check the block group counter in relocate/scrub, then
unmark the block groups when the swap file is deactivated, which gets
really messy because the file can grow while it is an active swap file.
If this is a deal breaker, I can work something out, but I don't think
it's worth the trouble.

This was tested with the swap tests in xfstests plus my new tests here
[2]. Additionally, I used my swapme test program [3] and ran a few
memory-intensive workloads (e.g., a highly parallel kernel build),
verifying that swap was being used. All of this was done with lockdep
enabled.

This series is based on v4.19-rc1. Please take a look.

Thanks!

1: https://www.spinics.net/lists/linux-btrfs/msg78731.html
2: https://github.com/osandov/xfstests/tree/btrfs-swap
3: https://github.com/osandov/osandov-linux/blob/master/scripts/swapme.c

Omar Sandoval (6):
  mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
  mm: export add_swap_extent()
  vfs: update swap_{,de}activate documentation
  Btrfs: prevent ioctls from interfering with a swap file
  Btrfs: rename get_chunk_map() and make it non-static
  Btrfs: support swap files

 Documentation/filesystems/Locking |  17 +--
 Documentation/filesystems/vfs.txt |  12 +-
 fs/btrfs/ctree.h                  |   6 +
 fs/btrfs/disk-io.c                |   3 +
 fs/btrfs/inode.c                  | 232 ++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.c                  |  51 ++++++-
 fs/btrfs/volumes.c                |  28 ++--
 fs/btrfs/volumes.h                |   9 ++
 include/linux/swap.h              |  13 +-
 mm/page_io.c                      |   6 +-
 mm/swapfile.c                     |  14 +-
 11 files changed, 348 insertions(+), 43 deletions(-)

-- 
2.18.0
