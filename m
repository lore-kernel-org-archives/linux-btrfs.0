Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10174 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752684AbbFHMHc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jun 2015 08:07:32 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t58C5ucu032705
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Jun 2015 20:05:56 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: cleanup noused initialization of dev in btrfs_end_bio()
Date: Mon, 8 Jun 2015 20:05:50 +0800
Message-ID: <9f8bfeed7f5af89039d1a989275235c04976cb23.1433765143.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

It is introduced by:
 c404e0dc2c843b154f9a36c3aec10d0a715d88eb
 Btrfs: fix use-after-free in the finishing procedure of the device replace

But seems no relationship with that bug, this patch revirt these
code block for cleanup.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 174f5e1..1702adc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5596,7 +5596,6 @@ static inline void btrfs_end_bbio(struct btrfs_bio *bbio, struct bio *bio, int e
 static void btrfs_end_bio(struct bio *bio, int err)
 {
 	struct btrfs_bio *bbio = bio->bi_private;
-	struct btrfs_device *dev = bbio->stripes[0].dev;
 	int is_orig_bio = 0;
 
 	if (err) {
@@ -5604,6 +5603,7 @@ static void btrfs_end_bio(struct bio *bio, int err)
 		if (err == -EIO || err == -EREMOTEIO) {
 			unsigned int stripe_index =
 				btrfs_io_bio(bio)->stripe_index;
+			struct btrfs_device *dev;
 
 			BUG_ON(stripe_index >= bbio->num_stripes);
 			dev = bbio->stripes[stripe_index].dev;
-- 
1.8.5.1

