Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49324 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754568AbdGNRga (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 13:36:30 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7682FAAC5
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 17:36:29 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/5] GFP flags and allocation cleanups
Date: Fri, 14 Jul 2017 19:35:15 +0200
Message-Id: <cover.1500053599.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A few more NOFS -> KERNEL conversions and simplification of memory allocations.

David Sterba (5):
  btrfs: use GFP_KERNEL in mount and remount
  btrfs: use GFP_KERNEL in btrfs_defrag_file
  btrfs: defrag: make readahead state allocation failure non-fatal
  btrfs: factor reading progress out of btrfs_dev_replace_status
  btrfs: simplify btrfs_dev_replace_kthread

 fs/btrfs/dev-replace.c | 74 ++++++++++++++++++++++++++++----------------------
 fs/btrfs/ioctl.c       | 20 +++++++-------
 fs/btrfs/super.c       | 15 +++++-----
 3 files changed, 59 insertions(+), 50 deletions(-)

-- 
2.13.0

