Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:42209 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750818AbeCNKOe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 06:14:34 -0400
Subject: Re: FS unmountable after RAID/LVM problems
To: Dirk Gouders <dirk@gouders.net>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
References: <ghlgew5pbq.fsf@lena.gouders.net>
 <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
 <ghwoygxh77.fsf@lena.gouders.net>
 <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com>
 <ghsh94xfx9.fsf@lena.gouders.net>
 <9dd85c04-2371-04df-8bd7-f07f8a92a044@gmx.com>
 <gho9jsxdii.fsf@lena.gouders.net>
 <a9f30fd5-d044-2daa-0a52-085b02f258b1@gmx.com>
 <ghk1ugxc6m.fsf@lena.gouders.net>
 <e134bae6-d316-fcda-d0c5-0b0ae7d56edb@gmx.com>
 <ghlgevjavx.fsf@lena.gouders.net>
 <d77ddf8b-3221-97b9-2193-8e4783231a1a@gmx.com>
 <ghefknj8x3.fsf@lena.gouders.net>
 <749caef1-7f2e-482f-0b16-b6861c475e2b@gmx.com>
 <gha7vbj7iv.fsf@lena.gouders.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <de71954e-9738-ffec-3c0b-ee15c5b83d7b@gmx.com>
Date: Wed, 14 Mar 2018 18:14:12 +0800
MIME-Version: 1.0
In-Reply-To: <gha7vbj7iv.fsf@lena.gouders.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JAkjDLhlF8A8PWwHVwsEdVZSupS7eJn45"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JAkjDLhlF8A8PWwHVwsEdVZSupS7eJn45
Content-Type: multipart/mixed; boundary="wqb4czxOU41Fzh3KO0cpTb1j3v6ZniQX7";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dirk Gouders <dirk@gouders.net>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Message-ID: <de71954e-9738-ffec-3c0b-ee15c5b83d7b@gmx.com>
Subject: Re: FS unmountable after RAID/LVM problems
References: <ghlgew5pbq.fsf@lena.gouders.net>
 <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
 <ghwoygxh77.fsf@lena.gouders.net>
 <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com>
 <ghsh94xfx9.fsf@lena.gouders.net>
 <9dd85c04-2371-04df-8bd7-f07f8a92a044@gmx.com>
 <gho9jsxdii.fsf@lena.gouders.net>
 <a9f30fd5-d044-2daa-0a52-085b02f258b1@gmx.com>
 <ghk1ugxc6m.fsf@lena.gouders.net>
 <e134bae6-d316-fcda-d0c5-0b0ae7d56edb@gmx.com>
 <ghlgevjavx.fsf@lena.gouders.net>
 <d77ddf8b-3221-97b9-2193-8e4783231a1a@gmx.com>
 <ghefknj8x3.fsf@lena.gouders.net>
 <749caef1-7f2e-482f-0b16-b6861c475e2b@gmx.com>
 <gha7vbj7iv.fsf@lena.gouders.net>
In-Reply-To: <gha7vbj7iv.fsf@lena.gouders.net>

--wqb4czxOU41Fzh3KO0cpTb1j3v6ZniQX7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8814=E6=97=A5 18:06, Dirk Gouders wrote:
> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>=20
>> On 2018=E5=B9=B403=E6=9C=8814=E6=97=A5 17:36, Dirk Gouders wrote:
>>> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>>>
>>>> On 2018=E5=B9=B403=E6=9C=8814=E6=97=A5 16:53, Dirk Gouders wrote:
>>>>> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>>>>>
>>>>>> On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 22:49, Dirk Gouders wrote:
>>>>>> [snip]
>>>>>>>>
>>>>>>>> # btrfs inspect dump-tree -b 848986112 /dev/loop0p1
>>>>>>>> # btrfs inspect dump-tree -b 72089600 /dev/loop0p1
>>>>>>>
>>>>>>> OK.
>>>>>>>
>>>>>>> (This mail gets a bit long but I don't want to snip probably impo=
rtant
>>>>>>>  information above.)
>>>>>>>
>>>>>>
>>>>>> Feel free to snip.
>>>>>> As the involved tree block is not shown anywhere.
>>>>>>
>>>>>> So it's not any root node corrupted.
>>>>>> It may be some extent tree node corrupted in this case.
>>>>>>
>>>>>> While to inspect it, we need some new functionality in btrfs inspe=
ct tree.
>>>>>>
>>>>>> Before that, would you please try the following patch and to see i=
f it
>>>>>> helps btrfs-restore to salvage any data?
>>>>>
>>>>> I tried it and got the following output:
>>>>>
>>>>> # btrfs restore /dev/loop0p1 /mnt/
>>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>>> checksum verify failed on 363069440 found DC09290B wanted C630FD61
>>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>>> bytenr mismatch, want=3D363069440, have=3D17552567724568668829
>>>>> Could not open root, trying backup super
>>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>>> checksum verify failed on 363069440 found DC09290B wanted C630FD61
>>>>> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
>>>>> bytenr mismatch, want=3D363069440, have=3D17552567724568668829
>>>>> Could not open root, trying backup super
>>>>> ERROR: superblock bytenr 274877906944 is larger than device size 10=
741612544
>>>>> Could not open root, trying backup super
>>>>
>>>> So it's still something important in the tree.
>>>>
>>>> Would you please apply this patch?
>>>> https://patchwork.kernel.org/patch/10281329/
>>>>
>>>> And then dump the tree again using that newly added -f option?
>>>> (Both stdout and stderr is needed)
>>>>
>>>> The dump command would be:
>>>> # btrfs inspect dump-tree -f -b <bytenr>
>>>>
>>>> Needed bytenrs would be:
>>>> 848773120	tree root
>>>> 848789504	extent root (My primary guess)
>>>
>>> I am currently preparing the diagnosis data but after the above byten=
r
>>> the log grew to already 28MB.  Should I send all that data to the lis=
t?
>>
>> Nope, stderr is enough.
>=20
> OK, I will attach the output to the end.  The output is separated by th=
e
> command lines, so searching for "inspect" helps for navigation.
>=20
> For extend root and fs root I provide only stderr, because they grew
> stdout by 28 resp. 150 MB.

Thanks for all your effort!

It's clear the problem is the extent tree.

I'll try to enhance open_ctree() to allow btrfs-restore to continue even
if extent tree is corrupted asap.

Thanks,
Qu

>=20
> Thanks,
>=20
> Dirk
>=20
>>
>>>
>>> Thanks,
>>>
>>> Dirk
>>>
>>>> 30408704	dev root
>>>> 850509824	fs root (this could contain *FILENAME*, please censor
>>>>                          them if needed, and it may be large)
>>>> 212353024	uuid tree (not really imporatant)
>>>>
>>>> And if it's extent root, we could enhance btrfs-progs open_ctree() t=
o
>>>> handle it for RO mode (needed by btrfs-restore)
>>>>
>>>> Thanks,
>>>> Qu
>=20


--wqb4czxOU41Fzh3KO0cpTb1j3v6ZniQX7--

--JAkjDLhlF8A8PWwHVwsEdVZSupS7eJn45
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqo9fQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhHiwf9HuN9KKhgY/KXBT4xAKkuuVw5
Rm1GspnVtyF3BYF7Ymaajfony/G3LkQmSmf6kxUMR7pUkQ5nnR8RQrt35hqYLcwt
cTPKxDXFmfhXBVjW4jO3A2ig1XMlDjo8beNbv/i9L/xTMfiNhFVTaVXUqcdUUmEa
IgNDPRIHmEjlXYZaZ5zqyCqcXKmBSy1QJGPVAXkRNgTUz6LwZUjSZ3HdhzJpCeJ+
PwtD/8ABJUjJ6BDybsWDgnv50Ix1bUH/daOTD+YHwS7t6WzGFWAbo4dUVq6cFiy7
D3bhsX7L1YyUYChxeac5FNsS5fsPOLav0OOik9Vqo5sAZn9hPVw5RSV296E/ZA==
=wFz7
-----END PGP SIGNATURE-----

--JAkjDLhlF8A8PWwHVwsEdVZSupS7eJn45--
