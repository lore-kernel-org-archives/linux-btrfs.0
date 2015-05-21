Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.phunq.net ([184.71.0.62]:38669 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbbEUTnc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 15:43:32 -0400
Message-ID: <555E355F.7000305@phunq.net>
Date: Thu, 21 May 2015 12:43:27 -0700
From: Daniel Phillips <daniel@phunq.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>,
        BTRFS FILE SYSTEM <linux-btrfs@vger.kernel.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tux3@tux3.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [WIP][PATCH] tux3: preliminatry nospace handling
References: <8f886f13-6550-4322-95be-93244ae61045@phunq.net> <55545C2F.8040207@phunq.net> <55549C2F.6000103@redhat.com>
In-Reply-To: <55549C2F.6000103@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

This is a rollup patch for preliminary nospace handling in Tux3, in 
line with my post here:

   http://lkml.iu.edu/hypermail/linux/kernel/1505.1/03167.html

You still have ENOSPC issues. Maybe it would be helpful to look at 
what we have done. I saw a reproducible case with 1,000 tasks in 
parallel last week that went nospace while 28% full. You also are not
giving a very good picture of the true full state via df.

Our algorithm is pretty simple, reliable and fast. I do not see any 
reason why Btrfs could not do it basically the same way. In one way it 
is easier for you - you are not forced to commit the entire delta, you 
can choose the bits you want to force to disk as convenient. You have 
more different kinds of cache objects to account, but that should be 
just detail. Your current frontend accounting looks plausible.

We're trying something a bit different with df, to see how it flies - 
we don't always return the same number to f_blocks, we actually return 
the volume size less the accounting reserve, which is variable. The 
reserve gets smaller as freespace gets smaller, so it is not a nasty 
surprise to the user to see it change, rather a pleasant surprise. What 
it does is make the 100% really be 100%, less just a handful of blocks, 
and it makes "used" and "available" add up exactly to "blocks". If the 
user wants to know how many blocks they really have, they can look at 
/proc/partitions.

Regards,

Daniel

diff --git a/fs/tux3/commit.c b/fs/tux3/commit.c
index 909a222..7043580 100644
--- a/fs/tux3/commit.c
+++ b/fs/tux3/commit.c
@@ -297,6 +297,7 @@ static int commit_delta(struct sb *sb)
 	tux3_wake_delta_commit(sb);
 
 	/* Commit was finished, apply defered bfree. */
+	sb->defreed = 0;
 	return unstash(sb, &sb->defree, apply_defered_bfree);
 }
 
@@ -321,13 +322,13 @@ static int need_unify(struct sb *sb)
 /* For debugging */
 void tux3_start_backend(struct sb *sb)
 {
-	assert(current->journal_info == NULL);
+	assert(!change_active());
 	current->journal_info = sb;
 }
 
 void tux3_end_backend(void)
 {
-	assert(current->journal_info);
+	assert(change_active());
 	current->journal_info = NULL;
 }
 
@@ -337,12 +338,103 @@ int tux3_under_backend(struct sb *sb)
 	return current->journal_info == sb;
 }
 
+/* Internal use only */
+static struct delta_ref *to_delta_ref(struct sb *sb, unsigned delta)
+{
+	return &sb->delta_refs[tux3_delta(delta)];
+}
+
+static block_t newfree(struct sb *sb)
+{
+	return sb->freeblocks + sb->defreed;
+}
+
+/*
+ * Reserve size should vary with budget. The reserve can include the
+ * log block overhead on the assumption that every block in the budget
+ * is a data block that generates one log record (or two?).
+ */
+block_t set_budget(struct sb *sb)
+{
+	block_t reserve = sb->freeblocks >> 7; /* FIXME: magic number */
+
+	if (1) {
+		if (reserve > max_reserve_blocks)
+			reserve = max_reserve_blocks;
+		if (reserve < min_reserve_blocks)
+			reserve = min_reserve_blocks;
+	} else if (0)
+		reserve = 10;
+
+	block_t budget = newfree(sb) - reserve;
+	if (1)
+		tux3_msg(sb, "set_budget: free %Li, budget %Li, reserve %Li", newfree(sb), budget, reserve);
+	sb->reserve = reserve;
+	atomic_set(&sb->budget, budget);
+	return reserve;
+}
+
+/*
+ * After transition, the front delta may have used some of the balance
+ * left over from this delta. The charged amount of the back delta is
+ * now stable and gives the exact balance at transition by subtracting
+ * from the old budget. The difference between the new budget and the
+ * balance at transition, which must never be negative, is added to
+ * the current balance, so the effect is exactly the same as if we had
+ * set the new budget and balance atomically at transition time. But
+ * we do not know the new balance at transition time and even if we
+ * did, we would need to add serialization against frontend changes,
+ * which are currently lockless and would like to stay that way. So we 
+ * let the current delta charge against the remaining balance until
+ * flush is done, here, then adjust the balance to what it would have
+ * been if the budget had been reset exactly at transition.
+ *
+ * We have:
+ *
+ *    consumed = oldfree - free
+ *    oldbudget = oldfree - reserve
+ *    newbudget = free - reserve
+ *    transition_balance = oldbudget - charged
+ * 
+ * Factoring out the reserve, the balance adjustment is:
+ * 
+ *    adjust = newbudget - transition_balance
+ *           = (free - reserve) - ((oldfree - reserve) - charged)
+ *           = free + (charged - oldfree)
+ *           = charged + (free - oldfree)
+ *           = charged - consumed
+ *
+ * To extend for variable reserve size, add the difference between
+ * old and new reserve size to the balance adjustment.
+ */
+void reset_balance(struct sb *sb, unsigned delta, block_t unify_cost)
+{
+	enum { initial_logblock = 0 };
+	unsigned charged = atomic_read(&to_delta_ref(sb, delta)->charged);
+	block_t consumed = sb->oldfree - newfree(sb);
+	//block_t old_reserve = sb->reserve;
+
+	if (1)
+		tux3_msg(sb, "budget %i, balance %i, charged %u, consumed %Li, free %Lu, defree %Lu, unify %Lu",
+			atomic_read(&sb->budget), atomic_read(&sb->balance), 
+			charged, consumed, sb->freeblocks, sb->defreed, unify_cost);
+
+	sb->oldfree = newfree(sb);
+	set_budget(sb); /* maybe should set in size dependent order */
+	atomic_add(charged - consumed /*+ (old_reserve - sb->reserve)*/, &sb->balance);
+
+	if (consumed - initial_logblock - unify_cost > charged)
+		tux3_warn(sb, "delta %u estimate exceeded by %Lu blocks",
+			delta, consumed - charged);
+}
+
 static int do_commit(struct sb *sb, int flags)
 {
 	unsigned delta = sb->delta_staging;
 	int no_unify = flags & __NO_UNIFY;
 	struct blk_plug plug;
 	struct ioinfo ioinfo;
+	block_t unify_cost = 0;
 	int err = 0;
 
 	trace(">>>>>>>>> commit delta %u", delta);
@@ -359,8 +451,10 @@ static int do_commit(struct sb *sb, int flags)
 	 * FIXME: there is no need to commit if normal inodes are not
 	 * dirty? better way?
 	 */
-	if (!(flags & __FORCE_DELTA) && !tux3_has_dirty_inodes(sb, delta))
+	if (1 && !(flags & __FORCE_DELTA) && !tux3_has_dirty_inodes(sb, delta)) {
+		reset_balance(sb, delta, 0);
 		goto out;
+	}
 
 	/* Prepare to wait I/O */
 	tux3_io_init(&ioinfo, flags);
@@ -402,9 +496,11 @@ static int do_commit(struct sb *sb, int flags)
 #endif
 
 	if ((!no_unify && need_unify(sb)) || (flags & __FORCE_UNIFY)) {
+		unify_cost = sb->freeblocks;
 		err = unify_log(sb);
 		if (err)
 			goto error; /* FIXME: error handling */
+		unify_cost -= sb->freeblocks;
 
 		/* Add delta log for debugging. */
 		log_delta(sb);
@@ -414,6 +510,8 @@ static int do_commit(struct sb *sb, int flags)
 	write_log(sb);
 	blk_finish_plug(&plug);
 
+	reset_balance(sb, delta, unify_cost);
+
 	/*
 	 * Commit last block (for now, this is sync I/O).
 	 *
@@ -455,12 +553,6 @@ error:
 	 ((int)((a) - (b)) >= 0))
 #define delta_before_eq(a,b)	delta_after_eq(b,a)
 
-/* Internal use only */
-static struct delta_ref *to_delta_ref(struct sb *sb, unsigned delta)
-{
-	return &sb->delta_refs[tux3_delta(delta)];
-}
-
 static int flush_delta(struct sb *sb, int flags)
 {
 	int err;
@@ -510,6 +602,13 @@ static struct delta_ref *delta_get(struct sb *sb)
 	 * free ->current_delta, so we don't need rcu_read_lock().
 	 */
 	do {
+		barrier();
+		/*
+		 * NOTE: Without this barrier(), at least, gcc-4.8.2 ignores
+		 * volatile dereference of sb->current_delta in this loop,
+		 * and instead uses the cached value.
+		 * (Looks like a gcc bug, this barrier() is the workaround)
+		 */
 		delta_ref = rcu_dereference_check(sb->current_delta, 1);
 	} while (!atomic_inc_not_zero(&delta_ref->refcount));
 
@@ -540,6 +639,7 @@ static void __delta_transition(struct sb *sb, struct delta_ref *delta_ref,
 	reinit_completion(&delta_ref->waitref_done);
 	/* Assign the delta number */
 	delta_ref->delta = new_delta;
+	atomic_set(&delta_ref->charged, 0);
 
 	/*
 	 * Update current delta, then release reference.
@@ -587,6 +687,7 @@ void tux3_delta_init(struct sb *sb)
 
 	for (i = 0; i < ARRAY_SIZE(sb->delta_refs); i++) {
 		atomic_set(&sb->delta_refs[i].refcount, 0);
+		atomic_set(&sb->delta_refs[i].charged, 0);
 		init_completion(&sb->delta_refs[i].waitref_done);
 	}
 #ifdef TUX3_FLUSHER_SYNC
@@ -620,11 +721,16 @@ void tux3_delta_setup(struct sb *sb)
 #endif
 }
 
-unsigned tux3_get_current_delta(void)
+static inline struct delta_ref *current_delta(void)
 {
 	struct delta_ref *delta_ref = current->journal_info;
 	assert(delta_ref != NULL);
-	return delta_ref->delta;
+	return delta_ref;
+}
+
+unsigned tux3_get_current_delta(void)
+{
+	return current_delta()->delta;
 }
 
 /* Choice sb->delta or sb->unify from inode */
@@ -654,7 +760,7 @@ unsigned tux3_inode_delta(struct inode *inode)
  */
 void change_begin_atomic(struct sb *sb)
 {
-	assert(current->journal_info == NULL);
+	assert(!change_active());
 	current->journal_info = delta_get(sb);
 }
 
@@ -662,7 +768,7 @@ void change_begin_atomic(struct sb *sb)
 void change_end_atomic(struct sb *sb)
 {
 	struct delta_ref *delta_ref = current->journal_info;
-	assert(delta_ref != NULL);
+	assert(change_active());
 	current->journal_info = NULL;
 	delta_put(sb, delta_ref);
 }
@@ -694,12 +800,52 @@ void change_end_atomic_nested(struct sb *sb, void *ptr)
  * and blocked if disabled asynchronous backend and backend is
  * running.
  */
-void change_begin(struct sb *sb)
+
+int change_begin_nospace(struct sb *sb, int cost, int limit)
 {
 #ifdef TUX3_FLUSHER_SYNC
 	down_read(&sb->delta_lock);
 #endif
+	if (1)
+		tux3_msg(sb, "check space, budget %i, balance %i, cost %u, limit %i",
+			atomic_read(&sb->budget), atomic_read(&sb->balance), cost, limit);
+
 	change_begin_atomic(sb);
+	if (atomic_sub_return(cost, &sb->balance) >= limit) {
+		atomic_add(cost, &current_delta()->charged);
+		return 0;
+	}
+	atomic_add(cost, &sb->balance);
+	if (1)
+		tux3_msg(sb, "wait space, budget %i, balance %i, cost %u, limit %i",
+			atomic_read(&sb->budget), atomic_read(&sb->balance), cost, limit);
+	change_end_atomic(sb);
+	return 1;
+}
+
+int change_nospace(struct sb *sb, int cost, int limit)
+{
+	assert(!change_active());
+	sync_current_delta(sb);
+	if (1)
+		tux3_msg(sb, "final check, budget %i, balance %i, cost %u, limit %i",
+			atomic_read(&sb->budget), atomic_read(&sb->balance), cost, limit);
+	if (cost > atomic_read(&sb->budget + limit)) {
+		if (1)
+			tux3_msg(sb, "*** out of space ***");
+		return 1;
+	}
+	return 0;
+}
+
+int change_begin(struct sb *sb, int cost, int limit)
+{
+	while (change_begin_nospace(sb, cost, limit)) {
+		if (change_nospace(sb, cost, limit)) {
+			return 1;
+		}
+	}
+	return 0;
 }
 
 int change_end(struct sb *sb)
@@ -714,34 +860,3 @@ int change_end(struct sb *sb)
 #endif
 	return err;
 }
-
-/*
- * This is used for simplify the error path, or separates big chunk to
- * small chunk in loop.
- *
- * E.g. the following
- *
- * change_begin()
- * while (stop) {
- *	change_begin_if_need()
- *	if (do_something() < 0)
- *		break;
- *	change_end_if_need()
- * }
- * change_end_if_need()
- */
-void change_begin_if_needed(struct sb *sb, int need_sep)
-{
-	if (current->journal_info == NULL)
-		change_begin(sb);
-	else if (need_sep) {
-		change_end(sb);
-		change_begin(sb);
-	}
-}
-
-void change_end_if_needed(struct sb *sb)
-{
-	if (current->journal_info)
-		change_end(sb);
-}
diff --git a/fs/tux3/commit_flusher.c b/fs/tux3/commit_flusher.c
index 59d6781..f543cfc 100644
--- a/fs/tux3/commit_flusher.c
+++ b/fs/tux3/commit_flusher.c
@@ -187,6 +187,10 @@ long tux3_writeback(struct super_block *super, struct bdi_writeback *wb,
 	unsigned target_delta;
 	int err;
 
+	if (0)
+		tux3_msg(sb, "writeback delta %i, reason %i",
+			container_of(work, struct tux3_wb_work, work)->delta, work->reason);
+
 	/* If we didn't finish replay yet, don't flush. */
 	if (!(super->s_flags & MS_ACTIVE))
 		return 0;
diff --git a/fs/tux3/filemap.c b/fs/tux3/filemap.c
index a8811c2..e79a148 100644
--- a/fs/tux3/filemap.c
+++ b/fs/tux3/filemap.c
@@ -834,7 +834,6 @@ static int __tux3_file_write_begin(struct file *file,
 				   int tux3_flags)
 {
 	int ret;
-
 	ret = tux3_write_begin(mapping, pos, len, flags, pagep,
 			       tux3_da_get_block, tux3_flags);
 	if (ret < 0)
@@ -877,8 +876,8 @@ static int tux3_file_write_end(struct file *file, struct address_space *mapping,
 
 	/* Separate big write transaction to small chunk. */
 	assert(S_ISREG(mapping->host->i_mode));
-	change_end_if_needed(tux_sb(mapping->host->i_sb));
-
+	if (change_active())
+		change_end(tux_sb(mapping->host->i_sb));
 	return ret;
 }
 
diff --git a/fs/tux3/filemap_blocklib.c b/fs/tux3/filemap_blocklib.c
index 1e0127f..aa13810 100644
--- a/fs/tux3/filemap_blocklib.c
+++ b/fs/tux3/filemap_blocklib.c
@@ -167,16 +167,33 @@ static int tux3_write_begin(struct address_space *mapping, loff_t pos,
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	struct page *page;
 	int status;
-
 retry:
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page)
 		return -ENOMEM;
 
 	if (tux3_flags & TUX3_F_SEP_DELTA) {
+		struct sb *sb = tux_sb(mapping->host->i_sb);
+		int cost = one_page_cost(mapping->host);
 		/* Separate big write transaction to small chunk. */
 		assert(S_ISREG(mapping->host->i_mode));
-		change_begin_if_needed(tux_sb(mapping->host->i_sb), 1);
+
+		if (change_active())
+			change_end(sb);
+
+		if (PageDirty(page))
+			change_begin_atomic(sb);
+		else if (change_begin_nospace(sb, cost, 0)) {
+			unlock_page(page);
+			page_cache_release(page);
+			if (change_nospace(sb, cost, 0)) {
+				/* fail path will truncate page */
+				change_begin_atomic(sb);
+				status = -ENOSPC;
+				goto fail;
+			}
+			goto retry;
+		}
 	}
 
 	/*
@@ -207,6 +224,7 @@ retry:
 	if (unlikely(status)) {
 		unlock_page(page);
 		page_cache_release(page);
+fail:
 		page = NULL;
 	}
 
diff --git a/fs/tux3/inode.c b/fs/tux3/inode.c
index f747c0e..7c97285 100644
--- a/fs/tux3/inode.c
+++ b/fs/tux3/inode.c
@@ -984,7 +984,10 @@ int tux3_setattr(struct dentry *dentry, struct iattr *iattr)
 
 	if (need_lock)
 		down_write(&tux_inode(inode)->truncate_lock);
-	change_begin(sb);
+	if (change_begin(sb, 2, 0)) {
+		err = -ENOSPC;
+		goto unlock;
+	}
 
 	if (need_truncate)
 		err = tux3_truncate(inode, iattr->ia_size);
@@ -995,6 +998,7 @@ int tux3_setattr(struct dentry *dentry, struct iattr *iattr)
 	}
 
 	change_end(sb);
+unlock:
 	if (need_lock)
 		up_write(&tux_inode(inode)->truncate_lock);
 
@@ -1060,7 +1064,8 @@ static int tux3_special_update_time(struct inode *inode, struct timespec *time,
 		return 0;
 
 	/* FIXME: no i_mutex, so this is racy */
-	change_begin(sb);
+	if (change_begin(sb, 1, 0))
+		return -ENOSPC;
 	if (flags & S_VERSION)
 		inode_inc_iversion(inode);
 	if (flags & S_CTIME)
diff --git a/fs/tux3/inode_vfslib.c b/fs/tux3/inode_vfslib.c
index afae9b8..bdecf53 100644
--- a/fs/tux3/inode_vfslib.c
+++ b/fs/tux3/inode_vfslib.c
@@ -21,10 +21,15 @@ static ssize_t tux3_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	mutex_lock(&inode->i_mutex);
 	/* For each ->write_end() calls change_end(). */
-	change_begin(sb);
+	if (change_begin(sb, 1, 0)) {
+		mutex_unlock(&inode->i_mutex);
+		return -ENOSPC;
+	}
+
 	/* FIXME: file_update_time() in this can be race with mmap */
 	ret = __generic_file_write_iter(iocb, from);
-	change_end_if_needed(sb);
+	if (change_active())
+		change_end(sb);
 	mutex_unlock(&inode->i_mutex);
 
 	if (ret > 0) {
diff --git a/fs/tux3/log.c b/fs/tux3/log.c
index bb26c73..fdc36b0 100644
--- a/fs/tux3/log.c
+++ b/fs/tux3/log.c
@@ -634,6 +634,7 @@ int defer_bfree(struct sb *sb, struct stash *defree,
 
 	assert(count > 0);
 	assert(block + count <= sb->volblocks);
+	sb->defreed += count;
 
 	/*
 	 * count field of stash is 16bits. So, this separates to
diff --git a/fs/tux3/namei.c b/fs/tux3/namei.c
index cb8e0b2..2b1355d 100644
--- a/fs/tux3/namei.c
+++ b/fs/tux3/namei.c
@@ -37,13 +37,16 @@ static int __tux3_mknod(struct inode *dir, struct dentry *dentry,
 			struct tux_iattr *iattr)
 {
 	struct inode *inode;
+	struct sb *sb = tux_sb(dir->i_sb);
 	int err;
 
 	if (!huge_valid_dev(iattr->rdev) &&
 	    (S_ISBLK(iattr->mode) || S_ISCHR(iattr->mode)))
 		return -EINVAL;
 
-	change_begin(tux_sb(dir->i_sb));
+	if (change_begin(sb, 5, 0))
+		return -ENOSPC;
+
 	inode = tux_create_dirent_and_inode(dir, &dentry->d_name, iattr);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
@@ -56,7 +59,7 @@ static int __tux3_mknod(struct inode *dir, struct dentry *dentry,
 		inode_inc_link_count(dir);
 	err = 0;
 out:
-	change_end(tux_sb(dir->i_sb));
+	change_end(sb);
 	return err;
 }
 
@@ -93,7 +96,8 @@ static int tux3_link(struct dentry *old_dentry, struct inode *dir,
 	struct sb *sb = tux_sb(inode->i_sb);
 	int err;
 
-	change_begin(sb);
+	if (change_begin(sb, 5, 0))
+		return -ENOSPC;
 	tux3_iattrdirty(inode);
 	inode->i_ctime = gettime();
 	inode_inc_link_count(inode);
@@ -134,7 +138,8 @@ static int __tux3_symlink(struct inode *dir, struct dentry *dentry,
 	if (len > PAGE_CACHE_SIZE)
 		return -ENAMETOOLONG;
 
-	change_begin(sb);
+	if (change_begin(sb, 6, 0))
+		return -ENOSPC;
 	inode = tux_create_dirent_and_inode(dir, &dentry->d_name, iattr);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
@@ -181,7 +186,8 @@ static int tux3_unlink(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = dentry->d_inode;
 	struct sb *sb = tux_sb(inode->i_sb);
 
-	change_begin(sb);
+	if (change_begin(sb, 1, min_reserve_blocks * -.75))
+		return -ENOSPC;
 	int err = tux_del_dirent(dir, dentry);
 	if (!err) {
 		tux3_iattrdirty(inode);
@@ -201,7 +207,8 @@ static int tux3_rmdir(struct inode *dir, struct dentry *dentry)
 	int err = tux_dir_is_empty(inode);
 
 	if (!err) {
-		change_begin(sb);
+		if (change_begin(sb, 3, min_reserve_blocks * -.75))
+			return -ENOSPC;
 		err = tux_del_dirent(dir, dentry);
 		if (!err) {
 			tux3_iattrdirty(inode);
@@ -237,7 +244,8 @@ static int tux3_rename(struct inode *old_dir, struct dentry *old_dentry,
 	/* FIXME: is this needed? */
 	assert(be64_to_cpu(old_entry->inum) == tux_inode(old_inode)->inum);
 
-	change_begin(sb);
+	if (change_begin(sb, 20, 0))
+		return -ENOSPC;
 	delta = tux3_get_current_delta();
 
 	new_subdir = S_ISDIR(old_inode->i_mode) && new_dir != old_dir;
diff --git a/fs/tux3/super.c b/fs/tux3/super.c
index b104dc7..29b17e8 100644
--- a/fs/tux3/super.c
+++ b/fs/tux3/super.c
@@ -370,6 +370,7 @@ static int init_sb(struct sb *sb)
 
 	INIT_LIST_HEAD(&sb->orphan_add);
 	INIT_LIST_HEAD(&sb->orphan_del);
+	sb->defreed = 0;
 	stash_init(&sb->defree);
 	stash_init(&sb->deunify);
 	INIT_LIST_HEAD(&sb->unify_buffers);
@@ -421,6 +422,12 @@ static void __setup_sb(struct sb *sb, struct disksuper *super)
 
 	sb->blocksize = 1 << sb->blockbits;
 	sb->blockmask = (1 << sb->blockbits) - 1;
+#ifdef __KERNEL__
+	sb->blocks_per_page_bits = PAGE_CACHE_SHIFT - sb->blockbits;
+#else
+	sb->blocks_per_page_bits = 0;
+#endif
+	sb->blocks_per_page = 1 << sb->blocks_per_page_bits;
 	sb->groupbits = 13; // FIXME: put in disk super?
 	sb->volmask = roundup_pow_of_two64(sb->volblocks) - 1;
 	sb->entries_per_node = calc_entries_per_node(sb->blocksize);
@@ -656,12 +663,13 @@ static int tux3_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
 	struct sb *sbi = tux_sb(sb);
-
+	block_t reserve = sbi->reserve, avail = sbi->freeblocks + sbi->defreed;
+	avail -= avail < reserve ? avail : reserve;
 	buf->f_type = sb->s_magic;
 	buf->f_bsize = sbi->blocksize;
-	buf->f_blocks = sbi->volblocks;
-	buf->f_bfree = sbi->freeblocks;
-	buf->f_bavail = sbi->freeblocks;
+	buf->f_blocks = sbi->volblocks - reserve;
+	buf->f_bfree = avail;
+	buf->f_bavail = avail; /* FIXME: no special privilege for root yet */
 	buf->f_files = MAX_INODES;
 	buf->f_ffree = sbi->freeinodes;
 #if 0
@@ -773,7 +781,7 @@ static int tux3_fill_super(struct super_block *sb, void *data, int silent)
 			goto error;
 		}
 	}
-	tux3_dbg("s_blocksize %lu", sb->s_blocksize);
+	tux3_dbg("s_blocksize %lu, sb = %p", sb->s_blocksize, tux_sb(sb));
 
 	rp = tux3_init_fs(sbi);
 	if (IS_ERR(rp)) {
@@ -794,6 +802,9 @@ static int tux3_fill_super(struct super_block *sb, void *data, int silent)
 		goto error;
 	}
 
+	sbi->oldfree = sbi->freeblocks;
+	set_budget(sbi);
+	atomic_set(&sbi->balance, atomic_read(&sbi->budget));
 	return 0;
 
 error:
diff --git a/fs/tux3/tux3.h b/fs/tux3/tux3.h
index e2f2d9b..4eae938 100644
--- a/fs/tux3/tux3.h
+++ b/fs/tux3/tux3.h
@@ -277,6 +277,7 @@ struct delta_ref {
 	atomic_t refcount;
 	unsigned delta;
 	struct completion waitref_done;
+	atomic_t charged; /* block allocation upper bound for this delta */
 };
 
 /* Per-delta data structure for sb */
@@ -355,7 +356,8 @@ struct sb {
 	unsigned blocksize, blockbits, blockmask, groupbits;
 	u64 freeinodes;		/* Number of free inode numbers. This is
 				 * including the deferred allocated inodes */
-	block_t volblocks, volmask, freeblocks, nextblock;
+	block_t volblocks, volmask, freeblocks, oldfree, reserve, nextblock;
+	unsigned blocks_per_page, blocks_per_page_bits;
 	inum_t nextinum;	/* FIXME: temporary hack to avoid to find
 				 * same area in itree for free inum. */
 	unsigned entries_per_node; /* must be per-btree type, get rid of this */
@@ -376,6 +378,7 @@ struct sb {
 	struct list_head orphan_add; /* defered orphan inode add list */
 	struct list_head orphan_del; /* defered orphan inode del list */
 
+	block_t defreed;	/* total deferred free blocks */
 	struct stash defree;	/* defer extent frees until after delta */
 	struct stash deunify;	/* defer extent frees until after unify */
 
@@ -387,6 +390,7 @@ struct sb {
 	/*
 	 * For frontend and backend
 	 */
+	atomic_t budget, balance;
 	spinlock_t countmap_lock;
 	struct countmap_pin countmap_pin;
 	struct tux3_idefer_map *idefer_map;
@@ -515,6 +519,12 @@ static inline struct block_device *sb_dev(struct sb *sb)
 {
 	return sb->vfs_sb->s_bdev;
 }
+#else
+static inline struct sb *tux_sb(struct super_block *sb)
+{
+	return container_of(sb, struct sb, vfs_sb);
+}
+
 #endif /* __KERNEL__ */
 
 /* Get delta from free running counter */
@@ -686,6 +696,15 @@ static inline int has_no_root(struct btree *btree)
 	return btree->root.depth == 0;
 }
 
+/* Estimate backend allocation cost per data page */
+static inline unsigned one_page_cost(struct inode *inode)
+{
+	struct sb *sb = tux_sb(inode->i_sb);
+	struct btree *btree = &tux_inode(inode)->btree;
+	unsigned depth = has_root(btree) ? btree->root.depth : 0;
+	return sb->blocks_per_page + 2 * depth + 1;
+}
+
 /* Redirect ptr which is pointing data of src from src to dst */
 static inline void *ptr_redirect(void *ptr, void *src, void *dst)
 {
@@ -832,6 +851,14 @@ int replay_bnode_del(struct replay *rp, block_t bnode, tuxkey_t key, unsigned co
 int replay_bnode_adjust(struct replay *rp, block_t bnode, tuxkey_t from, tuxkey_t to);
 
 /* commit.c */
+
+enum { min_reserve_blocks = 8, max_reserve_blocks = 128 };
+
+static inline int change_active(void)
+{
+	return !!current->journal_info;
+}
+
 void tux3_start_backend(struct sb *sb);
 void tux3_end_backend(void);
 int tux3_under_backend(struct sb *sb);
@@ -844,10 +871,11 @@ void change_begin_atomic(struct sb *sb);
 void change_end_atomic(struct sb *sb);
 void change_begin_atomic_nested(struct sb *sb, void **ptr);
 void change_end_atomic_nested(struct sb *sb, void *ptr);
-void change_begin(struct sb *sb);
+int change_begin_nospace(struct sb *sb, int cost, int limit);
+int change_nospace(struct sb *sb, int cost, int limit);
+int change_begin(struct sb *sb, int cost, int limit);
 int change_end(struct sb *sb);
-void change_begin_if_needed(struct sb *sb, int need_sep);
-void change_end_if_needed(struct sb *sb);
+block_t set_budget(struct sb *sb);
 
 /* dir.c */
 void tux_set_entry(struct buffer_head *buffer, struct tux3_dirent *entry,
diff --git a/fs/tux3/user/filemap.c b/fs/tux3/user/filemap.c
index 8d8c812..6c99948 100644
--- a/fs/tux3/user/filemap.c
+++ b/fs/tux3/user/filemap.c
@@ -309,7 +309,7 @@ int tuxwrite(struct file *file, const void *data, unsigned len)
 {
 	struct sb *sb = tux_sb(file->f_inode->i_sb);
 	int ret;
-	change_begin(sb);
+	change_begin(sb, 2 * len, 0);
 	ret = tuxio(file, (void *)data, len, 1);
 	change_end(sb);
 	return ret;
diff --git a/fs/tux3/user/inode.c b/fs/tux3/user/inode.c
index 21823a1..70d5602 100644
--- a/fs/tux3/user/inode.c
+++ b/fs/tux3/user/inode.c
@@ -354,7 +354,7 @@ int tuxtruncate(struct inode *inode, loff_t size)
 	struct sb *sb = tux_sb(inode->i_sb);
 	int err;
 
-	change_begin(sb);
+	change_begin(sb, 1, -10);
 	err = __tuxtruncate(inode, size);
 	change_end(sb);
 
diff --git a/fs/tux3/user/tux3user.h b/fs/tux3/user/tux3user.h
index 5b68e5c..a298a91 100644
--- a/fs/tux3/user/tux3user.h
+++ b/fs/tux3/user/tux3user.h
@@ -55,11 +55,6 @@ static inline map_t *mapping(struct inode *inode);
 
 #include "../tux3.h"
 
-static inline struct sb *tux_sb(struct super_block *sb)
-{
-	return container_of(sb, struct sb, vfs_sb);
-}
-
 static inline struct super_block *vfs_sb(struct sb *sb)
 {
 	return &sb->vfs_sb;
diff --git a/fs/tux3/xattr.c b/fs/tux3/xattr.c
index c4ea5f9..9aff2e7 100644
--- a/fs/tux3/xattr.c
+++ b/fs/tux3/xattr.c
@@ -724,7 +724,7 @@ int set_xattr(struct inode *inode, const char *name, unsigned len,
 	struct inode *atable = sb->atable;
 
 	mutex_lock(&atable->i_mutex);
-	change_begin(sb);
+	change_begin(sb, 0, 0);
 
 	atom_t atom;
 	int err = make_atom(atable, name, len, &atom);
@@ -748,7 +748,7 @@ int del_xattr(struct inode *inode, const char *name, unsigned len)
 	int err;
 
 	mutex_lock(&atable->i_mutex);
-	change_begin(sb);
+	change_begin(sb, 0, 0);
 
 	atom_t atom;
 	err = find_atom(atable, name, len, &atom);

