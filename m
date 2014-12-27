Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56094 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaL0Jar (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 04:30:47 -0500
Date: Sat, 27 Dec 2014 09:30:43 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Message-ID: <20141227093043.GJ25267@carfax.org.uk>
References: <3738341.y7uRQFcLJH@merkaba>
 <549DE5C6.2000606@pobox.com>
 <4232026.31LFOYpm2s@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x0KprKst+ZOYEj2z"
In-Reply-To: <4232026.31LFOYpm2s@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--x0KprKst+ZOYEj2z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 27, 2014 at 10:01:17AM +0100, Martin Steigerwald wrote:
> Am Freitag, 26. Dezember 2014, 14:48:38 schrieb Robert White:
> > On 12/26/2014 05:37 AM, Martin Steigerwald wrote:
> > > Hello!
> > >=20
> > > First: Have a merry christmas and enjoy a quiet time in these days.
> > >=20
> > > Second: At a time you feel like it, here is a little rant, but also a=
 bug
> > > report:
> > >=20
> > > I have this on 3.18 kernel on Debian Sid with BTRFS Dual SSD RAID with
> > > space_cache, skinny meta data extents =E2=80=93 are these a problem? =
=E2=80=93 and
> >=20
> > > compress=3Dlzo:
> > (there is no known problem with skinny metadata, it's actually more
> > efficient than the older format. There has been some anecdotes about
> > mixing the skinny and fat metadata but nothing has ever been
> > demonstrated problematic.)
> >=20
> > > merkaba:~> btrfs fi sh /home
> > > Label: 'home'  uuid: b96c4f72-0523-45ac-a401-f7be73dd624a
> > >=20
> > >          Total devices 2 FS bytes used 144.41GiB
> > >          devid    1 size 160.00GiB used 160.00GiB path
> > >          /dev/mapper/msata-home
> > >          devid    2 size 160.00GiB used 160.00GiB path
> > >          /dev/mapper/sata-home
> > >=20
> > > Btrfs v3.17
> > > merkaba:~> btrfs fi df /home
> > > Data, RAID1: total=3D154.97GiB, used=3D141.12GiB
> > > System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> > > Metadata, RAID1: total=3D5.00GiB, used=3D3.29GiB
> > > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> >=20
> > This filesystem, at the allocation level, is "very full" (see below).
> >=20
> > > And I had hangs with BTRFS again. This time as I wanted to install tax
> > > return software in Virtualbox=C2=B4d Windows XP VM (which I use once =
a year
> > > cause I know no tax return software for Linux which would be suitable=
 for
> > > Germany and I frankly don=C2=B4t care about the end of security cause=
 all
> > > surfing and other network access I will do from the Linux box and I o=
nly
> > > run the VM behind a firewall).
> >=20
> > > And thus I try the balance dance again:
> > ITEM: Balance... it doesn't do what you think it does... 8-)
> >=20
> > "Balancing" is something you should almost never need to do. It is only
> > for cases of changing geometry (adding disks, switching RAID levels,
> > etc.) of for cases when you've radically changed allocation behaviors
> > (like you decided to remove all your VM's or you've decided to remove a
> > mail spool directory full of thousands of tiny files).
> >=20
> > People run balance all the time because they think they should. They are
> > _usually_ incorrect in that belief.
>=20
> I only see the lockups of BTRFS is the trees *occupy* all space on the de=
vice.

   No, "the trees" occupy 3.29 GiB of your 5 GiB of mirrored metadata
space. What's more, balance does *not* balance the metadata trees. The
remaining space -- 154.97 GiB -- is unstructured storage for file
data, and you have some 13 GiB of that available for use.

   Now, since you're seeing lockups when the space on your disks is
all allocated I'd say that's a bug. However, you're the *only* person
who's reported this as a regular occurrence. Does this happen with all
filesystems you have, or just this one?

> I *never* so far saw it lockup if there is still space BTRFS can allocate=
 from=20
> to *extend* a tree.

   It's not a tree. It's simply space allocation. It's not even space
*usage* you're talking about here -- it's just allocation (i.e. the FS
saying "I'm going to use this piece of disk for this purpose").

> This may be a bug, but this is what I see.
>=20
> And no amount of "you should not balance a BTRFS" will make that percepti=
on go=20
> away.
>=20
> See, I see the sun coming out on a morning and you tell me "no, it doesn=
=C2=B4t".=20
> Simply that is not going to match my perception.

   Duncan's assertion is correct in its detail. Looking at your space
usage, I would not suggest that running a balance is something you
need to do. Now, since you have these lockups that seem quite
repeatable, there's probably a lurking bug in there, but hacking
around with balance every time you hit it isn't going to get the
problem solved properly.

   I think I would suggest the following:

 - make sure you have some way of logging your dmesg permanently (use
   a different filesystem for /var/log, or a serial console, or a
   netconsole)

 - when the lockup happens, hit Alt-SysRq-t a few times

 - send the dmesg output here, or post to bugzilla.kernel.org

   That's probably going to give enough information to the developers
to work out where the lockup is happening, and is clearly the way
forward here.

   Hugo.

--=20
Hugo Mills             | w.w.w. -- England's batting scorecard
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--x0KprKst+ZOYEj2z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUnnxDAAoJEFheFHXiqx3kP7gP/0mYqU4vk3XjZxrx7XNw+GC/
HW4J/3v1fh9sHtTcTYz7uIpVCytALWXllkNwxdzPqAE3QD0GaQU7aXi8hGO1sqL5
PjGDqlaxlVXaLllMzXZB2oL1EoOQGWZ5BvXoUcg1+BeU0MRMFxyEPRAz/WTZU7qc
TPMbEYpvEB/zlKpLwcNuTrHDDq0tJqn2uZ6NWPPFzUetKoL78cI/Y8jenK1YUuOJ
TRDbpK6SYs1K8DCzXRkMDQAbC8Ka57FUv8oX1OTK6oiD17JiSwoXRw/oFunz5i1T
hsW7TOb0TvXwgkm/5YGRVd0HqFrCAYjvEMWhUtxWQHM0Kdv/vMdGetcCk+qkzMFU
vNFvUDuwKkBMMUrmJ3RjE4AAWihQwvX5/+NoPFs+hCTjhivVUvhvSSDGo9/QxrJz
Y2/wcyQI3RcTX7mPUePyTWtW9D54ipjA8L2wGosK5A2RjrK/4rwqydncc3I5QVy/
vN6F/UWfiZc2cuDtkZbKBErJ3+i+M3K5fiu50r4b2vC3jDV/EPPJpPoWMykY56hP
TRh0tVR7MoMVrctr+S1GjyQz+J2s5hhkGwc2dinA2lWN1+T7zZFg9VxWqqGpV8qv
r7OkyK5qKikcRzllxex7SHwVId7xvVurbh9d4ZC8gNB28azUUuLYLlivgTzPxvr1
ebm65Snv8zTsPISBmAV0
=45Dp
-----END PGP SIGNATURE-----

--x0KprKst+ZOYEj2z--
