Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab2HTUew (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 16:34:52 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH v4 0/4] btrfs: extended inode refs
Date: Mon, 20 Aug 2012 13:29:17 -0700
Message-Id: <1345494561-28758-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs has a limitation on the maximum number of hard links an
inode can have. Specifically, links are stored in an array of ref
items:

struct btrfs_inode_ref {
	__le64 index;
	__le16 name_len;
	/* name goes here */
} __attribute__ ((__packed__));

The ref arrays are found via key triple:

(inode objectid, BTRFS_INODE_EXTREF_KEY, parent dir objectid)

Since items can not exceed the size of a leaf, the total number of links
that can be stored for a given inode / parent dir pair is limited to under
4k. This works fine for the most common case of few to only a handful of
links. Once the link count gets higher however, we begin to return EMLINK.


The following patches fix this situation by introducing a new ref item:

struct btrfs_inode_extref {
	__le64 parent_objectid;
	__le64 index;
	__le16 name_len;
	__u8   name[0];
	/* name goes here */
} __attribute__ ((__packed__));

Extended refs use a different addressing scheme. Extended ref keys
look like:

(inode objectid, BTRFS_INODE_EXTREF_KEY, hash)

Where hash is defined as a function of the parent objectid and link name.

This effectively fixes the limitation, though we have a slightly less
efficient packing of link data. To keep the best of both worlds then, I
implemented the following behavior:

Extended refs don't replace the existing ref array. An inode gets an
extended ref for a given link _only_ after the ref array has been filled.  So
the most common cases shouldn't actually see any difference in performance
or disk usage as they'll never get to the point where we're using an
extended ref.

It's important while reading the patches however that there's still the
possibility that we can have a set of operations that grow out an inode ref
array (adding some extended refs) and then remove only the refs in the
array.  I don't really see this being common but it's a case we always have
to consider when coding these changes.

Extended refs handle the case of a hash collision by storing items with the
same key in an array just like the dir item code. This means we have to
search an array on rare occasion.

Included in this series is a patch by Jan Schmidt which gives us a
very nice cleanup of add_inode_ref(). This makes my subsequent changes
and the function in general easier to understand.

Testing wise, the basic namespace operations work well (link, unlink, etc).
The rest has gotten less debugging (and I really don't have a great way of
testing the code in tree-log.c) Attached to this e-mail are btrfs-progs
patches which make testing of the changes possible.

These patches are based off Linux v3.5. There is at least one cleanup
that we can make if the patch is rebased to latest git (we can replace
most of btrfs_find_one_extref() with btrfs_search_slot_for_read()). I
didn't want to keep rebasing this patch set though as that tends to
introduce bugs. Suffice to say I'm happy to do that patch once we
rebase these again or the changes are merged / on the way to merging.
       --Mark

Most recent review for this series can be found at:
http://www.spinics.net/lists/linux-btrfs/msg18331.html

Thanks to Jan Schmidt for giving the patches thorough review. Most of the
changes are from his suggestions.

* Changelog

- Added patch from Jan to clean up add_inode_ref().

- Fixed a bug in add_inode_ref() where extended refs were using the
  wrong parent directory for tree operations.

- Whitespace cleanups.

- I am versioning the patches now, starting with v4.

- Fixed a bug I accidentally introduced to btrfs_insert_inode_extref()
  where we weren't setting the item values on succesful extend.

- Made return value handling in count_inode_extrefs() more clear.


* Old changes

- rebased against 3.5

- many code style cleanups

- simplified ref_get_fields() and callers 

- count_inode_extrefs() return value is bubbled up to callers now

- Fixed up add_inode_ref() changes based on my understanding of the
  function. Hopefully I've hit upon the right changes :)

- Implemented collision handling.

- Standardized naming of extended ref variables (extref).

- moved hashing code to hash.h and gave the function a better name
  (btrfs_extref_hash).

- A few cleanups of error handling.

- Fixed a bug where btrfs_find_one_extref() was erroneously incrementing the
  extref offset before returning it.

- Moved btrfs_find_one_extref() into backref.c. This means that backref.c no
  longer has to include tree-log.h.

- Fixed a bug in iref_to_path() where we were looking for extended refs
  (this actually lead to other bugs). Since iref_to_path() only deals with
  directory inodes we would never have an extended ref.

- added some explicit locking calls in the backref.c changes

- Instead of adding a second iterate function for extended refs, I fixed up
  iterate_irefs_t arguments to take the raw information from whatever ref
  version we're coming from. This removed a bunch of duplicated code.

- I am actually including a patch to btrfs-progs with this drop. :)



From: Mark Fasheh <mfasheh@suse.com>

[PATCH] btrfs-progs: basic support for extended inode refs

This patch adds enough mkfs support to turn on the superblock flag and
btrfs-debug-tree support so that we can visualize the state of extended refs
on disk.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 ctree.h      |   27 ++++++++++++++++++++++++++-
 mkfs.c       |   14 +++++++++-----
 print-tree.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/ctree.h b/ctree.h
index 6545c50..ebf38fe 100644
--- a/ctree.h
+++ b/ctree.h
@@ -115,6 +115,13 @@ struct btrfs_trans_handle;
  */
 #define BTRFS_NAME_LEN 255
 
+/*
+ * Theoretical limit is larger, but we keep this down to a sane
+ * value. That should limit greatly the possibility of collisions on
+ * inode ref items.
+ */
+#define	BTRFS_LINK_MAX	65535U
+
 /* 32 bytes in various csum fields */
 #define BTRFS_CSUM_SIZE 32
 
@@ -412,6 +419,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
 #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
 #define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
+
 /*
  * some patches floated around with a second compression method
  * lets save that incompat here for when they do get in
@@ -426,6 +434,7 @@ struct btrfs_super_block {
  */
 #define BTRFS_FEATURE_INCOMPAT_BIG_METADATA     (1ULL << 5)
 
+#define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF   (1ULL << 6)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
@@ -434,7 +443,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
 	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
 	 BTRFS_FEATURE_INCOMPAT_BIG_METADATA |		\
-	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
+	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
+	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -573,6 +583,13 @@ struct btrfs_inode_ref {
 	/* name goes here */
 } __attribute__ ((__packed__));
 
+struct btrfs_inode_extref {
+	__le64 parent_objectid;
+	__le64 index;
+	__le16 name_len;
+	__u8   name[0]; /* name goes here */
+} __attribute__ ((__packed__));
+
 struct btrfs_timespec {
 	__le64 sec;
 	__le32 nsec;
@@ -866,6 +883,7 @@ struct btrfs_root {
  */
 #define BTRFS_INODE_ITEM_KEY		1
 #define BTRFS_INODE_REF_KEY		12
+#define BTRFS_INODE_EXTREF_KEY		13
 #define BTRFS_XATTR_ITEM_KEY		24
 #define BTRFS_ORPHAN_ITEM_KEY		48
 
@@ -1145,6 +1163,13 @@ BTRFS_SETGET_FUNCS(inode_ref_name_len, struct btrfs_inode_ref, name_len, 16);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_ref_name_len, struct btrfs_inode_ref, name_len, 16);
 BTRFS_SETGET_FUNCS(inode_ref_index, struct btrfs_inode_ref, index, 64);
 
+/* struct btrfs_inode_extref */
+BTRFS_SETGET_FUNCS(inode_extref_parent, struct btrfs_inode_extref,
+		   parent_objectid, 64);
+BTRFS_SETGET_FUNCS(inode_extref_name_len, struct btrfs_inode_extref,
+		   name_len, 16);
+BTRFS_SETGET_FUNCS(inode_extref_index, struct btrfs_inode_extref, index, 64);
+
 /* struct btrfs_inode_item */
 BTRFS_SETGET_FUNCS(inode_generation, struct btrfs_inode_item, generation, 64);
 BTRFS_SETGET_FUNCS(inode_sequence, struct btrfs_inode_item, sequence, 64);
diff --git a/mkfs.c b/mkfs.c
index c531ef2..5c18a6d 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1225,6 +1225,9 @@ int main(int ac, char **av)
 	u64 source_dir_size = 0;
 	char *pretty_buf;
 
+	struct btrfs_super_block *super;
+	u64 flags;
+
 	while(1) {
 		int c;
 		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:r:VM", long_options,
@@ -1426,13 +1429,14 @@ raid_groups:
 	ret = create_data_reloc_tree(trans, root);
 	BUG_ON(ret);
 
-	if (mixed) {
-		struct btrfs_super_block *super = &root->fs_info->super_copy;
-		u64 flags = btrfs_super_incompat_flags(super);
+	super = &root->fs_info->super_copy;
+	flags = btrfs_super_incompat_flags(super);
+	flags |= BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF;
 
+	if (mixed)
 		flags |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
-		btrfs_set_super_incompat_flags(super, flags);
-	}
+
+	btrfs_set_super_incompat_flags(super, flags);
 
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
 	    "sectorsize %u size %s\n",
diff --git a/print-tree.c b/print-tree.c
index fc134c0..6012df8 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -55,6 +55,42 @@ static int print_dir_item(struct extent_buffer *eb, struct btrfs_item *item,
 	return 0;
 }
 
+static int print_inode_extref_item(struct extent_buffer *eb,
+				   struct btrfs_item *item,
+				   struct btrfs_inode_extref *extref)
+{
+	u32 total;
+	u32 cur = 0;
+	u32 len;
+	u32 name_len = 0;
+	u64 index = 0;
+	u64 parent_objid;
+	char namebuf[BTRFS_NAME_LEN];
+
+	total = btrfs_item_size(eb, item);
+
+	while (cur < total) {
+		index = btrfs_inode_extref_index(eb, extref);
+		name_len = btrfs_inode_extref_name_len(eb, extref);
+		parent_objid = btrfs_inode_extref_parent(eb, extref);
+
+		len = (name_len <= sizeof(namebuf))? name_len: sizeof(namebuf);
+
+		read_extent_buffer(eb, namebuf, (unsigned long)(extref->name), len);
+
+		printf("\t\tinode extref index %llu parent %llu namelen %u "
+		       "name: %.*s\n",
+		       (unsigned long long)index,
+		       (unsigned long long)parent_objid,
+		       name_len, len, namebuf);
+
+		len = sizeof(*extref) + name_len;
+		extref = (struct btrfs_inode_extref *)((char *)extref + len);
+		cur += len;
+	}
+	return 0;
+}
+
 static int print_inode_ref_item(struct extent_buffer *eb, struct btrfs_item *item,
 				struct btrfs_inode_ref *ref)
 {
@@ -285,6 +321,9 @@ static void print_key_type(u8 type)
 	case BTRFS_INODE_REF_KEY:
 		printf("INODE_REF");
 		break;
+	case BTRFS_INODE_EXTREF_KEY:
+		printf("INODE_EXTREF");
+		break;
 	case BTRFS_DIR_ITEM_KEY:
 		printf("DIR_ITEM");
 		break;
@@ -454,6 +493,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_extent_data_ref *dref;
 	struct btrfs_shared_data_ref *sref;
 	struct btrfs_inode_ref *iref;
+	struct btrfs_inode_extref *iref2;
 	struct btrfs_dev_extent *dev_extent;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_root_item root_item;
@@ -492,6 +532,10 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			iref = btrfs_item_ptr(l, i, struct btrfs_inode_ref);
 			print_inode_ref_item(l, item, iref);
 			break;
+		case BTRFS_INODE_EXTREF_KEY:
+			iref2 = btrfs_item_ptr(l, i, struct btrfs_inode_extref);
+			print_inode_extref_item(l, item, iref2);
+			break;
 		case BTRFS_DIR_ITEM_KEY:
 		case BTRFS_DIR_INDEX_KEY:
 		case BTRFS_XATTR_ITEM_KEY:
-- 
1.7.7

