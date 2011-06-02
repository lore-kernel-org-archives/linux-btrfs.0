From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH][RESEND] btrfs: separate superblock items out of fs_info
Date: Thu, 2 Jun 2011 21:36:43 +0300
Message-ID: <20110602213643.6d62caef@sf>
References: <1307031202-14029-1-git-send-email-dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XPrmDXx4plZGKmt0p8pgNc+"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307031202-14029-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/XPrmDXx4plZGKmt0p8pgNc+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu,  2 Jun 2011 18:13:22 +0200
David Sterba <dsterba@suse.cz> wrote:

> fs_info is now ~9kb, more than fits into one page. This will cause
> mount failure when memory is too fragmented. Top space consumers are
> super block structures super_copy and super_for_commit, ~2.8kb each.
> Allocate them dynamically. fs_info will be ~3.5kb. (measured on x86_64)
>=20
> Add a wrapper for freeing fs_info.
>=20
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
...
> @@ -801,6 +800,15 @@ static struct dentry *btrfs_mount(struct file_system=
_type *fs_type, int flags,
>  	fs_info->fs_devices =3D fs_devices;
>  	tree_root->fs_info =3D fs_info;
> =20
> +	fs_info->super_copy =3D kzalloc(sizeof(struct btrfs_super_block),
> +			GFP_NOFS);
> +	fs_info->super_for_commit =3D kzalloc(sizeof(struct btrfs_super_block),
> +			GFP_NOFS);

In light of http://thread.gmane.org/gmane.comp.file-systems.btrfs/11004/foc=
us=3D11038
what do you think of allocating BTRFS_SUPER_INFO_SIZE instead of sizeof?

> +	if (!fs_info->super_copy || !fs_info->super_for_commit) {
> +		error =3D -ENOMEM;
> +		goto error_close_devices;
> +	}
> +
>  	bdev =3D fs_devices->latest_bdev;
>  	s =3D sget(fs_type, btrfs_test_super, btrfs_set_super, tree_root);
>  	if (IS_ERR(s))

--=20

  Sergei

--Sig_/XPrmDXx4plZGKmt0p8pgNc+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk3n2D4ACgkQcaHudmEf86pKUQCeJNiMQoNLIuU+evMhlUlhlGin
TikAn2rpUQ1rgHApOS0V/pKlXCcrjGFz
=kNAQ
-----END PGP SIGNATURE-----

--Sig_/XPrmDXx4plZGKmt0p8pgNc+--
