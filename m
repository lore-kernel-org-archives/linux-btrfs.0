Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47244 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbHPO5W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Aug 2015 10:57:22 -0400
Date: Sun, 16 Aug 2015 14:57:19 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: understanding btrfs fi df
Message-ID: <20150816145719.GU12976@carfax.org.uk>
References: <55D09F50.5070900@friedels.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4rQ9lIe3OahbhU4J"
In-Reply-To: <55D09F50.5070900@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4rQ9lIe3OahbhU4J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 16, 2015 at 04:33:52PM +0200, Hendrik Friedel wrote:
> Hello,
>=20
> I am struggling to understand the output of btrfs fi df:
>=20
> btrfs fi df /mnt/__Complete_Disk/
> Data, RAID5: total=3D3.85TiB, used=3D3.85TiB
> System, RAID5: total=3D32.00MiB, used=3D576.00KiB
> Metadata, RAID5: total=3D6.46GiB, used=3D5.14GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> I have three disks:
>=20
> btrfs fi show
> Label: none  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
>         Total devices 3 FS bytes used 3.85TiB
>         devid    1 size 2.73TiB used 2.73TiB path /dev/sdf
>         devid    2 size 2.73TiB used 2.24TiB path /dev/sdd
>         devid    3 size 2.73TiB used 2.73TiB path /dev/sde

   Here's your problem -- you've got a RAID 5 filesystem, which has a
minimum allocation of 2 devices, but only one device has free space on
it for allocation, so no more chunks can be allocated. I'm not sure
how it ended up in this situation, but that's what's happened.

   From btrfs fi df, you've filled up all the existing data
allocation, so the usual filtered balance isn't going to help, because
there's no space within the existing allocation to compact the storage
into.

   You will need to free up some space on devices 1 and 3, and then
run a full balance. There are two ways I can see of doing this:

1) add a small (4-8 GiB, say) block device, do a full balance, and
then delete the device again:

# btrfs dev add /dev/sdx /mnt/__Complete_Disk
# btrfs balance start /mnt/__Complete_Disk
# btrfs dev del /dev/sdx /mnt/__Complete_Disk

2) convert a few chunks of the existing FS, on devices 1 and 3, to
single, which should free up some space across all the devices, and
then run a full balance, and finally convert the single back to RAID
5:

# btrfs balance start -dconvert=3Dsingle,devid=3D1,limit=3D4 /mnt/__Complet=
e_Disk
# btrfs balance start -dconvert=3Dsingle,devid=3D3,limit=3D4 /mnt/__Complet=
e_Disk
# btrfs balance start -dprofiles=3Draid5 /mnt/__Complete_Disk
# btrfs balance start -dconvert=3Draid5,soft /mnt/__Complete_Disk

   Hugo.

> So I would expect around 5.4TiB to be available. In fact I am
> currently using 4.4TiB and the drive seems to be full (I cannot
> store more data).
>=20
> I went through Marcs Blog post on this, but the hints there did not
> help. In particular:
>  btrfs balance start -dusage=3D95 /mnt/__Complete_Disk/ (started with 55)
>=20
> What's wrong here?
>=20
> Regards,
> Hendrik
>=20
> ---
> Diese E-Mail wurde von Avast Antivirus-Software auf Viren gepr=FCft.
> https://www.avast.com/antivirus
>=20

--=20
Hugo Mills             | =A91973 Unclear Research Ltd
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--4rQ9lIe3OahbhU4J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV0KTPAAoJEFheFHXiqx3kP+IP/AnvMJly4kRimv30MJU7gQ++
ddQnPepPuG8CMTK9ciTSC8PQcYZdVhLBtlUP3b/PWgv7oKlqMmUOqhx+UbHIG6Ht
y/WHt1AqZbmccXcMb0/ncgcbPalHVJ33a8CM6wCqBDuU4sE01Kyby+VrTOGh348+
8qc7nlR01+l1+jExf+sMYvEHT/+Oi5SOPxTsgpv9DjSGHF5WkyzuWKvYf4PVNq98
E17FWhc98cKNDFN09V/lKwJ9GbRQ+d2uJc/JyBpCsxMc7K4InP9fD6vLyd+fUMwd
aeO0zgWE/ZLNKhBo1IvDiyVzKj1HQ9adIRgUf3EozUtTi986COEhZ+jsWd0ETf16
C5LPcBA04P5B2oTGBSdE7tWuNSthDrImNuPy9PWXDIwZz0tGdGhhQDpd7kscbcPa
KtZGOiODzuFHAzrWBwF/wPCmP41M7f8Q6WUsGQWp8oGB+Mw82nN1C+hATnYgVK5S
v/eawiw0MqWbVMoujeAo5rdN4+1Cm5jbbM3NUkB6wYzdlT6iEVxUb7yo317E9zu1
+DsaHV8nlGrwNCelYDTpbqRnWiszTs4FsWXcICtDtunkFRNmY43GnrA34UGOobO0
JP8CzlkJkjkUsYc6gRmBn3/l/3/hvjRdz+6rrvxHFJJMGb9ndtCl9M4gzxG8CUHP
7sR3ySNtivHpjS86DFzV
=qDd0
-----END PGP SIGNATURE-----

--4rQ9lIe3OahbhU4J--
