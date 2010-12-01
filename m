From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: Correct printing of sector_t
Date: Wed, 01 Dec 2010 09:33:25 +0800
Message-ID: <4CF5A5E5.5040404@cn.fujitsu.com>
References: <alpine.DEB.2.00.1011302128450.6502@ayla.of.borg>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-7
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1011302128450.6502@ayla.of.borg>
List-ID: <linux-btrfs.vger.kernel.org>

Geert Uytterhoeven wrote:
> If CONFIG_LBDAF=3Dy, `sector_t' becomes `u64' instead of `unsigned lo=
ng':
>=20
> fs/btrfs/inode.c: In function =A1btrfs_end_dio_bio=A2:
> fs/btrfs/inode.c:5717: warning: format =A1%lu=A2 expects type =A1long=
 unsigned int=A2, but argument 4 has type =A1sector_t=A2
>=20
> Hence always cast it to `unsigned long long' for printing.
>=20
> Introduced by commit e65e1535542931e51189832264cd282e5899e4b9 ("btrfs=
: fix
> panic caused by direct IO")
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

While we are at this..

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[PATCH] btrfs: Fix compile warning when CONFIG_MIGRATION is not set

=46ix this newly introduced warning:

fs/btrfs/disk-io.c:699: warning: 'btree_migratepage' defined but not us=
ed

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 33b6d45..7648247 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -696,6 +696,7 @@ static int btree_submit_bio_hook(struct inode *inod=
e, int rw, struct bio *bio,
 				   __btree_submit_bio_done);
 }
=20
+#ifdef CONFIG_MIGRATION
 static int btree_migratepage(struct address_space *mapping,
 			struct page *newpage, struct page *page)
 {
@@ -712,12 +713,10 @@ static int btree_migratepage(struct address_space=
 *mapping,
 	if (page_has_private(page) &&
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
-#ifdef CONFIG_MIGRATION
+
 	return migrate_page(mapping, newpage, page);
-#else
-	return -ENOSYS;
-#endif
 }
+#endif
=20
 static int btree_writepage(struct page *page, struct writeback_control=
 *wbc)
 {
--=20
1.6.3
