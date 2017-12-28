Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61299 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753151AbdL1MLX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 07:11:23 -0500
Subject: Re: Hand Patching a BTRFS Superblock?
To: Nikolay Borisov <n.borisov.lkml@gmail.com>, swestrup@gmail.com,
        linux-btrfs@vger.kernel.org
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
 <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
Date: Thu, 28 Dec 2017 20:11:14 +0800
MIME-Version: 1.0
In-Reply-To: <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tJ7qA5if5ftt4ZxSsyXNC5fE1sjbuHtUm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tJ7qA5if5ftt4ZxSsyXNC5fE1sjbuHtUm
Content-Type: multipart/mixed; boundary="TiTru2FReekPp5ukWzhyqOQrHD2uIn6jc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>, swestrup@gmail.com,
 linux-btrfs@vger.kernel.org
Message-ID: <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
Subject: Re: Hand Patching a BTRFS Superblock?
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
 <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
In-Reply-To: <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>

--TiTru2FReekPp5ukWzhyqOQrHD2uIn6jc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8828=E6=97=A5 19:41, Nikolay Borisov wrote:
>=20
>=20
> On 28.12.2017 03:53, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8828=E6=97=A5 09:46, Stirling Westrup wrote:
>>> Here's my situation: I have a network file server containing a 12TB
>>> BTRFS spread out over four devices (sda-sdd) which I am trying to
>>> recover. I do have a backup, but it's about 3 months old, and while I=

>>> could certainly rebuild everything from that if I really had to, I
>>> would far rather not have to rerip my latest DVDs. So, I am willing t=
o
>>> experiment if it might save me a few hundred hours of reconstruction.=

>>> I don't currently have another 12 TB of space anywhere for making a
>>> scratch copy.
>>>
>>> A few days ago sdb developed hard errors and I can no longer mount th=
e
>>> filesystem. sdb is no longer even recognized as a valid btrfs drive.
>>> However, when I ran ddrescue over the drive I managed to make a clone=

>>> (sdf) which contains all but 12K of the original drive. However, thos=
e
>>> missing 12K are all in the various superblocks, so the cloned drive i=
s
>>> still unreadable.
>>>
>>> In the hopes that I was only missing a few bits of the superblocks, I=

>>> started out by dd-ing the first 4M of sdd into sdf in the hopes that
>>> ddrescue would overwrite much of the superblocks, and the final bits
>>> from sdd would make things usable.
>>>
>>> No such luck. I now have a drive sdf which claims to be identical to
>>> sdd but which is a clone of sdb. In case it matters, sda and sdc are
>>> each 4TB while sdb and sdd are each 2TB drives; sde is my boot drive
>>> and sdf is a 2TB clone of sdb.
>>>
>>> What I need to do is to somehow patch sdf's primary superblock so it
>>> contains the correct device number and UUID_SUB for sdb, so that I ca=
n
>>> attempt some sort of recovery. Right now my linux is (understandably)=

>>> quite confused by the situation:
>>
>> Did you tried "btrfs rescue super-recover"?
>>
>> Remember to use the devel branch from git, as there is a small bug
>> prevent it report correct result.
>=20
> Unforutnately my patchset which fixes super-recover is still not merged=
,
> so he needs to grab the patches from the mailing list and compile the
> btrfs tools himself. The patch in question can be found here:
>=20
> https://patchwork.kernel.org/patch/10092471/

And just in-case, "btrfs insp dump-super -fa" output could greatly help
us to check if the backup superblocks are really good.

Thanks,
Qu
>=20
>>
>> super-recover will try to use the backup superblock to recover the
>> primary one.
>>
>> Thanks,
>> Qu
>>
>>>
>>> videon:~ # uname -a
>>> Linux videon 4.4.103-18.41-default #1 SMP Wed Dec 13 14:06:33 UTC 201=
7
>>> (f66c68c) x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> videon:~ # btrfs --version
>>> btrfs-progs v4.5.3+20160729
>>>
>>> videon:~ # btrfs fi show
>>> Label: 'Storage'  uuid: 33d2890d-f07d-4ba8-b1fc-7b4f14463b1f
>>>         Total devices 4 FS bytes used 10.69TiB
>>>         devid    1 size 1.82TiB used 1.82TiB path /dev/sdd
>>>         devid    3 size 3.64TiB used 3.54TiB path /dev/sdc
>>>         devid    4 size 3.64TiB used 3.54TiB path /dev/sda
>>>         *** Some devices missing
>>>
>>> Any suggestions on how to proceed would be appreciated.
>>>
>>


--TiTru2FReekPp5ukWzhyqOQrHD2uIn6jc--

--tJ7qA5if5ftt4ZxSsyXNC5fE1sjbuHtUm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpE32IXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj+MAf/SrVLw6etPF73a7EinkgkH94a
b/UESB9bZsW1kSFvRufnplRaSPYr4pKf8mtxF5rV5HA/xC2ncNFdUaL6L/Ei6W3+
ZbiRqnvjY2VjzGcTg58A1WKlAvFx7seNFX+lJfaGpYmnFMUFSd7iiGsoRbTebll7
Zobi4LQiqs3bFjtAyuxOnZesVDfO1G8G45eR+4JIe83aXPzAqrDPu51B4pfPagv4
TFLSvZuhBs+qkM0jbkG2Mxx7Crju4FPcJxgZgX7tBFQOvnw5uyAQWETHoYP/Hbfv
kJYJhdvbAw0lcie8ioyLOoYVk2rzwx06ceMp7RgnNh9icZcXB/h51FR0CHohPA==
=tL4Z
-----END PGP SIGNATURE-----

--tJ7qA5if5ftt4ZxSsyXNC5fE1sjbuHtUm--
