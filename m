Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54681 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750785AbdLMIZr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 03:25:47 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 86CBCABCF
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Dec 2017 08:25:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/4] Cleanup of bio_get/set 
Date: Wed, 13 Dec 2017 10:25:36 +0200
Message-Id: <1513153540-10737-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

Here is a series which cleans the btrfs source code of all the redundant 
bio_get/set calls. After it's applied there is only a single bio_get inovcation
left in __alloc_device for the flush_bio (and that is wrong since it 
leaks the bio, but this will be fixed in a follow up fix).

Nikolay Borisov (4):
  btrfs: Remove redundant bio_get/set calls in compressed read/write
    paths
  btrfs: Remove redundant bio_get/set from submit_dio_repair_bio
  btrfs: Remove redundan bio_get/bio_set pair from submit_one_bio
  btrfs: Remove redundant pair of bio_get/set in __btrfs_submit_dio_bio

 fs/btrfs/compression.c | 12 ------------
 fs/btrfs/extent_io.c   |  2 --
 fs/btrfs/inode.c       | 10 ++--------
 3 files changed, 2 insertions(+), 22 deletions(-)

-- 
2.7.4

