Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:41607 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3JDUmm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Oct 2013 16:42:42 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 141899A0364
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Oct 2013 14:42:42 -0600 (MDT)
Received: from CAS1.int.fusionio.com ([10.101.1.40]) by mx1.fusionio.com with ESMTP id WJS9HW0tZnvAD8Xs (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 04 Oct 2013 14:42:41 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: print out human readable errors for inodes and backrefs
Date: Fri, 4 Oct 2013 16:42:39 -0400
Message-ID: <1380919359-2310-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We usually print out a hex value of any errors on inodes or their backrefs,
which is a huge pain for me because I have to put it into a calculator and count
the bits to figure out which errors these map to, and usually I get it wrong the
first time.  To fix this lets just print out a human readable string for each
error that way it will be easier to spot the "OH GOD THAT'S AWFUL" errors from
"oh yeah thats no big deal, repair will fix that."  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ec6669c..d8fcf97 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -278,6 +278,70 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	return rec;
 }
 
+static void print_inode_error(int errors)
+{
+	if (errors & I_ERR_NO_INODE_ITEM)
+		fprintf(stderr, ", no inode item");
+	if (errors & I_ERR_NO_ORPHAN_ITEM)
+		fprintf(stderr, ", no orphan item");
+	if (errors & I_ERR_DUP_INODE_ITEM)
+		fprintf(stderr, ", dup inode item");
+	if (errors & I_ERR_DUP_DIR_INDEX)
+		fprintf(stderr, ", dup dir index");
+	if (errors & I_ERR_ODD_DIR_ITEM)
+		fprintf(stderr, ", odd dir item");
+	if (errors & I_ERR_ODD_FILE_EXTENT)
+		fprintf(stderr, ", odd file extent");
+	if (errors & I_ERR_BAD_FILE_EXTENT)
+		fprintf(stderr, ", bad file extent");
+	if (errors & I_ERR_FILE_EXTENT_OVERLAP)
+		fprintf(stderr, ", file extent overlap");
+	if (errors & I_ERR_FILE_EXTENT_DISCOUNT)
+		fprintf(stderr, ", file extent discount");
+	if (errors & I_ERR_DIR_ISIZE_WRONG)
+		fprintf(stderr, ", dir isize wrong");
+	if (errors & I_ERR_FILE_NBYTES_WRONG)
+		fprintf(stderr, ", nbytes wrong");
+	if (errors & I_ERR_ODD_CSUM_ITEM)
+		fprintf(stderr, ", odd csum item");
+	if (errors & I_ERR_SOME_CSUM_MISSING)
+		fprintf(stderr, ", some csum missing");
+	if (errors & I_ERR_LINK_COUNT_WRONG)
+		fprintf(stderr, ", link count wrong");
+	fprintf(stderr, "\n");
+}
+
+static void print_ref_error(int errors)
+{
+	if (errors & REF_ERR_NO_DIR_ITEM)
+		fprintf(stderr, ", no dir item");
+	if (errors & REF_ERR_NO_DIR_INDEX)
+		fprintf(stderr, ", no dir index");
+	if (errors & REF_ERR_NO_INODE_REF)
+		fprintf(stderr, ", no inode ref");
+	if (errors & REF_ERR_DUP_DIR_ITEM)
+		fprintf(stderr, ", dup dir item");
+	if (errors & REF_ERR_DUP_DIR_INDEX)
+		fprintf(stderr, ", dup dir index");
+	if (errors & REF_ERR_DUP_INODE_REF)
+		fprintf(stderr, ", dup inode ref");
+	if (errors & REF_ERR_INDEX_UNMATCH)
+		fprintf(stderr, ", index unmatch");
+	if (errors & REF_ERR_FILETYPE_UNMATCH)
+		fprintf(stderr, ", filetype unmatch");
+	if (errors & REF_ERR_NAME_TOO_LONG)
+		fprintf(stderr, ", name too long");
+	if (errors & REF_ERR_NO_ROOT_REF)
+		fprintf(stderr, ", no root ref");
+	if (errors & REF_ERR_NO_ROOT_BACKREF)
+		fprintf(stderr, ", no root backref");
+	if (errors & REF_ERR_DUP_ROOT_REF)
+		fprintf(stderr, ", dup root ref");
+	if (errors & REF_ERR_DUP_ROOT_BACKREF)
+		fprintf(stderr, ", dup root backref");
+	fprintf(stderr, "\n");
+}
+
 static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 					  u64 ino, int mod)
 {
@@ -1474,9 +1538,10 @@ static int check_inode_recs(struct btrfs_root *root,
 			rec->errors |= I_ERR_NO_INODE_ITEM;
 		if (rec->found_link != rec->nlink)
 			rec->errors |= I_ERR_LINK_COUNT_WRONG;
-		fprintf(stderr, "root %llu inode %llu errors %x\n",
+		fprintf(stderr, "root %llu inode %llu errors %x",
 			(unsigned long long) root->root_key.objectid,
 			(unsigned long long) rec->ino, rec->errors);
+		print_inode_error(rec->errors);
 		list_for_each_entry(backref, &rec->backrefs, list) {
 			if (!backref->found_dir_item)
 				backref->errors |= REF_ERR_NO_DIR_ITEM;
@@ -1485,11 +1550,12 @@ static int check_inode_recs(struct btrfs_root *root,
 			if (!backref->found_inode_ref)
 				backref->errors |= REF_ERR_NO_INODE_REF;
 			fprintf(stderr, "\tunresolved ref dir %llu index %llu"
-				" namelen %u name %s filetype %d error %x\n",
+				" namelen %u name %s filetype %d error %x",
 				(unsigned long long)backref->dir,
 				(unsigned long long)backref->index,
 				backref->namelen, backref->name,
 				backref->filetype, backref->errors);
+			print_ref_error(backref->errors);
 		}
 		free_inode_rec(rec);
 	}
-- 
1.8.3.1

