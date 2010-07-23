From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [2.6.35-rc6 patch] direct I/O submission fixes
Date: Sat, 24 Jul 2010 00:01:59 +0100
Message-ID: <AANLkTinGy=mJjXJZ1YmmpHKsvL0E6O0kn2pSPBcQ5mcP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

This fixes some issues relating to direct I/O submission, however a
further patch will be needed to handle the case where allocation of
'dip' fails, which is always dereferenced when finding the ordered
extent.

Thanks,
  Daniel

---

Fix use-after-free, potential leak of 'dip' and double assignment.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1bff92a..302e6d0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5652,7 +5652,6 @@ static void btrfs_submit_direct(int rw, struct
bio *bio, struct inode *inode,
 		ret = -ENOMEM;
 		goto free_ordered;
 	}
-	dip->csums = NULL;

 	if (!skip_sum) {
 		dip->csums = kmalloc(sizeof(u32) * bio->bi_vcnt, GFP_NOFS);
@@ -5660,7 +5659,8 @@ static void btrfs_submit_direct(int rw, struct
bio *bio, struct inode *inode,
 			ret = -ENOMEM;
 			goto free_ordered;
 		}
-	}
+	} else
+		dip->csums = NULL;

 	dip->private = bio->bi_private;
 	dip->inode = inode;
@@ -5704,7 +5704,6 @@ static void btrfs_submit_direct(int rw, struct
bio *bio, struct inode *inode,
 	return;
 out_err:
 	kfree(dip->csums);
-	kfree(dip);
 free_ordered:
 	/*
 	 * If this is a write, we need to clean up the reserved space and kill
@@ -5722,6 +5721,7 @@ free_ordered:
 		btrfs_put_ordered_extent(ordered);
 	}
 	bio_endio(bio, ret);
+	kfree(dip);
 }

 static ssize_t check_direct_IO(struct btrfs_root *root, int rw,
struct kiocb *iocb,
-- 
Daniel J Blueman
