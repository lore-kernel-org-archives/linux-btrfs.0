Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:23982 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab3ENK2B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 06:28:01 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp2) (RZmta 31.27 OK)
	with ESMTP id g01efep4E2rV3O for <linux-btrfs@vger.kernel.org>;
	Tue, 14 May 2013 12:27:59 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/4] Btrfs-progs: use UUID tree for send/receive
Date: Tue, 14 May 2013 12:27:58 +0200
Message-Id: <46fc58b53fa1d6f6ca73981a59712f91de918202.1368524368.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368524368.git.sbehrens@giantdisaster.de>
References: <cover.1368524368.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368524368.git.sbehrens@giantdisaster.de>
References: <cover.1368524368.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit changes the btrfs send/receive commands to use the
UUID tree to map UUIDs to subvolumes, and to use the root tree
to map subvolume IDs to paths. Now these tools start fast and are
independent on the number of subvolules/snapshot that exist.

Before this commit, mapping UUIDs to subvolume IDs was an operation
with a high effort. The algorithm even had quadratic effort (based
on the number of existing subvolumes). E.g. with 15,000 subvolumes
it took much more than 5 minutes on a state of the art XEON CPU to
start btrfs send or receive before these tools were able to send or
receive the first byte).
Even linear effort instead of the current quadratic effort would be
too much since it would be a waste. And these data structures to
allow mapping UUIDs to subvolume IDs had been created every time a
btrfs send/receive instance was started.

It is much more efficient to maintain a searchable persistent data
structure in the filesystem, one that is updated whenever a
subvolume/snapshot is created and deleted, and when the received
subvolume UUID is set by the btrfs-receive tool.

Therefore kernel code was added that is able to maintain data
structures in the filesystem that allow to quickly search for a
given UUID and to retrieve data that is assigned to this UUID, like
which subvolume ID is related to this UUID.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-receive.c |  23 ++-
 cmds-send.c    |  53 +++++--
 send-utils.c   | 477 +++++++++++++++++++++++----------------------------------
 send-utils.h   |   9 +-
 4 files changed, 253 insertions(+), 309 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index c2fa2e1..4e480f9 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -31,6 +31,7 @@
 #include <math.h>
 #include <ftw.h>
 #include <wait.h>
+#include <assert.h>
 
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -129,14 +130,14 @@ static int finish_subvol(struct btrfs_receive *r)
 		goto out;
 	}
 
-	ret = btrfs_list_get_path_rootid(subvol_fd, &r->cur_subvol->root_id);
-	if (ret < 0)
-		goto out;
-	subvol_uuid_search_add(&r->sus, r->cur_subvol);
-	r->cur_subvol = NULL;
 	ret = 0;
 
 out:
+	if (r->cur_subvol) {
+		free(r->cur_subvol->path);
+		free(r->cur_subvol);
+		r->cur_subvol = NULL;
+	}
 	if (subvol_fd != -1)
 		close(subvol_fd);
 	return ret;
@@ -197,7 +198,7 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	struct btrfs_receive *r = user;
 	char uuid_str[128];
 	struct btrfs_ioctl_vol_args_v2 args_v2;
-	struct subvol_info *parent_subvol;
+	struct subvol_info *parent_subvol = NULL;
 
 	ret = finish_subvol(r);
 	if (ret < 0)
@@ -268,6 +269,10 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	}
 
 out:
+	if (parent_subvol) {
+		free(parent_subvol->path);
+		free(parent_subvol);
+	}
 	return ret;
 }
 
@@ -557,7 +562,7 @@ static int process_clone(const char *path, u64 offset, u64 len,
 			 const char *clone_path, u64 clone_offset,
 			 void *user)
 {
-	int ret = 0;
+	int ret;
 	struct btrfs_receive *r = user;
 	struct btrfs_ioctl_clone_range_args clone_args;
 	struct subvol_info *si = NULL;
@@ -624,6 +629,10 @@ static int process_clone(const char *path, u64 offset, u64 len,
 	}
 
 out:
+	if (si) {
+		free(si->path);
+		free(si);
+	}
 	free(full_path);
 	free(full_clone_path);
 	free(subvol_path);
diff --git a/cmds-send.c b/cmds-send.c
index 72804a9..7209aba 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -31,6 +31,7 @@
 #include <sys/ioctl.h>
 #include <libgen.h>
 #include <mntent.h>
+#include <assert.h>
 
 #include <uuid/uuid.h>
 
@@ -106,30 +107,33 @@ static int get_root_id(struct btrfs_send *s, const char *path, u64 *root_id)
 	if (!si)
 		return -ENOENT;
 	*root_id = si->root_id;
+	free(si->path);
+	free(si);
 	return 0;
 }
 
 static struct subvol_info *get_parent(struct btrfs_send *s, u64 root_id)
 {
+	struct subvol_info *si_tmp;
 	struct subvol_info *si;
 
-	si = subvol_uuid_search(&s->sus, root_id, NULL, 0, NULL,
+	si_tmp = subvol_uuid_search(&s->sus, root_id, NULL, 0, NULL,
 			subvol_search_by_root_id);
-	if (!si)
+	if (!si_tmp)
 		return NULL;
 
-	si = subvol_uuid_search(&s->sus, 0, si->parent_uuid, 0, NULL,
+	si = subvol_uuid_search(&s->sus, 0, si_tmp->parent_uuid, 0, NULL,
 			subvol_search_by_uuid);
-	if (!si)
-		return NULL;
+	free(si_tmp->path);
+	free(si_tmp);
 	return si;
 }
 
 static int find_good_parent(struct btrfs_send *s, u64 root_id, u64 *found)
 {
 	int ret;
-	struct subvol_info *parent;
-	struct subvol_info *parent2;
+	struct subvol_info *parent = NULL;
+	struct subvol_info *parent2 = NULL;
 	struct subvol_info *best_parent = NULL;
 	__s64 tmp;
 	u64 best_diff = (u64)-1;
@@ -144,24 +148,43 @@ static int find_good_parent(struct btrfs_send *s, u64 root_id, u64 *found)
 	for (i = 0; i < s->clone_sources_count; i++) {
 		if (s->clone_sources[i] == parent->root_id) {
 			best_parent = parent;
+			parent = NULL;
 			goto out_found;
 		}
 	}
 
 	for (i = 0; i < s->clone_sources_count; i++) {
 		parent2 = get_parent(s, s->clone_sources[i]);
-		if (parent2 != parent)
+		if (!parent2)
 			continue;
+		if (parent2->root_id != parent->root_id) {
+			free(parent2->path);
+			free(parent2);
+			parent2 = NULL;
+			continue;
+		}
 
+		free(parent2->path);
+		free(parent2);
 		parent2 = subvol_uuid_search(&s->sus, s->clone_sources[i], NULL,
 				0, NULL, subvol_search_by_root_id);
 
+		assert(parent2);
 		tmp = parent2->ctransid - parent->ctransid;
 		if (tmp < 0)
 			tmp *= -1;
 		if (tmp < best_diff) {
+			if (best_parent) {
+				free(best_parent->path);
+				free(best_parent);
+			}
 			best_parent = parent2;
+			parent2 = NULL;
 			best_diff = tmp;
+		} else {
+			free(parent2->path);
+			free(parent2);
+			parent2 = NULL;
 		}
 	}
 
@@ -175,6 +198,14 @@ out_found:
 	ret = 0;
 
 out:
+	if (parent) {
+		free(parent->path);
+		free(parent);
+	}
+	if (best_parent) {
+		free(best_parent->path);
+		free(best_parent);
+	}
 	return ret;
 }
 
@@ -320,7 +351,7 @@ static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root_id,
 		fprintf(stderr, "joining genl thread\n");
 
 	close(pipefd[1]);
-	pipefd[1] = 0;
+	pipefd[1] = -1;
 
 	ret = pthread_join(t_read, &t_err);
 	if (ret) {
@@ -347,6 +378,10 @@ out:
 		close(pipefd[0]);
 	if (pipefd[1] != -1)
 		close(pipefd[1]);
+	if (si) {
+		free(si->path);
+		free(si);
+	}
 	return ret;
 }
 
diff --git a/send-utils.c b/send-utils.c
index bacd47e..874f8a5 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -16,7 +16,10 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <unistd.h>
+#include <fcntl.h>
 #include <sys/ioctl.h>
+#include <uuid/uuid.h>
 
 #include "ctree.h"
 #include "send-utils.h"
@@ -26,6 +29,136 @@
 static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
 				      u64 subvol_id);
 
+static int btrfs_get_root_id_by_sub_path(int mnt_fd, const char *sub_path,
+					 u64 *root_id)
+{
+	int ret;
+	int subvol_fd;
+
+	subvol_fd = openat(mnt_fd, sub_path, O_RDONLY);
+	if (subvol_fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: open %s failed. %s\n", sub_path,
+			strerror(-ret));
+		return ret;
+	}
+
+	ret = btrfs_list_get_path_rootid(subvol_fd, root_id);
+	close(subvol_fd);
+	return ret;
+}
+
+static int btrfs_read_root_item_raw(int mnt_fd, u64 root_id, size_t buf_len,
+				    u32 *read_len, void *buf)
+{
+	int ret;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header *sh;
+	unsigned long off = 0;
+	int found = 0;
+	int i;
+
+	*read_len = 0;
+	memset(&args, 0, sizeof(args));
+
+	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
+
+	/*
+	 * there may be more than one ROOT_ITEM key if there are
+	 * snapshots pending deletion, we have to loop through
+	 * them.
+	 */
+	sk->min_objectid = root_id;
+	sk->max_objectid = root_id;
+	sk->max_type = BTRFS_ROOT_ITEM_KEY;
+	sk->min_type = BTRFS_ROOT_ITEM_KEY;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+	sk->nr_items = 4096;
+
+	while (1) {
+		ret = ioctl(mnt_fd, BTRFS_IOC_TREE_SEARCH, &args);
+		if (ret < 0) {
+			fprintf(stderr,
+				"ERROR: can't perform the search - %s\n",
+				strerror(errno));
+			return 0;
+		}
+		/* the ioctl returns the number of item it found in nr_items */
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+		for (i = 0; i < sk->nr_items; i++) {
+			struct btrfs_root_item *item;
+			sh = (struct btrfs_ioctl_search_header *)(args.buf +
+								  off);
+
+			off += sizeof(*sh);
+			item = (struct btrfs_root_item *)(args.buf + off);
+			off += sh->len;
+
+			sk->min_objectid = sh->objectid;
+			sk->min_type = sh->type;
+			sk->min_offset = sh->offset;
+
+			if (sh->objectid > root_id)
+				break;
+
+			if (sh->objectid == root_id &&
+			    sh->type == BTRFS_ROOT_ITEM_KEY) {
+				if (sh->len > buf_len) {
+					/* btrfs-progs is too old for kernel */
+					fprintf(stderr,
+						"ERROR: buf for read_root_item_raw() is too small, get newer btrfs tools!\n");
+					return -EOVERFLOW;
+				}
+				memcpy(buf, item, sh->len);
+				*read_len = sh->len;
+				found = 1;
+			}
+		}
+		if (sk->min_offset < (u64)-1)
+			sk->min_offset++;
+		else
+			break;
+
+		if (sk->min_type != BTRFS_ROOT_ITEM_KEY ||
+		    sk->min_objectid != root_id)
+			break;
+	}
+
+	return found ? 0 : -ENOENT;
+}
+
+/*
+ * Read a root item from the tree. In case we detect a root item smaller then
+ * sizeof(root_item), we know it's an old version of the root structure and
+ * initialize all new fields to zero. The same happens if we detect mismatching
+ * generation numbers as then we know the root was once mounted with an older
+ * kernel that was not aware of the root item structure change.
+ */
+static int btrfs_read_root_item(int mnt_fd, u64 root_id,
+				struct btrfs_root_item *item)
+{
+	int ret;
+	u32 read_len;
+
+	ret = btrfs_read_root_item_raw(mnt_fd, root_id, sizeof(*item),
+				       &read_len, item);
+	if (ret)
+		return ret;
+
+	if (read_len < sizeof(*item) ||
+	    btrfs_root_generation(item) != btrfs_root_generation_v2(item))
+		memset(&item->generation_v2, 0,
+			sizeof(*item) - offsetof(struct btrfs_root_item,
+						 generation_v2));
+
+	return 0;
+}
+
 int btrfs_subvolid_resolve(int fd, char *path, size_t path_len, u64 subvol_id)
 {
 	if (path_len < 1)
@@ -122,142 +255,13 @@ static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
 	return 0;
 }
 
-static struct rb_node *tree_insert(struct rb_root *root,
-				   struct subvol_info *si,
-				   enum subvol_search_type type)
-{
-	struct rb_node ** p = &root->rb_node;
-	struct rb_node * parent = NULL;
-	struct subvol_info *entry;
-	__s64 comp;
-
-	while(*p) {
-		parent = *p;
-		if (type == subvol_search_by_received_uuid) {
-			entry = rb_entry(parent, struct subvol_info,
-					rb_received_node);
-
-			comp = memcmp(entry->received_uuid, si->received_uuid,
-					BTRFS_UUID_SIZE);
-			if (!comp) {
-				if (entry->stransid < si->stransid)
-					comp = -1;
-				else if (entry->stransid > si->stransid)
-					comp = 1;
-				else
-					comp = 0;
-			}
-		} else if (type == subvol_search_by_uuid) {
-			entry = rb_entry(parent, struct subvol_info,
-					rb_local_node);
-			comp = memcmp(entry->uuid, si->uuid, BTRFS_UUID_SIZE);
-		} else if (type == subvol_search_by_root_id) {
-			entry = rb_entry(parent, struct subvol_info,
-					rb_root_id_node);
-			comp = entry->root_id - si->root_id;
-		} else if (type == subvol_search_by_path) {
-			entry = rb_entry(parent, struct subvol_info,
-					rb_path_node);
-			comp = strcmp(entry->path, si->path);
-		} else {
-			BUG();
-		}
-
-		if (comp < 0)
-			p = &(*p)->rb_left;
-		else if (comp > 0)
-			p = &(*p)->rb_right;
-		else
-			return parent;
-	}
-
-	if (type == subvol_search_by_received_uuid) {
-		rb_link_node(&si->rb_received_node, parent, p);
-		rb_insert_color(&si->rb_received_node, root);
-	} else if (type == subvol_search_by_uuid) {
-		rb_link_node(&si->rb_local_node, parent, p);
-		rb_insert_color(&si->rb_local_node, root);
-	} else if (type == subvol_search_by_root_id) {
-		rb_link_node(&si->rb_root_id_node, parent, p);
-		rb_insert_color(&si->rb_root_id_node, root);
-	} else if (type == subvol_search_by_path) {
-		rb_link_node(&si->rb_path_node, parent, p);
-		rb_insert_color(&si->rb_path_node, root);
-	}
-	return NULL;
-}
-
-static struct subvol_info *tree_search(struct rb_root *root,
-				       u64 root_id, const u8 *uuid,
-				       u64 stransid, const char *path,
-				       enum subvol_search_type type)
-{
-	struct rb_node * n = root->rb_node;
-	struct subvol_info *entry;
-	__s64 comp;
-
-	while(n) {
-		if (type == subvol_search_by_received_uuid) {
-			entry = rb_entry(n, struct subvol_info,
-					rb_received_node);
-			comp = memcmp(entry->received_uuid, uuid,
-					BTRFS_UUID_SIZE);
-			if (!comp) {
-				if (entry->stransid < stransid)
-					comp = -1;
-				else if (entry->stransid > stransid)
-					comp = 1;
-				else
-					comp = 0;
-			}
-		} else if (type == subvol_search_by_uuid) {
-			entry = rb_entry(n, struct subvol_info, rb_local_node);
-			comp = memcmp(entry->uuid, uuid, BTRFS_UUID_SIZE);
-		} else if (type == subvol_search_by_root_id) {
-			entry = rb_entry(n, struct subvol_info, rb_root_id_node);
-			comp = entry->root_id - root_id;
-		} else if (type == subvol_search_by_path) {
-			entry = rb_entry(n, struct subvol_info, rb_path_node);
-			comp = strcmp(entry->path, path);
-		} else {
-			BUG();
-		}
-		if (comp < 0)
-			n = n->rb_left;
-		else if (comp > 0)
-			n = n->rb_right;
-		else
-			return entry;
-	}
-	return NULL;
-}
-
-static int count_bytes(void *buf, int len, char b)
-{
-	int cnt = 0;
-	int i;
-	for (i = 0; i < len; i++) {
-		if (((char*)buf)[i] == b)
-			cnt++;
-	}
-	return cnt;
-}
-
 void subvol_uuid_search_add(struct subvol_uuid_search *s,
 			    struct subvol_info *si)
 {
-	int cnt;
-
-	tree_insert(&s->root_id_subvols, si, subvol_search_by_root_id);
-	tree_insert(&s->path_subvols, si, subvol_search_by_path);
-
-	cnt = count_bytes(si->uuid, BTRFS_UUID_SIZE, 0);
-	if (cnt != BTRFS_UUID_SIZE)
-		tree_insert(&s->local_subvols, si, subvol_search_by_uuid);
-	cnt = count_bytes(si->received_uuid, BTRFS_UUID_SIZE, 0);
-	if (cnt != BTRFS_UUID_SIZE)
-		tree_insert(&s->received_subvols, si,
-				subvol_search_by_received_uuid);
+	if (si) {
+		free(si->path);
+		free(si);
+	}
 }
 
 struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
@@ -265,166 +269,71 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 				       const char *path,
 				       enum subvol_search_type type)
 {
-	struct rb_root *root;
-	if (type == subvol_search_by_received_uuid)
-		root = &s->received_subvols;
-	else if (type == subvol_search_by_uuid)
-		root = &s->local_subvols;
-	else if (type == subvol_search_by_root_id)
-		root = &s->root_id_subvols;
-	else if (type == subvol_search_by_path)
-		root = &s->path_subvols;
-	else
-		return NULL;
-	return tree_search(root, root_id, uuid, transid, path, type);
-}
-
-int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
-{
-	int ret;
-	struct btrfs_ioctl_search_args args;
-	struct btrfs_ioctl_search_key *sk = &args.key;
-	struct btrfs_ioctl_search_header *sh;
-	struct btrfs_root_item *root_item_ptr;
+	int ret = 0;
 	struct btrfs_root_item root_item;
-	struct subvol_info *si = NULL;
-	int root_item_valid = 0;
-	unsigned long off = 0;
-	int i;
-	int e;
-	char *path;
-
-	memset(&args, 0, sizeof(args));
-
-	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
-
-	sk->max_objectid = (u64)-1;
-	sk->max_offset = (u64)-1;
-	sk->max_transid = (u64)-1;
-	sk->min_type = BTRFS_ROOT_ITEM_KEY;
-	sk->max_type = BTRFS_ROOT_BACKREF_KEY;
-	sk->nr_items = 4096;
-
-	while(1) {
-		ret = ioctl(mnt_fd, BTRFS_IOC_TREE_SEARCH, &args);
-		e = errno;
-		if (ret < 0) {
-			fprintf(stderr, "ERROR: can't perform the search- %s\n",
-				strerror(e));
-			return ret;
-		}
-		if (sk->nr_items == 0)
-			break;
-
-		off = 0;
-
-		for (i = 0; i < sk->nr_items; i++) {
-			sh = (struct btrfs_ioctl_search_header *)(args.buf +
-								  off);
-			off += sizeof(*sh);
-
-			if ((sh->objectid != 5 &&
-			    sh->objectid < BTRFS_FIRST_FREE_OBJECTID) ||
-			    sh->objectid > BTRFS_LAST_FREE_OBJECTID)
-				goto skip;
-
-			if (sh->type == BTRFS_ROOT_ITEM_KEY) {
-				/* older kernels don't have uuids+times */
-				if (sh->len < sizeof(root_item)) {
-					root_item_valid = 0;
-					goto skip;
-				}
-				root_item_ptr = (struct btrfs_root_item *)
-						(args.buf + off);
-				memcpy(&root_item, root_item_ptr,
-						sizeof(root_item));
-				root_item_valid = 1;
-			} else if (sh->type == BTRFS_ROOT_BACKREF_KEY ||
-				   root_item_valid) {
-				if (!root_item_valid)
-					goto skip;
-
-				path = btrfs_list_path_for_root(mnt_fd,
-								sh->objectid);
-				if (!path)
-					path = strdup("");
-				if (IS_ERR(path)) {
-					ret = PTR_ERR(path);
-					fprintf(stderr, "ERROR: unable to "
-							"resolve path "
-							"for root %llu\n",
-							sh->objectid);
-					goto out;
-				}
-
-				si = calloc(1, sizeof(*si));
-				si->root_id = sh->objectid;
-				memcpy(si->uuid, root_item.uuid,
-						BTRFS_UUID_SIZE);
-				memcpy(si->parent_uuid, root_item.parent_uuid,
-						BTRFS_UUID_SIZE);
-				memcpy(si->received_uuid,
-						root_item.received_uuid,
-						BTRFS_UUID_SIZE);
-				si->ctransid = btrfs_root_ctransid(&root_item);
-				si->otransid = btrfs_root_otransid(&root_item);
-				si->stransid = btrfs_root_stransid(&root_item);
-				si->rtransid = btrfs_root_rtransid(&root_item);
-				si->path = path;
-				subvol_uuid_search_add(s, si);
-				root_item_valid = 0;
-			} else {
-				goto skip;
-			}
-
-skip:
-			off += sh->len;
+	struct subvol_info *info = NULL;
+
+	switch (type) {
+	case subvol_search_by_received_uuid:
+		ret = btrfs_lookup_uuid_received_subvol_item(s->mnt_fd, uuid,
+							     &root_id);
+		break;
+	case subvol_search_by_uuid:
+		ret = btrfs_lookup_uuid_subvol_item(s->mnt_fd, uuid, &root_id);
+		break;
+	case subvol_search_by_root_id:
+		break;
+	case subvol_search_by_path:
+		ret = btrfs_get_root_id_by_sub_path(s->mnt_fd, path, &root_id);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
 
-			/*
-			 * record the mins in sk so we can make sure the
-			 * next search doesn't repeat this root
-			 */
-			sk->min_objectid = sh->objectid;
-			sk->min_offset = sh->offset;
-			sk->min_type = sh->type;
-		}
-		sk->nr_items = 4096;
-		if (sk->min_offset < (u64)-1)
-			sk->min_offset++;
-		else if (sk->min_objectid < (u64)-1) {
-			sk->min_objectid++;
-			sk->min_offset = 0;
-			sk->min_type = 0;
-		} else
-			break;
+	if (ret)
+		goto out;
+
+	ret = btrfs_read_root_item(s->mnt_fd, root_id, &root_item);
+	if (ret)
+		goto out;
+
+	info = calloc(1, sizeof(*info));
+	info->root_id = root_id;
+	memcpy(info->uuid, root_item.uuid, BTRFS_UUID_SIZE);
+	memcpy(info->received_uuid, root_item.received_uuid, BTRFS_UUID_SIZE);
+	memcpy(info->parent_uuid, root_item.parent_uuid, BTRFS_UUID_SIZE);
+	info->ctransid = btrfs_root_ctransid(&root_item);
+	info->otransid = btrfs_root_otransid(&root_item);
+	info->stransid = btrfs_root_stransid(&root_item);
+	info->rtransid = btrfs_root_rtransid(&root_item);
+	if (type == subvol_search_by_path) {
+		info->path = strdup(path);
+	} else {
+		info->path = malloc(BTRFS_PATH_NAME_MAX);
+		ret = btrfs_subvolid_resolve(s->mnt_fd, info->path,
+					     BTRFS_PATH_NAME_MAX, root_id);
 	}
 
 out:
-	return ret;
+	if (ret && info) {
+		free(info->path);
+		free(info);
+		info = NULL;
+	}
+
+	return info;
 }
 
-/*
- * It's safe to call this function even without the subvol_uuid_search_init()
- * call before as long as the subvol_uuid_search structure is all-zero.
- */
-void subvol_uuid_search_finit(struct subvol_uuid_search *s)
+int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 {
-	struct rb_root *root = &s->root_id_subvols;
-	struct rb_node *node;
-
-	while ((node = rb_first(root))) {
-		struct subvol_info *entry =
-			rb_entry(node, struct subvol_info, rb_root_id_node);
+	s->mnt_fd = mnt_fd;
 
-		free(entry->path);
-		rb_erase(node, root);
-		free(entry);
-	}
+	return 0;
+}
 
-	s->root_id_subvols = RB_ROOT;
-	s->local_subvols = RB_ROOT;
-	s->received_subvols = RB_ROOT;
-	s->path_subvols = RB_ROOT;
+void subvol_uuid_search_finit(struct subvol_uuid_search *s)
+{
 }
 
 char *path_cat(const char *p1, const char *p2)
@@ -441,7 +350,6 @@ char *path_cat(const char *p1, const char *p2)
 	return new;
 }
 
-
 char *path_cat3(const char *p1, const char *p2, const char *p3)
 {
 	int p1_len = strlen(p1);
@@ -458,4 +366,3 @@ char *path_cat3(const char *p1, const char *p2, const char *p3)
 	sprintf(new, "%.*s/%.*s/%.*s", p1_len, p1, p2_len, p2, p3_len, p3);
 	return new;
 }
-
diff --git a/send-utils.h b/send-utils.h
index 06af75f..ed1a40e 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -38,10 +38,6 @@ enum subvol_search_type {
 };
 
 struct subvol_info {
-	struct rb_node rb_root_id_node;
-	struct rb_node rb_local_node;
-	struct rb_node rb_received_node;
-	struct rb_node rb_path_node;
 	u64 root_id;
 	u8 uuid[BTRFS_UUID_SIZE];
 	u8 parent_uuid[BTRFS_UUID_SIZE];
@@ -55,10 +51,7 @@ struct subvol_info {
 };
 
 struct subvol_uuid_search {
-	struct rb_root root_id_subvols;
-	struct rb_root local_subvols;
-	struct rb_root received_subvols;
-	struct rb_root path_subvols;
+	int mnt_fd;
 };
 
 int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s);
-- 
1.8.2.2

