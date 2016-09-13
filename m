Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33632 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757642AbcIMNip (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 09:38:45 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH] btrfs: Encryption: Add btrfs encryption support
Date: Tue, 13 Sep 2016 21:39:47 +0800
Message-Id: <1473773990-3071-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds encryption support. Based on v4.7-rc3.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/Makefile               |   4 +-
 fs/btrfs/btrfs_inode.h          |   6 +
 fs/btrfs/compression.c          |  30 +-
 fs/btrfs/compression.h          |  10 +-
 fs/btrfs/ctree.h                |   4 +
 fs/btrfs/disk-io.c              |   3 +
 fs/btrfs/encrypt.c              | 807 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/encrypt.h              |  94 +++++
 fs/btrfs/inode.c                | 255 ++++++++++++-
 fs/btrfs/ioctl.c                |  67 ++++
 fs/btrfs/lzo.c                  |   2 +-
 fs/btrfs/props.c                | 331 +++++++++++++++-
 fs/btrfs/super.c                |  27 +-
 fs/btrfs/tests/crypto-tests.c   | 376 +++++++++++++++++++
 fs/btrfs/tests/crypto-tests.h   |  38 ++
 fs/btrfs/zlib.c                 |   2 +-
 include/uapi/linux/btrfs_tree.h |   6 +-
 17 files changed, 2027 insertions(+), 35 deletions(-)
 create mode 100644 fs/btrfs/encrypt.c
 create mode 100644 fs/btrfs/encrypt.h
 create mode 100755 fs/btrfs/tests/crypto-tests.c
 create mode 100755 fs/btrfs/tests/crypto-tests.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 128ce17a80b0..c185b2f18953 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -9,7 +9,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
-	   uuid-tree.o props.o hash.o free-space-tree.o
+	   uuid-tree.o props.o hash.o free-space-tree.o encrypt.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
@@ -17,4 +17,4 @@ btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
 btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
 	tests/extent-buffer-tests.o tests/btrfs-tests.o \
 	tests/extent-io-tests.o tests/inode-tests.o tests/qgroup-tests.o \
-	tests/free-space-tree-tests.o
+	tests/free-space-tree-tests.o tests/crypto-tests.o
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 4919aedb5fc1..8d2ce6c0e384 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -24,6 +24,7 @@
 #include "extent_io.h"
 #include "ordered-data.h"
 #include "delayed-inode.h"
+#include "encrypt.h"
 
 /*
  * ordered_data_close is set by truncate when a file that used
@@ -207,6 +208,11 @@ struct btrfs_inode {
 	struct rw_semaphore dio_sem;
 
 	struct inode vfs_inode;
+
+	unsigned char key_payload[BTRFS_CRYPTO_KEY_SIZE];
+	u32 key_len;
+	unsigned char cryptoiv[BTRFS_CRYPTO_IV_SIZE];
+	u32 iv_len;
 };
 
 extern unsigned char btrfs_filetype_table[];
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 658c39b70fba..fc65f8831a1d 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -41,6 +41,7 @@
 #include "compression.h"
 #include "extent_io.h"
 #include "extent_map.h"
+#include "encrypt.h"
 
 struct compressed_bio {
 	/* number of bios pending for this compressed extent */
@@ -83,7 +84,7 @@ struct compressed_bio {
 
 static int btrfs_decompress_biovec(int type, struct page **pages_in,
 				   u64 disk_start, struct bio_vec *bvec,
-				   int vcnt, size_t srclen);
+				   int vcnt, size_t srclen, struct bio *bio);
 
 static inline int compressed_bio_size(struct btrfs_root *root,
 				      unsigned long disk_size)
@@ -180,9 +181,9 @@ static void end_compressed_bio_read(struct bio *bio)
 				      cb->start,
 				      cb->orig_bio->bi_io_vec,
 				      cb->orig_bio->bi_vcnt,
-				      cb->compressed_len);
+				      cb->compressed_len, cb->orig_bio);
 csum_failed:
-	if (ret)
+	if (ret && ret != -ENOKEY)
 		cb->errors = 1;
 
 	/* release the compressed pages */
@@ -754,15 +755,21 @@ static struct {
 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
+	&btrfs_encrypt_ops,
 };
 
 void __init btrfs_init_compress(void)
 {
 	int i;
+	int type;
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
 		struct list_head *workspace;
 
+		type = i + 1;
+		if (type == BTRFS_ENCRYPT_AES)
+			continue;
+
 		INIT_LIST_HEAD(&btrfs_comp_ws[i].idle_ws);
 		spin_lock_init(&btrfs_comp_ws[i].ws_lock);
 		atomic_set(&btrfs_comp_ws[i].total_ws, 0);
@@ -801,6 +808,10 @@ static struct list_head *find_workspace(int type)
 	atomic_t *total_ws		= &btrfs_comp_ws[idx].total_ws;
 	wait_queue_head_t *ws_wait	= &btrfs_comp_ws[idx].ws_wait;
 	int *free_ws			= &btrfs_comp_ws[idx].free_ws;
+
+	if (type == BTRFS_ENCRYPT_AES)
+		return NULL;
+
 again:
 	spin_lock(ws_lock);
 	if (!list_empty(idle_ws)) {
@@ -867,6 +878,9 @@ static void free_workspace(int type, struct list_head *workspace)
 	wait_queue_head_t *ws_wait	= &btrfs_comp_ws[idx].ws_wait;
 	int *free_ws			= &btrfs_comp_ws[idx].free_ws;
 
+	if (!workspace)
+		return;
+
 	spin_lock(ws_lock);
 	if (*free_ws < num_online_cpus()) {
 		list_add(workspace, idle_ws);
@@ -894,8 +908,12 @@ static void free_workspaces(void)
 {
 	struct list_head *workspace;
 	int i;
+	int type;
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
+		type = i + 1;
+		if (type == BTRFS_ENCRYPT_AES)
+			continue;
 		while (!list_empty(&btrfs_comp_ws[i].idle_ws)) {
 			workspace = btrfs_comp_ws[i].idle_ws.next;
 			list_del(workspace);
@@ -931,7 +949,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 			 unsigned long *out_pages,
 			 unsigned long *total_in,
 			 unsigned long *total_out,
-			 unsigned long max_out)
+			 unsigned long max_out, int flags)
 {
 	struct list_head *workspace;
 	int ret;
@@ -942,7 +960,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 						      start, len, pages,
 						      nr_dest_pages, out_pages,
 						      total_in, total_out,
-						      max_out);
+						      max_out, flags);
 	free_workspace(type, workspace);
 	return ret;
 }
@@ -965,7 +983,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
  */
 static int btrfs_decompress_biovec(int type, struct page **pages_in,
 				   u64 disk_start, struct bio_vec *bvec,
-				   int vcnt, size_t srclen)
+				   int vcnt, size_t srclen, struct bio *bio)
 {
 	struct list_head *workspace;
 	int ret;
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index f49d8b8c0f00..b90820f3898c 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -29,7 +29,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 			 unsigned long *out_pages,
 			 unsigned long *total_in,
 			 unsigned long *total_out,
-			 unsigned long max_out);
+			 unsigned long max_out, int flags);
 int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 		     unsigned long start_byte, size_t srclen, size_t destlen);
 int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
@@ -53,8 +53,9 @@ enum btrfs_compression_type {
 	BTRFS_COMPRESS_NONE  = 0,
 	BTRFS_COMPRESS_ZLIB  = 1,
 	BTRFS_COMPRESS_LZO   = 2,
-	BTRFS_COMPRESS_TYPES = 2,
-	BTRFS_COMPRESS_LAST  = 3,
+	BTRFS_ENCRYPT_AES    = 3,
+	BTRFS_COMPRESS_TYPES = 3,
+	BTRFS_COMPRESS_LAST  = 4,
 };
 
 struct btrfs_compress_op {
@@ -70,7 +71,7 @@ struct btrfs_compress_op {
 			      unsigned long *out_pages,
 			      unsigned long *total_in,
 			      unsigned long *total_out,
-			      unsigned long max_out);
+			      unsigned long max_out, int flags);
 
 	int (*decompress_biovec)(struct list_head *workspace,
 				 struct page **pages_in,
@@ -88,5 +89,6 @@ struct btrfs_compress_op {
 
 extern const struct btrfs_compress_op btrfs_zlib_compress;
 extern const struct btrfs_compress_op btrfs_lzo_compress;
+extern const struct btrfs_compress_op btrfs_encrypt_ops;
 
 #endif
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 101c3cfd3f7c..aa3b3a4da923 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -40,6 +40,7 @@
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
+#include "encrypt.h"
 
 struct btrfs_trans_handle;
 struct btrfs_transaction;
@@ -1255,6 +1256,8 @@ struct btrfs_root {
 
 	/* For qgroup metadata space reserve */
 	atomic_t qgroup_meta_rsv;
+
+	char crypto_keytag[BTRFS_CRYPTO_KEYTAG_SIZE];
 };
 
 /*
@@ -1384,6 +1387,7 @@ do {                                                                   \
 #define BTRFS_INODE_NOATIME		(1 << 9)
 #define BTRFS_INODE_DIRSYNC		(1 << 10)
 #define BTRFS_INODE_COMPRESS		(1 << 11)
+#define BTRFS_INODE_ENCRYPT		(1 << 12)
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1142127f6e5e..8517e7c5968f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -50,6 +50,7 @@
 #include "sysfs.h"
 #include "qgroup.h"
 #include "compression.h"
+#include "encrypt.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -1302,6 +1303,8 @@ static void __setup_root(u32 nodesize, u32 sectorsize, u32 stripesize,
 	root->anon_dev = 0;
 
 	spin_lock_init(&root->root_item_lock);
+
+	memset(root->crypto_keytag, 0, BTRFS_CRYPTO_KEYTAG_SIZE);
 }
 
 static struct btrfs_root *btrfs_alloc_root(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/encrypt.c b/fs/btrfs/encrypt.c
new file mode 100644
index 000000000000..ff22295a617c
--- /dev/null
+++ b/fs/btrfs/encrypt.c
@@ -0,0 +1,807 @@
+/*
+ * Copyright (C) 2016 Oracle.  All rights reserved.
+ * Author: Anand Jain (anand.jain@oracle.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+#include <linux/string.h>
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+#include <linux/pagemap.h>
+#include <keys/user-type.h>
+#include "compression.h"
+#include <linux/slab.h>
+#include <linux/keyctl.h>
+#include <linux/key-type.h>
+#include <linux/cred.h>
+#include <keys/user-type.h>
+#include "ctree.h"
+#include "btrfs_inode.h"
+#include "props.h"
+#include "hash.h"
+#include "encrypt.h"
+#include "xattr.h"
+
+static const struct btrfs_encrypt_algorithm {
+	const char *name;
+	size_t keylen;
+	size_t ivlen;
+	int type_index;
+} btrfs_encrypt_algorithm_supported[] = {
+	{"ctr(aes)", 16, 16, BTRFS_ENCRYPT_AES}
+};
+
+int get_encrypt_type_index(char *type_name)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(btrfs_encrypt_algorithm_supported); i++)
+		if (!strcmp(btrfs_encrypt_algorithm_supported[i].name, type_name))
+			return btrfs_encrypt_algorithm_supported[i].type_index;
+
+	return -EINVAL;
+}
+
+/*
+ * Returns cipher alg key size if the encryption type is found
+ * otherwise 0
+ */
+size_t get_encrypt_type_len(char *type)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(btrfs_encrypt_algorithm_supported); i++)
+		if (!strcmp(btrfs_encrypt_algorithm_supported[i].name, type))
+			return btrfs_encrypt_algorithm_supported[i].keylen;
+
+	return 0;
+}
+
+void btrfs_disable_encrypt_inode(struct inode *inode)
+{
+	if (BTRFS_I(inode)->force_compress == BTRFS_ENCRYPT_AES)
+		BTRFS_I(inode)->force_compress = 0;
+}
+
+/*
+ * Helper to get the key.
+ * The key can be in
+ *                system keyring or
+ *                in a file in the external USB drive
+ * As of now only keyring type is supported.
+ */
+int btrfs_request_key(char *key_tag, void *key_data)
+{
+	int ret;
+	const struct user_key_payload *payload;
+	struct key *btrfs_key = NULL;
+
+	ret = 0;
+
+	btrfs_key = request_key(BTRFS_CRYPTO_KEY_TYPE, key_tag, NULL);
+	if (IS_ERR(btrfs_key)) {
+		ret = PTR_ERR(btrfs_key);
+		btrfs_key = NULL;
+		return ret;
+	}
+
+	ret = key_validate(btrfs_key);
+	if (ret < 0) {
+		key_put(btrfs_key);
+		return ret;
+	}
+
+	down_read(&btrfs_key->sem);
+	payload = user_key_payload(btrfs_key);
+	if (IS_ERR_OR_NULL(payload)) {
+		pr_err("get payload failed\n");
+		ret = PTR_ERR(payload);
+		goto out;
+	}
+
+	if (payload->datalen != BTRFS_CRYPTO_KEY_SIZE) {
+		pr_err("payload datalen does not match the expected\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	memcpy(key_data, payload->data, BTRFS_CRYPTO_KEY_SIZE);
+
+out:
+	up_read(&btrfs_key->sem);
+	key_put(btrfs_key);
+
+	return ret;
+}
+
+#if !(BTRFS_CRYPTO_TEST_BYDUMMYENC | BTRFS_CRYPTO_TEST_BYDUMMYKEY)
+static int btrfs_get_cipher_name_from_inode(struct inode *inode,
+					unsigned char *cipher_name)
+{
+	struct btrfs_root *root;
+
+	root = BTRFS_I(inode)->root;
+	memcpy(cipher_name, root->root_item.encrypt_algo,
+				BTRFS_CRYPTO_TFM_NAME_SIZE);
+	cipher_name[BTRFS_CRYPTO_TFM_NAME_SIZE] = '\0';
+	if (strlen(cipher_name))
+		return 0;
+
+	if (root->fs_info->compress_type == BTRFS_ENCRYPT_AES) {
+		memset(cipher_name, 0, BTRFS_CRYPTO_TFM_NAME_SIZE);
+		memcpy(cipher_name, "ctr(aes)",
+				BTRFS_CRYPTO_TFM_NAME_SIZE);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+#endif
+
+int btrfs_check_keytag(char *keytag)
+{
+	unsigned char keydata[BTRFS_CRYPTO_KEY_SIZE];
+	return btrfs_request_key(keytag, keydata);
+}
+
+int btrfs_validate_keytag(struct inode *inode, unsigned char *keytag)
+{
+	int ret;
+	u32 seed = 0;
+	u32 keyhash = ~(u32)0;
+	struct btrfs_root_item *ri;
+	unsigned char keydata[BTRFS_CRYPTO_KEY_SIZE];
+
+	ri = &(BTRFS_I(inode)->root->root_item);
+	if (!ri->crypto_keyhash)
+		return -ENOTSUPP;
+
+	ret = btrfs_request_key(keytag, keydata);
+	if (ret)
+		return ret;
+
+	keyhash = btrfs_crc32c(seed, keydata, BTRFS_CRYPTO_KEY_SIZE);
+	if (keyhash != ri->crypto_keyhash) {
+		/* wrong key */
+		pr_err("BTRFS: %pU wrong key: hash %u expected %u\n",
+				ri->uuid, keyhash, ri->crypto_keyhash);
+		return -EKEYREJECTED;
+	}
+
+	return 0;
+}
+
+int btrfs_set_keyhash(struct inode *inode, char *keytag)
+{
+	int ret;
+	u32 seed = 0;
+	u32 keyhash = ~(u32)0;
+	struct btrfs_root *root;
+	unsigned char keydata[BTRFS_CRYPTO_KEY_SIZE+1];
+
+	ret = btrfs_request_key(keytag, keydata);
+	if (ret)
+		return ret;
+
+	keyhash = btrfs_crc32c(seed, keydata, BTRFS_CRYPTO_KEY_SIZE);
+	root = BTRFS_I(inode)->root;
+	root->root_item.crypto_keyhash = keyhash;
+	return 0;
+}
+
+int btrfs_check_key_access(struct inode *inode)
+{
+	int ret;
+	u32 seed = 0;
+	u32 keyhash = ~(u32)0;
+	struct btrfs_root_item *ri;
+	char keytag[BTRFS_CRYPTO_KEYTAG_SIZE + 1];
+	unsigned char keydata[BTRFS_CRYPTO_KEY_SIZE + 1];
+
+	ri = &(BTRFS_I(inode)->root->root_item);
+	if (!ri->crypto_keyhash)
+		return -ENOKEY;
+
+	strncpy(keytag, BTRFS_I(inode)->root->crypto_keytag,
+					BTRFS_CRYPTO_KEYTAG_SIZE);
+	keytag[BTRFS_CRYPTO_KEYTAG_SIZE] = '\0';
+	ret = btrfs_request_key(keytag, keydata);
+	if (ret)
+		return ret;
+
+	keyhash = btrfs_crc32c(seed, keydata, BTRFS_CRYPTO_KEY_SIZE);
+	/*
+	 * what if there is different key with the same keytag
+	 * check with the hash helps to eliminate this case.
+	 */
+	if (ri->crypto_keyhash != keyhash)
+		return -EKEYREJECTED;
+
+	return 0;
+}
+
+int btrfs_get_master_key(struct inode *inode,
+					unsigned char *key)
+{
+	int ret;
+	char keytag[BTRFS_CRYPTO_KEYTAG_SIZE + 1];
+	struct btrfs_root_item *ri;
+	u32 keyhash = ~(u32)0;
+	u32 seed = 0;
+	unsigned char keydata[BTRFS_CRYPTO_KEY_SIZE + 1];
+
+	ri = &(BTRFS_I(inode)->root->root_item);
+	if (strlen(BTRFS_I(inode)->root->crypto_keytag)) {
+		strncpy(keytag, BTRFS_I(inode)->root->crypto_keytag,
+					BTRFS_CRYPTO_KEYTAG_SIZE);
+	} else {
+		pr_err("BTRFS: %lu btrfs_get_master_key no keytag\n",
+						inode->i_ino);
+		return -EINVAL;
+	}
+	keytag[BTRFS_CRYPTO_KEYTAG_SIZE] = '\0';
+
+	ret = btrfs_request_key(keytag, keydata);
+	if (ret)
+		return ret;
+
+	keyhash = btrfs_crc32c(seed, keydata, BTRFS_CRYPTO_KEY_SIZE);
+
+	/*
+	 * what if there is different key with the same keytag
+	 * checking with the hash helps to eliminate this case.
+	 */
+	if (ri->crypto_keyhash && ri->crypto_keyhash != keyhash) {
+		/* wrong key */
+		pr_err("BTRFS: %pU wrong key: hash %u expected %u\n",
+				ri->uuid, keyhash, ri->crypto_keyhash);
+		return -EKEYREJECTED;
+	}
+
+	memcpy(key, keydata, BTRFS_CRYPTO_KEY_SIZE);
+
+	return 0;
+}
+
+#if !(BTRFS_CRYPTO_TEST_BYDUMMYENC | BTRFS_CRYPTO_TEST_BYDUMMYKEY)
+static int btrfs_get_iv_from_inode(struct inode *inode,
+				unsigned char *iv, size_t *iv_size)
+{
+	if (!BTRFS_I(inode)->iv_len)
+		return -EINVAL;
+
+	memcpy(iv, BTRFS_I(inode)->cryptoiv, BTRFS_I(inode)->iv_len);
+
+	*iv_size = BTRFS_I(inode)->iv_len;
+
+	return 0;
+}
+#endif
+
+int btrfs_update_key_to_binode(struct inode *inode)
+{
+	int ret;
+	unsigned char keydata[BTRFS_CRYPTO_KEY_SIZE];
+
+	ret = btrfs_get_master_key(inode, keydata);
+	if (ret)
+		return ret;
+
+	memcpy(BTRFS_I(inode)->key_payload, keydata,
+					BTRFS_CRYPTO_KEY_SIZE);
+
+	BTRFS_I(inode)->key_len = BTRFS_CRYPTO_KEY_SIZE;
+	return ret;
+}
+
+int btrfs_blkcipher(int encrypt, struct btrfs_blkcipher_req *btrfs_req,
+						char *data, size_t len)
+{
+	int ret = -EFAULT;
+	struct scatterlist sg;
+	unsigned int ivsize = 0;
+	unsigned int blksize = 0;
+	char *cipher = "cbc(aes)";
+	struct blkcipher_desc desc;
+	struct crypto_blkcipher *blkcipher = NULL;
+
+	blkcipher = crypto_alloc_blkcipher(cipher, 0, 0);
+	if (IS_ERR(blkcipher)) {
+		pr_err("BTRFS: crypto, allocate blkcipher handle for %s\n", cipher);
+		return -PTR_ERR(blkcipher);
+	}
+
+	blksize = crypto_blkcipher_blocksize(blkcipher);
+	if (len < blksize) {
+		pr_err("BTRFS: crypto, blk can't work with len %lu\n", len);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (crypto_blkcipher_setkey(blkcipher, btrfs_req->key,
+					btrfs_req->key_len)) {
+		pr_err("BTRFS: crypto, key could not be set\n");
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	ivsize = crypto_blkcipher_ivsize(blkcipher);
+	if (ivsize != btrfs_req->iv_len) {
+		pr_err("BTRFS: crypto, length differs from expected length\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	crypto_blkcipher_set_iv(blkcipher, btrfs_req->cryptoiv,
+					btrfs_req->iv_len);
+
+	desc.flags = 0;
+	desc.tfm = blkcipher;
+	sg_init_one(&sg, data, len);
+
+	if (encrypt) {
+		/* encrypt data in place */
+		ret = crypto_blkcipher_encrypt(&desc, &sg, &sg, len);
+	} else {
+		/* decrypt data in place */
+		ret = crypto_blkcipher_decrypt(&desc, &sg, &sg, len);
+	}
+
+out:
+	crypto_free_blkcipher(blkcipher);
+	return ret;
+}
+
+int btrfs_cipher_iv(int encrypt, struct inode *inode,
+					char *data, size_t len)
+{
+	int ret;
+	struct btrfs_blkcipher_req btrfs_req;
+	unsigned char key[BTRFS_CRYPTO_KEY_SIZE];
+	unsigned char *iv = BTRFS_CRYPTO_IV_IV;
+
+	ret = btrfs_get_master_key(inode, key);
+	if (ret) {
+		pr_err("BTRFS: crypto, %lu btrfs_get_master_key failed to '%s' iv\n",
+				inode->i_ino, encrypt?"encrypt":"decrypt");
+		return ret;
+	}
+
+	memcpy(btrfs_req.key, key, BTRFS_CRYPTO_KEY_SIZE);
+	btrfs_req.key_len = BTRFS_CRYPTO_KEY_SIZE;
+	memcpy(btrfs_req.cryptoiv, iv, BTRFS_CRYPTO_IV_SIZE);
+	btrfs_req.iv_len = BTRFS_CRYPTO_IV_SIZE;
+
+	ret = btrfs_blkcipher(encrypt, &btrfs_req, data, len);
+
+	return ret;
+}
+
+static void btrfs_ablkcipher_cb(struct crypto_async_request *req, int error)
+{
+	struct btrfs_ablkcipher_result *cb_result = req->data;
+
+	if (error == -EINPROGRESS)
+		return;
+
+	cb_result->err = error;
+
+	complete(&cb_result->completion);
+}
+
+int btrfs_do_ablkcipher(int enc, struct page *page, unsigned long len,
+				struct btrfs_ablkcipher_req_data *btrfs_req)
+{
+	int ret = 0;
+	char *ivdata = NULL;
+	unsigned int ivsize = 0;
+	unsigned int ivdata_size;
+	unsigned int ablksize = 0;
+	struct ablkcipher_request *req = NULL;
+	struct crypto_ablkcipher *ablkcipher = NULL;
+	int key_len = btrfs_req->key_len;
+
+	ablkcipher = crypto_alloc_ablkcipher(btrfs_req->cipher_name, 0, 0);
+	if (IS_ERR(ablkcipher)) {
+		ret = PTR_ERR(ablkcipher);
+		pr_err("BTRFS: crypto, allocate cipher engine '%s' failed: %d\n",
+					btrfs_req->cipher_name, ret);
+		return ret;
+	}
+
+	ablksize = crypto_ablkcipher_blocksize(ablkcipher);
+	/* we can't cipher a block less the ciper block size */
+	if (len < ablksize) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (ablksize > BTRFS_CRYPTO_KEY_SIZE)
+		BUG_ON("Incompatible key for the cipher\n");
+
+	ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	ivdata = btrfs_req->iv;
+	ivdata_size = btrfs_req->iv_size;
+
+	if (ivsize != ivdata_size) {
+		BUG_ON("IV length differs from expected length\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	req = ablkcipher_request_alloc(ablkcipher, GFP_KERNEL);
+	if (IS_ERR(req)) {
+		pr_info("BTRFS: crypto, could not allocate request queue\n");
+		ret = PTR_ERR(req);
+		goto out;
+	}
+	btrfs_req->tfm = ablkcipher;
+	btrfs_req->req = req;
+
+	ablkcipher_request_set_tfm(req, ablkcipher);
+	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				btrfs_ablkcipher_cb, &btrfs_req->cb_result);
+
+	ret = crypto_ablkcipher_setkey(ablkcipher, btrfs_req->key, key_len);
+	if (ret) {
+		pr_err("BTRFS: crypto, cipher '%s' set key failed: len %u %d\n",
+				btrfs_req->cipher_name, key_len, ret);
+		goto out;
+	}
+
+	sg_init_table(&btrfs_req->sg_src, 1);
+	sg_set_page(&btrfs_req->sg_src, page, len, 0);
+	ablkcipher_request_set_crypt(req, &btrfs_req->sg_src,
+				&btrfs_req->sg_src, len, ivdata);
+
+	init_completion(&btrfs_req->cb_result.completion);
+
+	if (enc)
+		ret = crypto_ablkcipher_encrypt(btrfs_req->req);
+	else
+		ret = crypto_ablkcipher_decrypt(btrfs_req->req);
+
+	switch (ret) {
+	case 0:
+		break;
+	case -EINPROGRESS:
+	case -EBUSY:
+		ret = wait_for_completion_interruptible(
+					&btrfs_req->cb_result.completion);
+		if (!ret && !btrfs_req->cb_result.err) {
+			reinit_completion(&btrfs_req->cb_result.completion);
+			break;
+		}
+	default:
+		pr_info("crypto engine: %d result %d\n",
+					ret, btrfs_req->cb_result.err);
+		break;
+	}
+	init_completion(&btrfs_req->cb_result.completion);
+
+out:
+	if (ablkcipher)
+		crypto_free_ablkcipher(ablkcipher);
+	if (req)
+		ablkcipher_request_free(req);
+
+	return ret;
+}
+
+static int btrfs_do_ablkcipher_by_inode(int enc, struct page *page,
+				unsigned long len, struct inode *inode)
+{
+	int ret;
+	struct btrfs_ablkcipher_req_data btrfs_req;
+
+	if (!inode) {
+		BUG_ON("BTRFS: crypto, needs inode\n");
+		return -EINVAL;
+	}
+	memset(&btrfs_req, 0, sizeof(struct btrfs_ablkcipher_req_data));
+
+#if BTRFS_CRYPTO_TEST_BYDUMMYENC
+	if (len < PAGE_SIZE) {
+		char *in;
+		in = kmap(page);
+		/*
+		 * not scratched with zero, so to have
+		 * higher chance of catching bugs
+		 */
+		memset(in+len, 'z', PAGE_SIZE - len);
+		kunmap(page);
+	}
+	ret = 0;
+#elif BTRFS_CRYPTO_TEST_BYDUMMYKEY
+	/*
+	 * This is for testing only, especially the extents ops,
+	 * we don't worry about security here
+	 */
+	strncpy(btrfs_req.cipher_name, "ctr(aes)", BTRFS_CRYPTO_TFM_NAME_SIZE);
+	strncpy(btrfs_req.key, BTRFS_CRYPTO_IV_IV, BTRFS_CRYPTO_KEY_SIZE);
+	strncpy(btrfs_req.iv, BTRFS_CRYPTO_IV_IV, BTRFS_CRYPTO_IV_SIZE);
+	btrfs_req.key_len = BTRFS_CRYPTO_KEY_SIZE;
+	btrfs_req.iv_size = BTRFS_CRYPTO_IV_SIZE;
+	ret = btrfs_do_ablkcipher(enc, page, len, &btrfs_req);
+#else
+
+	/* Get the cipher engine name */
+	ret = btrfs_get_cipher_name_from_inode(inode, btrfs_req.cipher_name);
+	if (ret) {
+		pr_err("BTRFS: Error: Invalid cipher name: '%d'\n", ret);
+		return -EINVAL;
+	}
+
+	/* Get the Key */
+	if (BTRFS_I(inode)->key_len)
+		memcpy(btrfs_req.key, BTRFS_I(inode)->key_payload,
+						BTRFS_CRYPTO_KEY_SIZE);
+	else
+		ret = btrfs_get_master_key(inode, btrfs_req.key);
+
+	btrfs_req.key_len = BTRFS_CRYPTO_KEY_SIZE;
+
+	if (ret) {
+		/* Error getting key */
+		if (enc) {
+			/* For encrypt its an error*/
+			pr_err("BTRFS: crypto, '%lu' Get key failed: %d\n",
+						inode->i_ino, ret);
+		} else {
+			/*
+			 * For decrypt, the user with no key, may access
+			 * ciphertext
+			 */
+			if (ret == -ENOKEY || ret == -EKEYREVOKED)
+				ret = 0;
+			else
+				pr_err("BTRFS: crypto, '%lu' Get key failed: %d\n",
+						inode->i_ino, ret);
+		}
+		return ret;
+	}
+
+	ret = btrfs_get_iv_from_inode(inode, btrfs_req.iv,
+					&btrfs_req.iv_size);
+	if (ret) {
+		pr_err("BTRFS: crypto, can't get cryptoiv\n");
+		return ret;
+	}
+
+	ret = btrfs_do_ablkcipher(enc, page, len, &btrfs_req);
+#endif
+
+	return ret;
+}
+
+
+static int btrfs_encrypt_pages(struct list_head *na_ws,
+			struct address_space *mapping, u64 start,
+			unsigned long len, struct page **pages,
+			unsigned long nr_pages, unsigned long *nr_out_pages,
+			unsigned long *total_in, unsigned long *total_out,
+			unsigned long na_max_out, int dont_align)
+{
+	int ret;
+	struct page *in_page;
+	struct page *out_page = NULL;
+	char *in;
+	char *out;
+	unsigned long bytes_left = len;
+	unsigned long cur_page_len = 0;
+	unsigned long cur_page_len_for_out = 0;
+	unsigned long i;
+	struct inode *inode;
+	u64 blocksize;
+
+	*total_in = 0;
+	*nr_out_pages = 0;
+	*total_out = 0;
+	if (!len)
+		return 0;
+
+	if (!mapping && !mapping->host) {
+		WARN_ON("BTRFS: crypto, need mapped pages\n");
+		return -EINVAL;
+	}
+
+	inode = mapping->host;
+	blocksize = BTRFS_I(inode)->root->sectorsize;
+	if (blocksize != PAGE_SIZE)
+		pr_err("BTRFS: crypto, fatal, blocksize not same as page size\n");
+
+	for (i = 0; i < nr_pages; i++) {
+
+		in_page = find_get_page(mapping, start >> PAGE_SHIFT);
+		cur_page_len = min(bytes_left, PAGE_SIZE);
+		out_page = alloc_page(GFP_NOFS| __GFP_HIGHMEM);
+
+		in = kmap(in_page);
+		out = kmap(out_page);
+		memset(out, 0, PAGE_SIZE);
+		memcpy(out, in, cur_page_len);
+		kunmap(out_page);
+		kunmap(in_page);
+		if (dont_align)
+			cur_page_len_for_out = cur_page_len;
+		else
+			cur_page_len_for_out = ALIGN(cur_page_len, blocksize);
+
+		ret = btrfs_do_ablkcipher_by_inode(1, out_page,
+						cur_page_len_for_out, inode);
+		if (ret) {
+			__free_page(out_page);
+			return ret;
+		}
+		put_page(in_page);
+
+		pages[i] = out_page;
+		*nr_out_pages = *nr_out_pages + 1;
+		*total_in += cur_page_len;
+		*total_out += cur_page_len_for_out;
+
+		start += cur_page_len;
+		bytes_left = bytes_left - cur_page_len;
+		if (!bytes_left)
+			break;
+	}
+
+	return ret;
+}
+
+static int btrfs_decrypt_pages(struct list_head *na_ws, unsigned char *in,
+			struct page *out_page, unsigned long na_start_byte,
+			size_t in_size, size_t out_size)
+{
+	int ret;
+	char *out_addr;
+	struct address_space *mapping;
+	struct inode *inode;
+
+	if (!out_page)
+		return -EINVAL;
+
+	if (in_size > PAGE_SIZE) {
+		WARN_ON("BTRFS: crypto, cant decrypt more than pagesize\n");
+		return -EINVAL;
+	}
+
+	mapping = out_page->mapping;
+	if (!mapping && !mapping->host) {
+		WARN_ON("BTRFS: crypto, Need mapped pages\n");
+		return -EINVAL;
+	}
+
+	inode = mapping->host;
+
+	out_addr = kmap_atomic(out_page);
+	memcpy(out_addr, in, in_size);
+	kunmap_atomic(out_addr);
+
+	ret = btrfs_do_ablkcipher_by_inode(0, out_page, in_size, inode);
+
+#if BTRFS_CRYPTO_INFO_POTENTIAL_BUG
+	if (na_start_byte) {
+		pr_err("BTRFS: crypto, a context that a out start is not zero %lu\n",
+						na_start_byte);
+		BUG_ON(1);
+	}
+#endif
+
+	return ret;
+}
+
+static int btrfs_decrypt_pages_bio(struct list_head *na_ws,
+		struct page **in_pages, u64 disk_start, struct bio_vec *bvec,
+		int bi_vcnt, size_t in_len)
+{
+	char *in;
+	char *out;
+	int ret = 0;
+	int more = 0;
+	struct page *in_page;
+	struct page *out_page;
+	unsigned long bytes_left;
+	unsigned long total_in_pages;
+	unsigned long cur_page_len;
+	unsigned long processed_len = 0;
+	unsigned long page_in_index = 0;
+	unsigned long page_out_index = 0;
+	unsigned long saved_page_out_index = 0;
+	unsigned long pg_offset = 0;
+	struct address_space *mapping;
+	struct inode *inode;
+	total_in_pages = DIV_ROUND_UP(in_len, PAGE_SIZE);
+
+	if (na_ws)
+		return -EINVAL;
+
+	out_page = bvec[page_out_index].bv_page;
+	mapping = out_page->mapping;
+	if (!mapping && !mapping->host) {
+		WARN_ON("BTRFS: crypto, need mapped page\n");
+		return -EINVAL;
+	}
+
+	inode = mapping->host;
+
+#if BTRFS_CRYPTO_INFO_POTENTIAL_BUG
+	/* Hope the call here is an inode specific, or its not ? */
+	if (bi_vcnt > 1) {
+		int i;
+		struct inode *tmp_i;
+		for (i = 0; i < bi_vcnt; i++) {
+			tmp_i = (bvec[i].bv_page)->mapping->host;
+			if (tmp_i != inode)
+				pr_err("BTRFS: crypto, pages of diff files %lu and %lu\n",
+					tmp_i->i_ino, inode->i_ino);
+		}
+	}
+#endif
+
+	bytes_left = in_len;
+
+#if BTRFS_CRYPTO_INFO_POTENTIAL_BUG
+	if (total_in_pages < bi_vcnt)
+		pr_err("BTRFS: crypto, untested: pages to be decrypted is less than expected, "\
+			"total_in_pages %lu out_nr_pages %d in_len %lu\n",
+					total_in_pages, bi_vcnt, in_len);
+#endif
+
+	for (page_in_index = 0; page_in_index < total_in_pages;
+						page_in_index++) {
+		cur_page_len = min(bytes_left, PAGE_SIZE);
+		saved_page_out_index = page_out_index;
+
+		in_page = in_pages[page_in_index];
+		in = kmap(in_page);
+		more = btrfs_decompress_buf2page(in, processed_len,
+				processed_len + cur_page_len, disk_start,
+				bvec, bi_vcnt, &page_out_index, &pg_offset);
+		kunmap(in_page);
+
+		/*
+		 * if page_out_index is incremented then we know data to
+		 * decrypt is in the outpage.
+		 */
+		if (!more || saved_page_out_index != page_out_index) {
+			out_page = bvec[saved_page_out_index].bv_page;
+			ret = btrfs_do_ablkcipher_by_inode(0, out_page,
+						cur_page_len, inode);
+			if (ret)
+				return ret;
+
+			if (cur_page_len < PAGE_SIZE) {
+				out = kmap(out_page);
+				memset(out + cur_page_len, 0,
+						PAGE_SIZE - cur_page_len);
+				kunmap(out_page);
+			}
+		}
+
+		bytes_left = bytes_left - cur_page_len;
+		processed_len = processed_len + cur_page_len;
+		if (!more)
+			break;
+	}
+	return 0;
+}
+
+const struct btrfs_compress_op btrfs_encrypt_ops = {
+	.alloc_workspace	= NULL,
+	.free_workspace		= NULL,
+	.compress_pages		= btrfs_encrypt_pages,
+	.decompress_biovec	= btrfs_decrypt_pages_bio,
+	.decompress		= btrfs_decrypt_pages,
+};
diff --git a/fs/btrfs/encrypt.h b/fs/btrfs/encrypt.h
new file mode 100644
index 000000000000..8e794da9d8f5
--- /dev/null
+++ b/fs/btrfs/encrypt.h
@@ -0,0 +1,94 @@
+/*
+ * Copyright (C) 2016 Oracle.  All rights reserved.
+ * Author: Anand Jain, (anand.jain@oracle.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#ifndef __ENCRYPT__
+#define __ENCRYPT__
+/*
+ * Encryption sub features defines.
+ */
+#ifndef BTRFS_CRYPT_SUB_FEATURES
+//testing
+	//enable method
+	#define BTRFS_CRYPTO_TEST_ENABLE_BYMNTOPT	0
+	//key choice
+	#define BTRFS_CRYPTO_TEST_BYDUMMYKEY		0 //off rest
+	#define BTRFS_CRYPTO_TEST_BYDUMMYENC		0 //off rest
+
+//debug
+	#define BTRFS_CRYPTO_INFO_POTENTIAL_BUG 	1
+
+//feature
+	#define BTRFS_CRYPTO_KEY_TYPE_LOGON		1
+#endif
+
+#define BTRFS_CRYPTO_TFM_NAME_SIZE	16
+#define BTRFS_CRYPTO_KEYTAG_SIZE	16
+#define BTRFS_CRYPTO_KEY_SIZE		16
+#define BTRFS_CRYPTO_IV_SIZE		16
+#define BTRFS_CRYPTO_IV_IV 	\
+	"\x12\x34\x56\x78\x90\xab\xcd\xef\x12\x34\x56\x78\x90\xab\xcd\xef"
+#if BTRFS_CRYPTO_KEY_TYPE_LOGON
+	#define BTRFS_CRYPTO_KEY_TYPE &key_type_logon
+#else
+	#define BTRFS_CRYPTO_KEY_TYPE &key_type_user
+#endif
+
+struct btrfs_ablkcipher_result {
+	struct completion completion;
+	int err;
+};
+
+struct btrfs_ablkcipher_req_data {
+	char cipher_name[17];
+	struct scatterlist sg_src;
+	struct crypto_ablkcipher *tfm;
+	struct ablkcipher_request *req;
+	unsigned char key[BTRFS_CRYPTO_KEY_SIZE];
+	size_t key_len;
+	unsigned char iv[BTRFS_CRYPTO_IV_SIZE];
+	size_t iv_size;
+	struct btrfs_ablkcipher_result cb_result;
+};
+
+struct btrfs_blkcipher_req {
+	unsigned char key[BTRFS_CRYPTO_KEY_SIZE];
+	size_t key_len;
+	unsigned char cryptoiv[BTRFS_CRYPTO_IV_SIZE];
+	size_t iv_len;
+};
+
+int get_encrypt_type_index(char *type_name);
+size_t get_encrypt_type_len(char *encryption_type);
+int btrfs_update_key_to_binode(struct inode *inode);
+int btrfs_validate_keytag(struct inode *inode, unsigned char *keytag);
+int btrfs_check_keytag(char *keytag);
+int btrfs_set_keyhash(struct inode *inode, char *keytag);
+int btrfs_request_key(char *key_tag, void *key_data);
+int btrfs_key_get(struct inode *inode);
+void btrfs_key_put(struct inode *inode);
+int btrfs_check_key_access(struct inode *inode);
+int btrfs_do_ablkcipher(int enc, struct page *page, unsigned long len,
+			struct btrfs_ablkcipher_req_data *btrfs_req);
+int btrfs_get_master_key(struct inode *inode,
+					unsigned char *keydata);
+int btrfs_cipher_iv(int encrypt, struct inode *inode,
+					char *data, size_t len);
+void btrfs_disable_encrypt_inode(struct inode *inode);
+void print_hex(char *key, size_t len, char *prefix);
+#endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8b1212e8f7a8..f07c86245c70 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -60,6 +60,7 @@
 #include "hash.h"
 #include "props.h"
 #include "qgroup.h"
+#include "encrypt.h"
 
 struct btrfs_iget_args {
 	struct btrfs_key *location;
@@ -206,10 +207,13 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 		}
 		btrfs_set_file_extent_compression(leaf, ei,
 						  compress_type);
+		if (compress_type == BTRFS_ENCRYPT_AES)
+			btrfs_set_file_extent_encryption(leaf, ei, 1);
 	} else {
 		page = find_get_page(inode->i_mapping,
 				     start >> PAGE_SHIFT);
 		btrfs_set_file_extent_compression(leaf, ei, 0);
+		btrfs_set_file_extent_encryption(leaf, ei, 0);
 		kaddr = kmap_atomic(page);
 		offset = start & (PAGE_SIZE - 1);
 		write_extent_buffer(leaf, kaddr + offset, ptr, size);
@@ -386,6 +390,154 @@ static inline int inode_need_compress(struct inode *inode)
 	return 0;
 }
 
+static int btrfs_inline_extent_able(struct inode *inode,
+				u64 start, u64 end, size_t data_len)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	u64 isize = i_size_read(inode);
+	u64 actual_end = min(end + 1, isize);
+
+	if (start > 0 ||
+	    actual_end > root->sectorsize ||
+	    data_len > BTRFS_MAX_INLINE_DATA_SIZE(root) ||
+	    (!data_len &&
+	    (actual_end & (root->sectorsize - 1)) == 0) ||
+	    end + 1 < isize ||
+	    data_len > root->fs_info->max_inline) {
+		return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * In crypto bailout is only when its inevitable, in the long run we
+ * should merge this to compress_file_range() though.
+ */
+static noinline int encrypt_file_range(struct inode *inode,
+			struct page *locked_page, u64 start, u64 end,
+			struct async_cow *async_cow, int *num_added)
+{
+	int ret = 0;
+	u64 actual_end;
+	unsigned long len = 0;
+	unsigned long nr_pages;
+	int may_inline_dont_align = -1; //test with btrfs/035
+	struct page **pages = NULL;
+	unsigned long total_in = 0;
+	unsigned long ram_bytes = 0;
+	unsigned long total_out = 0;
+	unsigned long nr_pages_ret = 0;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int encode_type = root->fs_info->compress_type;
+
+	if (BTRFS_I(inode)->force_compress)
+		encode_type = BTRFS_I(inode)->force_compress;
+
+	if ((end - start + 1) < SZ_16K &&
+	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
+		btrfs_add_inode_defrag(NULL, inode);
+
+	actual_end = min_t(u64, i_size_read(inode), end + 1);
+	if (actual_end < start)
+		actual_end = end + 1;
+
+again:
+	if (actual_end <= start)
+		return 0;
+
+	len = min_t(unsigned long, actual_end - start, SZ_128K);
+
+	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
+	nr_pages = min_t(unsigned long, nr_pages, SZ_128K / PAGE_SIZE);
+	pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
+	if (!pages) {
+		pr_err("BTRFS: Fatal: kcalloc for encrypt page list failed\n");
+		goto inevitable_bailout;
+	}
+
+	extent_range_clear_dirty_for_io(inode, start, end);
+
+	total_in = 0;
+	total_out = 0;
+	nr_pages_ret = 0;
+
+	if (len == actual_end)
+		may_inline_dont_align = btrfs_inline_extent_able(inode,
+							start, end, len);
+	else
+		may_inline_dont_align = 0;
+	ret = btrfs_compress_pages(encode_type, inode->i_mapping, start,
+				len, pages, nr_pages, &nr_pages_ret,
+				&total_in, &total_out, SZ_128K,
+				may_inline_dont_align);
+	if (ret) {
+		kfree(pages);
+		goto inevitable_bailout;
+	}
+
+	if (may_inline_dont_align) {
+
+		ret = cow_file_range_inline(root, inode, start, end,
+					total_out, encode_type, pages);
+
+		if (!ret) {
+			extent_clear_unlock_delalloc(inode, start, end,
+				NULL, EXTENT_DELALLOC | EXTENT_DEFRAG,
+				PAGE_UNLOCK | PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
+				PAGE_END_WRITEBACK);
+			return 0;
+		}
+
+		if (ret < 0)
+			goto inevitable_bailout;
+	}
+
+	ram_bytes = ALIGN(total_in, PAGE_SIZE);
+
+	ret = add_async_extent(async_cow, start, ram_bytes, total_out, pages,
+						nr_pages_ret, encode_type);
+	*num_added += 1;
+	if (start + total_in < end) {
+		start += total_in;
+		pages = NULL;
+		cond_resched();
+		goto again;
+	}
+
+	return ret;
+
+inevitable_bailout:
+	if (start == 0) {
+		ret = cow_file_range_inline(root, inode, start, end,
+					0, BTRFS_COMPRESS_NONE, NULL);
+		if (ret <= 0) {
+			unsigned long clear_flags = EXTENT_DELALLOC |
+							EXTENT_DEFRAG;
+			unsigned long page_error_op = PAGE_UNLOCK |
+				PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
+				PAGE_END_WRITEBACK;
+
+			clear_flags |= (ret < 0) ? EXTENT_DO_ACCOUNTING : 0;
+			page_error_op |= (ret < 0) ? PAGE_SET_ERROR : 0;
+
+			extent_clear_unlock_delalloc(inode, start, end, NULL,
+						clear_flags, page_error_op);
+			return ret;
+		}
+	}
+	if (page_offset(locked_page) >= start &&
+				page_offset(locked_page) <= end)
+			__set_page_dirty_nobuffers(locked_page);
+
+	extent_range_redirty_for_io(inode, start, end);
+	ret = add_async_extent(async_cow, start, end - start + 1,
+				0, NULL, 0, BTRFS_COMPRESS_NONE);
+	*num_added += 1;
+
+	return ret;
+}
+
 /*
  * we create compressed extents in two phases.  The first
  * phase compresses a range of pages that have already been
@@ -510,7 +662,7 @@ again:
 					   nr_pages, &nr_pages_ret,
 					   &total_in,
 					   &total_compressed,
-					   max_compressed);
+					   max_compressed, 0);
 
 		if (!ret) {
 			unsigned long offset = total_compressed &
@@ -1087,12 +1239,26 @@ out_unlock:
 static noinline void async_cow_start(struct btrfs_work *work)
 {
 	struct async_cow *async_cow;
+	struct inode *inode;
 	int num_added = 0;
+	int encode_type;
+
 	async_cow = container_of(work, struct async_cow, work);
+	inode = async_cow->inode;
+	encode_type = BTRFS_I(inode)->root->fs_info->compress_type;
 
-	compress_file_range(async_cow->inode, async_cow->locked_page,
+	if (BTRFS_I(inode)->force_compress)
+		encode_type = BTRFS_I(inode)->force_compress;
+
+	if (encode_type == BTRFS_ENCRYPT_AES)
+		encrypt_file_range(async_cow->inode, async_cow->locked_page,
+			    async_cow->start, async_cow->end, async_cow,
+			    &num_added);
+	else
+		compress_file_range(async_cow->inode, async_cow->locked_page,
 			    async_cow->start, async_cow->end, async_cow,
 			    &num_added);
+
 	if (num_added == 0) {
 		btrfs_add_delayed_iput(async_cow->inode);
 		async_cow->inode = NULL;
@@ -6735,6 +6901,8 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	max_size = min_t(unsigned long, PAGE_SIZE, max_size);
 	ret = btrfs_decompress(compress_type, tmp, page,
 			       extent_offset, inline_size, max_size);
+	if (ret && ret == -ENOKEY)
+		ret = 0;
 	kfree(tmp);
 	return ret;
 }
@@ -9249,6 +9417,11 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->i_otime.tv_sec = 0;
 	ei->i_otime.tv_nsec = 0;
 
+	memset(ei->key_payload, 0, BTRFS_CRYPTO_KEY_SIZE);
+	ei->key_len = 0;
+	memset(ei->cryptoiv, 0, BTRFS_CRYPTO_IV_SIZE);
+	ei->iv_len = 0;
+
 	inode = &ei->vfs_inode;
 	extent_map_tree_init(&ei->extent_tree);
 	extent_io_tree_init(&ei->io_tree, &inode->i_data);
@@ -9689,6 +9862,50 @@ out:
 	return ret;
 }
 
+static int btrfs_check_fops_move_crypto(struct btrfs_root *src,
+					struct btrfs_root *dest)
+{
+	u64 src_flags;
+	u64 dest_flags;
+
+	src_flags = btrfs_root_flags(&src->root_item);
+	dest_flags = btrfs_root_flags(&dest->root_item);
+
+	if (src == dest)
+		return 0;
+
+	/*
+	 * Move from non-encrypted sv to encrypted sv is a thing
+	 * as usual
+	 */
+	if (!(src_flags & BTRFS_ROOT_SUBVOL_ENCRYPT))
+		return 0;
+
+	/*
+	 * Here we are sure src is encrypted but not dest.
+	 * This means asking for reverse encryption which
+	 * is nosupp as of now. Workaround is to use cp instead.
+	 */
+	if (!(dest_flags & BTRFS_ROOT_SUBVOL_ENCRYPT))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Move to different sv, but having same key hash.
+	 * As of now there is only one encryption policy so just
+	 * approve the move, but its a 'crypto-fixme' when there
+	 * are mulitple encryption policies
+	 */
+	if (src->root_item.crypto_keyhash ==
+			dest->root_item.crypto_keyhash)
+		return 0;
+
+	/*
+	 * Any thing else no supp
+	 */
+
+	return -EOPNOTSUPP;
+}
+
 static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry,
 			   unsigned int flags)
@@ -9705,6 +9922,21 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	u64 old_ino = btrfs_ino(old_inode);
 	bool log_pinned = false;
 
+	u64 root_flags;
+	u64 dest_flags;
+	/*
+	 * File move across subvol with potentially a different/no
+	 * encryption key is not supported as if now.
+	 */
+	root_flags = btrfs_root_flags(&root->root_item);
+	dest_flags = btrfs_root_flags(&dest->root_item);
+	if ((root_flags & BTRFS_ROOT_SUBVOL_ENCRYPT) ||
+		(dest_flags & BTRFS_ROOT_SUBVOL_ENCRYPT)) {
+		ret = btrfs_check_fops_move_crypto(root, dest);
+		if (ret)
+			return ret;
+	}
+
 	if (btrfs_ino(new_dir) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
 		return -EPERM;
 
@@ -10403,6 +10635,25 @@ static int btrfs_permission(struct inode *inode, int mask)
 		if (BTRFS_I(inode)->flags & BTRFS_INODE_READONLY)
 			return -EACCES;
 	}
+
+	if (S_ISREG(mode)) {
+		int ret = 0;
+		u64 root_flags;
+
+		root_flags = btrfs_root_flags(&root->root_item);
+		if (root_flags & BTRFS_ROOT_SUBVOL_ENCRYPT) {
+			ret = btrfs_check_key_access(inode);
+			if (ret) {
+				return ret;
+			}
+			if (!BTRFS_I(inode)->key_len) {
+				ret = btrfs_update_key_to_binode(inode);
+				if (ret)
+					return ret;
+			}
+		}
+	}
+
 	return generic_permission(inode, mask);
 }
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 05173563e4a6..0bcc0a357c02 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2144,8 +2144,15 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
 	int ret;
 	size_t buf_size;
 
+	/*
+	 * Allow tree serach by non root, so that non root
+	 * user can find info about the subvol they own/create.
+	 * BTRFS_CRYPTO_fixme: check if safe?.
+	 */
+#if 0
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
+#endif
 
 	uargs = (struct btrfs_ioctl_search_args __user *)argp;
 
@@ -2622,6 +2629,27 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 			}
 			/* compression requires us to start the IO */
 			if ((range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)) {
+#if !(BTRFS_CRYPTO_TEST_BYDUMMYKEY | BTRFS_CRYPTO_TEST_BYDUMMYENC)
+				/*
+				 * Check if user is trying to encrypt the file/root
+				 * which isn't under an encrypt subvol, as their isn't
+				 * key for that, unless we are under the defines
+				 * BTRFS_CRYPTO_TEST_BYDUMMYKEY or
+				 * BTRFS_CRYPTO_TEST_BYDUMMYENC
+				 * which means its testing context so don't really
+				 * worry about the key.
+				 */
+				if (range->compress_type == BTRFS_ENCRYPT_AES) {
+					u64 root_flags = btrfs_root_flags(&root->root_item);
+					/*
+					 * Presence of a valid key is already been verified
+					 * at the permission, just reject encrypt compress
+					 * type on a non encrypt subvol.
+					 */
+					if (!(root_flags & BTRFS_ROOT_SUBVOL_ENCRYPT))
+						return -EOPNOTSUPP;
+				}
+#endif
 				range->flags |= BTRFS_DEFRAG_RANGE_START_IO;
 				range->extent_thresh = (u32)-1;
 			}
@@ -3844,6 +3872,41 @@ out:
 	return ret;
 }
 
+static int btrfs_encode_check_fops(struct btrfs_root *src,
+			struct btrfs_root *dest, int fops)
+{
+#if 0
+	u64 src_flags;
+	u64 dest_flags;
+
+	src_flags = btrfs_root_flags(&src->root_item);
+	dest_flags = btrfs_root_flags(&dest->root_item);
+
+	if (src_flags & BTRFS_ROOT_SUBVOL_ENCRYPT)
+		return -EOPNOTSUPP;
+
+	if (dest_flags & BTRFS_ROOT_SUBVOL_ENCRYPT)
+		return -EOPNOTSUPP;
+
+	return 0;
+#else
+
+	switch(fops) {
+	case 1: //clone; not tested for per file compress/encrypt
+		if (src == dest)
+			return 0;
+
+		if (src->root_item.crypto_keyhash ==
+			dest->root_item.crypto_keyhash)
+			return 0;
+
+		return -EOPNOTSUPP;
+		break;
+	}
+	return -EINVAL;
+#endif
+}
+
 static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 					u64 off, u64 olen, u64 destoff)
 {
@@ -3873,6 +3936,10 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	    src->i_sb != inode->i_sb)
 		return -EXDEV;
 
+	ret = btrfs_encode_check_fops(BTRFS_I(src)->root, root, 1);
+	if (ret)
+		return ret;
+
 	/* don't make the dst file partly checksummed */
 	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
 	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 1adfbe7be6b8..46ed0fc5c137 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -92,7 +92,7 @@ static int lzo_compress_pages(struct list_head *ws,
 			      unsigned long *out_pages,
 			      unsigned long *total_in,
 			      unsigned long *total_out,
-			      unsigned long max_out)
+			      unsigned long max_out, int flags)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	int ret = 0;
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 36992128c746..a1c74ce29b9e 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -17,38 +17,74 @@
  */
 
 #include <linux/hashtable.h>
+#include <linux/random.h>
 #include "props.h"
 #include "btrfs_inode.h"
 #include "hash.h"
 #include "transaction.h"
 #include "xattr.h"
 #include "compression.h"
+#include "encrypt.h"
 
 #define BTRFS_PROP_HANDLERS_HT_BITS 8
 static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
 
+#define BTRFS_PROP_INHERIT_NONE		(1U << 0)
+#define BTRFS_PROP_INHERIT_FOR_DIR	(1U << 1)
+#define BTRFS_PROP_INHERIT_FOR_CLONE	(1U << 2)
+#define BTRFS_PROP_INHERIT_FOR_SUBVOL	(1U << 3)
+
 struct prop_handler {
 	struct hlist_node node;
 	const char *xattr_name;
-	int (*validate)(const char *value, size_t len);
+	int (*validate)(struct inode *inode, const char *value, size_t len);
 	int (*apply)(struct inode *inode, const char *value, size_t len);
 	const char *(*extract)(struct inode *inode);
 	int inheritable;
 };
 
-static int prop_compression_validate(const char *value, size_t len);
+static int prop_compression_validate(struct inode *inode, const char *value, size_t len);
 static int prop_compression_apply(struct inode *inode,
 				  const char *value,
 				  size_t len);
 static const char *prop_compression_extract(struct inode *inode);
 
+static int prop_encrypt_validate(struct inode *inode, const char *value, size_t len);
+static int prop_encrypt_apply(struct inode *inode,
+				  const char *value, size_t len);
+static const char *prop_encrypt_extract(struct inode *inode);
+static int prop_cryptoiv_validate(struct inode *inode, const char *value, size_t len);
+static int prop_cryptoiv_apply(struct inode *inode,
+				  const char *value, size_t len);
+static const char *prop_cryptoiv_extract(struct inode *inode);
+
 static struct prop_handler prop_handlers[] = {
 	{
 		.xattr_name = XATTR_BTRFS_PREFIX "compression",
 		.validate = prop_compression_validate,
 		.apply = prop_compression_apply,
 		.extract = prop_compression_extract,
-		.inheritable = 1
+		.inheritable = BTRFS_PROP_INHERIT_FOR_DIR| \
+				BTRFS_PROP_INHERIT_FOR_CLONE| \
+				BTRFS_PROP_INHERIT_FOR_SUBVOL,
+	},
+	{
+		.xattr_name = XATTR_BTRFS_PREFIX "encrypt",
+		.validate = prop_encrypt_validate,
+		.apply = prop_encrypt_apply,
+		.extract = prop_encrypt_extract,
+		.inheritable = BTRFS_PROP_INHERIT_FOR_DIR| \
+				BTRFS_PROP_INHERIT_FOR_CLONE| \
+				BTRFS_PROP_INHERIT_FOR_SUBVOL,
+	},
+	{
+		.xattr_name = XATTR_BTRFS_PREFIX "cryptoiv",
+		.validate = prop_cryptoiv_validate,
+		.apply = prop_cryptoiv_apply,
+		.extract = prop_cryptoiv_extract,
+		.inheritable = BTRFS_PROP_INHERIT_FOR_DIR| \
+				BTRFS_PROP_INHERIT_FOR_CLONE| \
+				BTRFS_PROP_INHERIT_FOR_SUBVOL,
 	},
 };
 
@@ -127,15 +163,19 @@ static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	ret = handler->validate(value, value_len);
-	if (ret)
+	ret = handler->validate(inode, value, value_len);
+	if (ret) {
 		return ret;
+	}
 	ret = __btrfs_setxattr(trans, inode, handler->xattr_name,
 			       value, value_len, flags);
-	if (ret)
+	if (ret) {
 		return ret;
+	}
 	ret = handler->apply(inode, value, value_len);
-	if (ret) {
+	if (ret && ret != -EKEYREJECTED) {
+		pr_err("BTRFS: property apply failed %s %d %s %lu\n",
+					name, ret, value, value_len);
 		__btrfs_setxattr(trans, inode, handler->xattr_name,
 				 NULL, 0, flags);
 		return ret;
@@ -143,7 +183,7 @@ static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
 
 	set_bit(BTRFS_INODE_HAS_PROPS, &BTRFS_I(inode)->runtime_flags);
 
-	return 0;
+	return ret;
 }
 
 int btrfs_set_prop(struct inode *inode,
@@ -276,13 +316,15 @@ static void inode_prop_iterator(void *ctx,
 	int ret;
 
 	ret = handler->apply(inode, value, len);
-	if (unlikely(ret))
-		btrfs_warn(root->fs_info,
+	if (unlikely(ret)) {
+		if (ret != -ENOKEY && ret != -EKEYREVOKED)
+			btrfs_warn(root->fs_info,
 			   "error applying prop %s to ino %llu (root %llu): %d",
 			   handler->xattr_name, btrfs_ino(inode),
 			   root->root_key.objectid, ret);
-	else
+	} else {
 		set_bit(BTRFS_INODE_HAS_PROPS, &BTRFS_I(inode)->runtime_flags);
+	}
 }
 
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path)
@@ -296,6 +338,20 @@ int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path)
 	return ret;
 }
 
+static int btrfs_create_iv(char **ivdata, unsigned int ivsize)
+{
+	char *tmp;
+	tmp = kmalloc(ivsize+1, GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+	get_random_bytes(tmp, ivsize);
+	tmp[ivsize] = '\0';
+
+	*ivdata = tmp;
+
+	return 0;
+}
+
 static int inherit_props(struct btrfs_trans_handle *trans,
 			 struct inode *inode,
 			 struct inode *parent)
@@ -313,6 +369,10 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 		const char *value;
 		u64 num_bytes;
 
+		/*
+		 * BTRFS_CRYPTO_fixme:
+		 * should be inheritable only by files inode type
+		 */
 		if (!h->inheritable)
 			continue;
 
@@ -323,13 +383,37 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 		num_bytes = btrfs_calc_trans_metadata_size(root, 1);
 		ret = btrfs_block_rsv_add(root, trans->block_rsv,
 					  num_bytes, BTRFS_RESERVE_NO_FLUSH);
-		if (ret)
+		if (ret) {
+			if (!strcmp(h->xattr_name, "btrfs.encrypt") ||
+				!strcmp(h->xattr_name, "btrfs.cryptoiv"))
+				kfree(value);
 			goto out;
-		ret = __btrfs_set_prop(trans, inode, h->xattr_name,
+		}
+		if (!strcmp(h->xattr_name, "btrfs.cryptoiv"))
+			ret = __btrfs_set_prop(trans, inode, h->xattr_name,
+				       value, BTRFS_CRYPTO_IV_SIZE, 0);
+		else
+			ret = __btrfs_set_prop(trans, inode, h->xattr_name,
 				       value, strlen(value), 0);
+		if (ret) {
+			pr_err("BTRFS: %lu failed to inherit '%s': %d\n",
+					inode->i_ino, h->xattr_name, ret);
+			if (!strcmp(h->xattr_name, "btrfs.encrypt") ||
+				!strcmp(h->xattr_name, "btrfs.cryptoiv"))
+				btrfs_disable_encrypt_inode(inode);
+			dump_stack();
+		}
+
 		btrfs_block_rsv_release(root, trans->block_rsv, num_bytes);
-		if (ret)
+		if (ret) {
+			if (!strcmp(h->xattr_name, "btrfs.encrypt") ||
+				!strcmp(h->xattr_name, "btrfs.cryptoiv"))
+				kfree(value);
 			goto out;
+		}
+		if (!strcmp(h->xattr_name, "btrfs.encrypt") ||
+			!strcmp(h->xattr_name, "btrfs.cryptoiv"))
+			kfree(value);
 	}
 	ret = 0;
 out:
@@ -376,8 +460,11 @@ int btrfs_subvol_inherit_props(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int prop_compression_validate(const char *value, size_t len)
+static int prop_compression_validate(struct inode *inode, const char *value, size_t len)
 {
+	if (BTRFS_I(inode)->force_compress == BTRFS_ENCRYPT_AES)
+		return -ENOTSUPP;
+
 	if (!strncmp("lzo", value, len))
 		return 0;
 	else if (!strncmp("zlib", value, len))
@@ -426,4 +513,218 @@ static const char *prop_compression_extract(struct inode *inode)
 	return NULL;
 }
 
+static int btrfs_split_key_type(const char *val, size_t len,
+					char *tfm, char *keytag)
+{
+	char *tmp;
+	char *tmp2;
+	char tmp1[BTRFS_CRYPTO_KEYTAG_SIZE + BTRFS_CRYPTO_TFM_NAME_SIZE + 1];
 
+	if (len > BTRFS_CRYPTO_KEYTAG_SIZE + BTRFS_CRYPTO_TFM_NAME_SIZE) {
+		return -EINVAL;
+	}
+	memcpy(tmp1, val, len);
+	tmp1[len] = '\0';
+	tmp = tmp1;
+	tmp2 = strsep(&tmp, "@");
+	if (!tmp2)
+		return -EINVAL;
+
+	if (strlen(tmp2) > BTRFS_CRYPTO_TFM_NAME_SIZE ||
+			strlen(tmp) > BTRFS_CRYPTO_KEYTAG_SIZE)
+		return -EINVAL;
+
+	strcpy(tfm, tmp2);
+	strcpy(keytag, tmp);
+
+	return 0;
+}
+
+/*
+ * The required foramt in the value is <crypto_algo>@<key_tag>
+ * eg: btrfs.encrypt="ctr(aes)@btrfs:61e0d004"
+ */
+static int prop_encrypt_validate(struct inode *inode,
+					const char *value, size_t len)
+{
+	int ret;
+	size_t keylen;
+	char keytag[BTRFS_CRYPTO_KEYTAG_SIZE + 1];
+	char keyalgo[BTRFS_CRYPTO_TFM_NAME_SIZE + 1];
+
+	if (BTRFS_I(inode)->force_compress == BTRFS_COMPRESS_ZLIB ||
+		BTRFS_I(inode)->force_compress == BTRFS_COMPRESS_LZO)
+		return -ENOTSUPP;
+
+	if (!len)
+		return 0;
+
+	if (len > (BTRFS_CRYPTO_TFM_NAME_SIZE + BTRFS_CRYPTO_KEYTAG_SIZE ))
+		return -EINVAL;
+
+	ret = btrfs_split_key_type(value, len, keyalgo, keytag);
+	if (ret) {
+		pr_err("BTRFS: %lu mal formed value '%s' %lu\n",
+					inode->i_ino, value, len);
+		return ret;
+	}
+
+	keylen = get_encrypt_type_len(keyalgo);
+	if (!keylen)
+		return -ENOTSUPP;
+
+	ret = btrfs_check_keytag(keytag);
+	if (!ret)
+		return ret;
+
+	ret = btrfs_validate_keytag(inode, keytag);
+	// check if its newly being set
+	if (ret == -ENOTSUPP)
+		ret = 0;
+
+	return ret;
+}
+
+static int prop_encrypt_apply(struct inode *inode,
+				const char *value, size_t len)
+{
+	int ret;
+	u64 root_flags;
+	char keytag[BTRFS_CRYPTO_KEYTAG_SIZE];
+	char keyalgo[BTRFS_CRYPTO_TFM_NAME_SIZE];
+	struct btrfs_root_item *root_item;
+	struct btrfs_root *root;
+
+	root_item = &(BTRFS_I(inode)->root->root_item);
+	root = BTRFS_I(inode)->root;
+
+	if (len == 0) {
+		/* means disable encryption */
+		return -EOPNOTSUPP;
+	}
+
+	ret = btrfs_split_key_type(value, len, keyalgo, keytag);
+	if (ret)
+		return ret;
+
+	/* do it only for the subvol or snapshot */
+	if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID) {
+		if (!root_item->crypto_keyhash) {
+			pr_info("BTRFS: subvol %pU enable encryption '%s'\n",
+							root_item->uuid, keyalgo);
+			/*
+			 * We are here when xattribute being set for the first time
+			 */
+			ret = btrfs_set_keyhash(inode, keytag);
+			if (!ret) {
+				root_flags = btrfs_root_flags(root_item);
+				btrfs_set_root_flags(root_item,
+					root_flags | BTRFS_ROOT_SUBVOL_ENCRYPT);
+
+				strncpy(root_item->encrypt_algo, keyalgo,
+						BTRFS_CRYPTO_TFM_NAME_SIZE);
+			}
+		} else {
+			ret = btrfs_validate_keytag(inode, keytag);
+		}
+		if (!ret)
+			strncpy(root->crypto_keytag, keytag,
+						BTRFS_CRYPTO_KEYTAG_SIZE);
+	}
+
+	if (!ret) {
+		BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
+		BTRFS_I(inode)->force_compress = get_encrypt_type_index(keyalgo);
+	}
+
+	return ret;
+}
+
+static int tuplet_encrypt_tfm_and_tag(char *val_out, char *tfm, char *tag)
+{
+	char tmp_tag[BTRFS_CRYPTO_KEYTAG_SIZE + 1];
+	char tmp_tfm[BTRFS_CRYPTO_TFM_NAME_SIZE + 1];
+	int sz = BTRFS_CRYPTO_TFM_NAME_SIZE + BTRFS_CRYPTO_KEYTAG_SIZE + 1;
+
+	memcpy(tmp_tag, tag, BTRFS_CRYPTO_KEYTAG_SIZE);
+	memcpy(tmp_tfm, tfm, BTRFS_CRYPTO_TFM_NAME_SIZE);
+
+	tmp_tag[BTRFS_CRYPTO_KEYTAG_SIZE] = '\0';
+	tmp_tfm[BTRFS_CRYPTO_TFM_NAME_SIZE] = '\0';
+
+	return snprintf(val_out, sz, "%s@%s", tmp_tfm, tmp_tag);
+}
+
+static const char *prop_encrypt_extract(struct inode *inode)
+{
+	struct btrfs_root *root;
+	char val[BTRFS_CRYPTO_TFM_NAME_SIZE + BTRFS_CRYPTO_KEYTAG_SIZE + 1];
+
+	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_ENCRYPT))
+		return NULL;
+
+	root = BTRFS_I(inode)->root;
+
+	tuplet_encrypt_tfm_and_tag(val, root->root_item.encrypt_algo,
+							root->crypto_keytag);
+
+	return kstrdup(val, GFP_NOFS);
+}
+
+static int prop_cryptoiv_validate(struct inode *inode,
+					const char *value, size_t len)
+{
+	if (len < BTRFS_CRYPTO_IV_SIZE)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int prop_cryptoiv_apply(struct inode *inode,
+				const char *value, size_t len)
+{
+	int ret;
+	char *tmp_val;
+
+	if (!strlen(BTRFS_I(inode)->root->crypto_keytag))
+		return -ENOKEY;
+
+	tmp_val = kmemdup(value, len, GFP_KERNEL);
+	/* decrypt iv and apply to binode */
+	ret = btrfs_cipher_iv(0, inode, tmp_val, len);
+	if (ret) {
+		pr_err("BTRFS: %lu prop_cryptoiv_apply failed ret %d len %lu\n",
+			inode->i_ino, ret, len);
+		return ret;
+	}
+
+	memcpy(BTRFS_I(inode)->cryptoiv, tmp_val, len);
+	BTRFS_I(inode)->iv_len = len;
+
+	kfree(tmp_val);
+	return 0;
+}
+
+static const char *prop_cryptoiv_extract(struct inode *inode)
+{
+	int ret;
+	char *ivdata = NULL;
+
+	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_ENCRYPT))
+		return NULL;
+
+	ret = btrfs_create_iv(&ivdata, BTRFS_CRYPTO_IV_SIZE);
+	if (ret)
+		return NULL;
+
+	/* Encrypt iv with master key */
+	ret = btrfs_cipher_iv(1, inode, ivdata,
+					BTRFS_CRYPTO_IV_SIZE);
+	if (ret) {
+		pr_err("BTRFS Error: %lu iv encrypt failed: %d\n",
+						inode->i_ino, ret);
+		kfree(ivdata);
+		return NULL;
+	}
+	return ivdata;
+}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4339b6613f19..b90fc1cfad2f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -59,10 +59,10 @@
 #include "free-space-cache.h"
 #include "backref.h"
 #include "tests/btrfs-tests.h"
-
 #include "qgroup.h"
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
+#include "encrypt.h"
 
 static const struct super_operations btrfs_super_ops;
 static struct file_system_type btrfs_fs_type;
@@ -92,6 +92,9 @@ const char *btrfs_decode_error(int errno)
 	case -ENOENT:
 		errstr = "No such entry";
 		break;
+	case -ENOKEY:
+		errstr = "Required key not available";
+		break;
 	}
 
 	return errstr;
@@ -491,6 +494,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options,
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
 				no_compress = 0;
+#if BTRFS_CRYPTO_TEST_ENABLE_BYMNTOPT
+			} else if (strcmp(args[0].from, "ctr(aes)") == 0) {
+				compress_type = "ctr(aes)";
+				info->compress_type = BTRFS_ENCRYPT_AES;
+				btrfs_set_opt(info->mount_opt, COMPRESS);
+				btrfs_clear_opt(info->mount_opt, NODATACOW);
+				btrfs_clear_opt(info->mount_opt, NODATASUM);
+				no_compress = 0;
+#endif
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
 				btrfs_clear_opt(info->mount_opt, COMPRESS);
@@ -1208,10 +1220,19 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 					     num_online_cpus() + 2, 8))
 		seq_printf(seq, ",thread_pool=%d", info->thread_pool_size);
 	if (btrfs_test_opt(root, COMPRESS)) {
-		if (info->compress_type == BTRFS_COMPRESS_ZLIB)
+		switch(info->compress_type) {
+		case BTRFS_COMPRESS_ZLIB:
 			compress_type = "zlib";
-		else
+			break;
+		case BTRFS_COMPRESS_LZO:
 			compress_type = "lzo";
+			break;
+		case BTRFS_ENCRYPT_AES:
+			compress_type = "ctr(aes)";
+			break;
+		default:
+			compress_type = "error";
+		}
 		if (btrfs_test_opt(root, FORCE_COMPRESS))
 			seq_printf(seq, ",compress-force=%s", compress_type);
 		else
diff --git a/fs/btrfs/tests/crypto-tests.c b/fs/btrfs/tests/crypto-tests.c
new file mode 100755
index 000000000000..917c5837cc3f
--- /dev/null
+++ b/fs/btrfs/tests/crypto-tests.c
@@ -0,0 +1,376 @@
+#include <linux/highmem.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+#include <linux/scatterlist.h>
+#include <linux/random.h>
+#include <keys/user-type.h>
+#include "../extent_io.h"
+#include "../encrypt.h"
+#include "../hash.h"
+#include "crypto-tests.h"
+
+struct page *known_data_page = 0;
+char *known_data_str = 0;
+struct key *btrfs_key = 0;
+
+int __blkcipher(int encrypt, char *str, size_t sz)
+{
+	return 0;
+}
+
+int __ablkcipher(int enc, char *cipher_name, struct page *page,
+						unsigned long len)
+{
+	struct btrfs_ablkcipher_req_data btrfs_req;
+	char *key_str;
+
+	memset(&btrfs_req, 0, sizeof(btrfs_req));
+	key_str = kstrdup(
+	"\x12\x34\x56\x78\x90\xab\xcd\xef\x12\x34\x56\x78\x90\xab\xcd\xef",
+			GFP_NOFS);
+	memcpy(btrfs_req.key, key_str, 16);
+
+	strcpy(btrfs_req.cipher_name, cipher_name);
+	return btrfs_do_ablkcipher(enc, page, len, &btrfs_req);
+}
+
+bool is_same_as_known_data_page(char *a, char *b, size_t sz)
+{
+	return !memcmp(a, b, sz);
+}
+
+void __check_same_print(char *a, char *b, size_t sz, int for_encrypt)
+{
+	if (is_same_as_known_data_page(a, b, sz)) {
+		if (for_encrypt)
+			printk("_BTRFS_: encrypt failed !!!\n");
+		else
+			printk("_BTRFS_: decrypt success\n");
+	} else {
+		if (for_encrypt)
+			printk("_BTRFS_: encrypt success\n");
+		else
+			printk("_BTRFS_: decrypt failed !!!\n");
+	}
+}
+
+void test_pr_result(struct page *page_in, int for_encrypt)
+{
+	char *a = page_address(page_in);
+	char *b = page_address(known_data_page);
+
+	__check_same_print(a, b, TEST_DATA_SIZE, for_encrypt);
+}
+
+void test_pr_result_str(char *a, int for_encrypt)
+{
+	__check_same_print(a, known_data_str, TEST_DATA_SIZE, for_encrypt);
+}
+
+void test_init(void)
+{
+	char *kaddr;
+	char *str = "deadbeef";
+	unsigned long dlen = strlen(str);
+	unsigned long offset;
+
+	if (known_data_page)
+		return;
+
+	if (TEST_DATA_SIZE > PAGE_SIZE) {
+		printk("_BTRFS_: TEST_DATA_PAGE is bigger than PAGE_SIZE\n");
+		return;
+	}
+
+	known_data_page = alloc_page(GFP_NOFS);
+	//known_data_page = get_zeroed_page(GFP_NOFS);
+	if (!known_data_page) {
+		printk("_BTRFS_: FAILED to alloc page\n");
+		return;
+	}
+
+	/* Fill known data */
+	kaddr = page_address(known_data_page);
+	for (offset = 0; offset < TEST_DATA_SIZE; offset = offset + dlen)
+		memcpy(kaddr + offset, str, dlen);
+
+	flush_kernel_dcache_page(known_data_page);
+}
+
+void test_fini(void)
+{
+	if (known_data_page)
+		__free_page(known_data_page);
+}
+
+
+void test_print_data(const char *str, char *prefix, size_t sz, int print_as_str)
+{
+	int i;
+	printk("_BTRFS_: %s: sz %lu: ", prefix, sz);
+
+	if (print_as_str)
+		for (i = 0; i < sz; i++) printk("%c", str[i]);
+	else
+		for (i = 0; i < sz; i++) printk("%02x ", 0xF & str[i]);
+
+	printk("\n");
+}
+
+struct page *test_alloc_page_cpy_known_data(void)
+{
+	struct page *page;
+	char *kaddr;
+	char *kaddr_known_data;
+
+	page = alloc_page(GFP_NOFS|__GFP_HIGHMEM);
+	if (!page) {
+		printk("_BTRFS_: FAILED to alloc page\n");
+		return NULL;
+	}
+	kaddr = kmap(page);
+
+	if (!known_data_page)
+		test_init();
+	kaddr_known_data = kmap(known_data_page);
+
+	memcpy(kaddr, kaddr_known_data, TEST_DATA_SIZE);
+
+	kunmap(page);
+	kunmap(known_data_page);
+
+	return page;
+}
+
+char *test_alloc_known_data_str(void)
+{
+	char *str;
+
+	known_data_str = kzalloc(TEST_DATA_SIZE, GFP_NOFS);
+	strncpy(known_data_str, "This is test", TEST_DATA_SIZE);
+
+	str = kzalloc(TEST_DATA_SIZE, GFP_NOFS);
+	memcpy(str, known_data_str, TEST_DATA_SIZE);
+	return str;
+}
+
+void test_blkcipher(void)
+{
+	int ret;
+	char *str;
+
+	str = test_alloc_known_data_str();
+
+	printk("_BTRFS_: ------ testing blkcipher start ------\n");
+	ret = __blkcipher(1, str, TEST_DATA_SIZE);
+	if (ret) goto out;
+	test_pr_result_str(str, 1);
+	ret = __blkcipher(0, str, TEST_DATA_SIZE);
+	if (ret) goto out;
+	test_pr_result_str(str, 0);
+	printk("_BTRFS_: ------ testing blkcipher end ------\n");
+
+out:
+	kfree(str);
+	kfree(known_data_str);
+	known_data_str = NULL;
+}
+
+void test_ablkcipher(void)
+{
+	struct page *page;
+
+	test_init();
+	page = test_alloc_page_cpy_known_data();
+
+	printk("_BTRFS_: ------- testing ablkcipher start ---------\n");
+	__ablkcipher(1, "cts(cbc(aes))", page, TEST_DATA_SIZE);
+	test_pr_result(page, 1);
+	__ablkcipher(0, "cts(cbc(aes))", page, TEST_DATA_SIZE);
+	test_pr_result(page, 0);
+
+	__ablkcipher(1, "ctr(aes)", page, TEST_DATA_SIZE);
+	test_pr_result(page, 1);
+	__ablkcipher(0, "ctr(aes)", page, TEST_DATA_SIZE);
+	test_pr_result(page, 0);
+	printk("_BTRFS_: ------ testing ablkcipher end ------------\n\n");
+
+	__free_page(page);
+
+	test_fini();
+}
+
+bool does_pages_match(struct address_space *mapping, u64 start, unsigned long len,
+			unsigned long nr_page, struct page **pages)
+{
+	int ret;
+	char *in;
+	char *out;
+	struct page *in_page;
+	struct page *out_page;
+	unsigned long bytes_left = len;
+	unsigned long cur_page_len;
+	unsigned long cr_page;
+
+	for (cr_page = 0; cr_page < nr_page; cr_page++) {
+
+		WARN_ON(!bytes_left);
+
+		in_page = find_get_page(mapping, start >> PAGE_SHIFT);
+		out_page = pages[cr_page];
+		cur_page_len = min(bytes_left, PAGE_SIZE);
+
+		in = kmap(in_page);
+		out = kmap(out_page);
+		ret = memcmp(out, in, cur_page_len);
+		kunmap(out_page);
+		kunmap(in_page);
+		if (ret)
+			return false;
+
+		start += cur_page_len;
+		bytes_left = bytes_left - cur_page_len;
+	}
+
+	return true;
+}
+
+void test_key(char *keytag)
+{
+	int ret;
+	unsigned char key_payload[16];
+
+	printk("_BTRFS_: ---- test_key() start -----\n");
+	ret = btrfs_request_key(keytag, key_payload);
+	if (ret == -ENOKEY) {
+		printk("_BTRFS_: NOKEY: keytag %s\n", keytag);
+		return;
+	}
+	if (ret) {
+		printk("_BTRFS_: request key failed !! %d\n", ret);
+		return;
+	}
+	printk("_BTRFS_: ------ test_key() end -----\n");
+}
+
+void test_print_data_v2(struct page *page, int endec)
+{
+	char *data;
+	char tmp[80];
+
+	data = kmap(page);
+	strncpy(tmp, data, 80);
+	kunmap(page);
+
+	printk("_BTRFS_: %s\n", tmp);
+}
+
+void test_open_key()
+{
+	btrfs_key = request_key(&key_type_user, "btrfs_test", NULL);
+	if (IS_ERR(btrfs_key)) {
+		printk("_BTRFS_: getting test key 'btrfs_test' failed\n");
+		btrfs_key = NULL;
+		return;
+	}
+
+	printk("_BTRFS_: Got test key serial %d\n", btrfs_key->serial);
+	down_write_nested(&btrfs_key->sem, 1);
+}
+
+void test_close_key()
+{
+	if (btrfs_key) {
+		up_write(&btrfs_key->sem);
+		key_put(btrfs_key);
+	}
+}
+
+int test_ablkciphear2(char *cipher_name, size_t test_size)
+{
+	u32 crc1 = ~(u32)0;
+	u32 crc2 = ~(u32)0;
+	u32 crc3 = ~(u32)0;
+	u32 seed;
+	struct page *page;
+	char *kaddr;
+	int ret = 0;
+	unsigned int page_nr;
+
+	page_nr = test_size/PAGE_SIZE;
+	page = alloc_pages(GFP_KERNEL, page_nr);
+	if (unlikely(!page)) {
+		printk("_BTRFS_: FAILED to alloc page\n");
+		return -ENOMEM;
+	}
+	kaddr = kmap(page);
+
+	get_random_bytes(&seed, 4);
+	crc1 = btrfs_crc32c(seed, kaddr, test_size);
+
+	/* Encrypt */
+	ret = __ablkcipher(1, cipher_name, page, test_size);
+	if (ret) {
+		printk("BTRFS_TEST: Encrypt '%s' size '%lu' Failed\n",
+			cipher_name, test_size);
+		return ret;
+	}
+
+	crc2 = btrfs_crc32c(seed, kaddr, test_size);
+
+	/* Decrypt */
+	ret = __ablkcipher(0, cipher_name, page, test_size);
+	if (ret) {
+		printk("BTRFS_TEST: Decrypt '%s' size '%lu' Failed\n",
+			cipher_name, test_size);
+		return ret;
+	}
+
+	crc3 = btrfs_crc32c(seed, kaddr, test_size);
+
+	if (crc1 == crc2) {
+		printk("BTRFS_TEST: %u:%u:%u\n", crc1,crc2,crc3);
+		printk("!!! BTRFS: ERROR: Encrypt failed !!! \n");
+		ret = -EINVAL;
+	}
+	if (!ret && (crc1 != crc3)) {
+		printk("BTRFS_TEST: %u:%u:%u\n", crc1,crc2,crc3);
+		printk("!!! BTRFS: ERROR: Decrypt failed !!!\n");
+		ret = -EINVAL;
+	}
+
+	kunmap(page);
+	__free_pages(page, page_nr);
+
+	return ret;
+}
+
+void workout(char *cipher_name)
+{
+	if (test_ablkciphear2(cipher_name, 16))
+		return;
+	if (test_ablkciphear2(cipher_name, 2024))
+		return;
+	if (test_ablkciphear2(cipher_name, 4096))
+		return;
+	if (test_ablkciphear2(cipher_name, 8192))
+		return;
+	if (test_ablkciphear2(cipher_name, 8333))
+		return;
+
+	test_ablkciphear2(cipher_name, 4097);
+	test_ablkciphear2(cipher_name, 1);
+	test_ablkciphear2(cipher_name, 15);
+}
+
+void btrfs_selftest_crypto(void)
+{
+	char cipher_name[17];
+
+	strcpy(cipher_name, "ctr(aes)");
+	workout(cipher_name);
+	/*
+	strcpy(cipher_name, "cts(cbc(aes))");
+	workout(cipher_name);
+	*/
+}
diff --git a/fs/btrfs/tests/crypto-tests.h b/fs/btrfs/tests/crypto-tests.h
new file mode 100755
index 000000000000..d51e78fb239e
--- /dev/null
+++ b/fs/btrfs/tests/crypto-tests.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2016 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#define BTRFS_CONFIG_TEST_ABLKCIPHER	1
+#define BTRFS_CONFIG_ZLIB_AS_ENCRYPT	1
+#define BTRFS_CONFIG_COMP_INT		1
+#define BTRFS_TEST_KEY			0
+
+//#define TEST_DATA_SIZE	16
+//#define TEST_DATA_SIZE	PAGE_CACHE_SIZE
+//#define TEST_DATA_SIZE	1024
+#define TEST_DATA_SIZE		2024
+
+void test_ablkcipher(void);
+void test_blkcipher(void);
+void test_print_data(const char *str, char *prefix, size_t sz, int print_str);
+void test_key(char *keytag);
+void test_pr_result(struct page *page_in, int for_encrypt);
+struct page *test_alloc_page_cpy_known_data(void);
+void test_fini(void);
+void test_open_key(void);
+void test_close_key(void);
+void btrfs_selftest_crypto(void);
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 88d274e8ecf2..5d007ec4ffbf 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -79,7 +79,7 @@ static int zlib_compress_pages(struct list_head *ws,
 			       unsigned long *out_pages,
 			       unsigned long *total_in,
 			       unsigned long *total_out,
-			       unsigned long max_out)
+			       unsigned long max_out, int flags)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	int ret;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index d5ad15a106a7..fb91acc7260e 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -593,6 +593,7 @@ struct btrfs_dir_item {
  * still visible as a directory
  */
 #define BTRFS_ROOT_SUBVOL_DEAD		(1ULL << 48)
+#define BTRFS_ROOT_SUBVOL_ENCRYPT	(1ULL << 49)
 
 struct btrfs_root_item {
 	struct btrfs_inode_item inode;
@@ -636,7 +637,10 @@ struct btrfs_root_item {
 	struct btrfs_timespec otime;
 	struct btrfs_timespec stime;
 	struct btrfs_timespec rtime;
-	__le64 reserved[8]; /* for future */
+	char encrypt_algo[16];
+	__le32 crypto_keylen;
+	__le32 crypto_keyhash;
+	__le64 reserved[3]; /* for future */
 } __attribute__ ((__packed__));
 
 /*
-- 
2.7.0

