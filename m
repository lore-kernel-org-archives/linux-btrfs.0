Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:36906 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbeCGIU7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 03:20:59 -0500
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 0/2]  btrfs fiemap related BUG fix.
Date: Wed,  7 Mar 2018 16:20:17 +0800
Message-Id: <1520410819-32405-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

This patchset intends to fix btrfs fiemap related bug.

The fiemap has the following problems:

1) Wrong extent count when fm_extent_count is zero.


2) SHARED bit is not correct
I have two ideas, but I do not know which one is the best.

Like:
 # dd if=/dev/zero bs=16K count=2 oflag=dsync of=/mnt/btrfs/file
 # xfs_io -c "fiemap -v" /mnt/btrfs/file
     /mnt/btrfs/file:
     EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
       0: [0..63]:         4241424..4241487    64   0x1
 # cloner -s $((16*1024)) /mnt/btrfs/file /mnt/btrfs/file_clone

1. When any extent is shared in extent map, the entire extent map is shared
 # xfs_io -c "fiemap -v" /mnt/btrfs/file
     /mnt/btrfs/file:
     EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
       0: [0..63]:         4241424..4241487   64  0x2001

2. Split into different extent
 # xfs_io -c "fiemap -v" /mnt/btrfs/file
     /mnt/btrfs/file:
     EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
       0: [0..31]:         4241424..4241455   32  0x0
       1: [32..63]:        4241456..4241487   32  0x2001

Robbie Ko (2):
  Btrfs: fiemap: pass correct bytenr when fm_extent_count is zero
  Btrfs: fix fiemap extent SHARED flag error with range clone.

 fs/btrfs/extent_io.c | 150 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 132 insertions(+), 18 deletions(-)

--
1.9.1

