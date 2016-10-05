Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35643 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750964AbcJEND3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Oct 2016 09:03:29 -0400
Received: by mail-pf0-f193.google.com with SMTP id t25so6297894pfg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Oct 2016 06:03:29 -0700 (PDT)
From: Prasanth K S R <kosigiprasanth@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Prasanth K S R <prasanth.ksr@dell.com>, dsterba@suse.com
Subject: [PATCH] Btrfs-progs: subvol_uuid_search: Return error code on memory allocation failure
Date: Wed,  5 Oct 2016 18:33:12 +0530
Message-Id: <1475672592-3963-1-git-send-email-kosigiprasanth@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Prasanth K S R <prasanth.ksr@dell.com>

This commit fixes coverity defect CID 1328695.

Signed-off-by: Prasanth K S R <prasanth.ksr@dell.com>
---
 send-utils.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/send-utils.c b/send-utils.c
index a85fa08..6f80b6f 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -486,6 +486,11 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 		info->path = strdup(path);
 	} else {
 		info->path = malloc(PATH_MAX);
+		if (!info->path) {
+			fprintf(stderr, "Memory allocation failed\n");
+			ret = -ENOMEM;
+			goto out;
+		}
 		ret = btrfs_subvolid_resolve(s->mnt_fd, info->path,
 					     PATH_MAX, root_id);
 	}
-- 
2.7.4

