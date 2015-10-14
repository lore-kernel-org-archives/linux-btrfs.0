Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41814 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbbJNJN1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 05:13:27 -0400
Date: Wed, 14 Oct 2015 09:13:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: System completely unresponsive after `btrfs balance start
 -dconvert=raid0 /` and `btrfs fi show /`
Message-ID: <20151014091325.GL25907@carfax.org.uk>
References: <C1BFF62A-9C2E-4A5D-86F9-7F01DDDF8BF6@paolino.me>
 <pan$39697$bacd3e0c$3e39ab12$ed8c21a7@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U2TwCo+MHNvvM16y"
In-Reply-To: <pan$39697$bacd3e0c$3e39ab12$ed8c21a7@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--U2TwCo+MHNvvM16y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2015 at 05:08:17AM +0000, Duncan wrote:
> Carmine Paolino posted on Tue, 13 Oct 2015 23:21:49 +0200 as excerpted:
>=20
> > I have an home server with 3 hard drives that I added to the same btrfs
> > filesystem. Several hours ago I run `btrfs balance start -dconvert=3Dra=
id0
> > /` and as soon as I run `btrfs fi show /` I lost my ssh connection to
> > the machine. The machine is still on, but it doesn=E2=80=99t even respo=
nd to
> > ping[. ...]
> >=20
> > (I have a 250gb internal hard drive, a 120gb usb 2.0 one and a 2TB usb
> > 2.0 one so the transfer speeds are pretty low)
>=20
> I won't attempt to answer the primary question[1] directly, but can point=
=20
> out that in many cases, USB-connected devices simply don't have a stable=
=20
> enough connection to work reliably in a multi-device btrfs.  There's=20
> several possibilities for failure, including flaky connections (sometimes=
=20
> assisted by cats or kids), unstable USB host port drivers, and unstable=
=20
> USB/ATA translators.  A number of folks have reported problems with such=
=20
> filesystems with devices connected over USB, that simply disappear if=20
> they direct-connect the exact same devices to a proper SATA port.  The=20
> problem seems to be /dramatically/ worse with USB connected devices, than=
=20
> it is with, for instance, PCIE-based SATA expansion cards.
>=20
> Single-device btrfs with USB-attached devices seem to work rather better,=
=20
> because at least in that case, if the connection is flaky, the entire=20
> filesystem appears and disappears at once, and btrfs' COW, atomic-commit=
=20
> and data-integrity features, kick in to help deal with the connection's=
=20
> instability.
>=20
> Arguably, a two-device raid1 (both data/metadata, with metadata including=
=20
> system) should work reasonably well too, as long as scrubs are done after=
=20
> reconnection when there's trouble with one of the pair, because in that=
=20
> case, all data appears on both devices, but single and raid0 modes are=20
> likely to have severe issues in that sort of environment, because even=20
> temporary disconnection of a single device means loss of access to some=
=20
> data/metadata on the filesystem.  Raid10, 3+-device-raid1, and raid5/6,=
=20
> are more complex situations.  They should survive loss of at least one=20
> device, but keeping the filesystem healthy in the presence of unstable=20
> connections is... complex enough I'd hate to be the one having to deal=20
> with it, which means I can't recommend it to others, either.

   Note also that RAID-0 is a poor choice for this configuration,
because you'll only get 640 GB usable space out of it. With single,
you'll get the full sum of 2370 GB usable. With RAID-1, you'll have
320 GB usable. The low figures for the RAID-0 and -1 come from the
fact that you've got two small devices, and that both RAID-0 and
RAID-1 have a minimum of two devices per block group. You can play
around with the configurations at http://carfax.org.uk/btrfs-usage

   But I second Duncan's advice about not using USB. It's really not a
reliable configuration with btrfs.

   Hugo.

> So I'd recommend either connecting all devices internally if possible, or=
=20
> setting up the USB-connected devices with separate filesystems, if=20
> internal direct-connection isn't possible.
>=20
> ---
> [1] Sysadmin's rule of backups.  If the data isn't backed up, by=20
> definition it is of less value than the resource and hassle cost of=20
> backup.  No exceptions -- post-loss claims to the contrary simply put the=
=20
> lie to the claims, as actions spoke louder than words and they defined=20
> the cost of the backup as more expensive than the data that would have=20
> been backed up.  Worst-case is then loss of data that was by definition=
=20
> of less value than the cost of backup, and the more valuable resource and=
=20
> hassle cost of the backup was avoided, so the comparatively lower value=
=20
> data loss is no big deal.
>=20
> So in a case like this, I'd simply power down and take my chances of=20
> filesystem loss, strictly limiting the time and resources I'd devote to=
=20
> any further attempt at recovery, because the data is by definition either=
=20
> backed up, or of such low value that a backup was considered too=20
> expensive to do, meaning there's a very real possibility of spending more=
=20
> time in a recovery attempt that's iffy at best, than the data on the=20
> filesystem is actually worth, either because there are backups, or=20
> because it's throw-away data in the first place.
>=20

--=20
Hugo Mills             | There's an infinite number of monkeys outside who
hugo@... carfax.org.uk | want to talk to us about this new script for Hamlet
http://carfax.org.uk/  | they've worked out!
PGP: E2AB1DE4          |                                           Arthur D=
ent

--U2TwCo+MHNvvM16y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWHhy0AAoJEFheFHXiqx3kZdwQALCUcB/ivF7Se2lXFhpLXlkt
jzAvZrw0oAkRQC/WdG70L5MloV6kCf3gVvteuUiqfTZuHLEwOkRW/q37EpnjbxsY
AdHvXgLP17Pu8oe6jxDGTlb9HVyJmHtG6Iaiix4sDI1Wh5dalgpsFVvQDA3aJoif
S9/Gu1sNteY/AHc41vjRWUsImYw8XyKDekwuObicYWK83uRKycakIioktoeF9Wn5
EmilT5z+Cj8lz0II7EmTuXloHrb6EFhur/VLcUG6tYf1zwvctYnTIl4guXm8DgSU
MSJVtK6gVXOcaqT4P4jed740jtsgDA3orsk7WHi3UpkWC7pdE40HAHk2vrw67Vuz
Eo2GrLNs6XxjdCL16s9k4e2X7803tuqcAZC6bI5T/HPzgZQxuPOePgzlXvDhUvUk
Kg92SpD6a6cx+Lu4NCvEAd7E1wLzOXVUUrQqjiD6SETXLPPYIm2tAGDQEDZCNSaD
bwW1QLFkw0+IUqRwYty9rolfTRJXSnANeEDsHw2ywfGKk4UeBmcvC12b+Jr78lzL
aYpabxLw0t2sv2lderWGothwf5y5T8hg+fAGO2gXbL44JjMcirrlVQqQ7YsJ9SVz
uDfWPaiNKKbox4O9xKu+17oz3M8IqRYeOCHkV3RiNcuScqk0hsbVb74hLsnuwCVD
j89PqKbCNeoX0ylaci1t
=osjd
-----END PGP SIGNATURE-----

--U2TwCo+MHNvvM16y--
