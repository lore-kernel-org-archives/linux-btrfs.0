From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: How to remove a device on a RAID-1 before replacing it?
Date: Tue, 29 Mar 2011 22:15:46 +0100
Message-ID: <20110329211546.GA4082@carfax.org.uk>
References: <AANLkTinpGXaF_=nZW+uB8zEBG8XPZbwrn+HW48JG_02P@mail.gmail.com>
 <AANLkTi=SiesmPbkwoCHSpxDaLK_S8EcZEbBBtVFZUV_j@mail.gmail.com>
 <AANLkTimXOFpfWS=8bxLyYiPLS_qBFbWG-g8VKsxLMEcD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andrew Lutomirski <luto@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimXOFpfWS=8bxLyYiPLS_qBFbWG-g8VKsxLMEcD@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 29, 2011 at 05:01:39PM -0400, Andrew Lutomirski wrote:
> On Tue, Mar 29, 2011 at 4:21 PM, cwillu <cwillu@cwillu.com> wrote:
> > On Tue, Mar 29, 2011 at 2:09 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> >> I have a disk with a SMART failure. =A0It still works but I assume it'=
ll
> >> fail sooner or later.
> >>
> >> I want to remove it from my btrfs volume, replace it, and add the new
> >> one. =A0But the obvious command doesn't work:
> >>
> >> # btrfs device delete /dev/dm-5 /mnt/foo
> >> ERROR: error removing the device '/dev/dm-5'
> >>
> >> dmesg says:
> >> btrfs: unable to go below two devices on raid1
> >>
> >> With mdadm, I would fail the device, remove it, run degraded until I
> >> get a new device, and hot-add that device.
> >>
> >> With btrfs, I'd like some confirmation from the fs that data is
> >> balanced appropriately so I won't get data loss if I just yank the
> >> drive. =A0And I don't even know how to tell btrfs to release the drive
> >> so I can safely remove it.
> >>
> >> (Mounting with -o degraded doesn't help. =A0I could umount, remove the
> >> disk, then remount, but that feels like a hack.)
> >
> > There's no "nice" way to remove a failing disk in btrfs right now
> > ("btrfs dev delete" is more of a online management thing to politely
> > remove a perfectly functional disk you'd like to use for something
> > else.) =A0As I understand things, the only way to do it right now is the
> > umount, remove disk, remount w/ degraded, and then btrfs add the new
> > device.
> >
>=20
> Well, the disk *is* perfectly functional.  It just won't be for long.
>=20
> I guess what I'm saying is that either btrfs dev delete isn't really
> working -- I want to be able to convert to non-RAID and back or
> degraged and back or something else equivalent.

   RAID conversion isn't quite ready yet, sadly. As I understand it,
you've got two options:

 - Yoink the drive (thus making the fs run in degraded mode), add the
   new one, and balance to spread the duplicate data onto the new
   volume.

 - Add the new drive to the FS first, then use btrfs dev del to remove
   the original device. This should end up writing all the replicated
   data to the new drive as it "removes" the data from the old one.

   Of the two options, the latter is (for me) the favourite, as you
don't end up with a filesystem that's running on just a single copy of
the data.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- Prof Brain had been in search of The Truth for 25 years, with --- =20
             the intention of putting it under house arrest.            =20

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNkkwCIKyzvlFcI40RAnRfAJ99Fdav1vUErojAt6QhgOBqA0kdpgCfe6w9
Vd/CTVEsv4nea+TQN1fPUEo=
=j8Wi
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
