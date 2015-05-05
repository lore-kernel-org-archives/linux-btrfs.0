Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57443 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756072AbbEEGS4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:18:56 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t456Hbwd008371
	for <linux-btrfs@vger.kernel.org>; Tue, 5 May 2015 14:17:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 7/8] btrfs-progs: Introduce change_uuid() function.
Date: Tue, 5 May 2015 14:16:45 +0800
Message-ID: <1430806606-3226-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function does all the needed things for changing uuid.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfstune.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/btrfstune.c b/btrfstune.c
index 8a5b3c2..3e308b7 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -29,6 +29,7 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "utils.h"
+#include "volumes.h"
 
 static char *device;
 static int force = 0;
@@ -262,6 +263,62 @@ out:
 	return ret;
 }
 
+static int change_uuid(struct btrfs_fs_info *fs_info, char *new_fsid,
+		       char *new_chunk_uuid)
+{
+	int ret = 0;
+
+	/* caller should do extra check on passed uuid */
+	if (new_fsid) {
+		/* allocated mem will be freed at close_ctree() */
+		fs_info->new_fsid = malloc(BTRFS_FSID_SIZE);
+		if (!fs_info->new_fsid) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = uuid_parse(new_fsid, fs_info->new_fsid);
+		if (ret < 0)
+			goto out;
+	}
+
+	if (new_chunk_uuid) {
+		/* allocated mem will be freed at close_ctree() */
+		fs_info->new_chunk_tree_uuid = malloc(BTRFS_UUID_SIZE);
+		if (!fs_info->new_chunk_tree_uuid) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = uuid_parse(new_chunk_uuid, fs_info->new_chunk_tree_uuid);
+		if (ret < 0)
+			goto out;
+	}
+
+	/* Change extents first */
+	ret = change_extents_uuid(fs_info);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to change UUID of metadata\n");
+		goto out;
+	}
+
+	/* Then devices */
+	ret = change_devices_uuid(fs_info);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to change UUID of devices\n");
+		goto out;
+	}
+
+	/* Last, change fsid in super, only fsid change needs this */
+	if (new_fsid) {
+		memcpy(fs_info->fs_devices->fsid, fs_info->new_fsid,
+		       BTRFS_FSID_SIZE);
+		memcpy(fs_info->super_copy->fsid, fs_info->new_fsid,
+		       BTRFS_FSID_SIZE);
+		ret = write_all_supers(fs_info->tree_root);
+	}
+out:
+	return ret;
+}
+
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfstune [options] device\n");
-- 
2.3.7

