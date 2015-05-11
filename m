Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11526 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752699AbbEKIJH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:07 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87kaG028786
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 12/13] btrfs-progs: Add offline type for btrfs property.
Date: Mon, 11 May 2015 16:08:53 +0800
Message-ID: <1431331734-11714-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new offline type for btrfs property, it has two members:
1) fsid: Set/get fsid of an *OFFLINE* btrfs.
2) chunk_tree_uuid: Set/get chunk tree uuid of an *OFFLINE* btrfs

The new type is added to distinguish these dangerous offline operation
from the normal online operations.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Newly introduced.
---
 cmds-property.c |   5 ++-
 props.c         | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 props.h         |   1 +
 3 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/cmds-property.c b/cmds-property.c
index 6501338..6c699db 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -41,7 +41,7 @@ static const char * const cmd_get_usage[] = {
 	"an inode or a device. The '-t <type>' option can be used to explicitly",
 	"specify what type of object you meant. This is only needed when a",
 	"property could be set for more then one object type. Possible types",
-	"are s[ubvol], f[ilesystem], i[node] and d[evice].",
+	"are s[ubvol], f[ilesystem], i[node], d[evice] and o[ffline].",
 	NULL
 };
 
@@ -360,6 +360,9 @@ static void parse_args(int argc, char **argv,
 		} else if (!strcmp(type_str, "d") ||
 			   !strcmp(type_str, "device")) {
 			*types = prop_object_dev;
+		} else if (!strcmp(type_str, "o") ||
+			   !strcmp(type_str, "offline")) {
+			*types = prop_object_offline;
 		} else {
 			fprintf(stderr, "ERROR: invalid object type.\n");
 			usage(usage_str);
diff --git a/props.c b/props.c
index 9b2117c..73537bd 100644
--- a/props.c
+++ b/props.c
@@ -451,6 +451,125 @@ out:
 	return ret;
 }
 
+/* Will check if it is a block device/softlink/regular file, or mounted */
+static int check_offline(const char *device)
+{
+	struct stat statbuf;
+	int ret = 0;
+
+	ret = stat(device, &statbuf);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to check status for %s: %s\n",
+			device, strerror(errno));
+		ret = -errno;
+		goto out;
+	}
+	if (!(S_ISBLK(statbuf.st_mode) || S_ISREG(statbuf.st_mode) ||
+	      S_ISLNK(statbuf.st_mode))) {
+		fprintf(stderr,
+			"%s is not a regular/device file containing btrfs\n",
+			device);
+		ret = -EINVAL;
+		goto out;
+	}
+	ret = check_mounted(device);
+	if (ret < 0) {
+		fprintf(stderr, "Could not check mount status: %s\n",
+			strerror(-ret));
+	} else if (ret > 0) {
+		fprintf(stderr, "%s is mounted\n", device);
+		ret = -EINVAL;
+	}
+out:
+	return ret;
+}
+
+static int prop_offline_uuid(enum prop_object_type type,
+			     const char *object,
+			     const char *name,
+			     const char *value)
+{
+	struct btrfs_fs_info *fs_info;
+	enum btrfs_open_ctree_flags ctree_flags = 0;
+	char *uuid_name = NULL;
+	int is_fsid;
+	int ret = 0;
+
+	ret = check_offline(object);
+	if (ret < 0)
+		goto out;
+
+	if (!strcmp(name, "fsid")) {
+		is_fsid = 1;
+		uuid_name = "fsid";
+	} else {
+		is_fsid = 0;
+		uuid_name = "chunk_tree_uuid";
+	}
+
+	if (value) {
+		uuid_t tmp;
+		char fsid[BTRFS_UUID_UNPARSED_SIZE];
+
+		ctree_flags |= OPEN_CTREE_WRITES;
+		if (is_fsid)
+			ctree_flags |= OPEN_CTREE_IGNORE_FSID;
+		else
+			ctree_flags |= OPEN_CTREE_IGNORE_CHUNK_TREE_ID;
+
+		ret = uuid_parse(value, tmp);
+		if (ret < 0) {
+			fprintf(stderr, "could not parse UUID: %s\n", value);
+			goto out;
+		}
+
+		/*
+		 * Copy value to fsid, to avoid warning about discarding
+		 * 'const' qualifier.
+		 * The root cause is from blkid library used by
+		 * test_uuid_unique, no good fix in btrfs.
+		 */
+		strcpy(fsid, value);
+
+		if (!test_uuid_unique(fsid)) {
+			fprintf(stderr, "non-unique UUID: %s\n", fsid);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	fs_info = open_ctree_fs_info(object, 0, 0, ctree_flags);
+	if (!fs_info) {
+		ret = -EIO;
+		goto out;
+	}
+
+	/* For get, we just use fsid from fs_info */
+	if (!value) {
+		char buf[BTRFS_UUID_UNPARSED_SIZE] = {'\0'};
+
+		uuid_unparse(fs_info->fsid, buf);
+		fprintf(stdout, "%s=%s\n", uuid_name, buf);
+		goto close_ctree;
+	}
+
+	/* Here, we are going to change uuid*/
+	if (is_fsid)
+		ret = change_uuid(fs_info, value, NULL);
+	else
+		ret = change_uuid(fs_info, NULL, value);
+	if (ret < 0)
+		fprintf(stderr, "Failed to change %s: %s\n",
+			uuid_name, strerror(-ret));
+	else
+		printf("%s changed to %s\n", uuid_name, value);
+
+close_ctree:
+	close_ctree(fs_info->tree_root);
+out:
+	return ret;
+}
+
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
 	 prop_read_only},
@@ -458,5 +577,9 @@ const struct prop_handler prop_handlers[] = {
 	 prop_object_dev | prop_object_root, prop_label},
 	{"compression", "Set/get compression for a file or directory", 0,
 	 prop_object_inode, prop_compression},
+	{"fsid", "Set/get fsid of a offline filesystem", 0,
+	 prop_object_offline, prop_offline_uuid},
+	{"chunk_tree_uuid", "Set/get fsid of a offline filesystem", 0,
+	 prop_object_offline, prop_offline_uuid},
 	{0, 0, 0, 0, 0}
 };
diff --git a/props.h b/props.h
index a43cb25..05c7761 100644
--- a/props.h
+++ b/props.h
@@ -22,6 +22,7 @@ enum prop_object_type {
 	prop_object_root	= (1 << 1),
 	prop_object_subvol	= (1 << 2),
 	prop_object_inode	= (1 << 3),
+	prop_object_offline	= (1 << 4),
 	__prop_object_max,
 };
 
-- 
2.4.0

