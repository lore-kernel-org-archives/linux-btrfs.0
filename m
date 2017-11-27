Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54551 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751838AbdK0NR1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 08:17:27 -0500
Subject: Re: How about adding an ioctl to convert a directory to a subvolume?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171127094156.GC29491@fnst.localdomain>
 <493abbdd-e412-b91e-f14e-8e40da404cf8@gmx.com>
 <2de2ce9f-5b6e-664c-a7ce-c319767e7cec@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3b52d261-7802-8f01-b853-2d55d52fe2bd@gmx.com>
Date: Mon, 27 Nov 2017 21:17:17 +0800
MIME-Version: 1.0
In-Reply-To: <2de2ce9f-5b6e-664c-a7ce-c319767e7cec@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jOHPJoiESjp2A9ggsUfBrCpk4eTB6AEjP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jOHPJoiESjp2A9ggsUfBrCpk4eTB6AEjP
Content-Type: multipart/mixed; boundary="wADcRQakJGSquMNlNSHB6if3sJWSgcuDm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <3b52d261-7802-8f01-b853-2d55d52fe2bd@gmx.com>
Subject: Re: How about adding an ioctl to convert a directory to a subvolume?
References: <20171127094156.GC29491@fnst.localdomain>
 <493abbdd-e412-b91e-f14e-8e40da404cf8@gmx.com>
 <2de2ce9f-5b6e-664c-a7ce-c319767e7cec@gmail.com>
In-Reply-To: <2de2ce9f-5b6e-664c-a7ce-c319767e7cec@gmail.com>

--wADcRQakJGSquMNlNSHB6if3sJWSgcuDm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8827=E6=97=A5 21:02, Austin S. Hemmelgarn wrote:=

> On 2017-11-27 05:13, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8827=E6=97=A5 17:41, Lu Fengqi wrote:
>>> Hi all,
>>>
>>> As we all know, under certain circumstances, it is more appropriate t=
o
>>> create some subvolumes rather than keep everything in the same
>>> subvolume. As the condition of demand change, the user may need to
>>> convert a previous directory to a subvolume. For this reason=EF=BC=8C=
how about
>>> adding an ioctl to convert a directory to a subvolume?
>>
>> The idea seems interesting.
>>
>> However in my opinion, this can be done quite easily in (mostly) user
>> space, thanks to btrfs support of relink.
>>
>> The method from Hugo or Chris is quite good, maybe it can be enhanced =
a
>> little.
>>
>> Use the following layout as an example:
>>
>> root_subv
>> |- subvolume_1
>> |=C2=A0 |- dir_1
>> |=C2=A0 |=C2=A0 |- file_1
>> |=C2=A0 |=C2=A0 |- file_2
>> |=C2=A0 |- dir_2
>> |=C2=A0=C2=A0=C2=A0=C2=A0 |- file_3
>> |- subvolume_2
>>
>> If we want to convert dir_1 into subvolume, we can do it like:
>>
>> 1) Create a temporary readonly snapshot of parent subvolume containing=

>> =C2=A0=C2=A0=C2=A0 the desired dir
>> =C2=A0=C2=A0=C2=A0 # btrfs sub snapshot -r root_subv/subvolume_1 \
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 root_subv/tmp_snapshot_1
>>
>> 2) Create a new subvolume, as destination.
>> =C2=A0=C2=A0=C2=A0 # btrfs sub create root_subv/tmp_dest/
>>
>> 3) Copy the content and sync the fs
>> =C2=A0=C2=A0=C2=A0 Use of reflink is necessary.
>> =C2=A0=C2=A0=C2=A0 # cp -r --reflink=3Dalways root_subv/tmp_snapshot_1=
/dir_1 \
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 root_subv/tmp_dest
>> =C2=A0=C2=A0=C2=A0 # btrfs sync root_subv/tmp_dest
>>
>> 4) Delete temporary readonly snapshot
>> =C2=A0=C2=A0=C2=A0 # btrfs subvolume delete root_subv/tmp_snapshot_1
>>
>> 5) Remove the source dir
>> =C2=A0=C2=A0=C2=A0 # rm -rf root_subv/subvolume_1/dir_1
>>
>> 5) Create a final destination snapshot of "root_subv/temporary_dest"
>> =C2=A0=C2=A0=C2=A0 # btrfs subvolume snapshot root_subv/tmp_dest \
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 root_subv/subvolume_1/dir_1
>>
>> 6) Remove the temporary destination
>> =C2=A0=C2=A0=C2=A0 # btrfs subvolume delete root_subv/tmp_dest
>>
>>
>> The main challenge is in step 3).
>> In fact above method can only handle normal dir/files.
>> If there is another subvolume inside the desired dir, current "cp -r" =
is
>> a bad idea.
>> We need to skip subvolume dir, and create snapshot for it.
>>
>> But it's quite easy to write a user space program to handle it.
>> Maybe using "find" command can already handle it well.
>>
>> Anyway, doing it in user space is already possible and much easier tha=
n
>> doing it in kernel.
>>
>>>
>>> Users can convert by the scripts mentioned in this
>>> thread(https://www.spinics.net/lists/linux-btrfs/msg33252.html), but =
is
>>> it easier to use the off-the-shelf btrfs subcommand?
>>
>> If you just want to integrate the functionality into btrfs-progs, mayb=
e
>> it's possible.
>>
>> But if you insist in providing a new ioctl for this, I highly doubt if=

>> the extra hassle is worthy.
>>
>>>
>>> After an initial consideration, our implementation is broadly divided=

>>> into the following steps:
>>> 1. Freeze the filesystem or set the subvolume above the source direct=
ory
>>> to read-only;
>>
>> Not really need to freeze the whole fs.
>> Just create a readonly snapshot of the parent subvolume which contains=

>> the dir.
>> That's how snapshot is designed for.
>>
>>> 2. Perform a pre-check, for example, check if a cross-device link
>>> creation during the conversion;
>>
>> This can be done in-the-fly.
>> As the check is so easy (only needs to check if the inode number is 25=
6).
>> We only need a mid-order iteration of the source dir (in temporary
>> snapshot), and for normal file, use reflink.
>> For subvolume dir, create a snapshot for it.
>>
>> And for such iteration, a python script less than 100 lines would be
>> sufficient.
> On that note, see the function convert_dir_to_subv() in:
> https://github.com/Ferroin/btrfs-subv-backup/blob/master/btrfs-subv-bac=
kup.py
>=20
>=20
> For an example of how to do it in Python (albeit with some extra code t=
o
> handle the case of not having the reflink module from PyPI, and without=

> anything to prevent the source from being modified).
>=20
> It would still be nice to be able to do this atomically though, or at
> least get cross-rename support in BTRFS, which would allow the final
> rename to replace the source with a subvolume to be atomic (assuming of=

> course you could cross-rename a directory and subvolume).

The problem behind cross-rename is, btrfs doesn't follow the
one-inode-one-tree organization used by most filesystems.

This prevents inode from being referred outside of its subvolume.


And since btrfs uses one-subvolume-one-tree solution, which greatly
simplify the snapshot implementation, it's pretty hard or almost
impossible to do real rename-across-subvolume.

But at least we can reflink, reducing huge amount of data IO, making us
only need to handle inode creation/link.

(Although such one-subvolume-one-tree also makes metadata concurrency
very low, further slowing down the metadata operation)

Thanks,
Qu

>>
>> Thanks,
>> Qu
>>
>>> 3. Perform conversion, such as creating a new subvolume and moving th=
e
>>> contents of the source directory;
>>> 4. Thaw the filesystem or restore the subvolume writable property.
>>>
>>> In fact, I am not so sure whether this use of freeze is appropriate
>>> because the source directory the user needs to convert may be located=

>>> at / or /home and this pre-check and conversion process may take a lo=
ng
>>> time, which can lead to some shell and graphical application suspende=
d.
>>>
>>> Please give your comments if any.
>>>
>>
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--wADcRQakJGSquMNlNSHB6if3sJWSgcuDm--

--jOHPJoiESjp2A9ggsUfBrCpk4eTB6AEjP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlocEF0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgkfgf+Ii7M2H3Tpnb90l4KaBc2x3qG
2fQiuo/Dt69F2d7rNL8Qcr602kgfy0eajBcumqOMnOWODRTeno9QaImXsu8WGmJz
NDw1K/e+j+eUvUnDlqxlgROvwXVN+0aJPHy/3Vi7/I3zoiSuIE2BF9/xH1o1VCZQ
HcjdH6O+FwhUuX7hjz7ssQ0gkAI66yvj3Qp8PxIqFNRWc3Qztl+dTARWWbVu392Q
ts3GunsBfhityLxMXyHUmeMBkF/m0AcNAJKe0q/4aNiHDUnodbxlTqOmScqZkLJk
YuWKA0nm4fM+JQWpnUPGG2CebD00yKxvnZcnexDbLDe/WoNz5nT39hab+F9fTw==
=5OgH
-----END PGP SIGNATURE-----

--jOHPJoiESjp2A9ggsUfBrCpk4eTB6AEjP--
