Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35055 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbbJSLm3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 07:42:29 -0400
Received: by pasz6 with SMTP id z6so28640929pas.2
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 04:42:29 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 03/10] btrfs-progs: remove deadcode around metadump_v2 in check_chunk_refs
Date: Mon, 19 Oct 2015 19:37:53 +0800
Message-Id: <1445254680-11102-4-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

metadump_v2 is initialized to 0 and never updated again. So remove the
deadcode.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

I'm not sure about this one, seems metadump_v2 should be initialized depending
on whether superblock has BTRFS_SUPER_FLAG_METADUMP_V2 flag set.

 cmds-check.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 80a7c29..118a274 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7597,7 +7597,6 @@ static int check_chunk_refs(struct chunk_record *chunk_rec,
 	u64 devid;
 	u64 offset;
 	u64 length;
-	int metadump_v2 = 0;
 	int i;
 	int ret = 0;
 
@@ -7610,8 +7609,7 @@ static int check_chunk_refs(struct chunk_record *chunk_rec,
 					       cache);
 		if (chunk_rec->length != block_group_rec->offset ||
 		    chunk_rec->offset != block_group_rec->objectid ||
-		    (!metadump_v2 &&
-		     chunk_rec->type_flags != block_group_rec->flags)) {
+		    chunk_rec->type_flags != block_group_rec->flags) {
 			if (!silent)
 				fprintf(stderr,
 					"Chunk[%llu, %u, %llu]: length(%llu), offset(%llu), type(%llu) mismatch with block group[%llu, %u, %llu]: offset(%llu), objectid(%llu), flags(%llu)\n",
@@ -7645,9 +7643,6 @@ static int check_chunk_refs(struct chunk_record *chunk_rec,
 		ret = 1;
 	}
 
-	if (metadump_v2)
-		return ret;
-
 	length = calc_stripe_length(chunk_rec->type_flags, chunk_rec->length,
 				    chunk_rec->num_stripes);
 	for (i = 0; i < chunk_rec->num_stripes; ++i) {
-- 
2.4.3

