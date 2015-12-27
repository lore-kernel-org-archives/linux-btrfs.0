Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41896 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbbL0XNM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 18:13:12 -0500
Date: Sun, 27 Dec 2015 23:13:03 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Jiri Kanicky <j@ganomi.com>, linux-btrfs@vger.kernel.org
Subject: Re: How to change BTRFS filesystem UUID
Message-ID: <20151227231303.GL1586@carfax.org.uk>
References: <567FF63E.3010106@ganomi.com>
 <20151227144535.GJ1586@carfax.org.uk>
 <5680034D.7030509@ganomi.com>
 <1451257299.6320.3.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wAI/bQb0EMvlZCHl"
In-Reply-To: <1451257299.6320.3.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wAI/bQb0EMvlZCHl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 28, 2015 at 12:01:39AM +0100, Christoph Anton Mitterer wrote:
> On Mon, 2015-12-28 at 02:27 +1100, Jiri Kanicky wrote:
> > Thanks for the reply. Looks like I will have o use some newer
> > distro.=A0
> As it was already said... btrfs may even corrupt your filesystem if
> colliding UUIDs are "seen".
>=20
> At least to me it's currently unclear what "seen" exactly means...
> actually trying a mount, or already when just a device with colliding
> IDs appear.

   The damage happens on (or after) mount. Until that point there's no
danger.

   The OS (usually udev) will run btfs dev scan when a new block
device is detected, and it tells the kernel that there's a btrfs
filesystem with a particular UUID on a particular block device.

   The kernel uses this information to decide which devices to include
when it assembles a filesystem. If you have two devices where there
should be only one (particularly if the data on the two was similar
but has now diverged), then the kernel can end up writing to one or
other device arbitrarily, possibly having read state from the other
one, and things screw up rather fast.

   Hugo.

> So whenever you do your recovery works, make sure that there's never a
> moment where more than one btrfs block device appears with the same
> UUID.
> Even when it's just for some seconds it may already cause corruption.
>=20
>=20
> Cheers,
> Chris.



--=20
Hugo Mills             | emacs: Eats Memory and Crashes.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--wAI/bQb0EMvlZCHl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWgHB/AAoJEFheFHXiqx3knh4P/RYJA1TPggK0givCghZkNR7c
1eWN0S3R4rHEAyz60iNcziHC7N+Y1OfQMWk3wQO7B/pdTlIruCmxVvFj6ZPvP7no
uTm2KNt9Zt0kigTwsgDQYVXsnmE0yxlP+CE3clMHGyCGDFPvcxaOP30r8D22QjIJ
hCzwMAr9CI/L9kS0nlujjS4unB3H8mrQCP6Q75eiCNbH5MceLDn0TAnFTk0QRJf6
1R+FCFFGGnHpqcOLe3PSm/LbprGrqfV6+b96rjb7d0ABnD6uNmQ+QoHQODsBkGmD
bgWFj+LUsASUYPR6ofAQifMmj78BGTSNIUmpXEj/NipRAnBATwVrDurzGeLeCwnX
qcERAxJ4v5MUD8RZ3PLultWAUmrb++I+UbmOPbvY7kjl0Ma1i7lJYmATJ35YMUQg
adGog5HD+2zmMxIecOGvMinu3+Hb/1rXfZTo9btYIfSBqaL7yxuPbVurgY7VbhZ5
xFT0Ah3fM8FGyLVroYOSj02LHtFqEnMWxGpVLHi7/tz103CIBqRV6zL2lp4d/cBD
twfWCmEGZJgwuphQpIwDt1tjI+oSbWFS5PAsChFsa9gFQEpNqi/36luwkH7Q3cHs
2lIeWWU6eqRzuGnsOJlmeodZZO32XhSXgkU9TkEM37xCh4lRmiLeFEwgJiHKYLi6
469gzT2PiEmtEDhAkjfp
=JDHi
-----END PGP SIGNATURE-----

--wAI/bQb0EMvlZCHl--
