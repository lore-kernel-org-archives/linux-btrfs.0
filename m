From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] btrfs: fix double-free 'tree_root' in 'btrfs_mount()'
Date: Mon, 7 Nov 2011 12:37:37 +0300
Message-ID: <20111107123737.73ff1a94@sf.home>
References: <1320657127-3561-1-git-send-email-slyich@gmail.com>
	<20111107091005.GA17056@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hGE7Gghw3FNe96zQ+UWTXLo"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org,
	Sergei Trofimovich <slyfox@gentoo.org>,
	Arne Jansen <sensille@gmx.net>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111107091005.GA17056@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/hGE7Gghw3FNe96zQ+UWTXLo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> >     bdev=3D/dev/ubda
> >     btr_root=3D/btr
> >     /mkfs.btrfs $bdev
> >     mount $bdev $btr_root
> >     mkdir $btr_root/subvols/
> >     cd $btr_root/subvols/
> >     /btrfs su cr foo
> >     /btrfs su cr bar
> >     mount $bdev -osubvol=3Dsubvols/foo $btr_root/subvols/bar
> >     umount $btr_root/subvols/bar
>=20
> Can you please send this as a new testcase for xfstests?

I'll try to. Will take some time though (never seen it before).
Thanks!

--=20

  Sergei

--Sig_/hGE7Gghw3FNe96zQ+UWTXLo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk63puQACgkQcaHudmEf86rDUQCfYwWcDi7u9jqR9xstPxN48DKa
0yIAnRFvXobHqiszscqKCUQLr/4Na1yp
=x700
-----END PGP SIGNATURE-----

--Sig_/hGE7Gghw3FNe96zQ+UWTXLo--
