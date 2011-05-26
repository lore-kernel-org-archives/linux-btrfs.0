From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/2] fs: add a DCACHE_NEED_LOOKUP flag for d_flags
Date: Thu, 26 May 2011 10:48:35 -0400
Message-ID: <1306421316-1504-1-git-send-email-josef@redhat.com>
References: <adilger@dilger.ca, hch@lst.de>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <adilger@dilger.ca, hch@lst.de>
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
 fs/dcache.c            |   34 ++++++++++++++++++++++++++++++-
 fs/namei.c             |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |    7 ++++++
 3 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 22a0ef4..7fc0e30 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -343,6 +343,24 @@ void d_drop(struct dentry *dentry)
 EXPORT_SYMBOL(d_drop);
 
 /*
+ * d_clear_need_lookup - drop a dentry from cache and clear the need lookup flag
+ * @dentry: dentry to drop
+ *
+ * This is called when we do a lookup on a placeholder dentry that needed to be
+ * looked up.  The dentry should have been hashed in order for it to be found by
+ * the lookup code, but now needs to be unhashed while we do the actual lookup
+ * and clear the DCACHE_NEED_LOOKUP flag.
+ */
+void d_clear_need_lookup(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+	__d_drop(dentry);
+	dentry->d_flags &= ~DCACHE_NEED_LOOKUP;
+	spin_unlock(&dentry->d_lock);
+}
+EXPORT_SYMBOL(d_clear_need_lookup);
+
+/*
  * Finish off a dentry we've decided to kill.
  * dentry->d_lock must be held, returns with it unlocked.
  * If ref is non-zero, then decrement the refcount too.
@@ -431,8 +449,13 @@ repeat:
  	if (d_unhashed(dentry))
 		goto kill_it;
 
-	/* Otherwise leave it cached and ensure it's on the LRU */
-	dentry->d_flags |= DCACHE_REFERENCED;
+	/*
+	 * If this dentry needs lookup, don't set the referenced flag so that it
+	 * is more likely to be cleaned up by the dcache shrinker in case of
+	 * memory pressure.
+	 */
+	if (!d_need_lookup(dentry))
+		dentry->d_flags |= DCACHE_REFERENCED;
 	dentry_lru_add(dentry);
 
 	dentry->d_count--;
@@ -1703,6 +1726,13 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 	}
 
 	/*
+	 * We are going to instantiate this dentry, unhash it and clear the
+	 * lookup flag so we can do that.
+	 */
+	if (unlikely(d_need_lookup(found)))
+		d_clear_need_lookup(found);
+
+	/*
 	 * Negative dentry: instantiate it unless the inode is a directory and
 	 * already has a dentry.
 	 */
diff --git a/fs/namei.c b/fs/namei.c
index e3c4f11..fc8bc60 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1198,6 +1198,30 @@ static struct dentry *d_alloc_and_lookup(struct dentry *parent,
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
+
+/*
  *  It's more convoluted than I'd like it to be, but... it's still fairly
  *  small and for now I'd prefer to have fast path as straight as possible.
  *  It _is_ time-critical.
@@ -1236,6 +1260,8 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 				goto unlazy;
 			}
 		}
+		if (unlikely(d_need_lookup(dentry)))
+			goto unlazy;
 		path->mnt = mnt;
 		path->dentry = dentry;
 		if (likely(__follow_mount_rcu(nd, path, inode, false)))
@@ -1252,6 +1278,10 @@ unlazy:
 		dentry = __d_lookup(parent, name);
 	}
 
+	if (dentry && unlikely(d_need_lookup(dentry))) {
+		dput(dentry);
+		dentry = NULL;
+	}
 retry:
 	if (unlikely(!dentry)) {
 		struct inode *dir = parent->d_inode;
@@ -1268,6 +1298,17 @@ retry:
 			/* known good */
 			need_reval = 0;
 			status = 1;
+		} else if (unlikely(d_need_lookup(dentry))) {
+			struct dentry *old;
+
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
@@ -1755,6 +1796,16 @@ static struct dentry *__lookup_hash(struct qstr *name,
 	 */
 	dentry = d_lookup(base, name);
 
+	if (dentry && d_need_lookup(dentry)) {
+		/*
+		 * __lookup_hash is called with the parent dir's i_mutex already
+		 * held, so we are good to go here.
+		 */
+		dentry = d_inode_lookup(base, dentry, nd);
+		if (IS_ERR(dentry))
+			return dentry;
+	}
+
 	if (dentry && (dentry->d_flags & DCACHE_OP_REVALIDATE))
 		dentry = do_revalidate(dentry, nd);
 
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 19d90a5..5fa5bd3 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -216,6 +216,7 @@ struct dentry_operations {
 #define DCACHE_MOUNTED		0x10000	/* is a mountpoint */
 #define DCACHE_NEED_AUTOMOUNT	0x20000	/* handle automount on this dir */
 #define DCACHE_MANAGE_TRANSIT	0x40000	/* manage transit from this dirent */
+#define DCACHE_NEED_LOOKUP	0x80000 /* dentry requires i_op->lookup */
 #define DCACHE_MANAGED_DENTRY \
 	(DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
 
@@ -416,6 +417,12 @@ static inline bool d_mountpoint(struct dentry *dentry)
 	return dentry->d_flags & DCACHE_MOUNTED;
 }
 
+static inline bool d_need_lookup(struct dentry *dentry)
+{
+	return dentry->d_flags & DCACHE_NEED_LOOKUP;
+}
+
+extern void d_clear_need_lookup(struct dentry *dentry);
 extern struct dentry *lookup_create(struct nameidata *nd, int is_dir);
 
 extern int sysctl_vfs_cache_pressure;
-- 
1.7.2.3

