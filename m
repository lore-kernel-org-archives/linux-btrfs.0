From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Sun, 06 Mar 2011 19:58:30 -0500
Message-ID: <1299459296-sup-3057@think>
References: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl> <AANLkTi=6G2A1Lb6aWwtFeLgJvV2k_syss4rRfokbFG56@mail.gmail.com> <1865303E0DED764181A9D882DEF65FB68662CD02C8@shsmsx502.ccr.corp.intel.com> <1299203447-sup-9359@think> <1299241124-sup-3502@think> <BAY156-w4980F081E2593ACCC07B2AD2C20@phx.gbl> <AANLkTikFVd3kG4J99BQvVUwb05DRQXLyabsHieeTZCBW@mail.gmail.com> <AANLkTinjtx37eJ+v6WS=Y8z_Brkb9YGq5cZdFP1bVWGB@mail.gmail.com> <BAY156-w342CF81501D00C36A69EABD2C50@phx.gbl> <AANLkTimDvTraBapv18iOf8wmUh8nSnUay2etXvjEv77P@mail.gmail.com> <AANLkTi=gqurEsoMZv+10Np4duOKq4kZf77mTgu6BfkSC@mail.gmail.com> <1299434330-sup-8189@think>
Content-Type: text/plain; charset=UTF-8
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	Xin Zhong <thierryzhong@hotmail.com>,
	"xin.zhong" <xin.zhong@intel.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1299434330-sup-8189@think>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chris Mason's message of 2011-03-06 13:00:27 -0500:
> Excerpts from Mitch Harder's message of 2011-03-05 11:50:14 -0500:
> > I've constructed a test patch that is currently addressing all the
> > issues on my system.
> > 
> > The portion of Openmotif that was having issues with page faults works
> > correctly with this patch, and gcc-4.4.5 builds without issue.
> > 
> > I extracted only the portion of the first patch that corrects the
> > handling of dirty_pages when copied==0, and incorporated the second
> > patch that falls back to one-page-at-a-time if there are troubles with
> > page faults.
> 
> Just to make sure I understand, could you please post the full combined
> path that was giving you trouble with gcc?  We do need to make sure the
> pages are properly up to date if we fall back to partial writes.

Ok, I was able to reproduce this easily with fsx.  The problem is that I
wasn't making sure the last partial page in the write was up to date
when it was also the first page in the write.

Here is the updated patch, it has all the fixes we've found so far:

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7084140..5986ac7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -763,6 +763,27 @@ out:
 }
 
 /*
+ * on error we return an unlocked page and the error value
+ * on success we return a locked page and 0
+ */
+static int prepare_uptodate_page(struct page *page, u64 pos)
+{
+	int ret = 0;
+
+	if ((pos & (PAGE_CACHE_SIZE - 1)) && !PageUptodate(page)) {
+		ret = btrfs_readpage(NULL, page);
+		if (ret)
+			return ret;
+		lock_page(page);
+		if (!PageUptodate(page)) {
+			unlock_page(page);
+			return -EIO;
+		}
+	}
+	return 0;
+}
+
+/*
  * this gets pages into the page cache and locks them down, it also properly
  * waits for data=ordered extents to finish before allowing the pages to be
  * modified.
@@ -777,6 +798,7 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
 	unsigned long index = pos >> PAGE_CACHE_SHIFT;
 	struct inode *inode = fdentry(file)->d_inode;
 	int err = 0;
+	int faili = 0;
 	u64 start_pos;
 	u64 last_pos;
 
@@ -794,15 +816,24 @@ again:
 	for (i = 0; i < num_pages; i++) {
 		pages[i] = grab_cache_page(inode->i_mapping, index + i);
 		if (!pages[i]) {
-			int c;
-			for (c = i - 1; c >= 0; c--) {
-				unlock_page(pages[c]);
-				page_cache_release(pages[c]);
-			}
-			return -ENOMEM;
+			faili = i - 1;
+			err = -ENOMEM;
+			goto fail;
+		}
+
+		if (i == 0)
+			err = prepare_uptodate_page(pages[i], pos);
+		if (i == num_pages - 1)
+			err = prepare_uptodate_page(pages[i],
+						    pos + write_bytes);
+		if (err) {
+			page_cache_release(pages[i]);
+			faili = i - 1;
+			goto fail;
 		}
 		wait_on_page_writeback(pages[i]);
 	}
+	err = 0;
 	if (start_pos < inode->i_size) {
 		struct btrfs_ordered_extent *ordered;
 		lock_extent_bits(&BTRFS_I(inode)->io_tree,
@@ -842,6 +873,14 @@ again:
 		WARN_ON(!PageLocked(pages[i]));
 	}
 	return 0;
+fail:
+	while (faili >= 0) {
+		unlock_page(pages[faili]);
+		page_cache_release(pages[faili]);
+		faili--;
+	}
+	return err;
+
 }
 
 static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
@@ -851,7 +890,6 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct page *pinned[2];
 	struct page **pages = NULL;
 	struct iov_iter i;
 	loff_t *ppos = &iocb->ki_pos;
@@ -872,9 +910,6 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	will_write = ((file->f_flags & O_DSYNC) || IS_SYNC(inode) ||
 		      (file->f_flags & O_DIRECT));
 
-	pinned[0] = NULL;
-	pinned[1] = NULL;
-
 	start_pos = pos;
 
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
@@ -962,32 +997,6 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	first_index = pos >> PAGE_CACHE_SHIFT;
 	last_index = (pos + iov_iter_count(&i)) >> PAGE_CACHE_SHIFT;
 
-	/*
-	 * there are lots of better ways to do this, but this code
-	 * makes sure the first and last page in the file range are
-	 * up to date and ready for cow
-	 */
-	if ((pos & (PAGE_CACHE_SIZE - 1))) {
-		pinned[0] = grab_cache_page(inode->i_mapping, first_index);
-		if (!PageUptodate(pinned[0])) {
-			ret = btrfs_readpage(NULL, pinned[0]);
-			BUG_ON(ret);
-			wait_on_page_locked(pinned[0]);
-		} else {
-			unlock_page(pinned[0]);
-		}
-	}
-	if ((pos + iov_iter_count(&i)) & (PAGE_CACHE_SIZE - 1)) {
-		pinned[1] = grab_cache_page(inode->i_mapping, last_index);
-		if (!PageUptodate(pinned[1])) {
-			ret = btrfs_readpage(NULL, pinned[1]);
-			BUG_ON(ret);
-			wait_on_page_locked(pinned[1]);
-		} else {
-			unlock_page(pinned[1]);
-		}
-	}
-
 	while (iov_iter_count(&i) > 0) {
 		size_t offset = pos & (PAGE_CACHE_SIZE - 1);
 		size_t write_bytes = min(iov_iter_count(&i),
@@ -1024,8 +1033,20 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 
 		copied = btrfs_copy_from_user(pos, num_pages,
 					   write_bytes, pages, &i);
-		dirty_pages = (copied + offset + PAGE_CACHE_SIZE - 1) >>
-				PAGE_CACHE_SHIFT;
+
+		/*
+		 * if we have trouble faulting in the pages, fall
+		 * back to one page at a time
+		 */
+		if (copied < write_bytes)
+			nrptrs = 1;
+
+		if (copied == 0)
+			dirty_pages = 0;
+		else
+			dirty_pages = (copied + offset +
+				       PAGE_CACHE_SIZE - 1) >>
+				       PAGE_CACHE_SHIFT;
 
 		if (num_pages > dirty_pages) {
 			if (copied > 0)
@@ -1069,10 +1090,6 @@ out:
 		err = ret;
 
 	kfree(pages);
-	if (pinned[0])
-		page_cache_release(pinned[0]);
-	if (pinned[1])
-		page_cache_release(pinned[1]);
 	*ppos = pos;
 
 	/*
