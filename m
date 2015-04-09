Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbbDIHtZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Apr 2015 03:49:25 -0400
Date: Thu, 9 Apr 2015 17:49:16 +1000
From: NeilBrown <neilb@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH/RFC] fscache/cachefiles versus btrfs
Message-ID: <20150409174916.5a2efef5@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/0PlgLnAyohhkPpMVYpzLyvU"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/0PlgLnAyohhkPpMVYpzLyvU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


hi,
 fscache cannot currently be used with btrfs as the backing store for the
 cache (managed by cachefilesd).
 This is because cachefiles needs the ->bmap address_space_operation, and
 btrfs doesn't provide it.

 cachefiles only uses this to find out if a particular page is a 'hole' or
 not.  For btrfs, this can be done with 'SEEK_DATA'.

 Unfortunately it doesn't seem to be possible to query a filesystem or a fi=
le
 to see if SEEK_DATA is reliable or not, so we cannot simply use SEEK_DATA
 when reliable, else ->bmap if available.

 The following patch make fscache work for me on btrfs.  It explicitly chec=
ks
 for BTRFS_SUPER_MAGIC.  Not really a nice solution, but all I could think =
of.

 Is there a better way?  Could a better way be created?  Maybe
 SEEK_DATA_RELIABLE ??

 Comments, suggestions welcome.


Also, if you do try to use fscache on btrfs with 3.19, then nothing gets
cached (as expected) and with a heavy load you can lose a race and get an
asserting fail in fscache_enqueue_operation

	ASSERT(fscache_object_is_available(op->object));

It looks like the object is being killed before it is available...

[  859.700765] kernel BUG at ../fs/fscache/operation.c:38!
...
[  859.703124] Call Trace:
[  859.703193]  [<ffffffffa0448044>] fscache_run_op.isra.4+0x34/0x80 [fscac=
he]
[  859.703260]  [<ffffffffa0448160>] fscache_start_operations+0xa0/0xf0 [fs=
cache]
[  859.703388]  [<ffffffffa0446cd8>] fscache_kill_object+0x98/0xc0 [fscache]
[  859.703455]  [<ffffffffa04475c1>] fscache_object_work_func+0x151/0x210 [=
fscache]
[  859.703578]  [<ffffffff81078b07>] process_one_work+0x147/0x3c0
[  859.703642]  [<ffffffff8107929c>] worker_thread+0x20c/0x470

I haven't figured out the cause of that yet.


Thanks,
NeilBrown




diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 1e51714eb33e..1389d8483d5d 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -20,6 +20,7 @@
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/slab.h>
+#include <linux/magic.h>
 #include "internal.h"
=20
 #define CACHEFILES_KEYBUF_SIZE 512
@@ -647,7 +648,8 @@ lookup_again:
=20
 			ret =3D -EPERM;
 			aops =3D object->dentry->d_inode->i_mapping->a_ops;
-			if (!aops->bmap)
+			if (!aops->bmap &&
+			    object->dentry->d_sb->s_magic !=3D BTRFS_SUPER_MAGIC)
 				goto check_error;
=20
 			object->backer =3D object->dentry;
diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index c6cd8d7a4eef..49fb330c0ab8 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -410,11 +410,11 @@ int cachefiles_read_or_alloc_page(struct fscache_retr=
ieval *op,
=20
 	inode =3D object->backer->d_inode;
 	ASSERT(S_ISREG(inode->i_mode));
-	ASSERT(inode->i_mapping->a_ops->bmap);
 	ASSERT(inode->i_mapping->a_ops->readpages);
=20
 	/* calculate the shift required to use bmap */
-	if (inode->i_sb->s_blocksize > PAGE_SIZE)
+	if (inode->i_mapping->a_ops->bmap &&
+	    inode->i_sb->s_blocksize > PAGE_SIZE)
 		goto enobufs;
=20
 	shift =3D PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
@@ -423,20 +423,36 @@ int cachefiles_read_or_alloc_page(struct fscache_retr=
ieval *op,
 	op->op.flags |=3D FSCACHE_OP_ASYNC;
 	op->op.processor =3D cachefiles_read_copier;
=20
-	/* we assume the absence or presence of the first block is a good
-	 * enough indication for the page as a whole
-	 * - TODO: don't use bmap() for this as it is _not_ actually good
-	 *   enough for this as it doesn't indicate errors, but it's all we've
-	 *   got for the moment
-	 */
-	block0 =3D page->index;
-	block0 <<=3D shift;
-
-	block =3D inode->i_mapping->a_ops->bmap(inode->i_mapping, block0);
-	_debug("%llx -> %llx",
-	       (unsigned long long) block0,
-	       (unsigned long long) block);
+	if (inode->i_mapping->a_ops->bmap) {
+		/* we assume the absence or presence of the first block is a good
+		 * enough indication for the page as a whole
+		 * - TODO: don't use bmap() for this as it is _not_ actually good
+		 *   enough for this as it doesn't indicate errors, but it's all we've
+		 *   got for the moment
+		 */
+		block0 =3D page->index;
+		block0 <<=3D shift;
=20
+		block =3D inode->i_mapping->a_ops->bmap(inode->i_mapping, block0);
+		_debug("%llx -> %llx",
+		       (unsigned long long) block0,
+		       (unsigned long long) block);
+	} else {
+		/* Use llseek */
+		struct path path;
+		struct file *file;
+		path.mnt =3D cache->mnt;
+		path.dentry =3D object->backer;
+		file =3D dentry_open(&path, O_RDONLY, cache->cache_cred);
+		if (IS_ERR(file))
+			goto enobufs;
+		block =3D vfs_llseek(file, page->index << PAGE_SHIFT, SEEK_DATA);
+		filp_close(file, NULL);
+		if (block !=3D page->index << PAGE_SHIFT)
+			block =3D 0;
+		else
+			block =3D 1;
+	}
 	if (block) {
 		/* submit the apparently valid page to the backing fs to be
 		 * read from disk */
@@ -707,11 +723,11 @@ int cachefiles_read_or_alloc_pages(struct fscache_ret=
rieval *op,
=20
 	inode =3D object->backer->d_inode;
 	ASSERT(S_ISREG(inode->i_mode));
-	ASSERT(inode->i_mapping->a_ops->bmap);
 	ASSERT(inode->i_mapping->a_ops->readpages);
=20
 	/* calculate the shift required to use bmap */
-	if (inode->i_sb->s_blocksize > PAGE_SIZE)
+	if (inode->i_mapping->a_ops->bmap &&
+	    inode->i_sb->s_blocksize > PAGE_SIZE)
 		goto all_enobufs;
=20
 	shift =3D PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
@@ -729,21 +745,38 @@ int cachefiles_read_or_alloc_pages(struct fscache_ret=
rieval *op,
 	list_for_each_entry_safe(page, _n, pages, lru) {
 		sector_t block0, block;
=20
-		/* we assume the absence or presence of the first block is a
-		 * good enough indication for the page as a whole
-		 * - TODO: don't use bmap() for this as it is _not_ actually
-		 *   good enough for this as it doesn't indicate errors, but
-		 *   it's all we've got for the moment
-		 */
-		block0 =3D page->index;
-		block0 <<=3D shift;
-
-		block =3D inode->i_mapping->a_ops->bmap(inode->i_mapping,
-						      block0);
-		_debug("%llx -> %llx",
-		       (unsigned long long) block0,
-		       (unsigned long long) block);
+		if (inode->i_mapping->a_ops->bmap) {
+			/* we assume the absence or presence of the first block is a
+			 * good enough indication for the page as a whole
+			 * - TODO: don't use bmap() for this as it is _not_ actually
+			 *   good enough for this as it doesn't indicate errors, but
+			 *   it's all we've got for the moment
+			 */
+			block0 =3D page->index;
+			block0 <<=3D shift;
+
+			block =3D inode->i_mapping->a_ops->bmap(inode->i_mapping,
+							      block0);
+			_debug("%llx -> %llx",
+			       (unsigned long long) block0,
+			       (unsigned long long) block);
=20
+		} else {
+			/* Use llseek */
+			struct path path;
+			struct file *file;
+			path.mnt =3D cache->mnt;
+			path.dentry =3D object->backer;
+			file =3D dentry_open(&path, O_RDONLY, cache->cache_cred);
+			if (IS_ERR(file))
+				goto all_enobufs;
+			block =3D vfs_llseek(file, page->index << PAGE_SHIFT, SEEK_DATA);
+			filp_close(file, NULL);
+			if (block !=3D page->index << PAGE_SHIFT)
+				block =3D 0;
+			else
+				block =3D 1;
+		}
 		if (block) {
 			/* we have data - add it to the list to give to the
 			 * backing fs */

--Sig_/0PlgLnAyohhkPpMVYpzLyvU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSYu/Dnsnt1WYoG5AQLOvg//U5M0EteugCF1Hv+f4lptPD0TDFMUlTlM
QW8ybK1YE5p7yxPASSwYdAlsj3x+3MsIrcjEV/00mjmbSncduqkeoo97ijb7DsL5
WN3hbTPequ/c3A9FDlQyEcri6zcBhObSmGXTtzPrOQtykIkP+GiyRegIgSCB2sj5
WumZMNHqAg8lyfyVf2xcExXEgDaNNM0mKeEO7c0LBBIk1b5mFbMXlGTjDA+DpVw6
xkfdVrS50tQNZaa8rgPhg+DEMVkNSGNpF46DT3MCve9UlJ5NXsPwRlFN1rsmxISm
xv6c4spX6MmtrnxvCdbAr5p5hMPR4+ocf/hOj62nl3Ido+9s7vBapx+TBXMlmYfY
2qwpmDDjAXDDwQ5ULKTna7g3d+l5x3H9zKQApYFR0yfNP8HE0MHm08yV9HX2VwG7
m9bYk/zesaWrcbmDKvZmpLRFK/SaWXSUKjjal71/HZaHRB6tAe8BPceR50WOIkFj
isW+dv9/BTIDB37ju8qmTwpCeDFgcUfk3KwgQL9h9iYJ7rBP/L+TIwfGT5bNkbND
2flN6+3dPeJym00mSI4BaFQ4YbLddmtWPZnost9w2A9vrnkLHsksSGMyPX6WvFTi
6HSDr6Yul1Izd8Fi+el9G2ZXbK8MFfmMeawogGUllF7+UvsO02u4DiOe8dRcHB7s
BA0HaU4MmVI=
=zMwj
-----END PGP SIGNATURE-----

--Sig_/0PlgLnAyohhkPpMVYpzLyvU--
