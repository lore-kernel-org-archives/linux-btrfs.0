Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:42784 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbeEBFPu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 01:15:50 -0400
Received: by mail-lf0-f67.google.com with SMTP id u21-v6so18978314lfu.9
        for <linux-btrfs@vger.kernel.org>; Tue, 01 May 2018 22:15:49 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH V3 0/3] Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB restriction
Date: Wed,  2 May 2018 08:15:35 +0300
Message-Id: <20180502051538.26432-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At now btrfs_dedupe_file_range() restricted to 16MiB range for
limit locking time and memory requirement for dedup ioctl()

For too big input range code silently set range to 16MiB

Let's remove that restriction by do iterating over dedup range.
That's backward compatible and will not change anything for request
less then 16MiB.

Changes:
  v1 -> v2:
    - Refactor btrfs_cmp_data_prepare and btrfs_extent_same
    - Store memory of pages array between iterations
    - Lock inodes once, not on each iteration
    - Small inplace cleanups
  v2 -> v3:
    - Split to several patches

Timofey Titovets (3):
  Btrfs: split btrfs_extent_same() for simplification
  Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB restriction
  Btrfs: btrfs_extent_same() reuse cmp workspace

 fs/btrfs/ioctl.c | 161 ++++++++++++++++++++++++++---------------------
 1 file changed, 91 insertions(+), 70 deletions(-)

-- 
2.17.0
