From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 6/7] debug-tree output: device speed added; type output switched to hex
Date: Tue,  1 Feb 2011 14:54:49 +0100
Message-ID: <1296568490-13264-7-git-send-email-list.btrfs@jan-o-sch.net>
References: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
Cc: chris.mason@oracle.com, sensille@gmx.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 print-tree.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index ac575d5..79a2f21 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -83,7 +83,7 @@ static void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 {
 	int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
 	int i;
-	printf("\t\tchunk length %llu owner %llu type %llu num_stripes %d\n",
+	printf("\t\tchunk length %llu owner %llu type 0x%llx num_stripes %d\n",
 	       (unsigned long long)btrfs_chunk_length(eb, chunk),
 	       (unsigned long long)btrfs_chunk_owner(eb, chunk),
 	       (unsigned long long)btrfs_chunk_type(eb, chunk),
@@ -98,10 +98,11 @@ static void print_dev_item(struct extent_buffer *eb,
 			   struct btrfs_dev_item *dev_item)
 {
 	printf("\t\tdev item devid %llu "
-	       "total_bytes %llu bytes used %Lu\n",
+	       "total_bytes %llu bytes used %Lu speed %u\n",
 	       (unsigned long long)btrfs_device_id(eb, dev_item),
 	       (unsigned long long)btrfs_device_total_bytes(eb, dev_item),
-	       (unsigned long long)btrfs_device_bytes_used(eb, dev_item));
+	       (unsigned long long)btrfs_device_bytes_used(eb, dev_item),
+	       btrfs_device_seek_speed(eb, dev_item));
 }
 
 static void print_uuids(struct extent_buffer *eb)
-- 
1.7.2.2

