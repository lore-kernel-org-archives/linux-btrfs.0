Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:39433 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751191AbeE1FLc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 01:11:32 -0400
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
 <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
 <e0854da8-0d3e-946a-5709-7a329175bad3@shaw.ca>
 <de65fc60-fc23-f7d5-1f58-52687d4859e8@gmx.com>
 <b9ac2d21-93aa-e69a-5994-a1839114cfbb@shaw.ca>
 <53d68efd-21fa-3e18-c35e-89a043605471@gmx.com>
 <f50de27a-bb18-ce30-8694-d5f76684846e@shaw.ca>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ac13c732-29a3-89c7-0fe2-f3222e7cb6ee@gmx.com>
Date: Mon, 28 May 2018 13:11:20 +0800
MIME-Version: 1.0
In-Reply-To: <f50de27a-bb18-ce30-8694-d5f76684846e@shaw.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7x2d0AgoeNHhlZJGb6YXVA982pZhONnLx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7x2d0AgoeNHhlZJGb6YXVA982pZhONnLx
Content-Type: multipart/mixed; boundary="robbBXp3c3QOBxudTNO859uKJA5b6b9IF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
Message-ID: <ac13c732-29a3-89c7-0fe2-f3222e7cb6ee@gmx.com>
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
 <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
 <e0854da8-0d3e-946a-5709-7a329175bad3@shaw.ca>
 <de65fc60-fc23-f7d5-1f58-52687d4859e8@gmx.com>
 <b9ac2d21-93aa-e69a-5994-a1839114cfbb@shaw.ca>
 <53d68efd-21fa-3e18-c35e-89a043605471@gmx.com>
 <f50de27a-bb18-ce30-8694-d5f76684846e@shaw.ca>
In-Reply-To: <f50de27a-bb18-ce30-8694-d5f76684846e@shaw.ca>

--robbBXp3c3QOBxudTNO859uKJA5b6b9IF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8828=E6=97=A5 11:47, Steve Leung wrote:
> On 05/26/2018 06:57 PM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B405=E6=9C=8826=E6=97=A5 22:06, Steve Leung wrote:
>>> On 05/20/2018 07:07 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2018=E5=B9=B405=E6=9C=8821=E6=97=A5 04:43, Steve Leung wrote:
>>>>> On 05/19/2018 07:02 PM, Qu Wenruo wrote:
>>>>>>
>>>>>>
>>>>>> On 2018=E5=B9=B405=E6=9C=8820=E6=97=A5 07:40, Steve Leung wrote:
>>>>>>> On 05/17/2018 11:49 PM, Qu Wenruo wrote:
>>>>>>>> On 2018=E5=B9=B405=E6=9C=8818=E6=97=A5 13:23, Steve Leung wrote:=

>>>>>>>>> Hi list,
>>>>>>>>>
>>>>>>>>> I've got 3-device raid1 btrfs filesystem that's throwing up som=
e
>>>>>>>>> "corrupt leaf" errors in dmesg.=C2=A0 This is a uniquified list=
 I've
>>>>>>>>> observed lately:
>>>>>
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS critical (device sda1): co=
rrupt leaf: root=3D1
>>>>>>>>> block=3D4970196795392
>>>>>>>>> slot=3D307 ino=3D206231 file_offset=3D0, invalid ram_bytes for
>>>>>>>>> uncompressed
>>>>>>>>> inline extent, have 3468 expect 3469
>>>>>>>>
>>>>>>>> Would you please use "btrfs-debug-tree -b 4970196795392
>>>>>>>> /dev/sda1" to
>>>>>>>> dump the leaf?
>>>>>>>
>>>>>>> Attached btrfs-debug-tree dumps for all of the blocks that I saw
>>>>>>> messages for.
>>>>>>>
>>>>>>>> It's caught by tree-checker code which is ensuring all tree bloc=
ks
>>>>>>>> are
>>>>>>>> correct before btrfs can take use of them.
>>>>>>>>
>>>>>>>> That inline extent size check is tested, so I'm wondering if thi=
s
>>>>>>>> indicates any real corruption.
>>>>>>>> That btrfs-debug-tree output will definitely help.
>>>>>>>>
>>>>>>>> BTW, if I didn't miss anything, there should not be any inlined
>>>>>>>> extent
>>>>>>>> in root tree.
>>>>>>>>
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS critical (device sda1): co=
rrupt leaf: root=3D1
>>>>>>>>> block=3D4970552426496
>>>>>>>>> slot=3D91 ino=3D209736 file_offset=3D0, invalid ram_bytes for
>>>>>>>>> uncompressed
>>>>>>>>> inline extent, have 3496 expect 3497
>>>>>>>>
>>>>>>>> Same dump will definitely help.
>>>>>>>>
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS critical (device sda1): co=
rrupt leaf: root=3D1
>>>>>>>>> block=3D4970712399872
>>>>>>>>> slot=3D221 ino=3D205230 file_offset=3D0, invalid ram_bytes for
>>>>>>>>> uncompressed
>>>>>>>>> inline extent, have 1790 expect 1791
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS critical (device sda1): co=
rrupt leaf: root=3D1
>>>>>>>>> block=3D4970803920896
>>>>>>>>> slot=3D368 ino=3D205732 file_offset=3D0, invalid ram_bytes for
>>>>>>>>> uncompressed
>>>>>>>>> inline extent, have 2475 expect 2476
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS critical (device sda1): co=
rrupt leaf: root=3D1
>>>>>>>>> block=3D4970987945984
>>>>>>>>> slot=3D236 ino=3D208896 file_offset=3D0, invalid ram_bytes for
>>>>>>>>> uncompressed
>>>>>>>>> inline extent, have 490 expect 491
>>>>>>>>>
>>>>>>>>> All of them seem to be 1 short of the expected value.
>>>>>>>>>
>>>>>>>>> Some files do seem to be inaccessible on the filesystem, and bt=
rfs
>>>>>>>>> inspect-internal on any of those inode numbers fails with:
>>>>>>>>>
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ERROR: ino paths ioctl: Input/out=
put error
>>>>>>>>>
>>>>>>>>> and another message for that inode appears.
>>>>>>>>>
>>>>>>>>> 'btrfs check' (output attached) seems to notice these corruptio=
ns
>>>>>>>>> (among
>>>>>>>>> a few others, some of which seem to be related to a problematic=

>>>>>>>>> attempt
>>>>>>>>> to build Android I posted about some months ago).
>>>>>>>>>
>>>>>>>>> Other information:
>>>>>>>>>
>>>>>>>>> Arch Linux x86-64, kernel 4.16.6, btrfs-progs 4.16.=C2=A0 The
>>>>>>>>> filesystem
>>>>>>>>> has
>>>>>>>>> about 25 snapshots at the moment, only a handful of compressed
>>>>>>>>> files,
>>>>>>>>> and nothing fancy like qgroups enabled.
>>>>>>>>>
>>>>>>>>> btrfs fi show:
>>>>>>>>>
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Label: none=C2=A0 uuid: 9d4db9e3-=
b9c3-4f6d-8cb4-60ff55e96d82
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 Total devices 4 FS bytes used 2.48TiB
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 size 1.36TiB used 1.13TiB path /dev/s=
dd1
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 size 464.73GiB used 230.00GiB path
>>>>>>>>> /dev/sdc1
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 3 size 1.36TiB used 1.13TiB path /dev/s=
db1
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 4 size 3.49TiB used 2.49TiB path /dev/s=
da1
>>>>>>>>>
>>>>>>>>> btrfs fi df:
>>>>>>>>>
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Data, RAID1: total=3D2.49TiB, use=
d=3D2.48TiB
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0System, RAID1: total=3D32.00MiB, =
used=3D416.00KiB
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Metadata, RAID1: total=3D7.00GiB,=
 used=3D5.29GiB
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0GlobalReserve, single: total=3D51=
2.00MiB, used=3D0.00B
>>>>>>>>>
>>>>>>>>> dmesg output attached as well.
>>>>>>>>>
>>>>>>>>> Thanks in advance for any assistance!=C2=A0 I have backups of a=
ll the
>>>>>>>>> important stuff here but it would be nice to fix the
>>>>>>>>> corruptions in
>>>>>>>>> place.
>>>>>>>>
>>>>>>>> And btrfs check doesn't report the same problem as the default
>>>>>>>> original
>>>>>>>> mode doesn't have such check.
>>>>>>>>
>>>>>>>> Please also post the result of "btrfs check --mode=3Dlowmem
>>>>>>>> /dev/sda1"
>>>>>>>
>>>>>>> Also, attached.=C2=A0 It seems to notice the same off-by-one prob=
lems,
>>>>>>> though
>>>>>>> there also seem to be a couple of examples of being off by more t=
han
>>>>>>> one.
>>>>>>
>>>>>> Unfortunately, it doesn't detect, as there is no off-by-one error =
at
>>>>>> all.
>>>>>>
>>>>>> The problem is, kernel is reporting error on completely fine leaf.=

>>>>>>
>>>>>> Further more, even in the same leaf, there are more inlined extent=
s,
>>>>>> and
>>>>>> they are all valid.
>>>>>>
>>>>>> So the kernel reports the error out of nowhere.
>>>>>>
>>>>>> More problems happens for extent_size where a lot of them is
>>>>>> offset by
>>>>>> one.
>>>>>>
>>>>>> Moreover, the root owner is not printed correctly, thus I'm
>>>>>> wondering if
>>>>>> the memory is corrupted.
>>>>>>
>>>>>> Please try memtest+ to verify all your memory is correct, and if s=
o,
>>>>>> please try the attached patch and to see if it provides extra info=
=2E
>>>>>
>>>>> Memtest ran for about 12 hours last night, and didn't find any erro=
rs.
>>>>>
>>>>> New messages from patched kernel:
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0BTRFS critical (device sdd1): corrupt leaf: root=3D=
1
>>>>> block=3D4970196795392
>>>>> slot=3D307 ino=3D206231 file_offset=3D0, invalid ram_bytes for unco=
mpressed
>>>>> inline extent, have 3468 expect 3469 (21 + 3448)
>>>>
>>>> This output doesn't match with debug-tree dump.
>>>>
>>>> item 307 key (206231 EXTENT_DATA 0) itemoff 15118 itemsize 3468
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0generation 692987 type 0 (inline)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline extent data size 3447 ram_bytes=
 3447 compression 0 (none)
>>>>
>>>> Where its ram_bytes is 3447, not 3448.
>>>>
>>>> Further more, there are 2 more inlined extent, if something really w=
ent
>>>> wrong reading ram_bytes, it should also trigger the same warning.
>>>>
>>>> item 26 key (206227 EXTENT_DATA 0) itemoff 30917 itemsize 175
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0generation 367 type 0 (inline)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline extent data size 154 ram_bytes =
154 compression 0 (none)
>>>>
>>>> and
>>>>
>>>> item 26 key (206227 EXTENT_DATA 0) itemoff 30917 itemsize 175
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0generation 367 type 0 (inline)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0inline extent data size 154 ram_bytes =
154 compression 0 (none)
>>>>
>>>> The only way to get the number 3448 is from its inode item.
>>>>
>>>> item 305 key (206231 INODE_ITEM 0) itemoff 18607 itemsize 160
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0generation 1136104 transid 1136104 siz=
e 3447 nbytes=C2=A0 >>3448<<
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0block group 0 mode 100644 links 1 uid =
1000 gid 1000 rdev 0
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sequence 4 flags 0x0(none)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0atime 1390923260.43167583 (2014-01-28 =
15:34:20)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ctime 1416461176.910968309 (2014-11-20=
 05:26:16)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mtime 1392531030.754511511 (2014-02-16=
 06:10:30)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0otime 0.0 (1970-01-01 00:00:00)
>>>>
>>>> But the slot is correct, and nothing wrong with these item
>>>> offset/length.
>>>>
>>>> And the problem of wrong "root=3D" output also makes me pretty curio=
us.
>>>>
>>>> Is it possible to make a btrfs-image dump if all the filenames in th=
is
>>>> fs are not sensitive?
>>>
>>> Hi Qu Wenruo,
>>>
>>> I sent details of the btrfs-image to you in a private message. Hopefu=
lly
>>> you've received it and will find it useful.
>>
>> Sorry, I didn't find the private message.
>=20
> Ok, resent with a subject of "resend: btrfs image dump".=C2=A0 Hopefull=
y it
> didn't get caught by your spam filter.

Still nope.
What about encrypt it and upload it to some public storage provider like
google drive/dropbox?

Thanks,
Qu

>=20
> Steve
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--robbBXp3c3QOBxudTNO859uKJA5b6b9IF--

--7x2d0AgoeNHhlZJGb6YXVA982pZhONnLx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsLj3gACgkQwj2R86El
/qjynQf8DxvAdm+o5QPyy5oNpJqUS3F/57LXTHkjB+SQ1VOkDRsthRdoKhHZWszO
SNR2u2PaLSDg6i+hjKdFGvBLmIi/UnNTb7PJbBgYUPU/tg1PHwXrag9IpKQwaWbK
IeehIRrbZFGSh9l+INql3wOoh0DM2l6FJ0zBhPfLLyqj0xNJh/hESMNiajVYDBTU
dk6/VUcVbTgLPBugQJlHWVAjKsRXkQTg47Foon5Bg/hLKd4Q38BkPdG9lzwwTROr
cuN23J7XD7Ufplb3mjwfum8cWkIBGulxpr0RhmgAngpCHShORrJee012qZ5dGpiE
kTP30hjY+AdhBBjbef7i9hu82yyZpg==
=U5NE
-----END PGP SIGNATURE-----

--7x2d0AgoeNHhlZJGb6YXVA982pZhONnLx--
