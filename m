Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:56864 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966053AbdIYUSe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 16:18:34 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/2] Use the new ioctl BTRFS_IOC_GET_CHUNK_INFO for load_chunk_info()
Date: Mon, 25 Sep 2017 22:18:15 +0200
Message-Id: <20170925201815.10161-3-kreijack@libero.it>
In-Reply-To: <20170925201815.10161-1-kreijack@libero.it>
References: <20170925201815.10161-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Use the new ioctl BTRFS_IOC_GET_CHUNK_INFO in load_chunk_info() instead of the
BTRFS_IOC_TREE_SEARCH. The old method is still present as fallback for
compatibility reason.

The goal is to avoid BTRFS_IOC_GET_CHUNK_INFO because it requires root
privileges.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-fi-usage.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 ioctl.h         |  60 +++++++++++++++++++++++++++++++
 2 files changed, 165 insertions(+), 3 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 6c846c15..6a101e28 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -36,7 +36,7 @@
 /*
  * Add the chunk info to the chunk_info list
  */
-static int add_info_to_list(struct chunk_info **info_ptr,
+static int legacy_add_info_to_list(struct chunk_info **info_ptr,
 			int *info_count,
 			struct btrfs_chunk *chunk)
 {
@@ -127,7 +127,8 @@ static int cmp_chunk_info(const void *a, const void *b)
 		((struct chunk_info *)b)->type);
 }
 
-static int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count)
+static int legacy_load_chunk_info(int fd, struct chunk_info **info_ptr,
+					int *info_count)
 {
 	int ret;
 	struct btrfs_ioctl_search_args args;
@@ -180,7 +181,7 @@ static int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count
 			off += sizeof(*sh);
 			item = (struct btrfs_chunk *)(args.buf + off);
 
-			ret = add_info_to_list(info_ptr, info_count, item);
+			ret = legacy_add_info_to_list(info_ptr, info_count, item);
 			if (ret) {
 				*info_ptr = NULL;
 				return 1;
@@ -213,6 +214,107 @@ static int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count
 	return 0;
 }
 
+/*
+ * Add the chunk info to the chunk_info list
+ */
+static int add_info_to_list(struct chunk_info **info_ptr,
+			int *info_count,
+			struct btrfs_chunk_info *chunk)
+{
+
+	u64 type = chunk->type;
+	u64 size = chunk->length;
+	int num_stripes = chunk->num_stripes;
+	int j;
+
+	for (j = 0 ; j < num_stripes ; j++) {
+		int i;
+		struct chunk_info *p = NULL;
+		u64    devid;
+
+		devid = chunk->stripes[j].devid;
+
+		for (i = 0 ; i < *info_count ; i++)
+			if ((*info_ptr)[i].type == type &&
+			    (*info_ptr)[i].devid == devid &&
+			    (*info_ptr)[i].num_stripes == num_stripes) {
+				p = (*info_ptr) + i;
+				break;
+			}
+
+		if (!p) {
+			int tmp = sizeof(struct btrfs_chunk) *
+						(*info_count + 1);
+			struct chunk_info *res = realloc(*info_ptr, tmp);
+
+			if (!res) {
+				free(*info_ptr);
+				error("not enough memory");
+				return -ENOMEM;
+			}
+
+			*info_ptr = res;
+			p = res + *info_count;
+			(*info_count)++;
+
+			p->devid = devid;
+			p->type = type;
+			p->size = 0;
+			p->num_stripes = num_stripes;
+		}
+
+		p->size += size;
+
+	}
+
+	return 0;
+
+}
+
+static int load_chunk_info(int fd, struct chunk_info **info_ptr,
+				int *info_count)
+{
+
+	char buf[4096];
+	struct btrfs_ioctl_chunk_info *bici =
+		(struct btrfs_ioctl_chunk_info *)buf;
+	int cont;
+
+	bici->buf_size = sizeof(buf);
+	bici->offset = (u64)0;
+
+	do {
+		int i;
+		struct btrfs_chunk_info *ci;
+		int ret;
+
+		cont = false;
+		ret = ioctl(fd, BTRFS_IOC_GET_CHUNK_INFO, bici);
+		if (ret < 0) {
+			int e = errno;
+
+			if (e == ENOTTY)
+				return legacy_load_chunk_info(fd, info_ptr,
+								info_count);
+			else if (e == EAGAIN)
+				cont = true;
+			else
+				return -e;
+		}
+
+		ci = btrfs_first_chunk_info(bici);
+		for (i = 0 ; i < bici->items_count ; i++) {
+			add_info_to_list(info_ptr, info_count, ci);
+			ci = btrfs_next_chunk_info(ci);
+		}
+
+	} while (cont);
+
+	qsort(*info_ptr, *info_count, sizeof(struct chunk_info),
+		cmp_chunk_info);
+
+	return 0;
+}
 /*
  * Helper to sort the struct btrfs_ioctl_space_info
  */
diff --git a/ioctl.h b/ioctl.h
index 709e996f..11a2c239 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -672,6 +672,64 @@ BUILD_ASSERT(sizeof(struct btrfs_ioctl_send_args_64) == 72);
 
 #define BTRFS_IOC_SEND_64_COMPAT_DEFINED 1
 
+struct btrfs_chunk_info_stripe {
+	__u64 devid;
+	__u64 offset;
+	__u8 dev_uuid[BTRFS_UUID_SIZE];
+};
+
+struct btrfs_chunk_info {
+	/* logical start of this chunk */
+	__u64 offset;
+	/* size of this chunk in bytes */
+	__u64 length;
+
+	__u64 stripe_len;
+	__u64 type;
+
+	/* 2^16 stripes is quite a lot, a second limit is the size of a single
+	 * item in the btree
+	 */
+	__u16 num_stripes;
+
+	/* sub stripes only matter for raid10 */
+	__u16 sub_stripes;
+
+	struct btrfs_chunk_info_stripe stripes[1];
+	/* additional stripes go here */
+};
+
+struct btrfs_ioctl_chunk_info {
+	/* offset to start the search; after the ioctl, this field contains
+	 * the next offset to start a search
+	 */
+	u64			offset;		/* in/out */
+	/* size of the passed buffer, including btrfs_ioctl_chunk_info */
+	u32			buf_size;	/* in     */
+	/*  number of items returned */
+	u32			items_count;	/* out    */
+};
+
+static inline struct btrfs_chunk_info *
+btrfs_first_chunk_info(struct btrfs_ioctl_chunk_info *bici)
+{
+	return (struct btrfs_chunk_info *)((char *)bici +
+		sizeof(struct btrfs_ioctl_chunk_info));
+}
+
+static inline int btrfs_chunk_info_size(struct btrfs_chunk_info *ci)
+{
+	return sizeof(struct btrfs_chunk_info) +
+		sizeof(struct btrfs_chunk_info_stripe) * (ci->num_stripes-1);
+}
+
+static inline struct btrfs_chunk_info *
+btrfs_next_chunk_info(struct btrfs_chunk_info *ci)
+{
+	return (struct btrfs_chunk_info *)((char *)ci +
+		btrfs_chunk_info_size(ci));
+}
+
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
 	notused,
@@ -828,6 +886,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
                                   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_GET_CHUNK_INFO _IOR(BTRFS_IOCTL_MAGIC, 59, \
+				   struct btrfs_ioctl_chunk_info)
 #ifdef __cplusplus
 }
 #endif
-- 
2.14.1

