Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35264 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932146AbcLJNsW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Dec 2016 08:48:22 -0500
Received: by mail-pg0-f65.google.com with SMTP id p66so5385837pga.2
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Dec 2016 05:48:22 -0800 (PST)
From: Prasanth K S R <kosigiprasanth@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Prasanth K S R <prasanth.ksr@dell.com>, dsterba@suse.com
Subject: [PATCH 3/3] Btrfs-progs: subvol_uuid_search: Return error code on memory allocation failure
Date: Sat, 10 Dec 2016 19:17:44 +0530
Message-Id: <20161210134744.10825-3-kosigiprasanth@gmail.com>
In-Reply-To: <20161210134744.10825-1-kosigiprasanth@gmail.com>
References: <20161210134744.10825-1-kosigiprasanth@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Prasanth K S R <prasanth.ksr@dell.com>

On failure of memory allocation for a 'struct subvol_info', we would end
up dereferencing a NULL pointer. This commit fixes the issue by returning an
error encoded pointer.

Signed-off-by: Prasanth K S R <prasanth.ksr@dell.com>
---
 send-utils.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/send-utils.c b/send-utils.c
index 252ca6d..95445b5 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -474,6 +474,10 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 		goto out;
 
 	info = calloc(1, sizeof(*info));
+	if (!info) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	info->root_id = root_id;
 	memcpy(info->uuid, root_item.uuid, BTRFS_UUID_SIZE);
 	memcpy(info->received_uuid, root_item.received_uuid, BTRFS_UUID_SIZE);
@@ -495,9 +499,11 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 	}
 
 out:
-	if (ret && info) {
-		free(info->path);
-		free(info);
+	if (ret) {
+		if (info) {
+			free(info->path);
+			free(info);
+		}
 		return ERR_PTR(ret);
 	}
 
-- 
2.10.2

