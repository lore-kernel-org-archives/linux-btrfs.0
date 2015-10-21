Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36928 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbJUA7f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 20:59:35 -0400
Received: by wicfv8 with SMTP id fv8so52715369wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 17:59:33 -0700 (PDT)
Received: from [192.168.1.30] (nat-minsk-pool-46-53-200-210.telecom.by. [46.53.200.210])
        by smtp.gmail.com with ESMTPSA id q1sm6885522wje.39.2015.10.20.17.59.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Oct 2015 17:59:32 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [RFC PATCH V2] btrfs/ioctl.c: extent_same - Use inode as src which,
 close to disk beginning
Message-ID: <5626E373.8050906@gmail.com>
Date: Wed, 21 Oct 2015 03:59:31 +0300
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030002080404090006030405"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030002080404090006030405
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

It's just a proof of concept, and i hope to see feedback, ideas about it.
---
While deduplication,
Btrfs produce extent and file fragmentation
But it's can be optimized by compute - which inode data placed a closest 
to beginning of hdd
It's allow to reach:
1. Permonace boost on hdd (beginning of disk faster then end)
2. it's allow to make sparse only tail of fs, what can give boost later in
balancing and resizing of fs

New function:
static u64 btrfs_avg_disko(struct inode *inode,
                         const u64 off, const u64 olen_aligned);

It normalize offsets with data lenghts, by represent it like offsets of 
blocks
It return average data offset of all "pagesized" blocks in given range 
for inode
Function cloned from btrfs_clone()

Changes from V1:
         Added new function which compute "normal" offset

---
  fs/btrfs/ioctl.c | 147 
++++++++++++++++++++++++++++++++++++++++++++++++++++++-
  1 file changed, 145 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3e3e613..a14b4e7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -86,6 +86,9 @@ struct btrfs_ioctl_received_subvol_args_32 {
  #endif


+static u64 btrfs_avg_disko(struct inode *inode,
+                    const u64 off, const u64 olen_aligned);
+
  static int btrfs_clone(struct inode *src, struct inode *inode,
                 u64 off, u64 olen, u64 olen_aligned, u64 destoff,
                 int no_time_update);
@@ -3074,8 +3077,20 @@ static int btrfs_extent_same(struct inode *src, 
u64 loff, u64 olen,

      /* pass original length for comparison so we stay within i_size */
      ret = btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
-    if (ret == 0)
-        ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
+    if (ret == 0) {
+        /* prefer inode with lowest offset as source for clone*/
+        u64 src_weight;
+        u64 dst_weight;
+        src_weight = btrfs_avg_disko(src, off, olen);
+        dst_weight = btrfs_avg_disko(dest, dst_loff, olen);
+        /* if one of weight == 0 -> fallback */
+        if (dest_weight == 0)
+            src_weight = 0;
+        if (src_weight > dest_weight)
+            ret = btrfs_clone(dst, src, dst_loff, olen, len, loff, 1);
+        else
+            ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
+    }

      if (same_inode)
          unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
@@ -3329,6 +3344,134 @@ static void clone_update_extent_map(struct inode 
*inode,
  }

  /**
+ * btrfs_avg_disko() - return avg data offset weight for inode
+ *
+ * @inode: Inode
+ * @off: Offset for computing
+ * @olen_aligned: Block-aligned len of data
+ *
+ * Computing avg address place of data, allow to heuristically
+ * determine where on the disk placed most fragment of data
+ */
+static u64 btrfs_avg_disko(struct inode *inode,
+                    const u64 off, const u64 olen_aligned)
+{
+    struct btrfs_root *root = BTRFS_I(inode)->root;
+    struct btrfs_path *path = NULL;
+    struct extent_buffer *leaf;
+    char *buf = NULL;
+    struct btrfs_key key;
+    u32 nritems;
+    int slot;
+    int no_quota;
+    double sum = 0;
+    u64 ret = 0;
+    u64 counter = 0;
+
+    buf = vmalloc(root->nodesize);
+    if (!buf)
+        return ret;
+
+    path = btrfs_alloc_path();
+    if (!path) {
+        vfree(buf);
+        return ret;
+    }
+
+    path->reada = 2;
+    /* clone data */
+    key.objectid = btrfs_ino(inode);
+    key.type = BTRFS_EXTENT_DATA_KEY;
+    key.offset = off;
+
+    while (1) {
+        u64 next_key_min_offset = key.offset + 1;
+
+        /*
+         * note the key will change type as we walk through the
+         * tree.
+         */
+        path->leave_spinning = 1;
+        ret = btrfs_search_slot(NULL, BTRFS_I(inode)->root, &key, 
path,    0, 0);
+        if (ret < 0)
+            goto out;
+        /*
+         * First search, if no extent item that starts at offset off was
+         * found but the previous item is an extent item, it's possible
+         * it might overlap our target range, therefore process it.
+         */
+        if (key.offset == off && ret > 0 && path->slots[0] > 0) {
+            btrfs_item_key_to_cpu(path->nodes[0], &key,
+                          path->slots[0] - 1);
+            if (key.type == BTRFS_EXTENT_DATA_KEY)
+                path->slots[0]--;
+        }
+
+        nritems = btrfs_header_nritems(path->nodes[0]);
+process_slot:
+        no_quota = 1;
+        if (path->slots[0] >= nritems) {
+            ret = btrfs_next_leaf(BTRFS_I(inode)->root, path);
+            if (ret < 0)
+                goto out;
+            if (ret > 0)
+                break;
+            nritems = btrfs_header_nritems(path->nodes[0]);
+        }
+        leaf = path->nodes[0];
+        slot = path->slots[0];
+
+        btrfs_item_key_to_cpu(leaf, &key, slot);
+        if (key.type > BTRFS_EXTENT_DATA_KEY ||
+            key.objectid != btrfs_ino(inode))
+            break;
+
+        if (key.type == BTRFS_EXTENT_DATA_KEY) {
+            struct btrfs_file_extent_item *extent;
+            int type;
+            u64 disko = 0;
+            u64 diskl = 0;
+            u64 datal = 0;
+
+            extent = btrfs_item_ptr(leaf, slot,    struct 
btrfs_file_extent_item);
+            type = btrfs_file_extent_type(leaf, extent);
+            if (type == BTRFS_FILE_EXTENT_REG ||
+                type == BTRFS_FILE_EXTENT_PREALLOC) {
+                disko = btrfs_file_extent_disk_bytenr(leaf, extent);
+                diskl = btrfs_file_extent_disk_num_bytes(leaf, extent);
+                datal = btrfs_file_extent_num_bytes(leaf, extent);
+            }
+
+            /*
+             * The first search might have left us at an extent
+             * item that ends before our target range's start, can
+             * happen if we have holes and NO_HOLES feature enabled.
+             */
+            if (key.offset + datal <= off) {
+                path->slots[0]++;
+                goto process_slot;
+            } else if (key.offset >= off + olen_aligned) {
+                break;
+            }
+            next_key_min_offset = key.offset + datal;
+
+            for (;diskl >= 0; diskl -= pagesize) {
+                sum += disko+diskl;
+                counter++;
+            }
+
+            btrfs_release_path(path);
+            path->leave_spinning = 0;
+    }
+
+out:
+    ret = sum/counter;
+    btrfs_free_path(path);
+    vfree(buf);
+    return ret;
+}
+
+/**
   * btrfs_clone() - clone a range from inode file to another
   *
   * @src: Inode to clone from
-- 
2.6.1



--------------030002080404090006030405
Content-Type: text/x-patch;
 name="0001-btrfs-ioctl.c-extent_same-Use-inode-as-src-which-clo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-btrfs-ioctl.c-extent_same-Use-inode-as-src-which-clo.pa";
 filename*1="tch"

>From 8719129c0fb4d5325f9f87ee34f591d301933f67 Mon Sep 17 00:00:00 2001
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 21 Oct 2015 03:31:57 +0300
Subject: [RFC PATCH V2] btrfs/ioctl.c: extent_same - Use inode as src which
 close to disk beginning

While deduplication,
Btrfs produce extent and file fragmentation
But it's can be optimized by compute - which inode data placed a closest to beginning of hdd
It's allow to reach:
1. Permonace boost on hdd (beginning of disk faster then end)
2. it's allow to make sparse only tail of fs, what can give boost later in
balancing and resizing of fs

New function:
static u64 btrfs_avg_disko(struct inode *inode,
                        const u64 off, const u64 olen_aligned);

It normalize offsets with data lenghts, by represent it like offsets of blocks
It return average data offset of all "pagesized" blocks in given range for inode
---
 fs/btrfs/ioctl.c | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 145 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3e3e613..a14b4e7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -86,6 +86,9 @@ struct btrfs_ioctl_received_subvol_args_32 {
 #endif
 
 
+static u64 btrfs_avg_disko(struct inode *inode,
+					const u64 off, const u64 olen_aligned);
+
 static int btrfs_clone(struct inode *src, struct inode *inode,
 		       u64 off, u64 olen, u64 olen_aligned, u64 destoff,
 		       int no_time_update);
@@ -3074,8 +3077,20 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 
 	/* pass original length for comparison so we stay within i_size */
 	ret = btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
-	if (ret == 0)
-		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
+	if (ret == 0) {
+		/* prefer inode with lowest offset as source for clone*/
+		u64 src_weight;
+		u64 dst_weight;
+		src_weight = btrfs_avg_disko(src, off, olen);
+		dst_weight = btrfs_avg_disko(dest, dst_loff, olen);
+		/* if one of weight == 0 -> fallback */
+		if (dest_weight == 0)
+			src_weight = 0;
+		if (src_weight > dest_weight)
+			ret = btrfs_clone(dst, src, dst_loff, olen, len, loff, 1);
+		else
+			ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
+	}
 
 	if (same_inode)
 		unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
@@ -3329,6 +3344,134 @@ static void clone_update_extent_map(struct inode *inode,
 }
 
 /**
+ * btrfs_avg_disko() - return avg data offset weight for inode
+ *
+ * @inode: Inode
+ * @off: Offset for computing
+ * @olen_aligned: Block-aligned len of data
+ *
+ * Computing avg address place of data, allow to heuristically
+ * determine where on the disk placed most fragment of data
+ */
+static u64 btrfs_avg_disko(struct inode *inode,
+					const u64 off, const u64 olen_aligned)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_path *path = NULL;
+	struct extent_buffer *leaf;
+	char *buf = NULL;
+	struct btrfs_key key;
+	u32 nritems;
+	int slot;
+	int no_quota;
+	double sum = 0;
+	u64 ret = 0;
+	u64 counter = 0;
+
+	buf = vmalloc(root->nodesize);
+	if (!buf)
+		return ret;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		vfree(buf);
+		return ret;
+	}
+
+	path->reada = 2;
+	/* clone data */
+	key.objectid = btrfs_ino(inode);
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = off;
+
+	while (1) {
+		u64 next_key_min_offset = key.offset + 1;
+
+		/*
+		 * note the key will change type as we walk through the
+		 * tree.
+		 */
+		path->leave_spinning = 1;
+		ret = btrfs_search_slot(NULL, BTRFS_I(inode)->root, &key, path,	0, 0);
+		if (ret < 0)
+			goto out;
+		/*
+		 * First search, if no extent item that starts at offset off was
+		 * found but the previous item is an extent item, it's possible
+		 * it might overlap our target range, therefore process it.
+		 */
+		if (key.offset == off && ret > 0 && path->slots[0] > 0) {
+			btrfs_item_key_to_cpu(path->nodes[0], &key,
+					      path->slots[0] - 1);
+			if (key.type == BTRFS_EXTENT_DATA_KEY)
+				path->slots[0]--;
+		}
+
+		nritems = btrfs_header_nritems(path->nodes[0]);
+process_slot:
+		no_quota = 1;
+		if (path->slots[0] >= nritems) {
+			ret = btrfs_next_leaf(BTRFS_I(inode)->root, path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0)
+				break;
+			nritems = btrfs_header_nritems(path->nodes[0]);
+		}
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		if (key.type > BTRFS_EXTENT_DATA_KEY ||
+		    key.objectid != btrfs_ino(inode))
+			break;
+
+		if (key.type == BTRFS_EXTENT_DATA_KEY) {
+			struct btrfs_file_extent_item *extent;
+			int type;
+			u64 disko = 0;
+			u64 diskl = 0;
+			u64 datal = 0;
+
+			extent = btrfs_item_ptr(leaf, slot,	struct btrfs_file_extent_item);
+			type = btrfs_file_extent_type(leaf, extent);
+			if (type == BTRFS_FILE_EXTENT_REG ||
+			    type == BTRFS_FILE_EXTENT_PREALLOC) {
+				disko = btrfs_file_extent_disk_bytenr(leaf, extent);
+				diskl = btrfs_file_extent_disk_num_bytes(leaf, extent);
+				datal = btrfs_file_extent_num_bytes(leaf, extent);
+			}
+
+			/*
+			 * The first search might have left us at an extent
+			 * item that ends before our target range's start, can
+			 * happen if we have holes and NO_HOLES feature enabled.
+			 */
+			if (key.offset + datal <= off) {
+				path->slots[0]++;
+				goto process_slot;
+			} else if (key.offset >= off + olen_aligned) {
+				break;
+			}
+			next_key_min_offset = key.offset + datal;
+
+			for (;diskl >= 0; diskl -= pagesize) {
+				sum += disko+diskl;
+				counter++;
+			}
+
+			btrfs_release_path(path);
+			path->leave_spinning = 0;
+	}
+
+out:
+	ret = sum/counter;
+	btrfs_free_path(path);
+	vfree(buf);
+	return ret;
+}
+
+/**
  * btrfs_clone() - clone a range from inode file to another
  *
  * @src: Inode to clone from
-- 
2.6.1


--------------030002080404090006030405--
