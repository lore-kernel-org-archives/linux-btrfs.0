Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:54120 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaBOD3x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 22:29:53 -0500
Date: Fri, 14 Feb 2014 21:45:24 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: unset DCACHE_DISCONNECTED when mounting default
 subvol
Message-ID: <20140215024524.GA6660@fieldses.org>
References: <1392403428-4593-1-git-send-email-jbacik@fb.com>
 <20140214220525.GB3506@fieldses.org>
 <8761ohnoew.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8761ohnoew.fsf@xmission.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 14, 2014 at 05:40:55PM -0800, Eric W. Biederman wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> > On Fri, Feb 14, 2014 at 01:43:48PM -0500, Josef Bacik wrote:
> >> A user was running into errors from an NFS export of a subvolume that had a
> >> default subvol set.  When we mount a default subvol we will use d_obtain_alias()
> >> to find an existing dentry for the subvolume in the case that the root subvol
> >> has already been mounted, or a dummy one is allocated in the case that the root
> >> subvol has not already been mounted.  This allows us to connect the dentry later
> >> on if we wander into the path.  However if we don't ever wander into the path we
> >> will keep DCACHE_DISCONNECTED set for a long time, which angers NFS.  It doesn't
> >> appear to cause any problems but it is annoying nonetheless, so simply unset
> >> DCACHE_DISCONNECTED in the get_default_root case and switch btrfs_lookup() to
> >> use d_materialise_unique() instead which will make everything play nicely
> >> together and reconnect stuff if we wander into the defaul subvol path from a
> >> different way.  With this patch I'm no longer getting the NFS errors when
> >> exporting a volume that has been mounted with a default subvol set.  Thanks,
> >
> > Looks obviously correct, but based on a quick grep, there are four
> > d_obtain_alias callers outside export methods:
> >
> > 	- btrfs/super.c:get_default_root()
> > 	- fs/ceph/super.c:open_root_dentry()
> > 	- fs/nfs/getroot.c:nfs_get_root()
> > 	- fs/nilfs2/super.c:nilfs_get_root_dentry()
> >
> > It'd be nice to give them a common d_obtain_alias variant instead of
> > making them all clear this by hand.
> 
> I am in favor of one small fix at a time, so that progress is made and
> fixing something just for btrfs seems reasonable for the short term.
> 
> > Of those nilfs2 also uses d_splice_alias.  I think that problem would
> > best be solved by fixing d_splice_alias not to require a
> > DCACHE_DISCONNECTED dentry; IS_ROOT() on its own should be fine.
> 
> You mean by renaming d_splice_alias d_materialise_unique?
> 
> Or is there a useful distinction you see that should be preserved
> between the two methods?
> 
> Right now my inclination is that everyone should just use
> d_materialise_unique and we should kill d_splice_alias.

Probably.  One remaining distinction:

	- In the local filesystem case if you discover a directory is
	  already aliased elsewhere, you have a corrupted filesystem and
	  want to error out the lookup.  (Didn't you propose a patch to
	  do something like that before?)
	- In the distributed filesystem this is perfectly normal and we
	  want to do our best to fix up our local cache to represent
	  remote reality.

> And by everyone I mean all file systems that are either distributed
> (implementing d_revalidate) or exportable by knfsd.
> 
> One of the interesting things that d_materialise_unique does is get the
> lazy rename case correct for a distributed filesystem.
> check_submounts_and_drop can drop a directory when it is found not to be
> accessible by that name, but later when we look it up
> d_materialise_uniuqe will resuscciate the existing dentry.

OK.  I'm not sure I understand how that helps.

Ugly untested draft follows.

--b.

diff --git a/fs/dcache.c b/fs/dcache.c
index 265e0ce..b4572fa 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1905,58 +1905,6 @@ struct dentry *d_obtain_alias(struct inode *inode)
 EXPORT_SYMBOL(d_obtain_alias);
 
 /**
- * d_splice_alias - splice a disconnected dentry into the tree if one exists
- * @inode:  the inode which may have a disconnected dentry
- * @dentry: a negative dentry which we want to point to the inode.
- *
- * If inode is a directory and has a 'disconnected' dentry (i.e. IS_ROOT and
- * DCACHE_DISCONNECTED), then d_move that in place of the given dentry
- * and return it, else simply d_add the inode to the dentry and return NULL.
- *
- * This is needed in the lookup routine of any filesystem that is exportable
- * (via knfsd) so that we can build dcache paths to directories effectively.
- *
- * If a dentry was found and moved, then it is returned.  Otherwise NULL
- * is returned.  This matches the expected return value of ->lookup.
- *
- * Cluster filesystems may call this function with a negative, hashed dentry.
- * In that case, we know that the inode will be a regular file, and also this
- * will only occur during atomic_open. So we need to check for the dentry
- * being already hashed only in the final case.
- */
-struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
-{
-	struct dentry *new = NULL;
-
-	if (IS_ERR(inode))
-		return ERR_CAST(inode);
-
-	if (inode && S_ISDIR(inode->i_mode)) {
-		spin_lock(&inode->i_lock);
-		new = __d_find_alias(inode, 1);
-		if (new) {
-			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
-			spin_unlock(&inode->i_lock);
-			security_d_instantiate(new, inode);
-			d_move(new, dentry);
-			iput(inode);
-		} else {
-			/* already taking inode->i_lock, so d_add() by hand */
-			__d_instantiate(dentry, inode);
-			spin_unlock(&inode->i_lock);
-			security_d_instantiate(dentry, inode);
-			d_rehash(dentry);
-		}
-	} else {
-		d_instantiate(dentry, inode);
-		if (d_unhashed(dentry))
-			d_rehash(dentry);
-	}
-	return new;
-}
-EXPORT_SYMBOL(d_splice_alias);
-
-/**
  * d_add_ci - lookup or allocate new dentry with case-exact name
  * @inode:  the inode case-insensitive lookup has found
  * @dentry: the negative dentry that was passed to the parent's lookup func
@@ -2716,19 +2664,42 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 }
 
 /**
- * d_materialise_unique - introduce an inode into the tree
- * @dentry: candidate dentry
+ * d_splice_alias - introduce an inode into the tree
  * @inode: inode to bind to the dentry, to which aliases may be attached
+ * @dentry: candidate dentry
+ * @force: move an existing non-root alias if necessary
+ *
+ * Introduces a dentry into the tree, using either the provided dentry
+ * or, if appropriate, a preexisting alias for the same inode.  Return
+ * NULL in the former case, the found alias in the latter.  Caller must
+ * hold the i_mutex of the parent directory.
  *
- * Introduces an dentry into the tree, substituting an extant disconnected
- * root directory alias in its place if there is one. Caller must hold the
- * i_mutex of the parent directory.
+ * The inode may also be an error or NULL; in the former case the error is
+ * just passed through, in the latter we hash and instantiate the negative
+ * dentry.  This allows filesystems to use d_splice_alias as the
+ * unconditional last step of their lookup method.
+ *
+ * Directories must have unique aliases.  In the case a directory is
+ * found to already have an alias, if that alias is IS_ROOT, we move
+ * it into place.  Otherwise, if @force is false, we fail with -EIO.  If
+ * @force is true, we try to move the alias anyway, returning -ELOOP if
+ * that would create a directory alias or -EBUSY if we fail to acquire
+ * the locks required for a rename.
+ *
+ * d_splice_alias makes no such guarantee for files, but may still
+ * use a preexisting alias when convenient.
+ *
+ * Note that d_splice_alias normally expects an unhashed dentry, the single
+ * exception being that cluster filesystems may call this function
+ * during atomic_open with a negative hashed dentry, and with inode a
+ * regular file.
  */
-struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
+struct dentry *__d_splice_alias(struct inode *inode, struct dentry *dentry, bool force)
 {
 	struct dentry *actual;
 
-	BUG_ON(!d_unhashed(dentry));
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 
 	if (!inode) {
 		actual = dentry;
@@ -2760,9 +2731,27 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 				__d_drop(alias);
 				goto found;
 			} else {
-				/* Nope, but we must(!) avoid directory
-				 * aliasing. This drops inode->i_lock */
-				actual = __d_unalias(inode, dentry, alias);
+				/*
+				 * Nope, but we must(!) avoid directory
+				 * aliasing.
+				 */
+				if (force) {
+					/*
+					 * Distributed filesystem case:
+					 * somebody else moved things
+					 * out from under us.  Let's do
+					 * our best to fix up things
+					 * locally:
+					 */
+					actual = __d_unalias(inode, dentry, alias);
+				} else {
+					/*
+					 * local filesystem case:
+					 * filesystem is just corrupted:
+					 */
+					actual = ERR_PTR(-EIO);
+					spin_unlock(&inode->i_lock);
+				}
 			}
 			write_sequnlock(&rename_lock);
 			if (IS_ERR(actual)) {
@@ -2788,7 +2777,8 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 
 	spin_lock(&actual->d_lock);
 found:
-	_d_rehash(actual);
+	if (d_unhashed(actual))
+		_d_rehash(actual);
 	spin_unlock(&actual->d_lock);
 	spin_unlock(&inode->i_lock);
 out_nolock:
@@ -2800,6 +2790,17 @@ out_nolock:
 	iput(inode);
 	return actual;
 }
+EXPORT_SYMBOL(d_splice_alias);
+
+struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
+{
+	return __d_splice_alias(inode, dentry, 0);
+}
+
+struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
+{
+	return __d_splice_alias(inode, dentry, 1);
+}
 EXPORT_SYMBOL_GPL(d_materialise_unique);
 
 static int prepend(char **buffer, int *buflen, const char *str, int namelen)
