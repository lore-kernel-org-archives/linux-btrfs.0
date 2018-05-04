Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59165 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750820AbeEDHra (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 May 2018 03:47:30 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 88CB3AC7D
        for <linux-btrfs@vger.kernel.org>; Fri,  4 May 2018 07:47:29 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Misc cleanups to cached extent
Date: Fri,  4 May 2018 10:47:24 +0300
Message-Id: <1525420047-17397-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here are a couple of cleanups I stumbled upon while looking at the freespace 
validation code. The first one simplifies btrfs_rmap_block that has an unused 
parameter. The next 2 patches cleanup the cache_extent apis since they provide
more than we are actually using (or have ever used).

Nikolay Borisov (3):
  btrfs-progs: Remove devid parameter from btrfs_rmap_block
  btrfs-progs: Remove add_cache_extent2
  btrfs-progs: Remove objectid argument from alloc_cache_extent

 check/main.c   |  2 +-
 extent-cache.c | 21 ++++-----------------
 extent-cache.h |  2 --
 extent-tree.c  | 10 +++++-----
 volumes.c      |  7 ++-----
 volumes.h      |  4 ++--
 6 files changed, 14 insertions(+), 32 deletions(-)

-- 
2.7.4

