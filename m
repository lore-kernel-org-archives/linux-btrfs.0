From: Libor =?utf-8?q?Klep=C3=A1=C4=8D?= <libor.klepac@bcom.cz>
Subject: Re: Raid1 resync
Date: Fri, 11 Mar 2011 16:28:46 +0100
Message-ID: <201103111628.48231.libor.klepac@bcom.cz>
References: <201103111405.49352.libor.klepac@bcom.cz> <AANLkTi=55pb-o+sFhO4Apgz=QZ3p46DGc8YUcqH+G0F1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3367007.F5N1H75Fcy";
  protocol="application/pgp-signature";
  micalg=pgp-sha256
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=55pb-o+sFhO4Apgz=QZ3p46DGc8YUcqH+G0F1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3367007.F5N1H75Fcy
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,
sorry for my bad wording, i have no crash with btrfs, I'm considering to=20
switch to btrfs on ssd disk comming back from warranty claim.
I was just asking, whether it's posible to switch my old setup (i described=
 in=20
my first mail) using mdraid to using btrfs internal raid without using mdra=
id,=20
ie whether it's possible to resync changed data on iscsi disk when i come t=
o=20
work in morning.

With regards
Libor

PS. If this mailing list is for bug/patches reporting only, then i'm sorry =
for=20
making unvanted mail traffic.


Dne p=C3=A1tek 11 B=C5=99ezen 2011 15:41:25 Wenyi Liu napsal(a):
> Hi Libor:
>     Maybe, you can attach your oops at first.
>=20
> ---
> Best Regards,
> Liu Wenyi
>=20
> 2011/3/11 Libor Klep=C3=A1=C4=8D <libor.klepac@bcom.cz>
>=20
> > Hi,
> > before my ssd crashed, my /home partion was sitting on md raid1
> > consisting of partition on disk and iScsi LUN in network, it was created
> > with bitmaps and iscsi lun was set writemostly.
> > So when i came to work, i fired up iscsi, added lun to raid and partial
> > resync went ahead.
> > Before leaving work, i failed iscsci disk and kicked it from raid.
> > I would like to use something like this with btrfs, without mdraid below
> > it.
> >=20
> > Is it somehow posible?
> > 1) I can't go below 2 devices.
> > 2) Does btrfs support resync only of changed blocks like mdraid with
> > bitmaps?
> >=20
> > Thanks
> > Libor

--nextPart3367007.F5N1H75Fcy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJNej+vAAoJEPDvjG7Cn0eObhIP/0DFeEUYfn6mmlKddHAY8MXg
ovkxMNbKhXJPg4HkZ0H++lSXoWGHycmEsY4JeAkB1QF87QAvUqyNY73Q23NAG07v
7Pb/wm5I9FUOpt1OBxUyzPlYCyfDZfPOe/2z3ud9gnAmmbA+nOdyHxf0uRbZdPsl
bGSeaq0DR1hKn0Vc+u+fetVkCylwdXR+dgIfbkbH5o1H51z9LfbBMfv4BZNS122n
wmrCPzbUeRk4J0Y633MvNZVqGasVi6TKULsO3Qr2F8hAC8260t4BtlpfTOHJiFKW
IN1rYM6fA/Pi6/EhxZ0ckE37GzovUcica33I2Bz1CWj8qHcXrwOocwNxCVXZgkhS
lhmUt84JZjNnyWvEFADW+caP5s7O2H6fWPOak3aQmXQ5vehRK7Mcz+IuZVBcZaVD
pNYSSGOLmxbTiQE95n6l4jxGUZfbX4yHatPauq8x80GypYPuKrq0ibz5ZEmqUoav
4wrmEt+QLFvw9TlmQ45LqCnV5/QC0badOySQPQWDUc8wF+KM5E/yFVJTH66CHLFO
pnikiq6iO/0UX/sZMA8EgMZp0to5DExsImgl+0Y4eYWSJgVvEfQOfnEIUUfjdmn4
3gWDdKK9/9ugTGJNgQMGUQ3xvcyrVIAySHHZJq7lt6oSj8GUTIe7l7fFBQvFtQal
w6nedVMahrqwEhLnbTPi
=8SwI
-----END PGP SIGNATURE-----

--nextPart3367007.F5N1H75Fcy--
