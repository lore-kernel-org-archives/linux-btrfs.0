Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab3JGVnQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:43:16 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97LhGaw017186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:43:16 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 04/12] btrfs-progs: don't overflow read buffer in image
Date: Mon,  7 Oct 2013 14:42:57 -0700
Message-Id: <1381182185-10896-5-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-1-git-send-email-zab@redhat.com>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

search_for_chunk_blocks() allocates a fixed-size buffer and then reads
arbitrary u32 sized buffers in to it.  Instead let's fail if the item is
bigger than the buffer.  This was found by static analysis.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-image.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 7474642..03ad4e9 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2011,6 +2011,7 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 	u64 current_cluster = cluster_bytenr, bytenr;
 	u64 item_bytenr;
 	u32 bufsize, nritems, i;
+	u32 max_size = MAX_PENDING_SIZE * 2;
 	u8 *buffer, *tmp = NULL;
 	int ret = 0;
 
@@ -2020,7 +2021,7 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 		return -ENOMEM;
 	}
 
-	buffer = malloc(MAX_PENDING_SIZE * 2);
+	buffer = malloc(max_size);
 	if (!buffer) {
 		fprintf(stderr, "Error allocing buffer\n");
 		free(cluster);
@@ -2028,7 +2029,7 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 	}
 
 	if (mdres->compress_method == COMPRESS_ZLIB) {
-		tmp = malloc(MAX_PENDING_SIZE * 2);
+		tmp = malloc(max_size);
 		if (!tmp) {
 			fprintf(stderr, "Error allocing tmp buffer\n");
 			free(cluster);
@@ -2079,6 +2080,13 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 			bufsize = le32_to_cpu(item->size);
 			item_bytenr = le64_to_cpu(item->bytenr);
 
+			if (bufsize > max_size) {
+				fprintf(stderr, "item %u size %u too big\n",
+					i, bufsize);
+				ret = -EIO;
+				break;
+			}
+
 			if (mdres->compress_method == COMPRESS_ZLIB) {
 				ret = fread(tmp, bufsize, 1, mdres->in);
 				if (ret != 1) {
@@ -2088,7 +2096,7 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 					break;
 				}
 
-				size = MAX_PENDING_SIZE * 2;
+				size = max_size;
 				ret = uncompress(buffer,
 						 (unsigned long *)&size, tmp,
 						 bufsize);
-- 
1.7.11.7

