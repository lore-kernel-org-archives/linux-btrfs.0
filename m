Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50395 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbaLVKiJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 05:38:09 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 7391C3EE0B6
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 19:38:06 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id AD3DAAC02E4
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 19:38:05 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 59CF7E08002
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 19:38:05 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
	by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 78F1F3288AD
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 19:38:04 +0900 (JST)
Message-ID: <5497F487.20109@jp.fujitsu.com>
Date: Mon, 22 Dec 2014 19:37:59 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Capitalize elements in enum for improve readability.
References: <5497F2EE.1010906@jp.fujitsu.com>
In-Reply-To: <5497F2EE.1010906@jp.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

There are 25 enums in btrfs-progs and only two of them use
lower case letters for the name of elements. Capitalize
them to readability.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
 
---
 cmds-property.c | 18 +++++++++---------
 cmds-receive.c  |  6 +++---
 cmds-send.c     |  8 ++++----
 props.c         |  6 +++---
 props.h         | 10 +++++-----
 send-utils.c    | 50 +++++++++++++++++++++++++-------------------------
 send-utils.h    |  8 ++++----
 7 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index a764293..b7c01b3 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -197,19 +197,19 @@ static int autodetect_object_types(const char *object, int *types_out)
 	}
 
 	if (is_btrfs_object) {
-		types |= prop_object_inode;
+		types |= PROP_OBJECT_INODE;
 		if (st.st_ino == BTRFS_FIRST_FREE_OBJECTID)
-			types |= prop_object_subvol;
+			types |= PROP_OBJECT_SUBVOL;
 
 		ret = check_is_root(object);
 		if (ret < 0)
 			goto out;
 		if (!ret)
-			types |= prop_object_root;
+			types |= PROP_OBJECT_ROOT;
 	}
 
 	if (S_ISBLK(st.st_mode))
-		types |= prop_object_dev;
+		types |= PROP_OBJECT_DEV;
 
 	ret = 0;
 	*types_out = types;
@@ -250,7 +250,7 @@ static int dump_props(int types, const char *object, int name_and_help)
 
 	for (i = 0; prop_handlers[i].name; i++) {
 		prop = &prop_handlers[i];
-		for (j = 1; j < __prop_object_max; j <<= 1) {
+		for (j = 1; j < __PROP_OBJECT_MAX; j <<= 1) {
 			ret = dump_prop(prop, object, types, j, name_and_help);
 			if (ret < 0) {
 				ret = 50;
@@ -338,16 +338,16 @@ static void parse_args(int argc, char **argv,
 	*types = 0;
 	if (type_str) {
 		if (!strcmp(type_str, "s") || !strcmp(type_str, "subvol")) {
-			*types = prop_object_subvol;
+			*types = PROP_OBJECT_SUBVOL;
 		} else if (!strcmp(type_str, "f") ||
 			   !strcmp(type_str, "filesystem")) {
-			*types = prop_object_root;
+			*types = PROP_OBJECT_ROOT;
 		} else if (!strcmp(type_str, "i") ||
 			   !strcmp(type_str, "inode")) {
-			*types = prop_object_inode;
+			*types = PROP_OBJECT_INODE;
 		} else if (!strcmp(type_str, "d") ||
 			   !strcmp(type_str, "device")) {
-			*types = prop_object_dev;
+			*types = PROP_OBJECT_DEV;
 		} else {
 			fprintf(stderr, "ERROR: invalid object type.\n");
 			usage(usage_str);
diff --git a/cmds-receive.c b/cmds-receive.c
index f269ade..caa79c0 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -233,10 +233,10 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	strncpy_null(args_v2.name, path);
 
 	parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
-			parent_ctransid, NULL, subvol_search_by_received_uuid);
+			parent_ctransid, NULL, SUBVOL_SEARCH_BY_RECEIVED_UUID);
 	if (!parent_subvol) {
 		parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
-				parent_ctransid, NULL, subvol_search_by_uuid);
+				parent_ctransid, NULL, SUBVOL_SEARCH_BY_UUID);
 	}
 	if (!parent_subvol) {
 		ret = -ENOENT;
@@ -583,7 +583,7 @@ static int process_clone(const char *path, u64 offset, u64 len,
 		goto out;
 
 	si = subvol_uuid_search(&r->sus, 0, clone_uuid, clone_ctransid, NULL,
-			subvol_search_by_received_uuid);
+			SUBVOL_SEARCH_BY_RECEIVED_UUID);
 	if (!si) {
 		if (memcmp(clone_uuid, r->cur_subvol->received_uuid,
 				BTRFS_UUID_SIZE) == 0) {
diff --git a/cmds-send.c b/cmds-send.c
index 9b32c1f..730d0ea 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -63,7 +63,7 @@ static int get_root_id(struct btrfs_send *s, const char *path, u64 *root_id)
 	struct subvol_info *si;
 
 	si = subvol_uuid_search(&s->sus, 0, NULL, 0, path,
-			subvol_search_by_path);
+			SUBVOL_SEARCH_BY_PATH);
 	if (!si)
 		return -ENOENT;
 	*root_id = si->root_id;
@@ -78,12 +78,12 @@ static struct subvol_info *get_parent(struct btrfs_send *s, u64 root_id)
 	struct subvol_info *si;
 
 	si_tmp = subvol_uuid_search(&s->sus, root_id, NULL, 0, NULL,
-			subvol_search_by_root_id);
+			SUBVOL_SEARCH_BY_ROOT_ID);
 	if (!si_tmp)
 		return NULL;
 
 	si = subvol_uuid_search(&s->sus, 0, si_tmp->parent_uuid, 0, NULL,
-			subvol_search_by_uuid);
+			SUBVOL_SEARCH_BY_UUID);
 	free(si_tmp->path);
 	free(si_tmp);
 	return si;
@@ -127,7 +127,7 @@ static int find_good_parent(struct btrfs_send *s, u64 root_id, u64 *found)
 		free(parent2->path);
 		free(parent2);
 		parent2 = subvol_uuid_search(&s->sus, s->clone_sources[i], NULL,
-				0, NULL, subvol_search_by_root_id);
+				0, NULL, SUBVOL_SEARCH_BY_ROOT_ID);
 
 		if (!parent2) {
 			ret = -ENOENT;
diff --git a/props.c b/props.c
index c7c6752..3a4798f 100644
--- a/props.c
+++ b/props.c
@@ -189,11 +189,11 @@ out:
 
 
 const struct prop_handler prop_handlers[] = {
-	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
+	{"ro", "Set/get read-only flag of subvolume.", 0, PROP_OBJECT_SUBVOL,
 	 prop_read_only},
 	{"label", "Set/get label of device.", 0,
-	 prop_object_dev | prop_object_root, prop_label},
+	 PROP_OBJECT_DEV | PROP_OBJECT_ROOT, prop_label},
 	{"compression", "Set/get compression for a file or directory", 0,
-	 prop_object_inode, prop_compression},
+	 PROP_OBJECT_INODE, prop_compression},
 	{0, 0, 0, 0, 0}
 };
diff --git a/props.h b/props.h
index faa4410..21ba8a2 100644
--- a/props.h
+++ b/props.h
@@ -18,11 +18,11 @@
 #define PROPS_H_
 
 enum prop_object_type {
-	prop_object_dev		= (1 << 0),
-	prop_object_root	= (1 << 1),
-	prop_object_subvol	= (1 << 2),
-	prop_object_inode	= (1 << 3),
-	__prop_object_max,
+	PROP_OBJECT_DEV		= (1 << 0),
+	PROP_OBJECT_ROOT	= (1 << 1),
+	PROP_OBJECT_SUBVOL	= (1 << 2),
+	PROP_OBJECT_INODE	= (1 << 3),
+	__PROP_OBJECT_MAX,
 };
 
 typedef int (*prop_handler_t)(enum prop_object_type type,
diff --git a/send-utils.c b/send-utils.c
index cbaf2e9..1f0bca7 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -171,7 +171,7 @@ static struct rb_node *tree_insert(struct rb_root *root,
 
 	while (*p) {
 		parent = *p;
-		if (type == subvol_search_by_received_uuid) {
+		if (type == SUBVOL_SEARCH_BY_RECEIVED_UUID) {
 			entry = rb_entry(parent, struct subvol_info,
 					rb_received_node);
 
@@ -185,15 +185,15 @@ static struct rb_node *tree_insert(struct rb_root *root,
 				else
 					comp = 0;
 			}
-		} else if (type == subvol_search_by_uuid) {
+		} else if (type == SUBVOL_SEARCH_BY_UUID) {
 			entry = rb_entry(parent, struct subvol_info,
 					rb_local_node);
 			comp = memcmp(entry->uuid, si->uuid, BTRFS_UUID_SIZE);
-		} else if (type == subvol_search_by_root_id) {
+		} else if (type == SUBVOL_SEARCH_BY_ROOT_ID) {
 			entry = rb_entry(parent, struct subvol_info,
 					rb_root_id_node);
 			comp = entry->root_id - si->root_id;
-		} else if (type == subvol_search_by_path) {
+		} else if (type == SUBVOL_SEARCH_BY_PATH) {
 			entry = rb_entry(parent, struct subvol_info,
 					rb_path_node);
 			comp = strcmp(entry->path, si->path);
@@ -209,16 +209,16 @@ static struct rb_node *tree_insert(struct rb_root *root,
 			return parent;
 	}
 
-	if (type == subvol_search_by_received_uuid) {
+	if (type == SUBVOL_SEARCH_BY_RECEIVED_UUID) {
 		rb_link_node(&si->rb_received_node, parent, p);
 		rb_insert_color(&si->rb_received_node, root);
-	} else if (type == subvol_search_by_uuid) {
+	} else if (type == SUBVOL_SEARCH_BY_UUID) {
 		rb_link_node(&si->rb_local_node, parent, p);
 		rb_insert_color(&si->rb_local_node, root);
-	} else if (type == subvol_search_by_root_id) {
+	} else if (type == SUBVOL_SEARCH_BY_ROOT_ID) {
 		rb_link_node(&si->rb_root_id_node, parent, p);
 		rb_insert_color(&si->rb_root_id_node, root);
-	} else if (type == subvol_search_by_path) {
+	} else if (type == SUBVOL_SEARCH_BY_PATH) {
 		rb_link_node(&si->rb_path_node, parent, p);
 		rb_insert_color(&si->rb_path_node, root);
 	}
@@ -340,16 +340,16 @@ void subvol_uuid_search_add(struct subvol_uuid_search *s,
 {
 	int cnt;
 
-	tree_insert(&s->root_id_subvols, si, subvol_search_by_root_id);
-	tree_insert(&s->path_subvols, si, subvol_search_by_path);
+	tree_insert(&s->root_id_subvols, si, SUBVOL_SEARCH_BY_ROOT_ID);
+	tree_insert(&s->path_subvols, si, SUBVOL_SEARCH_BY_PATH);
 
 	cnt = count_bytes(si->uuid, BTRFS_UUID_SIZE, 0);
 	if (cnt != BTRFS_UUID_SIZE)
-		tree_insert(&s->local_subvols, si, subvol_search_by_uuid);
+		tree_insert(&s->local_subvols, si, SUBVOL_SEARCH_BY_UUID);
 	cnt = count_bytes(si->received_uuid, BTRFS_UUID_SIZE, 0);
 	if (cnt != BTRFS_UUID_SIZE)
 		tree_insert(&s->received_subvols, si,
-				subvol_search_by_received_uuid);
+				SUBVOL_SEARCH_BY_RECEIVED_UUID);
 }
 
 static struct subvol_info *tree_search(struct rb_root *root,
@@ -362,7 +362,7 @@ static struct subvol_info *tree_search(struct rb_root *root,
 	__s64 comp;
 
 	while (n) {
-		if (type == subvol_search_by_received_uuid) {
+		if (type == SUBVOL_SEARCH_BY_RECEIVED_UUID) {
 			entry = rb_entry(n, struct subvol_info,
 					rb_received_node);
 			comp = memcmp(entry->received_uuid, uuid,
@@ -375,14 +375,14 @@ static struct subvol_info *tree_search(struct rb_root *root,
 				else
 					comp = 0;
 			}
-		} else if (type == subvol_search_by_uuid) {
+		} else if (type == SUBVOL_SEARCH_BY_UUID) {
 			entry = rb_entry(n, struct subvol_info, rb_local_node);
 			comp = memcmp(entry->uuid, uuid, BTRFS_UUID_SIZE);
-		} else if (type == subvol_search_by_root_id) {
+		} else if (type == SUBVOL_SEARCH_BY_ROOT_ID) {
 			entry = rb_entry(n, struct subvol_info,
 					 rb_root_id_node);
 			comp = entry->root_id - root_id;
-		} else if (type == subvol_search_by_path) {
+		} else if (type == SUBVOL_SEARCH_BY_PATH) {
 			entry = rb_entry(n, struct subvol_info, rb_path_node);
 			comp = strcmp(entry->path, path);
 		} else {
@@ -407,13 +407,13 @@ static struct subvol_info *subvol_uuid_search_old(struct subvol_uuid_search *s,
 				       enum subvol_search_type type)
 {
 	struct rb_root *root;
-	if (type == subvol_search_by_received_uuid)
+	if (type == SUBVOL_SEARCH_BY_RECEIVED_UUID)
 		root = &s->received_subvols;
-	else if (type == subvol_search_by_uuid)
+	else if (type == SUBVOL_SEARCH_BY_UUID)
 		root = &s->local_subvols;
-	else if (type == subvol_search_by_root_id)
+	else if (type == SUBVOL_SEARCH_BY_ROOT_ID)
 		root = &s->root_id_subvols;
-	else if (type == subvol_search_by_path)
+	else if (type == SUBVOL_SEARCH_BY_PATH)
 		root = &s->path_subvols;
 	else
 		return NULL;
@@ -445,16 +445,16 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 					     path, type);
 #endif
 	switch (type) {
-	case subvol_search_by_received_uuid:
+	case SUBVOL_SEARCH_BY_RECEIVED_UUID:
 		ret = btrfs_lookup_uuid_received_subvol_item(s->mnt_fd, uuid,
 							     &root_id);
 		break;
-	case subvol_search_by_uuid:
+	case SUBVOL_SEARCH_BY_UUID:
 		ret = btrfs_lookup_uuid_subvol_item(s->mnt_fd, uuid, &root_id);
 		break;
-	case subvol_search_by_root_id:
+	case SUBVOL_SEARCH_BY_ROOT_ID:
 		break;
-	case subvol_search_by_path:
+	case SUBVOL_SEARCH_BY_PATH:
 		ret = btrfs_get_root_id_by_sub_path(s->mnt_fd, path, &root_id);
 		break;
 	default:
@@ -478,7 +478,7 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 	info->otransid = btrfs_root_otransid(&root_item);
 	info->stransid = btrfs_root_stransid(&root_item);
 	info->rtransid = btrfs_root_rtransid(&root_item);
-	if (type == subvol_search_by_path) {
+	if (type == SUBVOL_SEARCH_BY_PATH) {
 		info->path = strdup(path);
 	} else {
 		info->path = malloc(BTRFS_PATH_NAME_MAX);
diff --git a/send-utils.h b/send-utils.h
index f451c1c..2617981 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -37,10 +37,10 @@ extern "C" {
 #define BTRFS_COMPAT_SEND_NO_UUID_TREE 1
 
 enum subvol_search_type {
-	subvol_search_by_root_id,
-	subvol_search_by_uuid,
-	subvol_search_by_received_uuid,
-	subvol_search_by_path,
+	SUBVOL_SEARCH_BY_ROOT_ID,
+	SUBVOL_SEARCH_BY_UUID,
+	SUBVOL_SEARCH_BY_RECEIVED_UUID,
+	SUBVOL_SEARCH_BY_PATH,
 };
 
 struct subvol_info {
-- 
1.8.3.1

