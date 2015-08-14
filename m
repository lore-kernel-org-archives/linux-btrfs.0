Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37944 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbbHNKdj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:39 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 11/23] Btrfs: use BTRFS_ERROR_DEV_MISSING_NOT_FOUND when missing device is not found
Date: Fri, 14 Aug 2015 18:32:56 +0800
Message-Id: <1439548388-29686-12-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

use btrfs specific error code BTRFS_ERROR_DEV_MISSING_NOT_FOUND instead of -ENOENT.
Next this removes the logging when user specifies "missing" and we don't find
it in the kernel device list. logging are for system events not for user input errors.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 101a473..f1b36b9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2078,10 +2078,8 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 			}
 		}
 
-		if (!*device) {
-			btrfs_err(root->fs_info, "no missing device found");
-			return -ENOENT;
-		}
+		if (!*device)
+			return BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
 
 		return 0;
 	} else {
-- 
2.4.1

