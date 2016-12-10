Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34298 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753471AbcLJNsS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Dec 2016 08:48:18 -0500
Received: by mail-pg0-f66.google.com with SMTP id e9so5376831pgc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Dec 2016 05:48:18 -0800 (PST)
From: Prasanth K S R <kosigiprasanth@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Prasanth K S R <prasanth.ksr@dell.com>, dsterba@suse.com
Subject: [PATCH 1/3] Btrfs-progs: subvol_uuid_search: Return error on memory allocation failure
Date: Sat, 10 Dec 2016 19:17:42 +0530
Message-Id: <20161210134744.10825-1-kosigiprasanth@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Prasanth K S R <prasanth.ksr@dell.com>

This commit fixes coverity defect CID 1328695.

Signed-off-by: Prasanth K S R <prasanth.ksr@dell.com>
---
 send-utils.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/send-utils.c b/send-utils.c
index a85fa08..5026882 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -486,6 +486,10 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 		info->path = strdup(path);
 	} else {
 		info->path = malloc(PATH_MAX);
+		if (!info->path) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		ret = btrfs_subvolid_resolve(s->mnt_fd, info->path,
 					     PATH_MAX, root_id);
 	}
-- 
2.10.2

