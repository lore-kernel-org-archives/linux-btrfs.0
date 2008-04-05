From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: [PATCH] define write_cache_pages for linux kernel <=
	2.6.20 instead of 2.6.18
Date: Sat, 5 Apr 2008 20:40:06 +0100
Message-ID: <f058a9c30804051240m6a4cad0fwa8608906109d399@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
Return-path: <btrfs-devel-bounces@oss.oracle.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/btrfs-devel>
List-Post: <mailto:btrfs-devel@oss.oracle.com>
List-Help: <mailto:btrfs-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=subscribe>
Errors-To: btrfs-devel-bounces@oss.oracle.com
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
write_cache_pages doesn't exist in linux 2.6.20,  change the #if
condition to match that.

diff -r 4b838034355c extent_io.c
--- a/extent_io.c       Sat Apr 05 19:06:30 2008 +0100
+++ b/extent_io.c       Sat Apr 05 20:36:59 2008 +0100
@@ -2096,7 +2096,7 @@ done:
        return 0;
 }

-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,18)
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,20)

 /* Taken directly from 2.6.23 for 2.6.18 back port */
 typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,


-- 
Miguel Sousa Filipe
