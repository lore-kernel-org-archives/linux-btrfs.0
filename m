Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:33113 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751485AbeD2CHo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 22:07:44 -0400
Subject: Re: Problems with btrfs
To: "David C. Partridge" <david.partridge@perdrix.co.uk>,
        linux-btrfs@vger.kernel.org
References: <003801d3de56$fba1b930$f2e52b90$@perdrix.co.uk>
 <035a8b69-127a-0b7f-28e0-67c0a3e3f5c7@gmx.com>
 <003801d3def2$d90965c0$8b1c3140$@perdrix.co.uk>
 <a5c24cee-ad20-f317-28e8-40e88039db45@gmx.com>
 <004d01d3def6$4000ed40$c002c7c0$@perdrix.co.uk>
 <60674123-6fe2-2cfe-e7a8-25d62e023c53@gmx.com>
 <006201d3defa$2783dda0$768b98e0$@perdrix.co.uk>
 <0dba3a1c-434a-dc23-5d5d-75151121ffbf@gmx.com>
 <001701d3df0a$55d7cf30$01876d90$@perdrix.co.uk>
 <275af8f8-4997-5246-d2a4-99ab2bf299fb@gmx.com>
 <002f01d3df5d$25dd0270$71970750$@perdrix.co.uk>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c26c307a-75ce-d0f5-ca29-75854c34280c@gmx.com>
Date: Sun, 29 Apr 2018 10:07:37 +0800
MIME-Version: 1.0
In-Reply-To: <002f01d3df5d$25dd0270$71970750$@perdrix.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vXeNhwwxc65qpcf2fAV4TVOm7X1HsZzx8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vXeNhwwxc65qpcf2fAV4TVOm7X1HsZzx8
Content-Type: multipart/mixed; boundary="6K782vMObIbcdLQkA3ypbbuW9cAlMOKo1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "David C. Partridge" <david.partridge@perdrix.co.uk>,
 linux-btrfs@vger.kernel.org
Message-ID: <c26c307a-75ce-d0f5-ca29-75854c34280c@gmx.com>
Subject: Re: Problems with btrfs
References: <003801d3de56$fba1b930$f2e52b90$@perdrix.co.uk>
 <035a8b69-127a-0b7f-28e0-67c0a3e3f5c7@gmx.com>
 <003801d3def2$d90965c0$8b1c3140$@perdrix.co.uk>
 <a5c24cee-ad20-f317-28e8-40e88039db45@gmx.com>
 <004d01d3def6$4000ed40$c002c7c0$@perdrix.co.uk>
 <60674123-6fe2-2cfe-e7a8-25d62e023c53@gmx.com>
 <006201d3defa$2783dda0$768b98e0$@perdrix.co.uk>
 <0dba3a1c-434a-dc23-5d5d-75151121ffbf@gmx.com>
 <001701d3df0a$55d7cf30$01876d90$@perdrix.co.uk>
 <275af8f8-4997-5246-d2a4-99ab2bf299fb@gmx.com>
 <002f01d3df5d$25dd0270$71970750$@perdrix.co.uk>
In-Reply-To: <002f01d3df5d$25dd0270$71970750$@perdrix.co.uk>

--6K782vMObIbcdLQkA3ypbbuW9cAlMOKo1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 09:55, David C. Partridge wrote:
> Not a problem
>=20
> See attached

The final binary dump:

# dd if=3D<device> of=3D/tmp/copy1.img bs=3D1 count=3D16K skip=3D25942081=
536
# dd if=3D<device> of=3D/tmp/copy2.img bs=3D1 count=3D16K skip=3D26478952=
448

Thanks,
Qu

>=20
>=20
> -----Original Message-----
> From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]=20
> Sent: 29 April 2018 02:35
> To: David C. Partridge; linux-btrfs@vger.kernel.org
> Subject: Re: Problems with btrfs
>=20
>=20
>=20
> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 00:02, David C. Partridge wrote:=

>> Here are the dumps you requested.
>=20
> Sorry, I took wrong dump.
>=20
> The correct dump would be:
> # btrfs inspect dump-tree -t extent <dev>
>=20
> And you still need to do an extra dump for the final offending tree blo=
ck.
>=20
> Considering the extra steps and delays, feel free to use btrfs-restore =
to recovery your data.
>=20
> Thanks,
> Qu
>=20
>>
>> -----Original Message-----
>> From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]
>> Sent: 28 April 2018 15:23
>> To: David C. Partridge; linux-btrfs@vger.kernel.org
>> Subject: Re: Problems with btrfs
>>
>>
>>
>> On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 22:06, David C. Partridge wrote=
:
>>> Here's the log you asked for ...
>>>
>>> David
>>
>> To dump the offending tree block, you could use the following command:=

>>
>> # dd if=3D/dev/mapper/Charon--vg-root of=3Dcopy1.dump bs=3D1 count=3D1=
6k
>> skip=3D22919544832
>>
>> # dd if=3D/dev/mapper/Charon--vg-root of=3Dcopy2.dump bs=3D1 count=3D1=
6k
>> skip=3D23456415744
>>
>> And attach copy1.img and copy2.img.
>>
>> Thanks,
>> Qu
>>
>>>
>>> -----Original Message-----
>>> From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]
>>> Sent: 28 April 2018 14:54
>>> To: David C. Partridge
>>> Subject: Re: Problems with btrfs
>>>
>>>
>>>
>>> On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 21:38, David C. Partridge wrot=
e:
>>>> Oh! doing a private build from source a bit beyond my skill level :(=
  Are there alternatives like climbing in with a disk editor or is there =
too much to change?
>>>
>>> It's possible to only modify that offending tree block.
>>> But I can't ensure the safety, thus I recommend to use btrfs-corrupt-=
block.
>>> Since it's not convenient for you, then let's go that way.
>>>
>>> Please provide the following dump:
>>>
>>> # btrfs inspect dump-tree -t chunk <device>
>>>
>>> Then I could calculate the offset on-disk for you to do a binary dump=
 and send that tree block back to me to hand patch it.
>>>
>>>>
>>>> I'm prepared to install a newer version of btrfs-progs if that will =
fix the problem (assuming I can find a suitable package file).
>>>>
>>>> I'm assuming that I'll likely also need to update the kernel?
>>>
>>> Not exactly.
>>> If latest btrfs check gives no error after fix, even old kernel shoul=
d handle it well without problem.
>>>
>>> But as a generic advice, it's recommended to use latest kernel for bt=
rfs if possible.
>>>
>>> And currently there is nothing sensitive in the thread (btrfs-inspect=
=2Elog could contain some filenames, but nothing sensitive right now), so=
 it's better to CC the mail to mail list, just in case some other guy cou=
ld provide extra help.
>>>
>>> (Next mail may be after 8~10 hours, as it's bed time for my timezone)=

>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> David
>>>>
>>>> -----Original Message-----
>>>> From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]
>>>> Sent: 28 April 2018 14:25
>>>> To: David C. Partridge
>>>> Subject: Re: Problems with btrfs
>>>>
>>>>
>>>>
>>>> On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 21:14, David C. Partridge wro=
te:
>>>>> Here's the output from
>>>>>
>>>>> # btrfs inspect dump-tree /dev/mapper/Charon--vg-root | grep -C 20
>>>>> 224304857088
>>>>
>>>> Located the problem:
>>>>
>>>> 	item 382 key (224304857088 EXTENT_ITEM 16384) itemoff 14495 itemsiz=
e 51
>>>> 		extent refs 1 gen 735989 flags TREE_BLOCK
>>>> 		tree block key (4401028 UNKNOWN.0 0) level 0
>>>>                                 ^^^^^^^^^^^^^^^^^^^
>>>> 		shared block backref parent 140827475968
>>>>
>>>> It could be fixed by special crafted btrfs-corrupt-block tool to han=
dle it.
>>>> Although this means you need to compile btrfs-progs by yourself with=
 special branch.
>>>>
>>>> Before patching btrfs-progs, I'd like to double check if other part =
is correct.
>>>>
>>>> Please execute the following command:
>>>> # btrfs inspect dump-tree -b 140827475968=20
>>>> /dev/mapper/Charon--vg-root
>>>>
>>>> If the output is correct, I could start patching btrfs-corrupt-block=
 then.
>>>> But please be aware of that, this could only fix the problem found i=
n extent tree, I'm not 100% sure if there will be other problems, as the =
btrfs-progs is pretty old.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> HtH
>>>>> David
>>>>>
>>>>
>>>
>>
>=20


--6K782vMObIbcdLQkA3ypbbuW9cAlMOKo1--

--vXeNhwwxc65qpcf2fAV4TVOm7X1HsZzx8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrlKOkACgkQwj2R86El
/qi8wQf+NuH6DkM2xMkGXgQaar/1FdVOw17Jjjfqg6lrFaexJuoSUnDXGCR3urmV
1KXqm1Gfo3IIL0WU2C7zi8k4jxdoZmWWIBglsmq5hUKIacnKhIEJooN+GtfNUmZW
5JK8Dm2PXJ3GPyzBJ4LrlQpUpzL4Kd5itufqGTa9beAMZbAabZQkvmPVawuj4U8d
XwcCQ6scP8JPI5YSlAc6Ug21X7RnzMG/PA5yEn9kgMNq+ittLl4dlb1kL9wqZ/xn
MZbuqIyeKta7Lx6mDARQTWNhRfONaXbeHsqjahScySfAzxCrEQmQtpkFdiDAh7tP
mLCOBf0YAPDO+ImKQu6X3Uyt07VI2A==
=NWMn
-----END PGP SIGNATURE-----

--vXeNhwwxc65qpcf2fAV4TVOm7X1HsZzx8--
