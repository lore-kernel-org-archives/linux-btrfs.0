Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbaAUP4L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 10:56:11 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: enclose uuid tree compat code with ifdefs
Date: Tue, 21 Jan 2014 16:56:07 +0100
Message-Id: <1390319767-11201-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit "Btrfs-progs: make send/receive compatible with older kernels"
adds code that will become deprecated, let's clearly mark it in the
sources.

CC: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 send-utils.c |   28 ++++++++++++++++++++++++++++
 send-utils.h |   10 ++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/send-utils.c b/send-utils.c
index 1772d2c5c0f3..8d4f46e3dd04 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -159,6 +159,7 @@ static int btrfs_read_root_item(int mnt_fd, u64 root_id,
 	return 0;
 }
 
+#ifdef BTRFS_COMPAT_SEND_NO_UUID_TREE
 static struct rb_node *tree_insert(struct rb_root *root,
 				   struct subvol_info *si,
 				   enum subvol_search_type type)
@@ -223,6 +224,7 @@ static struct rb_node *tree_insert(struct rb_root *root,
 	}
 	return NULL;
 }
+#endif
 
 int btrfs_subvolid_resolve(int fd, char *path, size_t path_len, u64 subvol_id)
 {
@@ -320,6 +322,7 @@ static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
 	return 0;
 }
 
+#ifdef BTRFS_COMPAT_SEND_NO_UUID_TREE
 static int count_bytes(void *buf, int len, char b)
 {
 	int cnt = 0;
@@ -416,6 +419,16 @@ static struct subvol_info *subvol_uuid_search_old(struct subvol_uuid_search *s,
 		return NULL;
 	return tree_search(root, root_id, uuid, transid, path, type);
 }
+#else
+void subvol_uuid_search_add(struct subvol_uuid_search *s,
+			    struct subvol_info *si)
+{
+	if (si) {
+		free(si->path);
+		free(si);
+	}
+}
+#endif
 
 struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 				       u64 root_id, const u8 *uuid, u64 transid,
@@ -426,9 +439,11 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 	struct btrfs_root_item root_item;
 	struct subvol_info *info = NULL;
 
+#ifdef BTRFS_COMPAT_SEND_NO_UUID_TREE
 	if (!s->uuid_tree_existed)
 		return subvol_uuid_search_old(s, root_id, uuid, transid,
 					     path, type);
+#endif
 	switch (type) {
 	case subvol_search_by_received_uuid:
 		ret = btrfs_lookup_uuid_received_subvol_item(s->mnt_fd, uuid,
@@ -481,6 +496,7 @@ out:
 	return info;
 }
 
+#ifdef BTRFS_COMPAT_SEND_NO_UUID_TREE
 static int is_uuid_tree_supported(int fd)
 {
 	int ret;
@@ -679,6 +695,18 @@ void subvol_uuid_search_finit(struct subvol_uuid_search *s)
 	s->received_subvols = RB_ROOT;
 	s->path_subvols = RB_ROOT;
 }
+#else
+int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
+{
+	s->mnt_fd = mnt_fd;
+
+	return 0;
+}
+
+void subvol_uuid_search_finit(struct subvol_uuid_search *s)
+{
+}
+#endif
 
 char *path_cat(const char *p1, const char *p2)
 {
diff --git a/send-utils.h b/send-utils.h
index 943b0277cf7e..f451c1cb6071 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -30,6 +30,12 @@
 extern "C" {
 #endif
 
+/*
+ * Compatibility code for kernels < 3.12; the UUID tree is not available there
+ * and we have to do the slow search. This should be deprecated someday.
+ */
+#define BTRFS_COMPAT_SEND_NO_UUID_TREE 1
+
 enum subvol_search_type {
 	subvol_search_by_root_id,
 	subvol_search_by_uuid,
@@ -38,10 +44,12 @@ enum subvol_search_type {
 };
 
 struct subvol_info {
+#ifdef BTRFS_COMPAT_SEND_NO_UUID_TREE
 	struct rb_node rb_root_id_node;
 	struct rb_node rb_local_node;
 	struct rb_node rb_received_node;
 	struct rb_node rb_path_node;
+#endif
 
 	u64 root_id;
 	u8 uuid[BTRFS_UUID_SIZE];
@@ -57,12 +65,14 @@ struct subvol_info {
 
 struct subvol_uuid_search {
 	int mnt_fd;
+#ifdef BTRFS_COMPAT_SEND_NO_UUID_TREE
 	int uuid_tree_existed;
 
 	struct rb_root root_id_subvols;
 	struct rb_root local_subvols;
 	struct rb_root received_subvols;
 	struct rb_root path_subvols;
+#endif
 };
 
 int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s);
-- 
1.7.9

