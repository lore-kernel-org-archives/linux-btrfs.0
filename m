Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.gocept.net ([195.62.125.19]:53473 "EHLO mail.gocept.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752607AbdC0Oxg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 10:53:36 -0400
From: Christian Theune <ct@flyingcircus.io>
Message-Id: <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_90094307-A409-4E3E-B5B0-3F29978A053C";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: Shrinking a device - performance?
Date: Mon, 27 Mar 2017 16:53:03 +0200
In-Reply-To: <20170327194847.5c0c5545@natsu>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk>
 <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327194847.5c0c5545@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_90094307-A409-4E3E-B5B0-3F29978A053C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

> On Mar 27, 2017, at 4:48 PM, Roman Mamedov <rm@romanrm.net> wrote:
>=20
> On Mon, 27 Mar 2017 15:20:37 +0200
> Christian Theune <ct@flyingcircus.io> wrote:
>=20
>> (Background info: we=E2=80=99re migrating large volumes from btrfs to =
xfs and can
>> only do this step by step: copying some data, shrinking the btrfs =
volume,
>> extending the xfs volume, rinse repeat. If someone should have any
>> suggestions to speed this up and not having to think in terms of =
_months_
>> then I=E2=80=99m all ears.)
>=20
> I would only suggest that you reconsider XFS. You can't shrink XFS, =
therefore
> you won't have the flexibility to migrate in the same way to anything =
better
> that comes along in the future (ZFS perhaps? or even Bcachefs?). XFS =
does not
> perform that much better over Ext4, and very importantly, Ext4 can be =
shrunk.

That is true. However, we do have moved the expected feature set of the =
filesystem (i.e. cow) down to =E2=80=9Cstore files safely and =
reliably=E2=80=9D and we=E2=80=99ve seen too much breakage with ext4 in =
the past. Of course =E2=80=9Cpersistence means you=E2=80=99ll have to =
say I=E2=80=99m sorry=E2=80=9D and thus with either choice we may be =
faced with some issue in the future that we might have circumvented with =
another solution and yes flexibility is worth a great deal.

We=E2=80=99ve run XFS and ext4 on different (large and small) workloads =
in the last 2 years and I have to say I=E2=80=99m much more happy about =
XFS even with the shrinking limitation.

To us ext4 is prohibitive with it=E2=80=99s fsck performance and we do =
like the tight error checking in XFS.

Thanks for the reminder though - especially in the public archive making =
this tradeoff with flexibility known is wise to communicate. :-)

Hugs,
Christian

--
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian. =
Theune, Christian. Zagrodnick


--Apple-Mail=_90094307-A409-4E3E-B5B0-3F29978A053C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJY2SdPAAoJEKuh8lKpfGLOO+YH/RB1uRgZ+Lm+yMJevWSAJcgP
FFbaXgYm/8qXP2K4VRjhHZtsFbe9hn61BoVzALXWZv8M2qVymjoAyGz+/JFBstFR
4V+ZSl6zkr8m2DcI/hsXm5UZ7UxckMaU/4eDeiPrndosXK3M06owmbJF7+UWfg1O
GrhIBMDaayjl0RwkgMJPUiTqBQkqim42kPYYPLh7N2rMjLBeUW6yAk9JxGngASL8
7Zi3tcL7tnbfNkN5TRxSlFw6O2CXIijNUEj+kGJ4tJcSVTd+s/VkYQl/rB9U9ekV
/N3L/mqshgufCSID6ddGUHwV5X5W86NAU/wxOZy9UG65HtOE1TouV5FJ9Rs+A5Q=
=+Tsp
-----END PGP SIGNATURE-----

--Apple-Mail=_90094307-A409-4E3E-B5B0-3F29978A053C--
