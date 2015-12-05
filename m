Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33474 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbbLEMBG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Dec 2015 07:01:06 -0500
Date: Sat, 5 Dec 2015 12:01:03 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Subvolume UUID, data corruption?
Message-ID: <20151205120103.GA2376@carfax.org.uk>
References: <20151204120529.37E47D5A28@emkei.cz>
 <20151204130758.GR8775@carfax.org.uk>
 <1449286104.18841.14.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
In-Reply-To: <1449286104.18841.14.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 05, 2015 at 04:28:24AM +0100, Christoph Anton Mitterer wrote:
> On Fri, 2015-12-04 at 13:07 +0000, Hugo Mills wrote:
> > I don't think it'll cause problems.
> Is there any guaranteed behaviour when btrfs encounters two filesystems
> (i.e. not talking about the subvols now) with the same UUID?

   Nothing guaranteed, but the likelihood is that things will go badly
wrong, in the sense of corrupt filesystems.

> Given that it's long standing behaviour that people could clone
> filesystems (dd, etc.) and this just worked=E2=84=A2, btrfs should at lea=
st
> handle such case gracefully.
> For example, when already more than one block device with a btrfs of
> the same UUID are known, then it should refuse to mount any of them.
> And if one is already known and another device pops up it should refuse
> to mount that and continue to normally use the already mounted one.

   Except that that's exactly the mechanism that btrfs uses to handle
multi-device filesystems, so you've just broken anything with more
than one device in the FS.

   If you inspect the devid on each device as well, and refuse
duplicates of those, you've just broken any multipathing
configurations.

   Even if you can handle that, if you have two copies of dev1, and
two copies of dev2, how do you guarantee that the "right" pair of dev1
and dev2 is selected? (e.g. if you have them as network devices, and
the device enumeration order is unstable on each boot).

   Hugo.

--=20
Hugo Mills             | Geek, n.:
hugo@... carfax.org.uk | Circus sideshow performer specialising in the eati=
ng
http://carfax.org.uk/  | of live animals.
PGP: E2AB1DE4          |                                                   =
OED

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWYtH/AAoJEFheFHXiqx3kCRAP/0AFuj6lPoNR1+zh3sDtyJGM
gnJcG5We2mgRtle4aLvJz4E5A2npiBc83hf91g2+2YbjiIXQsoJcy4nEzcwIEtph
mOLL6iYReUkOD4ZGviv3Uz5tRm5baStHFpP1yJzICWbxbLv6j9BLnKpe2emHtzQY
Ye7lVgpBvsZv+dESIcNQko1w+s/kmzfquZComCoWuCjTt5C1rPuibMNs/k8QVxcX
+wvZD8xfGK2bULrXnNuSWCIC26ekHQ59UHJpI841Ga4HUhRwQEibYnbrTY/n70KL
Wlqe4AEUGonC/7sX/HJUIpVzjgXqm5FPZwEkDKSs4Fdy6YvUjegDdK7zyYJAXibf
IOk2/NjX5yXAiUo5c2zTSbSI+lE6Ev5+JsXEwvznPg552bxF16QmgcLxjPk3ReUQ
upTriJ4L2qUBJPjemni6ALmYznMALuy0yaRL4W0T2SFd93mVOkzMX2P5Nnl0i2uE
qDuVawrtsYSxowa+H2ru1PhFGEQAIOJTKJlAHNfBwYeCDSGeEsfSxdGb3WCwz5sU
iqlnIFoK5MjB99rwJOPzoHALjONf7/FUr9hl1at/AvcRN3twIveSVmZqskJKptxG
gLYsQrR2prdP9ZOz3Ql3qJcFv8xXMSt5uyJCxuMThinnlsuCt7Jw3zUpSR/mPAKr
psVl/sqhIqnZDrxa/V9i
=0Sn1
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
