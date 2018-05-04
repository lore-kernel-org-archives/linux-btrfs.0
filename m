Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59350 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeEDLLR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 May 2018 07:11:17 -0400
From: Colin King <colin.king@canonical.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: send: fix spelling mistake: "send_in_progres" -> "send_in_progress"
Date: Fri,  4 May 2018 12:11:12 +0100
Message-Id: <20180504111112.14900-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake of function name in btrfs_err message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index c0074d2d7d6d..6e8184f239e0 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6454,7 +6454,7 @@ static void btrfs_root_dec_send_in_progress(struct btrfs_root* root)
 	 */
 	if (root->send_in_progress < 0)
 		btrfs_err(root->fs_info,
-			  "send_in_progres unbalanced %d root %llu",
+			  "send_in_progress unbalanced %d root %llu",
 			  root->send_in_progress, root->root_key.objectid);
 	spin_unlock(&root->root_item_lock);
 }
-- 
2.17.0

