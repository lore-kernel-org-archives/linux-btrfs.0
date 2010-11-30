From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] btrfs: Correct printing of sector_t
Date: Tue, 30 Nov 2010 21:30:01 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1011302128450.6502@ayla.of.borg>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Cc: linux-btrfs@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Miao Xie <miaox@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If CONFIG_LBDAF=3Dy, `sector_t' becomes `u64' instead of `unsigned long=
':

fs/btrfs/inode.c: In function =A1btrfs_end_dio_bio=A2:
fs/btrfs/inode.c:5717: warning: format =A1%lu=A2 expects type =A1long u=
nsigned int=A2, but argument 4 has type =A1sector_t=A2

Hence always cast it to `unsigned long long' for printing.

Introduced by commit e65e1535542931e51189832264cd282e5899e4b9 ("btrfs: =
fix
panic caused by direct IO")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8039390..fbffe5f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5712,9 +5712,9 @@ static void btrfs_end_dio_bio(struct bio *bio, in=
t err)
=20
 	if (err) {
 		printk(KERN_ERR "btrfs direct IO failed ino %lu rw %lu "
-		      "disk_bytenr %lu len %u err no %d\n",
-		      dip->inode->i_ino, bio->bi_rw, bio->bi_sector,
-		      bio->bi_size, err);
+		      "disk_bytenr %llu len %u err no %d\n",
+		      dip->inode->i_ino, bio->bi_rw,
+		      (unsigned long long)bio->bi_sector, bio->bi_size, err);
 		dip->errors =3D 1;
=20
 		/*
--=20
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
							    -- Linus Torvalds
