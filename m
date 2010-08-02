From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: synchronous removal?
Date: Mon, 2 Aug 2010 09:02:42 -0600
Message-ID: <20100802150242.GA12234@untroubled.org>
References: <4C55E2F3.3030202@noir.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C55E2F3.3030202@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 01, 2010 at 02:11:15PM -0700, K. Richard Pixley wrote:
> I notice that when I remove old snapshots and delete old directories,=20
> the free space on my disk, (according to df), doesn't rise immediately. =
=20

> Basically, I want to check to see if there's enough space available.  If=
=20
> not, I want to remove some things, (including at least one snapshot),=20
> wait for the cleaner to digest, and then start over with the checking to=
=20
> see if there's enough space available and loop until I've removed enough=
=20
> things that there is enough space available.  How can I do that on a=20
> btrfs file system?

I asked a similar question a while back, and the short answer is that
you can't, short of unmounting and remounting the filesystem.  The
indication was made that writing a new ioctl to wait for all background
activity wouldn't be too hard, but I don't recall seeing it in any
recent patches.

See this thread:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04872.html

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkxW3hEACgkQ6W+y3GmZgOhEHQCgm29keLi8tdSQFZ+aLpGG4Wmq
vesAoInL5Bx/xU3QXPMQhkPz/4nLSAGn
=JBKF
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
