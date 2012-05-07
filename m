From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Mon, 7 May 2012 11:59:44 +0100
Message-ID: <20120507105944.GD8938@carfax.org.uk>
References: <C8PBkd9uCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mSxgbZZZvrAyzONB"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8PBkd9uCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--mSxgbZZZvrAyzONB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 07, 2012 at 12:46:00PM +0200, Helmut Hullen wrote:
> Hallo,
>=20
> "never change a running system" ...
>=20
> For some months I run btrfs unter kernel 3.2.5 and 3.2.9, without =20
> problems.
>=20
> Yesterday I compiled kernel 3.3.4, and this morning I started the =20
> machine with this kernel. There may be some ugly problems.
>=20
> Copying something into the btrfs "directory" worked well for some files, =
=20
> and then I got error messages (I've not copied them, something with "IO =
=20
> error" under Samba).
>=20
> Rebooting the machine with kernel 3.2.9 worked, copying 1 file worked, =
=20
> but copying more than this file didn't work. And I can't delete this =20
> file.
>=20
> That doesn't please me - copying more than 4 TBytes wastes time and =20
> money.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D configuration =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> /dev/sdc1 on /srv/MM type btrfs (rw,noatime)
>=20
> /dev/sdc: SAMSUNG HD204UI: 25 =B0C
> /dev/sdf: WDC WD30EZRX-00MMMB0: 30 =B0C
> /dev/sdi: WDC WD30EZRX-00MMMB0: 29 =B0C
>=20
> Data, RAID0: total=3D5.29TB, used=3D4.29TB
> System, RAID1: total=3D8.00MB, used=3D352.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, RAID1: total=3D149.00GB, used=3D5.00GB
>=20
> Label: 'MMedia'  uuid: 9adfdc84-0fbe-431b-bcb1-cabb6a915e91
> 	Total devices 3 FS bytes used 4.29TB
> 	devid    3 size 2.73TB used 1.98TB path /dev/sdi1
> 	devid    2 size 2.73TB used 1.94TB path /dev/sdf1
> 	devid    1 size 1.82TB used 1.63TB path /dev/sdc1
>=20
> Btrfs Btrfs v0.19
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D boot messages, =
kernel related =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> [boot with kernel 3.3.4]
> May  7 06:55:26 Arktur kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 0=
x10000 action 0xe frozen
> May  7 06:55:26 Arktur kernel: ata5: SError: { PHYRdyChg }
> May  7 06:55:26 Arktur kernel: ata5: hard resetting link
> May  7 06:55:31 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
> May  7 06:55:31 Arktur kernel: ata5: reset failed (errno=3D-19), retrying=
 in 6 secs
> May  7 06:55:36 Arktur kernel: ata5: hard resetting link
> May  7 06:55:38 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
> May  7 06:55:38 Arktur kernel: ata5: reset failed (errno=3D-19), retrying=
 in 9 secs
> May  7 06:55:46 Arktur kernel: ata5: hard resetting link
> May  7 06:55:47 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
> May  7 06:55:47 Arktur kernel: ata5: reset failed (errno=3D-19), retrying=
 in 34 secs
> May  7 06:56:21 Arktur kernel: ata5: hard resetting link
> May  7 06:56:22 Arktur kernel: ata5: SATA link up 1.5 Gbps (SStatus 113 S=
Control 310)
> May  7 06:56:22 Arktur kernel: ata5.00: configured for UDMA/100
> May  7 06:56:22 Arktur kernel: ata5: EH complete
> May  7 07:12:07 Arktur kernel: ata5.00: exception Emask 0x10 SAct 0x0 SEr=
r 0x10000 action 0xe frozen
> May  7 07:12:07 Arktur kernel: ata5: SError: { PHYRdyChg }
> May  7 07:12:07 Arktur kernel: ata5.00: failed command: WRITE DMA EXT
> May  7 07:12:07 Arktur kernel: ata5.00: cmd 35/00:00:00:62:50/00:04:5e:00=
:00/e0 tag 0 dma 524288 out
> May  7 07:12:07 Arktur kernel:          res d8/d8:d8:d8:d8:d8/d8:d8:d8:d8=
:d8/d8 Emask 0x12 (ATA bus error)
> May  7 07:12:07 Arktur kernel: ata5.00: status: { Busy }
> May  7 07:12:07 Arktur kernel: ata5.00: error: { ICRC UNC IDNF }

   This is a hardware error. You have a device that's either dead or
dying. (Given the number of errors, probably already dead).

> May  7 07:12:07 Arktur kernel: ata5: hard resetting link
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The 3 btrfs disks are connected via a SiI 3114 SATA-PCI-Controller.
> Only 1 of the 3 disks seems to be damaged.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Ca I repair the system? Or have I to copy it to a set of other disks?

   If you have RAID-1 or RAID-10 on both data and netadata, then you
_should_ in theory just be able to remove the dead disk (physically),
then btrfs dev add a new one, btrfs dev del missing, and balance.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                        --- argc, argv, argh! ---                       =20

--mSxgbZZZvrAyzONB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPp6sgIKyzvlFcI40RAlJsAKDA2UcRRjNPe42s/hWsdHEj0ghElQCgkFFu
iIxOfgootSjPH3BN+ARGl/U=
=BFvF
-----END PGP SIGNATURE-----

--mSxgbZZZvrAyzONB--
