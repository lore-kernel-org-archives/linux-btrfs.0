Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54067 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785AbbDGOUc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 10:20:32 -0400
Date: Tue, 7 Apr 2015 14:20:30 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs subvolume & default subvolume
Message-ID: <20150407142030.GK13864@carfax.org.uk>
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
 <CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
 <20150407110354.GH13864@carfax.org.uk>
 <CAK1hC9vDQ4j3CZ=7T30-Sg+Q8FYFOzntgmz57WMWRU5WELpDnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QxIEt88oQPsT6QmF"
In-Reply-To: <CAK1hC9vDQ4j3CZ=7T30-Sg+Q8FYFOzntgmz57WMWRU5WELpDnA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--QxIEt88oQPsT6QmF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 07, 2015 at 01:08:59PM +0200, arnaud gaboury wrote:
> On Tue, Apr 7, 2015 at 1:03 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Tue, Apr 07, 2015 at 12:58:28PM +0200, arnaud gaboury wrote:
[snip]
> >> After more reading, it seems to me creating a top root subvolume is
> >> the right thing to do:
> >> # btrfs subvolume create root
> >> # btrfs subvolume create root/var
> >> # btrfs subvolume create root/home
> >>
> >> Am I right?
> >
> >    Not how I'd recommend doing it. I'd say:
> >
> > # btrfs sub crea root
> > # btrfs sub crea var
> > # btrfs sub crea home
> >
> >    Then fstab:
> >
> > LABEL=3Dmyfs    /      btrfs    subvol=3Droot         0 0
> > LABEL=3Dmyfs    /var   btrfs    subvol=3Dvar          0 0
> > LABEL=3Dmyfs    /home  btrfs    subvol=3Dhome         0 0
> >
> >    And finally, add this to your kernel command line in the bootloader
> > to specify how to mount root:
> >
> > rootflags=3Dsubvol=3Droot
> >
> >    Hugo.
>=20
> Thank you Hugo. May you please tell why your recommendation is better
> than my settings, if I thereafter make root as the default sub-volume?
> I changed the root name to active and avoid any confusion:

   Well, keeping the subvolumes separate from each other, rather than
nested, makes it a bit easier to do things like replace one subvolume
with an earlier snapshot. If you nest them, then your recovery process
=66rom (say) a screwed-up / looks a bit like this:

# mount -o subvolid=3D0 /dev/sda1 /media/btrfs
# mv /media/btrfs/root /media/btrfs/old-root
# btrfs sub snap /media/btrfs/old-root/snapshots/last-root /media/btrfs/root
# btrfs sub snap /media/btrfs/old-root/var /media/btrfs/root/var
# btrfs sub snap /media/btrfs/old-root/home /media/btrfs/root/home
# btrfs sub set-default $n /media/btrfs
# umount /media/btrfs

   If you don't nest them, and don't use set-default, then the same
recovery process would look like this:

# mount -o subvolid=3D0 /dev/sda1 /media/btrfs
# mv /media/btrfs/root /media/btrfs/old-root
# mv /media/btrfs/snapshots/last-root /media/btrfs/root
# umount /media/btrfs

   (This also explains why I wouldn't use set-default, but instead
mount / using a subvol=3D<path> option).

   Now, for making the snapshots in the first place, with nested
subvolumes, your snapshot script looks a bit like this:

# btrfs sub snap / /snapshots/last-root

and with the approach I'd recommend, it looks like this:

# mount -o subvolid=3D0 /dev/sda1 /media/btrfs
# btrfs sub snap /media/btrfs/root /media/btrfs/snapshots/last-root
# umount /media/btrfs

which is a little more complex, but the approach is precisely similar
to the recovery process: mount the top level of the FS on
/media/btrfs, manipulate the subvolumes, and then unmount. This keeps
the management of subvolumes a completely separate concern from the
structure of the filesystem tree.

   Hugo.

> # btrfs subvolume list .
> ID 260 gen 17 top level 5 path active
> ID 261 gen 15 top level 260 path active/home
> ID 262 gen 16 top level 260 path active/var
> ID 263 gen 17 top level 260 path active/etc
>=20
> # btrfs subvolume set-default 260 .
>=20
> In this way, I will not need any kernel command line.
>=20
> >

--=20
Hugo Mills             | Vote early, vote often
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--QxIEt88oQPsT6QmF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVI+euAAoJEFheFHXiqx3kTm0QAKpyfYagLf0sXiTNJg4yf4Ca
Qos3c7lggjmfkJfKvfySsFw2tsL8m+L8UlxnhYV2zeXBpCVNpbbkqrZW1YAV4Ts4
Jw/QxADwvgtPaKdLZKEOv8dwizA1hqghTgBqqFZxs0L6nT3qqfxvs1CK1sSe5Xj6
Em9W3hkXrJdyKa+BzLT6nn9zpIfcsdz6CEe4G+Zxh3NAq1YhNrzerhdg4+FMOGx8
Re2afPQOZYeBKVZSdkhmHMQ6Cr6ikMm7PJpDiYuRCyEP4jI+ICcoNtX7g/rHLUOq
ZUq6h9pSTXjOVG67q3FLYvOIR0J39FWTKeYed9cEba3eCPCB1Dc9CxdLQcvLDrp2
D+LgSq71MvuQh/UVBb/GjnyOi5T6Qd5zm99QfIzt/IC0eQt53mzT77m5eazgFPtx
OFk6SmDnMA7pnoea3M9XwpmGXWhPLaTB+5TLEgpOus316rG+oAiaXkM2r0YUY7Oh
zbYgpAqxee+0JoKBo8YjgDuWCZAzMoDdMqJYJRq8bnb+Bd4Mqb6RMaWXN3KPPrmy
rZOCH7vKNhjCc6/JOMkmwjCag17pBREw1U0HA1EwDzSdRbTKgp29Jfgo6TSjAwUA
jnK2pLRyJqDjGo9JLaioqbY/zn3+lTGxtwneccuG9qPVZEFAFwQk2/Ca4XaMc1ZW
Q4JcqYycKckl75xKf4e7
=wZm9
-----END PGP SIGNATURE-----

--QxIEt88oQPsT6QmF--
