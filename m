From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: snapshot merging?
Date: Wed, 24 Sep 2008 02:54:16 -0600
Message-ID: <1222246456.26395.16.camel@telesto>
References: <48D63C8E.2060802@wpkg.org> <48D657DB.7050601@oracle.com>
	 <48D65ACD.7030907@wpkg.org>  <200809232034.21750.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rBoVL2SZcrViBSP+2Qxk"
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
	Zheng Yan <zheng.yan@oracle.com>, linux-btrfs@vger.kernel.org
To: Daniel Phillips <phillips@phunq.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200809232034.21750.phillips@phunq.net>
List-ID: <linux-btrfs.vger.kernel.org>


--=-rBoVL2SZcrViBSP+2Qxk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-23 at 20:34 -0700, Daniel Phillips wrote:
> On Sunday 21 September 2008 07:31, Tomasz Chmielewski wrote:
> > > Writeable snapshot has been available in btrfs for a long time.
> >=20
> > Writeable snapshots and snapshot merging are two different things.
>=20
> I think what Mikulas really means by "snapshot merging" is what we call
> "revert to snapshot" in ddsnap (google Zumastor ddsnap).  The latter is
> more appropriate terminology IMHO.  For a snapshotted volume, this just
> requires copying any blocks that belong to the snapshot and not the
> origin back to the origin.  Similarly, one could revert any snapshot
> "back" (quotes because there is not necessarily any relationship in
> time) to any other.  For a filesystem it will not be nearly so simple,
> because at best only part of the job can be done at the physical block
> level.

It took me a while to get what was meant by snapshot merging. Consider
this a vote for the "revert" terminology. :) Although, it calls into
question some of my assumptions about what people use snapshots for.

What do people use snapshots for?

Cheers,
Eric


--=-rBoVL2SZcrViBSP+2Qxk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBI2gA4e2L37HVup3ARAqMJAJ9OZqKkq5Cb/3T49Rr7g0rznvuBuQCfYEEA
aX/c/9I3Cuvvp2LDKwxCayw=
=ctcb
-----END PGP SIGNATURE-----

--=-rBoVL2SZcrViBSP+2Qxk--

