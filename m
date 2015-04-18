Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44633 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbbDRIKr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Apr 2015 04:10:47 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: how to clone a btrfs filesystem
Date: Sat, 18 Apr 2015 10:10:40 +0200
Message-ID: <1816824.Xy3LLo99sJ@merkaba>
In-Reply-To: <1429312124.8371.62.camel@scientia.net>
References: <1429312124.8371.62.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart11171989.oAo4tFeH8k"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart11171989.oAo4tFeH8k
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Samstag, 18. April 2015, 01:08:44 schrieb Christoph Anton Mitterer:
> Hey.

Hi Christoph,

> I've seen that this has been asked some times before, and there are
> stackoverflow/etc. questions on that, but none with a really good
> answer.
>=20
> How can I best copy one btrfs filesystem (with snapshots and subvolum=
es)
> into another, especially with keeping the CoW/reflink status of all
> files?
> And ideally incrementally upgrade it later (again with all
> snapshots/subvols, and again not loosing the shared blocks between th=
ese
> files).
>=20
> send/receive apparently also works for just one subvolume,... and
> documentation is quite sparse :-/

To make it short and simple:

I am not aware of any out of the box solution for this use case.

And I think that is just why you didn=B4t found any.

I want to buy a new backup harddisk sometime in the future, and ideally=
=20
transfer the contents of the current one with all subvolumes and=20
snapshots, but I think except for some old backups that I have only the=
re=20
and I do not have the sources anymore, I will just start from scratch a=
nd=20
let it collect its own snapshots.

That said, I think it can be scripted. But I am not aware of anyone hav=
ing=20
done this. I may be missing something, so maybe someone on the list has=
 a=20
recommendation.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart11171989.oAo4tFeH8k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlUyEYUACgkQmRvqrKWZhMfpWQCglpmisp2okK/O8eB9v0gZNvIU
yuoAni0+hkRqQclO0ppzBneii7cHjYIN
=r7l4
-----END PGP SIGNATURE-----

--nextPart11171989.oAo4tFeH8k--

