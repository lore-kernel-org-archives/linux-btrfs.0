From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/2] fs: add a DCACHE_NEED_LOOKUP flag for d_flags
Date: Thu, 19 May 2011 13:58:48 -0400
Message-ID: <1305827929-18491-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	viro@ZenIV.linux.org.uk, hch@lst.de
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs (and I'd venture most other fs's) stores its indexes in nice disk order
for readdir, but unfortunately in the case of anything that stats the files in
order that readdir spits back (like oh say ls) that means we still have to do
the normal lookup of the file, which means looking up our other index and then
looking up the inode.  What I want is a way to create dummy dentries when we
find them in readdir so that when ls or anything else subsequently does a
stat(), we already have the location information in the dentry and can go
straight to the inode itself.  The lookup stuff just assumes that if it finds a
dentry it is done, it doesn't perform a lookup.  So add a DCACHE_NEED_LOOKUP
flag so that the lookup code knows it still needs to run i_op->lookup() on the
parent to get the inode for the dentry.  I have tested this with btrfs and I
went from something that looks like this

http://people.redhat.com/jwhiter/ls-noreada.png

To this

http://people.redhat.com/jwhiter/ls-good.png

Thats a savings of 1300 seconds, or 22 minutes.  That is a significant savings.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/namei.c             |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |    1 +
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e3c4f11..a1bff4f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1198,6 +1198,29 @@ static struct dentry *d_alloc_and_lookup(struct dentry *parent,
 }
 
 /*
+ * We already have a dentry, but require a lookup to be performed on the parent
+ * directory to fill in d_inode. Returns the new dentry, or ERR_PTR on error.
+ * parent->d_inode->i_mutex must be held. d_lookup must have verified that no
+ * child exists while under i_mutex.
+ */
+static struct dentry *d_inode_lookup(struct dentry *parent, struct dentry *dentry,
+				     struct nameidata *nd)
+{
+	struct inode *inode = parent->d_inode;
+	struct dentry *old;
+
+	/* Don't create child dentry for a dead directory. */
+	if (unlikely(IS_DEADDIR(inode)))
+		return ERR_PTR(-ENOENT);
+
+	old = inode->i_op->lookup(inode, dentry, nd);
+	if (unlikely(old)) {
+		dput(dentry);
+		dentry = old;
+	}
+	return dentry;
+}
+/*
  *  It's more convoluted than I'd like it to be, but... it's still fairly
  *  small and for now I'd prefer to have fast path as straight as possible.
  *  It _is_ time-critical.
@@ -1236,6 +1259,13 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 				goto unlazy;
 			}
 		}
+		if (unlikely(dentry->d_flags & DCACHE_NEED_LOOKUP)) {
+			if (nameidata_dentry_drop_rcu(nd, dentry))
+				return -ECHILD;
+			dput(dentry);
+			dentry = NULL;
+			goto retry;
+		}
 		path->mnt = mnt;
 		path->dentry = dentry;
 		if (likely(__follow_mount_rcu(nd, path, inode, false)))
@@ -1250,6 +1280,12 @@ unlazy:
 		}
 	} else {
 		dentry = __d_lookup(parent, name);
+		if (unlikely(!dentry))
+			goto retry;
+		if (unlikely(dentry->d_flags & DCACHE_NEED_LOOKUP)) {
+			dput(dentry);
+			dentry = NULL;
+		}
 	}
 
 retry:
@@ -1268,6 +1304,18 @@ retry:
 			/* known good */
 			need_reval = 0;
 			status = 1;
+		} else if (unlikely(dentry->d_flags & DCACHE_NEED_LOOKUP)) {
+			struct dentry *old;
+
+			dentry->d_flags &= ~DCACHE_NEED_LOOKUP;
+			dentry = d_inode_lookup(parent, dentry, nd);
+			if (IS_ERR(dentry)) {
+				mutex_unlock(&dir->i_mutex);
+				return PTR_ERR(dentry);
+			}
+			/* known good */
+			need_reval = 0;
+			status = 1;
 		}
 		mutex_unlock(&dir->i_mutex);
 	}
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 19d90a5..a8b2457 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -216,6 +216,7 @@ struct dentry_operations {
 #define DCACHE_MOUNTED		0x10000	/* is a mountpoint */
 #define DCACHE_NEED_AUTOMOUNT	0x20000	/* handle automount on this dir */
 #define DCACHE_MANAGE_TRANSIT	0x40000	/* manage transit from this dirent */
+#define DCACHE_NEED_LOOKUP	0x80000 /* dentry requires i_op->lookup */
 #define DCACHE_MANAGED_DENTRY \
 	(DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
 
-- 
1.7.2.3

