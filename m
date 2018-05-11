Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:41275 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeEKGa1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 02:30:27 -0400
Received: by mail-pl0-f67.google.com with SMTP id az12-v6so2713683plb.8
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 23:30:26 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 0/3] Btrfs: stop abusing current->journal_info for direct I/O
Date: Thu, 10 May 2018 23:30:09 -0700
Message-Id: <cover.1525933432.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi, everyone,

Btrfs currently abuses current->journal_info in btrfs_direct_IO() in
order to pass around some state to get_block() and submit_io(). This
hack is ugly and unnecessary because the data we pass around is only
used in one call frame. Robbie Ko also pointed out [1] that it could
potentially cause a crash if we happen to end up in start_transaction()
(e.g., from memory reclaim calling into btrfs_evict_inode(), which can
start a transaction). I'm not convinced that Robbie's case can happen in
practice since we are using GFP_NOFS for allocations during direct I/O,
but either way it's fragile and nasty.

This series stops using current->journal_info and instead adds some
extra arguments to the generic direct I/O code so that we can pass
things around like sane people.

Based on Linus' master.

Thanks!

1: https://patchwork.kernel.org/patch/10389077/

Omar Sandoval (3):
  fs: add initial bh_result->b_private value to __blockdev_direct_IO()
  fs: add private argument to dio_submit_t
  Btrfs: stop abusing current->journal_info in btrfs_direct_IO()

 fs/btrfs/inode.c   | 39 ++++++++++-----------------------------
 fs/direct-io.c     | 12 +++++++-----
 fs/ext4/inode.c    |  6 +++---
 fs/gfs2/aops.c     |  2 +-
 fs/ocfs2/aops.c    |  5 ++---
 include/linux/fs.h | 10 +++++-----
 6 files changed, 28 insertions(+), 46 deletions(-)

-- 
2.17.0

