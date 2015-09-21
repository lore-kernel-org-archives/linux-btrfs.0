Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s7.hotmail.com ([65.55.116.18]:52356 "EHLO
	BLU004-OMC1S7.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbbIUDqU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 23:46:20 -0400
Message-ID: <BLU437-SMTP103A5A3F35BD11388D6FC65FF460@phx.gbl>
From: Shan Hai <haishan.bai@hotmail.com>
To: linux-btrfs@vger.kernel.org
CC: clm@fb.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] btrfs/file.c: remove an unsed varialbe first_index
Date: Mon, 21 Sep 2015 11:40:57 +0800
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <BLU437-SMTP103CD3FBBD84F09E5592AACFF460@phx.gbl>

From: Shan Hai <shan.hai@windriver.com>

The commit b37392ea86761 ("Btrfs: cleanup unnecessary parameter
and variant of prepare_pages()") makes it redundant.

Signed-off-by: Shan Hai <haishan.bai@hotmail.com>
---
 fs/btrfs/file.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b823fac..b6695c4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1469,7 +1469,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	u64 release_bytes = 0;
 	u64 lockstart;
 	u64 lockend;
-	unsigned long first_index;
 	size_t num_written = 0;
 	int nrptrs;
 	int ret = 0;
@@ -1485,8 +1484,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	if (!pages)
 		return -ENOMEM;
 
-	first_index = pos >> PAGE_CACHE_SHIFT;
-
 	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_CACHE_SIZE - 1);
 		size_t write_bytes = min(iov_iter_count(i),
-- 
2.1.4

