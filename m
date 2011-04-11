From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: v2.6.38-6555-ga44f99c: null pointer dereference on -ENOSPC
Date: Tue, 12 Apr 2011 01:09:03 +0300
Message-ID: <20110412010903.353a653c@sf>
References: <20110329103224.3fecfd32@sf.vba.domain>
	<20110403001028.62341746@sf.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kyOJFhF9=QCrSx+uF=DB7np"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110403001028.62341746@sf.home>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/kyOJFhF9=QCrSx+uF=DB7np
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 3 Apr 2011 00:10:28 +0300
Sergei Trofimovich <slyich@gmail.com> wrote:

> > The partition is a physical ~5GB --mixed lzo compressed partition.

I used wrong patch for btrfs-progs to support --mixed, so please treat
it as OOps on horribly corrupted FS.

--=20

  Sergei

--Sig_/kyOJFhF9=QCrSx+uF=DB7np
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2jfAQACgkQcaHudmEf86qMzACeJmlhRtAJIbAd871kvSVTAjRS
duIAn1qO6vxLmG9YkqCm0da3HiEPODUM
=+UXh
-----END PGP SIGNATURE-----

--Sig_/kyOJFhF9=QCrSx+uF=DB7np--
