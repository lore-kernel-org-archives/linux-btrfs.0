From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: Transparent compression for Btrfs
Date: Sun, 31 Aug 2008 20:49:57 -0600
Message-ID: <1220237397.11137.17.camel@telesto>
References: <200809010739.29862.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yZVFmtRfbOclm4yBZqes"
Cc: linux-btrfs@vger.kernel.org
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200809010739.29862.balajirrao@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-yZVFmtRfbOclm4yBZqes
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-01 at 07:39 +0530, Balaji Rao wrote:
> Hi,
>=20
> For a medium term project, I'm thinking of working on transparent compres=
sion=20
> for Btrfs. Please give any hints and comments on how we would want to go=20
> about this, the features we would like to have and some common pitfalls t=
o=20
> avoid.
>=20
> Is looking at how it's done in Reiser4, a good idea ? Can we allow the=20
> compression algorithm be configurable on a per file basis, may be using a=
n=20
> xattr ? This, for example, would allow us to make a compromise between sp=
eed=20
> and compression ratio.
>=20
> Any other ideas welcome.

If the algorithm is tunable on a per file basis, why not make the
compression level tunable on a per file basis? I think it's also
important to consider the tradeoff the between learning
curve/administrative overhead and the granularity of control over
compression, but I don't have any good answers.

While we're on the subject, someone on the ZFS list expressed a need to
tune redundancy on a per-file basis (or even tune redundancy at all
after the filesystem is created). Currently ZFS is very inflexible in
this regard, so it could be a way for btrfs to get ahead.

Cheers,
Eric


--=-yZVFmtRfbOclm4yBZqes
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIu1hVe2L37HVup3ARAtLSAKC/9V5xVgPzQTxA3+B10SUa2LS7vwCeJLFc
PcIYnmmN80jtPHKfAITyAhg=
=pv9c
-----END PGP SIGNATURE-----

--=-yZVFmtRfbOclm4yBZqes--

