Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732412AbeHABEI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 21:04:08 -0400
Date: Tue, 31 Jul 2018 23:21:27 +0000
From: Mark Fasheh <mfasheh@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 1/4] vfs: introduce function to map unique ino/dev pairs
Message-ID: <20180731232127.GB20761@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20180731211045.5671-1-mfasheh@suse.de>
 <20180731211045.5671-2-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180731211045.5671-2-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Tue, Jul 31, 2018 at 02:10:42PM -0700, Mark Fasheh wrote:
> diff --git a/fs/stat.c b/fs/stat.c
> index f8e6fb2c3657..80ea42505219 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -84,6 +84,29 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
>  }
>  EXPORT_SYMBOL(vfs_getattr_nosec);
>  
> +void vfs_map_unique_ino_dev(struct dentry *dentry, u64 *ino, dev_t *dev)
> +{
> +	int ret;
> +	struct path path;
> +	struct kstat stat;
> +
> +	path.mnt = NULL;
> +	path.dentry = dentry;
> +	/* ->dev is always returned, so we only need to specify ino here */
> +	ret = vfs_getattr_nosec(&path, &stat, STATX_INO, 0);
> +	if (ret) {
> +		struct inode *inode = d_inode(dentry);
> +		/* Fallback to old behavior in case of getattr error */
> +		*ino = inode->i_ino;
> +		*dev = inode->i_sb->s_dev;
> +		return ret;

Ooof, attached is a version of this patch which doesn't try to return a value
from a void function. Apologies for the extra e-mail.

>From Mark Fasheh <mfasheh@suse.de>

[PATCH 1/4] vfs: introduce function to map unique ino/dev pairs

There are places in the VFS where we export an ino/dev pair to userspace.
/proc/PID/maps is a good example - we directly expose inode->i_ino and
inode->i_sb->s_dev to userspace there.  Many filesystems don't put a unique
value in inode->i_ino and instead rely on ->getattr to provide the real
inode number to userspace.  super->s_dev is similar - some filesystems
expose a difference device from what's put in super->s_dev when queried via
stat/statx.

Ultimately this makes it impossible for a user (or software) to match one of
those reported pairs to the right inode.

We can fix this by adding a helper function, vfs_map_unique_ino_dev(), which
will query the owning filesystem (via ->getattr) to get the correct ino/dev
pair.  Later patches will update those places which simply dump inode->i_ino
and super->s_dev to use the helper.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/stat.c          | 22 ++++++++++++++++++++++
 include/linux/fs.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/fs/stat.c b/fs/stat.c
index f8e6fb2c3657..20c72d618ed5 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -84,6 +84,28 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 }
 EXPORT_SYMBOL(vfs_getattr_nosec);
 
+void vfs_map_unique_ino_dev(struct dentry *dentry, u64 *ino, dev_t *dev)
+{
+	int ret;
+	struct path path;
+	struct kstat stat;
+
+	path.mnt = NULL;
+	path.dentry = dentry;
+	/* ->dev is always returned, so we only need to specify ino here */
+	ret = vfs_getattr_nosec(&path, &stat, STATX_INO, 0);
+	if (ret) {
+		struct inode *inode = d_inode(dentry);
+		/* Fallback to old behavior in case of getattr error */
+		*ino = inode->i_ino;
+		*dev = inode->i_sb->s_dev;
+		return;
+	}
+	*ino = stat.ino;
+	*dev = stat.dev;
+}
+EXPORT_SYMBOL(vfs_map_unique_ino_dev);
+
 /*
  * vfs_getattr - Get the enhanced basic attributes of a file
  * @path: The file of interest
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d78d146a98da..b80789472438 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3077,6 +3077,8 @@ extern void kfree_link(void *);
 extern void generic_fillattr(struct inode *, struct kstat *);
 extern int vfs_getattr_nosec(const struct path *, struct kstat *, u32, unsigned int);
 extern int vfs_getattr(const struct path *, struct kstat *, u32, unsigned int);
+extern void vfs_map_unique_ino_dev(struct dentry *dentry, u64 *ino, dev_t *dev);
+
 void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void __inode_sub_bytes(struct inode *inode, loff_t bytes);
-- 
2.15.1

