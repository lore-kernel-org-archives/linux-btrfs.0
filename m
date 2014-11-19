Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37665 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbaKSHWi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 02:22:38 -0500
Received: by mail-pd0-f176.google.com with SMTP id y10so879pdj.35
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 23:22:37 -0800 (PST)
Date: Tue, 18 Nov 2014 23:22:35 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] btrfs: implement swap file support
Message-ID: <20141119072235.GA6541@mew>
References: <cover.1416219974.git.osandov@osandov.com>
 <20141117154817.GA25670@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
In-Reply-To: <20141117154817.GA25670@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 17, 2014 at 07:48:17AM -0800, Christoph Hellwig wrote:
> With the new iov_iter infrastructure that supprots direct I/O to kernel
> pages please get rid of the ->readpage hack first.  I'm still utterly
> disapoined that this crap ever got merged.
> 
That seems reasonable. Using direct I/O circumvents the need for patches 3, 4,
and 5, which were workarounds for readpage being fed a swapcache page, and
patch 1, which is a big, error-prone mess.

Here's a nice little bit of insanity I put together in that direction --
consider it a discussion point more than a patch. It does two things:

- Uses an ITER_BVEC iov_iter to do direct_IO for swap_readpage. This makes
  swap_readpage a synchronous operation, but I think that's the best we can do
  with the existing interface.
- Unless I'm missing something, there don't appear to be any instances of
  ITER_BVEC | READ in the kernel, so the dio path doesn't know not to dirty
  pages it gets that way. Dave Kleikamp and Ming Lei each previously submitted
  patches doing this as part of adding an aio_kernel interface. (The NFS direct
  I/O implementation doesn't know how to deal with these either, so this patch
  actually breaks the only existing user of this code path, but in the interest
  of keeping the patch short, I didn't try to fix it :)

Obviously, there's more to be done if that's how you'd prefer I do this. I'm
far from being an expert in any of this, so please let me know if I'm spewing
nonsense :)

-- 
Omar

--HlL+5n6rz5pIUxbD
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-swap-use-direct_IO-for-swap_readpage.patch"

>From e58c52e69a9aef07c0089f9ce552fca96d42bce9 Mon Sep 17 00:00:00 2001
Message-Id: <e58c52e69a9aef07c0089f9ce552fca96d42bce9.1416380574.git.osandov@osandov.com>
From: Omar Sandoval <osandov@osandov.com>
Date: Tue, 18 Nov 2014 22:42:10 -0800
Subject: [PATCH] swap: use direct_IO for swap_readpage

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/direct-io.c |  8 +++++---
 mm/page_io.c   | 37 ++++++++++++++++++++++++++++++-------
 2 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index e181b6b..e542ce4 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -120,6 +120,7 @@ struct dio {
 	spinlock_t bio_lock;		/* protects BIO fields below */
 	int page_errors;		/* errno from get_user_pages() */
 	int is_async;			/* is IO async ? */
+	int should_dirty;		/* should we mark read pages dirty? */
 	bool defer_completion;		/* defer AIO completion to workqueue? */
 	int io_error;			/* IO error in completion path */
 	unsigned long refcount;		/* direct_io_worker() and bios */
@@ -392,7 +393,7 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	dio->refcount++;
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
-	if (dio->is_async && dio->rw == READ)
+	if (dio->is_async && dio->rw == READ && dio->should_dirty)
 		bio_set_pages_dirty(bio);
 
 	if (sdio->submit_io)
@@ -463,13 +464,13 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 	if (!uptodate)
 		dio->io_error = -EIO;
 
-	if (dio->is_async && dio->rw == READ) {
+	if (dio->is_async && dio->rw == READ && dio->should_dirty) {
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 	} else {
 		bio_for_each_segment_all(bvec, bio, i) {
 			struct page *page = bvec->bv_page;
 
-			if (dio->rw == READ && !PageCompound(page))
+			if (dio->rw == READ && !PageCompound(page) && dio->should_dirty)
 				set_page_dirty_lock(page);
 			page_cache_release(page);
 		}
@@ -1177,6 +1178,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 
 	dio->inode = inode;
 	dio->rw = rw;
+	dio->should_dirty = !(iter->type & ITER_BVEC);
 
 	/*
 	 * For AIO O_(D)SYNC writes we need to defer completions to a workqueue
diff --git a/mm/page_io.c b/mm/page_io.c
index 955db8b..b9b84b2 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -266,8 +266,8 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		struct address_space *mapping = swap_file->f_mapping;
 		struct bio_vec bv = {
 			.bv_page = page,
-			.bv_len  = PAGE_SIZE,
-			.bv_offset = 0
+			.bv_len = PAGE_SIZE,
+			.bv_offset = 0,
 		};
 		struct iov_iter from = {
 			.type = ITER_BVEC | WRITE,
@@ -283,8 +283,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 
 		set_page_writeback(page);
 		unlock_page(page);
-		ret = mapping->a_ops->direct_IO(ITER_BVEC | WRITE,
-						&kiocb, &from,
+		ret = mapping->a_ops->direct_IO(WRITE, &kiocb, &from,
 						kiocb.ki_pos);
 		if (ret == PAGE_SIZE) {
 			count_vm_event(PSWPOUT);
@@ -303,7 +302,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 			set_page_dirty(page);
 			ClearPageReclaim(page);
 			pr_err_ratelimited("Write error on dio swapfile (%Lu)\n",
-				page_file_offset(page));
+					   page_file_offset(page));
 		}
 		end_page_writeback(page);
 		return ret;
@@ -348,12 +347,36 @@ int swap_readpage(struct page *page)
 	}
 
 	if (sis->flags & SWP_FILE) {
+		struct kiocb kiocb;
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
+		struct bio_vec bv = {
+			.bv_page = page,
+			.bv_len = PAGE_SIZE,
+			.bv_offset = 0,
+		};
+		struct iov_iter to = {
+			.type = ITER_BVEC | READ,
+			.count = PAGE_SIZE,
+			.iov_offset = 0,
+			.nr_segs = 1,
+		};
+		to.bvec = &bv;	/* older gcc versions are broken */
+
+		init_sync_kiocb(&kiocb, swap_file);
+		kiocb.ki_pos = page_file_offset(page);
+		kiocb.ki_nbytes = PAGE_SIZE;
 
-		ret = mapping->a_ops->readpage(swap_file, page);
-		if (!ret)
+		ret = mapping->a_ops->direct_IO(READ, &kiocb, &to,
+						kiocb.ki_pos);
+		if (ret == PAGE_SIZE) {
+			SetPageUptodate(page);
 			count_vm_event(PSWPIN);
+			ret = 0;
+		} else {
+			PageError(page); /* XXX: maybe? */
+		}
+		unlock_page(page);
 		return ret;
 	}
 
-- 
2.1.3


--HlL+5n6rz5pIUxbD--
