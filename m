From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: fix compiler warning in file.c
Date: Wed, 30 Mar 2011 09:57:23 +0900
Message-ID: <4D927FF3.6050300@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Chris Mason <chris.mason@oracle.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While compiling Btrfs, I got following messages:

  CC [M]  fs/btrfs/file.o
fs/btrfs/file.c: In function '__btrfs_buffered_write':
fs/btrfs/file.c:909: warning: 'ret' may be used uninitialized in this function
  CC [M]  fs/btrfs/tree-defrag.o

This patch fixes compiler warning.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -urNp linux-2.6.39-rc1/fs/btrfs/file.c linux-2.6.39-rc1.new/fs/btrfs/file.c
--- linux-2.6.39-rc1/fs/btrfs/file.c	2011-03-30 04:09:47.000000000 +0900
+++ linux-2.6.39-rc1.new/fs/btrfs/file.c	2011-03-30 09:41:49.000000000 +0900
@@ -906,7 +906,7 @@ static noinline ssize_t __btrfs_buffered
 	unsigned long last_index;
 	size_t num_written = 0;
 	int nrptrs;
-	int ret;
+	int ret = 0;
 
 	nrptrs = min((iov_iter_count(i) + PAGE_CACHE_SIZE - 1) /
 		     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /


