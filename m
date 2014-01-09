Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53698 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbaAIKxl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 05:53:41 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s09Arbcv026969
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Jan 2014 18:53:37 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: make send/receive compatible with older kernels
Date: Thu, 9 Jan 2014 18:52:38 +0800
Message-Id: <1389264758-9495-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some users complaint that with latest btrfs-progs, they will
fail to use send/receive. The problem is new tool will try
to use uuid tree while it dosen't work on older kernel.

Now we first check if we support uuid tree, if not we fall into
normal search as previous way.i copy most of codes from Alexander
Block's previous codes and did some adjustments to make it work.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 send-utils.c | 352 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 send-utils.h |  11 ++
 2 files changed, 359 insertions(+), 4 deletions(-)

diff --git a/send-utils.c b/send-utils.c
index 874f8a5..1772d2c 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -159,6 +159,71 @@ static int btrfs_read_root_item(int mnt_fd, u64 root_id,
 	return 0;
 }
 
+static struct rb_node *tree_insert(struct rb_root *root,
+				   struct subvol_info *si,
+				   enum subvol_search_type type)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct subvol_info *entry;
+	__s64 comp;
+
+	while (*p) {
+		parent = *p;
+		if (type == subvol_search_by_received_uuid) {
+			entry = rb_entry(parent, struct subvol_info,
+					rb_received_node);
+
+			comp = memcmp(entry->received_uuid, si->received_uuid,
+					BTRFS_UUID_SIZE);
+			if (!comp) {
+				if (entry->stransid < si->stransid)
+					comp = -1;
+				else if (entry->stransid > si->stransid)
+					comp = 1;
+				else
+					comp = 0;
+			}
+		} else if (type == subvol_search_by_uuid) {
+			entry = rb_entry(parent, struct subvol_info,
+					rb_local_node);
+			comp = memcmp(entry->uuid, si->uuid, BTRFS_UUID_SIZE);
+		} else if (type == subvol_search_by_root_id) {
+			entry = rb_entry(parent, struct subvol_info,
+					rb_root_id_node);
+			comp = entry->root_id - si->root_id;
+		} else if (type == subvol_search_by_path) {
+			entry = rb_entry(parent, struct subvol_info,
+					rb_path_node);
+			comp = strcmp(entry->path, si->path);
+		} else {
+			BUG();
+		}
+
+		if (comp < 0)
+			p = &(*p)->rb_left;
+		else if (comp > 0)
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	if (type == subvol_search_by_received_uuid) {
+		rb_link_node(&si->rb_received_node, parent, p);
+		rb_insert_color(&si->rb_received_node, root);
+	} else if (type == subvol_search_by_uuid) {
+		rb_link_node(&si->rb_local_node, parent, p);
+		rb_insert_color(&si->rb_local_node, root);
+	} else if (type == subvol_search_by_root_id) {
+		rb_link_node(&si->rb_root_id_node, parent, p);
+		rb_insert_color(&si->rb_root_id_node, root);
+	} else if (type == subvol_search_by_path) {
+		rb_link_node(&si->rb_path_node, parent, p);
+		rb_insert_color(&si->rb_path_node, root);
+	}
+	return NULL;
+}
+
 int btrfs_subvolid_resolve(int fd, char *path, size_t path_len, u64 subvol_id)
 {
 	if (path_len < 1)
@@ -255,13 +320,101 @@ static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
 	return 0;
 }
 
+static int count_bytes(void *buf, int len, char b)
+{
+	int cnt = 0;
+	int i;
+
+	for (i = 0; i < len; i++) {
+		if (((char *)buf)[i] == b)
+			cnt++;
+	}
+	return cnt;
+}
+
 void subvol_uuid_search_add(struct subvol_uuid_search *s,
 			    struct subvol_info *si)
 {
-	if (si) {
-		free(si->path);
-		free(si);
+	int cnt;
+
+	tree_insert(&s->root_id_subvols, si, subvol_search_by_root_id);
+	tree_insert(&s->path_subvols, si, subvol_search_by_path);
+
+	cnt = count_bytes(si->uuid, BTRFS_UUID_SIZE, 0);
+	if (cnt != BTRFS_UUID_SIZE)
+		tree_insert(&s->local_subvols, si, subvol_search_by_uuid);
+	cnt = count_bytes(si->received_uuid, BTRFS_UUID_SIZE, 0);
+	if (cnt != BTRFS_UUID_SIZE)
+		tree_insert(&s->received_subvols, si,
+				subvol_search_by_received_uuid);
+}
+
+static struct subvol_info *tree_search(struct rb_root *root,
+				       u64 root_id, const u8 *uuid,
+				       u64 stransid, const char *path,
+				       enum subvol_search_type type)
+{
+	struct rb_node *n = root->rb_node;
+	struct subvol_info *entry;
+	__s64 comp;
+
+	while (n) {
+		if (type == subvol_search_by_received_uuid) {
+			entry = rb_entry(n, struct subvol_info,
+					rb_received_node);
+			comp = memcmp(entry->received_uuid, uuid,
+					BTRFS_UUID_SIZE);
+			if (!comp) {
+				if (entry->stransid < stransid)
+					comp = -1;
+				else if (entry->stransid > stransid)
+					comp = 1;
+				else
+					comp = 0;
+			}
+		} else if (type == subvol_search_by_uuid) {
+			entry = rb_entry(n, struct subvol_info, rb_local_node);
+			comp = memcmp(entry->uuid, uuid, BTRFS_UUID_SIZE);
+		} else if (type == subvol_search_by_root_id) {
+			entry = rb_entry(n, struct subvol_info,
+					 rb_root_id_node);
+			comp = entry->root_id - root_id;
+		} else if (type == subvol_search_by_path) {
+			entry = rb_entry(n, struct subvol_info, rb_path_node);
+			comp = strcmp(entry->path, path);
+		} else {
+			BUG();
+		}
+		if (comp < 0)
+			n = n->rb_left;
+		else if (comp > 0)
+			n = n->rb_right;
+		else
+			return entry;
 	}
+	return NULL;
+}
+
+/*
+ * this function will be only called if kernel dosen't support uuid tree.
+ */
+static struct subvol_info *subvol_uuid_search_old(struct subvol_uuid_search *s,
+				       u64 root_id, const u8 *uuid, u64 transid,
+				       const char *path,
+				       enum subvol_search_type type)
+{
+	struct rb_root *root;
+	if (type == subvol_search_by_received_uuid)
+		root = &s->received_subvols;
+	else if (type == subvol_search_by_uuid)
+		root = &s->local_subvols;
+	else if (type == subvol_search_by_root_id)
+		root = &s->root_id_subvols;
+	else if (type == subvol_search_by_path)
+		root = &s->path_subvols;
+	else
+		return NULL;
+	return tree_search(root, root_id, uuid, transid, path, type);
 }
 
 struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
@@ -273,6 +426,9 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 	struct btrfs_root_item root_item;
 	struct subvol_info *info = NULL;
 
+	if (!s->uuid_tree_existed)
+		return subvol_uuid_search_old(s, root_id, uuid, transid,
+					     path, type);
 	switch (type) {
 	case subvol_search_by_received_uuid:
 		ret = btrfs_lookup_uuid_received_subvol_item(s->mnt_fd, uuid,
@@ -325,15 +481,203 @@ out:
 	return info;
 }
 
+static int is_uuid_tree_supported(int fd)
+{
+	int ret;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+
+	memset(&args, 0, sizeof(args));
+
+	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
+
+	sk->min_objectid = BTRFS_UUID_TREE_OBJECTID;
+	sk->max_objectid = BTRFS_UUID_TREE_OBJECTID;
+	sk->max_type = BTRFS_ROOT_ITEM_KEY;
+	sk->min_type = BTRFS_ROOT_ITEM_KEY;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+	sk->nr_items = 1;
+
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+	if (ret < 0)
+		return ret;
+
+	/* the ioctl returns the number of item it found in nr_items */
+	if (sk->nr_items == 0)
+		return 0;
+
+	return 1;
+}
+
+/*
+ * this function is mainly used to read all root items
+ * it will be only used when we use older kernel which uuid
+ * tree is not supported yet
+ */
 int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 {
+	int ret;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header *sh;
+	struct btrfs_root_item *root_item_ptr;
+	struct btrfs_root_item root_item;
+	struct subvol_info *si = NULL;
+	int root_item_valid = 0;
+	unsigned long off = 0;
+	int i;
+	int e;
+	char *path;
+
 	s->mnt_fd = mnt_fd;
 
-	return 0;
+	s->root_id_subvols = RB_ROOT;
+	s->local_subvols = RB_ROOT;
+	s->received_subvols = RB_ROOT;
+	s->path_subvols = RB_ROOT;
+
+	ret = is_uuid_tree_supported(mnt_fd);
+	if (ret < 0) {
+		fprintf(stderr,
+			"ERROR: check if we support uuid tree fails- %s\n",
+			strerror(errno));
+		return ret;
+	} else if (ret) {
+		/* uuid tree is supported */
+		s->uuid_tree_existed = 1;
+		return 0;
+	}
+	memset(&args, 0, sizeof(args));
+
+	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
+
+	sk->max_objectid = (u64)-1;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+	sk->min_type = BTRFS_ROOT_ITEM_KEY;
+	sk->max_type = BTRFS_ROOT_BACKREF_KEY;
+	sk->nr_items = 4096;
+
+	while (1) {
+		ret = ioctl(mnt_fd, BTRFS_IOC_TREE_SEARCH, &args);
+		e = errno;
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: can't perform the search- %s\n",
+				strerror(e));
+			return ret;
+		}
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+
+		for (i = 0; i < sk->nr_items; i++) {
+			sh = (struct btrfs_ioctl_search_header *)(args.buf +
+								  off);
+			off += sizeof(*sh);
+
+			if ((sh->objectid != 5 &&
+			    sh->objectid < BTRFS_FIRST_FREE_OBJECTID) ||
+			    sh->objectid > BTRFS_LAST_FREE_OBJECTID)
+				goto skip;
+
+			if (sh->type == BTRFS_ROOT_ITEM_KEY) {
+				/* older kernels don't have uuids+times */
+				if (sh->len < sizeof(root_item)) {
+					root_item_valid = 0;
+					goto skip;
+				}
+				root_item_ptr = (struct btrfs_root_item *)
+						(args.buf + off);
+				memcpy(&root_item, root_item_ptr,
+						sizeof(root_item));
+				root_item_valid = 1;
+			} else if (sh->type == BTRFS_ROOT_BACKREF_KEY ||
+				   root_item_valid) {
+				if (!root_item_valid)
+					goto skip;
+
+				path = btrfs_list_path_for_root(mnt_fd,
+								sh->objectid);
+				if (!path)
+					path = strdup("");
+				if (IS_ERR(path)) {
+					ret = PTR_ERR(path);
+					fprintf(stderr, "ERROR: unable to "
+							"resolve path "
+							"for root %llu\n",
+							sh->objectid);
+					goto out;
+				}
+
+				si = calloc(1, sizeof(*si));
+				si->root_id = sh->objectid;
+				memcpy(si->uuid, root_item.uuid,
+						BTRFS_UUID_SIZE);
+				memcpy(si->parent_uuid, root_item.parent_uuid,
+						BTRFS_UUID_SIZE);
+				memcpy(si->received_uuid,
+						root_item.received_uuid,
+						BTRFS_UUID_SIZE);
+				si->ctransid = btrfs_root_ctransid(&root_item);
+				si->otransid = btrfs_root_otransid(&root_item);
+				si->stransid = btrfs_root_stransid(&root_item);
+				si->rtransid = btrfs_root_rtransid(&root_item);
+				si->path = path;
+				subvol_uuid_search_add(s, si);
+				root_item_valid = 0;
+			} else {
+				goto skip;
+			}
+
+skip:
+			off += sh->len;
+
+			/*
+			 * record the mins in sk so we can make sure the
+			 * next search doesn't repeat this root
+			 */
+			sk->min_objectid = sh->objectid;
+			sk->min_offset = sh->offset;
+			sk->min_type = sh->type;
+		}
+		sk->nr_items = 4096;
+		if (sk->min_offset < (u64)-1)
+			sk->min_offset++;
+		else if (sk->min_objectid < (u64)-1) {
+			sk->min_objectid++;
+			sk->min_offset = 0;
+			sk->min_type = 0;
+		} else
+			break;
+	}
+
+out:
+	return ret;
 }
 
 void subvol_uuid_search_finit(struct subvol_uuid_search *s)
 {
+	struct rb_root *root = &s->root_id_subvols;
+	struct rb_node *node;
+
+	if (!s->uuid_tree_existed)
+		return;
+
+	while ((node = rb_first(root))) {
+		struct subvol_info *entry =
+			rb_entry(node, struct subvol_info, rb_root_id_node);
+
+		free(entry->path);
+		rb_erase(node, root);
+		free(entry);
+	}
+
+	s->root_id_subvols = RB_ROOT;
+	s->local_subvols = RB_ROOT;
+	s->received_subvols = RB_ROOT;
+	s->path_subvols = RB_ROOT;
 }
 
 char *path_cat(const char *p1, const char *p2)
diff --git a/send-utils.h b/send-utils.h
index ed1a40e..943b027 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -38,6 +38,11 @@ enum subvol_search_type {
 };
 
 struct subvol_info {
+	struct rb_node rb_root_id_node;
+	struct rb_node rb_local_node;
+	struct rb_node rb_received_node;
+	struct rb_node rb_path_node;
+
 	u64 root_id;
 	u8 uuid[BTRFS_UUID_SIZE];
 	u8 parent_uuid[BTRFS_UUID_SIZE];
@@ -52,6 +57,12 @@ struct subvol_info {
 
 struct subvol_uuid_search {
 	int mnt_fd;
+	int uuid_tree_existed;
+
+	struct rb_root root_id_subvols;
+	struct rb_root local_subvols;
+	struct rb_root received_subvols;
+	struct rb_root path_subvols;
 };
 
 int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s);
-- 
1.8.3.1

