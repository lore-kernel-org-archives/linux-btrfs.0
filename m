From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] btrfs: fix warning in iput for bad-inode
Date: Tue, 30 Aug 2011 19:53:09 +0300
Message-ID: <20110830195309.4882f478@sf>
References: <20110817185619.4660.78543.stgit@localhost6>
	<20110829063416.00f4652c@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cybFXZ6XxvMMPMfy+g0l.NA"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110829063416.00f4652c@sf>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/cybFXZ6XxvMMPMfy+g0l.NA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> Running 'sync' program after the load does not finish and eats 100%CPU
> busy-waiting for something in kernel.
>=20
> It's easy to reproduce hang with patch for me. I just run liferea and sync
> after it. Without patch I haven't managed to hang btrfs up.

And I think it's another btrfs bug. I've managed to reproduce it _without_
your patch and _without_ autodefrag enabled by manually running the
following commands:
    $ btrfs fi defrag file-with-20_000-extents
    $ sync

I think your patch just shuffles things a bit and forces autodefrag races
to pop-up sooner (which is good! :])

--=20

  Sergei

--Sig_/cybFXZ6XxvMMPMfy+g0l.NA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5dFXgACgkQcaHudmEf86oeBQCfYGSisQwmGLyxqlrkgZyZ2B0d
zbsAn1dbYgSEZSuO7exm5xqxedYL96Ny
=1MpK
-----END PGP SIGNATURE-----

--Sig_/cybFXZ6XxvMMPMfy+g0l.NA--
