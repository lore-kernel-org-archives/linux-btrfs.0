Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38134 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbbL3Kb3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 05:31:29 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com, jpage.lkml@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH] BTRFS: Runs the xor function if a Block has failed
Date: Wed, 30 Dec 2015 01:28:36 -0500
Message-Id: <1451456916-16520-1-git-send-email-jpage.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch adds the xor function after the P stripe
has failed, without bad data or the Q stripe.

Signed-off-by: Sanidhya Solanki <jpage.lkml@gmail.com>
---
 fs/btrfs/raid56.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 1a33d3e..d33734a 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1864,8 +1864,8 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 					/*
 					 * Just the P stripe has failed, without
 					 * a bad data or Q stripe.
-					 * TODO, we should redo the xor here.
 					 */
+					run_xor(pointers, rbio->nr_data - 1, PAGE_CACHE_SIZE);
 					err = -EIO;
 					goto cleanup;
 				}
-- 
2.5.0

