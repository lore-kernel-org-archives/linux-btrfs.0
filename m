Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61213 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab2JDP74 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2012 11:59:56 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so613698obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Oct 2012 08:59:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50602781.9010009@jan-o-sch.net>
References: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com>
	<CAHf9xvaH6HoapVVqdTAXdFAZsEfvN7-xjoGtj31Lw=fUbY3LXA@mail.gmail.com>
	<50602781.9010009@jan-o-sch.net>
Date: Thu, 4 Oct 2012 17:59:54 +0200
Message-ID: <CAHf9xvY1TSNa-zY82whUrK6DtnFYiNx1BEF6R1kGQj1HU+wbxA@mail.gmail.com>
Subject: Re: btrfs send/receive review by vfs folks
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, Alexander Block <ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,
as I promised, here is some code for you to look at.

First I will describe the approach in general.

# Get rid of the pipe. Instead, user-space passes a buffer and kernel
fills the specified user-space buffer with commands.
# When the buffer is full, kernel stops generating commands and
returns a checkpoint to the user-space.
# User-space does whatever it wants with the returned buffer, and then
calls the kernel again, with a buffer and a checkpoint that was
returned by the kernel from previous SEND ioctl().
# Kernel re-arms itself to the specified checkpoint, and fills the
specified buffer with commands, attaches a new checkpoint and so on.
# Eventually kernel signals to the user that there are no more commands.

I realize this is a big change, and a new IOCTL has to be introduced
in order not to break current user-kernel protocol.
The pros as I see them:
# One data-copy is avoided (no pipe). For WRITE commands two
data-copies are avoided (no read_buf needed)
# ERESTARTSYS issue disappears. If needed, ioctl is restarted, but
there is no problem with that, it will simply refill the buffer from
the same checkpoint.
Cons:
# Instead of one ioctl(), many ioctls() are issued to finish the send.
# Big code change

Checkpoint details:
# Checkpoint is supported both on full-send and diff-send.
# Kernel cannot produce a checkpoint between any two commands. This is
because kernel handles a context like sctx->cur_ino,
sctx->new_refs/deleted_refs etc. (Part of the context becomes part of
the checkpoint, but new_refs/deleted_refs are not). To address this:
kernel remembers how many commands it issued since the latest
checkpoint, and after re-arming to it, it can skip the required number
of commands.
# WRITE command can be broken, if the WRITE does not fit in the user
buffer. After re-arming, the required part of the WRITE is properly
skipped.
# non-WRITE commands cannot be broken
# To user-space, a checkpoint is a blob. However, currently user-space
sees it as well, for easier debugging.
# Checkpoint is envisioned to be able to be persisted on-disk by
user-space, sent over network etc, that's why it is "packed" and in
little endian. With proper user-space support in the future, user will
be able to resume broken full-sends or diff-sends.

Testing:
# I am comparing byte-to-byte the stream that the new code produces vs
original send-stream (for now I introduced a new IOCTL for
send-with-checkpoint). WRITE commands are checked byte-byte based on
offset/length. This is because original code and new code break WRITEs
in different places. Still, all WRITE data is compared.
# I have an option to force the kernel to produce only one command
each time (i.e., pretend that user buffer is really small and can
accommodate only one command). In this way I test re-arming to each
possible point in the send-stream. Then do byte-to-byte comparison
with original stream. This mode is, of course, for testing only.

Code:
# Below is code based on Chris's send-recv branch.
# The code below uses the original send ioctl, and is, therefore,
incompatible with the old pipe-based user-space.
# The code below as-is was not run, it is only to demonstrate the
concept and implementation. I performed my testing on a different
branch that supports both IOCTLs, and is based on a different Chris's
branch (but has latest send-recv code).

Thanks for taking time reading up to here (hopefully). I appreciate
any comments on the code.
Alex.



diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
old mode 100644
new mode 100755
index fcc8c21..4e1049a
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5165,6 +5165,135 @@ static int tree_compare_item(struct btrfs_root
*left_root,
 #define ADVANCE 1
 #define ADVANCE_ONLY_NEXT -1

+static /*const*/ struct btrfs_key s_key_tree_end_reached = {
+	.objectid = (u64)-1,
+	.type	  = (u8)-1,
+	.offset   = (u64)-1
+};
+
+/*
+ * Generate a tree comparison checkpoint, suitable for being sent over network,
+ * written to disk etc.
+ * Returns the same 'cp' pointer that was passed.
+ */
+struct btrfs_compare_trees_checkpoint*
+btrfs_compare_trees_gen_checkpoint(struct btrfs_compare_trees_checkpoint *cp,
+							 struct btrfs_key *left_key, int left_end_reached,
+							 struct btrfs_key *right_key, int right_end_reached)
+{
+	if (left_end_reached) {
+		cp->left_key__objectid = cpu_to_le64(s_key_tree_end_reached.objectid);
+		cp->left_key__type     = s_key_tree_end_reached.type;
+		cp->left_key__offset   = cpu_to_le64(s_key_tree_end_reached.offset);
+	} else {
+		cp->left_key__objectid = cpu_to_le64(left_key->objectid);
+		cp->left_key__type     = left_key->type;
+		cp->left_key__offset   = cpu_to_le64(left_key->offset);
+	}
+
+	if (right_end_reached) {
+		cp->right_key__objectid = cpu_to_le64(s_key_tree_end_reached.objectid);
+		cp->right_key__type	    = s_key_tree_end_reached.type;
+		cp->right_key__offset   = cpu_to_le64(s_key_tree_end_reached.offset);
+	} else {
+		cp->right_key__objectid = cpu_to_le64(right_key->objectid);
+		cp->right_key__type	    = right_key->type;
+		cp->right_key__offset   = cpu_to_le64(right_key->offset);
+	}
+
+	return cp;
+}
+
+static int btrfs_compare_trees_rearm_to_tree_end(struct btrfs_root *root,
+	/* Output goes here */
+	struct btrfs_path *path,
+	struct btrfs_key *key, int *level, int *end_reached)
+{
+	int ret = 0;
+	struct btrfs_key search_key = s_key_tree_end_reached;
+
+	ret = btrfs_search_slot(NULL, root, &search_key, path, 0/*ins_len*/,
0/*cow*/);
+	if (ret > 0) {
+		*key = s_key_tree_end_reached;                  /* doesn't really
matter in this case */
+		*level = btrfs_header_level(root->commit_root); /* doesn't really
matter in this case */
+		*end_reached = ADVANCE;
+		ret = 0;
+	} else {
+		ret = -EILSEQ;
+	}
+
+	return ret;
+}
+
+static int btrfs_compare_trees_rearm_to_item(struct btrfs_root *root,
struct btrfs_key *rearm_key,
+	/* Output goes here */
+	struct btrfs_path *path,
+	struct btrfs_key *key, int *level, int *end_reached)
+{
+	int ret = 0;
+	struct btrfs_key search_key = *rearm_key;
+
+	ret = btrfs_search_slot(NULL, root, &search_key, path, 0/*ins_len*/,
0/*cow*/);
+	if (ret != 0) {
+		/* We should be able to find the key */
+		ret = -EILSEQ;
+	} else {
+		*key = *rearm_key;
+		*level = 0; /* We found the item, so we're on level 0 */
+		*end_reached = 0;
+	}
+
+	return ret;
+}
+
+static int btrfs_compare_trees_rearm_cp(struct
btrfs_compare_trees_checkpoint *cp,
+	struct btrfs_root *left_root, struct btrfs_root *right_root,
+	/* Output goes here */
+	struct btrfs_path *left_path, struct btrfs_path *right_path,
+	struct btrfs_key *left_key, int *left_level, int *left_end_reached,
+	struct btrfs_key *right_key, int *right_level, int *right_end_reached)
+{
+	int ret = 0;
+	struct btrfs_key rearm_key;
+
+	/* rearm left tree */
+	rearm_key.objectid = le64_to_cpu(cp->left_key__objectid);
+	rearm_key.type     = cp->left_key__type;
+	rearm_key.offset   = le64_to_cpu(cp->left_key__offset);
+	if (btrfs_comp_cpu_keys(&rearm_key, &s_key_tree_end_reached) == 0) {
+		ret = btrfs_compare_trees_rearm_to_tree_end(left_root,
+				/* output */
+				left_path,
+				left_key, left_level, left_end_reached);
+	} else {
+		ret = btrfs_compare_trees_rearm_to_item(left_root, &rearm_key,
+				/* output */
+				left_path,
+				left_key, left_level, left_end_reached);
+	}
+	if (ret)
+		goto out;
+
+	/* rearm right tree */
+	rearm_key.objectid = le64_to_cpu(cp->right_key__objectid);
+	rearm_key.type	   = cp->right_key__type;
+	rearm_key.offset   = le64_to_cpu(cp->right_key__offset);
+	if (btrfs_comp_cpu_keys(&rearm_key, &s_key_tree_end_reached) == 0) {
+		ret = btrfs_compare_trees_rearm_to_tree_end(right_root,
+				/* output */
+				right_path,
+				right_key, right_level, right_end_reached);
+	} else {
+		ret = btrfs_compare_trees_rearm_to_item(right_root, &rearm_key,
+				/* output */
+				right_path,
+				right_key, right_level, right_end_reached);
+	}
+
+out:
+	return ret;
+}
+
 /*
  * This function compares two trees and calls the provided callback for
  * every changed/new/deleted item it finds.
@@ -5180,6 +5309,7 @@ static int tree_compare_item(struct btrfs_root *left_root,
  */
 int btrfs_compare_trees(struct btrfs_root *left_root,
 			struct btrfs_root *right_root,
+			struct btrfs_compare_trees_checkpoint *tree_cp,
 			btrfs_changed_cb_t changed_cb, void *ctx)
 {
 	int ret;
@@ -5203,6 +5333,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 	u64 left_start_ctransid;
 	u64 right_start_ctransid;
 	u64 ctransid;
+	struct btrfs_compare_trees_checkpoint curr_cp;

 	left_path = btrfs_alloc_path();
 	if (!left_path) {
@@ -5277,30 +5408,44 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 	 *   the right if possible or go up and right.
 	 */

-	left_level = btrfs_header_level(left_root->commit_root);
-	left_root_level = left_level;
-	left_path->nodes[left_level] = left_root->commit_root;
-	extent_buffer_get(left_path->nodes[left_level]);
+	if (tree_cp == NULL) {
+		left_level = btrfs_header_level(left_root->commit_root);
+		left_root_level = left_level;
+		left_path->nodes[left_level] = left_root->commit_root;
+		extent_buffer_get(left_path->nodes[left_level]);

-	right_level = btrfs_header_level(right_root->commit_root);
-	right_root_level = right_level;
-	right_path->nodes[right_level] = right_root->commit_root;
-	extent_buffer_get(right_path->nodes[right_level]);
+		right_level = btrfs_header_level(right_root->commit_root);
+		right_root_level = right_level;
+		right_path->nodes[right_level] = right_root->commit_root;
+		extent_buffer_get(right_path->nodes[right_level]);

-	if (left_level == 0)
-		btrfs_item_key_to_cpu(left_path->nodes[left_level],
-				&left_key, left_path->slots[left_level]);
-	else
-		btrfs_node_key_to_cpu(left_path->nodes[left_level],
-				&left_key, left_path->slots[left_level]);
-	if (right_level == 0)
-		btrfs_item_key_to_cpu(right_path->nodes[right_level],
-				&right_key, right_path->slots[right_level]);
-	else
-		btrfs_node_key_to_cpu(right_path->nodes[right_level],
-				&right_key, right_path->slots[right_level]);
+		if (left_level == 0)
+			btrfs_item_key_to_cpu(left_path->nodes[left_level],
+					&left_key, left_path->slots[left_level]);
+		else
+			btrfs_node_key_to_cpu(left_path->nodes[left_level],
+					&left_key, left_path->slots[left_level]);
+		if (right_level == 0)
+			btrfs_item_key_to_cpu(right_path->nodes[right_level],
+					&right_key, right_path->slots[right_level]);
+		else
+			btrfs_node_key_to_cpu(right_path->nodes[right_level],
+					&right_key, right_path->slots[right_level]);

-	left_end_reached = right_end_reached = 0;
+		left_end_reached = right_end_reached = 0;
+	} else {
+		ret = btrfs_compare_trees_rearm_cp(tree_cp,
+					left_root, right_root,
+					/* output */
+					left_path, right_path,
+					&left_key, &left_level, &left_end_reached,
+					&right_key, &right_level, &right_end_reached);
+		if (ret)
+			goto out;
+		
+		left_root_level = btrfs_header_level(left_root->commit_root);
+		right_root_level = btrfs_header_level(right_root->commit_root);
+	}
 	advance_left = advance_right = 0;

 	while (1) {
@@ -5384,6 +5529,8 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 			advance_right = 0;
 		}

+		BUG_ON(!(advance_left == 0 && advance_right == 0));
+
 		if (left_end_reached && right_end_reached) {
 			ret = 0;
 			goto out;
@@ -5393,6 +5540,9 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 						left_path, right_path,
 						&right_key,
 						BTRFS_COMPARE_TREE_DELETED,
+						btrfs_compare_trees_gen_checkpoint(&curr_cp,
+							NULL/*left_key*/, ADVANCE/*left_end_reached*/,
+							&right_key, 0/*right_end_reached*/),
 						ctx);
 				if (ret < 0)
 					goto out;
@@ -5405,6 +5555,9 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 						left_path, right_path,
 						&left_key,
 						BTRFS_COMPARE_TREE_NEW,
+						btrfs_compare_trees_gen_checkpoint(&curr_cp,
+							&left_key, 0/*left_end_reached*/,
+							NULL/*right_key*/, ADVANCE/*right_end_reached*/),
 						ctx);
 				if (ret < 0)
 					goto out;
@@ -5414,12 +5567,18 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 		}

 		if (left_level == 0 && right_level == 0) {
+			/* All the cases here will have the same checkpoint */
+			btrfs_compare_trees_gen_checkpoint(&curr_cp,
+				&left_key, 0/*left_end_reached*/,
+				&right_key, 0/*right_end_reached*/);
+
 			cmp = btrfs_comp_cpu_keys(&left_key, &right_key);
 			if (cmp < 0) {
 				ret = changed_cb(left_root, right_root,
 						left_path, right_path,
 						&left_key,
 						BTRFS_COMPARE_TREE_NEW,
+						&curr_cp,
 						ctx);
 				if (ret < 0)
 					goto out;
@@ -5429,6 +5588,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 						left_path, right_path,
 						&right_key,
 						BTRFS_COMPARE_TREE_DELETED,
+						&curr_cp,
 						ctx);
 				if (ret < 0)
 					goto out;
@@ -5443,6 +5603,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 						left_path, right_path,
 						&left_key,
 						BTRFS_COMPARE_TREE_CHANGED,
+						&curr_cp,
 						ctx);
 					if (ret < 0)
 						goto out;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
old mode 100644
new mode 100755
index c38734a..a1e4282
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2945,9 +2945,15 @@ typedef int (*btrfs_changed_cb_t)(struct
btrfs_root *left_root,
 				  struct btrfs_path *right_path,
 				  struct btrfs_key *key,
 				  enum btrfs_compare_tree_result result,
+				  struct btrfs_compare_trees_checkpoint *tree_cp,
 				  void *ctx);
+struct btrfs_compare_trees_checkpoint*
+btrfs_compare_trees_gen_checkpoint(struct btrfs_compare_trees_checkpoint *cp,
+							 struct btrfs_key *left_key, int left_end_reached,
+							 struct btrfs_key *right_key, int right_end_reached);
 int btrfs_compare_trees(struct btrfs_root *left_root,
 			struct btrfs_root *right_root,
+			struct btrfs_compare_trees_checkpoint *tree_cp,
 			btrfs_changed_cb_t cb, void *ctx);
 int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, struct extent_buffer *buf,
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
old mode 100644
new mode 100755
index 731e287..60f32bb
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -363,11 +363,80 @@ struct btrfs_ioctl_received_subvol_args {
 	__u64	reserved[16];		/* in */
 };

+ /*
+  * This is a tree comparison checkpoint.
+  * This information is enough to rearm the tree comparison process
+  * to restart from the point where it was interrupted.
+  *
+  * This struct needs to be in strict endian and alignment, because
it is sent over network.
+  */
+struct btrfs_compare_trees_checkpoint {
+	__le64 left_key__objectid;
+	__u8   left_key__type;
+	__le64 left_key__offset;
+
+	__le64 right_key__objectid;
+	__u8   right_key__type;
+	__le64 right_key__offset;
+} __attribute__ ((__packed__));
+
+ /*
+  * This structure is used to restart the "send" stream
+  * from some previously checkpointed position.
+  * It needs strict endian and alignment, because it is sent over network.
+  */
+struct btrfs_send_checkpoint {
+	__le32 cp_size_bytes;
+ 	__le32 version;
+
+	/* Tree comparison checkpoint */
+	struct btrfs_compare_trees_checkpoint tree_cmp_cp;
+
+	/* Send context checkpoint */
+	__le64 cur_ino;
+	__le64 cur_inode_gen;
+	__u8   cur_inode_new;
+	__u8   cur_inode_new_gen;
+	__u8   cur_inode_deleted;
+	__le64 cur_inode_size;
+	__le64 cur_inode_mode;
+	__le64 send_progress;
+
+	/*
+	 * Kernel cannot produce a checkpoint between any two commands, so
+	 * this allows us to skip the required number of commands since
+	 * the previous checkpoint.
+	 * Also, if the last command was a large WRITE command, but we can send
+	 * only a part of it, and later send the remainder.
+	 */
+	__le32 n_cmds_since_cp;
+ 	__le32 offset_in_write_cmd_bytes;
+
+} __attribute__ ((__packed__));
+
+#define BTRFS_SEND_CHECKPOINT_VERSION 1
+
+#define BTRFS_HAS_TREE_CMP_CHECKPOINT(tree_cp)           \
+	((le64_to_cpu((tree_cp)->left_key__objectid) != 0) && \
+	 (le64_to_cpu((tree_cp)->right_key__objectid) != 0))
+
+#define BTRFS_HAS_SEND_CHECKPOINT(cp)
BTRFS_HAS_TREE_CMP_CHECKPOINT(&((cp)->tree_cmp_cp))
+
 struct btrfs_ioctl_send_args {
-	__s64 send_fd;			/* in */
+	__u8 __user *send_buffer;                     /* in/out: this buffer
will be filled with commands by kernel */
+	__u32 send_buffer_size_bytes;                 /* in:  the size of
send_buffer */
+	                                              /* out: the amount of
valid data on successful completion */
+
 	__u64 clone_sources_count;	/* in */
 	__u64 __user *clone_sources;	/* in */
 	__u64 parent_root;		/* in */
+
+	struct btrfs_send_checkpoint __user *in_cp;   /* in: checkpoint,
kernel must check the version and size */
+	__u32 in_cp_size_bytes;                       /* in: the size of the
checkpoint buffer */
+
+	struct btrfs_send_checkpoint out_cp;          /* out: the checkpoint
for the next batch of commands */
+	__u8 end_of_data;                             /* out: whether we
have pulled the last batch */
+	
 	__u64 flags;			/* in */
 	__u64 reserved[4];		/* in */
 };
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
old mode 100644
new mode 100755
index 760390f..b4bf56c
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -77,14 +77,30 @@ struct clone_root {
 #define SEND_CTX_NAME_CACHE_CLEAN_SIZE (SEND_CTX_MAX_NAME_CACHE_SIZE * 2)

 struct send_ctx {
-	struct file *send_filp;
-	loff_t send_off;
 	char *send_buf;
 	u32 send_size;
 	u32 send_max_size;
 	u64 total_send_size;
 	u64 cmd_send_size[BTRFS_SEND_C_MAX + 1];

+	/* How many commands/bytes we need to skip, before we can start
sending new commands */
+	u32 n_cmds_to_skip;
+	u32 offset_in_write_cmd_bytes_to_skip;
+
+	/* Our current checkpoint */
+	struct btrfs_send_checkpoint curr_cp;
+
+	/* User buffer to be filled with data and how much data there already is */
+	u8 __user *out_buffer;
+	u32 out_buffer_size_bytes;
+	u32 out_buffer_data_bytes;
+
+	/*
+	 * We set this to 1, when we cannot put more data into the user buffer,
+	 * and we return -EOVERFLOW.
+	 */
+	u8 out_buffer_full;
+
 	struct vfsmount *mnt;

 	struct btrfs_root *send_root;
@@ -119,7 +135,6 @@ struct send_ctx {
 	int name_cache_size;

 	struct file *cur_inode_filp;
-	char *read_buf;
 };

 struct name_cache_entry {
@@ -385,38 +400,6 @@ static struct btrfs_path *alloc_path_for_send(void)
 	return path;
 }

-static int write_buf(struct send_ctx *sctx, const void *buf, u32 len)
-{
-	int ret;
-	mm_segment_t old_fs;
-	u32 pos = 0;
-
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-
-	while (pos < len) {
-		ret = vfs_write(sctx->send_filp, (char *)buf + pos, len - pos,
-				&sctx->send_off);
-		/* TODO handle that correctly */
-		/*if (ret == -ERESTARTSYS) {
-			continue;
-		}*/
-		if (ret < 0)
-			goto out;
-		if (ret == 0) {
-			ret = -EIO;
-			goto out;
-		}
-		pos += ret;
-	}
-
-	ret = 0;
-
-out:
-	set_fs(old_fs);
-	return ret;
-}
-
 static int tlv_put(struct send_ctx *sctx, u16 attr, const void *data, int len)
 {
 	struct btrfs_tlv_header *hdr;
@@ -545,14 +528,66 @@ static int tlv_put_btrfs_timespec(struct
send_ctx *sctx, u16 attr,
 			goto tlv_put_failure; \
 	} while (0)

-static int send_header(struct send_ctx *sctx)
+
+		
+/*
+ * Command is ready on send_buf, and send_size is the total command size.
+ * Set up the correct length and command header and calculate CRC.
+ * Then copy the whole command to the user buffer.
+ */
+static int __finalize_cmd_hdr_and_copy_to_user(struct send_ctx *sctx)
 {
-	struct btrfs_stream_header hdr;
+	int ret = 0;
+	struct btrfs_cmd_header *hdr = (struct btrfs_cmd_header*)sctx->send_buf;
+	u32 crc = 0;

-	strcpy(hdr.magic, BTRFS_SEND_STREAM_MAGIC);
-	hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION);
+	hdr->len = cpu_to_le32(sctx->send_size - sizeof(struct btrfs_cmd_header));
+	hdr->crc = 0;
+
+	crc = crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
+	hdr->crc = cpu_to_le32(crc);

-	return write_buf(sctx, &hdr, sizeof(hdr));
+	ret = copy_to_user(sctx->out_buffer + sctx->out_buffer_data_bytes, /*to*/
+					   sctx->send_buf, sctx->send_size);
+	if (ret)
+		ret = -EFAULT;
+
+	return ret;
+}
+
+static void __cmd_fully_sent(struct send_ctx *sctx, u16 cmd, int skipped)
+{
+	/* Update our tracking info */
+	
+	sctx->curr_cp.n_cmds_since_cp =
cpu_to_le32(le32_to_cpu(sctx->curr_cp.n_cmds_since_cp) + 1);
+	/* Since the command was fully sent/skipped, let's be explicit and
reset this */
+	sctx->curr_cp.offset_in_write_cmd_bytes = cpu_to_le32(0);
+
+	if (skipped) {
+		BUG_ON(sctx->n_cmds_to_skip == 0);
+		--sctx->n_cmds_to_skip;
+		/* we must not touch offset_in_write_cmd_bytes_to_skip here */
+	} else {
+		/* If we are not skipping, we mustn't have any leftovers */
+		BUG_ON(sctx->n_cmds_to_skip > 0);
+			/*
+			 * If we have not skipped this command, then we must reset this,
+			 * because the command was processed fully, and we may be processing
+			 * more WRITE commands in this batch.
+			 */
+			sctx->offset_in_write_cmd_bytes_to_skip = 0;
+	}
+
+	if (!skipped)
+		sctx->out_buffer_data_bytes += sctx->send_size;
+		
+	/* Update general info */
+	if (!skipped) {
+		sctx->total_send_size += sctx->send_size;
+		if (cmd != BTRFS_SEND_C_UNSPEC) /* for stream header */
+			sctx->cmd_send_size[cmd] += sctx->send_size;
+	}
+	sctx->send_size = 0; /* This is most important - for next command */
 }

 /*
@@ -576,28 +611,84 @@ static int begin_cmd(struct send_ctx *sctx, int cmd)
 	return 0;
 }

-static int send_cmd(struct send_ctx *sctx)
+/*
+ * At this point the command header + data are already set up on send_buf,
+ * but the header does not include crc.
+ */
+static int send_non_write_or_stream_header(struct send_ctx *sctx, int header)
 {
-	int ret;
-	struct btrfs_cmd_header *hdr;
-	u32 crc;
+	int ret = 0;
+	u16 cmd = BTRFS_SEND_C_UNSPEC;
+	int skipped = 1;

-	hdr = (struct btrfs_cmd_header *)sctx->send_buf;
-	hdr->len = cpu_to_le32(sctx->send_size - sizeof(*hdr));
-	hdr->crc = 0;
+	if (!header)
+		cmd = le16_to_cpu(((struct btrfs_cmd_header*)sctx->send_buf)->cmd);

-	crc = crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
-	hdr->crc = cpu_to_le32(crc);
+	/* We shouldn't get here with a non-write command */
+	BUG_ON(cmd == BTRFS_SEND_C_WRITE);
+
+	if (sctx->n_cmds_to_skip == 0) {
+		/* We are going to push this command, so assert we have no
leftovers from skipping */
+		BUG_ON(sctx->n_cmds_to_skip > 0 ||
sctx->offset_in_write_cmd_bytes_to_skip > 0);

-	ret = write_buf(sctx, sctx->send_buf, sctx->send_size);
+		/* Sanity check on free space in our buffer */
+		BUG_ON(sctx->out_buffer_full || sctx->out_buffer_data_bytes >
sctx->out_buffer_size_bytes);

-	sctx->total_send_size += sctx->send_size;
-	sctx->cmd_send_size[le16_to_cpu(hdr->cmd)] += sctx->send_size;
-	sctx->send_size = 0;
+		/* Check if command can fit in the user buffer */
+		if (sctx->send_size > sctx->out_buffer_size_bytes -
sctx->out_buffer_data_bytes) {
+			/*
+			 * This command cannot be sent fully, and this is not a WRITE command,
+			 * so we must give up, because we cannot break non-WRITE commands.
+			 */
+			/* Signal that this is not a real overflow */
+			sctx->out_buffer_full = 1;
+			ret = -EOVERFLOW;
+			goto out;
+		}
+
+		/* Send */
+		if (!header) {
+			ret = __finalize_cmd_hdr_and_copy_to_user(sctx);
+		} else {
+			ret = copy_to_user(sctx->out_buffer + sctx->out_buffer_data_bytes,
+			                   sctx->send_buf, sctx->send_size);
+			if (ret)
+				ret = -EFAULT;
+		}
+		if (ret < 0)
+			goto out;
+
+		skipped = 0;
+	}

+	__cmd_fully_sent(sctx, cmd, skipped);
+
+#if 0
+	/* ---- For testing only --------- */
+	if (!skipped && cmd != BTRFS_SEND_C_END) {
+		sctx->out_buffer_full = 1;
+		ret = -EOVERFLOW;
+	}
+	/* ------------------------------- */
+#endif
+
+out:
 	return ret;
 }

+static int send_header(struct send_ctx *sctx)
+{
+	struct btrfs_stream_header hdr;
+
+	strcpy(hdr.magic, BTRFS_SEND_STREAM_MAGIC);
+	hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION);
+
+	memcpy(sctx->send_buf, &hdr, sizeof(hdr));
+	sctx->send_size = sizeof(hdr);
+
+	return send_non_write_or_stream_header(sctx, 1/*header*/);
+}
+
 /*
  * Sends a move instruction to user space
  */
@@ -615,7 +706,7 @@ verbose_printk("btrfs: send_rename %s -> %s\n",
from->start, to->start);
 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, from);
 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH_TO, to);

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);

 tlv_put_failure:
 out:
@@ -639,7 +730,7 @@ verbose_printk("btrfs: send_link %s -> %s\n",
path->start, lnk->start);
 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, path);
 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH_LINK, lnk);

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);

 tlv_put_failure:
 out:
@@ -661,7 +752,7 @@ verbose_printk("btrfs: send_unlink %s\n", path->start);

 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, path);

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);

 tlv_put_failure:
 out:
@@ -683,7 +774,7 @@ verbose_printk("btrfs: send_rmdir %s\n", path->start);

 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, path);

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);

 tlv_put_failure:
 out:
@@ -2208,7 +2299,7 @@ static int send_subvol_begin(struct send_ctx *sctx)
 				sctx->parent_root->root_item.ctransid);
 	}

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);

 tlv_put_failure:
 out:
@@ -2238,7 +2329,7 @@ verbose_printk("btrfs: send_truncate %llu
size=%llu\n", ino, size);
 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
 	TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, size);

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);

 tlv_put_failure:
 out:
@@ -2267,7 +2358,7 @@ verbose_printk("btrfs: send_chmod %llu
mode=%llu\n", ino, mode);
 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
 	TLV_PUT_U64(sctx, BTRFS_SEND_A_MODE, mode & 07777);

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);

 tlv_put_failure:
 out:
@@ -2297,7 +2388,7 @@ verbose_printk("btrfs: send_chown %llu uid=%llu,
gid=%llu\n", ino, uid, gid);
 	TLV_PUT_U64(sctx, BTRFS_SEND_A_UID, uid);
 	TLV_PUT_U64(sctx, BTRFS_SEND_A_GID, gid);

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);

 tlv_put_failure:
 out:
@@ -2354,7 +2445,7 @@ verbose_printk("btrfs: send_utimes %llu\n", ino);
 			btrfs_inode_ctime(ii));
 	/* TODO Add otime support when the otime patches get into upstream */

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);

 tlv_put_failure:
 out:
@@ -2429,7 +2520,7 @@ verbose_printk("btrfs: send_create_inode %llu\n", ino);
 		TLV_PUT_U64(sctx, BTRFS_SEND_A_RDEV, rdev);
 	}

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);
 	if (ret < 0)
 		goto out;

@@ -3257,7 +3348,7 @@ static int send_set_xattr(struct send_ctx *sctx,
 	TLV_PUT_STRING(sctx, BTRFS_SEND_A_XATTR_NAME, name, name_len);
 	TLV_PUT(sctx, BTRFS_SEND_A_XATTR_DATA, data, data_len);

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);

 tlv_put_failure:
 out:
@@ -3277,7 +3368,7 @@ static int send_remove_xattr(struct send_ctx *sctx,
 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, path);
 	TLV_PUT_STRING(sctx, BTRFS_SEND_A_XATTR_NAME, name, name_len);

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);

 tlv_put_failure:
 out:
@@ -3548,21 +3639,70 @@ out:
 }

 /*
- * Read some bytes from the current inode/file and send a write command to
- * user space.
+ * Setup the BTRFS_SEND_C_WRITE header, and all the TLVs, except
BTRFS_SEND_A_DATA.
+ * For BTRFS_SEND_A_DATA, set up only the TLV header with correct tlv_type, but
+ * no tlv_len yet.
  */
-static int send_write(struct send_ctx *sctx, u64 offset, u32 len)
+static int __setup_write_cmd_wo_data(struct send_ctx *sctx,
+				u64	 offset_in_file_bytes,
+				struct btrfs_tlv_header **out_hdr)
 {
 	int ret = 0;
-	struct fs_path *p;
-	loff_t pos = offset;
-	int num_read = 0;
-	mm_segment_t old_fs;
+	struct fs_path *p = NULL;

 	p = fs_path_alloc(sctx);
 	if (!p)
 		return -ENOMEM;

+	/* This sets up the command header */
+	ret = begin_cmd(sctx, BTRFS_SEND_C_WRITE);
+	if (ret < 0)
+		goto out;
+
+	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
+	if (ret < 0)
+		goto out;
+
+	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
+	TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset_in_file_bytes);
+
+	/* Set up TLV header for BTRFS_SEND_A_DATA */
+	{
+		struct btrfs_tlv_header *data_hdr = NULL;
+		u32 left = sctx->send_max_size - sctx->send_size;
+		
+		if (unlikely(left < sizeof(struct btrfs_tlv_header))) {
+			ret = -EOVERFLOW;
+			goto out;
+		}
+
+		data_hdr = (struct btrfs_tlv_header*)(sctx->send_buf + sctx->send_size);
+		data_hdr->tlv_type = cpu_to_le16(BTRFS_SEND_A_DATA);
+		*out_hdr = data_hdr;
+		
+		sctx->send_size += sizeof(struct btrfs_tlv_header);
+	}
+
+tlv_put_failure:
+out:
+	fs_path_free(sctx, p);
+	return ret;
+}
+
+/*
+ * Reads "nbytes_to_read" starting from "offset_in_file_bytes" from
the current inode onto send_buf+send_size.
+ * Upon successful completion, updates send_size.
+ */
+static int __fetch_write_cmd_data(struct send_ctx *sctx,
+				u64 offset_in_file_bytes,
+				u16 nbytes_to_read)
+{
+	int ret = 0;
+	mm_segment_t old_fs;
+	ssize_t nbytes_read = 0;
+
+	BUG_ON(nbytes_to_read == 0);
+
 	/*
 	 * vfs normally only accepts user space buffers for security reasons.
 	 * we only read from the file and also only provide the read_buf buffer
@@ -3572,40 +3712,157 @@ static int send_write(struct send_ctx *sctx,
u64 offset, u32 len)
 	old_fs = get_fs();
 	set_fs(KERNEL_DS);

-verbose_printk("btrfs: send_write offset=%llu, len=%d\n", offset, len);
-
 	ret = open_cur_inode_file(sctx);
 	if (ret < 0)
 		goto out;

-	ret = vfs_read(sctx->cur_inode_filp, sctx->read_buf, len, &pos);
+	while (nbytes_read < nbytes_to_read) {
+		loff_t pos = offset_in_file_bytes + nbytes_read;
+			
+		ret = vfs_read(sctx->cur_inode_filp,
+			           sctx->send_buf + sctx->send_size + nbytes_read,
+			           nbytes_to_read - nbytes_read,
+			           &pos);
+		if (ret < 0)
+			goto out;
+		if (ret == 0) {
+			/* This should not happen; we know there's data to read */
+			ret = -ENODATA;
+			goto out;
+		}
+
+		/* we got some data, keep reading */
+		nbytes_read += ret;
+	}
+
+	/* we got all the data */
+	sctx->send_size += nbytes_to_read;
+	ret = 0;
+
+out:
+	set_fs(old_fs);
+	
+	return ret;
+}
+
+
+/*
+ * Nothing has been set up on send_buf yet (so send_size==0).
+ * offset_in_file_bytes and len_bytes reflect the real file extent
+ * (not broken down to BTRFS_SEND_READ_SIZE or something like that).
+ */
+static int send_write(struct send_ctx *sctx, u64
offset_in_file_bytes, u64 len_bytes)
+{
+	static const u16 MAX_U16 = (u16)-1;
+
+	int ret = 0;
+	struct btrfs_tlv_header *data_hdr = NULL;
+	u16 nbytes_to_send = 0;
+
+	/* Check if we need to skip this command fully */
+	if (sctx->n_cmds_to_skip > 0) {
+		__cmd_fully_sent(sctx, BTRFS_SEND_C_WRITE, 1/*skipped*/);
+		goto out;
+	}
+
+	/* Check if we need to skip a part of this command */
+	if (sctx->offset_in_write_cmd_bytes_to_skip > 0) {
+		/* If we need to skip the full WRITE or more than the WRITE, this is a bug */
+		if (sctx->offset_in_write_cmd_bytes_to_skip >= len_bytes) {
+			ret = -EPROTO;
+			goto out;
+		}
+
+		offset_in_file_bytes += sctx->offset_in_write_cmd_bytes_to_skip;
+		len_bytes -= sctx->offset_in_write_cmd_bytes_to_skip;
+	}
+
+	/*
+	 * Set up command header and all TLVs, except for BTRFS_SEND_A_DATA;
+	 * for this TLV, set up only the TLV header.
+	 */
+	ret = __setup_write_cmd_wo_data(sctx, offset_in_file_bytes, &data_hdr);
 	if (ret < 0)
 		goto out;
-	num_read = ret;
-	if (!num_read)
+
+	/* Sanity check on free space in our buffer */
+	BUG_ON(sctx->out_buffer_full || sctx->out_buffer_data_bytes >
sctx->out_buffer_size_bytes);
+
+	/*
+	 * We need to be able to send command header, all TLVs and "some" data.
+	 * If we're unable, signal overflow.
+	 * BUT: if we had to skip part of this WRITE, we should be able to do this,
+	 * otherwise, this is a bug.
+	 * "Some" data should be a couple of bytes at least, like 8?
+	 */
+	if (sctx->send_size + 8 > sctx->out_buffer_size_bytes -
sctx->out_buffer_data_bytes) {
+		if (sctx->offset_in_write_cmd_bytes_to_skip > 0) {
+			/*
+			 * We should send a partial WRITE command, and it should be the first
+			 * command for this buffer. So we should be able to send *something*.
+			 */
+			ret = -EPROTO;
+			goto out;
+		}
+
+		/* Signal that this is not a real overflow */
+		sctx->out_buffer_full = 1;
+		ret = -EOVERFLOW;
 		goto out;
+	}

-	ret = begin_cmd(sctx, BTRFS_SEND_C_WRITE);
+	/* Check how much data we can actually send, note that it must not
be more than u16 */
+	nbytes_to_send = min3((u64)MAX_U16, len_bytes,
(u64)(sctx->out_buffer_size_bytes - sctx->out_buffer_data_bytes -
sctx->send_size));
+	ret = __fetch_write_cmd_data(sctx, offset_in_file_bytes, nbytes_to_send);
 	if (ret < 0)
 		goto out;
+	/* send_size reflects the full command at this point */

-	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
+	/* Now we can commit to sending "nbytes_to_send" worth of data! */
+	
+	/* We got the data, so finalize the TLV header of the WRITE command */
+	data_hdr->tlv_len = cpu_to_le16(nbytes_to_send);
+
+	/* Send the command */
+	ret = __finalize_cmd_hdr_and_copy_to_user(sctx);
 	if (ret < 0)
 		goto out;

-	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
-	TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
-	TLV_PUT(sctx, BTRFS_SEND_A_DATA, sctx->read_buf, num_read);
+	/* Update checkpoint-related info */
+	if (nbytes_to_send < len_bytes) {
+		/*
+		 * We haven't completed this WRITE, therefore, we cannot increment
n_cmds_since_cp.
+		 * We need to set offset_in_write_cmd_bytes correctly and signal to bail out.
+		 */
+		sctx->curr_cp.offset_in_write_cmd_bytes =
cpu_to_le32(sctx->offset_in_write_cmd_bytes_to_skip + nbytes_to_send);

-	ret = send_cmd(sctx);
+		/*
+		 * We are going to bail out here, so don't bother updating
+		 * n_cmds_to_skip/offset_in_write_cmd_bytes_to_skip here.
+		 * However, we still need to record that we sent some bytes.
+		 */
+		sctx->out_buffer_data_bytes += sctx->send_size;
+		
+		sctx->total_send_size += sctx->send_size;
+		sctx->cmd_send_size[BTRFS_SEND_C_WRITE] += sctx->send_size;
+		/* don't bother setting send_size to 0 here, we're bailing out */
+
+		/* Signal that this is not a real overflow */
+		sctx->out_buffer_full = 1;
+		ret = -EOVERFLOW;
+	} else {
+		__cmd_fully_sent(sctx, BTRFS_SEND_C_WRITE, 0/*skipped*/);
+
+#if 0
+		/* ---- For testing only --------- */
+		sctx->out_buffer_full = 1;
+		ret = -EOVERFLOW;
+		/* ------------------------------- */
+#endif
+	}

-tlv_put_failure:
 out:
-	fs_path_free(sctx, p);
-	set_fs(old_fs);
-	if (ret < 0)
-		return ret;
-	return num_read;
+	return ret;
 }

 /*
@@ -3661,7 +3918,7 @@ verbose_printk("btrfs: send_clone offset=%llu,
len=%d, clone_root=%llu, "
 	TLV_PUT_U64(sctx, BTRFS_SEND_A_CLONE_OFFSET,
 			clone_root->offset);

-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);

 tlv_put_failure:
 out:
@@ -3677,9 +3934,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 	int ret = 0;
 	struct btrfs_file_extent_item *ei;
 	u64 offset = key->offset;
-	u64 pos = 0;
 	u64 len;
-	u32 l;
 	u8 type;

 	ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
@@ -3704,22 +3959,10 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		goto out;
 	}

-	if (!clone_root) {
-		while (pos < len) {
-			l = len - pos;
-			if (l > BTRFS_SEND_READ_SIZE)
-				l = BTRFS_SEND_READ_SIZE;
-			ret = send_write(sctx, pos + offset, l);
-			if (ret < 0)
-				goto out;
-			if (!ret)
-				break;
-			pos += ret;
-		}
-		ret = 0;
-	} else {
+	if (!clone_root)
+		ret = send_write(sctx, offset, len);
+	else
 		ret = send_clone(sctx, offset, len, clone_root);
-	}

 out:
 	return ret;
@@ -4301,6 +4544,47 @@ static int changed_extent(struct send_ctx *sctx,
 	return ret;
 }

+static void record_checkpoint(struct send_ctx *sctx,
+				struct btrfs_compare_trees_checkpoint *tree_cp)
+{
+	struct btrfs_send_checkpoint old_cp;
+	struct btrfs_send_checkpoint *new_cp = &sctx->curr_cp;
+
+	/* Cannot take a checkpoint, if we have a context that we don't save */
+	if (!list_empty(&sctx->new_refs) || !list_empty(&sctx->deleted_refs))
+		return;
+
+	/* Take checkpoint */
+	old_cp = sctx->curr_cp;
+	new_cp->tree_cmp_cp               = *tree_cp;
+
+	new_cp->cur_ino                   = cpu_to_le64(sctx->cur_ino);
+	new_cp->cur_inode_gen             = cpu_to_le64(sctx->cur_inode_gen);
+	new_cp->cur_inode_new             = sctx->cur_inode_new;     /* u8 */
+	new_cp->cur_inode_new_gen         = sctx->cur_inode_new_gen; /* u8 */
+	new_cp->cur_inode_deleted         = sctx->cur_inode_deleted; /* u8 */
+	new_cp->cur_inode_size            = cpu_to_le64(sctx->cur_inode_size);
+	new_cp->cur_inode_mode            = cpu_to_le64(sctx->cur_inode_mode);
+	new_cp->send_progress             = cpu_to_le64(sctx->send_progress);
+
+	new_cp->n_cmds_since_cp           = cpu_to_le32(0);
+	new_cp->offset_in_write_cmd_bytes = cpu_to_le32(0);
+
+	/*
+	 * If the compare_tree checkpoint is identical and we have already produced
+	 * some commands, this is a bug.
+	 * If it's identical, but we haven't produced any commands, this is a warning.
+	 */
+	if (memcmp(&old_cp.tree_cmp_cp, &new_cp->tree_cmp_cp,
+		       sizeof(struct btrfs_compare_trees_checkpoint)) == 0) {
+		if (le32_to_cpu(old_cp.n_cmds_since_cp) > 0 ||
le32_to_cpu(old_cp.offset_in_write_cmd_bytes) > 0) {
+			BUG();
+		} else {
+			WARN_ON(1);
+		}
+	}
+}
+
 /*
  * Updates compare related fields in sctx and simply forwards to the actual
  * changed_xxx functions.
@@ -4311,6 +4595,7 @@ static int changed_cb(struct btrfs_root *left_root,
 		      struct btrfs_path *right_path,
 		      struct btrfs_key *key,
 		      enum btrfs_compare_tree_result result,
+		      struct btrfs_compare_trees_checkpoint *tree_cp,
 		      void *ctx)
 {
 	int ret = 0;
@@ -4320,6 +4605,8 @@ static int changed_cb(struct btrfs_root *left_root,
 	sctx->right_path = right_path;
 	sctx->cmp_key = key;

+	record_checkpoint(sctx, tree_cp);
+
 	ret = finish_inode_if_needed(sctx, 0);
 	if (ret < 0)
 		goto out;
@@ -4342,7 +4629,8 @@ out:
 	return ret;
 }

-static int full_send_tree(struct send_ctx *sctx)
+static int full_send_tree(struct send_ctx *sctx,
+			struct btrfs_compare_trees_checkpoint *tree_cp)
 {
 	int ret;
 	struct btrfs_trans_handle *trans = NULL;
@@ -4363,9 +4651,15 @@ static int full_send_tree(struct send_ctx *sctx)
 	start_ctransid = btrfs_root_ctransid(&send_root->root_item);
 	spin_unlock(&send_root->root_times_lock);

-	key.objectid = BTRFS_FIRST_FREE_OBJECTID;
-	key.type = BTRFS_INODE_ITEM_KEY;
-	key.offset = 0;
+	if (tree_cp == NULL) {
+		key.objectid = BTRFS_FIRST_FREE_OBJECTID;
+		key.type = BTRFS_INODE_ITEM_KEY;
+		key.offset = 0;
+	} else {
+		key.objectid = le64_to_cpu(tree_cp->left_key__objectid);
+		key.type = tree_cp->left_key__type;
+		key.offset = le64_to_cpu(tree_cp->left_key__offset);
+	}

 join_trans:
 	/*
@@ -4403,6 +4697,8 @@ join_trans:
 		goto out_finish;

 	while (1) {
+		struct btrfs_compare_trees_checkpoint curr_cp;
+
 		/*
 		 * When someone want to commit while we iterate, end the
 		 * joined transaction and rejoin.
@@ -4421,7 +4717,12 @@ join_trans:
 		btrfs_item_key_to_cpu(eb, &found_key, slot);

 		ret = changed_cb(send_root, NULL, path, NULL,
-				&found_key, BTRFS_COMPARE_TREE_NEW, sctx);
+				&found_key, BTRFS_COMPARE_TREE_NEW,
+				/* The checkpoint is as if the right tree ended */
+				btrfs_compare_trees_gen_checkpoint(&curr_cp,
+					&found_key, 0/*left_end_reached*/,
+					NULL/*right_key*/, 1/*right_end_reached*/),
+				sctx);
 		if (ret < 0)
 			goto out;

@@ -4452,7 +4753,8 @@ out:
 	return ret;
 }

-static int send_subvol(struct send_ctx *sctx)
+static int send_subvol(struct send_ctx *sctx,
+			struct btrfs_compare_trees_checkpoint *tree_cp)
 {
 	int ret;

@@ -4466,14 +4768,14 @@ static int send_subvol(struct send_ctx *sctx)

 	if (sctx->parent_root) {
 		ret = btrfs_compare_trees(sctx->send_root, sctx->parent_root,
-				changed_cb, sctx);
+			    tree_cp, changed_cb, sctx);
 		if (ret < 0)
 			goto out;
 		ret = finish_inode_if_needed(sctx, 1);
 		if (ret < 0)
 			goto out;
 	} else {
-		ret = full_send_tree(sctx);
+		ret = full_send_tree(sctx, tree_cp);
 		if (ret < 0)
 			goto out;
 	}
@@ -4495,8 +4797,8 @@ long btrfs_ioctl_send(struct file *mnt_file,
void __user *arg_)
 	struct btrfs_root *clone_root;
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_ioctl_send_args *arg = NULL;
+	struct btrfs_send_checkpoint *cp = NULL;
 	struct btrfs_key key;
-	struct file *filp = NULL;
 	struct send_ctx *sctx = NULL;
 	u32 i;
 	u64 *clone_sources_tmp = NULL;
@@ -4514,6 +4816,21 @@ long btrfs_ioctl_send(struct file *mnt_file,
void __user *arg_)
 		goto out;
 	}

+	/*
+	 * Do not accept too small buffers, BTRFS_SEND_BUF_SIZE should
+	 * accomodate at least one command.
+	 */
+	if (arg->send_buffer == NULL ||
+		arg->send_buffer_size_bytes < BTRFS_SEND_BUF_SIZE) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (!access_ok(VERIFY_WRITE, arg->send_buffer,
+			arg->send_buffer_size_bytes)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
 	if (!access_ok(VERIFY_READ, arg->clone_sources,
 			sizeof(*arg->clone_sources *
 			arg->clone_sources_count))) {
@@ -4521,6 +4838,33 @@ long btrfs_ioctl_send(struct file *mnt_file,
void __user *arg_)
 		goto out;
 	}

+	/* Grab the checkpoint if exists */
+	if (arg->in_cp != NULL && arg->in_cp_size_bytes > 0) {
+		if (arg->in_cp_size_bytes != sizeof(struct btrfs_send_checkpoint)) {
+			ret = -EILSEQ;
+			goto out;
+		}
+		cp = memdup_user(arg->in_cp, arg->in_cp_size_bytes);
+		if (IS_ERR(cp)) {
+			ret = PTR_ERR(cp);
+			cp = NULL; /* Prevent from freeing cp */
+			goto out;
+		}
+		cp->version = le32_to_cpu(cp->version);
+		cp->cp_size_bytes = le32_to_cpu(cp->cp_size_bytes);
+		if (cp->version != BTRFS_SEND_CHECKPOINT_VERSION ||
+			cp->cp_size_bytes != sizeof(struct btrfs_send_checkpoint)) {
+			ret = -EILSEQ;
+			goto out;
+		}
+
+		/* This should not happen */
+		if (!BTRFS_HAS_SEND_CHECKPOINT(cp)) {
+			kfree(cp);
+			cp = NULL;
+		}
+	}
+
 	sctx = kzalloc(sizeof(struct send_ctx), GFP_NOFS);
 	if (!sctx) {
 		ret = -ENOMEM;
@@ -4532,12 +4876,6 @@ long btrfs_ioctl_send(struct file *mnt_file,
void __user *arg_)
 	INIT_RADIX_TREE(&sctx->name_cache, GFP_NOFS);
 	INIT_LIST_HEAD(&sctx->name_cache_list);

-	sctx->send_filp = fget(arg->send_fd);
-	if (IS_ERR(sctx->send_filp)) {
-		ret = PTR_ERR(sctx->send_filp);
-		goto out;
-	}
-
 	sctx->mnt = mnt_file->f_path.mnt;

 	sctx->send_root = send_root;
@@ -4550,12 +4888,6 @@ long btrfs_ioctl_send(struct file *mnt_file,
void __user *arg_)
 		goto out;
 	}

-	sctx->read_buf = vmalloc(BTRFS_SEND_READ_SIZE);
-	if (!sctx->read_buf) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	sctx->clone_roots = vzalloc(sizeof(struct clone_root) *
 			(arg->clone_sources_count + 1));
 	if (!sctx->clone_roots) {
@@ -4621,30 +4953,104 @@ long btrfs_ioctl_send(struct file *mnt_file,
void __user *arg_)
 			sizeof(*sctx->clone_roots), __clone_root_cmp_sort,
 			NULL);

-	ret = send_subvol(sctx);
+	/* Re-arm the send checkpoint, if any */
+	if (cp == NULL) {
+		sctx->cur_ino                       = 0;
+		sctx->cur_inode_gen                 = 0;
+		sctx->cur_inode_new                 = 0;
+		sctx->cur_inode_new_gen             = 0;
+		sctx->cur_inode_deleted             = 0;
+		sctx->cur_inode_size                = 0;
+		sctx->cur_inode_mode                = 0;
+		sctx->send_progress                 = 0;
+
+		sctx->n_cmds_to_skip                     = 0;
+		sctx->offset_in_write_cmd_bytes_to_skip  = 0;
+	} else {
+		sctx->cur_ino                       = le64_to_cpu(cp->cur_ino);
+		sctx->cur_inode_gen                 = le64_to_cpu(cp->cur_inode_gen);
+		sctx->cur_inode_new                 = cp->cur_inode_new;     /* u8 */
+		sctx->cur_inode_new_gen             = cp->cur_inode_new_gen; /* u8 */
+		sctx->cur_inode_deleted             = cp->cur_inode_deleted; /* u8 */
+		sctx->cur_inode_size                = le64_to_cpu(cp->cur_inode_size);
+		sctx->cur_inode_mode                = le64_to_cpu(cp->cur_inode_mode);
+		sctx->send_progress                 = le64_to_cpu(cp->send_progress);
+
+		sctx->n_cmds_to_skip                     = le32_to_cpu(cp->n_cmds_since_cp);
+		sctx->offset_in_write_cmd_bytes_to_skip  =
le32_to_cpu(cp->offset_in_write_cmd_bytes);
+	}
+
+	/* Initialize constant part of the current checkpoint */
+	sctx->curr_cp.cp_size_bytes = cpu_to_le32(sizeof(struct
btrfs_send_checkpoint));
+	sctx->curr_cp.version       = cpu_to_le32(BTRFS_SEND_CHECKPOINT_VERSION);
+	/*
+	 * The rest of curr_cp is left zeroed, so that in record_checkpoint()
+	 * we do not assert because of a duplicate checkpoint.
+	 * This will also signal to user mode !BTRFS_HAS_SEND_CHECKPOINT() in case
+	 * we manage only to send the SUBVOL command (which should not happen).
+	 */
+
+	/* Initialize user buffer */
+	sctx->out_buffer = arg->send_buffer;
+	sctx->out_buffer_size_bytes = arg->send_buffer_size_bytes;
+	sctx->out_buffer_data_bytes = 0;
+	sctx->out_buffer_full = 0;
+
+	ret = send_subvol(sctx, (cp != NULL) ? &cp->tree_cmp_cp : NULL);
 	if (ret < 0)
 		goto out;

 	ret = begin_cmd(sctx, BTRFS_SEND_C_END);
 	if (ret < 0)
 		goto out;
-	ret = send_cmd(sctx);
+	ret = send_non_write_or_stream_header(sctx, 0/*header*/);
 	if (ret < 0)
 		goto out;

 out:
-	if (filp)
-		fput(filp);
+	if (sctx != NULL) {
+		BUG_ON(arg == NULL);
+
+		if (!ret) {
+			/* Case1: we completed sending all the data */
+			arg->send_buffer_size_bytes = sctx->out_buffer_data_bytes;
+			
+			/* generate end-of-data checkpoint */
+			arg->out_cp.cp_size_bytes = cpu_to_le32(sizeof(struct
btrfs_send_checkpoint));
+			arg->out_cp.version       = cpu_to_le32(BTRFS_SEND_CHECKPOINT_VERSION);
+			btrfs_compare_trees_gen_checkpoint(&arg->out_cp.tree_cmp_cp,
+				NULL/*left_key*/, 1/*left_end_reached*/,
+				NULL/*right_key*/,1/*right_end_reached*/);
+			arg->out_cp.cur_ino       = cpu_to_le64((u64)-1);
+			arg->out_cp.cur_inode_gen = cpu_to_le64((u64)-1);
+			/* Rest of the checkpoint fields should not matter */
+
+			arg->end_of_data = 1; /* Signal end-of-data to user mode */
+
+			ret = copy_to_user(arg_, arg, sizeof(*arg));
+			if (ret)
+				ret = -EFAULT;
+		} else if (ret == -EOVERFLOW && sctx->out_buffer_full) {
+			/* Case2: we filled the current buffer, but still have more data to push */
+			arg->send_buffer_size_bytes = sctx->out_buffer_data_bytes;
+
+			/* copy the current checkpoint */
+			arg->out_cp = sctx->curr_cp;
+			arg->end_of_data = 0;
+			ret = copy_to_user(arg_, arg, sizeof(*arg));
+			if (ret)
+				ret = -EFAULT;
+		} else {
+			/* Case3: some real error: just return error from ioctl */
+		}
+	}
+
 	kfree(arg);
 	vfree(clone_sources_tmp);

 	if (sctx) {
-		if (sctx->send_filp)
-			fput(sctx->send_filp);
-
 		vfree(sctx->clone_roots);
 		vfree(sctx->send_buf);
-		vfree(sctx->read_buf);

 		name_cache_free(sctx);
