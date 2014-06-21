Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53060 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbaFUMGD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Jun 2014 08:06:03 -0400
Message-ID: <1403352353.23472.67.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [v3.10.y][v3.11.y][v3.12.y][v3.13.y][v3.14.y][PATCH 1/1][V2]
 ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while
 DEBUG not defined
From: Ben Hutchings <ben@decadent.org.uk>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: greg@kroah.com, kamal.mostafa@canonical.com, luis.henriques@canonical.com,
        jslaby@suse.cz, clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sat, 21 Jun 2014 13:05:53 +0100
In-Reply-To: <53A47BC4.8040406@canonical.com>
References: <cover.1403113867.git.joseph.salisbury@canonical.com>
		 <a377cdb51b1a98e9fa6bffaa124502fc15c47903.1403113867.git.joseph.salisbury@canonical.com>
	 <1403142759.23472.28.camel@deadeye.wl.decadent.org.uk>
	 <53A4515C.8090103@canonical.com> <53A47BC4.8040406@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-km7cYOiT9RrDw2QafFVk"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-km7cYOiT9RrDw2QafFVk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-06-20 at 14:21 -0400, Joseph Salisbury wrote:
[...]
> I looked at this some more.   It seems like my v2 backport may be the
> most suitable for the releases mentioned in the subject line, but I'd
> like to get additional feedback.
>=20
> The lines added by commit a5065eb just get removed by commit b7a77235.=
=20
> Also, if I apply commit a5065eb, it will also require a backport to pull
> in just a piece of code(Remove snd_printk() and add dev_dbg()) from
> another prior commit(0ba41d9).  No backport would be needed at all if I
> cherry-pick 0ba41d9, but that commit seems to have too may changes for a
> stable release.

Keep the changes squashed together if you like, but do include both
commit hashes and commit messages.

Ben.

--=20
Ben Hutchings
Who are all these weirdos? - David Bowie, reading IRC for the first time

--=-km7cYOiT9RrDw2QafFVk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU6V1Jue/yOyVhhEJAQqI1xAAvz7yt/S1TZw5QJB/QadDS3B8C6eJ3jh3
gjhs2AnbU7DwujICfH+j75hrRlXXY13feZz2O4el3JJgnHmINixxgTvT6I8C+qKY
3Azqi4iJRyk3pobeZz2OUUMrHQRSSKTgJafeWzrBwv9NewtMzC2+BWvfzk3VuivT
XckHw/qRkAR5XETUHksWRHyMA7aJgXAt4zhlAxveAUvPBoQHJQALShP2GdLPFwCc
9Yqx93BoQX8f4SAn+TaFgcVedROVCCLCzsG2y5NYP8dZTAgcDJ1dfnJYECZ8pb3L
5fCjYVyqq1fO7q7v1X6qF6m4l0KYQdJNKZseDq9T6QKDoSYGV6tstxP7+n3H+OS5
ti45HeiGDDpplMwoCWwSejCCl5UGPtlY47oagoSlDAskN6GTcENlL50S8Ol4lTkA
he9pg4FNIho1qx+5SmlWS7MYjm4qbj/uTmwtVPSXp0eb3uZ4OZUCaHX/pK/II6YQ
fHSquQb4zcmbRkQsTrT5PxDsP6oAuI3xne49wHm1vZJEyKqUV2cAxhz2iwSrQr7M
SOJwfiYNTHUueHSH6T9AhyriwqJDxILXXHDxPfVbyndkPXbzl1+r+558VwYHyqm3
2beXj9BwbNCZnJL6uJAGfPMnZl77NxMVSBGvjAHYDr7LVFr+ax0YlcGSagbTMbCZ
R+abg2PZ02c=
=i7Va
-----END PGP SIGNATURE-----

--=-km7cYOiT9RrDw2QafFVk--
