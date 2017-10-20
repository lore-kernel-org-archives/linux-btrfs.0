Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:54162 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbdJTB7R (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 19 Oct 2017 21:59:17 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/7] btrfs-progs: mkfs: Only zero out the first 1M for rootdir
Date: Fri, 20 Oct 2017 09:59:03 +0800
Message-Id: <20171020015907.25430-4-wqu@suse.com>
In-Reply-To: <20171020015907.25430-1-wqu@suse.com>
References: <20171020015907.25430-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's a waste of IO to fill the whole image before creating btrfs on it,
just wiping the first 1M, and then write 1 byte to the last position to
create a sparse file.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 1355089505ca..7b78cfe3550e 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -404,18 +404,25 @@ static int zero_output_file(int out_fd, u64 size)
 {
 	int loop_num;
 	u64 location = 0;
-	char buf[4096];
+	char buf[SZ_4K];
 	int ret = 0, i;
 	ssize_t written;
 
-	memset(buf, 0, 4096);
-	loop_num = size / 4096;
+	memset(buf, 0, SZ_4K);
+
+	/* Only zero out the first 1M */
+	loop_num = SZ_1M / SZ_4K;
 	for (i = 0; i < loop_num; i++) {
-		written = pwrite64(out_fd, buf, 4096, location);
-		if (written != 4096)
+		written = pwrite64(out_fd, buf, SZ_4K, location);
+		if (written != SZ_4K)
 			ret = -EIO;
-		location += 4096;
+		location += SZ_4K;
 	}
+
+	/* Then enlarge the file to size */
+	written = pwrite64(out_fd, buf, 1, size - 1);
+	if (written < 1)
+		ret = -EIO;
 	return ret;
 }
 
-- 
2.14.2

