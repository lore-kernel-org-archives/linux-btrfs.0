Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39842 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756081AbaFSCl0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 22:41:26 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J2fOaT024076
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 10:41:24 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/7] Btrfs: fix deadlock when mounting a degraded fs
Date: Thu, 19 Jun 2014 10:42:54 +0800
Message-ID: <1403145775-22641-7-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403145775-22641-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403145775-22641-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The deadlock happened when we mount degraded filesystem, the reproduced
steps are following:
 # mkfs.btrfs -f -m raid1 -d raid1 <dev0> <dev1>
 # echo 1 > /sys/block/`basename <dev0>`/device/delete
 # mount -o degraded <dev1> <mnt>

The reason was that the counter -- bi_remaining was wrong. If the missing
or unwriteable device was the last device in the mapping array, we would
not submit the original bio, so we shouldn't increase bi_remaining of it
in btrfs_end_bio(), or we would skip the final endio handle.

Fix this problem by adding a flag into btrfs bio structure. If we submit
the original bio, we will set the flag, and we increase bi_remaining counter,
or we don't.

Though there is another way to fix it -- decrease bi_remaining counter of the
original bio when we make sure the original bio is not submitted, this method
need add more check and is easy to make mistake.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 7 ++++++-
 fs/btrfs/volumes.h | 3 +++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 31f9036..4ca3c92 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5415,8 +5415,12 @@ static void btrfs_end_bio(struct bio *bio, int err)
 			set_bit(BIO_UPTODATE, &bio->bi_flags);
 			err = 0;
 		}
+
+		if (likely(bbio->flags & BTRFS_BIO_ORIG_BIO_SUBMITTED))
+			bio_endio_nodec(bio, err);
+		else
+			bio_endio(bio, err);
 		kfree(bbio);
-		bio_endio_nodec(bio, err);
 	} else if (!is_orig_bio) {
 		bio_put(bio);
 	}
@@ -5671,6 +5675,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 			BUG_ON(!bio); /* -ENOMEM */
 		} else {
 			bio = first_bio;
+			bbio->flags |= BTRFS_BIO_ORIG_BIO_SUBMITTED;
 		}
 
 		submit_stripe_bio(root, bbio, bio,
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1a15bbe..2aaa00c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -190,11 +190,14 @@ struct btrfs_bio_stripe {
 struct btrfs_bio;
 typedef void (btrfs_bio_end_io_t) (struct btrfs_bio *bio, int err);
 
+#define BTRFS_BIO_ORIG_BIO_SUBMITTED	0x1
+
 struct btrfs_bio {
 	atomic_t stripes_pending;
 	struct btrfs_fs_info *fs_info;
 	bio_end_io_t *end_io;
 	struct bio *orig_bio;
+	unsigned long flags;
 	void *private;
 	atomic_t error;
 	int max_errors;
-- 
1.9.3

