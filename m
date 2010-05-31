From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: Disk space accounting and subvolume delete
Date: Mon, 31 May 2010 13:01:07 -0600
Message-ID: <20100531190107.GA20103@untroubled.org>
References: <20100510182352.GA21154@untroubled.org>
 <AANLkTilDHeJ_aRQSKWUTJgIBhlpLHyNRTy4x4ai_MGJI@mail.gmail.com>
 <20100511154518.GA11710@untroubled.org>
 <AANLkTikzNWS11qycrI94k69PFEZJWpAezwuOF6nmw_PF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikzNWS11qycrI94k69PFEZJWpAezwuOF6nmw_PF@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 12, 2010 at 01:02:07PM +0800, Yan, Zheng  wrote:
> Dropping a tree can be lengthy. It's not good to let sync wait for hours.
> For most linux FS, 'sync' just force an transaction/journal commit. I don=
't
> think they wait for large operations that can span multiple transactions =
to
> complete.

What happens to the consistency of the filesystem if a crash happens
during this process?

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkwEB3MACgkQ6W+y3GmZgOi9hQCcDJ34yRiaIPUSuU41cDyHwg90
6KoAmgMHUp+1GQI8K+I9x1ciGc2kgMze
=XlXN
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
