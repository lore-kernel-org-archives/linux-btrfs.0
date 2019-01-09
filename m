Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A831C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FFEB20821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8XUiyxV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfAIB1g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:27:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43968 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729459AbfAIB1e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:34 -0500
Received: by mail-wr1-f67.google.com with SMTP id r10so5985152wrs.10;
        Tue, 08 Jan 2019 17:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SoMH8UBSra9lx/5ihZgzGJU0YQeMhBtzKVlspVFRgZo=;
        b=e8XUiyxVFj5ylVMSNA0bv/lqgDyYTwA1AARqQV4rNnP9du6S6m2C1siUpvuZsHrCgv
         14pScxjMUMfYoA9i7ia1qleiOauIvgDBotLtBYdldzlVGaIkZKSWpbUVMRp/8iUNE49C
         nsqSLLGWqUPldJc4KIAJLkpFNRa1sqolzFYLpt7vpj+0X63mSg07aJjStXbaaGw4XbN4
         2Dt+G+TtB2KPD5U5rIEHOelL3bui10fcs7M8Dat41dIKMtZG5qe9rug40b6DwHUnKaj/
         fya3IbwRqS+jB45Gbns4qaz0B5SpfRNNe/y/YbLzogUy9YAUZ9VfFlBKIplDCvo4pbV+
         pZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=SoMH8UBSra9lx/5ihZgzGJU0YQeMhBtzKVlspVFRgZo=;
        b=cBsivcMkjWLrXpKjTbPEzXeXRF1AWc+/AWo7BjygZE0wU3Mvs0kMbg6ozAoX9vFawx
         EYL5/P2ArsRIskrW70MkjU3OtY7Ttb90/Xw08U62RHsJSw4XZksIWzXdMQMa+XAT4YYm
         rFzs0YgZqMel0B28ySD2FBz8SagJUG14qH26zMeo9dPWg9biAaCCLu0PL+qM5rl/2Pe7
         iveAxB3d/xvj/bvCenAR8nZmuWbQhka5wiCxX3+gyLb13LEjLGN9TiV6TiqGDZXmFQ3k
         Xkrn+ECgPStLc6JqDV8kg6EOdNXsjWN6SqH9sPupigKLg7TDIZMXmUnK/KpEs0Ee7WMn
         1BPQ==
X-Gm-Message-State: AJcUukezfEslliFe7Nw1EARGimtY5/YpVUQjHWs+9wxP123sxXTPJ4I/
        Oke9XhTsUflCy5kabLpv0OY=
X-Google-Smtp-Source: ALg8bN635GO5/2SJyQh+Gnsnp22jbRfSI9Dtu7M6BeBRGNG+6iN1fE1L72xRCzAI4KO+Sw7kLlpjHQ==
X-Received: by 2002:adf:ee07:: with SMTP id y7mr3247338wrn.187.1546997251752;
        Tue, 08 Jan 2019 17:27:31 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:31 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 06/19] btrfs: add ioctl BTRFS_IOC_GET_KEY_SALT
Date:   Wed,  9 Jan 2019 01:26:48 +0000
Message-Id: <20190109012701.26441-6-mark@harmstone.com>
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
 fs/btrfs/Makefile          |   2 +-
 fs/btrfs/ctree.h           |   4 +
 fs/btrfs/disk-io.c         |   6 ++
 fs/btrfs/encryption.c      |  58 +++++++++++++
 fs/btrfs/encryption.h      |   3 +
 fs/btrfs/ioctl.c           | 170 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  10 +++
 7 files changed, 252 insertions(+), 1 deletion(-)
 create mode 100644 fs/btrfs/encryption.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index ca693dd554e9..805654060cea 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -10,7 +10,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o zstd.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
-	   uuid-tree.o props.o free-space-tree.o tree-checker.o
+	   uuid-tree.o props.o free-space-tree.o tree-checker.o encryption.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3f3356a2d145..4bab57e01e21 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2418,6 +2418,10 @@ BTRFS_SETGET_FUNCS(file_extent_other_encoding, struct btrfs_file_extent_item,
 
 #define BTRFS_ENCRYPTION_KEY_ID_LENGTH 64
 
+struct btrfs_encryption_key_item {
+	u8 key_id[BTRFS_ENCRYPTION_KEY_ID_LENGTH];
+} __attribute__ ((__packed__));
+
 /*
  * this returns the number of bytes used by the item on disk, minus the
  * size of any extent headers.  If a file is compressed on disk, this is
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a1964b768750..2ecce2ce51be 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2596,6 +2596,10 @@ int open_ctree(struct super_block *sb,
 	int clear_free_space_tree = 0;
 	int level;
 
+	err = crypto_get_default_rng();
+	if (err)
+		goto fail;
+
 	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
 	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
 	if (!tree_root || !chunk_root) {
@@ -4031,6 +4035,8 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 		list_del_init(&key->key_list);
 		kfree(key);
 	}
+
+	crypto_put_default_rng();
 }
 
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
diff --git a/fs/btrfs/encryption.c b/fs/btrfs/encryption.c
new file mode 100644
index 000000000000..0803642c1ec9
--- /dev/null
+++ b/fs/btrfs/encryption.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Mark Harmstone.  All rights reserved.
+ */
+
+#include <crypto/hash.h>
+#include "ctree.h"
+#include "encryption.h"
+
+int btrfs_get_key_id(u64 salt, char *password, unsigned int pwdlen,
+		     char *key_id)
+{
+	int ret;
+	struct crypto_shash *shash;
+	struct shash_desc *desc;
+
+	shash = crypto_alloc_shash("sha512", 0, 0);
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
+	ret = crypto_shash_update(desc, password, pwdlen);
+	if (ret)
+		goto free_desc;
+
+	ret = crypto_shash_final(desc, key_id);
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
diff --git a/fs/btrfs/encryption.h b/fs/btrfs/encryption.h
index 77914d7797c6..adf35696373f 100644
--- a/fs/btrfs/encryption.h
+++ b/fs/btrfs/encryption.h
@@ -30,4 +30,7 @@ struct btrfs_enc_key {
 	struct mutex lock;
 };
 
+int btrfs_get_key_id(u64 salt, char *password, unsigned int pwdlen,
+		     char *key_id);
+
 #endif
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 802a628e9f7d..92fbed90dc4e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -26,6 +26,7 @@
 #include <linux/btrfs.h>
 #include <linux/uaccess.h>
 #include <linux/iversion.h>
+#include <crypto/rng.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -43,6 +44,7 @@
 #include "qgroup.h"
 #include "tree-log.h"
 #include "compression.h"
+#include "encryption.h"
 
 #ifdef CONFIG_64BIT
 /* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
@@ -5852,6 +5854,172 @@ static int _btrfs_ioctl_send(struct file *file, void __user *argp, bool compat)
 	return ret;
 }
 
+static int btrfs_ioctl_get_key_salt(struct btrfs_fs_info *fs_info,
+				    void __user *argp)
+{
+	struct btrfs_ioctl_get_key_salt_args args;
+	int ret;
+	u64 salt;
+	struct btrfs_enc_key *k = NULL, *k2;
+	char key_id[BTRFS_ENCRYPTION_KEY_ID_LENGTH];
+
+	if (copy_from_user(&args, argp, sizeof(args)))
+		return -EFAULT;
+
+	down_write(&fs_info->key_sem);
+
+	/* Search loaded keys */
+	list_for_each_entry(k2, &fs_info->key_list, key_list) {
+		ret = btrfs_get_key_id(k2->key_number, args.password,
+				       strlen(args.password), key_id);
+		if (ret) {
+			up_write(&fs_info->key_sem);
+			return ret;
+		}
+
+		if (!memcmp(key_id, k2->key_id, sizeof(key_id))) {
+			k = k2;
+			break;
+		}
+	}
+
+	/* Not loaded - search tree */
+	if (!k && fs_info->key_root) {
+		struct btrfs_key key;
+		struct btrfs_path *path;
+
+		path = btrfs_alloc_path();
+		if (!path) {
+			up_write(&fs_info->key_sem);
+			return -ENOMEM;
+		}
+
+		key.objectid = 0;
+		key.type = BTRFS_ENCRYPTION_KEY;
+		key.offset = 0;
+
+		ret = btrfs_search_slot(NULL, fs_info->key_root, &key,
+					path, 0,  0);
+		if (ret < 0) {
+			up_write(&fs_info->key_sem);
+			btrfs_free_path(path);
+			return ret;
+		}
+
+		do {
+			struct extent_buffer *leaf;
+			int slot;
+			u32 item_size;
+			struct btrfs_encryption_key_item *item;
+			char key_id2[BTRFS_ENCRYPTION_KEY_ID_LENGTH];
+
+			leaf = path->nodes[0];
+			slot = path->slots[0];
+			btrfs_item_key_to_cpu(leaf, &key, slot);
+
+			if (key.type != BTRFS_ENCRYPTION_KEY)
+				goto skip;
+
+			item_size = btrfs_item_size_nr(leaf, slot);
+
+			if (item_size !=
+				sizeof(struct btrfs_encryption_key_item))
+				goto skip;
+
+			item = btrfs_item_ptr(leaf, path->slots[0],
+					      struct btrfs_encryption_key_item);
+
+			salt = key.objectid;
+
+			ret = btrfs_get_key_id(salt, args.password,
+					       strlen(args.password), key_id);
+			if (ret) {
+				up_write(&fs_info->key_sem);
+				btrfs_free_path(path);
+				return ret;
+			}
+
+			read_eb_member(leaf, item,
+				       struct btrfs_encryption_key_item,
+				       key_id, key_id2);
+
+			if (!memcmp(key_id, key_id2,
+				    BTRFS_ENCRYPTION_KEY_ID_LENGTH)) {
+				k = kmalloc(sizeof(*k), GFP_KERNEL);
+				if (!k) {
+					up_write(&fs_info->key_sem);
+					btrfs_free_path(path);
+					return -ENOMEM;
+				}
+
+				memcpy(k->key_id, key_id,
+				       BTRFS_ENCRYPTION_KEY_ID_LENGTH);
+				k->key_number = salt;
+				k->loaded = false;
+				k->added = false;
+				k->used = true;
+				mutex_init(&k->lock);
+
+				list_add(&k->key_list, &fs_info->key_list);
+				break;
+			}
+
+skip:
+			ret = btrfs_next_item(fs_info->key_root, path);
+			if (ret == 0)
+				continue;
+			else if (ret > 0)
+				ret = 0;
+			break;
+		} while (1);
+
+		btrfs_free_path(path);
+	}
+
+	/* Not found - allocate new key */
+	if (!k) {
+		ret = crypto_rng_get_bytes(crypto_default_rng, (u8 *)&salt,
+					   sizeof(salt));
+
+		if (ret) {
+			up_write(&fs_info->key_sem);
+			return ret;
+		}
+
+		k = kmalloc(sizeof(*k), GFP_KERNEL);
+		if (!k) {
+			up_write(&fs_info->key_sem);
+			return -ENOMEM;
+		}
+
+		k->key_number = salt;
+
+		ret = btrfs_get_key_id(k->key_number, args.password,
+				       strlen(args.password), k->key_id);
+		if (ret) {
+			up_write(&fs_info->key_sem);
+			kzfree(k);
+			return ret;
+		}
+
+		k->loaded = false;
+		k->added = true;
+		k->used = false;
+		mutex_init(&k->lock);
+
+		list_add(&k->key_list, &fs_info->key_list);
+	}
+
+	args.salt = k->key_number;
+
+	up_write(&fs_info->key_sem);
+
+	if (copy_to_user(argp, &args, sizeof(args)))
+		return -EFAULT;
+
+	return 0;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -5998,6 +6166,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_subvol_rootref(file, argp);
 	case BTRFS_IOC_INO_LOOKUP_USER:
 		return btrfs_ioctl_ino_lookup_user(file, argp);
+	case BTRFS_IOC_GET_KEY_SALT:
+		return btrfs_ioctl_get_key_salt(fs_info, argp);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 6c785d5cfb4b..aef9b695a05c 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -817,6 +817,14 @@ struct btrfs_ioctl_get_subvol_rootref_args {
 		__u8 align[7];
 };
 
+#define BTRFS_ENC_PASSWORD_MAX 255
+
+struct btrfs_ioctl_get_key_salt_args {
+	char password[BTRFS_ENC_PASSWORD_MAX]; /* in */
+
+	__u64 salt; /* out */
+};
+
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
 	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1,
@@ -941,5 +949,7 @@ enum btrfs_err_code {
 				struct btrfs_ioctl_get_subvol_rootref_args)
 #define BTRFS_IOC_INO_LOOKUP_USER _IOWR(BTRFS_IOCTL_MAGIC, 62, \
 				struct btrfs_ioctl_ino_lookup_user_args)
+#define BTRFS_IOC_GET_KEY_SALT _IOWR(BTRFS_IOCTL_MAGIC, 63, \
+				struct btrfs_ioctl_get_key_salt_args)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.19.2

