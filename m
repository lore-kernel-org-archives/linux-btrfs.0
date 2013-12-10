Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60635 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3LJMTK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 07:19:10 -0500
Date: Tue, 10 Dec 2013 12:19:04 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Cirillo Costantino <linoc@pacbell.net>
Cc: "\"linux-btrfs@vger.kernel.org\"" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs questions
Message-ID: <20131210121904.GG9738@carfax.org.uk>
References: <1386615086.1044.YahooMailNeo@web180901.mail.ne1.yahoo.com>
 <1386619322.61331.YahooMailNeo@web180902.mail.ne1.yahoo.com>
 <20131209200856.GF9738@carfax.org.uk>
 <1386623127.31132.YahooMailNeo@web180903.mail.ne1.yahoo.com>
 <1386623231.94746.YahooMailNeo@web180901.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TKYYegg/GYAC5JIZ"
In-Reply-To: <1386623231.94746.YahooMailNeo@web180901.mail.ne1.yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TKYYegg/GYAC5JIZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2013 at 01:07:11PM -0800, Cirillo Costantino wrote:
> resending in plain text
>=20
>=20
> ________________________________
> From: Cirillo Costantino <linoc@pacbell.net>
> To: Hugo Mills <hugo@carfax.org.uk>=20
> Cc: ""linux-btrfs@vger.kernel.org"" <linux-btrfs@vger.kernel.org>=20
> Sent: Monday, December 9, 2013 1:05 PM
> Subject: Re: Btrfs questions
>=20
>=20
>=20
> thanks Hugo,
>=20
> the link you sent indicates that has been "submitted" but it is not in a =
kernel release... does it mean it could be in a 3.14 or 15 release?=A0

   Unlikely. There were patches a couple of years ago, but they
weren't accepted back then and would probably need some additional
effort to make them work now -- even if the general approach was
accepted (which I'm not sure it was, from memory).

> with the release of Haswell from Intel, persistent memory will be
> possible and cheap... portions of this memory could be made visible
> as block devices and mirrored for protection to a neighboring system
> for later replay in the event of a crash or power outage; how are
> such feature request be included in btrfs?

   I think you're confusing two things (or possibly I am) --
transactional memory and persistent memory.

   Transactional memory allows for [potentially] more efficient
algorithms to be used in concurrent systems, reducing the necessity
for explicit locking -- that's unlikely to have much direct effect on
btrfs, as I suspect it will largely be implemented in the kernel's
lock primitives, and "ordinary" kernel code won't see much difference.

   Persistent memory simply retains its state over a power-off, so in
that sense it looks something like a directly-attached/addressable
block device, which have been around for ages in the embedded space
(although the approaches used there, like XIP, may need modification
to scale up appropriately).

   Both are useful things to have, but I don't think you're going to
see any gigantic changes coming out of either, other than access times
for persistent storage coming down as a result of persistent memory.

   Hugo.

> lino
>=20
>=20
> ________________________________
> From: Hugo Mills <hugo@carfax.org.uk>
> To: Cirillo Costantino <linoc@pacbell.net>=20
> Cc: ""linux-btrfs@vger.kernel.org"" <linux-btrfs@vger.kernel.org>=20
> Sent: Monday, December 9, 2013 12:08 PM
> Subject: Re: Btrfs questions
>=20
>=20
> On Mon, Dec 09, 2013 at 12:02:02PM -0800, Cirillo Costantino wrote:
> >=20
> >=20
> > i am looking at using btrfs for a new project and i have a few question=
s:
> >=20
> > =A0=A0=A0=A0* i have heard that as it currently stands Btrfs has some i=
ssues to be used as a Lustre file system; is he aware of the issues and any=
 plans to address these and integrate Btrfs in to Lustre
>=20
> =A0=A0=A0I don't recall seeing any Lustre-specific issues being reported
> here. Do you have any links to bug reports with this configuration?
>=20
> > =A0=A0=A0=A0* any plans to support=A0native=A0clustering on Btrfs
>=20
> =A0=A0=A0No: https://btrfs.wiki.kernel.org/index.php/FAQ#Will_Btrfs_becom=
e_a_clustered_file_system
>=20
> > =A0=A0=A0=A0* on ZFS the ZIL is a separate device, any plans to impleme=
nt a
> the B-Tree log on a separate device?
>=20
> =A0=A0=A0Not that I'm aware of, but it may come out of the work below.
>=20
> > =A0=A0=A0=A0* any plans to allow to have a file system metadata be plac=
ed on a separate device
>=20
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Device_IO_Priorities
>=20
> =A0=A0=A0... but it's not being worked on right now.
>=20
> =A0=A0=A0Hugo.
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- There's many a slip 'twixt wicket-keeper and gully. ---      =20

--TKYYegg/GYAC5JIZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUqcGuFheFHXiqx3kAQI16w//e53ryHHKHnR8HlVKSQBrxrbYsCWzzd8b
b/0MP90YWnddo6kDISmFzNyK6c0BBh3HB4RWfCzmtwigWXsWpuarauhKeCs7MEJk
Zffn9eZ1pMUUIX1Sbvo/wZpjdXSkuTx3pepPRX3lK13vB9clhW0lorBumz+B2CPO
gc+Eb7vK4A+m1m772dwmI6sQujAyO/kqQOhECywaqKSvUTTd0rF58C+sllcZqn6Y
rOV5rAAQFr//8W/QzB1zNxllmDTYHehwQ/iqsRagLObeMkG/YSVoN4FWzsRlou8w
4XLY2bZc7bNz09RC3ttG8EMJlSGh998d+AJLtKdI7FdQjbnWO8jZn1us9N0TKiB/
O184hpaFDVsns7/1uUbdzR8FSSFJkSEy9OVq6ubtjwKnZxAAbl61vK1F9o+oT0j/
jj8kCyHuk+NWAmDtFIqpAU5OcSXbhsMG/E/vV6ikwEjbIVBrS55TSfP/y0GK3vGw
haXWEH/Tf7B310GQnrk+C1Yr0Y+55oO1N8Vm25m/X96XbbRAzaNM7SaqqLAhh7T9
D1i/urXW/yLvkLJDwKAuszuZdlxeDgl0VViBfq4xz8H07ElWYyPQEdW7EFC77v89
mbUDviKLmiC1dPQO3bLYtUKafL8V3vprBSh/WGcyMfvvNbm5dWef/eQDZfLAvnG7
8SpRmzTKzIM=
=MTaA
-----END PGP SIGNATURE-----

--TKYYegg/GYAC5JIZ--
