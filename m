Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54824 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab2INC3D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 22:29:03 -0400
Received: by qaas11 with SMTP id s11so3656988qaa.19
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 19:29:02 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Sep 2012 10:29:02 +0800
Message-ID: <CAPgLHd_pvtMjXoJWaOSGG-DprQVECpWtYc9SoTAXYcyX4wiq7A@mail.gmail.com>
Subject: [PATCH] Btrfs: using for_each_set_bit_from to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: chris.mason@fusionio.com
Cc: yongjun_wei@trendmicro.com.cn, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using for_each_set_bit_from() to simplify the code.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/btrfs/free-space-cache.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6b10acf..b107e68 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1454,9 +1454,7 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
 			  max_t(u64, *offset, bitmap_info->offset));
 	bits = bytes_to_bits(*bytes, ctl->unit);
 
-	for (i = find_next_bit(bitmap_info->bitmap, BITS_PER_BITMAP, i);
-	     i < BITS_PER_BITMAP;
-	     i = find_next_bit(bitmap_info->bitmap, BITS_PER_BITMAP, i + 1)) {
+	for_each_set_bit_from(i, bitmap_info->bitmap, BITS_PER_BITMAP) {
 		next_zero = find_next_zero_bit(bitmap_info->bitmap,
 					       BITS_PER_BITMAP, i);
 		if ((next_zero - i) >= bits) {
@@ -2307,9 +2305,7 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
 
 again:
 	found_bits = 0;
-	for (i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, i);
-	     i < BITS_PER_BITMAP;
-	     i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, i + 1)) {
+	for_each_set_bit_from(i, entry->bitmap, BITS_PER_BITMAP) {
 		next_zero = find_next_zero_bit(entry->bitmap,
 					       BITS_PER_BITMAP, i);
 		if (next_zero - i >= min_bits) {

