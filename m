Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39157 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaJGGL4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 02:11:56 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs-progs: fix uninitialized warining in btrfs_calc_stripe_index
Date: Tue,  7 Oct 2014 06:17:02 +0800
Message-Id: <1412633822-15952-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <20141006171931.GD11436@twin.jikos.cz>
References: <20141006171931.GD11436@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

chunk-recover.c: In function ‘btrfs_calc_stripe_index’:
chunk-recover.c:1481: warning: ‘index’ may be used uninitialized in this function

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Accept David review comment
 chunk-recover.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 14c25a7..058a652 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1491,7 +1491,7 @@ static int btrfs_calc_stripe_index(struct chunk_record *chunk, u64 logical)
 		stripe_nr /= nr_data_stripes;
 		index = (index + stripe_nr) % chunk->num_stripes;
 	} else {
-		BUG_ON(1);
+		return -1;
 	}
 	return index;
 }
@@ -1554,6 +1554,7 @@ btrfs_rebuild_ordered_meta_chunk_stripes(struct recover_control *rc,
 again:
 	er = container_of(cache, struct extent_record, cache);
 	index = btrfs_calc_stripe_index(chunk, er->cache.start);
+	BUG_ON(index == -1);
 	if (chunk->stripes[index].devid)
 		goto next;
 	list_for_each_entry_safe(devext, next, &devexts, chunk_list) {
@@ -1944,6 +1945,7 @@ next_csum:
 	if (list_is_last(candidates.next, &candidates)) {
 		index = btrfs_calc_stripe_index(chunk,
 			key.offset + csum_offset * blocksize);
+		BUG_ON(index == -1);
 		if (chunk->stripes[index].devid)
 			goto next_stripe;
 		ret = insert_stripe(&candidates, rc, chunk, index);
-- 
2.0.0.153.g79dcccc

