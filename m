Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC7BC2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 19:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46AC92081B
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 19:09:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="pRGMMHaG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46AC92081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbeJaEDr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 00:03:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55348 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725743AbeJaEDr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 00:03:47 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.22/8.16.0.22) with SMTP id w9UJ8oES021739
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 12:09:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=bJkuduBwGlm4NAGCnGYbd8fVkA61Vjmn/OcyOLjyHUo=;
 b=pRGMMHaGofdMIRijr03UK7Ha6jJFSErIVEIgxMMd2ryElFVPH9CcT//6GCFTK8lxBCaA
 gXcN1xbCSoSqtmvwYA54riXuAfwa8pgMG+IarQjCpo5+CI8DybHlout8JHOEdOBh+Lk/
 sg8AoIhp2MrPtyIo2w/+rttTKMQ2ptJa3qw= 
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2nevk584g3-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 12:09:01 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1531.3;
 Tue, 30 Oct 2018 12:08:50 -0700
Received: by devvm3802.prn3.facebook.com (Postfix, from userid 32154)
        id C55EC21C5AD9; Tue, 30 Oct 2018 12:08:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Nick Terrell <terrelln@fb.com>
Smtp-Origin-Hostname: devvm3802.prn3.facebook.com
To:     Nick Terrell <terrelln@fb.com>
CC:     <kernel-team@fb.com>, Omar Sandoval <osandov@fb.com>,
        <linux-btrfs@vger.kernel.org>, Jennifer Liu <jenniferliu620@fb.com>
Smtp-Origin-Cluster: prn3c11
Subject: [PATCH] btrfs: add zstd compression level support
Date:   Tue, 30 Oct 2018 12:06:21 -0700
Message-ID: <20181030190621.716013-1-terrelln@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-10-30_11:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Jennifer Liu <jenniferliu620@fb.com>

Adds zstd compression level support to btrfs. Zstd requires
different amounts of memory for each level, so the design had
to be modified to allow set_level() to allocate memory. We
preallocate one workspace of the maximum size to guarantee
forward progress. This feature is expected to be useful for
read-mostly filesystems, or when creating images.

Benchmarks run in qemu on Intel x86 with a single core.
The benchmark measures the time to copy the Silesia corpus [0] to
a btrfs filesystem 10 times, then read it back.

The two important things to note are:
- The decompression speed and memory remains constant.
  The memory required to decompress is the same as level 1.
- The compression speed and ratio will vary based on the source.

Level	Ratio	Compression	Decompression	Compression Memory
1    	2.59 	153 MB/s   	112 MB/s     	0.8 MB
2    	2.67 	136 MB/s   	113 MB/s     	1.0 MB
3    	2.72 	106 MB/s   	115 MB/s     	1.3 MB
4    	2.78 	86  MB/s   	109 MB/s     	0.9 MB
5    	2.83 	69  MB/s   	109 MB/s     	1.4 MB
6    	2.89 	53  MB/s   	110 MB/s     	1.5 MB
7    	2.91 	40  MB/s   	112 MB/s     	1.4 MB
8    	2.92 	34  MB/s   	110 MB/s     	1.8 MB
9    	2.93 	27  MB/s   	109 MB/s     	1.8 MB
10   	2.94 	22  MB/s   	109 MB/s     	1.8 MB
11   	2.95 	17  MB/s   	114 MB/s     	1.8 MB
12   	2.95 	13  MB/s   	113 MB/s     	1.8 MB
13   	2.95 	10  MB/s   	111 MB/s     	2.3 MB
14   	2.99 	7   MB/s   	110 MB/s     	2.6 MB
15   	3.03 	6   MB/s   	110 MB/s     	2.6 MB

[0] http://sun.aei.polsl.pl/~sdeor/index.php?page=silesia

Signed-off-by: Jennifer Liu <jenniferliu620@fb.com>
Signed-off-by: Nick Terrell <terrelln@fb.com>
---
 fs/btrfs/compression.c | 172 +++++++++++++++++++++++++----------------
 fs/btrfs/compression.h |  18 +++--
 fs/btrfs/lzo.c         |   5 +-
 fs/btrfs/super.c       |   7 +-
 fs/btrfs/zlib.c        |  33 ++++----
 fs/btrfs/zstd.c        |  74 ++++++++++++++----
 6 files changed, 204 insertions(+), 105 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 2955a4ea2fa8..bd8e69381dc9 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -822,11 +822,15 @@ void __init btrfs_init_compress(void)
 
 		/*
 		 * Preallocate one workspace for each compression type so
-		 * we can guarantee forward progress in the worst case
+		 * we can guarantee forward progress in the worst case.
+		 * Provide the maximum compression level to guarantee large
+		 * enough workspace.
 		 */
-		workspace = btrfs_compress_op[i]->alloc_workspace();
+		workspace = btrfs_compress_op[i]->alloc_workspace(
+				btrfs_compress_op[i]->max_level);
 		if (IS_ERR(workspace)) {
-			pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
+			pr_warn("BTRFS: cannot preallocate compression "
+				"workspace, will try later\n");
 		} else {
 			atomic_set(&btrfs_comp_ws[i].total_ws, 1);
 			btrfs_comp_ws[i].free_ws = 1;
@@ -835,23 +839,78 @@ void __init btrfs_init_compress(void)
 	}
 }
 
+/*
+ * put a workspace struct back on the list or free it if we have enough
+ * idle ones sitting around
+ */
+static void __free_workspace(int type, struct list_head *workspace,
+			     bool heuristic)
+{
+	int idx = type - 1;
+	struct list_head *idle_ws;
+	spinlock_t *ws_lock;
+	atomic_t *total_ws;
+	wait_queue_head_t *ws_wait;
+	int *free_ws;
+
+	if (heuristic) {
+		idle_ws	 = &btrfs_heuristic_ws.idle_ws;
+		ws_lock	 = &btrfs_heuristic_ws.ws_lock;
+		total_ws = &btrfs_heuristic_ws.total_ws;
+		ws_wait	 = &btrfs_heuristic_ws.ws_wait;
+		free_ws	 = &btrfs_heuristic_ws.free_ws;
+	} else {
+		idle_ws	 = &btrfs_comp_ws[idx].idle_ws;
+		ws_lock	 = &btrfs_comp_ws[idx].ws_lock;
+		total_ws = &btrfs_comp_ws[idx].total_ws;
+		ws_wait	 = &btrfs_comp_ws[idx].ws_wait;
+		free_ws	 = &btrfs_comp_ws[idx].free_ws;
+	}
+
+	spin_lock(ws_lock);
+	if (*free_ws <= num_online_cpus()) {
+		list_add(workspace, idle_ws);
+		(*free_ws)++;
+		spin_unlock(ws_lock);
+		goto wake;
+	}
+	spin_unlock(ws_lock);
+
+	if (heuristic)
+		free_heuristic_ws(workspace);
+	else
+		btrfs_compress_op[idx]->free_workspace(workspace);
+	atomic_dec(total_ws);
+wake:
+	cond_wake_up(ws_wait);
+}
+
+static void free_workspace(int type, struct list_head *ws)
+{
+	return __free_workspace(type, ws, false);
+}
+
 /*
  * This finds an available workspace or allocates a new one.
  * If it's not possible to allocate a new one, waits until there's one.
  * Preallocation makes a forward progress guarantees and we do not return
  * errors.
  */
-static struct list_head *__find_workspace(int type, bool heuristic)
+static struct list_head *__find_workspace(unsigned int type_level,
+					  bool heuristic)
 {
 	struct list_head *workspace;
 	int cpus = num_online_cpus();
+	int type = type_level & 0xF;
 	int idx = type - 1;
-	unsigned nofs_flag;
+	unsigned int level = (type_level & 0xF0) >> 4;
+	unsigned int nofs_flag;
 	struct list_head *idle_ws;
 	spinlock_t *ws_lock;
 	atomic_t *total_ws;
 	wait_queue_head_t *ws_wait;
 	int *free_ws;
+	int ret;
 
 	if (heuristic) {
 		idle_ws	 = &btrfs_heuristic_ws.idle_ws;
@@ -874,8 +933,17 @@ static struct list_head *__find_workspace(int type, bool heuristic)
 		list_del(workspace);
 		(*free_ws)--;
 		spin_unlock(ws_lock);
+		if (!heuristic) {
+			nofs_flag = memalloc_nofs_save();
+			ret = btrfs_compress_op[idx]->set_level(workspace,
+								level);
+			memalloc_nofs_restore(nofs_flag);
+			if (!ret) {
+				free_workspace(type, workspace);
+				goto again;
+			}
+		}
 		return workspace;
-
 	}
 	if (atomic_read(total_ws) > cpus) {
 		DEFINE_WAIT(wait);
@@ -899,7 +967,8 @@ static struct list_head *__find_workspace(int type, bool heuristic)
 	if (heuristic)
 		workspace = alloc_heuristic_ws();
 	else
-		workspace = btrfs_compress_op[idx]->alloc_workspace();
+		workspace = btrfs_compress_op[idx]->alloc_workspace(level);
+
 	memalloc_nofs_restore(nofs_flag);
 
 	if (IS_ERR(workspace)) {
@@ -930,60 +999,22 @@ static struct list_head *__find_workspace(int type, bool heuristic)
 	return workspace;
 }
 
-static struct list_head *find_workspace(int type)
+static struct list_head *find_workspace(unsigned int type_level)
 {
-	return __find_workspace(type, false);
+	return __find_workspace(type_level, false);
 }
 
-/*
- * put a workspace struct back on the list or free it if we have enough
- * idle ones sitting around
- */
-static void __free_workspace(int type, struct list_head *workspace,
-			     bool heuristic)
+static struct list_head *find_decompression_workspace(unsigned int type)
 {
-	int idx = type - 1;
-	struct list_head *idle_ws;
-	spinlock_t *ws_lock;
-	atomic_t *total_ws;
-	wait_queue_head_t *ws_wait;
-	int *free_ws;
+	/*
+	 * Use the lowest level for decompression, since we don't need to
+	 * compress. This can help us save memory when using levels lower than
+	 * the default level.
+	 */
+	const unsigned int level = 1;
+	const unsigned int type_level = (level << 4) | (type & 0xF);
 
-	if (heuristic) {
-		idle_ws	 = &btrfs_heuristic_ws.idle_ws;
-		ws_lock	 = &btrfs_heuristic_ws.ws_lock;
-		total_ws = &btrfs_heuristic_ws.total_ws;
-		ws_wait	 = &btrfs_heuristic_ws.ws_wait;
-		free_ws	 = &btrfs_heuristic_ws.free_ws;
-	} else {
-		idle_ws	 = &btrfs_comp_ws[idx].idle_ws;
-		ws_lock	 = &btrfs_comp_ws[idx].ws_lock;
-		total_ws = &btrfs_comp_ws[idx].total_ws;
-		ws_wait	 = &btrfs_comp_ws[idx].ws_wait;
-		free_ws	 = &btrfs_comp_ws[idx].free_ws;
-	}
-
-	spin_lock(ws_lock);
-	if (*free_ws <= num_online_cpus()) {
-		list_add(workspace, idle_ws);
-		(*free_ws)++;
-		spin_unlock(ws_lock);
-		goto wake;
-	}
-	spin_unlock(ws_lock);
-
-	if (heuristic)
-		free_heuristic_ws(workspace);
-	else
-		btrfs_compress_op[idx]->free_workspace(workspace);
-	atomic_dec(total_ws);
-wake:
-	cond_wake_up(ws_wait);
-}
-
-static void free_workspace(int type, struct list_head *ws)
-{
-	return __free_workspace(type, ws, false);
+	return find_workspace(type_level);
 }
 
 /*
@@ -1044,9 +1075,7 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 	int ret;
 	int type = type_level & 0xF;
 
-	workspace = find_workspace(type);
-
-	btrfs_compress_op[type - 1]->set_level(workspace, type_level);
+	workspace = find_workspace(type_level);
 	ret = btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
 						      start, pages,
 						      out_pages,
@@ -1075,7 +1104,7 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
 	int ret;
 	int type = cb->compress_type;
 
-	workspace = find_workspace(type);
+	workspace = find_decompression_workspace(type);
 	ret = btrfs_compress_op[type - 1]->decompress_bio(workspace, cb);
 	free_workspace(type, workspace);
 
@@ -1093,7 +1122,7 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 	struct list_head *workspace;
 	int ret;
 
-	workspace = find_workspace(type);
+	workspace = find_decompression_workspace(type);
 
 	ret = btrfs_compress_op[type-1]->decompress(workspace, data_in,
 						  dest_page, start_byte,
@@ -1591,12 +1620,23 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 
 unsigned int btrfs_compress_str2level(const char *str)
 {
-	if (strncmp(str, "zlib", 4) != 0)
+	int ret;
+	int type;
+	unsigned int level;
+
+	if (strncmp(str, "zlib", 4) == 0)
+		type = BTRFS_COMPRESS_ZLIB;
+	else if (strncmp(str, "zstd", 4) == 0)
+		type = BTRFS_COMPRESS_ZSTD;
+	else
 		return 0;
 
-	/* Accepted form: zlib:1 up to zlib:9 and nothing left after the number */
-	if (str[4] == ':' && '1' <= str[5] && str[5] <= '9' && str[6] == 0)
-		return str[5] - '0';
+	if (str[4] == ':') {
+		ret = kstrtouint(str + 5, 10, &level);
+		if (ret == 0 && 0 < level &&
+		    level <= btrfs_compress_op[type-1]->max_level)
+			return level;
+	}
 
-	return BTRFS_ZLIB_DEFAULT_LEVEL;
+	return btrfs_compress_op[type-1]->default_level;
 }
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index ddda9b80bf20..a582a4483077 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -23,8 +23,6 @@
 /* Maximum size of data before compression */
 #define BTRFS_MAX_UNCOMPRESSED		(SZ_128K)
 
-#define	BTRFS_ZLIB_DEFAULT_LEVEL		3
-
 struct compressed_bio {
 	/* number of bios pending for this compressed extent */
 	refcount_t pending_bios;
@@ -87,7 +85,7 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags);
 
-unsigned btrfs_compress_str2level(const char *str);
+unsigned int btrfs_compress_str2level(const char *str);
 
 enum btrfs_compression_type {
 	BTRFS_COMPRESS_NONE  = 0,
@@ -98,7 +96,7 @@ enum btrfs_compression_type {
 };
 
 struct btrfs_compress_op {
-	struct list_head *(*alloc_workspace)(void);
+	struct list_head *(*alloc_workspace)(unsigned int level);
 
 	void (*free_workspace)(struct list_head *workspace);
 
@@ -119,7 +117,17 @@ struct btrfs_compress_op {
 			  unsigned long start_byte,
 			  size_t srclen, size_t destlen);
 
-	void (*set_level)(struct list_head *ws, unsigned int type);
+	/*
+	 * Check if memory allocated in workspace is greater than
+	 * or equal to memory needed to compress with given level.
+	 * If not, try to reallocate memory for the compression level.
+	 * Returns true on success.
+	 */
+	bool (*set_level)(struct list_head *ws, unsigned int level);
+
+	unsigned int max_level;
+
+	unsigned int default_level;
 };
 
 extern const struct btrfs_compress_op btrfs_zlib_compress;
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index b6a4cc178bee..ed9f0da8ceda 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -71,7 +71,7 @@ static void lzo_free_workspace(struct list_head *ws)
 	kfree(workspace);
 }
 
-static struct list_head *lzo_alloc_workspace(void)
+static struct list_head *lzo_alloc_workspace(unsigned int level)
 {
 	struct workspace *workspace;
 
@@ -485,8 +485,9 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
-static void lzo_set_level(struct list_head *ws, unsigned int type)
+static bool lzo_set_level(struct list_head *ws, unsigned int level)
 {
+	return true;
 }
 
 const struct btrfs_compress_op btrfs_lzo_compress = {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b362b45dd757..77ebd69371f1 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -520,7 +520,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				compress_type = "zlib";
 
 				info->compress_type = BTRFS_COMPRESS_ZLIB;
-				info->compress_level = BTRFS_ZLIB_DEFAULT_LEVEL;
+				info->compress_level =
+					btrfs_zlib_compress.default_level;
 				/*
 				 * args[0] contains uninitialized data since
 				 * for these tokens we don't expect any
@@ -542,9 +543,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
 				no_compress = 0;
-			} else if (strcmp(args[0].from, "zstd") == 0) {
+			} else if (strncmp(args[0].from, "zstd", 4) == 0) {
 				compress_type = "zstd";
 				info->compress_type = BTRFS_COMPRESS_ZSTD;
+				info->compress_level =
+					btrfs_compress_str2level(args[0].from);
 				btrfs_set_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 970ff3e35bb3..4c30a99b80f6 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -20,6 +20,9 @@
 #include <linux/refcount.h>
 #include "compression.h"
 
+#define BTRFS_ZLIB_DEFAULT_LEVEL 3
+#define BTRFS_ZLIB_MAX_LEVEL 9
+
 struct workspace {
 	z_stream strm;
 	char *buf;
@@ -36,7 +39,19 @@ static void zlib_free_workspace(struct list_head *ws)
 	kfree(workspace);
 }
 
-static struct list_head *zlib_alloc_workspace(void)
+static bool zlib_set_level(struct list_head *ws, unsigned int level)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+
+	if (level > BTRFS_ZLIB_MAX_LEVEL)
+		level = BTRFS_ZLIB_MAX_LEVEL;
+
+	workspace->level = level > 0 ? level : BTRFS_ZLIB_DEFAULT_LEVEL;
+
+	return true;
+}
+
+static struct list_head *zlib_alloc_workspace(unsigned int level)
 {
 	struct workspace *workspace;
 	int workspacesize;
@@ -53,6 +68,7 @@ static struct list_head *zlib_alloc_workspace(void)
 		goto fail;
 
 	INIT_LIST_HEAD(&workspace->list);
+	zlib_set_level(&workspace->list, level);
 
 	return &workspace->list;
 fail:
@@ -390,22 +406,13 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
-static void zlib_set_level(struct list_head *ws, unsigned int type)
-{
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
-	unsigned level = (type & 0xF0) >> 4;
-
-	if (level > 9)
-		level = 9;
-
-	workspace->level = level > 0 ? level : 3;
-}
-
 const struct btrfs_compress_op btrfs_zlib_compress = {
 	.alloc_workspace	= zlib_alloc_workspace,
 	.free_workspace		= zlib_free_workspace,
 	.compress_pages		= zlib_compress_pages,
 	.decompress_bio		= zlib_decompress_bio,
 	.decompress		= zlib_decompress,
-	.set_level              = zlib_set_level,
+	.set_level		= zlib_set_level,
+	.max_level		= BTRFS_ZLIB_MAX_LEVEL,
+	.default_level		= BTRFS_ZLIB_DEFAULT_LEVEL,
 };
diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index af6ec59972f5..e5d7c2eae65c 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -19,12 +19,13 @@
 
 #define ZSTD_BTRFS_MAX_WINDOWLOG 17
 #define ZSTD_BTRFS_MAX_INPUT (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
-#define ZSTD_BTRFS_DEFAULT_LEVEL 3
+#define BTRFS_ZSTD_DEFAULT_LEVEL 3
+#define BTRFS_ZSTD_MAX_LEVEL 15
 
-static ZSTD_parameters zstd_get_btrfs_parameters(size_t src_len)
+static ZSTD_parameters zstd_get_btrfs_parameters(size_t src_len,
+						 unsigned int level)
 {
-	ZSTD_parameters params = ZSTD_getParams(ZSTD_BTRFS_DEFAULT_LEVEL,
-						src_len, 0);
+	ZSTD_parameters params = ZSTD_getParams(level, src_len, 0);
 
 	if (params.cParams.windowLog > ZSTD_BTRFS_MAX_WINDOWLOG)
 		params.cParams.windowLog = ZSTD_BTRFS_MAX_WINDOWLOG;
@@ -37,10 +38,25 @@ struct workspace {
 	size_t size;
 	char *buf;
 	struct list_head list;
+	unsigned int level;
 	ZSTD_inBuffer in_buf;
 	ZSTD_outBuffer out_buf;
 };
 
+static bool zstd_reallocate_mem(struct workspace *workspace, int size)
+{
+	void *new_mem;
+
+	new_mem = kvmalloc(size, GFP_KERNEL);
+	if (new_mem) {
+		kvfree(workspace->mem);
+		workspace->mem = new_mem;
+		workspace->size = size;
+		return true;
+	}
+	return false;
+}
+
 static void zstd_free_workspace(struct list_head *ws)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
@@ -50,10 +66,34 @@ static void zstd_free_workspace(struct list_head *ws)
 	kfree(workspace);
 }
 
-static struct list_head *zstd_alloc_workspace(void)
+static bool zstd_set_level(struct list_head *ws, unsigned int level)
+{
+	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	ZSTD_parameters params;
+	int size;
+
+	if (level > BTRFS_ZSTD_MAX_LEVEL)
+		level = BTRFS_ZSTD_MAX_LEVEL;
+
+	if (level == 0)
+		level = BTRFS_ZSTD_DEFAULT_LEVEL;
+
+	params = ZSTD_getParams(level, ZSTD_BTRFS_MAX_INPUT, 0);
+	size = max_t(size_t,
+			ZSTD_CStreamWorkspaceBound(params.cParams),
+			ZSTD_DStreamWorkspaceBound(ZSTD_BTRFS_MAX_INPUT));
+	if (size > workspace->size) {
+		if (!zstd_reallocate_mem(workspace, size))
+			return false;
+	}
+	workspace->level = level;
+	return true;
+}
+
+static struct list_head *zstd_alloc_workspace(unsigned int level)
 {
 	ZSTD_parameters params =
-			zstd_get_btrfs_parameters(ZSTD_BTRFS_MAX_INPUT);
+			zstd_get_btrfs_parameters(ZSTD_BTRFS_MAX_INPUT, level);
 	struct workspace *workspace;
 
 	workspace = kzalloc(sizeof(*workspace), GFP_KERNEL);
@@ -69,6 +109,7 @@ static struct list_head *zstd_alloc_workspace(void)
 		goto fail;
 
 	INIT_LIST_HEAD(&workspace->list);
+	zstd_set_level(&workspace->list, level);
 
 	return &workspace->list;
 fail:
@@ -95,7 +136,8 @@ static int zstd_compress_pages(struct list_head *ws,
 	unsigned long len = *total_out;
 	const unsigned long nr_dest_pages = *out_pages;
 	unsigned long max_out = nr_dest_pages * PAGE_SIZE;
-	ZSTD_parameters params = zstd_get_btrfs_parameters(len);
+	ZSTD_parameters params = zstd_get_btrfs_parameters(len,
+							   workspace->level);
 
 	*out_pages = 0;
 	*total_out = 0;
@@ -419,15 +461,13 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
-static void zstd_set_level(struct list_head *ws, unsigned int type)
-{
-}
-
 const struct btrfs_compress_op btrfs_zstd_compress = {
-	.alloc_workspace = zstd_alloc_workspace,
-	.free_workspace = zstd_free_workspace,
-	.compress_pages = zstd_compress_pages,
-	.decompress_bio = zstd_decompress_bio,
-	.decompress = zstd_decompress,
-	.set_level = zstd_set_level,
+	.alloc_workspace	= zstd_alloc_workspace,
+	.free_workspace		= zstd_free_workspace,
+	.compress_pages		= zstd_compress_pages,
+	.decompress_bio		= zstd_decompress_bio,
+	.decompress		= zstd_decompress,
+	.set_level		= zstd_set_level,
+	.max_level		= BTRFS_ZSTD_MAX_LEVEL,
+	.default_level		= BTRFS_ZSTD_DEFAULT_LEVEL,
 };
-- 
2.17.1

