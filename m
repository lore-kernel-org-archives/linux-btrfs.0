Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38611 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbeITKn4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 06:43:56 -0400
Received: by mail-pl1-f195.google.com with SMTP id u11-v6so3718361plq.5
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 22:02:27 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v8 0/6] Btrfs: implement swap file support
Date: Wed, 19 Sep 2018 22:02:11 -0700
Message-Id: <cover.1537419652.git.osandov@fb.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi,

This series implements swap file support for Btrfs.

Changes from v7 [1]:

- Expanded a few commit messages
- Added Johannes' acked-by on patches 1 and 2
- Rebased on v4.19-rc4

No functional changes.

Thanks!

1: https://www.spinics.net/lists/linux-btrfs/msg81933.html

Omar Sandoval (6):
  mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
  mm: export add_swap_extent()
  vfs: update swap_{,de}activate documentation
  Btrfs: prevent ioctls from interfering with a swap file
  Btrfs: rename get_chunk_map() and make it non-static
  Btrfs: support swap files

 Documentation/filesystems/Locking |  17 +-
 Documentation/filesystems/vfs.txt |  12 +-
 fs/btrfs/ctree.h                  |  29 +++
 fs/btrfs/dev-replace.c            |   8 +
 fs/btrfs/disk-io.c                |   4 +
 fs/btrfs/inode.c                  | 317 ++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.c                  |  31 ++-
 fs/btrfs/relocation.c             |  18 +-
 fs/btrfs/volumes.c                |  82 ++++++--
 fs/btrfs/volumes.h                |   2 +
 include/linux/swap.h              |  13 +-
 mm/page_io.c                      |   6 +-
 mm/swapfile.c                     |  14 +-
 13 files changed, 502 insertions(+), 51 deletions(-)

-- 
2.19.0
