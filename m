Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45950 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbeABVjS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jan 2018 16:39:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w02Lb8rT152818
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Jan 2018 21:39:18 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2f8hua82vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jan 2018 21:39:17 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w02LdHPd029404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Jan 2018 21:39:17 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w02LdH8l001046
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Jan 2018 21:39:17 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: fix scrub to repair raid6 corruption
Date: Tue,  2 Jan 2018 13:36:42 -0700
Message-Id: <20180102203642.14105-2-bo.li.liu@oracle.com>
In-Reply-To: <20180102203642.14105-1-bo.li.liu@oracle.com>
References: <20180102203642.14105-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The raid6 corruption is that,
suppose that all disks can be read without problems and if the content
that was read out doesn't match its checksum, currently for raid6
btrfs at most retries twice,

- the 1st retry is to rebuild with all other stripes, it'll eventually
  be a raid5 xor rebuild,
- if the 1st fails, the 2nd retry will deliberately fail parity p so
  that it will do raid6 style rebuild,

however, the chances are that another non-parity stripe content also
has something corrupted, so that the above retries are not able to
return correct content.

We've fixed normal reads to rebuild raid6 correctly with more retries
in Patch "Btrfs: make raid6 rebuild retry more"[1], this is to fix
scrub to do the exactly same rebuild process.

[1]: https://patchwork.kernel.org/patch/10091755/

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/scrub.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 951e881..1bc3ee4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -301,6 +301,11 @@ static void __scrub_blocked_if_needed(struct btrfs_fs_info *fs_info);
 static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info);
 static void scrub_put_ctx(struct scrub_ctx *sctx);
 
+static inline int scrub_is_page_on_raid56(struct scrub_page *page)
+{
+	return page->recover &&
+	       (page->recover->bbio->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK);
+}
 
 static void scrub_pending_bio_inc(struct scrub_ctx *sctx)
 {
@@ -1323,15 +1328,34 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	 * could happen otherwise that a correct page would be
 	 * overwritten by a bad one).
 	 */
-	for (mirror_index = 0;
-	     mirror_index < BTRFS_MAX_MIRRORS &&
-	     sblocks_for_recheck[mirror_index].page_count > 0;
-	     mirror_index++) {
+	for (mirror_index = 0; ;mirror_index++) {
 		struct scrub_block *sblock_other;
 
 		if (mirror_index == failed_mirror_index)
 			continue;
-		sblock_other = sblocks_for_recheck + mirror_index;
+
+		/* raid56's mirror can be more than BTRFS_MAX_MIRRORS */
+		if (!scrub_is_page_on_raid56(sblock_bad->pagev[0])) {
+			if (mirror_index >= BTRFS_MAX_MIRRORS)
+				break;
+			if (!sblocks_for_recheck[mirror_index].page_count)
+				break;
+
+			sblock_other = sblocks_for_recheck + mirror_index;
+		} else {
+			struct scrub_recover *r = sblock_bad->pagev[0]->recover;
+			int max_allowed = r->bbio->num_stripes -
+						r->bbio->num_tgtdevs;
+
+			if (mirror_index >= max_allowed)
+				break;
+			if (!sblocks_for_recheck[1].page_count)
+				break;
+
+			ASSERT(failed_mirror_index == 0);
+			sblock_other = sblocks_for_recheck + 1;
+			sblock_other->pagev[0]->mirror_num = 1 + mirror_index;
+		}
 
 		/* build and submit the bios, check checksums */
 		scrub_recheck_block(fs_info, sblock_other, 0);
@@ -1671,26 +1695,22 @@ static void scrub_bio_wait_endio(struct bio *bio)
 	complete(bio->bi_private);
 }
 
-static inline int scrub_is_page_on_raid56(struct scrub_page *page)
-{
-	return page->recover &&
-	       (page->recover->bbio->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK);
-}
-
 static int scrub_submit_raid56_bio_wait(struct btrfs_fs_info *fs_info,
 					struct bio *bio,
 					struct scrub_page *page)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	int ret;
+	int mirror_num;
 
 	bio->bi_iter.bi_sector = page->logical >> 9;
 	bio->bi_private = &done;
 	bio->bi_end_io = scrub_bio_wait_endio;
 
+	mirror_num = page->sblock->pagev[0]->mirror_num;
 	ret = raid56_parity_recover(fs_info, bio, page->recover->bbio,
 				    page->recover->map_length,
-				    page->mirror_num, 0);
+				    mirror_num, 0);
 	if (ret)
 		return ret;
 
-- 
2.9.4

