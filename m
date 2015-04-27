Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28435 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbbD0HhF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 03:37:05 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, m_btrfs@ml1.co.uk
Subject: [PATCH 4/8] Btrfs: use BTRFS_ERROR_DEV_MISSING_NOT_FOUND when missing device is not found
Date: Mon, 27 Apr 2015 15:34:11 +0800
Message-Id: <1430120055-10381-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1430120055-10381-1-git-send-email-anand.jain@oracle.com>
References: <1429525756-2727-2-git-send-email-anand.jain@oracle.com>
 <1430120055-10381-1-git-send-email-anand.jain@oracle.com>
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
index 13b19c5..7b16147 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2054,10 +2054,8 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
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
2.0.0.153.g79dcccc

