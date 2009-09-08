From: Tracy Reed <treed@ultraviolet.org>
Subject: Re: btrfs csum failed on git .pack file
Date: Tue, 8 Sep 2009 14:53:57 -0700
Message-ID: <20090908215357.GK6779@tracyreed.org>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de>
 <20090908200041.GF18599@kernel.dk>
 <20090908202211.GA1901@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qicme7IxPpkH/pPU"
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-btrfs@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090908202211.GA1901@phenom2.trippelsdorf.de>
List-ID: <linux-btrfs.vger.kernel.org>


--qicme7IxPpkH/pPU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 08, 2009 at 10:22:11PM +0200, Markus Trippelsdorf spake thusly:
> I've already deleted the file in question unfortunately.
> On IRC Chris decided that either bad RAM or a harddrive error was the
> most likely reason for this chechsum mismatch.

Which raises an interesting point: I know reiserfs had its problems
but it also turned up a lot of machines with bad RAM which contributed
to giving the fs a bad name. With more and more complicated and memory
consuming filesystem datastructures being stored in RAM, larger volumes
of RAM in systems, and RAM not really getting any more reliable will
we ever see a day where something like btrfs is not recommended for
use in any machine that doesn't have ECC? Does the filesystem do
anything to protect itself from bad hardware?

--=20
Tracy Reed
http://tracyreed.org

--qicme7IxPpkH/pPU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFKptJ19PIYKZYVAq0RAvqxAJ0YDk42NPP6P1MgSXzY2zkEhyYqOQCeMdHk
0QLTFqyzrvjPLFy0MYJWKu0=
=0WaE
-----END PGP SIGNATURE-----

--qicme7IxPpkH/pPU--
