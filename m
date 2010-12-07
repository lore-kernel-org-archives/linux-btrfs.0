From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: RE: [PATCH] Btrfs: pwrite blocked when writing from the mmaped
 buffer of the same page
Date: Tue, 7 Dec 2010 17:23:35 +0800
Message-ID: <1865303E0DED764181A9D882DEF65FB682F3F80FCB@shsmsx502.ccr.corp.intel.com>
References: <1291708775-4484-1-git-send-email-xin.zhong@intel.com>
 <1865303E0DED764181A9D882DEF65FB682F3F80F97@shsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "Zhong, Xin" <xin.zhong@intel.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1865303E0DED764181A9D882DEF65FB682F3F80F97@shsmsx502.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, the format of the patch is not correct. I will submit again.

-----Original Message-----
From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Zhong, Xin
Sent: Tuesday, December 07, 2010 4:46 PM
To: linux-btrfs@vger.kernel.org
Subject: RE: [PATCH] Btrfs: pwrite blocked when writing from the mmaped buffer of the same page

The other filesystems such as ext3 do not have this problem since they are using generic_file_buffered_write(). And this problem is fixed back in 2007 for generic_file_buffered_write():
http://lkml.org/lkml/2007/2/4/26

I am very new to btrfs. I am wondering why btrfs has it's own write routine?
Thanks!

-----Original Message-----
From: Zhong, Xin 
Sent: Tuesday, December 07, 2010 4:00 PM
To: linux-btrfs@vger.kernel.org
Cc: Zhong, Xin
Subject: [PATCH] Btrfs: pwrite blocked when writing from the mmaped buffer of the same page

This problem is found in meego testing:
http://bugs.meego.com/show_bug.cgi?id=6672
A file in btrfs is mmaped and the mmaped buffer is passed to pwrite to write to the same page
of the same file. In btrfs_file_aio_write(), the pages is locked by prepare_pages(). So when
btrfs_copy_from_user() is called, page fault happens and the same page needs to be locked again
in filemap_fault(). The fix is to move iov_iter_fault_in_readable() before prepage_pages() to make page
fault happen before pages are locked. And also disable page fault in critical region in
btrfs_copy_from_user().

Signed-off-by: Xin Zhong <xin.zhong@intel.com>
---
 fs/btrfs/file.c |   23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index dfe15dc..c1faded 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -57,15 +57,11 @@ static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
 				     PAGE_CACHE_SIZE - offset, write_bytes);
 		struct page *page = prepared_pages[pg];
 again:
-		/* 
-		 * Copy data from userspace to the current page 
-		 *
-		 * Disable pagefault to avoid recursive lock since the pages 
-		 * are already locked
-		 */
-		pagefault_disable();
-		copied = iov_iter_copy_from_user_atomic(page, i, offset, count);
-		pagefault_enable();
+		if (unlikely(iov_iter_fault_in_readable(i, count)))
+			return -EFAULT;
+
+		/* Copy data from userspace to the current page */
+		copied = iov_iter_copy_from_user(page, i, offset, count);
 
 		/* Flush processor's dcache for this page */
 		flush_dcache_page(page);
@@ -978,15 +974,6 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		if (ret)
 			goto out;
 
-		/* 
-		 * fault pages before locking them in prepare_pages 
-		 * to avoid recursive lock 
-                 */
-		if (unlikely(iov_iter_fault_in_readable(&i, write_bytes))) {
-			ret = -EFAULT;
-			goto out;
-		}
-
 		ret = prepare_pages(root, file, pages, num_pages,
 				    pos, first_index, last_index,
 				    write_bytes);
-- 
1.6.2.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
