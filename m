Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ngcobalt08.manitu.net ([217.11.48.108]:43672 "EHLO
	ngcobalt08.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbbFAOGi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 10:06:38 -0400
Message-ID: <556C64E4.9070101@dergleichrichter.de>
Date: Mon, 01 Jun 2015 15:57:56 +0200
From: Justus Seifert <justus.seifert@dergleichrichter.de>
MIME-Version: 1.0
To: Neal Becker <ndbecker2@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [newb] move /home to subvolume
References: <mkhjkp$hgl$1@ger.gmane.org> <CAO5K3OfGP6SxK0Ch9XSu1dGZgjEx8G7-b19+2m0tGHzpjY++Zg@mail.gmail.com> <mkhl70$fnu$1@ger.gmane.org>
In-Reply-To: <mkhl70$fnu$1@ger.gmane.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="S3Jmju1URIGi07jx7kfn6qlUecFcTjsDv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S3Jmju1URIGi07jx7kfn6qlUecFcTjsDv
Content-Type: multipart/mixed;
 boundary="------------030006010508000704010200"

This is a multi-part message in MIME format.
--------------030006010508000704010200
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01.06.2015 15:03, Neal Becker wrote:
> So I think what I need to do is:
>=20
> 1. boot off some rescue media
> 2. mount the target btrfs volume (e.g., /mnt/sysimage/root)
> 3. mv exising home (mv /mnt/sysimage/home /mnt/sysimage/oldhome)
> 4. create new subvolume (btrfs subvolume create /mnt/sysimage/home)
> 5. move all the files from /mnt/sysimage/oldhome /mnt/sysimage/home - n=
ot=20
> sure easiest way to do this step
> 6. edit /mnt/sysimage/etc/fstab to mount new /home
>=20
> I have another machine, setup more or less this way:
> UUID=3D7246327b-1905-4fe2-9b6b-b9376017264f /                       btr=
fs  =20
> subvolid=3D5,subvol=3Droot00 0 0
> UUID=3D2c04be93-34c1-4016-ba41-60fd9fd90616 /boot                   ext=
4   =20
> defaults        1 2
> UUID=3D7246327b-1905-4fe2-9b6b-b9376017264f /home                   btr=
fs  =20
> subvol=3Dhome     0 0
>=20
>=20
>=20
> Vytautas D wrote:
>=20
>> as far as I know, you can't do this, you need to temporary move /home
>> somewhere else, create /home subvolume and copy everything back.
>>
>> -
>> Vytas
>>
>> On Mon, Jun 1, 2015 at 1:36 PM, Neal Becker <ndbecker2@gmail.com> wrot=
e:
>>> I have everything under /:
>>>
>>> sudo btrfs subvolume list /
>>> ID 257 gen 65795 top level 5 path root
>>>
>>> I want to move /home onto it's own subvolume.  I hope I can do this w=
hile
>>> the root device is mounted.
>>>
>>> What is the procedure?
>>>
>>> I tried first to create a subvolume for /home at the top-level, but
>>> couldn't figure out the syntax:
>>>
>>> [nbecker@nbecker2 ~]$ sudo btrfs subvolume create /home
>>> [sudo] password for nbecker:
>>> ERROR: '/home' exists
>>>


i think you can speed up step 5 there by not using mv but cp
--reflink=3Dauto and deleting the old copy once you are done.  reflinks
are shared between subvolumes.

justus

--------------030006010508000704010200
Content-Type: text/x-vcard; charset=utf-8;
 name="justus_seifert.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="justus_seifert.vcf"

begin:vcard
fn:Justus Seifert
n:Seifert;Justus
adr:;;;Dresden;Saxony;;Germany
email;internet:justus.seifert@dergleichrichter.de
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------030006010508000704010200--

--S3Jmju1URIGi07jx7kfn6qlUecFcTjsDv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVbGTkAAoJELFJh75Z+IvIknMP/3MgP5BvDuOxgCfMB4A1r/3M
LKtYiwHVqzSwnoU/SsZasCtAaXDZ99pybVeSbmur3JcoOKAGSWVztojiRpVid8bW
kM43kaxiRHrTboBsEKEFpG9YVELXkNZ60Srl/hY1flXvJqjU7yw86ZJH0tvtqwcC
m1uT+PD8/1j3/aSQqs9r9RTceC5kQtMrMK6D4c7cMNDgaS0dhuVfIF33bMMvE/CM
bP2ITwBgQqMLa9RU7ow+nNRvKtJIXkA89xxmaCvj99USOQ4q8qTEdPr6nw59Bgw+
mMbVRIr54TFXaymEoBQR19ABPLtOn6NYtlzJqit3xiTlvK3FFMbT3C49Oh1tOlVw
ZEvDhcWihif8+Pmsmsqt7llFCNp241vYbf5lbRgJD2Vz73s1vUSFA+/KAvKJi6cU
1W/b31oc6RrLoap26y7ylUlVZh7zDjJsIh852wbKqgSr9VI9wfNkI7vjlmA8dp61
u/2602V1bIb/JqnndF7t4q5yLMwSzg5M4baxHy6dLTHWOruUkDaiVyXi2M2qnBPF
EDwAjpTxV/lcDRfu/lgC9NxL9F8Du1F6SHaPhiq0vqXKyW6FRB0CyM9+c57rAT6R
khINEIyk6bPejjmkw0bRzgQIOxGs496C0b0TJCZimEcF8j9gTGfoYAN8BPITNY5k
QUMl6/PJL0l89wbEWDkH
=zY6w
-----END PGP SIGNATURE-----

--S3Jmju1URIGi07jx7kfn6qlUecFcTjsDv--
