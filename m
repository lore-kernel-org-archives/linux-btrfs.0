Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40475 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932234AbaJVUIN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 16:08:13 -0400
Date: Wed, 22 Oct 2014 16:08:12 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 5 _thousand_ snapshots? even 160? (was: device balance times)
Message-ID: <20141022200812.GA17395@hungrycats.org>
References: <9cf38edae6c01b900d4ea0068d2dcfdd@admin.virtall.com>
 <pan$66073$b8603a2$c915bfb9$cd573e99@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
In-Reply-To: <pan$66073$b8603a2$c915bfb9$cd573e99@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2014 at 07:41:32AM +0000, Duncan wrote:
> Tomasz Chmielewski posted on Wed, 22 Oct 2014 09:14:14 +0200 as excerpted:
> >> Tho that is of course per subvolume.  If you have multiple subvolumes
> >> on the same filesystem, that can still end up being a thousand or two
> >> snapshots per filesystem.  But those are all groups of something under
> >> 300 (under 100 with hourly) highly connected to each other, with the
> >> interweaving inside each of those groups being the real complexity in
> >> terms of btrfs management.
>=20
> IOW, if you thin down the snapshots per subvolume to something reasonable=
=20
> (under 300 for sure, preferably under 100), then depending on the number=
=20
> of subvolumes you're snapshotting, you might have a thousand or two. =20
> However, of those couple thousand, btrfs will only have to deal with the=
=20
> under 300 and preferably well under a hundred in the same group, that are=
=20
> snapshots of the same thing and thus related to each other, at any given=
=20
> time.  The other snapshots will be there but won't be adding to the=20
> complexity near as much since they're of different subvolumes and aren't=
=20
> logically interwoven together with the ones being considered at that=20
> moment.
>=20
> But even then, at say 250 snapshots per subvolume, 2000 snapshots is 8=20
> independent subvolumes.  That could happen.  But 5000 snapshots?  That'd=
=20
> be 20 independent subvolumes, which is heading toward the extreme again. =
=20
> Yes it could happen, but better if it does to cut down on the per-
> subvolume snapshots further, to say the 25 per subvolume I mentioned, or=
=20
> perhaps even further.  25 snapshots per subvolume with those same 20=20
> subvolumes... 500 snapshots total instead of 5000. =3D:^)

If you have one subvolume per user and 1000 user directories on a server,
it's only 5 snapshots per user (last hour, last day, last week, last
month, and last year).  I hear this is a normal use case in the ZFS world.
It would certainly be attractive if there was working quota support.

I have datasets where I record 14000+ snapshots of filesystem directory
trees scraped from test machines and aggregated onto a single server
for deduplication...but I store each snapshot as a git commit, not as
a btrfs snapshot or even subvolume.

We do sometimes run queries like "in the last two years, how many times
did $CONDITION occur?" which will scan a handful files in all of the
snapshots.  The use case itself isn't unreasonable, although using the
filesystem instead of a more domain-specific tool to achieve it may be.


--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRIDqwACgkQgfmLGlazG5ys/wCfbRtnMfvH7DcnNrBiKmQNGe7/
dfEAnRmVz1iCdlXWrI6gPKVUfWgSuh8+
=MT39
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
