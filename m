Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbbBYSYg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 13:24:36 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 48834AAD1
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2015 18:24:35 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 01/11] btrfs: need_resched not needed with cond_resched
Date: Wed, 25 Feb 2015 19:24:34 +0100
Message-Id: <3bf93d4c0c62fab642a7c36d82c8a35c6c5ef7cf.1424880058.git.dsterba@suse.cz>
In-Reply-To: <cover.1424880058.git.dsterba@suse.cz>
References: <cover.1424880058.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup, no special reason to do

if (need_resched())
        cond_resched();

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/volumes.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8222f6f74147..50bb7b8b17e8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -366,8 +366,8 @@ loop_lock:
 		btrfsic_submit_bio(cur->bi_rw, cur);
 		num_run++;
 		batch_run++;
-		if (need_resched())
-			cond_resched();
+
+		cond_resched();
 
 		/*
 		 * we made progress, there is more work to do and the bdi
@@ -400,8 +400,7 @@ loop_lock:
 				 * against it before looping
 				 */
 				last_waited = ioc->last_waited;
-				if (need_resched())
-					cond_resched();
+				cond_resched();
 				continue;
 			}
 			spin_lock(&device->io_lock);
-- 
2.1.3

