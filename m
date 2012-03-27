From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs: open_ctree failed
Date: Tue, 27 Mar 2012 14:02:08 +0100
Message-ID: <20120327130208.GC2597@carfax.org.uk>
References: <CANDob0+rwkLGeJg4kP+TpPpN8VOdrOV684F5YiLC6+BkzYehHA@mail.gmail.com>
 <CANDob0+cBXnNH1dZ5socF7vaNoAB8wHACA4cN-w_1Z4T=VKUbA@mail.gmail.com>
 <20120326215740.GA2597@carfax.org.uk>
 <CANDob0JDQKObq8L2s8E7D9x_=k=MgsaMu=g0DBaZqGqCO_O70Q@mail.gmail.com>
 <20120326224729.GB2597@carfax.org.uk>
 <CANDob0KMJXQT47MusDnwTMLV5E=whSOSp+E8zAw2ZF6hTsNyOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Cc: linux-btrfs@vger.kernel.org
To: Not Zippy <notzippy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANDob0KMJXQT47MusDnwTMLV5E=whSOSp+E8zAw2ZF6hTsNyOg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 27, 2012 at 05:58:17AM -0700, Not Zippy wrote:
> One entire subvolume was restored. But there were 4 subvolumes on that
> partition. Is there a way to specify/force the restore of a different
> subvolume ?
>=20
> find-root seems to only find a single root.

   There is only a single root tree, so that's understandable. If you
have a look at the documentation for restore[1], it mentions (right
near the bottom of the page) that -r will allow you to select an
alternative subvolume to recover from.

   Hugo.

[1] http://btrfs.ipv5.de/index.php?title=3DRestore

> thanks
>=20
> On Mon, Mar 26, 2012 at 3:47 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Mon, Mar 26, 2012 at 03:36:13PM -0700, Not Zippy wrote:
> >> Hugo
> >> I did try the dangerdonteveruse branch and thats the error btrfsck
> >> --repair gave me.
> >
> > =A0 Oooh, a brave one, I see. ;)
> >
> >> Looks like the btrfs-restore command may work (thanks!). And yes I
> >> do have backups for the important data - I had some other data on
> >> there which would need to be d/l again..
> >
> > =A0 Excellent. We don't need to set the hounds onto you, then.
> >
> >> I don't dabble that much with the kernel - this is a straight ubuntu
> >> which I regularly do their updates - Can I advance the kernel beyond ?
> >
> > =A0 Yes, there's a PPA[1] for it (documented in the "Getting Started"
> > page on the btrfs wiki at [2]).
> >
> > [1] http://kernel.ubuntu.com/~kernel-ppa/mainline/
> > [2] http://btrfs.ipv5.de/index.php?title=3DGetting_started#Ubuntu_Linux
> >

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- The enemy have elected for Death by Powerpoint. That's what ---  =20
                         they shall get.  -- gdb                        =20

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPcbpPIKyzvlFcI40RAqiTAJ4mfWF/Rc7/Kxg0mVCbX8c6VgKSFgCfQBXA
dQb/NtcdXaEufD0j19/u1II=
=NELo
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
