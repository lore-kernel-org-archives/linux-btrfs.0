Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60583 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbbDRIPA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Apr 2015 04:15:00 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: incremental full file backups to smaller mediums possible?
Date: Sat, 18 Apr 2015 10:14:58 +0200
Message-ID: <1489496.v0bc8xWMtg@merkaba>
In-Reply-To: <1429311803.8371.58.camel@scientia.net>
References: <1428596073.4994.24.camel@scientia.net> <20150409163319.GV13864@carfax.org.uk> <1429311803.8371.58.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1522585.72MrBAkc8Z"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1522585.72MrBAkc8Z
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Am Samstag, 18. April 2015, 01:03:23 schrieb Christoph Anton Mitterer:
> On Thu, 2015-04-09 at 16:33 +0000, Hugo Mills wrote:
> >    btrfs sub find-new might be more helpful to you here. That will
> >=20
> > give you the list of changed files; then just feed that list to you=
r
> > existing bin-packing algorithm for working out what goes on which
> > disks, and you're done.
>=20
> hmm that sounds interesting, but
> a) it lacks much documentation (how does that with the generations wo=
rk?
> when is there a new generation? what, if the generation overflows?)

I have no idea about when there is a new generation. I think it depends=
 on=20
the commit intervall.

You can see the current generation with:

merkaba:~> btrfs subvol show / | grep Generation
        Generation (Gen):       468143

> b) it seems to only show me new files, but not files that have been m=
oved,
> or removed, or when properties have changed.

It should show renamed or moved files. But yeah, if it does, at least n=
ot=20
in a way that shows that a rename or move operation took place.

> c) it seems to work only for one subvolume?

Its per subvolume, I think. Thats why it is under "btrfs subvolume"

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart1522585.72MrBAkc8Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlUyEoIACgkQmRvqrKWZhMfN/wCgsTO32JGaduNk0Kab312XcD1g
tLEAoJ/gl5GyOh+0ZjaZNpWOiA5oAKoP
=yLne
-----END PGP SIGNATURE-----

--nextPart1522585.72MrBAkc8Z--

