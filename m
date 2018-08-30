Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:32863 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727496AbeH3OKh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 10:10:37 -0400
Subject: Re: How to erase a RAID1 (+++)?
To: Pierre Couderc <pierre@couderc.eu>, linux-btrfs@vger.kernel.org
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
 <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
 <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
 <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
 <1bc34cb7-7523-11e1-b12f-05aff161b3c6@gmx.com>
 <c67143ae-e845-1b01-fdee-a7c32a208e52@couderc.eu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <27d116b2-ffbf-4b64-b63e-14a1e74d1490@gmx.com>
Date: Thu, 30 Aug 2018 18:09:02 +0800
MIME-Version: 1.0
In-Reply-To: <c67143ae-e845-1b01-fdee-a7c32a208e52@couderc.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kgdhFRUJfOmVQ0L1RapnDr1rpc5Rc9nHy"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kgdhFRUJfOmVQ0L1RapnDr1rpc5Rc9nHy
Content-Type: multipart/mixed; boundary="hbCX2PExy64prYKNph9kxr7Khc38mIy4I";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Pierre Couderc <pierre@couderc.eu>, linux-btrfs@vger.kernel.org
Message-ID: <27d116b2-ffbf-4b64-b63e-14a1e74d1490@gmx.com>
Subject: Re: How to erase a RAID1 (+++)?
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
 <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
 <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
 <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
 <1bc34cb7-7523-11e1-b12f-05aff161b3c6@gmx.com>
 <c67143ae-e845-1b01-fdee-a7c32a208e52@couderc.eu>
In-Reply-To: <c67143ae-e845-1b01-fdee-a7c32a208e52@couderc.eu>

--hbCX2PExy64prYKNph9kxr7Khc38mIy4I
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/30 =E4=B8=8B=E5=8D=886:01, Pierre Couderc wrote:
>=20
>=20
> On 08/30/2018 11:35 AM, Qu Wenruo wrote:
>>
>> On 2018/8/30 =E4=B8=8B=E5=8D=885:13, Pierre Couderc wrote:
>>> Trying to install a RAID1 on a debian stretch, I made some mistake an=
d
>>> got this, after installing on disk1 and trying to add second disk=C2=A0=
 :
>>>
>>>
>>> root@server:~# fdisk -l
>>> Disk /dev/sda: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
>>> Units: sectors of 1 * 512 =3D12 bytes
>>> Sector size (logical/physical): 512 bytes / 512 bytes
>>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>>> Disklabel type: dos
>>> Disk identifier: 0x2a799300
>>>
>>> Device=C2=A0=C2=A0=C2=A0=C2=A0 Boot Start=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 End=C2=A0=C2=A0=C2=A0 Sectors=C2=A0 Size Id Type
>>> /dev/sda1=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0 2048 3907028991 3907026944=C2=
=A0 1.8T 83 Linux
>>>
>>>
>>> Disk /dev/sdb: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
>>> Units: sectors of 1 * 512 =3D12 bytes
>>> Sector size (logical/physical): 512 bytes / 512 bytes
>>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>>> Disklabel type: dos
>>> Disk identifier: 0x9770f6fa
>>>
>>> Device=C2=A0=C2=A0=C2=A0=C2=A0 Boot Start=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 End=C2=A0=C2=A0=C2=A0 Sectors=C2=A0 Size Id Type
>>> /dev/sdb1=C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0 2048 3907029167 3907027120=C2=
=A0 1.8T=C2=A0 5 Extended
>>>
>>>
>>> And :
>>>
>>> root@server:~# btrfs fi show
>>> Label: none=C2=A0 uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 2 FS b=
ytes used 1.10GiB
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=
=A0 1 size 1.82TiB used 4.02GiB path /dev/sda1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=
=A0 2 size 1.00KiB used 0.00B path /dev/sdb1
>>>
>>> ...
>>>
>>> My purpose is a simple RAID1 main fs, with bootable flag on the 2 dis=
ks
>>> in prder to start in degraded mode....
>>> How to get out ofr that...?
>> The 2nd device is indeed strange.
>>
>> Considering how old packages Debian tends to deliver, it should be som=
e
>> old btrfs-progs.
>>
>> You could just boot into the system and execute the following commands=
:
>>
>> # btrfs device remove 2 <mnt>
> This works fine.
>>
>> Then add a new real device to the fs
>>
>> # btrfs device add <new device> <mnt>
>>
>>
> Thnk you, this :
>=20
> btrfs device add /dev/sdb1 /
>=20
> =C2=A0seems to work but=C2=A0 gives me the same :
>=20
> root@server:~# btrfs fi show
> Label: none=C2=A0 uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 2 FS bytes use=
d 1.10GiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 si=
ze 1.82TiB used 4.02GiB path /dev/sda1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 si=
ze 1.00KiB used 0.00B path /dev/sdb1
>=20
> So I need to "prepare" or format /dev/sdb before adding /dev/sdb1
> I have tried to format /dev/sdb and it works :

What's the output of lsblk command?

If it's 2T (1.8T) show in lsblk, then in above case you could fix it by
resize that device by:

# btrfs resize 2:max <mnt>

Thanks,
Qu


> root@server:~# btrfs fi show
> Label: none=C2=A0 uuid: eed65d24-6501-4991-94bd-6c3baf2af1ed
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 2 FS bytes use=
d 1.10GiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 si=
ze 1.82TiB used 4.02GiB path /dev/sda1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 si=
ze 1.82TiB used 0.00B path /dev/sdb
>=20
> but I have no partition table and no booot flag for degraded mode....
>=20
>=20
>=20


--hbCX2PExy64prYKNph9kxr7Khc38mIy4I--

--kgdhFRUJfOmVQ0L1RapnDr1rpc5Rc9nHy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluHwj4ACgkQwj2R86El
/qhwtAf+JsgyvxUeHy2GO0GdRGonc9FqHwytvJEQS10+pFRq8tyh/+85blzp06pQ
EJtBket6a0FgX72cZovWWjzCnb7FXU+z7vdc/e75WanH8XlSEYPlqlXKuK69/61a
9ggoURc11zxMzQ6iuGIs0LeXMnFRmehZxTZ3G8Sk6cjvJeJGyaFWS/MqmxQ9lMHS
L7Sch54+5SBWAQmrcoVLD47oNKtQ+s6TYDtNWJGapmSlhytoizSzV08eJK3sePE6
f9R99xOiXNM+da0wsya11Gvm6boGP9WtM54Q+qPeOE9vDHd1t2JD0aYZf641c74B
VNh/neELhBK0KqHCVxHz8yf5997IkA==
=m/IV
-----END PGP SIGNATURE-----

--kgdhFRUJfOmVQ0L1RapnDr1rpc5Rc9nHy--
