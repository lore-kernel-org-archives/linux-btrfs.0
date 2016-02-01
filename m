Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43484 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbcBAXPd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 18:15:33 -0500
Date: Mon, 1 Feb 2016 23:15:31 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: booting from BTRFS works only with one device in the pool
Message-ID: <20160201231531.GE8313@carfax.org.uk>
References: <56AFCEC3.9050803@friedels.name>
 <20160201221120.GD8313@carfax.org.uk>
 <pan$10266$74d6d340$652029ad$fa234679@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jKBxcB1XkHIR0Eqt"
In-Reply-To: <pan$10266$74d6d340$652029ad$fa234679@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jKBxcB1XkHIR0Eqt
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 01, 2016 at 11:02:42PM +0000, Duncan wrote:
> Hugo Mills posted on Mon, 01 Feb 2016 22:11:20 +0000 as excerpted:
>=20
> > On Mon, Feb 01, 2016 at 10:31:47PM +0100, Hendrik Friedel wrote:
> >> Hello,
> >>=20
> >> I am running CentOS from a btrfs root.
> >> This worked fine until I added a device to that pool:
> >> btrfs device add /dev/sda3 /
> >> reboot
> >>=20
> >> This now causes the errors:
> >> BTRFS: failed to read chunk tree on sdb3 BTRFS: open_ctree failed
> >>=20
> >> Here  I am stuck in a recovery prompt.
> >>=20
> >> btrfs fi show displays the file system correctly with 2.1GiB used for
> >> sdb3 and 0.00GiB used on sda3
> >=20
> > By far the simplest and most reliable method of doing this is to
> > use an initramfs with the command "btrfs dev scan" in it somewhere
> > before mounting. Most of the major distributions already have an
> > initramfs set up (as does yours, I see), and will install the correct
> > commands in the initramfs if you install the btrfs-progs package
> > (btrfs-tools in Debian derivatives).
> >=20
> > The other approach is to add "device=3D/dev/sda3,device=3D/dev/sdb3" to
> > the "rootflags=3D" option on the grub command line, but that's going to
> > break if your kernel or hardware decides to reorder your devices.
>=20
> As a btrfs user with a two-device btrfs root filesystem who has had to=20
> deal with this same problem myself...
>=20
> Unless the problem has been fixed in very recent kernels, device=3D doesn=
't=20
> work in rootflags=3D for btrfs on the kernel commandline in any case.  I=
=20
> don't know why, but I suspect it might be the fact that with=20
> rootflags=3Ddevice=3D, there's at least two =3D, and the kernel may split=
 it at=20
> the wrong =3D and instead of seeing a rootflags=3D option it knows what t=
o do=20
> with, it sees a rootflags=3Ddevice=3D option that it ignores as making no=
=20
> sense, making it a kernel commandline parsing bug.  Alternatively,=20
> another poster hinted that the kernel may get it correct, but btrfs for=
=20
> some reason can't use device=3D in the form it gets passed in from=20
> rootflags=3D, while it can use it when passed in from userspace, which=20
> would make it a btrfs bug.
>=20
> Either way, (1) the problem isn't new and has been there for quite some=
=20
> time, since early in the kernel 3.x era at least, but (2) other options=
=20
> such as degraded _can_ be passed successfully by rootflags=3D, so btrfs c=
an=20
> use rootflags=3D in general, it just has problems with device=3D, for=20
> whatever reason.
>=20
> Which means...
>=20
> > Do the sensible thing and just use the initramfs solution.
>=20
> Exactly.
>=20
> For over a decade I used reiserfs on / and was able to avoid an initr*=20
> entirely.  And single-device btrfs / works without an initr*.  But multi-
> device... not so much.  While I definitely wasn't thrilled at the=20
> prospect of having to complicate my boot process with an initr* that=20
> _shouldn't_ be necessary, and had to spend some time learning about initr=
*=20
> (I had initially dumped initr* early in my Linux experience and hadn't=20
> had to learn about them until I tried multi-device btrfs /) so as to be=
=20
> able to satisfy myself that I could work with it in both normal operation=
=20
> and disaster recovery scenarios...
>=20
> At this point there's really only two choices if you want multi-device=20
> btrfs /, either use an initr* and have your multi-device btrfs /, or give=
=20
> up on multi-device btrfs / and be satisfied with a more traditional=20
> single-device /, btrfs or otherwise.
>=20
> Well, unless you're a kernel-level dev sufficiently motivated to look=20
> into the problem, devise a patch to solve the problem, and get that patch=
=20
> thru the approval process and into kernel mainline.  In that case there's=
=20
> three options, and I dearly wish someone with the necessary kernel level=
=20
> coder qualification would take that third option, making initr*less multi-
> device btrfs / a viable option for the rest of us who in the mean time=20
> are stuck with only the first two options!

   The problem with that approach is that you're going to have to put
policy into the kernel (which devices do you bother to scan? -- we've
hit this already with long scan times caused by timeouts on /dev/fd0
and /dev/cdrom0). That on its own is, I think, enough to doom any
attempt at putting device scan into the kernel.

   An initramfs has been a requirement for so many configurations for
so long, and has largely been a solved problem for the major
distributions, I'm really bemused about people's adamant resistance to
having one. It's *less* trouble than a kernel-based solution, because
at least it's easier to debug. With a decent initramfs builder, you
can get a recovery shell to poke around and fix things (or at least
determine what's broken).

   Hugo, wearing the Hat of Limited Sympathy.

--=20
Hugo Mills             | What's a Nazg=FBl like you doing in a place like t=
his?
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                Ill=
iad

--jKBxcB1XkHIR0Eqt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWr+cTAAoJEFheFHXiqx3kPgkP+gM/xOWgVIZglpu10et5ZwhH
c8ekykRHTMqorsmlzpEPbvRNsuRHbE0hBxeszW54Fi1X7Ua/1vtEczt1Vdl+20rj
L09FgqbkufAGE0WjpZdV9gCPsES+9vMFMiADRbplACUmALBBVw9oTIoh0n1WxDxl
Yeuv2EP+o2K7ZKrKg6hMkXSMT/i4U5ULK+cTfjAPznLYAtSv0WkYHx29cd73/4C1
viW3AZ8J4YFvPZwoP6yAMs4E9SmKPIQABaH9VKUCS1eBVBfh8KDROJFHdKMaHUU8
aed9WbaISvOUYEdGR7U6W5t37cPBj8MYEZ24ad6xSb/JVCNZJJPY0auzVG4GtIC+
JFW/RP6i91cDZtx9eiRtRdE1iOhuHHzLrQDyyUJ92W2nAlYe2kUB/otjpde18dEJ
/K9SLx3SW6nBCXEcfrVC8TU8kj018zx/YvBk3aiGji4SpTrVIFyZxo1y7+ZnWWoX
Yn+LCsO7xcJ/8UBZC2GFK20UYrj3yM6pqMofIMk/ya2iiBagQyWgu1AcaB/r84a7
DUhFurFTahOJZqlbD7VxDVj0SawfU+565fxgYInGNseR0IdvJrElIZiMWXK9phtM
lcpUV6Nsf5r1lZZabg/vzVT23YnqhtZ9daLktRpFl+B7HHdC+jjJUux33iuZQxls
xCFiqdC/7i1jP6vlt4/r
=seTA
-----END PGP SIGNATURE-----

--jKBxcB1XkHIR0Eqt--
