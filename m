Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52312 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab3HAFhF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 01:37:05 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r715avKV009257
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Aug 2013 13:37:00 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/10] btrfs-progs: Update usage string of btrfs-map-logical
Date: Thu, 1 Aug 2013 13:35:32 +0800
Message-Id: <1375335334-32540-8-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-map-logical supports both short and long options, and also every option
should follow an arg,fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-map-logical.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index b9635f7..e46d812 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -86,10 +86,14 @@ struct extent_buffer *debug_read_block(struct btrfs_root *root, u64 bytenr,
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfs-map-logical [options] device\n");
-	fprintf(stderr, "\t-l Logical extent to map\n");
-	fprintf(stderr, "\t-c Copy of the extent to read (usually 1 or 2)\n");
-	fprintf(stderr, "\t-o Output file to hold the extent\n");
-	fprintf(stderr, "\t-b Number of bytes to read\n");
+	fprintf(stderr,
+		"\t-l|--logical <logical_num> Logical extent to map\n");
+	fprintf(stderr,
+		"\t-c|--copy <copy> Copy of the extent to read (usually 1 or 2)\n");
+	fprintf(stderr,
+		"\t-o|--output <filename> Output file to hold the extent\n");
+	fprintf(stderr,
+		"\t-b|--bytes <bytes> Number of bytes to read\n");
 	exit(1);
 }
 
-- 
1.8.0.1

