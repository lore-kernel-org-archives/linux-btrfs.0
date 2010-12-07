From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: RE: [PATCH] Btrfs: pwrite blocked when writing from the mmaped
 buffer of the same page
Date: Tue, 7 Dec 2010 17:34:09 +0800
Message-ID: <1865303E0DED764181A9D882DEF65FB682F3F80FDD@shsmsx502.ccr.corp.intel.com>
References: <1291713902-5149-1-git-send-email-xin.zhong@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "Zhong, Xin" <xin.zhong@intel.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291713902-5149-1-git-send-email-xin.zhong@intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

The previous patch is not ok (http://www.spinics.net/lists/linux-btrfs/msg07447.html).  Please ignore it. Thanks!

-----Original Message-----
From: Zhong, Xin 
Sent: Tuesday, December 07, 2010 5:25 PM
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
 fs/btrfs/file.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c1faded..805f2ee 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -57,11 +57,15 @@ static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
 				     PAGE_CACHE_SIZE - offset, write_bytes);
 		struct page *page = prepared_pages[pg];
 again:
-		if (unlikely(iov_iter_fault_in_readable(i, count)))
-			return -EFAULT;
-
-		/* Copy data from userspace to the current page */
-		copied = iov_iter_copy_from_user(page, i, offset, count);
+		/*
+		 * Copy data from userspace to the current page
+		 *
+		 * Disable pagefault to avoid recursive lock since
+		 * the pages are already locked
+		 */
+		pagefault_disable();
+		copied = iov_iter_copy_from_user_atomic(page, i, offset, count);
+		pagefault_enable();

 		/* Flush processor's dcache for this page */
 		flush_dcache_page(page);
@@ -974,6 +978,15 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		if (ret)
 			goto out;

+		/*
+		 * fault pages before locking them in prepare_pages
+		 * to avoid recursive lock
+		 */
+		if (unlikely(iov_iter_fault_in_readable(&i, write_bytes))) {
+			ret = -EFAULT;
+			goto out;
+		}
+
 		ret = prepare_pages(root, file, pages, num_pages,
 				    pos, first_index, last_index,
 				    write_bytes);
--
1.6.2.2

