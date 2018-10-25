Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A0BECDE46
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 07:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BEDE2054F
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 07:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BEDE2054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbeJYQQc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 12:16:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:58218 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726465AbeJYQQc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 12:16:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4DDF1AF92
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 07:44:57 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs-progs: original check: Use mismatch_dir_hash_record to record bad dir items
Date:   Thu, 25 Oct 2018 15:44:47 +0800
Message-Id: <20181025074449.32469-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181025074449.32469-1-wqu@suse.com>
References: <20181025074449.32469-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This allow us to report the error better, from old in-place report like:
  ERROR: DIR_ITEM[256 751495445] name foor.WvG1c1TdU namelen 13 filetype 1 mismatch with its hash, wanted 751495445 have 2870353892
  root 5 root dir 256 error

To new centralized report:
  root 5 root dir 256 error
  root 5 inode 256 errors 40000
  Dir items with mismatch hash:
	  name: foor.WvG1c1Td namelen: 13 wanted 0xab161fe4 has 0x2ccae915

Also, with mismatch_dir_hash_record structure, it provides the basis for
later original mode repair.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c          | 76 ++++++++++++++++++++++++++++++++++++++++---
 check/mode-original.h | 14 ++++++++
 2 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/check/main.c b/check/main.c
index bc2ee22f7943..4a4f2a7c9cdb 100644
--- a/check/main.c
+++ b/check/main.c
@@ -462,6 +462,8 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	struct inode_backref *tmp;
 	struct orphan_data_extent *src_orphan;
 	struct orphan_data_extent *dst_orphan;
+	struct mismatch_dir_hash_record *hash_record;
+	struct mismatch_dir_hash_record *new_record;
 	struct rb_node *rb;
 	size_t size;
 	int ret;
@@ -473,6 +475,7 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	rec->refs = 1;
 	INIT_LIST_HEAD(&rec->backrefs);
 	INIT_LIST_HEAD(&rec->orphan_extents);
+	INIT_LIST_HEAD(&rec->mismatch_dir_hash);
 	rec->holes = RB_ROOT;
 
 	list_for_each_entry(orig, &orig_rec->backrefs, list) {
@@ -494,6 +497,16 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 		memcpy(dst_orphan, src_orphan, sizeof(*src_orphan));
 		list_add_tail(&dst_orphan->list, &rec->orphan_extents);
 	}
+	list_for_each_entry(hash_record, &orig_rec->mismatch_dir_hash, list) {
+		size = sizeof(*hash_record) + hash_record->namelen;
+		new_record = malloc(size);
+		if (!new_record) {
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+		memcpy(&new_record, hash_record, size);
+		list_add_tail(&new_record->list, &rec->mismatch_dir_hash);
+	}
 	ret = copy_file_extent_holes(&rec->holes, &orig_rec->holes);
 	if (ret < 0)
 		goto cleanup_rb;
@@ -522,6 +535,13 @@ cleanup:
 			list_del(&orig->list);
 			free(orig);
 		}
+	if (!list_empty(&rec->mismatch_dir_hash)) {
+		list_for_each_entry_safe(hash_record, new_record,
+				&rec->mismatch_dir_hash, list) {
+			list_del(&hash_record->list);
+			free(hash_record);
+		}
+	}
 
 	free(rec);
 
@@ -621,6 +641,25 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 				round_up(rec->isize,
 					 root->fs_info->sectorsize));
 	}
+
+	/* Print dir item with mismatch hash */
+	if (errors & I_ERR_MISMATCH_DIR_HASH) {
+		struct mismatch_dir_hash_record *hash_record;
+
+		fprintf(stderr, "Dir items with mismatch hash:\n");
+		list_for_each_entry(hash_record, &rec->mismatch_dir_hash,
+				list) {
+			char *namebuf = (char *)(hash_record + 1);
+			u32 crc;
+
+			crc = btrfs_name_hash(namebuf, hash_record->namelen);
+			fprintf(stderr,
+			"\tname: %.*s namelen: %u wanted 0x%08x has 0x%08llx\n",
+				hash_record->namelen, namebuf,
+				hash_record->namelen, crc,
+				hash_record->key.offset);
+		}
+	}
 }
 
 static void print_ref_error(int errors)
@@ -682,6 +721,7 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 		rec->refs = 1;
 		INIT_LIST_HEAD(&rec->backrefs);
 		INIT_LIST_HEAD(&rec->orphan_extents);
+		INIT_LIST_HEAD(&rec->mismatch_dir_hash);
 		rec->holes = RB_ROOT;
 
 		node = malloc(sizeof(*node));
@@ -718,6 +758,8 @@ static void free_orphan_data_extents(struct list_head *orphan_extents)
 static void free_inode_rec(struct inode_record *rec)
 {
 	struct inode_backref *backref;
+	struct mismatch_dir_hash_record *hash;
+	struct mismatch_dir_hash_record *next;
 
 	if (--rec->refs > 0)
 		return;
@@ -727,6 +769,8 @@ static void free_inode_rec(struct inode_record *rec)
 		list_del(&backref->list);
 		free(backref);
 	}
+	list_for_each_entry_safe(hash, next, &rec->mismatch_dir_hash, list)
+		free(hash);
 	free_orphan_data_extents(&rec->orphan_extents);
 	free_file_extent_holes(&rec->holes);
 	free(rec);
@@ -1273,6 +1317,25 @@ out:
 	return has_parent ? 0 : 2;
 }
 
+static int add_mismatch_dir_hash(struct inode_record *dir_rec,
+				 struct btrfs_key *key, const char *namebuf,
+				 int namelen)
+{
+	struct mismatch_dir_hash_record *hash_record;
+
+	hash_record = malloc(sizeof(*hash_record) + namelen);
+	if (!hash_record) {
+		error("failed to allocate memory for mismatch dir hash rec");
+		return -ENOMEM;
+	}
+	memcpy(&hash_record->key, key, sizeof(*key));
+	memcpy(hash_record + 1, namebuf, namelen);
+	hash_record->namelen = namelen;
+
+	list_add(&hash_record->list, &dir_rec->mismatch_dir_hash);
+	return 0;
+}
+
 static int process_dir_item(struct extent_buffer *eb,
 			    int slot, struct btrfs_key *key,
 			    struct shared_node *active_node)
@@ -1300,6 +1363,8 @@ static int process_dir_item(struct extent_buffer *eb,
 	di = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
 	total = btrfs_item_size_nr(eb, slot);
 	while (cur < total) {
+		int ret;
+
 		nritems++;
 		btrfs_dir_item_key_to_cpu(eb, di, &location);
 		name_len = btrfs_dir_name_len(eb, di);
@@ -1324,10 +1389,12 @@ static int process_dir_item(struct extent_buffer *eb,
 
 		if (key->type == BTRFS_DIR_ITEM_KEY &&
 		    key->offset != btrfs_name_hash(namebuf, len)) {
-			rec->errors |= I_ERR_ODD_DIR_ITEM;
-			error("DIR_ITEM[%llu %llu] name %s namelen %u filetype %u mismatch with its hash, wanted %llu have %llu",
-			key->objectid, key->offset, namebuf, len, filetype,
-			key->offset, btrfs_name_hash(namebuf, len));
+			rec->errors |= I_ERR_MISMATCH_DIR_HASH;
+			ret = add_mismatch_dir_hash(rec, key, namebuf, len);
+			/* Fatal error, ENOMEM */
+			if (ret < 0)
+				return ret;
+			goto next;
 		}
 
 		if (location.type == BTRFS_INODE_ITEM_KEY) {
@@ -1348,6 +1415,7 @@ static int process_dir_item(struct extent_buffer *eb,
 					  len, filetype, key->type, error);
 		}
 
+next:
 		len = sizeof(*di) + name_len + data_len;
 		di = (struct btrfs_dir_item *)((char *)di + len);
 		cur += len;
diff --git a/check/mode-original.h b/check/mode-original.h
index ec2842e0b3be..25ca274118a7 100644
--- a/check/mode-original.h
+++ b/check/mode-original.h
@@ -188,6 +188,7 @@ struct file_extent_hole {
 #define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
 #define I_ERR_ODD_INODE_FLAGS		(1 << 16)
 #define I_ERR_INLINE_RAM_BYTES_WRONG	(1 << 17)
+#define I_ERR_MISMATCH_DIR_HASH		(1 << 18)
 
 struct inode_record {
 	struct list_head backrefs;
@@ -213,10 +214,23 @@ struct inode_record {
 	u64 extent_end;
 	struct rb_root holes;
 	struct list_head orphan_extents;
+	struct list_head mismatch_dir_hash;
 
 	u32 refs;
 };
 
+/*
+ * To record one dir_item with mismatch hash.
+ *
+ * Since the hash is incorrect, we must record the hash (key).
+ */
+struct mismatch_dir_hash_record {
+	struct list_head list;
+	struct btrfs_key key;
+	int namelen;
+	/* namebuf follows here */
+};
+
 struct root_backref {
 	struct list_head list;
 	unsigned int found_dir_item:1;
-- 
2.19.1

