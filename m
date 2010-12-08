From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix compile warning in fs/btrfs/inode.c
Date: Wed, 08 Dec 2010 18:01:18 +0800
Message-ID: <4CFF576E.8030505@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While compiling btrfs, I got belows:

  CC [M]  fs/btrfs/inode.o
fs/btrfs/inode.c: In function =E2=80=98btrfs_end_dio_bio=E2=80=99:
fs/btrfs/inode.c:5720: warning: format =E2=80=98%lu=E2=80=99 expects ty=
pe =E2=80=98long unsigned int=E2=80=99, but argument 4 has type =E2=80=98=
sector_t=E2=80=99
  LD [M]  fs/btrfs/btrfs.o
  Building modules, stage 2.
  MODPOST 1 modules
  LD [M]  fs/btrfs/btrfs.ko

This fixes the compile warning.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0f34cae..eff5aef 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5713,8 +5713,8 @@ static void btrfs_end_dio_bio(struct bio *bio, in=
t err)
 	if (err) {
 		printk(KERN_ERR "btrfs direct IO failed ino %lu rw %lu "
 		      "disk_bytenr %lu len %u err no %d\n",
-		      dip->inode->i_ino, bio->bi_rw, bio->bi_sector,
-		      bio->bi_size, err);
+		      dip->inode->i_ino, bio->bi_rw,
+		      (unsigned long)bio->bi_sector, bio->bi_size, err);
 		dip->errors =3D 1;
=20
 		/*
--=20
1.7.1
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
