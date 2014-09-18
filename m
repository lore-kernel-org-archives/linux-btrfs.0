Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45385 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751188AbaIREWV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 00:22:21 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8I4MQKk012944
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 12:22:26 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] btrfs-progs: Add data_offset and data_len output for print_file_extent_item
Date: Thu, 18 Sep 2014 12:22:17 +0800
Message-ID: <1411014138-20124-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1411014138-20124-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1411014138-20124-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add data_offset and data_len output for print_file_extent_item in
print-tree.c

WARNING: because the original output has word 'data' before 'offset',
to avoid confusion, remove the work 'data' before 'offset' and 'disk
bytenr'.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 7df5798..9b416bd 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -277,23 +277,29 @@ static void print_file_extent_item(struct extent_buffer *eb,
 		return;
 	}
 	if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
-		printf("\t\tprealloc data disk byte %llu nr %llu\n",
+		printf("\t\tprealloc disk byte %llu nr %llu\n",
 		  (unsigned long long)btrfs_file_extent_disk_bytenr(eb, fi),
 		  (unsigned long long)btrfs_file_extent_disk_num_bytes(eb, fi));
-		printf("\t\tprealloc data offset %llu nr %llu\n",
+		printf("\t\tprealloc offset %llu nr %llu\n",
 		  (unsigned long long)btrfs_file_extent_offset(eb, fi),
 		  (unsigned long long)btrfs_file_extent_num_bytes(eb, fi));
 		return;
 	}
-	printf("\t\textent data disk byte %llu nr %llu\n",
+	printf("\t\textent disk byte %llu nr %llu\n",
 		(unsigned long long)btrfs_file_extent_disk_bytenr(eb, fi),
 		(unsigned long long)btrfs_file_extent_disk_num_bytes(eb, fi));
-	printf("\t\textent data offset %llu nr %llu ram %llu\n",
+	printf("\t\textent offset %llu nr %llu ram %llu\n",
 		(unsigned long long)btrfs_file_extent_offset(eb, fi),
 		(unsigned long long)btrfs_file_extent_num_bytes(eb, fi),
 		(unsigned long long)btrfs_file_extent_ram_bytes(eb, fi));
 	printf("\t\textent compression %d\n",
 	       btrfs_file_extent_compression(eb, fi));
+	if (btrfs_item_size_nr(eb, slot) > sizeof(*fi))
+		printf("\t\tdata offset %llu nr %llu\n",
+		       (unsigned long long)
+		       btrfs_ondemand_file_extent_data_offset(eb, slot, fi),
+		       (unsigned long long)
+		       btrfs_ondemand_file_extent_data_len(eb, slot, fi));
 }
 
 /* Caller should ensure sizeof(*ret) >= 16("DATA|TREE_BLOCK") */
-- 
2.1.0

