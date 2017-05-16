Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43457 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752541AbdEPRS3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:18:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D7572AB5F
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:18:27 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: remove unused member list from async_submit_bio
Date: Tue, 16 May 2017 19:17:31 +0200
Message-Id: <8dae3bc04ee84f5e82f5ef619c0a44de132a8d35.1494954874.git.dsterba@suse.com>
In-Reply-To: <cover.1494954874.git.dsterba@suse.com>
References: <cover.1494954874.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The list used to track checksums in the early version (2.6.29), but I
was able not pinpoint the commit that stopped using it. Everything
apparently works without it for a long time.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8685d67185d0..db805632b4c0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -120,7 +120,6 @@ void btrfs_end_io_wq_exit(void)
 struct async_submit_bio {
 	struct inode *inode;
 	struct bio *bio;
-	struct list_head list;
 	extent_submit_bio_hook_t *submit_bio_start;
 	extent_submit_bio_hook_t *submit_bio_done;
 	int mirror_num;
-- 
2.12.0

