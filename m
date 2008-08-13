From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/3] NFS support for btrfs - v2
Date: Wed, 13 Aug 2008 09:53:17 +0100
Message-ID: <1218617597.2977.230.camel@pmac.infradead.org>
References: <200806290505.31641.balajirrao@gmail.com>
	 <1218548806.2977.179.camel@pmac.infradead.org>
	 <20080812185141.GB29426@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080812185141.GB29426@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-08-12 at 14:51 -0400, Christoph Hellwig wrote:
> On Tue, Aug 12, 2008 at 02:46:46PM +0100, David Woodhouse wrote:
> > +static inline struct dentry *d_obtain_alias(struct inode *inode)
> > +{
> > +	struct dentry *d = d_alloc_anon(inode);
> > +	if (!d)
> > +		iput(inode);
> > +	return d;
> > +}
> > +#endif
> 
> I'm not sure when al wants to merge with Linus, but the for-next naming
> makes it sound like the tree is the .28 queue.  Also please take the
> full implementation of d_obtain_alias from
> 
> 	http://git.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=commitdiff;h=10cdb734be3c4175b977ba18eafbaba8e5716291
> 
> please.  Your light implementation will crash and burn when btrfs_iget
> returns an error.

Well spotted; thanks.

> > +/* The size of encoded fh is the type number of the fh itself */
> > +#define BTRFS_FID_NON_CONNECTABLE		5
> > +#define BTRFS_FID_CONNECTABLE	 		8
> 
> That was an assumption in the very old code, but I think it's a very
> bad idea.  Just give your filehandles a uniqueue type number, e.g. in
> the 0x4? range so that people looking at nfs traffic using a packet
> analyzer know what kind of fhs they are actually dealing with.

Ok, I'll submit the patch to include/linux/exportfs.h separately -- the
numbers might as well be reserved immediately.

Btw, I'm not convinced nfsd does the right thing when we return 255 from
->encode_fh(). It seems to leak a refcount somewhere in nfs code, so I
can't stop the server and can't unmount the file system.

> > +	if (IS_ERR(inode))
> > +		return (void *)inode;
> > +
> > +	if (generation != inode->i_generation) {
> > +		iput(inode);
> > +		return ERR_PTR(-ESTALE);
> > +	}
> > +
> > +	result = d_alloc_anon(inode);
> > +	if (!result) {
> > +		iput(inode);
> > +		return ERR_PTR(-ENOMEM);
> > +	}
> 
> Didn't you intend to use d_obtain_alias?

Oops, yes. I did use it once; I missed the second one though.

I'll merge this into the patch in question...

diff --git a/compat.h b/compat.h
index 1040f07..d45fb37 100644
--- a/compat.h
+++ b/compat.h
@@ -8,7 +8,14 @@
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,27)
 static inline struct dentry *d_obtain_alias(struct inode *inode)
 {
-	struct dentry *d = d_alloc_anon(inode);
+	struct dentry *d;
+
+	if (!inode)
+		return NULL;
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
+	d = d_alloc_anon(inode);
 	if (!d)
 		iput(inode);
 	return d;
diff --git a/export.c b/export.c
index 253080a..34e4631 100644
--- a/export.c
+++ b/export.c
@@ -7,9 +7,13 @@
 #include "export.h"
 #include "compat.h"
 
-/* The size of encoded fh is the type number of the fh itself */
-#define BTRFS_FID_NON_CONNECTABLE		5
-#define BTRFS_FID_CONNECTABLE	 		8
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
+#define FILEID_BTRFS_WITHOUT_PARENT		0x4e
+#define FILEID_BTRFS_WITH_PARENT 		0x4f
+#endif
+
+#define BTRFS_FID_SIZE_NON_CONNECTABLE		(offsetof(struct btrfs_fid, parent_objectid)/4)
+#define BTRFS_FID_SIZE_CONNECTABLE		(sizeof(struct btrfs_fid)/4)
 
 static int btrfs_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
 			   int connectable)
@@ -17,12 +21,14 @@ static int btrfs_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
 	struct btrfs_fid *fid = (struct btrfs_fid *)fh;
 	struct inode *inode = dentry->d_inode;
 	int len = *max_len;
+	int type;
 
-	if ((len < BTRFS_FID_NON_CONNECTABLE) ||
-	    (connectable && len < BTRFS_FID_CONNECTABLE))
+	if ((len < BTRFS_FID_SIZE_NON_CONNECTABLE) ||
+	    (connectable && len < BTRFS_FID_SIZE_CONNECTABLE))
 		return 255;
 
-	len  = BTRFS_FID_NON_CONNECTABLE;
+	len  = BTRFS_FID_SIZE_NON_CONNECTABLE;
+	type = FILEID_BTRFS_WITHOUT_PARENT;
 
 	fid->objectid = BTRFS_I(inode)->location.objectid;
 	fid->root_objectid = BTRFS_I(inode)->root->objectid;
@@ -38,13 +44,12 @@ static int btrfs_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
 		fid->parent_gen = parent->i_generation;
 
 		spin_unlock(&dentry->d_lock);
-		len = BTRFS_FID_CONNECTABLE;
+		len = BTRFS_FID_SIZE_CONNECTABLE;
+		type = FILEID_BTRFS_WITH_PARENT;
 	}
-	*max_len = len;
-
-	/* We return length itself for the type */
-	return len;
 
+	*max_len = len;
+	return type;
 }
 
 static struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
@@ -69,11 +74,9 @@ static struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
 		return ERR_PTR(-ESTALE);
 	}
 
-	result = d_alloc_anon(inode);
-	if (!result) {
-		iput(inode);
+	result = d_obtain_alias(inode);
+	if (!result)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	return result;
 }
@@ -85,7 +88,8 @@ static struct dentry *btrfs_fh_to_parent(struct super_block *sb, struct fid *fh,
 	u64 objectid, root_objectid;
 	u32 generation;
 
-	if (fh_type != BTRFS_FID_CONNECTABLE)
+	if (fh_type != FILEID_BTRFS_WITH_PARENT ||
+	    fh_len != BTRFS_FID_SIZE_CONNECTABLE)
 		return NULL;
 
 	root_objectid = fid->root_objectid;
@@ -102,7 +106,10 @@ static struct dentry *btrfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
 	u64 objectid, root_objectid;
 	u32 generation;
 
-	if (fh_type > BTRFS_FID_CONNECTABLE)
+	if ((fh_type != FILEID_BTRFS_WITH_PARENT ||
+	     fh_len != BTRFS_FID_SIZE_CONNECTABLE) &&
+	    (fh_type != FILEID_BTRFS_WITHOUT_PARENT ||
+	     fh_len != BTRFS_FID_SIZE_NON_CONNECTABLE))
 		return NULL;
 
 	objectid = fid->objectid;

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



