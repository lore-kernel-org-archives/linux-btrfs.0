Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:5955 "EHLO mail.synology.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbbFVJI7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 05:08:59 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 4/7] Btrfs: incremental send, fix orphan_dir_info leak
Date: Mon, 22 Jun 2015 17:08:45 +0800
Message-Id: <1434964128-31757-5-git-send-email-robbieko@synology.com>
In-Reply-To: <1434964128-31757-1-git-send-email-robbieko@synology.com>
References: <1434964128-31757-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's one case where we leak a orphan_dir_info structure.

Example:

Parent snapshot:
|---- a/ (ino 279)
    |---- c (ino 282)
|---- del/ (ino 281)
    |---- tmp/ (ino 280)
    |---- long/ (ino 283)
    |---- longlong/ (ino 284)

Send snapshot:
|---- a/ (ino 279)
    |---- long (ino 283)
    |---- longlong (ino 284)
|---- c/ (ino 282)
    |---- tmp/ (ino 280)

Freeing an existing orphan_dir_info for a directory, when we realize
we can't rmdir the directory because it has a descendant that wasn't
yet processed, and the orphan_dir_info was created because it had a
descendant that had its rename operation delayed.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---

V2: modify comment

 fs/btrfs/send.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index b946067..bc9efbe 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2913,6 +2913,11 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 		}
 
 		if (loc.objectid > send_progress) {
+			struct orphan_dir_info *odi;
+
+			odi = get_orphan_dir_info(sctx, dir);
+			if (odi)
+				free_orphan_dir_info(sctx, odi);
 			ret = 0;
 			goto out;
 		}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
