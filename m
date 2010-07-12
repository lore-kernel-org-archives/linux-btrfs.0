From: Tracy Reed <treed@ultraviolet.org>
Subject: Re: slow deletion of files
Date: Mon, 12 Jul 2010 14:33:02 -0700
Message-ID: <20100712213302.GH2244@tracyreed.org>
References: <i1cm80$901$1@dough.gmane.org>
 <4C3A27A0.6090907@gmail.com>
 <AANLkTim2GsB-1BKaDUDbvzWkvNRi3YKe7c2iiGm6nRS9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ia+af9HxgiRv1+7n"
Cc: linux-btrfs@vger.kernel.org
To: Clemens Eisserer <linuxhippy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim2GsB-1BKaDUDbvzWkvNRi3YKe7c2iiGm6nRS9@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--ia+af9HxgiRv1+7n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 12, 2010 at 10:30:20PM +0200, Clemens Eisserer spake thusly:
> Another reason I moved away was btrfs corrupted, and btrfsck is still
> not able to repair it.
> I really like btrfs but in my opinion it has still a long road to go
> and declaring it stable in 2.6.35 is quite optimistic at best.

How many of reiserfs' problems were due to bugs in reiserfs vs due to
buggy PC memory which is rarely ECC? These fancy new filesystems hold
a lot of datastructures in memory compared to older filesystems which
would seem to increase the chances that they could be broken by bad
RAM. I am concerned that a flipped bit in memory somewhere could be
written out to disk and hose the filesystem. I know ZFS implements a
lot of checksums to prevent this sort of thing but it also tends to
run on nicer hardware with ECC. I never had corruption problems with
reiserfs even while running it on many terabytes of disk. I know
plenty of people who constantly lost data to it. I can't explain the
difference other than hardware.

--=20
Tracy Reed
http://tracyreed.org

--ia+af9HxgiRv1+7n
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFMO4oOBhSTPg0d/nQRAl8bAKDICgSByZ3HTaqBFd4ZX33+wIBQwwCg2R53
XNDr1y4PlfycKaUsOUwxzRs=
=54tp
-----END PGP SIGNATURE-----

--ia+af9HxgiRv1+7n--
