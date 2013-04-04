Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:35334 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762758Ab3DDQLH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Apr 2013 12:11:07 -0400
Received: from freie (home.lxoliva.fsfla.org [172.31.160.22])
	by linux-libre.fsfla.org (8.14.3/8.14.3/Debian-9.1ubuntu1) with ESMTP id r34GB1D6002094
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Apr 2013 16:11:05 GMT
From: Alexandre Oliva <oliva@gnu.org>
To: linux-btrfs@vger.kernel.org
Subject: I/O errors block the entire filesystem
Date: Thu, 04 Apr 2013 13:10:27 -0300
Message-ID: <orhajmb7kc.fsf@livre.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

I've been trying to figure out the btrfs I/O stack to try to understand
why, sometimes (but not always), after a failure to read a (data
non-replicated) block from the disk, the file being accessed becomes
permanently locked, and the filesystem, unmountable.

Sometimes (but not always) it's possible to kill the process that
accessed the file, and sometimes (but not always) the failure causes
the machine load to skyrocket by 60+ processes.

In one of the failures that caused machine load spikes, I tried to
collect info on active processes with perf top and SysRq-T, but nothing
there seemed to explain the spike.  Thoughts on how to figure out what's
causing this?

Another weirdness I noticed is that, after a single read failure,
btree_io_failed_hook gets called multiple times, until io_pages gets
down to zero.  This seems wrong: I think it should only be called once
when a single block fails, rather than having that single failure get
all pending pages marked as failed, no?

Here are some instrumented dumps I collected from one occurrence of the
scenario described in the previous paragraph (it didn't cause a load
spike).  Only one disk block had a read failure.  At the end, I enclose
the patch that got those dumps printed, the result of several iterations
in which one failure led me to find another function to instrument.

end_request: I/O error, dev sdd, sector 183052083
btrfs: bdev /dev/sdd4 errs: wr 0, rd 3, flush 0, corrupt 0, gen 0
btrfs_end_bio orig -EIO 1 > 0 pending 0 end ffffffffa0240820,ffffffffa020c2d0
end_workqueue_bio err -5 bi_rw 0
ata5: EH complete
end_workqueue_fn err -5 end_io ffffffffa020c2d0,ffffffffa0231080
btree_io_failed_hook failed_mirror 1 io_pages 15 readahead 0
end_bio_extent_readpage err -5 faied_hook ffffffffa020bed0 ret -5
btree_io_failed_hook failed_mirror 1 io_pages 14 readahead 0
end_bio_extent_readpage err -5 failed_hook ffffffffa020bed0 ret -5
[...repeat both msgs with io_pages decremented one at a time...]
btree_io_failed_hook failed_mirror 1 io_pages 0 readahead 0
end_bio_extent_readpage err -5 failed_hook ffffffffa020bed0 ret -5
(no further related messages)


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=verbose-end-bio-err.patch

Be verbose about the path followed after an I/O error

From: Alexandre Oliva <lxoliva@fsfla.org>


---
 fs/btrfs/disk-io.c   |   22 ++++++++++++++++++++--
 fs/btrfs/extent_io.c |    6 ++++++
 fs/btrfs/volumes.c   |   31 +++++++++++++++++++++++++++++--
 3 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6d19a0a..20f9828 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -659,13 +659,18 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
 {
 	struct extent_buffer *eb;
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
+	long io_pages;
+	bool readahead;
 
 	eb = (struct extent_buffer *)page->private;
 	set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
 	eb->read_mirror = failed_mirror;
-	atomic_dec(&eb->io_pages);
-	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
+	io_pages = atomic_dec_return(&eb->io_pages);
+	if ((readahead = test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags)))
 		btree_readahead_hook(root, eb, eb->start, -EIO);
+	printk(KERN_ERR
+	       "btree_io_failed_hook failed_mirror %i io_pages %li readahead %i\n",
+	       failed_mirror, io_pages, readahead);
 	return -EIO;	/* we fixed nothing */
 }
 
@@ -674,6 +679,12 @@ static void end_workqueue_bio(struct bio *bio, int err)
 	struct end_io_wq *end_io_wq = bio->bi_private;
 	struct btrfs_fs_info *fs_info;
 
+	if (err) {
+		printk(KERN_ERR
+		       "end_workqueue_bio err %i bi_rw %lx\n",
+		       err, (unsigned long)bio->bi_rw);
+	}
+
 	fs_info = end_io_wq->info;
 	end_io_wq->error = err;
 	end_io_wq->work.func = end_workqueue_fn;
@@ -1647,6 +1658,13 @@ static void end_workqueue_fn(struct btrfs_work *work)
 	fs_info = end_io_wq->info;
 
 	error = end_io_wq->error;
+
+	if (error) {
+		printk(KERN_ERR
+		       "end_workqueue_fn err %i end_io %p,%p\n",
+		       error, bio->bi_end_io, end_io_wq->end_io);
+	}
+
 	bio->bi_private = end_io_wq->private;
 	bio->bi_end_io = end_io_wq->end_io;
 	kfree(end_io_wq);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cdee391..355b24e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2422,6 +2422,9 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 
 		if (!uptodate && tree->ops && tree->ops->readpage_io_failed_hook) {
 			ret = tree->ops->readpage_io_failed_hook(page, mirror);
+			printk(KERN_ERR
+			       "end_bio_extent_readpage err %i failed_hook %p ret %i\n",
+			       err, tree->ops->readpage_io_failed_hook, ret);
 			if (!ret && !err &&
 			    test_bit(BIO_UPTODATE, &bio->bi_flags))
 				uptodate = 1;
@@ -2437,6 +2440,9 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			 * remain responsible for that page.
 			 */
 			ret = bio_readpage_error(bio, page, start, end, mirror, NULL);
+			printk(KERN_ERR
+			       "end_bio_extent_readpage err %i readpage_error ret %i\n",
+			       err, ret);
 			if (ret == 0) {
 				uptodate =
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2854c82..59ea128 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5033,6 +5033,8 @@ static void btrfs_end_bio(struct bio *bio, int err)
 {
 	struct btrfs_bio *bbio = extract_bbio_from_bio_private(bio->bi_private);
 	int is_orig_bio = 0;
+	int pending;
+	int errors = 0;
 
 	if (err) {
 		atomic_inc(&bbio->error);
@@ -5062,11 +5064,13 @@ static void btrfs_end_bio(struct bio *bio, int err)
 	if (bio == bbio->orig_bio)
 		is_orig_bio = 1;
 
-	if (atomic_dec_and_test(&bbio->stripes_pending)) {
+	if ((pending = atomic_dec_return(&bbio->stripes_pending)) == 0) {
+		void (*endio)(struct bio *, int);
 		if (!is_orig_bio) {
 			bio_put(bio);
 			bio = bbio->orig_bio;
 		}
+		endio = bio->bi_end_io;
 		bio->bi_private = bbio->private;
 		bio->bi_end_io = bbio->end_io;
 		bio->bi_bdev = (struct block_device *)
@@ -5074,21 +5078,44 @@ static void btrfs_end_bio(struct bio *bio, int err)
 		/* only send an error to the higher layers if it is
 		 * beyond the tolerance of the btrfs bio
 		 */
-		if (atomic_read(&bbio->error) > bbio->max_errors) {
+		;
+		if ((errors = atomic_read(&bbio->error)) > bbio->max_errors) {
 			err = -EIO;
+			printk(KERN_ERR
+			       "btrfs_end_bio %s-EIO %i > %i pending %i end %p,%p\n",
+			       is_orig_bio ? "orig " : "",
+			       errors, bbio->max_errors, pending,
+			       endio, bio->bi_end_io);
 		} else {
 			/*
 			 * this bio is actually up to date, we didn't
 			 * go over the max number of errors
 			 */
 			set_bit(BIO_UPTODATE, &bio->bi_flags);
+			if (errors) {
+				printk(KERN_ERR
+				       "btrfs_end_bio %s retry %i <= %i pending %i end %p,%p\n",
+				       is_orig_bio ? "orig " : "",
+				       errors, bbio->max_errors, pending,
+				       endio, bio->bi_end_io);
+			}
 			err = 0;
 		}
 		kfree(bbio);
 
 		bio_endio(bio, err);
 	} else if (!is_orig_bio) {
+		errors = atomic_read(&bbio->error);
 		bio_put(bio);
+		if (errors) {
+			printk(KERN_ERR
+			       "btrfs_end_bio no-endio %i <?> %i pending %i\n",
+			       errors, bbio->max_errors, pending);
+		}
+	} else if ((errors = atomic_read(&bbio->error))) {
+		printk(KERN_ERR
+		       "btrfs_end_bio orig no-endio %i <?> %i pending %i\n",
+		       errors, bbio->max_errors, pending);
 	}
 }
 

--=-=-=



-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
