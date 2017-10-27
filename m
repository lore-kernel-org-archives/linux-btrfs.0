Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37961 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752077AbdJ0H37 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 27 Oct 2017 03:29:59 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 7/8] btrfs-progs: mkfs: Introduce option to enable quota at mkfs time
Date: Fri, 27 Oct 2017 15:29:35 +0800
Message-Id: <20171027072936.4697-8-wqu@suse.com>
In-Reply-To: <20171027072936.4697-1-wqu@suse.com>
References: <20171027072936.4697-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new parameter, --enable-quota, to enable quota at mkfs time.

The result fs will has quota enabled, with consistent qgroup accounting.

This is quite handy to test quota with fstests, which doesn't support to
call ioctl for btrfs at mount time.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/mkfs.btrfs.asciidoc |   3 ++
 mkfs/main.c                       | 102 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 5ddbedbcea97..78ddd5a7017a 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -140,6 +140,9 @@ Print only error or warning messages. Options --features or --help are unaffecte
 Create the filesystem with the given 'UUID'. The UUID must not exist on any
 filesystem currently present.
 
+*--enable-quota*::
+Create the filesystem with quota enabled. See `btrfs quota`(8) for more info.
+
 *-V|--version*::
 Print the *mkfs.btrfs* version and exit.
 
diff --git a/mkfs/main.c b/mkfs/main.c
index c50e7e74daf1..8d93a1613053 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -31,6 +31,7 @@
 #include <uuid/uuid.h>
 #include <ctype.h>
 #include <blkid/blkid.h>
+#include <string.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "volumes.h"
@@ -41,6 +42,7 @@
 #include "mkfs/common.h"
 #include "mkfs/rootdir.h"
 #include "fsfeatures.h"
+#include "qgroup-verify.h"
 
 static int verbose = 1;
 
@@ -349,6 +351,7 @@ static void print_usage(int ret)
 	printf("\t-O|--features LIST      comma separated list of filesystem features (use '-O list-all' to list features)\n");
 	printf("\t-L|--label LABEL        set the filesystem label\n");
 	printf("\t-U|--uuid UUID          specify the filesystem UUID (must be unique)\n");
+	printf("\t--enable-quota          enable btrfs quota feature\n");
 	printf("  creation:\n");
 	printf("\t-b|--byte-count SIZE    set filesystem size to SIZE (on the first device)\n");
 	printf("\t-r|--rootdir DIR        copy files from DIR to the image root directory\n");
@@ -736,6 +739,91 @@ static int insert_qgroup_items(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int setup_quota_root(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_qgroup_status_item *qsi;
+	struct btrfs_root *quota_root;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	int qgroup_repaired = 0;
+	int ret;
+
+	/* One to modify tree root, one for quota root */
+	trans = btrfs_start_transaction(fs_info->tree_root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("failed to start transaction: %d (%s)",
+			ret, strerror(-ret));
+		return ret;
+	}
+	ret = btrfs_create_root(trans, fs_info, BTRFS_QUOTA_TREE_OBJECTID);
+	if (ret < 0) {
+		error("failed to create quota root: %d (%s)",
+			ret, strerror(-ret));
+		goto fail;
+	}
+	quota_root = fs_info->quota_root;
+
+	key.objectid = 0;
+	key.type = BTRFS_QGROUP_STATUS_KEY;
+	key.offset = 0;
+
+	btrfs_init_path(&path);
+	ret = btrfs_insert_empty_item(trans, quota_root, &path, &key,
+				      sizeof(*qsi));
+	if (ret < 0) {
+		error("failed to insert qgroup status item: %d (%s)",
+			ret, strerror(-ret));
+		goto fail;
+	}
+
+	qsi = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			     struct btrfs_qgroup_status_item);
+	btrfs_set_qgroup_status_generation(path.nodes[0], qsi, 0);
+	btrfs_set_qgroup_status_rescan(path.nodes[0], qsi, 0);
+
+	/* Mark current status info inconsistent, and fix it later */
+	btrfs_set_qgroup_status_flags(path.nodes[0], qsi,
+			BTRFS_QGROUP_STATUS_FLAG_ON |
+			BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT);
+	btrfs_release_path(&path);
+
+	/* Currently mkfs will only create one subvolume */
+	ret = insert_qgroup_items(trans, fs_info, BTRFS_FS_TREE_OBJECTID);
+	if (ret < 0) {
+		error("failed to insert qgroup items: %d (%s)",
+			ret, strerror(-ret));
+		goto fail;
+	}
+
+	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
+	if (ret < 0) {
+		error("failed to commit current transaction: %d (%s)",
+			ret, strerror(-ret));
+		return ret;
+	}
+
+	/*
+	 * Qgroup is setup but with wrong info, use qgroup-verify
+	 * infrastructure to repair them.
+	 * (Just acts as offline rescan)
+	 */
+	ret = qgroup_verify_all(fs_info);
+	if (ret < 0) {
+		error("qgroup rescan failed: %d (%s)", ret, strerror(-ret));
+		return ret;
+	}
+	ret = repair_qgroups(fs_info, &qgroup_repaired, true);
+	if (ret < 0)
+		error("failed to fill qgroup info: %d (%s)", ret,
+			strerror(-ret));
+	return ret;
+fail:
+	btrfs_commit_transaction(trans, fs_info->tree_root);
+	return ret;
+}
+
 int main(int argc, char **argv)
 {
 	char *file;
@@ -767,6 +855,7 @@ int main(int argc, char **argv)
 	char *source_dir = NULL;
 	bool source_dir_set = false;
 	bool shrink_rootdir = false;
+	bool enable_quota = false;
 	u64 source_dir_size = 0;
 	u64 min_dev_size;
 	u64 shrink_size;
@@ -779,7 +868,7 @@ int main(int argc, char **argv)
 
 	while(1) {
 		int c;
-		enum { GETOPT_VAL_SHRINK = 257 };
+		enum { GETOPT_VAL_SHRINK = 257, GETOPT_VAL_QUOTA };
 		static const struct option long_options[] = {
 			{ "alloc-start", required_argument, NULL, 'A'},
 			{ "byte-count", required_argument, NULL, 'b' },
@@ -798,6 +887,7 @@ int main(int argc, char **argv)
 			{ "uuid", required_argument, NULL, 'U' },
 			{ "quiet", 0, NULL, 'q' },
 			{ "shrink", no_argument, NULL, GETOPT_VAL_SHRINK },
+			{ "enable-quota", no_argument, NULL, GETOPT_VAL_QUOTA },
 			{ "help", no_argument, NULL, GETOPT_VAL_HELP },
 			{ NULL, 0, NULL, 0}
 		};
@@ -880,6 +970,8 @@ int main(int argc, char **argv)
 			case GETOPT_VAL_SHRINK:
 				shrink_rootdir = true;
 				break;
+			case GETOPT_VAL_QUOTA:
+				enable_quota = true;
 				break;
 			case GETOPT_VAL_HELP:
 			default:
@@ -1242,6 +1334,14 @@ raid_groups:
 		}
 	}
 
+	if (enable_quota) {
+		ret = setup_quota_root(fs_info);
+		if (ret < 0) {
+			error("failed to initialize quota: %d (%s)", ret,
+				strerror(-ret));
+			goto out;
+		}
+	}
 	if (verbose) {
 		char features_buf[64];
 
-- 
2.14.3

