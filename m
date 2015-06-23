Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:1618 "EHLO mail.synology.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387AbbFWKkA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 06:40:00 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v3 4/7] Btrfs: incremental send, fix orphan_dir_info leak
Date: Tue, 23 Jun 2015 18:39:48 +0800
Message-Id: <1435055991-10109-5-git-send-email-robbieko@synology.com>
In-Reply-To: <1435055991-10109-1-git-send-email-robbieko@synology.com>
References: <1435055991-10109-1-git-send-email-robbieko@synology.com>
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
 fs/btrfs/send.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index ca8cb87..194df76 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2914,6 +2914,11 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
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

