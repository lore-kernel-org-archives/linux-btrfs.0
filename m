Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:34461 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966227AbeEXVlk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 17:41:40 -0400
Received: by mail-pl0-f68.google.com with SMTP id ay10-v6so1840714plb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 24 May 2018 14:41:40 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [RFC PATCH v4 0/6] Btrfs: implement swap file support
Date: Thu, 24 May 2018 14:41:24 -0700
Message-Id: <cover.1527197312.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi,

This patch series implements swap file support for Btrfs. If you don't
remember versions 1-3, that's because they were almost 4 years ago [1]
:)

This attempt takes a very different approach from my original versions
back then. As a refresher, the original idea was to go through
->read_iter() and ->write_iter() in O_DIRECT mode. It turns out that
this is really hard to get right, because it effectively makes the
GFP_NOFS flag meaningless, since now swapping out can go through the
filesystem and grab locks and such. We could try to make the read/write
path lockless for a swap file, but this would be too easy to get wrong.

So, instead, this approach was inspired by the iomap swap file support
[2], where we directly tell the swap code where it can find the swap
extents while doing our own sanity checks. This has a bunch of
restrictions, documented in patches 4 and 6. I have a bunch of xfstests
for these cases at https://github.com/osandov/xfstests/tree/btrfs-swap.

This series can also be found at https://github.com/osandov/linux/tree/btrfs-swap.

All comments welcome. Thanks!

1: https://www.spinics.net/lists/linux-btrfs/msg40129.html
2: https://patchwork.kernel.org/patch/10390417/

Omar Sandoval (6):
  mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
  vfs: update swap_{,de}activate documentation
  Btrfs: push EXCL_OP set into btrfs_rm_device()
  Btrfs: prevent ioctls from interfering with a swap file
  Btrfs: rename get_chunk_map() and make it non-static
  Btrfs: support swap files

 Documentation/filesystems/Locking |  17 +--
 Documentation/filesystems/vfs.txt |  12 +-
 fs/btrfs/ctree.h                  |   6 +
 fs/btrfs/disk-io.c                |   3 +
 fs/btrfs/inode.c                  | 220 ++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.c                  |  64 ++++++---
 fs/btrfs/volumes.c                |  34 +++--
 fs/btrfs/volumes.h                |   2 +
 include/linux/swap.h              |  13 +-
 mm/page_io.c                      |   6 +-
 mm/swapfile.c                     |  14 +-
 11 files changed, 335 insertions(+), 56 deletions(-)

-- 
2.17.0

