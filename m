Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64834 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752673AbbEKIJH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:07 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87jSr028783
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:45 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 11/13] btrfs-progs: Introduce change_uuid() function.
Date: Mon, 11 May 2015 16:08:52 +0800
Message-ID: <1431331734-11714-12-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function does all the needed things for changing uuid.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
   Move to props.c
   Call change_id_prepare() and change_id_done().
---
 props.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/props.c b/props.c
index 0a1bc1e..9b2117c 100644
--- a/props.c
+++ b/props.c
@@ -20,12 +20,14 @@
 #include <sys/xattr.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include <uuid/uuid.h>
 
 #include "ctree.h"
 #include "commands.h"
 #include "utils.h"
 #include "props.h"
 #include "disk-io.h"
+#include "volumes.h"
 
 #define XATTR_BTRFS_PREFIX     "btrfs."
 #define XATTR_BTRFS_PREFIX_LEN (sizeof(XATTR_BTRFS_PREFIX) - 1)
@@ -383,6 +385,72 @@ static int change_id_done(struct btrfs_fs_info *fs_info)
 	return write_all_supers(fs_info->tree_root);
 }
 
+static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid,
+		       const char *new_chunk_uuid)
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
+	/* Now we can begin id change */
+	ret = change_id_prepare(fs_info);
+	if (ret < 0)
+		goto out;
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
+		if (ret < 0)
+			goto out;
+	}
+
+	/* Now id change is done */
+	ret = change_id_done(fs_info);
+out:
+	return ret;
+}
+
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
 	 prop_read_only},
-- 
2.4.0

