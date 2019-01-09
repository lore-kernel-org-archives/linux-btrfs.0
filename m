Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EF8C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 050B120821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4OzLiOl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbfAIB2i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:28:38 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38483 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729617AbfAIB1o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:44 -0500
Received: by mail-wr1-f66.google.com with SMTP id v13so6011917wrw.5;
        Tue, 08 Jan 2019 17:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EFO1qk3RR1TYdQa9iOxQubqukwLS4Np+uEBJbVscYag=;
        b=k4OzLiOlhPnebeFO6uATgN82OCok1YNMXQz0iP7FNsRm0WO9eQL1faTp6mMFaAX3Qg
         V1MgiiRrqsOrkIzidGgWwUOZhFNxyJCCtpWvQnZOHUKNaqmyw5qpALImPqZA96yCLWYu
         eyieJ3Za6LQ+TzAOwPRZMaCmyS+WWQrEfmN/avKoiwH9tnX2qggAOzA9wRfiI0Hr2xkr
         6c8B8SDot+4GoFu+YLYOlUYOFyUa6UZY6RaY93ZvpZ/CFynOXKEa24LsqFEiYHwtocgC
         +vN9ivKqe4bES3WxsKJtEYut6X8srBuN1qF8iDiR+a+5r3vSbOA/muXymG5jIW6Rp/bs
         cy2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=EFO1qk3RR1TYdQa9iOxQubqukwLS4Np+uEBJbVscYag=;
        b=VVMjNCojtIWsMzzk3IDyLKQn4iIJaJFCePGPjXsgPkbNjgGPyvl1DqmYpRg+xsdk+7
         NRqabGtyQMZEkRyjMHVEqk3WUVDuuS6QiHYOm+5AVTRmH8F2pUrzd40xci0wkVGkDSc1
         s+jqkstu+UtOTwTQ56ReHYLDrFecN0biQT5ETxoKDrw1aASLTQwHlnH1LyOYQvYI43+6
         MXq/jp4z0Ll0xQY0y+ycB7tNG7fSzCGH3st5s212gSbt0AU6Rncfe7dz/xKA7aanauTv
         n5p+qFwil+clXU8sSiKWyxEwz4CEzgM+C1V+tTUqIgWEqfEcgmfdzTxqNBy+HLwH8H8S
         8hWA==
X-Gm-Message-State: AJcUukdFxF0teuGu0obeKFT6Y8wSuKhy3jumBxWH9h/Yo5ZeYpm43d97
        Y8nd1xsIxGg13LdCCKI9AGIWWEtjH88=
X-Google-Smtp-Source: ALg8bN4TavRAgrGq7x5xkuRsvxAWQL24D+TKWGxV4Td2cV/FK+etvijJPnrS3QgQ9KVErYWDUX7j1g==
X-Received: by 2002:a5d:5443:: with SMTP id w3mr2914223wrv.4.1546997261003;
        Tue, 08 Jan 2019 17:27:41 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:40 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 12/19] btrfs: allow reading normal encrypted extents
Date:   Wed,  9 Jan 2019 01:26:54 +0000
Message-Id: <20190109012701.26441-12-mark@harmstone.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190109012701.26441-1-mark@harmstone.com>
References: <20190109012701.26441-1-mark@harmstone.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/ctree.h      |  6 +++
 fs/btrfs/encryption.c | 37 +++++++++++++++++
 fs/btrfs/encryption.h |  3 ++
 fs/btrfs/extent_io.c  | 96 ++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/extent_io.h  |  2 +
 fs/btrfs/extent_map.c | 16 +++++++-
 fs/btrfs/extent_map.h |  5 +++
 fs/btrfs/file-item.c  | 15 ++++++-
 fs/btrfs/inode.c      | 10 ++++-
 fs/btrfs/volumes.h    |  2 +
 10 files changed, 184 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 51fcc24047f8..4c5b8e8a8580 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2420,6 +2420,12 @@ BTRFS_SETGET_FUNCS(file_extent_encryption, struct btrfs_file_extent_item,
 BTRFS_SETGET_FUNCS(file_extent_other_encoding, struct btrfs_file_extent_item,
 		   other_encoding, 16);
 
+BTRFS_SETGET_FUNCS(file_extent_enc_key_number,
+		   struct btrfs_file_extent_item_enc, key_number, 64);
+
+BTRFS_SETGET_FUNCS(file_extent_inline_enc_key_number,
+		   struct btrfs_file_extent_inline_enc, key_number, 64);
+
 #define BTRFS_ENCRYPTION_KEY_ID_LENGTH 64
 
 struct btrfs_encryption_key_item {
diff --git a/fs/btrfs/encryption.c b/fs/btrfs/encryption.c
index 81313c4378b4..41c001339cc7 100644
--- a/fs/btrfs/encryption.c
+++ b/fs/btrfs/encryption.c
@@ -312,6 +312,43 @@ int btrfs_decrypt(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+int btrfs_decrypt_page(struct btrfs_fs_info *fs_info, struct page *page,
+		       u64 key_number, char *iv)
+{
+	struct scatterlist sg;
+	struct skcipher_request *req = NULL;
+	char *kaddr;
+	int ret = -EFAULT;
+	struct btrfs_enc_key *key;
+
+	ret = find_key(fs_info, key_number, &key);
+	if (ret)
+		return ret;
+
+	req = skcipher_request_alloc(key->skcipher, GFP_KERNEL);
+	if (!req) {
+		pr_info("could not allocate skcipher request\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	kaddr = kmap_atomic(page);
+
+	sg_init_one(&sg, kaddr, PAGE_SIZE);
+	skcipher_request_set_crypt(req, &sg, &sg, PAGE_SIZE, iv);
+
+	ret = crypto_skcipher_decrypt(req);
+
+	kunmap_atomic(kaddr);
+
+	if (ret < 0)
+		goto out;
+
+out:
+	if (req)
+		skcipher_request_free(req);
+	return ret;
+}
 
 int btrfs_get_key_id(u64 salt, char *password, unsigned int pwdlen,
 		     char *key_id)
diff --git a/fs/btrfs/encryption.h b/fs/btrfs/encryption.h
index dbc035a880a5..0d24dc51793c 100644
--- a/fs/btrfs/encryption.h
+++ b/fs/btrfs/encryption.h
@@ -33,6 +33,9 @@ struct btrfs_enc_key {
 int btrfs_decrypt(struct btrfs_fs_info *fs_info,
 		  unsigned char *data, size_t len);
 
+int btrfs_decrypt_page(struct btrfs_fs_info *fs_info, struct page *page,
+		       u64 key_number, char *iv);
+
 int btrfs_get_key_id(u64 salt, char *password, unsigned int pwdlen,
 		     char *key_id);
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d228f706ff3e..73fb0af50da8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -23,6 +23,7 @@
 #include "rcu-string.h"
 #include "backref.h"
 #include "disk-io.h"
+#include "encryption.h"
 
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
@@ -2490,6 +2491,26 @@ endio_readpage_release_extent(struct extent_io_tree *tree, u64 start, u64 len,
 	unlock_extent_cached_atomic(tree, start, end, &cached);
 }
 
+void btrfs_increment_iv(char *iv, u32 inc)
+{
+	u64 i1, ni1, i2;
+
+	if (inc == 0)
+		return;
+
+	i1 = be64_to_cpu(*(u64 *)(iv + sizeof(u64)));
+	ni1 = i1 + inc;
+
+	*(u64 *)(iv + sizeof(u64)) = cpu_to_be64(ni1);
+
+	if (ni1 > i1)
+		return;
+
+	i2 = be64_to_cpu(*(u64 *)iv);
+	i2++;
+	*(u64 *)iv = cpu_to_be64(i2);
+}
+
 /*
  * after a readpage IO is done, we need to:
  * clear the uptodate bits on error
@@ -2606,11 +2627,32 @@ static void end_bio_extent_readpage(struct bio *bio)
 			pgoff_t end_index = i_size >> PAGE_SHIFT;
 			unsigned off;
 
+			if (io_bio->key_number != 0) {
+				char iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+
+				memcpy(iv, io_bio->iv,
+				       BTRFS_ENCRYPTION_BLOCK_LENGTH);
+				btrfs_increment_iv(iv,
+				i * PAGE_SIZE / BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
+				ret = btrfs_decrypt_page(fs_info, page,
+						   io_bio->key_number, iv);
+			} else {
+				ret = 0;
+			}
+
 			/* Zero out the end if this page straddles i_size */
 			off = i_size & (PAGE_SIZE-1);
 			if (page->index == end_index && off)
 				zero_user_segment(page, off, PAGE_SIZE);
-			SetPageUptodate(page);
+
+			if (ret) {
+				uptodate = 0;
+				ClearPageUptodate(page);
+				SetPageError(page);
+			} else {
+				SetPageUptodate(page);
+			}
 		} else {
 			ClearPageUptodate(page);
 			SetPageError(page);
@@ -2752,6 +2794,8 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
  * @mirror_num:	     desired mirror to read/write
  * @prev_bio_flags:  flags of previous bio to see if we can merge the current one
  * @bio_flags:	flags of the current bio to see if we can merge them
+ * @key_number:	number of the encryption key (0 if not encrypted)
+ * @iv:		encryption initialization vector
  */
 static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 			      struct writeback_control *wbc,
@@ -2763,7 +2807,8 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 			      int mirror_num,
 			      unsigned long prev_bio_flags,
 			      unsigned long bio_flags,
-			      bool force_bio_submit)
+			      bool force_bio_submit, u64 key_number,
+			      char *iv)
 {
 	int ret = 0;
 	struct bio *bio;
@@ -2786,6 +2831,25 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 						      bio, bio_flags))
 			can_merge = false;
 
+		if (prev_bio_flags == bio_flags && contig &&
+			can_merge && !force_bio_submit) {
+			struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+
+			if (key_number != io_bio->key_number) {
+				can_merge = false;
+			} else if (key_number != 0) {
+				char iv2[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+
+				memcpy(iv2, io_bio->iv,
+				       BTRFS_ENCRYPTION_BLOCK_LENGTH);
+				btrfs_increment_iv(iv2, bio->bi_iter.bi_size /
+					BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
+				can_merge = !memcmp(iv, iv2,
+						 BTRFS_ENCRYPTION_BLOCK_LENGTH);
+			}
+		}
+
 		if (prev_bio_flags != bio_flags || !contig || !can_merge ||
 		    force_bio_submit ||
 		    bio_add_page(bio, page, page_size, pg_offset) < page_size) {
@@ -2813,6 +2877,13 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 		wbc_account_io(wbc, page, page_size);
 	}
 
+	if (key_number != 0) {
+		struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+
+		io_bio->key_number = key_number;
+		memcpy(io_bio->iv, iv, BTRFS_ENCRYPTION_BLOCK_LENGTH);
+	}
+
 	*bio_ret = bio;
 
 	return ret;
@@ -2924,6 +2995,8 @@ static int __do_readpage(struct extent_io_tree *tree,
 	while (cur <= end) {
 		bool force_bio_submit = false;
 		u64 offset;
+		char iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+		u64 key_number = 0;
 
 		if (cur >= last_byte) {
 			char *userpage;
@@ -2951,6 +3024,9 @@ static int __do_readpage(struct extent_io_tree *tree,
 		BUG_ON(extent_map_end(em) <= cur);
 		BUG_ON(end < cur);
 
+		if (test_bit(EXTENT_FLAG_ENCRYPTED, &em->flags))
+			this_bio_flag |= EXTENT_BIO_ENCRYPTED;
+
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
 			this_bio_flag |= EXTENT_BIO_COMPRESSED;
 			extent_set_compress_type(&this_bio_flag,
@@ -3014,6 +3090,16 @@ static int __do_readpage(struct extent_io_tree *tree,
 		if (prev_em_start)
 			*prev_em_start = em->orig_start;
 
+		if (this_bio_flag & EXTENT_BIO_ENCRYPTED &&
+			!(this_bio_flag & EXTENT_BIO_COMPRESSED)) {
+			key_number = em->key_number;
+			memcpy(iv, em->iv, BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
+			if (extent_offset != 0)
+				btrfs_increment_iv(iv,
+				extent_offset / BTRFS_ENCRYPTION_BLOCK_LENGTH);
+		}
+
 		free_extent_map(em);
 		em = NULL;
 
@@ -3061,7 +3147,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 					 end_bio_extent_readpage, mirror_num,
 					 *bio_flags,
 					 this_bio_flag,
-					 force_bio_submit);
+					 force_bio_submit, key_number, iv);
 		if (!ret) {
 			nr++;
 			*bio_flags = this_bio_flag;
@@ -3425,7 +3511,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 					 page, offset, iosize, pg_offset,
 					 bdev, &epd->bio,
 					 end_bio_extent_writepage,
-					 0, 0, 0, false);
+					 0, 0, 0, false, 0, NULL);
 		if (ret) {
 			SetPageError(page);
 			if (PageWriteback(page))
@@ -3738,7 +3824,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 					 p, offset, PAGE_SIZE, 0, bdev,
 					 &epd->bio,
 					 end_bio_extent_buffer_writepage,
-					 0, 0, 0, false);
+					 0, 0, 0, false, 0, NULL);
 		if (ret) {
 			set_btree_ioerr(p);
 			if (PageWriteback(p))
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 369daa5d4f73..54a7d6864d05 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -35,6 +35,7 @@
  * type for this bio
  */
 #define EXTENT_BIO_COMPRESSED 1
+#define EXTENT_BIO_ENCRYPTED 2
 #define EXTENT_BIO_FLAG_SHIFT 16
 
 /* these are bit numbers for test/set bit */
@@ -553,5 +554,6 @@ u64 btrfs_find_lock_delalloc_range(struct inode *inode,
 #endif
 struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 					       u64 start);
+void btrfs_increment_iv(char *iv, u32 inc);
 
 #endif
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 7eea8b6e2cd3..0cc0ffbe0453 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -6,7 +6,7 @@
 #include "ctree.h"
 #include "extent_map.h"
 #include "compression.h"
-
+#include "extent_io.h"
 
 static struct kmem_cache *extent_map_cache;
 
@@ -210,6 +210,20 @@ static int mergable_maps(struct extent_map *prev, struct extent_map *next)
 	if (!list_empty(&prev->list) || !list_empty(&next->list))
 		return 0;
 
+	if (prev->key_number != next->key_number)
+		return 0;
+
+	if (next->key_number != 0) {
+		char iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+
+		memcpy(iv, prev->iv, BTRFS_ENCRYPTION_BLOCK_LENGTH);
+		btrfs_increment_iv(iv, prev->len /
+				   BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
+		if (memcmp(iv, next->iv, BTRFS_ENCRYPTION_BLOCK_LENGTH))
+			return 0;
+	}
+
 	if (extent_map_end(prev) == next->start &&
 	    prev->flags == next->flags &&
 	    prev->bdev == next->bdev &&
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 31977ffd6190..2bc1087564a1 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -5,6 +5,7 @@
 
 #include <linux/rbtree.h>
 #include <linux/refcount.h>
+#include <linux/btrfs_tree.h>
 
 #define EXTENT_MAP_LAST_BYTE ((u64)-4)
 #define EXTENT_MAP_HOLE ((u64)-3)
@@ -14,6 +15,7 @@
 /* bits for the flags field */
 #define EXTENT_FLAG_PINNED 0 /* this entry not yet on disk, don't free it */
 #define EXTENT_FLAG_COMPRESSED 1
+#define EXTENT_FLAG_ENCRYPTED 2
 #define EXTENT_FLAG_PREALLOC 3 /* pre-allocated extent */
 #define EXTENT_FLAG_LOGGING 4 /* Logging this extent */
 #define EXTENT_FLAG_FILLING 5 /* Filling in a preallocated extent */
@@ -45,6 +47,9 @@ struct extent_map {
 	};
 	refcount_t refs;
 	unsigned int compress_type;
+	unsigned int encrypt_type;
+	u64 key_number;
+	char iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
 	struct list_head list;
 };
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ba74827beb32..a903997e67ba 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -13,6 +13,7 @@
 #include "volumes.h"
 #include "print-tree.h"
 #include "compression.h"
+#include "encryption.h"
 
 #define __MAX_CSUM_ITEMS(r, size) ((unsigned long)(((BTRFS_LEAF_DATA_SIZE(r) - \
 				   sizeof(struct btrfs_item) * 2) / \
@@ -931,6 +932,7 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 	u64 bytenr;
 	u8 type = btrfs_file_extent_type(leaf, fi);
 	int compress_type = btrfs_file_extent_compression(leaf, fi);
+	int encrypt_type = btrfs_file_extent_encryption(leaf, fi);
 
 	em->bdev = fs_info->fs_devices->latest_bdev;
 	btrfs_item_key_to_cpu(leaf, &key, slot);
@@ -960,7 +962,18 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 			em->block_start = EXTENT_MAP_HOLE;
 			return;
 		}
-		if (compress_type != BTRFS_COMPRESS_NONE) {
+
+		if (encrypt_type != BTRFS_ENCRYPTION_NONE) {
+			set_bit(EXTENT_FLAG_ENCRYPTED, &em->flags);
+			em->encrypt_type = encrypt_type;
+			em->block_start = bytenr;
+			em->block_len = em->orig_block_len;
+
+			if (compress_type != BTRFS_COMPRESS_NONE) {
+				set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
+				em->compress_type = compress_type;
+			}
+		} else if (compress_type != BTRFS_COMPRESS_NONE) {
 			set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 			em->compress_type = compress_type;
 			em->block_start = bytenr;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7018a2169e3e..52ea7d7c880b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1953,7 +1953,7 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 	u64 map_length;
 	int ret;
 
-	if (bio_flags & EXTENT_BIO_COMPRESSED)
+	if (bio_flags & (EXTENT_BIO_COMPRESSED | EXTENT_BIO_ENCRYPTED))
 		return 0;
 
 	length = bio->bi_iter.bi_size;
@@ -7039,6 +7039,14 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	btrfs_extent_item_to_extent_map(inode, path, item,
 			new_inline, em);
 
+	if (btrfs_file_extent_type(leaf, item) != BTRFS_ENCRYPTION_NONE) {
+		em->key_number = btrfs_file_extent_enc_key_number(leaf,
+				(struct btrfs_file_extent_item_enc *)item);
+
+		read_eb_member(leaf, item, struct btrfs_file_extent_item_enc,
+			       iv, em->iv);
+	}
+
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		goto insert;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index aefce895e994..fc12c28bdd93 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -271,6 +271,8 @@ struct btrfs_io_bio {
 	u8 *csum_allocated;
 	btrfs_io_bio_end_io_t *end_io;
 	struct bvec_iter iter;
+	u64 key_number;
+	char iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
 	/*
 	 * This member must come last, bio_alloc_bioset will allocate enough
 	 * bytes for entire btrfs_io_bio but relies on bio being last.
-- 
2.19.2

