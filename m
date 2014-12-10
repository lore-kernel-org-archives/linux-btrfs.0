Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbaLJNlI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 08:41:08 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D00BEAC19
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 13:41:05 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: basic support for TREE_SEARCH_V2 ioctl
Date: Wed, 10 Dec 2014 14:41:04 +0100
Message-Id: <1418218864-11430-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the interface and helper that checks if the v2 ioctl is supported.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 ioctl.h | 14 ++++++++++++++
 utils.c | 40 ++++++++++++++++++++++++++++++++++++++++
 utils.h |  2 ++
 3 files changed, 56 insertions(+)

diff --git a/ioctl.h b/ioctl.h
index 67c8de9808a7..2c2c7c1bc57e 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -279,6 +279,18 @@ struct btrfs_ioctl_search_args {
 	char buf[BTRFS_SEARCH_ARGS_BUFSIZE];
 };
 
+/*
+ * Extended version of TREE_SEARCH ioctl that can return more than 4k of bytes.
+ * The allocated size of the buffer is set in buf_size.
+ */
+struct btrfs_ioctl_search_args_v2 {
+        struct btrfs_ioctl_search_key key; /* in/out - search parameters */
+        __u64 buf_size;			   /* in - size of buffer
+                                            * out - on EOVERFLOW: needed size
+                                            *       to store item */
+        __u64 buf[0];                      /* out - found items */
+};
+
 #define BTRFS_INO_LOOKUP_PATH_MAX 4080
 struct btrfs_ioctl_ino_lookup_args {
 	__u64 treeid;
@@ -542,6 +554,8 @@ struct btrfs_ioctl_clone_range_args {
 				struct btrfs_ioctl_defrag_range_args)
 #define BTRFS_IOC_TREE_SEARCH _IOWR(BTRFS_IOCTL_MAGIC, 17, \
 				   struct btrfs_ioctl_search_args)
+#define BTRFS_IOC_TREE_SEARCH_V2 _IOWR(BTRFS_IOCTL_MAGIC, 17, \
+				   struct btrfs_ioctl_search_args_v2)
 #define BTRFS_IOC_INO_LOOKUP _IOWR(BTRFS_IOCTL_MAGIC, 18, \
 				   struct btrfs_ioctl_ino_lookup_args)
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, __u64)
diff --git a/utils.c b/utils.c
index 2a9241619128..d3ec0d4ab467 100644
--- a/utils.c
+++ b/utils.c
@@ -2450,3 +2450,43 @@ int find_next_key(struct btrfs_path *path, struct btrfs_key *key)
 	}
 	return 1;
 }
+
+int btrfs_tree_search2_ioctl_supported(int fd)
+{
+	struct btrfs_ioctl_search_args_v2 *args2;
+	struct btrfs_ioctl_search_key *sk;
+	int args2_size = 1024;
+	char args2_buf[args2_size];
+	int ret;
+	static int v2_supported = -1;
+
+	if (v2_supported != -1)
+		return v2_supported;
+
+	args2 = (struct btrfs_ioctl_search_args_v2 *)args2_buf;
+	sk = &(args2->key);
+
+	/*
+	 * Search for the extent tree item in the root tree.
+	 */
+	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
+	sk->min_objectid = BTRFS_EXTENT_TREE_OBJECTID;
+	sk->max_objectid = BTRFS_EXTENT_TREE_OBJECTID;
+	sk->min_type = BTRFS_ROOT_ITEM_KEY;
+	sk->max_type = BTRFS_ROOT_ITEM_KEY;
+	sk->min_offset = 0;
+	sk->max_offset = (u64)-1;
+	sk->min_transid = 0;
+	sk->max_transid = (u64)-1;
+	sk->nr_items = 1;
+	args2->buf_size = args2_size - sizeof(struct btrfs_ioctl_search_args_v2);
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH_V2, args2);
+	if (ret == -EOPNOTSUPP)
+		v2_supported = 0;
+	else if (ret == 0)
+		v2_supported = 1;
+	else
+		return ret;
+
+	return v2_supported;
+}
diff --git a/utils.h b/utils.h
index 289e86b4b11e..eb917d695f18 100644
--- a/utils.h
+++ b/utils.h
@@ -161,4 +161,6 @@ static inline u64 btrfs_min_dev_size(u32 leafsize)
 
 int find_next_key(struct btrfs_path *path, struct btrfs_key *key);
 
+int btrfs_tree_search2_ioctl_supported(int fd);
+
 #endif
-- 
2.1.3

