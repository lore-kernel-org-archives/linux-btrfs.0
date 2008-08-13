From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 1/3] Introduce btrfs_iget helper
Date: Wed, 13 Aug 2008 10:41:30 +0100
Message-ID: <1218620490.2977.246.camel@pmac.infradead.org>
References: <200806290505.31641.balajirrao@gmail.com>
	 <1218548800.2977.178.camel@pmac.infradead.org>
	 <20080812184654.GA29426@infradead.org>
	 <1218618434.2977.237.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218618434.2977.237.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-08-13 at 10:07 +0100, David Woodhouse wrote:
>                 /* the inode and parent dir are two different roots */
>                 if (new && root != sub_root) {
>                         igrab(inode);
>                         sub_root->inode = inode;
>                         do_orphan = 1;
>                 }

Hmmmm.... looking at that, don't we need to store the _parent_ root
object ID in the file handle too, if it can be different from the child?

Something like this, perhaps. Given that I think we've already given up
on exporting by NFSv2, do we care about another 8 bytes in the fh size?

diff --git a/export.c b/export.c
index 34e4631..1b8875c 100644
--- a/export.c
+++ b/export.c
@@ -8,12 +8,14 @@
 #include "compat.h"
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
-#define FILEID_BTRFS_WITHOUT_PARENT		0x4e
-#define FILEID_BTRFS_WITH_PARENT 		0x4f
+#define FILEID_BTRFS_WITHOUT_PARENT		0x4d
+#define FILEID_BTRFS_WITH_PARENT 		0x4e
+#define FILEID_BTRFS_WITH_PARENT_ROOT 		0x4f
 #endif
 
 #define BTRFS_FID_SIZE_NON_CONNECTABLE		(offsetof(struct btrfs_fid, parent_objectid)/4)
-#define BTRFS_FID_SIZE_CONNECTABLE		(sizeof(struct btrfs_fid)/4)
+#define BTRFS_FID_SIZE_CONNECTABLE		(offsetof(struct btrfs_fid, parent_root_objectid)/4)
+#define BTRFS_FID_SIZE_CONNECTABLE_ROOT		(sizeof(struct btrfs_fid)/4)
 
 static int btrfs_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
 			   int connectable)
@@ -36,16 +38,25 @@ static int btrfs_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
 
 	if (connectable && !S_ISDIR(inode->i_mode)) {
 		struct inode *parent;
+		u64 parent_root_id;
 
 		spin_lock(&dentry->d_lock);
 
 		parent = dentry->d_parent->d_inode;
 		fid->parent_objectid = BTRFS_I(parent)->location.objectid;
 		fid->parent_gen = parent->i_generation;
+		parent_root_id = BTRFS_I(parent)->root->objectid;
 
 		spin_unlock(&dentry->d_lock);
-		len = BTRFS_FID_SIZE_CONNECTABLE;
-		type = FILEID_BTRFS_WITH_PARENT;
+
+		if (parent_root_id != fid->root_objectid) {
+			fid->parent_root_objectid = parent_root_id;
+			len = BTRFS_FID_SIZE_CONNECTABLE_ROOT;
+			type = FILEID_BTRFS_WITH_PARENT_ROOT;
+		} else {
+			len = BTRFS_FID_SIZE_CONNECTABLE; 
+			type = FILEID_BTRFS_WITH_PARENT;
+		}
 	}
 
 	*max_len = len;
@@ -88,11 +99,17 @@ static struct dentry *btrfs_fh_to_parent(struct super_block *sb, struct fid *fh,
 	u64 objectid, root_objectid;
 	u32 generation;
 
-	if (fh_type != FILEID_BTRFS_WITH_PARENT ||
-	    fh_len != BTRFS_FID_SIZE_CONNECTABLE)
+	if (fh_type == FILEID_BTRFS_WITH_PARENT) {
+		if (fh_len !=  BTRFS_FID_SIZE_CONNECTABLE)
+			return NULL;
+		root_objectid = fid->root_objectid;
+	} else if (fh_type == FILEID_BTRFS_WITH_PARENT_ROOT) {
+		if (fh_len != BTRFS_FID_SIZE_CONNECTABLE_ROOT)
+			return NULL;
+		root_objectid = fid->parent_root_objectid;
+	} else
 		return NULL;
 
-	root_objectid = fid->root_objectid;
 	objectid = fid->parent_objectid;
 	generation = fid->parent_gen;
 
@@ -108,6 +125,8 @@ static struct dentry *btrfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
 
 	if ((fh_type != FILEID_BTRFS_WITH_PARENT ||
 	     fh_len != BTRFS_FID_SIZE_CONNECTABLE) &&
+	    (fh_type != FILEID_BTRFS_WITH_PARENT_ROOT ||
+	     fh_len != BTRFS_FID_SIZE_CONNECTABLE_ROOT) &&
 	    (fh_type != FILEID_BTRFS_WITHOUT_PARENT ||
 	     fh_len != BTRFS_FID_SIZE_NON_CONNECTABLE))
 		return NULL;
diff --git a/export.h b/export.h
index 019ca3a..074348a 100644
--- a/export.h
+++ b/export.h
@@ -12,6 +12,8 @@ struct btrfs_fid {
 
 	u64 parent_objectid;
 	u32 parent_gen;
+
+	u64 parent_root_objectid;
 } __attribute__ ((packed));
 
 #endif


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



