From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 1/3] Btrfs-progs, btrfs-map-logical: Fix typo in usage
Date: Thu, 23 Feb 2012 15:51:09 +0800
Message-ID: <4F45EFED.9010103@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The right option is 'o' not 'c'. And this tool is used for the block devices
on which there is a btrfs file system, so change "mount_point" to "device".

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfs-map-logical.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index d79a73a..fa4fb3f 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -84,7 +84,7 @@ struct extent_buffer *debug_read_block(struct btrfs_root *root, u64 bytenr,
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfs-map-logical [options] mount_point\n");
+	fprintf(stderr, "usage: btrfs-map-logical [options] device\n");
 	fprintf(stderr, "\t-l Logical extent to map\n");
 	fprintf(stderr, "\t-c Copy of the extent to read (usually 1 or 2)\n");
 	fprintf(stderr, "\t-o Output file to hold the extent\n");
@@ -96,7 +96,7 @@ static struct option long_options[] = {
 	/* { "byte-count", 1, NULL, 'b' }, */
 	{ "logical", 1, NULL, 'l' },
 	{ "copy", 1, NULL, 'c' },
-	{ "output", 1, NULL, 'c' },
+	{ "output", 1, NULL, 'o' },
 	{ "bytes", 1, NULL, 'b' },
 	{ 0, 0, 0, 0}
 };
-- 
1.7.6.5
