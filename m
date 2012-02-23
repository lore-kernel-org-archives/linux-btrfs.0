From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/3] Btrfs-progs, btrfs-corrupt-block: fix the wrong usage
Date: Thu, 23 Feb 2012 15:52:05 +0800
Message-ID: <4F45F025.1020204@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The old usage is a copy of btrfs-map-logical, it's wrong, fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
This patch is against dangerdonteveruse branch.
---
 btrfs-corrupt-block.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 9ad3e05..df84c81 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -85,11 +85,13 @@ struct extent_buffer *debug_corrupt_block(struct btrfs_root *root, u64 bytenr,
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfs-map-logical [options] mount_point\n");
-	fprintf(stderr, "\t-l Logical extent to map\n");
-	fprintf(stderr, "\t-c Copy of the extent to read (usually 1 or 2)\n");
-	fprintf(stderr, "\t-o Output file to hold the extent\n");
-	fprintf(stderr, "\t-b Number of bytes to read\n");
+	fprintf(stderr, "usage: btrfs-corrupt-block [options] device\n");
+	fprintf(stderr, "\t-l Logical extent to be corrupted\n");
+	fprintf(stderr, "\t-c Copy of the extent to be corrupted"
+		" (usually 1 or 2, default: 0)\n");
+	fprintf(stderr, "\t-b Number of bytes to be corrupted\n");
+	fprintf(stderr, "\t-e Extent to be corrupted\n");
+	fprintf(stderr, "\t-E The whole extent free to be corrupted\n");
 	exit(1);
 }
 
@@ -244,7 +246,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:eE", long_options,
+		c = getopt_long(ac, av, "l:c:b:eE", long_options,
 				&option_index);
 		if (c < 0)
 			break;
-- 
1.7.6.5
