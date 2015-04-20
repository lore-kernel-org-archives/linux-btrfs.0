Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbbDTP7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 11:59:15 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3914.1429528902@warthog.procyon.org.uk>
References: <3914.1429528902@warthog.procyon.org.uk> <20150420052752.26554.52672.stgit@notabene.brown> <20150420052558.26554.97143.stgit@notabene.brown>
Cc: dhowells@redhat.com, NeilBrown <neilb@suse.de>, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-cachefs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [RFC][PATCH] cachefiles: Make better use of SEEK_DATA/SEEK_HOLE
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 20 Apr 2015 16:59:06 +0100
Message-ID: <13106.1429545546@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's a test patch that makes better use of SEEK_DATA/SEEK_HOLE in
cachefiles_read_or_alloc_pages() by caching data/hole information to use on
the subsequent pages in the list.

Note that the pages list needs to be transited in reverse for this to work as
it seems that the list passed to the fs is reverse-sorted.

What I see in the kernel output when reading a 16MB file is:

	[cat   ] ==> cachefiles_read_or_alloc_pages({OBJ5,1},,512,,)
	[cat   ] SEEK_DATA: 0
	[cat   ] SEEK_HOLE: 1000000
	[cat   ] <== cachefiles_read_or_alloc_pages() = 0 [nr=0 empty]
	[cat   ] ==> cachefiles_read_or_alloc_pages({OBJ5,1},,512,,)
	[cat   ] SEEK_DATA: 200000
	[cat   ] SEEK_HOLE: 1000000
	[cat   ] <== cachefiles_read_or_alloc_pages() = 0 [nr=0 empty]
	[cat   ] ==> cachefiles_read_or_alloc_pages({OBJ5,1},,512,,)
	[cat   ] SEEK_DATA: 400000
	[cat   ] SEEK_HOLE: 1000000
	[cat   ] <== cachefiles_read_or_alloc_pages() = 0 [nr=0 empty]
	[cat   ] ==> cachefiles_read_or_alloc_pages({OBJ5,1},,512,,)
	[cat   ] SEEK_DATA: 600000
	[cat   ] SEEK_HOLE: 1000000
	[cat   ] <== cachefiles_read_or_alloc_pages() = 0 [nr=0 empty]
	[cat   ] ==> cachefiles_read_or_alloc_pages({OBJ5,1},,512,,)
	[cat   ] SEEK_DATA: 800000
	[cat   ] SEEK_HOLE: 1000000
	[cat   ] <== cachefiles_read_or_alloc_pages() = 0 [nr=0 empty]
	[cat   ] ==> cachefiles_read_or_alloc_pages({OBJ5,1},,512,,)
	[cat   ] SEEK_DATA: a00000
	[cat   ] SEEK_HOLE: 1000000
	[cat   ] <== cachefiles_read_or_alloc_pages() = 0 [nr=0 empty]
	[cat   ] ==> cachefiles_read_or_alloc_pages({OBJ5,1},,512,,)
	[cat   ] SEEK_DATA: c00000
	[cat   ] SEEK_HOLE: 1000000
	[cat   ] <== cachefiles_read_or_alloc_pages() = 0 [nr=0 empty]
	[cat   ] ==> cachefiles_read_or_alloc_pages({OBJ5,1},,512,,)
	[cat   ] SEEK_DATA: e00000
	[cat   ] SEEK_HOLE: 1000000
	[cat   ] <== cachefiles_read_or_alloc_pages() = 0 [nr=0 empty]
	[cat   ] ==> cachefiles_read_or_alloc_page({ffff880037ffac00},{1000},,,)
	[cat   ] <== cachefiles_read_or_alloc_page() = -61

It doesn't quite work, though - after invalidating the file, I see lots of:

	[cat   ] SEEK_DATA: fffffffffffffffa

That is ENXIO.  I'm not sure what that portends yet.

David

---
diff --git a/fs/cachefiles/bind.c b/fs/cachefiles/bind.c
index fbb08e97438d..17612f09d4b3 100644
--- a/fs/cachefiles/bind.c
+++ b/fs/cachefiles/bind.c
@@ -129,7 +129,8 @@ static int cachefiles_daemon_add_cache(struct cachefiles_cache *cache)
 	    !root->d_inode->i_op->setxattr ||
 	    !root->d_inode->i_op->getxattr ||
 	    !root->d_sb->s_op->statfs ||
-	    !root->d_sb->s_op->sync_fs)
+	    !root->d_sb->s_op->sync_fs ||
+	    !root->d_sb->s_type->fs_flags & FS_SUPPORTS_SEEK_HOLE)
 		goto error_unsupported;
 
 	ret = -EROFS;
diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 7c7cbfae7b19..375588be715c 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -402,7 +402,7 @@ int cachefiles_read_or_alloc_page(struct fscache_retrieval *op,
 	cache = container_of(object->fscache.cache,
 			     struct cachefiles_cache, cache);
 
-	_enter("{%p},{%lx},,,", object, page->index);
+	kenter("{%p},{%lx},,,", object, page->index);
 
 	if (!object->backer)
 		goto enobufs;
@@ -462,12 +462,12 @@ int cachefiles_read_or_alloc_page(struct fscache_retrieval *op,
 		goto enobufs;
 	}
 
-	_leave(" = %d", ret);
+	kleave(" = %d", ret);
 	return ret;
 
 enobufs:
 	fscache_retrieval_complete(op, 1);
-	_leave(" = -ENOBUFS");
+	kleave(" = -ENOBUFS");
 	return -ENOBUFS;
 }
 
@@ -698,7 +698,10 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 	struct pagevec pagevec;
 	struct inode *inode;
 	struct page *page, *_n;
+	struct file *file;
+	struct path path;
 	unsigned nrbackpages;
+	loff_t pre_hole, from, to;
 	int ret, ret2, space;
 
 	object = container_of(op->op.object,
@@ -706,7 +709,7 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 	cache = container_of(object->fscache.cache,
 			     struct cachefiles_cache, cache);
 
-	_enter("{OBJ%x,%d},,%d,,",
+	kenter("{OBJ%x,%d},,%d,,",
 	       object->fscache.debug_id, atomic_read(&op->op.usage),
 	       *nr_pages);
 
@@ -731,47 +734,34 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 	INIT_LIST_HEAD(&backpages);
 	nrbackpages = 0;
 
+	path.mnt = cache->mnt;
+	path.dentry = object->backer;
+	file = dentry_open(&path, O_RDWR, cache->cache_cred);
+	if (IS_ERR(file))
+		goto all_enobufs;
+	pre_hole = from = to = 0;
+
 	ret = space ? -ENODATA : -ENOBUFS;
-	list_for_each_entry_safe(page, _n, pages, lru) {
-		bool have_data;
-
-		if (inode->i_sb->s_type->fs_flags & FS_SUPPORTS_SEEK_HOLE) {
-			/* Use llseek */
-			struct path path;
-			struct file *file;
-			loff_t addr;
-
-			path.mnt = cache->mnt;
-			path.dentry = object->backer;
-			file = dentry_open(&path, O_RDONLY, cache->cache_cred);
-			if (IS_ERR(file))
+	list_for_each_entry_safe_reverse(page, _n, pages, lru) {
+		loff_t addr;
+
+		/* Determine whether the page is present */
+		addr = page->index;
+		addr <<= PAGE_SHIFT;
+		if (addr < pre_hole || addr >= to) {
+			pre_hole = addr;
+			from = vfs_llseek(file, pre_hole, SEEK_DATA);
+			kdebug("SEEK_DATA: %llx", from);
+			if (IS_ERR_VALUE(from))
+				goto all_enobufs;
+
+			to = vfs_llseek(file, from, SEEK_HOLE);
+			kdebug("SEEK_HOLE: %llx", to);
+			if (IS_ERR_VALUE(to))
 				goto all_enobufs;
-			addr = page->index;
-			addr <<= PAGE_SHIFT;
-			have_date = (addr == vfs_llseek(file, addr, SEEK_DATA));
-			filp_close(file, NULL);
-		} else {
-			/* we assume the absence or presence of the first block is a
-			 * good enough indication for the page as a whole
-			 * - TODO: don't use bmap() for this as it is _not_ actually
-			 *   good enough for this as it doesn't indicate errors, but
-			 *   it's all we've got for the moment
-			 */
-			/* calculate the shift required to use bmap */
-			unsigned shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
-			sector_t block0, block;
-
-			block0 = page->index;
-			block0 <<= shift;
-
-			block = inode->i_mapping->a_ops->bmap(inode->i_mapping,
-							      block0);
-			_debug("%llx -> %llx",
-			       (unsigned long long) block0,
-			       (unsigned long long) block);
-			have_data = (block != 0);
 		}
-		if (have_data) {
+
+		if (addr >= from && addr <= to - PAGE_SIZE) {
 			/* we have data - add it to the list to give to the
 			 * backing fs */
 			list_move(&page->lru, &backpages);
@@ -786,6 +776,8 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 		}
 	}
 
+	filp_close(file, NULL);
+
 	if (pagevec_count(&pagevec) > 0)
 		fscache_mark_pages_cached(op, &pagevec);
 
@@ -800,12 +792,13 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 			ret = ret2;
 	}
 
-	_leave(" = %d [nr=%u%s]",
+	kleave(" = %d [nr=%u%s]",
 	       ret, *nr_pages, list_empty(pages) ? " empty" : "");
 	return ret;
 
 all_enobufs:
 	fscache_retrieval_complete(op, *nr_pages);
+	kleave(" = -ENOBUFS [all]");
 	return -ENOBUFS;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 821f22dbe825..686bd0db1d80 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -89,7 +89,7 @@ static struct file_system_type ext2_fs_type = {
 	.name		= "ext2",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_SUPPORTS_SEEK_HOLE,
 };
 MODULE_ALIAS_FS("ext2");
 MODULE_ALIAS("ext2");
