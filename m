Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B81C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F15720821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BmyKst1y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbfAIB2r (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:28:47 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54991 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729573AbfAIB1k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:40 -0500
Received: by mail-wm1-f65.google.com with SMTP id a62so5982187wmh.4;
        Tue, 08 Jan 2019 17:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BC3+WJwz5bC1eSK1d688gwyECtY9iawjGUtkLyo3zdQ=;
        b=BmyKst1y6bzTDjnjH/hYn8nHQxsV06NwXW4+rUpGNkSvH6Z/crrBwQHgwKWQFp7sFl
         ov9nubshL2eEJfoUe29e/ZiqB+uxLGvnczRxmvzaXTHuKSFuswl64hwKYWHX6E3r4i+n
         36ERS32lx7Wl76Awvx9NWzJyGFOB5qiuNnpSRt8GTq2iCofzzoQ0xLHO4WhxdiWeaq6k
         KaB6uWrqZRadWDNBZ4HVq5m77q/BnwFPGpcD/wOJne1JdVOqnOGzjyJgHe9s6FUTh9uC
         /KfgWf6he7Svq5oymN8GqV3VYtpNjngXYo3XeZALWQnqz1B0NjfyGQrAuwSSNvYHYUnK
         6Jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=BC3+WJwz5bC1eSK1d688gwyECtY9iawjGUtkLyo3zdQ=;
        b=NmZSMt3D/tLfn6hi+YVtzrup6go2rmMle1KPTEJK32Xi6c8NI5gRqV9d0Nq9IAh0RS
         YjFkXNq9y2fRlQhAKm6WnoSEbD6e9MbyHjOkhW8jTIaSEAWKah3VE/cnGFBbROccRqFe
         zVzs4G0f41Gs19YF8HgV+O8Qb9e6Dm2rb/NHpmPIAPgV7jZNqIevL7Y3FgXhZO6jymw1
         fp37CdzPTzv4vFkeghtzvtYOvXZspFwYeRDkGWhuzuhyas0EU592aswVJYnafl1cjxYM
         dbvRN4hGmozCfjmRhqlkD5+CSjmwasdf+IKQZPmYpmYYZBoNBbhw0vzfAyf41JJINBRN
         1L1A==
X-Gm-Message-State: AJcUukdzogn80lpwHtDhYkJMLdVR9vlktTtKU68ZwZjEUbOLpL1zf653
        lgBk9Y9sVw476yjnTkzsUPI=
X-Google-Smtp-Source: ALg8bN5Ov0LiUMvVCUU3vJOS7SwgecggYrqvloDKNN1Z3qiVaHMm+WvbJ4DMnQi9GLyb7GwHEObXkA==
X-Received: by 2002:a1c:35ca:: with SMTP id c193mr3400342wma.146.1546997257288;
        Tue, 08 Jan 2019 17:27:37 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:36 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 10/19] btrfs: allow reading encrypted inline extents
Date:   Wed,  9 Jan 2019 01:26:52 +0000
Message-Id: <20190109012701.26441-10-mark@harmstone.com>
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
 fs/btrfs/encryption.c | 305 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/encryption.h |   3 +
 fs/btrfs/inode.c      |  72 +++++++++-
 3 files changed, 379 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/encryption.c b/fs/btrfs/encryption.c
index 0803642c1ec9..a1c9a982b009 100644
--- a/fs/btrfs/encryption.c
+++ b/fs/btrfs/encryption.c
@@ -4,9 +4,314 @@
  */
 
 #include <crypto/hash.h>
+#include <keys/user-type.h>
 #include "ctree.h"
 #include "encryption.h"
 
+#define KEY_SIG_PREFIX "btrfs:"
+#define KEY_SIG_LENGTH (sizeof(KEY_SIG_PREFIX) - 1 + 16)
+
+#define AES256_KEY_LENGTH 32
+
+static int derive_aes_key(u64 salt, char *data, unsigned int datalen,
+			  char *aeskey)
+{
+	int ret;
+	struct crypto_shash *shash;
+	struct shash_desc *desc;
+	char tmp[AES256_KEY_LENGTH];
+
+	shash = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(shash))
+		return PTR_ERR(shash);
+
+	desc = kmalloc(sizeof(struct shash_desc) + crypto_shash_descsize(shash),
+		       GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto free_shash;
+	}
+
+	desc->tfm = shash;
+	desc->flags = 0;
+
+	/* Get SHA256 of salted password */
+
+	ret = crypto_shash_init(desc);
+	if (ret)
+		goto free_desc;
+
+	salt = cpu_to_le64(salt);
+
+	ret = crypto_shash_update(desc, (u8 *)&salt, sizeof(salt));
+	if (ret)
+		goto free_desc;
+
+	ret = crypto_shash_update(desc, data, datalen);
+	if (ret)
+		goto free_desc;
+
+	ret = crypto_shash_final(desc, tmp);
+	if (ret)
+		goto free_desc;
+
+	/* SHA256 again */
+
+	ret = crypto_shash_init(desc);
+	if (ret)
+		goto free_desc;
+
+	ret = crypto_shash_update(desc, tmp, AES256_KEY_LENGTH);
+	if (ret)
+		goto free_desc;
+
+	ret = crypto_shash_final(desc, aeskey);
+	if (ret)
+		goto free_desc;
+
+	ret = 0;
+
+free_desc:
+	kzfree(desc);
+
+free_shash:
+	crypto_free_shash(shash);
+
+	return ret;
+}
+
+static int btrfs_load_key(struct btrfs_enc_key *k)
+{
+	struct key *key;
+	u64 salt;
+	char sig[KEY_SIG_LENGTH + 1];
+	char key_id[BTRFS_ENCRYPTION_KEY_ID_LENGTH];
+	char aeskey[AES256_KEY_LENGTH];
+	struct user_key_payload *upayload;
+	int ret;
+
+	if (k->loaded)
+		return 0;
+
+	salt = cpu_to_be64(k->key_number);
+
+	memcpy(sig, KEY_SIG_PREFIX, sizeof(KEY_SIG_PREFIX) - 1);
+	bin2hex(sig + sizeof(KEY_SIG_PREFIX) - 1, &salt, sizeof(u64));
+	sig[KEY_SIG_LENGTH] = 0;
+
+	key = request_key(&key_type_user, sig, NULL);
+
+	if (IS_ERR(key)) {
+		key = request_key(&key_type_logon, sig, NULL);
+
+		if (IS_ERR(key))
+			return -ENOKEY;
+	}
+
+	down_read(&key->sem);
+
+	upayload = user_key_payload_locked(key);
+	if (IS_ERR_OR_NULL(upayload)) {
+		ret = upayload ? PTR_ERR(upayload) : -EINVAL;
+		goto out_key_put;
+	}
+
+	ret = btrfs_get_key_id(k->key_number, upayload->data,
+			       upayload->datalen, key_id);
+	if (ret)
+		goto out_key_put;
+
+	if (memcmp(key_id, k->key_id,
+		   BTRFS_ENCRYPTION_KEY_ID_LENGTH)) {
+		ret = -EINVAL;
+		goto out_key_put;
+	}
+
+	k->skcipher = crypto_alloc_skcipher("ctr(aes)", 0, 0);
+	if (IS_ERR(k->skcipher)) {
+		ret = PTR_ERR(k->skcipher);
+		goto out_key_put;
+	}
+
+	ret = derive_aes_key(k->key_number, upayload->data,
+			     upayload->datalen, aeskey);
+	if (ret) {
+		crypto_free_skcipher(k->skcipher);
+		goto out_key_put;
+	}
+
+	ret = crypto_skcipher_setkey(k->skcipher, aeskey, 32);
+	if (ret) {
+		crypto_free_skcipher(k->skcipher);
+		goto out_key_put;
+	}
+
+	k->loaded = true;
+
+	ret = 0;
+
+out_key_put:
+	up_read(&key->sem);
+
+	key_put(key);
+
+	return ret;
+}
+
+static int find_key(struct btrfs_fs_info *fs_info, u64 key_number,
+		    struct btrfs_enc_key **key)
+{
+	int ret;
+	struct btrfs_enc_key *k = NULL, *k2;
+
+	down_write(&fs_info->key_sem);
+
+	list_for_each_entry(k2, &fs_info->key_list, key_list) {
+		if (k2->key_number == key_number) {
+			k = k2;
+			break;
+		}
+	}
+
+	if (!k && fs_info->key_root) {
+		struct btrfs_key key;
+		struct btrfs_path *path;
+		struct extent_buffer *leaf;
+		int slot;
+		u32 item_size;
+		struct btrfs_encryption_key_item *item;
+		char key_id[BTRFS_ENCRYPTION_KEY_ID_LENGTH];
+
+		path = btrfs_alloc_path();
+		if (!path) {
+			up_write(&fs_info->key_sem);
+			return -ENOMEM;
+		}
+
+		key.objectid = key_number;
+		key.type = BTRFS_ENCRYPTION_KEY;
+		key.offset = 0;
+
+		ret = btrfs_search_slot(NULL, fs_info->key_root, &key,
+					path, 0,  0);
+		if (ret < 0) {
+			btrfs_free_path(path);
+			up_write(&fs_info->key_sem);
+			return ret;
+		}
+
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+
+		if (key.objectid != key_number ||
+			key.type != BTRFS_ENCRYPTION_KEY) {
+			btrfs_free_path(path);
+			up_write(&fs_info->key_sem);
+			return -ENOKEY;
+		}
+
+		item_size = btrfs_item_size_nr(leaf, slot);
+
+		if (item_size != sizeof(struct btrfs_encryption_key_item)) {
+			btrfs_free_path(path);
+			up_write(&fs_info->key_sem);
+			return -ENOKEY;
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
+			return -ENOMEM;
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
+	}
+
+	up_write(&fs_info->key_sem);
+
+	if (!k)
+		return -ENOKEY;
+
+	if (!k->loaded) {
+		mutex_lock(&k->lock);
+		ret = btrfs_load_key(k);
+		mutex_unlock(&k->lock);
+
+		if (ret)
+			return ret;
+	}
+
+	*key = k;
+
+	return 0;
+}
+
+int btrfs_decrypt(struct btrfs_fs_info *fs_info,
+		  unsigned char *data, size_t len)
+{
+	struct scatterlist sg;
+	struct skcipher_request *req = NULL;
+	int ret = -EFAULT;
+	u64 key_number;
+	struct btrfs_enc_key *key;
+	struct btrfs_file_extent_inline_enc *eienc;
+	char iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+
+	if (len <= sizeof(struct btrfs_file_extent_inline_enc))
+		return -EINVAL;
+
+	eienc = (struct btrfs_file_extent_inline_enc *)data;
+
+	key_number = le64_to_cpu(eienc->key_number);
+
+	ret = find_key(fs_info, key_number, &key);
+	if (ret)
+		return ret;
+
+	memcpy(iv, eienc->iv, BTRFS_ENCRYPTION_BLOCK_LENGTH);
+
+	len -= sizeof(struct btrfs_file_extent_inline_enc);
+
+	sg_init_one(&sg, data + sizeof(struct btrfs_file_extent_inline_enc),
+		    len);
+
+	req = skcipher_request_alloc(key->skcipher, GFP_KERNEL);
+	if (!req) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	skcipher_request_set_crypt(req, &sg, &sg, len, iv);
+
+	ret = crypto_skcipher_decrypt(req);
+	if (ret < 0)
+		goto out;
+
+out:
+	if (req)
+		skcipher_request_free(req);
+	return ret;
+}
+
+
 int btrfs_get_key_id(u64 salt, char *password, unsigned int pwdlen,
 		     char *key_id)
 {
diff --git a/fs/btrfs/encryption.h b/fs/btrfs/encryption.h
index adf35696373f..add7ee6d879d 100644
--- a/fs/btrfs/encryption.h
+++ b/fs/btrfs/encryption.h
@@ -30,6 +30,9 @@ struct btrfs_enc_key {
 	struct mutex lock;
 };
 
+int btrfs_decrypt(struct btrfs_fs_info *fs_info,
+		  unsigned char *data, size_t len);
+
 int btrfs_get_key_id(u64 salt, char *password, unsigned int pwdlen,
 		     char *key_id);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1d1084cf9289..202a7458584f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -45,6 +45,7 @@
 #include "props.h"
 #include "qgroup.h"
 #include "dedupe.h"
+#include "encryption.h"
 
 struct btrfs_iget_args {
 	struct btrfs_key *location;
@@ -6757,6 +6758,66 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	return ret;
 }
 
+static noinline int decrypt_inline(struct btrfs_fs_info *fs_info,
+				   struct btrfs_path *path,
+				   struct page *page,
+				   size_t pg_offset, u64 extent_offset,
+				   struct btrfs_file_extent_item *item,
+				   int compress_type)
+{
+	int ret;
+	struct extent_buffer *leaf = path->nodes[0];
+	char *tmp;
+	size_t max_size;
+	unsigned long inline_size;
+	unsigned long ptr;
+	int encryption_type;
+
+	WARN_ON(pg_offset != 0);
+	encryption_type = btrfs_file_extent_encryption(leaf, item);
+	max_size = btrfs_file_extent_ram_bytes(leaf, item);
+	inline_size = btrfs_file_extent_inline_item_len(leaf,
+						btrfs_item_nr(path->slots[0]));
+	tmp = kmalloc(inline_size, GFP_NOFS);
+	if (!tmp)
+		return -ENOMEM;
+	ptr = btrfs_file_extent_inline_start(item);
+
+	read_extent_buffer(leaf, tmp, ptr, inline_size);
+
+	max_size = min_t(unsigned long, PAGE_SIZE, max_size);
+	ret = btrfs_decrypt(fs_info, tmp, inline_size);
+
+	if (ret)
+		goto end;
+
+	inline_size -= sizeof(struct btrfs_file_extent_inline_enc);
+
+	if (compress_type != BTRFS_COMPRESS_NONE) {
+
+		ret = btrfs_decompress(compress_type,
+			tmp + sizeof(struct btrfs_file_extent_inline_enc),
+			page, extent_offset, inline_size, max_size);
+	} else {
+		char *kaddr = kmap_atomic(page);
+
+		memcpy(kaddr + pg_offset,
+		       tmp + sizeof(struct btrfs_file_extent_inline_enc) +
+				extent_offset,
+		       min(max_size, inline_size));
+
+		if (max_size + pg_offset < PAGE_SIZE)
+			memset(kaddr + pg_offset + max_size, 0,
+			       PAGE_SIZE - max_size - pg_offset);
+
+		kunmap_atomic(kaddr);
+	}
+
+end:
+	kfree(tmp);
+	return ret;
+}
+
 /*
  * a bit scary, this does extent mapping from logical file offset to the disk.
  * the ugly parts come from merging extents from the disk with the in-ram
@@ -6932,7 +6993,16 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 
 		btrfs_set_path_blocking(path);
 		if (!PageUptodate(page)) {
-			if (btrfs_file_extent_compression(leaf, item) !=
+			if (btrfs_file_extent_encryption(leaf, item) !=
+			    BTRFS_ENCRYPTION_NONE) {
+				ret = decrypt_inline(fs_info, path, page,
+				  pg_offset, extent_offset, item,
+				  btrfs_file_extent_compression(leaf, item));
+				if (ret) {
+					err = ret;
+					goto out;
+				}
+			} else if (btrfs_file_extent_compression(leaf, item) !=
 			    BTRFS_COMPRESS_NONE) {
 				ret = uncompress_inline(path, page, pg_offset,
 							extent_offset, item);
-- 
2.19.2

