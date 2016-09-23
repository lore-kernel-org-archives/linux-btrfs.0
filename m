Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34309 "EHLO
        mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964947AbcIWAYf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 20:24:35 -0400
Received: by mail-pa0-f43.google.com with SMTP id wk8so34098764pab.1
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 17:24:35 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Anatoly Pugachev <matorola@gmail.com>
Subject: [PATCH v2 6/6] Btrfs: use less memory for delalloc sanity tests
Date: Thu, 22 Sep 2016 17:24:25 -0700
Message-Id: <c75f5b086bbf8ee43b2bb18e74aebcaeb81fa77a.1474580472.git.osandov@fb.com>
In-Reply-To: <218563982dbe4387c60909eeb0add6914a20f813.1474580472.git.osandov@fb.com>
References: <218563982dbe4387c60909eeb0add6914a20f813.1474580472.git.osandov@fb.com>
In-Reply-To: <cover.1474580472.git.osandov@fb.com>
References: <cover.1474580472.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

test_find_delalloc() allocates 256 MB worth of pages. That's all of the
RAM that my MIPS emulator has, so it ends up panicking after it OOM
kills everything. We don't actually need to use that much for this test.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/tests/extent-io-tests.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index caad80b..ea9c91b 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -73,8 +73,8 @@ static int test_find_delalloc(u32 sectorsize)
 	struct page *page;
 	struct page *locked_page = NULL;
 	unsigned long index = 0;
-	u64 total_dirty = SZ_256M;
-	u64 max_bytes = SZ_128M;
+	u64 total_dirty = sectorsize * 256;
+	u64 max_bytes = total_dirty >> 1;
 	u64 start, end, test_start;
 	u64 found;
 	int ret = -EINVAL;
@@ -138,7 +138,7 @@ static int test_find_delalloc(u32 sectorsize)
 	 * |--- delalloc ---|
 	 *           |--- search ---|
 	 */
-	test_start = SZ_64M;
+	test_start = max_bytes >> 1;
 	locked_page = find_lock_page(inode->i_mapping,
 				     test_start >> PAGE_SHIFT);
 	if (!locked_page) {
@@ -226,7 +226,7 @@ static int test_find_delalloc(u32 sectorsize)
 	 * range we want to find.
 	 */
 	page = find_get_page(inode->i_mapping,
-			     (max_bytes + SZ_1M) >> PAGE_SHIFT);
+			     (max_bytes + PAGE_SIZE) >> PAGE_SHIFT);
 	if (!page) {
 		test_msg("Couldn't find our page\n");
 		goto out_bits;
-- 
2.10.0

