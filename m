Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37034C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E28E120821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mkQsH/oa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbfAIB1q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:27:46 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43983 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729463AbfAIB1q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:46 -0500
Received: by mail-wr1-f68.google.com with SMTP id r10so5985437wrs.10;
        Tue, 08 Jan 2019 17:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EzW93gEgWsfTpxPAaTuWjU1X/H8eKAtRzIDsKr1uTpY=;
        b=mkQsH/oabhGy3PPfV+0FOEf4p7R3XhpgBfzLg/CmGBpfy4vcdXIVcvWfvVCQPczITs
         6zHXaY220AW8+AbMMhLkjG84MWmWGaAWzL1TKYa0eSolBqmUwL6TU8NbkeqajaXLHGRp
         kQD6jOjFvrl1gNmfAafhoTPM3Vs1tw1m3XQ9BV7UFzgk7Tj0El9vZGU3Cffmg7fKfp0G
         ZRsczu9vGf6OZm0MrJtylgYNSKIkBpgBWn7uw1B4Cze7z9j8MsIn9C4Etoq0Kb7ZxM/+
         W6HwS5CvP27m8KNErBjriffp+b+PbEDJJ6ClehyXtmvA2UQ7sbc5paooG0VxA3wIJwBh
         Fv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=EzW93gEgWsfTpxPAaTuWjU1X/H8eKAtRzIDsKr1uTpY=;
        b=URK69lXkXCcbT+f2CS+qmfUoqAKiMy1l5HOcYXe36vnIkLTiyvFFMXN89MU0ieGtBQ
         4if6Eb5mgw9jnP5TP+Myun4orkw5B/PjhH9+BPUJXELGbXMhBUj6IoMezQ198zO84I7y
         9FNHF1eB92RvD/UAtXrrJtR84atP2YTug+jD/nuOypbGxXse366EMYKqiotZNU1MCA2X
         snK7PB/cPgDI3Zj56sc+LhzTS/D6FkTTAZls45JkvscR4hrPNSB3Shx1W4hmvY1uw12+
         Eunj3qribTjc7WLK7ojNeohpVlmvqOTV5T3EtN++ksRqFfVSn+kYk3HXdenpmL8UlCfh
         kFIg==
X-Gm-Message-State: AJcUukesdgOGBi8gBp5FRpTLBd1Xp/XnivkBtzy7qX2a/ZRZ8d0Vpklp
        L96z9Gl1/a61X+lfVH+BwDE=
X-Google-Smtp-Source: ALg8bN4/r+jsFzBN7MaouE9M3KZZel/maZxbilYKUtOWOoIESwsrBBdJoLmOe9fzpZvBKAsglqFw0A==
X-Received: by 2002:a5d:6549:: with SMTP id z9mr3018213wrv.116.1546997262794;
        Tue, 08 Jan 2019 17:27:42 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:42 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 13/19] btrfs: allow writing normal and compressed encrypted extents
Date:   Wed,  9 Jan 2019 01:26:55 +0000
Message-Id: <20190109012701.26441-13-mark@harmstone.com>
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
 fs/btrfs/encryption.c   | 125 ++++++++++++++++++++++++++++
 fs/btrfs/encryption.h   |   8 ++
 fs/btrfs/extent_io.c    |  20 +++--
 fs/btrfs/inode.c        | 180 ++++++++++++++++++++++++++++++++++------
 fs/btrfs/ordered-data.c |  19 +++--
 fs/btrfs/ordered-data.h |  12 ++-
 6 files changed, 320 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/encryption.c b/fs/btrfs/encryption.c
index 41c001339cc7..2bf45c9f96fa 100644
--- a/fs/btrfs/encryption.c
+++ b/fs/btrfs/encryption.c
@@ -552,3 +552,128 @@ int btrfs_encrypt_inline(struct extent_buffer *eb, char *plaintext,
 	kfree(tmp);
 	return ret;
 }
+
+static int btrfs_encrypt_page(char *src, char *dest,
+			      struct btrfs_enc_key *key, char *iv)
+{
+	struct scatterlist sg;
+	struct scatterlist sg2;
+	struct skcipher_request *req = NULL;
+	int ret = -EFAULT;
+
+	req = skcipher_request_alloc(key->skcipher, GFP_KERNEL);
+	if (!req) {
+		pr_info("could not allocate skcipher request\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	sg_init_one(&sg, src, PAGE_SIZE);
+	sg_init_one(&sg2, dest, PAGE_SIZE);
+	skcipher_request_set_crypt(req, &sg, &sg2, PAGE_SIZE, iv);
+
+	ret = crypto_skcipher_encrypt(req);
+
+	if (ret < 0)
+		goto out;
+
+out:
+	if (req)
+		skcipher_request_free(req);
+	return ret;
+}
+
+int btrfs_encrypt_pages(struct address_space *mapping, struct page **pages,
+			unsigned long *nr_pages, u64 start,
+			struct btrfs_enc_key *key, char *iv)
+{
+	int ret;
+	unsigned int i;
+	char ctr[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+
+	if (!key->loaded) {
+		mutex_lock(&key->lock);
+		ret = btrfs_load_key(key);
+		mutex_unlock(&key->lock);
+
+		if (ret) {
+			*nr_pages = 0;
+			return ret;
+		}
+	}
+
+	key->used = true;
+
+	memcpy(ctr, iv, BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
+	for (i = 0; i < *nr_pages; i++) {
+		struct page *in_page;
+		char *src, *dest;
+
+		in_page = find_get_page(mapping, start >> PAGE_SHIFT);
+
+		pages[i] = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+		if (!pages[i]) {
+			*nr_pages = i;
+			return -ENOMEM;
+		}
+
+		src = kmap(in_page);
+		dest = kmap(pages[i]);
+
+		ret = btrfs_encrypt_page(src, dest, key, ctr);
+
+		kunmap(pages[i]);
+		kunmap(in_page);
+
+		if (ret) {
+			*nr_pages = i;
+			return ret;
+		}
+
+		start += PAGE_SIZE;
+	}
+
+	return 0;
+}
+
+int btrfs_encrypt_compressed_pages(struct page **pages,
+				   unsigned long *nr_pages,
+				   struct btrfs_enc_key *key, char *iv)
+{
+	int ret;
+	unsigned int i;
+	char ctr[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+
+	if (!key->loaded) {
+		mutex_lock(&key->lock);
+		ret = btrfs_load_key(key);
+		mutex_unlock(&key->lock);
+
+		if (ret) {
+			*nr_pages = 0;
+			return ret;
+		}
+	}
+
+	key->used = true;
+
+	memcpy(ctr, iv, BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
+	for (i = 0; i < *nr_pages; i++) {
+		char *buf;
+
+		buf = kmap(pages[i]);
+
+		ret = btrfs_encrypt_page(buf, buf, key, ctr);
+
+		kunmap(pages[i]);
+
+		if (ret) {
+			*nr_pages = i;
+			return ret;
+		}
+	}
+
+	return 0;
+}
diff --git a/fs/btrfs/encryption.h b/fs/btrfs/encryption.h
index 0d24dc51793c..cf10859fafe1 100644
--- a/fs/btrfs/encryption.h
+++ b/fs/btrfs/encryption.h
@@ -46,6 +46,14 @@ int btrfs_encrypt_inline(struct extent_buffer *eb, char *plaintext,
 			 unsigned long start, unsigned long len,
 			 struct btrfs_enc_key *key, char *iv);
 
+int btrfs_encrypt_pages(struct address_space *mapping, struct page **pages,
+			unsigned long *nr_pages, u64 start,
+			struct btrfs_enc_key *key, char *iv);
+
+int btrfs_encrypt_compressed_pages(struct page **pages,
+				   unsigned long *nr_pages,
+				   struct btrfs_enc_key *key, char *iv);
+
 int btrfs_load_key(struct btrfs_enc_key *k);
 
 #endif
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 73fb0af50da8..92bc9924c001 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3407,7 +3407,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 	size_t blocksize;
 	int ret = 0;
 	int nr = 0;
-	bool compressed;
+	bool compressed, encrypted;
 
 	if (tree->ops && tree->ops->writepage_start_hook) {
 		ret = tree->ops->writepage_start_hook(page, start,
@@ -3469,28 +3469,30 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 		bdev = em->bdev;
 		block_start = em->block_start;
 		compressed = test_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
+		encrypted = test_bit(EXTENT_FLAG_ENCRYPTED, &em->flags);
 		free_extent_map(em);
 		em = NULL;
 
 		/*
-		 * compressed and inline extents are written through other
-		 * paths in the FS
+		 * compressed, encrypted, or inline extents are written through
+		 * other paths in the FS
 		 */
-		if (compressed || block_start == EXTENT_MAP_HOLE ||
-		    block_start == EXTENT_MAP_INLINE) {
+		if (compressed || encrypted ||
+			block_start == EXTENT_MAP_HOLE ||
+			block_start == EXTENT_MAP_INLINE) {
 			/*
 			 * end_io notification does not happen here for
 			 * compressed extents
 			 */
-			if (!compressed && tree->ops &&
+			if (!compressed && !encrypted && tree->ops &&
 			    tree->ops->writepage_end_io_hook)
 				tree->ops->writepage_end_io_hook(page, cur,
 							 cur + iosize - 1,
 							 NULL, 1);
-			else if (compressed) {
+			else if (compressed || encrypted) {
 				/* we don't want to end_page_writeback on
-				 * a compressed extent.  this happens
-				 * elsewhere
+				 * a compressed or encrypted extent.
+				 * This happens elsewhere
 				 */
 				nr++;
 			}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 52ea7d7c880b..61481833f5e4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -97,7 +97,8 @@ static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
 				       u64 orig_start, u64 block_start,
 				       u64 block_len, u64 orig_block_len,
 				       u64 ram_bytes, int compress_type,
-				       int type);
+				       int type, struct btrfs_enc_key *enc_key,
+				       char *iv);
 
 static void __endio_write_update_ordered(struct inode *inode,
 					 const u64 offset, const u64 bytes,
@@ -375,6 +376,8 @@ struct async_extent {
 	struct page **pages;
 	unsigned long nr_pages;
 	int compress_type;
+	struct btrfs_enc_key *key;
+	char iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
 	struct list_head list;
 };
 
@@ -394,7 +397,8 @@ static noinline int add_async_extent(struct async_cow *cow,
 				     u64 compressed_size,
 				     struct page **pages,
 				     unsigned long nr_pages,
-				     int compress_type)
+				     int compress_type,
+				     struct btrfs_enc_key *key, char *iv)
 {
 	struct async_extent *async_extent;
 
@@ -406,6 +410,11 @@ static noinline int add_async_extent(struct async_cow *cow,
 	async_extent->pages = pages;
 	async_extent->nr_pages = nr_pages;
 	async_extent->compress_type = compress_type;
+	async_extent->key = key;
+
+	if (key)
+		memcpy(async_extent->iv, iv, BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
 	list_add_tail(&async_extent->list, &cow->extents);
 	return 0;
 }
@@ -498,8 +507,6 @@ static noinline void compress_file_range(struct inode *inode,
 	will_compress = 0;
 	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
 	BUILD_BUG_ON((BTRFS_MAX_COMPRESSED % PAGE_SIZE) != 0);
-	nr_pages = min_t(unsigned long, nr_pages,
-			BTRFS_MAX_COMPRESSED / PAGE_SIZE);
 
 	/*
 	 * we don't want to send crud past the end of i_size through
@@ -526,8 +533,6 @@ static noinline void compress_file_range(struct inode *inode,
 	   (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
 		goto cleanup_and_bail_uncompressed;
 
-	total_compressed = min_t(unsigned long, total_compressed,
-			BTRFS_MAX_UNCOMPRESSED);
 	total_in = 0;
 	ret = 0;
 
@@ -537,6 +542,8 @@ static noinline void compress_file_range(struct inode *inode,
 	 * change at any time if we discover bad compression ratios.
 	 */
 	if (inode_need_compress(inode, start, end)) {
+		nr_pages = min_t(unsigned long, nr_pages,
+				 BTRFS_MAX_COMPRESSED / PAGE_SIZE);
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
@@ -567,6 +574,9 @@ static noinline void compress_file_range(struct inode *inode,
 			redirty = 1;
 		}
 
+		total_compressed = min_t(unsigned long, total_compressed,
+					 BTRFS_MAX_UNCOMPRESSED);
+
 		/* Compression level is applied here and only here */
 		ret = btrfs_compress_pages(
 			compress_type | (fs_info->compress_level << 4),
@@ -594,6 +604,37 @@ static noinline void compress_file_range(struct inode *inode,
 			will_compress = 1;
 		}
 	}
+
+	if (key) {
+		if (!pages) {
+			pages = kcalloc(nr_pages,
+					sizeof(struct page *), GFP_NOFS);
+			if (!pages)
+				goto cont;
+		}
+
+		if (!redirty) {
+			extent_range_clear_dirty_for_io(inode, start, end);
+			redirty = 1;
+		}
+
+		ret = crypto_rng_get_bytes(crypto_default_rng, iv,
+					   BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
+		if (ret)
+			goto cont;
+
+		if (will_compress) {
+			ret = btrfs_encrypt_compressed_pages(pages, &nr_pages,
+							     key, iv);
+		} else {
+			ret = btrfs_encrypt_pages(inode->i_mapping, pages,
+						  &nr_pages, start, key, iv);
+		}
+
+		if (ret)
+			key = NULL;
+	}
 cont:
 	if (start == 0) {
 		/* lets try to make an inline extent */
@@ -664,7 +705,7 @@ static noinline void compress_file_range(struct inode *inode,
 			 */
 			add_async_extent(async_cow, start, total_in,
 					total_compressed, pages, nr_pages,
-					compress_type);
+					compress_type, key, iv);
 
 			if (start + total_in < end) {
 				start += total_in;
@@ -675,6 +716,29 @@ static noinline void compress_file_range(struct inode *inode,
 			return;
 		}
 	}
+
+	if (key) {
+		total_in = ALIGN(end - start, PAGE_SIZE);
+
+		if (total_in == 0)
+			return;
+
+		total_compressed = ALIGN(total_compressed, blocksize);
+
+		*num_added += 1;
+
+		if (!will_compress) {
+			compress_type = BTRFS_COMPRESS_NONE;
+			total_compressed = total_in;
+		}
+
+		add_async_extent(async_cow, start, total_in,
+				 total_compressed, pages, nr_pages,
+				 compress_type, key, iv);
+
+		return;
+	}
+
 	if (pages) {
 		/*
 		 * the compression code ran but failed to make things smaller,
@@ -710,7 +774,7 @@ static noinline void compress_file_range(struct inode *inode,
 	if (redirty)
 		extent_range_redirty_for_io(inode, start, end);
 	add_async_extent(async_cow, start, end - start + 1, 0, NULL, 0,
-			 BTRFS_COMPRESS_NONE);
+			 BTRFS_COMPRESS_NONE, NULL, NULL);
 	*num_added += 1;
 
 	return;
@@ -848,7 +912,8 @@ static noinline void submit_compressed_extents(struct inode *inode,
 				  ins.offset, /* orig_block_len */
 				  async_extent->ram_size, /* ram_bytes */
 				  async_extent->compress_type,
-				  BTRFS_ORDERED_COMPRESSED);
+				  BTRFS_ORDERED_COMPRESSED,
+				  async_extent->key, async_extent->iv);
 		if (IS_ERR(em))
 			/* ret value is not necessary due to void function */
 			goto out_free_reserve;
@@ -860,7 +925,9 @@ static noinline void submit_compressed_extents(struct inode *inode,
 						async_extent->ram_size,
 						ins.offset,
 						BTRFS_ORDERED_COMPRESSED,
-						async_extent->compress_type);
+						async_extent->compress_type,
+						async_extent->key,
+						async_extent->iv);
 		if (ret) {
 			btrfs_drop_extent_cache(BTRFS_I(inode),
 						async_extent->start,
@@ -1051,6 +1118,8 @@ static noinline int cow_file_range(struct inode *inode,
 			start + num_bytes - 1, 0);
 
 	while (num_bytes > 0) {
+		char iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+
 		cur_alloc_size = num_bytes;
 		ret = btrfs_reserve_extent(root, cur_alloc_size, cur_alloc_size,
 					   fs_info->sectorsize, 0, alloc_hint,
@@ -1060,6 +1129,14 @@ static noinline int cow_file_range(struct inode *inode,
 		cur_alloc_size = ins.offset;
 		extent_reserved = true;
 
+		if (key) {
+			ret = crypto_rng_get_bytes(crypto_default_rng, iv,
+						BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
+			if (ret)
+				goto out_reserve;
+		}
+
 		ram_size = ins.offset;
 		em = create_io_em(inode, start, ins.offset, /* len */
 				  start, /* orig_start */
@@ -1068,7 +1145,8 @@ static noinline int cow_file_range(struct inode *inode,
 				  ins.offset, /* orig_block_len */
 				  ram_size, /* ram_bytes */
 				  BTRFS_COMPRESS_NONE, /* compress_type */
-				  BTRFS_ORDERED_REGULAR /* type */);
+				  BTRFS_ORDERED_REGULAR /* type */,
+				  key, iv);
 		if (IS_ERR(em)) {
 			ret = PTR_ERR(em);
 			goto out_reserve;
@@ -1076,7 +1154,8 @@ static noinline int cow_file_range(struct inode *inode,
 		free_extent_map(em);
 
 		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
-					       ram_size, cur_alloc_size, 0);
+					       ram_size, cur_alloc_size, 0,
+					       key, iv);
 		if (ret)
 			goto out_drop_extent_cache;
 
@@ -1249,8 +1328,10 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->start = start;
 		async_cow->write_flags = write_flags;
 
-		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
-		    !btrfs_test_opt(fs_info, FORCE_COMPRESS))
+		if ((inode_need_encrypt(inode) &&
+			!inode_need_compress(inode, start, end)) ||
+		   (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
+		    !btrfs_test_opt(fs_info, FORCE_COMPRESS)))
 			cur_end = end;
 		else
 			cur_end = min(end, start + SZ_512K - 1);
@@ -1532,7 +1613,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					  num_bytes, /* block_len */
 					  disk_num_bytes, /* orig_block_len */
 					  ram_bytes, BTRFS_COMPRESS_NONE,
-					  BTRFS_ORDERED_PREALLOC);
+					  BTRFS_ORDERED_PREALLOC, NULL, NULL);
 			if (IS_ERR(em)) {
 				if (nocow)
 					btrfs_dec_nocow_writers(fs_info,
@@ -1550,7 +1631,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		}
 
 		ret = btrfs_add_ordered_extent(inode, cur_offset, disk_bytenr,
-					       num_bytes, num_bytes, type);
+					       num_bytes, num_bytes, type,
+					       NULL, NULL);
 		if (nocow)
 			btrfs_dec_nocow_writers(fs_info, disk_bytenr);
 		BUG_ON(ret); /* -ENOMEM */
@@ -1642,14 +1724,17 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
 	unsigned int write_flags = wbc_to_write_flags(wbc);
+	bool encrypt = inode_need_encrypt(inode);
 
-	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow &&
+	    !encrypt) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 1, nr_written);
-	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
+	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC &&
+		!force_cow && !encrypt) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode, start, end)) {
+	} else if (!inode_need_compress(inode, start, end) && !encrypt) {
 		ret = cow_file_range(inode, locked_page, start, end, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
@@ -2238,7 +2323,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       u64 disk_bytenr, u64 disk_num_bytes,
 				       u64 num_bytes, u64 ram_bytes,
 				       u8 compression, u8 encryption,
-				       u16 other_encoding, int extent_type)
+				       u16 other_encoding, int extent_type,
+				       u64 key_number, char *iv)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_file_extent_item *fi;
@@ -2248,11 +2334,17 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	u64 qg_released;
 	int extent_inserted = 0;
 	int ret;
+	size_t item_size;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
+	if (encryption != BTRFS_ENCRYPTION_NONE)
+		item_size = sizeof(struct btrfs_file_extent_item_enc);
+	else
+		item_size = sizeof(*fi);
+
 	/*
 	 * we may be replacing one extent in the tree with another.
 	 * The new extent is pinned in the extent map, and we don't want
@@ -2264,7 +2356,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	 */
 	ret = __btrfs_drop_extents(trans, root, inode, path, file_pos,
 				   file_pos + num_bytes, NULL, 0,
-				   1, sizeof(*fi), &extent_inserted);
+				   1, item_size, &extent_inserted);
 	if (ret)
 		goto out;
 
@@ -2275,7 +2367,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 
 		path->leave_spinning = 1;
 		ret = btrfs_insert_empty_item(trans, root, path, &ins,
-					      sizeof(*fi));
+					      item_size);
 		if (ret)
 			goto out;
 	}
@@ -2293,6 +2385,17 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_file_extent_encryption(leaf, fi, encryption);
 	btrfs_set_file_extent_other_encoding(leaf, fi, other_encoding);
 
+	if (encryption != BTRFS_ENCRYPTION_NONE) {
+		struct btrfs_file_extent_item_enc *fi_enc;
+
+		fi_enc = (struct btrfs_file_extent_item_enc *)fi;
+
+		btrfs_set_file_extent_enc_key_number(leaf, fi_enc, key_number);
+
+		write_eb_member(leaf, fi_enc, struct btrfs_file_extent_item_enc,
+				iv, iv);
+	}
+
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 
@@ -3091,14 +3194,27 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->file_offset +
 						logical_len);
 	} else {
+		u32 encrypt_type;
+		u64 key_number;
+
+		if (ordered_extent->key) {
+			encrypt_type = BTRFS_ENCRYPTION_AES256CTR;
+			key_number = ordered_extent->key->key_number;
+		} else {
+			encrypt_type = BTRFS_ENCRYPTION_NONE;
+			key_number = 0;
+		}
+
 		BUG_ON(root == fs_info->tree_root);
 		ret = insert_reserved_file_extent(trans, inode,
 						ordered_extent->file_offset,
 						ordered_extent->start,
 						ordered_extent->disk_len,
 						logical_len, logical_len,
-						compress_type, 0, 0,
-						BTRFS_FILE_EXTENT_REG);
+						compress_type, encrypt_type, 0,
+						BTRFS_FILE_EXTENT_REG,
+						key_number,
+						ordered_extent->iv);
 		if (!ret) {
 			clear_reserved_extent = false;
 			btrfs_release_delalloc_bytes(fs_info,
@@ -7283,7 +7399,7 @@ static struct extent_map *btrfs_create_dio_extent(struct inode *inode,
 				  block_start, block_len, orig_block_len,
 				  ram_bytes,
 				  BTRFS_COMPRESS_NONE, /* compress_type */
-				  type);
+				  type, NULL, NULL);
 		if (IS_ERR(em))
 			goto out;
 	}
@@ -7562,7 +7678,8 @@ static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
 				       u64 orig_start, u64 block_start,
 				       u64 block_len, u64 orig_block_len,
 				       u64 ram_bytes, int compress_type,
-				       int type)
+				       int type, struct btrfs_enc_key *enc_key,
+				       char *iv)
 {
 	struct extent_map_tree *em_tree;
 	struct extent_map *em;
@@ -7596,6 +7713,14 @@ static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
 		em->compress_type = compress_type;
 	}
 
+	if (enc_key) {
+		em->encrypt_type = BTRFS_ENCRYPTION_AES256CTR;
+		em->key_number = enc_key->key_number;
+		memcpy(em->iv, iv, BTRFS_ENCRYPTION_BLOCK_LENGTH);
+	} else {
+		em->encrypt_type = BTRFS_ENCRYPTION_NONE;
+	}
+
 	do {
 		btrfs_drop_extent_cache(BTRFS_I(inode), em->start,
 				em->start + em->len - 1, 0);
@@ -10413,7 +10538,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 						  cur_offset, ins.objectid,
 						  ins.offset, ins.offset,
 						  ins.offset, 0, 0, 0,
-						  BTRFS_FILE_EXTENT_PREALLOC);
+						  BTRFS_FILE_EXTENT_PREALLOC,
+						  0, NULL);
 		if (ret) {
 			btrfs_free_reserved_extent(fs_info, ins.objectid,
 						   ins.offset, 0);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 0c4ef208b8b9..5fbb60b5ddbe 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -170,7 +170,8 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
  */
 static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int dio, int compress_type)
+				      int type, int dio, int compress_type,
+				      struct btrfs_enc_key *key, char *iv)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -190,10 +191,14 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	entry->bytes_left = len;
 	entry->inode = igrab(inode);
 	entry->compress_type = compress_type;
+	entry->key = key;
 	entry->truncated_len = (u64)-1;
 	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
 		set_bit(type, &entry->flags);
 
+	if (key)
+		memcpy(entry->iv, iv, BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
 	if (dio)
 		set_bit(BTRFS_ORDERED_DIRECT, &entry->flags);
 
@@ -241,11 +246,12 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 }
 
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
-			     u64 start, u64 len, u64 disk_len, int type)
+			     u64 start, u64 len, u64 disk_len, int type,
+			     struct btrfs_enc_key *key, char *iv)
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  BTRFS_COMPRESS_NONE);
+					  BTRFS_COMPRESS_NONE, key, iv);
 }
 
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
@@ -253,16 +259,17 @@ int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 1,
-					  BTRFS_COMPRESS_NONE);
+					  BTRFS_COMPRESS_NONE, NULL, NULL);
 }
 
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int compress_type)
+				      int type, int compress_type,
+				      struct btrfs_enc_key *key, char *iv)
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  compress_type);
+					  compress_type, key, iv);
 }
 
 /*
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 02d813aaa261..563d882fdd16 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -95,6 +95,12 @@ struct btrfs_ordered_extent {
 	/* compression algorithm */
 	int compress_type;
 
+	/* encryption key */
+	struct btrfs_enc_key *key;
+
+	/* encryption initialization vector */
+	char iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+
 	/* reference count */
 	refcount_t refs;
 
@@ -158,12 +164,14 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 				   u64 *file_offset, u64 io_size,
 				   int uptodate);
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
-			     u64 start, u64 len, u64 disk_len, int type);
+			     u64 start, u64 len, u64 disk_len, int type,
+			     struct btrfs_enc_key *key, char *iv);
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 				 u64 start, u64 len, u64 disk_len, int type);
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int compress_type);
+				      int type, int compress_type,
+				      struct btrfs_enc_key *key, char *iv);
 void btrfs_add_ordered_sum(struct inode *inode,
 			   struct btrfs_ordered_extent *entry,
 			   struct btrfs_ordered_sum *sum);
-- 
2.19.2

