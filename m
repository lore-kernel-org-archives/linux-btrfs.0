Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49343 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750737AbeCNJRI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 05:17:08 -0400
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d77ddf8b-3221-97b9-2193-8e4783231a1a@gmx.com>
Date: Wed, 14 Mar 2018 17:16:46 +0800
MIME-Version: 1.0
In-Reply-To: <ghlgevjavx.fsf@lena.gouders.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PM32QAbZ9EFDzhNF9kATHrsrMcRDe2k4D"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PM32QAbZ9EFDzhNF9kATHrsrMcRDe2k4D
Content-Type: multipart/mixed; boundary="9MAV4oU4NQnMIjCq820MZctyljmWTMJ4o";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dirk Gouders <dirk@gouders.net>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Message-ID: <d77ddf8b-3221-97b9-2193-8e4783231a1a@gmx.com>
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
In-Reply-To: <ghlgevjavx.fsf@lena.gouders.net>

--9MAV4oU4NQnMIjCq820MZctyljmWTMJ4o
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8814=E6=97=A5 16:53, Dirk Gouders wrote:
> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>=20
>> On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 22:49, Dirk Gouders wrote:
>> [snip]
>>>>
>>>> # btrfs inspect dump-tree -b 848986112 /dev/loop0p1
>>>> # btrfs inspect dump-tree -b 72089600 /dev/loop0p1
>>>
>>> OK.
>>>
>>> (This mail gets a bit long but I don't want to snip probably importan=
t
>>>  information above.)
>>>
>>
>> Feel free to snip.
>> As the involved tree block is not shown anywhere.
>>
>> So it's not any root node corrupted.
>> It may be some extent tree node corrupted in this case.
>>
>> While to inspect it, we need some new functionality in btrfs inspect t=
ree.
>>
>> Before that, would you please try the following patch and to see if it=

>> helps btrfs-restore to salvage any data?
>=20
> I tried it and got the following output:
>=20
> # btrfs restore /dev/loop0p1 /mnt/
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found DC09290B wanted C630FD61
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> bytenr mismatch, want=3D363069440, have=3D17552567724568668829
> Could not open root, trying backup super
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found DC09290B wanted C630FD61
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> bytenr mismatch, want=3D363069440, have=3D17552567724568668829
> Could not open root, trying backup super
> ERROR: superblock bytenr 274877906944 is larger than device size 107416=
12544
> Could not open root, trying backup super

So it's still something important in the tree.

Would you please apply this patch?
https://patchwork.kernel.org/patch/10281329/

And then dump the tree again using that newly added -f option?
(Both stdout and stderr is needed)

The dump command would be:
# btrfs inspect dump-tree -f -b <bytenr>

Needed bytenrs would be:
848773120	tree root
848789504	extent root (My primary guess)
30408704	dev root
850509824	fs root (this could contain *FILENAME*, please censor
                         them if needed, and it may be large)
212353024	uuid tree (not really imporatant)

And if it's extent root, we could enhance btrfs-progs open_ctree() to
handle it for RO mode (needed by btrfs-restore)

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--9MAV4oU4NQnMIjCq820MZctyljmWTMJ4o--

--PM32QAbZ9EFDzhNF9kATHrsrMcRDe2k4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqo6H4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjDSAf+J7XbejELMHQac+P+LkcYGRT0
gQCWPYCRg+a98T3T4G7fRuY+Ub36WRSaWgTiRLX10sVxQazPbcAvzNOmGQ+uUWfp
W27/t15LiARfFtXMPpcsspWFlQw+YXrX77PDcofvhH9+BEaML7bYa/HMtu3wDTiL
dZsF/+LgP/I4ScyZ34ud7tIxx/TZrmgEhAT2JAWPiVTJUwoTW1Igd3a/O+QQ7Faw
WinjfoXFnthzK8PBaxwVyiP0fKTKgIJbJuSq+GGV534N4HWKiXoAmgkO9LgX+Bjw
JDx7Wl4OIMv2G08GkNETnH6u6T1w7fncLT7+kUP8v44lNtXC8WnwApKpCVU1GQ==
=krji
-----END PGP SIGNATURE-----

--PM32QAbZ9EFDzhNF9kATHrsrMcRDe2k4D--
