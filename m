Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4215 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbbKCGsO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Nov 2015 01:48:14 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tA36lYU1001031
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Nov 2015 14:47:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: print-tree: Output stripe dev uuid
Date: Tue, 3 Nov 2015 14:48:09 +0800
Message-ID: <1446533289-30373-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add output for dev uuid for print_chunk().

Quite useful to debug temporary btrfs in btrfs-convert.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/print-tree.c b/print-tree.c
index 7ddf400..4d4c3a2 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -231,9 +231,17 @@ void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 	printf("\t\ttype %s num_stripes %d\n",
 	       chunk_flags_str, num_stripes);
 	for (i = 0 ; i < num_stripes ; i++) {
+		unsigned char dev_uuid[BTRFS_UUID_SIZE];
+		char str_dev_uuid[BTRFS_UUID_UNPARSED_SIZE];
+
+		read_extent_buffer(eb, dev_uuid,
+			(unsigned long)btrfs_stripe_dev_uuid_nr(chunk, i),
+			BTRFS_UUID_SIZE);
+		uuid_unparse(dev_uuid, str_dev_uuid);
 		printf("\t\t\tstripe %d devid %llu offset %llu\n", i,
 		      (unsigned long long)btrfs_stripe_devid_nr(eb, chunk, i),
 		      (unsigned long long)btrfs_stripe_offset_nr(eb, chunk, i));
+		printf("\t\t\tdev uuid: %s\n", str_dev_uuid);
 	}
 }
 
-- 
2.6.2

