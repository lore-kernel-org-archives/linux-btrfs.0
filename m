Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63837 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932531AbeAXKOT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 05:14:19 -0500
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: Foo Bar <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com>
 <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com>
 <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com>
Date: Wed, 24 Jan 2018 18:14:11 +0800
MIME-Version: 1.0
In-Reply-To: <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hi5F8bZlhoPBuO8tQbHbkx39orIs3gl4O"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hi5F8bZlhoPBuO8tQbHbkx39orIs3gl4O
Content-Type: multipart/mixed; boundary="v4LBSIWPB8yUdFpTLhSrArhUOljbFFmpC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Foo Bar <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com>
 <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com>
 <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
In-Reply-To: <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>

--v4LBSIWPB8yUdFpTLhSrArhUOljbFFmpC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Here is the super dirty tricky fix (and less deadly now).

https://github.com/adam900710/btrfs-progs/tree/dirty_fix

Please compile the branch and run:

# ./btrfs-corrupt-block -X <device>

Where <device> must be unmounted, the original btrfs-corrupt-block tool
doesn't have mount check, and I'm too lazy to add such check.

The hack will remove the offending DIR_ITEM completely, and unlink the
old "Manifest" file, and repair the link for newer "Manifest" file.

And it shouldn't write anything to disk if any operation failed, so it's
less deadly.

Wish you good luck.

Thanks,
Qu

On 2018=E5=B9=B401=E6=9C=8824=E6=97=A5 17:18, Foo Bar wrote:
> Qu Wenruo wrote on 2018-01-24 09:49:
>> Sorry for the late reply, I was off yesterday.
>>
>=20
> No problem :-)
>=20
> Booted normally today, system up, but see this (I forgot to stop the sn=
apshot
> cron task...)
>=20
>   [  115.127961] BTRFS error (device sdb3): Send: inconsistent snapshot=
, found
> deleted reference for inode 30039323 without updated inode item, send r=
oot is
> 1399, parent root is 1385
>=20
> So inode 30039323 looks definitely the bad one. Let's get rid of it and=
 keep
> the newest dups, if any, thanks!
>=20
> Cheers,
>=20
>   Marco
>=20
>> On 2018=E5=B9=B401=E6=9C=8822=E6=97=A5 23:04, ^m'e wrote:
>>> Thanks for the quick reply, Qu!
>>>
>>> I forgot to say that I see weird characters in the btrfs check repair=

>>> in lines "ERROR: DIR_ITEM... name ..." output. Although that can be
>>> due to corruption, I seem to remember that a previous version of
>>> btrfs-progs I used didn't show that...
>>> I also see:
>>>
>>>    [19428.934684] init_special_inode: bogus i_mode (700) for inode
>>> sdb3:18446744073709551361
>>>
>>> BTW, no sensible names in the debug output, and as far as I can see,
>>> it might be all stuff in '[rootfs]/usr/portage': if that's the case,
>>> corrupted inodes can be safely removed, as the portage package tree
>>> can be easily rebuild. Here you are:
>>>
>>> ---------------------------------->8---------------------------------=
----
>>> # cat btrfs-debug.30039322.log[snip]
>>
>> This where the dir starts.
>>
>>>     item 78 key (30039322 INODE_ITEM 0) itemoff 4203 itemsize 160
>>>         generation 136248 transid 229515 size 152 nbytes 0
>>>         block group 0 mode 40755 links 1 uid 250 gid 250 rdev 0
>>>         sequence 0 flags 0xf(none)
>>>         atime 1504685599.188061317 (2017-09-06 08:13:19)
>>>         ctime 1516557882.551679697 (2018-01-21 18:04:42)
>>>         mtime 1516557882.551679697 (2018-01-21 18:04:42)
>>>         otime 1504685599.188061317 (2017-09-06 08:13:19)
>>>     item 79 key (30039322 INODE_REF 30037720) itemoff 4161 itemsize 4=
2
>>>         index 242 namelen 32 name: obs-service-download_src_package
>>>     item 80 key (30039322 DIR_ITEM 1076301169) itemoff 4083 itemsize =
78
>>>         location key (30039325 INODE_ITEM 0) type FILE
>>>         transid 136248 data_len 0 name_len 48
>>>         name: obs-service-download_src_package-20130318.ebuild
>>>     item 81 key (30039322 DIR_ITEM 2438219243) itemoff 4041 itemsize =
42
>>>         location key (0 UNKNOWN.0 0) type FILE
>>>         transid 136192 data_len 0 name_len 12
>>>         name: metadata.xml
>>>     item 82 key (30039322 DIR_ITEM 4007295565) itemoff 3927 itemsize =
114
>>>         location key (0 UNKNOWN.0 0) type DIR_ITEM.0
>>>         transid 0 data_len 0 name_len 0
>>>         name:
>>>         location key (0 UNKNOWN.125 72057594038112709) type DIR_ITEM.=
0
>>>         transid 0 data_len 32907 name_len 3
>>>         name:
>>>         data
>>
>> The whole item is corrupted.
>> Seems to be a half-written item get flushed to disk.
>>
>> I assume this is the DIR_ITEM for *two* Manifest, but that's just
>> insane, as we're going to have 2 files with the same name "Manifest"
>>
>>>     item 83 key (30039322 DIR_INDEX 2) itemoff 3889 itemsize 38
>>>         location key (30039323 INODE_ITEM 0) type FILE
>>>         transid 3377699720527872 data_len 0 name_len 8
>>
>> The transid seems corrupted too.
>>
>> Maybe I need to delete this item too?
>>
>>>     item 64 key (47302013 INODE_REF 30039322) itemoff 11278 itemsize =
18
>>>         index 5 namelen 8 name: Manifest
>>
>> Now we do have 2 "Manifest".
>>
>> Which one do you prefer to delete?
>>
>> The latter one, inode 47302013 seems newer, while previous one, inode
>> 30039323 is pretty old.
>>
>> Despite that, I didn't see big problem in the dump.
>>
>> I'll just craft the dirty fix to delete one inode and the incorrect di=
r
>> index/item.
>>
>> Thanks,
>> Qu
>>
>=20


--v4LBSIWPB8yUdFpTLhSrArhUOljbFFmpC--

--hi5F8bZlhoPBuO8tQbHbkx39orIs3gl4O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpoXHMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhnVgf9EXbAtucaAGwP2/Jbv5D6/fm+
wPKZp92GbWzL8TdVCm7M14WG5o+YwSTSEyg0mt1aqRRb0ouvNzj5JH0j0GnoRMKJ
o8Uisc7gXvlVGxBMpDf30dBDcGFASx82OlFrYHNTxzCZAX3yQcNz/LpysqcC3vVS
P1JgzRr7tTaqlAJFl7lRftuElpSAOqgyLtpgY4lISZKpjw0BwVuj/0bwhcEhv6sX
81a74o6UIbgfUFwN8D0VHpPOc6HKQDdR+Jca7YxiXnfZIEwVlOUl6+gdsS0u2a9+
aKTYu+5iWf3MJeTbrmqnv9kmom1nfD4VKezh650EWQIl3ZQezUoOxphTqdTxzw==
=uMBG
-----END PGP SIGNATURE-----

--hi5F8bZlhoPBuO8tQbHbkx39orIs3gl4O--
