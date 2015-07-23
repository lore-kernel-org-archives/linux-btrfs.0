Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29728 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752208AbbGWJSX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 05:18:23 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: print-tree: print stripe len of a chunk
Date: Thu, 23 Jul 2015 17:18:07 +0800
Message-ID: <1437643090-13920-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although it is fixed to BTRFS_STRIPE_LEN(64K) now, it's still used in a
lot of codes, just output it for user who want to trace the source of
stripe_len in btrfs_map_bio() codes.

Reported-by: Chris Murphy <lists@colorremedies.com>
Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/print-tree.c b/print-tree.c
index a72a979..dc1d276 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -224,9 +224,11 @@ void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 	char chunk_flags_str[32] = {0};
 
 	bg_flags_to_str(btrfs_chunk_type(eb, chunk), chunk_flags_str);
-	printf("\t\tchunk length %llu owner %llu type %s num_stripes %d\n",
+	printf("\t\tchunk length %llu owner %llu stripe_len %llu\n",
 	       (unsigned long long)btrfs_chunk_length(eb, chunk),
 	       (unsigned long long)btrfs_chunk_owner(eb, chunk),
+	       (unsigned long long)btrfs_chunk_stripe_len(eb, chunk));
+	printf("\t\ttype %s num_stripes %d\n",
 	       chunk_flags_str, num_stripes);
 	for (i = 0 ; i < num_stripes ; i++) {
 		printf("\t\t\tstripe %d devid %llu offset %llu\n", i,
-- 
2.4.6

