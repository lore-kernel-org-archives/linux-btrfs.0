Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758125Ab2FGXEF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jun 2012 19:04:05 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 2/3] [PATCH] btrfs-progs: add extended inode ref support to btrfsck
Date: Thu,  7 Jun 2012 16:00:55 -0700
Message-Id: <1339110056-21484-3-git-send-email-mfasheh@suse.de>
In-Reply-To: <1339110056-21484-1-git-send-email-mfasheh@suse.de>
References: <1339110056-21484-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

Add a function, process_inode_extref() to be called from process_one_leaf()
when an item type of BTRFS_INODE_EXTREF_KEY is encountered.

Similarly to process_inode_ref(), process_inode_extref() walks an extref and
adds an inode_backref structure for each reference found within.

I modified fsck's inode_backref to get a type field (ref_type) which helps
us internally track the exact type of backrefs found.  Of course this field
could be overwritten in case of disk corruption (duplicate refs) but
duplicate refs themselves are tracked by btrfsck so that should not be an
issue as btrfsck is written today.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 btrfsck.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 7aac736..b29c228 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -96,6 +96,7 @@ struct inode_backref {
 	unsigned int found_inode_ref:1;
 	unsigned int filetype:8;
 	int errors;
+	unsigned int ref_type;
 	u64 dir;
 	u64 index;
 	u16 namelen;
@@ -466,12 +467,14 @@ static int add_inode_backref(struct cache_tree *inode_cache,
 
 		backref->filetype = filetype;
 		backref->found_dir_item = 1;
-	} else if (itemtype == BTRFS_INODE_REF_KEY) {
+	} else if ((itemtype == BTRFS_INODE_REF_KEY) ||
+		   (itemtype == BTRFS_INODE_EXTREF_KEY)) {
 		if (backref->found_inode_ref)
 			backref->errors |= REF_ERR_DUP_INODE_REF;
 		if (backref->found_dir_index && backref->index != index)
 			backref->errors |= REF_ERR_INDEX_UNMATCH;
 
+		backref->ref_type = itemtype;
 		backref->index = index;
 		backref->found_inode_ref = 1;
 	} else {
@@ -507,7 +510,7 @@ static int merge_inode_recs(struct inode_record *src, struct inode_record *dst,
 			add_inode_backref(dst_cache, dst->ino,
 					backref->dir, backref->index,
 					backref->name, backref->namelen, 0,
-					BTRFS_INODE_REF_KEY, backref->errors);
+					backref->ref_type, backref->errors);
 		}
 	}
 
@@ -851,6 +854,49 @@ static int process_inode_ref(struct extent_buffer *eb,
 	return 0;
 }
 
+static int process_inode_extref(struct extent_buffer *eb,
+				int slot, struct btrfs_key *key,
+				struct shared_node *active_node)
+{
+	u32 total;
+	u32 cur = 0;
+	u32 len;
+	u32 name_len;
+	u64 index;
+	u64 parent;
+	int error;
+	struct cache_tree *inode_cache;
+	struct btrfs_inode_extref *extref;
+	char namebuf[BTRFS_NAME_LEN];
+
+	inode_cache = &active_node->inode_cache;
+
+	extref = btrfs_item_ptr(eb, slot, struct btrfs_inode_extref);
+	total = btrfs_item_size_nr(eb, slot);
+	while (cur < total) {
+		name_len = btrfs_inode_extref_name_len(eb, extref);
+		index = btrfs_inode_extref_index(eb, extref);
+		parent = btrfs_inode_extref_parent(eb, extref);
+		if (name_len <= BTRFS_NAME_LEN) {
+			len = name_len;
+			error = 0;
+		} else {
+			len = BTRFS_NAME_LEN;
+			error = REF_ERR_NAME_TOO_LONG;
+		}
+		read_extent_buffer(eb, namebuf,
+				   (unsigned long)(extref + 1), len);
+		add_inode_backref(inode_cache, key->objectid, parent,
+				  index, namebuf, len, 0, key->type, error);
+
+		len = sizeof(*extref) + name_len;
+		extref = (struct btrfs_inode_extref *)((char *)extref + len);
+		cur += len;
+	}
+	return 0;
+
+}
+
 static u64 count_csum_range(struct btrfs_root *root, u64 start, u64 len)
 {
 	struct btrfs_key key;
@@ -1033,6 +1079,9 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 		case BTRFS_INODE_REF_KEY:
 			ret = process_inode_ref(eb, i, &key, active_node);
 			break;
+		case BTRFS_INODE_EXTREF_KEY:
+			ret = process_inode_extref(eb, i, &key, active_node);
+			break;
 		case BTRFS_INODE_ITEM_KEY:
 			ret = process_inode_item(eb, i, &key, active_node);
 			break;
-- 
1.7.7

