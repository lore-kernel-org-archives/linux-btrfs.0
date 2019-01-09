Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB7EC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4298920821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gRrj8IWh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbfAIB1o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:27:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46008 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729607AbfAIB1n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id t6so5962482wrr.12;
        Tue, 08 Jan 2019 17:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KjNSi+0N2H/8Xhjc+yJMuYo30/iCeyb8aSeyo2QGjjk=;
        b=gRrj8IWhZlKwr1BCLy5akVCJ3PmSNlKUFH1hJWPUYUdil/N3oOraY6FlaYQe0ZXJ2X
         OvXicznAq9hQ19cxcmnYUjMZvAzzjMD7GFQ5Syu0QgQE25NZUQu/Upts6RD/3icWSIcu
         OvLv3w3xNYFyaV07byGVF/ai/SN/o3CD7Ps3BBAOXBa/IvD338So0GrTHXA5jsHfvhQw
         f1BNZJWCu4iLVTsu+s41JJHQF3a8QIMzjB0zB3v/3Skch/YkBI2OD1l1r4ZwMMnRLepG
         KpjjWKcoca7zbEiuzT9r95Nes5sEapQKy57aoTrwq8XKXhd4OjXoKtGWafyb93lacLTb
         4oTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=KjNSi+0N2H/8Xhjc+yJMuYo30/iCeyb8aSeyo2QGjjk=;
        b=LrKKVrTJcl/pAq/cGtP+Y8BKh1T9kHP7pVY7IchXYWIHzopcQ9yqqXYhRz4Vh/qTCs
         1gw8Rgx3H5fiD7df6S/d77aJdMymqhwqRSE6AsGqZljlrMcWF/Rnp6raET30FebDWFPU
         p/yKaA5mZtI/9eM8YqBEoul0hmQkRE8tyKUWEQgA2RV6zfan62ch45WheIHVZfZqWvH9
         4uYafMTxuk/rpHLUKiK7Zc9uvTHt5SDKMgBNd5H0sBAEX4LlCOTi68UsuprWmrIBJOp/
         PthMNrVZvub+jsD1l3uxu2IzT5gZoQgcf0Dpb29i45WE8bKxj05PyZ+mFaUl/0V+nFRt
         wbrQ==
X-Gm-Message-State: AJcUukedQC7UuIf6Q+XgboOt+WrtGhuK4e9KA4prfUv5kAU3HmeiJzwI
        NjoEopEDPfSKKEi8CZudcro=
X-Google-Smtp-Source: ALg8bN5+HCjvAdxj37VF8I87Du3TUZwhPy0P9HRqUmeS4au3Vgho03ac5NJ9uq85u22LAUF6TzkwKA==
X-Received: by 2002:adf:8342:: with SMTP id 60mr2932296wrd.212.1546997258941;
        Tue, 08 Jan 2019 17:27:38 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:38 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 11/19] btrfs: allow writing encrypted inline extents
Date:   Wed,  9 Jan 2019 01:26:53 +0000
Message-Id: <20190109012701.26441-11-mark@harmstone.com>
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
 fs/btrfs/ctree.h      |   5 +-
 fs/btrfs/encryption.c | 156 +++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/encryption.h |   9 +++
 fs/btrfs/inode.c      |  99 +++++++++++++++++++++++----
 fs/btrfs/ioctl.c      |   2 +-
 5 files changed, 254 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a1368c5c1236..51fcc24047f8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2393,8 +2393,11 @@ btrfs_file_extent_inline_start(const struct btrfs_file_extent_item *e)
 	return (unsigned long)e + BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
 
-static inline u32 btrfs_file_extent_calc_inline_size(u32 datasize)
+static inline u32 btrfs_file_extent_calc_inline_size(u32 datasize, bool enc)
 {
+	if (enc)
+		datasize += sizeof(struct btrfs_file_extent_inline_enc);
+
 	return BTRFS_FILE_EXTENT_INLINE_DATA_START + datasize;
 }
 
diff --git a/fs/btrfs/encryption.c b/fs/btrfs/encryption.c
index a1c9a982b009..81313c4378b4 100644
--- a/fs/btrfs/encryption.c
+++ b/fs/btrfs/encryption.c
@@ -6,6 +6,7 @@
 #include <crypto/hash.h>
 #include <keys/user-type.h>
 #include "ctree.h"
+#include "btrfs_inode.h"
 #include "encryption.h"
 
 #define KEY_SIG_PREFIX "btrfs:"
@@ -80,7 +81,7 @@ static int derive_aes_key(u64 salt, char *data, unsigned int datalen,
 	return ret;
 }
 
-static int btrfs_load_key(struct btrfs_enc_key *k)
+int btrfs_load_key(struct btrfs_enc_key *k)
 {
 	struct key *key;
 	u64 salt;
@@ -361,3 +362,156 @@ int btrfs_get_key_id(u64 salt, char *password, unsigned int pwdlen,
 
 	return ret;
 }
+
+void btrfs_find_inode_encryption_key(struct inode *inode,
+			       struct btrfs_enc_key **key_ret)
+{
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_enc_key *k;
+
+	*key_ret = NULL;
+
+	if (BTRFS_I(inode)->prop_key == 0)
+		return;
+
+	down_write(&fs_info->key_sem);
+
+	list_for_each_entry(k, &fs_info->key_list, key_list) {
+		if (k->key_number == BTRFS_I(inode)->prop_key) {
+			*key_ret = k;
+			break;
+		}
+	}
+
+	if (!*key_ret && fs_info->key_root) {
+		struct btrfs_key key;
+		struct btrfs_path *path;
+		int ret;
+		struct extent_buffer *leaf;
+		int slot;
+		u32 item_size;
+		struct btrfs_encryption_key_item *item;
+		char key_id[BTRFS_ENCRYPTION_KEY_ID_LENGTH];
+
+		path = btrfs_alloc_path();
+		if (!path) {
+			up_write(&fs_info->key_sem);
+			return;
+		}
+
+		key.objectid = BTRFS_I(inode)->prop_key;
+		key.type = BTRFS_ENCRYPTION_KEY;
+		key.offset = 0;
+
+		ret = btrfs_search_slot(NULL, fs_info->key_root, &key,
+					path, 0,  0);
+		if (ret < 0) {
+			btrfs_free_path(path);
+			up_write(&fs_info->key_sem);
+			return;
+		}
+
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+
+		if (key.objectid != BTRFS_I(inode)->prop_key ||
+			key.type != BTRFS_ENCRYPTION_KEY) {
+			btrfs_free_path(path);
+			up_write(&fs_info->key_sem);
+			return;
+		}
+
+		item_size = btrfs_item_size_nr(leaf, slot);
+
+		if (item_size != sizeof(struct btrfs_encryption_key_item)) {
+			btrfs_free_path(path);
+			up_write(&fs_info->key_sem);
+		}
+
+		item = btrfs_item_ptr(leaf, path->slots[0],
+					struct btrfs_encryption_key_item);
+
+		read_eb_member(leaf, item,
+				struct btrfs_encryption_key_item,
+				key_id, key_id);
+
+		k = kmalloc(sizeof(*k), GFP_KERNEL);
+		if (!k) {
+			btrfs_free_path(path);
+			up_write(&fs_info->key_sem);
+			return;
+		}
+
+		memcpy(k->key_id, key_id, BTRFS_ENCRYPTION_KEY_ID_LENGTH);
+		k->key_number = key.objectid;
+		k->loaded = false;
+		k->added = false;
+		k->used = true;
+		mutex_init(&k->lock);
+
+		list_add(&k->key_list, &fs_info->key_list);
+
+		btrfs_free_path(path);
+
+		*key_ret = k;
+	}
+
+	up_write(&fs_info->key_sem);
+}
+
+int btrfs_encrypt_inline(struct extent_buffer *eb, char *plaintext,
+			 unsigned long start, unsigned long len,
+			 struct btrfs_enc_key *key, char *iv)
+{
+	struct scatterlist sg;
+	struct scatterlist sg2;
+	struct skcipher_request *req = NULL;
+	int tmp_len;
+	char *tmp = NULL;
+	char ctr[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+	int ret = -EFAULT;
+	struct btrfs_file_extent_inline_enc *eienc;
+
+	key->used = true;
+
+	tmp_len = len + sizeof(struct btrfs_file_extent_inline_enc);
+	tmp = kmalloc(tmp_len, GFP_KERNEL);
+	if (!tmp) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(ctr, iv, BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
+	sg_init_one(&sg, plaintext, len);
+	sg_init_one(&sg2, tmp + sizeof(struct btrfs_file_extent_inline_enc),
+		    len);
+
+	req = skcipher_request_alloc(key->skcipher, GFP_KERNEL);
+	if (!req) {
+		pr_info("could not allocate skcipher request\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	skcipher_request_set_crypt(req, &sg, &sg2, len, ctr);
+
+	ret = crypto_skcipher_decrypt(req);
+	if (ret < 0)
+		goto out;
+
+	eienc = (struct btrfs_file_extent_inline_enc *)tmp;
+
+	eienc->key_number = cpu_to_le64(key->key_number);
+	memcpy(eienc->iv, iv, BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
+	write_extent_buffer(eb, tmp, start, tmp_len);
+
+out:
+	if (req)
+		skcipher_request_free(req);
+
+	kfree(tmp);
+	return ret;
+}
diff --git a/fs/btrfs/encryption.h b/fs/btrfs/encryption.h
index add7ee6d879d..dbc035a880a5 100644
--- a/fs/btrfs/encryption.h
+++ b/fs/btrfs/encryption.h
@@ -36,4 +36,13 @@ int btrfs_decrypt(struct btrfs_fs_info *fs_info,
 int btrfs_get_key_id(u64 salt, char *password, unsigned int pwdlen,
 		     char *key_id);
 
+void btrfs_find_inode_encryption_key(struct inode *inode,
+			       struct btrfs_enc_key **key_ret);
+
+int btrfs_encrypt_inline(struct extent_buffer *eb, char *plaintext,
+			 unsigned long start, unsigned long len,
+			 struct btrfs_enc_key *key, char *iv);
+
+int btrfs_load_key(struct btrfs_enc_key *k);
+
 #endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 202a7458584f..7018a2169e3e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -28,6 +28,7 @@
 #include <linux/magic.h>
 #include <linux/iversion.h>
 #include <asm/unaligned.h>
+#include <crypto/rng.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -166,7 +167,8 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root, struct inode *inode,
 				u64 start, size_t size, size_t compressed_size,
 				int compress_type,
-				struct page **compressed_pages)
+				struct page **compressed_pages,
+				struct btrfs_enc_key *enc_key, char *iv)
 {
 	struct extent_buffer *leaf;
 	struct page *page = NULL;
@@ -190,7 +192,8 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 		key.offset = start;
 		key.type = BTRFS_EXTENT_DATA_KEY;
 
-		datasize = btrfs_file_extent_calc_inline_size(cur_size);
+		datasize = btrfs_file_extent_calc_inline_size(cur_size,
+							      enc_key);
 		path->leave_spinning = 1;
 		ret = btrfs_insert_empty_item(trans, root, path, &key,
 					      datasize);
@@ -202,11 +205,16 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 			    struct btrfs_file_extent_item);
 	btrfs_set_file_extent_generation(leaf, ei, trans->transid);
 	btrfs_set_file_extent_type(leaf, ei, BTRFS_FILE_EXTENT_INLINE);
-	btrfs_set_file_extent_encryption(leaf, ei, 0);
 	btrfs_set_file_extent_other_encoding(leaf, ei, 0);
 	btrfs_set_file_extent_ram_bytes(leaf, ei, size);
 	ptr = btrfs_file_extent_inline_start(ei);
 
+	if (enc_key)
+		btrfs_set_file_extent_encryption(leaf, ei,
+						 BTRFS_ENCRYPTION_AES256CTR);
+	else
+		btrfs_set_file_extent_encryption(leaf, ei, 0);
+
 	if (compress_type != BTRFS_COMPRESS_NONE) {
 		struct page *cpage;
 		int i = 0;
@@ -231,7 +239,20 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 		btrfs_set_file_extent_compression(leaf, ei, 0);
 		kaddr = kmap_atomic(page);
 		offset = start & (PAGE_SIZE - 1);
-		write_extent_buffer(leaf, kaddr + offset, ptr, size);
+
+		if (enc_key) {
+			ret = btrfs_encrypt_inline(leaf, kaddr + offset,
+						   ptr, size, enc_key, iv);
+
+			if (ret) {
+				kunmap_atomic(kaddr);
+				put_page(page);
+				goto fail;
+			}
+		} else {
+			write_extent_buffer(leaf, kaddr + offset, ptr, size);
+		}
+
 		kunmap_atomic(kaddr);
 		put_page(page);
 	}
@@ -263,7 +284,8 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 static noinline int cow_file_range_inline(struct inode *inode, u64 start,
 					  u64 end, size_t compressed_size,
 					  int compress_type,
-					  struct page **compressed_pages)
+					  struct page **compressed_pages,
+					  struct btrfs_enc_key *key, char *iv)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -304,10 +326,10 @@ static noinline int cow_file_range_inline(struct inode *inode, u64 start,
 
 	if (compressed_size && compressed_pages)
 		extent_item_size = btrfs_file_extent_calc_inline_size(
-		   compressed_size);
+		   compressed_size, key);
 	else
 		extent_item_size = btrfs_file_extent_calc_inline_size(
-		    inline_len);
+		    inline_len, key);
 
 	ret = __btrfs_drop_extents(trans, root, inode, path,
 				   start, aligned_end, NULL,
@@ -322,7 +344,7 @@ static noinline int cow_file_range_inline(struct inode *inode, u64 start,
 	ret = insert_inline_extent(trans, path, extent_inserted,
 				   root, inode, start,
 				   inline_len, compressed_size,
-				   compress_type, compressed_pages);
+				   compress_type, compressed_pages, key, iv);
 	if (ret && ret != -ENOSPC) {
 		btrfs_abort_transaction(trans, ret);
 		goto out;
@@ -408,6 +430,18 @@ static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
 	return 0;
 }
 
+static inline int inode_need_encrypt(struct inode *inode)
+{
+	struct btrfs_enc_key *key;
+
+	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_ENCRYPT))
+		return 0;
+
+	btrfs_find_inode_encryption_key(inode, &key);
+
+	return key ? 1 : 0;
+}
+
 static inline void inode_should_defrag(struct btrfs_inode *inode,
 		u64 start, u64 end, u64 num_bytes, u64 small_write)
 {
@@ -451,8 +485,10 @@ static noinline void compress_file_range(struct inode *inode,
 	unsigned long total_in = 0;
 	int i;
 	int will_compress;
+	struct btrfs_enc_key *key;
 	int compress_type = fs_info->compress_type;
 	int redirty = 0;
+	char iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
 
 	inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1,
 			SZ_16K);
@@ -480,11 +516,13 @@ static noinline void compress_file_range(struct inode *inode,
 
 	total_compressed = actual_end - start;
 
+	btrfs_find_inode_encryption_key(inode, &key);
+
 	/*
 	 * skip compression for a small file range(<=blocksize) that
 	 * isn't an inline extent, since it doesn't save disk space at all.
 	 */
-	if (total_compressed <= blocksize &&
+	if (!key && total_compressed <= blocksize &&
 	   (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
 		goto cleanup_and_bail_uncompressed;
 
@@ -564,12 +602,14 @@ static noinline void compress_file_range(struct inode *inode,
 			 * to make an uncompressed inline extent.
 			 */
 			ret = cow_file_range_inline(inode, start, end, 0,
-						    BTRFS_COMPRESS_NONE, NULL);
+						    BTRFS_COMPRESS_NONE, NULL,
+						    key, iv);
 		} else {
 			/* try making a compressed inline extent */
 			ret = cow_file_range_inline(inode, start, end,
 						    total_compressed,
-						    compress_type, pages);
+						    compress_type, pages,
+						    key, iv);
 		}
 		if (ret <= 0) {
 			unsigned long clear_flags = EXTENT_DELALLOC |
@@ -952,6 +992,7 @@ static noinline int cow_file_range(struct inode *inode,
 	unsigned long page_ops;
 	bool extent_reserved = false;
 	int ret = 0;
+	struct btrfs_enc_key *key = NULL;
 
 	if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
 		WARN_ON_ONCE(1);
@@ -965,10 +1006,23 @@ static noinline int cow_file_range(struct inode *inode,
 
 	inode_should_defrag(BTRFS_I(inode), start, end, num_bytes, SZ_64K);
 
+	if (inode_need_encrypt(inode))
+		btrfs_find_inode_encryption_key(inode, &key);
+
 	if (start == 0) {
+		char iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+
+		if (key) {
+			ret = crypto_rng_get_bytes(crypto_default_rng, iv,
+						BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
+			if (ret)
+				goto out_unlock;
+		}
+
 		/* lets try to make an inline extent */
 		ret = cow_file_range_inline(inode, start, end, 0,
-					    BTRFS_COMPRESS_NONE, NULL);
+					    BTRFS_COMPRESS_NONE, NULL, key, iv);
 		if (ret == 0) {
 			/*
 			 * We use DO_ACCOUNTING here because we need the
@@ -3755,6 +3809,19 @@ static int btrfs_read_locked_inode(struct inode *inode,
 	}
 
 	btrfs_sync_inode_flags_to_i_flags(inode);
+
+	if (BTRFS_I(inode)->prop_key != 0) {
+		struct btrfs_enc_key *key;
+
+		btrfs_find_inode_encryption_key(inode, &key);
+
+		if (key && !key->loaded) {
+			mutex_lock(&key->lock);
+			btrfs_load_key(key);
+			mutex_unlock(&key->lock);
+		}
+	}
+
 	return 0;
 }
 
@@ -4677,7 +4744,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 				u32 size = (u32)(new_size - found_key.offset);
 
 				btrfs_set_file_extent_ram_bytes(leaf, fi, size);
-				size = btrfs_file_extent_calc_inline_size(size);
+				size = btrfs_file_extent_calc_inline_size(size,
+									false);
 				btrfs_truncate_item(root->fs_info, path, size, 1);
 			} else if (!del_item) {
 				/*
@@ -6167,6 +6235,9 @@ static void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
 	}
 
+	if (flags & BTRFS_INODE_ENCRYPT)
+		BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
+
 	btrfs_sync_inode_flags_to_i_flags(inode);
 }
 
@@ -10230,7 +10301,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	key.objectid = btrfs_ino(BTRFS_I(inode));
 	key.offset = 0;
 	key.type = BTRFS_EXTENT_DATA_KEY;
-	datasize = btrfs_file_extent_calc_inline_size(name_len);
+	datasize = btrfs_file_extent_calc_inline_size(name_len, false);
 	err = btrfs_insert_empty_item(trans, root, path, &key,
 				      datasize);
 	if (err) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 92fbed90dc4e..6589656e3988 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3851,7 +3851,7 @@ static int clone_copy_inline_extent(struct inode *dst,
 		return ret;
 
 	if (skip) {
-		const u32 start = btrfs_file_extent_calc_inline_size(0);
+		const u32 start = btrfs_file_extent_calc_inline_size(0, false);
 
 		memmove(inline_data + start, inline_data + start + skip, datal);
 	}
-- 
2.19.2

