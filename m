Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbbDTF2h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 01:28:37 -0400
From: NeilBrown <neilb@suse.de>
To: David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Date: Mon, 20 Apr 2015 15:27:52 +1000
Subject: [PATCH 2/3] fscache/cachefiles: optionally use SEEK_DATA instead of
 ->bmap.
Cc: linux-cachefs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <20150420052752.26554.52672.stgit@notabene.brown>
In-Reply-To: <20150420052558.26554.97143.stgit@notabene.brown>
References: <20150420052558.26554.97143.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cachefiles currently uses 'bmap' to determine if a given block
in a file has been cached, or not.
Not all filesystems support bmap, particularly BTRFS.

SEEK_DATA can be used to determine if a block in a file has
been allocated, but not all filesystems support this reliably.
On filesystems without explicit report, SEEK_DATA will report anything
below i_size to be valid  data.

So:
 - add a file_system_type flag which confirms that SEEK_DATA and
   SEEK_HOLE will reliably report holes,
 - change cachefiles to use vfs_lseek if FS_SUPPORTS_SEEK_HOLE is
   set, and only use ->bmap if it isn't.

Subsequent patch will set flag for btrfs.  Other filesystems could
usefully have FS_SUPPORTS_SEEK_HOLE set, but I'll leave that to the
relevant maintainers to decide.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/cachefiles/namei.c |   15 ++++--
 fs/cachefiles/rdwr.c  |  119 +++++++++++++++++++++++++++++++------------------
 include/linux/fs.h    |    1 
 3 files changed, 86 insertions(+), 49 deletions(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 5404afcdee98..5d5e56c645ec 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -643,14 +643,17 @@ lookup_again:
 	/* open a file interface onto a data file */
 	if (object->type != FSCACHE_COOKIE_TYPE_INDEX) {
 		if (d_is_reg(object->dentry)) {
-			const struct address_space_operations *aops;
 
 			ret = -EPERM;
-			aops = object->dentry->d_inode->i_mapping->a_ops;
-			if (!aops->bmap)
-				goto check_error;
-			if (object->dentry->d_sb->s_blocksize > PAGE_SIZE)
-				goto check_error;
+			if (!(object->dentry->d_sb->s_type->fs_flags
+			      & FS_SUPPORTS_SEEK_HOLE)) {
+				const struct address_space_operations *aops;
+				aops = object->dentry->d_inode->i_mapping->a_ops;
+				if (!aops->bmap)
+					goto check_error;
+				if (object->dentry->d_sb->s_blocksize > PAGE_SIZE)
+					goto check_error;
+			}
 
 			object->backer = object->dentry;
 		} else {
diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 9bd44ff48cc0..7c7cbfae7b19 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -394,9 +394,8 @@ int cachefiles_read_or_alloc_page(struct fscache_retrieval *op,
 	struct cachefiles_object *object;
 	struct cachefiles_cache *cache;
 	struct inode *inode;
-	sector_t block0, block;
-	unsigned shift;
 	int ret;
+	bool have_data;
 
 	object = container_of(op->op.object,
 			      struct cachefiles_object, fscache);
@@ -410,31 +409,47 @@ int cachefiles_read_or_alloc_page(struct fscache_retrieval *op,
 
 	inode = object->backer->d_inode;
 	ASSERT(S_ISREG(inode->i_mode));
-	ASSERT(inode->i_mapping->a_ops->bmap);
 	ASSERT(inode->i_mapping->a_ops->readpages);
 
-	/* calculate the shift required to use bmap */
-	shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
-
 	op->op.flags &= FSCACHE_OP_KEEP_FLAGS;
 	op->op.flags |= FSCACHE_OP_ASYNC;
 	op->op.processor = cachefiles_read_copier;
 
-	/* we assume the absence or presence of the first block is a good
-	 * enough indication for the page as a whole
-	 * - TODO: don't use bmap() for this as it is _not_ actually good
-	 *   enough for this as it doesn't indicate errors, but it's all we've
-	 *   got for the moment
-	 */
-	block0 = page->index;
-	block0 <<= shift;
-
-	block = inode->i_mapping->a_ops->bmap(inode->i_mapping, block0);
-	_debug("%llx -> %llx",
-	       (unsigned long long) block0,
-	       (unsigned long long) block);
-
-	if (block) {
+	if (inode->i_sb->s_type->fs_flags & FS_SUPPORTS_SEEK_HOLE) {
+		/* Use llseek */
+		struct path path;
+		struct file *file;
+		loff_t addr;
+		path.mnt = cache->mnt;
+		path.dentry = object->backer;
+		file = dentry_open(&path, O_RDONLY, cache->cache_cred);
+		if (IS_ERR(file))
+			goto enobufs;
+		addr = page->index;
+		addr <<= PAGE_SHIFT;
+		have_data = (addr == vfs_llseek(file, addr, SEEK_DATA));
+		filp_close(file, NULL);
+	} else {
+		/* we assume the absence or presence of the first block is a good
+		 * enough indication for the page as a whole
+		 * - TODO: don't use bmap() for this as it is _not_ actually good
+		 *   enough for this as it doesn't indicate errors, but it's all we've
+		 *   got for the moment
+		 */
+		/* calculate the shift required to use bmap */
+		unsigned shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
+		sector_t block0, block;
+
+		block0 = page->index;
+		block0 <<= shift;
+
+		block = inode->i_mapping->a_ops->bmap(inode->i_mapping, block0);
+		_debug("%llx -> %llx",
+		       (unsigned long long) block0,
+		       (unsigned long long) block);
+		have_data = (block != 0);
+	}
+	if (have_data) {
 		/* submit the apparently valid page to the backing fs to be
 		 * read from disk */
 		ret = cachefiles_read_backing_file_one(object, op, page);
@@ -683,7 +698,7 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 	struct pagevec pagevec;
 	struct inode *inode;
 	struct page *page, *_n;
-	unsigned shift, nrbackpages;
+	unsigned nrbackpages;
 	int ret, ret2, space;
 
 	object = container_of(op->op.object,
@@ -704,11 +719,8 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 
 	inode = object->backer->d_inode;
 	ASSERT(S_ISREG(inode->i_mode));
-	ASSERT(inode->i_mapping->a_ops->bmap);
 	ASSERT(inode->i_mapping->a_ops->readpages);
 
-	/* calculate the shift required to use bmap */
-	shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
 
 	pagevec_init(&pagevec, 0);
 
@@ -721,24 +733,45 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 
 	ret = space ? -ENODATA : -ENOBUFS;
 	list_for_each_entry_safe(page, _n, pages, lru) {
-		sector_t block0, block;
-
-		/* we assume the absence or presence of the first block is a
-		 * good enough indication for the page as a whole
-		 * - TODO: don't use bmap() for this as it is _not_ actually
-		 *   good enough for this as it doesn't indicate errors, but
-		 *   it's all we've got for the moment
-		 */
-		block0 = page->index;
-		block0 <<= shift;
-
-		block = inode->i_mapping->a_ops->bmap(inode->i_mapping,
-						      block0);
-		_debug("%llx -> %llx",
-		       (unsigned long long) block0,
-		       (unsigned long long) block);
-
-		if (block) {
+		bool have_data;
+
+		if (inode->i_sb->s_type->fs_flags & FS_SUPPORTS_SEEK_HOLE) {
+			/* Use llseek */
+			struct path path;
+			struct file *file;
+			loff_t addr;
+
+			path.mnt = cache->mnt;
+			path.dentry = object->backer;
+			file = dentry_open(&path, O_RDONLY, cache->cache_cred);
+			if (IS_ERR(file))
+				goto all_enobufs;
+			addr = page->index;
+			addr <<= PAGE_SHIFT;
+			have_date = (addr == vfs_llseek(file, addr, SEEK_DATA));
+			filp_close(file, NULL);
+		} else {
+			/* we assume the absence or presence of the first block is a
+			 * good enough indication for the page as a whole
+			 * - TODO: don't use bmap() for this as it is _not_ actually
+			 *   good enough for this as it doesn't indicate errors, but
+			 *   it's all we've got for the moment
+			 */
+			/* calculate the shift required to use bmap */
+			unsigned shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
+			sector_t block0, block;
+
+			block0 = page->index;
+			block0 <<= shift;
+
+			block = inode->i_mapping->a_ops->bmap(inode->i_mapping,
+							      block0);
+			_debug("%llx -> %llx",
+			       (unsigned long long) block0,
+			       (unsigned long long) block);
+			have_data = (block != 0);
+		}
+		if (have_data) {
 			/* we have data - add it to the list to give to the
 			 * backing fs */
 			list_move(&page->lru, &backpages);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f4131e8ead74..ae28d175eeb4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1863,6 +1863,7 @@ struct file_system_type {
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
 #define FS_USERNS_DEV_MOUNT	16 /* A userns mount does not imply MNT_NODEV */
+#define FS_SUPPORTS_SEEK_HOLE	32 /* SEEK_HOLE/SEEK_DATA reliably detect holes */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);


