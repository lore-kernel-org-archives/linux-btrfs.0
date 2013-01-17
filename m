Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:48022 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759235Ab3AQI2q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jan 2013 03:28:46 -0500
From: Arne Jansen <sensille@gmx.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: ignore orphan qgroup relations
Date: Thu, 17 Jan 2013 09:22:08 +0100
Message-Id: <97374a54586a5a6adabbc491f79f4f863ca8e9f7.1358410295.git.sensille@gmx.net>
In-Reply-To: <cover.1358410295.git.sensille@gmx.net>
References: <cover.1358410295.git.sensille@gmx.net>
In-Reply-To: <cover.1358410295.git.sensille@gmx.net>
References: <cover.1358410295.git.sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a qgroup that has still assignments is deleted by the user, the corresponding
relations are left in the tree. This leads to an unmountable filesystem.
With this patch, those relations are simple ignored.

Reported-by: Eric Hopper <hopper@omnifarious.org>
Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/qgroup.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index fe9d02c..28f2b39 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -379,6 +379,13 @@ next1:
 
 		ret = add_relation_rb(fs_info, found_key.objectid,
 				      found_key.offset);
+		if (ret == -ENOENT) {
+			printk(KERN_WARNING
+				"btrfs: orphan qgroup relation 0x%llx->0x%llx\n",
+				(unsigned long long)found_key.objectid,
+				(unsigned long long)found_key.offset);
+			ret = 0;	/* ignore the error */
+		}
 		if (ret)
 			goto out;
 next2:
-- 
1.7.3.4

