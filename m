From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: btrfs on MIPS with 16K page size
Date: Wed, 27 Jul 2011 01:49:55 +0600
Message-ID: <20110727014955.3d5df934@natsu>
References: <20110627010018.7133192e@natsu>
	<20110727010232.553f8480@natsu>
	<20110727013756.427c46fc@natsu>
	<20110727014648.20c9bdc4@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KRFOw8hrwWfK9u6SySRJ3Ld"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110727014648.20c9bdc4@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/KRFOw8hrwWfK9u6SySRJ3Ld
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Jul 2011 01:46:48 +0600
Roman Mamedov <rm@romanrm.ru> wrote:

> "WARNING: at fs/btrfs/inode.c:6775 btrfs_destroy_inode",
>=20
> void btrfs_destroy_inode(struct inode *inode)
> {
> 	struct btrfs_ordered_extent *ordered;
> 	struct btrfs_root *root =3D BTRFS_I(inode)->root;
>=20
> 6775->	WARN_ON(!list_empty(&inode->i_dentry));

Ah, nope, with the -rc6 source this is actually the line:

void btrfs_destroy_inode(struct inode *inode)
{
	struct btrfs_ordered_extent *ordered;
	struct btrfs_root *root =3D BTRFS_I(inode)->root;

	WARN_ON(!list_empty(&inode->i_dentry));
	WARN_ON(inode->i_data.nrpages);
>>>	WARN_ON(atomic_read(&BTRFS_I(inode)->outstanding_extents)); <<<
	WARN_ON(atomic_read(&BTRFS_I(inode)->reserved_extents));


--=20
With respect,
Roman

--Sig_/KRFOw8hrwWfK9u6SySRJ3Ld
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4vGmMACgkQTLKSvz+PZwi8zQCfRr6wTLzN2PQXt86Zo4MWqEPM
5aMAnRKnGeKjKmtZ9F8aUlxEmGIJ6FRU
=wH5f
-----END PGP SIGNATURE-----

--Sig_/KRFOw8hrwWfK9u6SySRJ3Ld--
