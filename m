From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [PATCH] Include subvolume= and metadata_ratio= in /cat/proc
Date: Thu, 14 Jan 2010 20:59:25 +0100
Message-ID: <201001142100.00106.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1501621.pArRIRvnmJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1501621.pArRIRvnmJ
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

this patch include in /proc/mount the info about which subvolume is mounted=
=20
and which metadata_ratio value is used.

$ cat /proc/mounts
rootfs / rootfs rw 0 0
[...]
/dev/sdc /tmp/t4 btrfs rw,relatime,metadata_ratio=3D20 0 0
/dev/sdc /mnt/btrfs btrfs rw,relatime,degraded,metadata_ratio=3D20,subvol=
=3Dsnap-
of-root 0 0

BR
G.Baroncelli

commit 3d7ea7bbd70a66c4d0f369b2879c503b722e8834
Author: ghigo <ghigo@kreijack.homelinux.net>
Date:   Thu Jan 14 20:27:41 2010 +0100

    Add info about metadata_ratio and subvolume name

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3f9b457..faeaa7f 100644
=2D-- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -461,6 +461,16 @@ static int btrfs_show_options(struct seq_file *seq,=20
struct vfsmount *vfs)
 		seq_puts(seq, ",discard");
 	if (!(root->fs_info->sb->s_flags & MS_POSIXACL))
 		seq_puts(seq, ",noacl");
+	if( root->fs_info->metadata_ratio )
+		seq_printf(seq, ",metadata_ratio=3D%d",=20
+			root->fs_info->metadata_ratio);
+	spin_lock(&vfs->mnt_root->d_lock);
+	if (vfs->mnt_root->d_name.len !=3D 1 ||
+	    vfs->mnt_root->d_name.name[0] !=3D '/'){
+		seq_puts(seq, ",subvol=3D");
+		seq_puts(seq, vfs->mnt_root->d_name.name);
+	}
+	spin_unlock(&vfs->mnt_root->d_lock);
 	return 0;
 }
=20



=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.=
it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart1501621.pArRIRvnmJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLT3edvwTxYT3FBRIRAjPVAJ4vbNrxdyK6gkM3jK6LJPzNfIT7oACggAzU
OJhdPtWOfkjrxRP7YkgfOzU=
=tXzJ
-----END PGP SIGNATURE-----

--nextPart1501621.pArRIRvnmJ--
