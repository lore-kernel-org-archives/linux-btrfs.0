Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:46737 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751103AbeE0A5O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 May 2018 20:57:14 -0400
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
 <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
 <e0854da8-0d3e-946a-5709-7a329175bad3@shaw.ca>
 <de65fc60-fc23-f7d5-1f58-52687d4859e8@gmx.com>
 <b9ac2d21-93aa-e69a-5994-a1839114cfbb@shaw.ca>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <53d68efd-21fa-3e18-c35e-89a043605471@gmx.com>
Date: Sun, 27 May 2018 08:57:01 +0800
MIME-Version: 1.0
In-Reply-To: <b9ac2d21-93aa-e69a-5994-a1839114cfbb@shaw.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DuSkosoHBZefqKFhBkBbKzRWUKBSZlNC8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DuSkosoHBZefqKFhBkBbKzRWUKBSZlNC8
Content-Type: multipart/mixed; boundary="fScuKnlUoC60V2djECIbL1hknizR47ecI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
Message-ID: <53d68efd-21fa-3e18-c35e-89a043605471@gmx.com>
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
 <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
 <e0854da8-0d3e-946a-5709-7a329175bad3@shaw.ca>
 <de65fc60-fc23-f7d5-1f58-52687d4859e8@gmx.com>
 <b9ac2d21-93aa-e69a-5994-a1839114cfbb@shaw.ca>
In-Reply-To: <b9ac2d21-93aa-e69a-5994-a1839114cfbb@shaw.ca>

--fScuKnlUoC60V2djECIbL1hknizR47ecI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8826=E6=97=A5 22:06, Steve Leung wrote:
> On 05/20/2018 07:07 PM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B405=E6=9C=8821=E6=97=A5 04:43, Steve Leung wrote:
>>> On 05/19/2018 07:02 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2018=E5=B9=B405=E6=9C=8820=E6=97=A5 07:40, Steve Leung wrote:
>>>>> On 05/17/2018 11:49 PM, Qu Wenruo wrote:
>>>>>> On 2018=E5=B9=B405=E6=9C=8818=E6=97=A5 13:23, Steve Leung wrote:
>>>>>>> Hi list,
>>>>>>>
>>>>>>> I've got 3-device raid1 btrfs filesystem that's throwing up some
>>>>>>> "corrupt leaf" errors in dmesg.=C2=A0 This is a uniquified list I=
've
>>>>>>> observed lately:
>>>
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 BTRFS critical (device sda1): corrupt le=
af: root=3D1
>>>>>>> block=3D4970196795392
>>>>>>> slot=3D307 ino=3D206231 file_offset=3D0, invalid ram_bytes for
>>>>>>> uncompressed
>>>>>>> inline extent, have 3468 expect 3469
>>>>>>
>>>>>> Would you please use "btrfs-debug-tree -b 4970196795392 /dev/sda1"=
 to
>>>>>> dump the leaf?
>>>>>
>>>>> Attached btrfs-debug-tree dumps for all of the blocks that I saw
>>>>> messages for.
>>>>>
>>>>>> It's caught by tree-checker code which is ensuring all tree blocks=

>>>>>> are
>>>>>> correct before btrfs can take use of them.
>>>>>>
>>>>>> That inline extent size check is tested, so I'm wondering if this
>>>>>> indicates any real corruption.
>>>>>> That btrfs-debug-tree output will definitely help.
>>>>>>
>>>>>> BTW, if I didn't miss anything, there should not be any inlined
>>>>>> extent
>>>>>> in root tree.
>>>>>>
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 BTRFS critical (device sda1): corrupt le=
af: root=3D1
>>>>>>> block=3D4970552426496
>>>>>>> slot=3D91 ino=3D209736 file_offset=3D0, invalid ram_bytes for unc=
ompressed
>>>>>>> inline extent, have 3496 expect 3497
>>>>>>
>>>>>> Same dump will definitely help.
>>>>>>
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 BTRFS critical (device sda1): corrupt le=
af: root=3D1
>>>>>>> block=3D4970712399872
>>>>>>> slot=3D221 ino=3D205230 file_offset=3D0, invalid ram_bytes for
>>>>>>> uncompressed
>>>>>>> inline extent, have 1790 expect 1791
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 BTRFS critical (device sda1): corrupt le=
af: root=3D1
>>>>>>> block=3D4970803920896
>>>>>>> slot=3D368 ino=3D205732 file_offset=3D0, invalid ram_bytes for
>>>>>>> uncompressed
>>>>>>> inline extent, have 2475 expect 2476
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 BTRFS critical (device sda1): corrupt le=
af: root=3D1
>>>>>>> block=3D4970987945984
>>>>>>> slot=3D236 ino=3D208896 file_offset=3D0, invalid ram_bytes for
>>>>>>> uncompressed
>>>>>>> inline extent, have 490 expect 491
>>>>>>>
>>>>>>> All of them seem to be 1 short of the expected value.
>>>>>>>
>>>>>>> Some files do seem to be inaccessible on the filesystem, and btrf=
s
>>>>>>> inspect-internal on any of those inode numbers fails with:
>>>>>>>
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0ERROR: ino paths ioctl: Input/output erro=
r
>>>>>>>
>>>>>>> and another message for that inode appears.
>>>>>>>
>>>>>>> 'btrfs check' (output attached) seems to notice these corruptions=

>>>>>>> (among
>>>>>>> a few others, some of which seem to be related to a problematic
>>>>>>> attempt
>>>>>>> to build Android I posted about some months ago).
>>>>>>>
>>>>>>> Other information:
>>>>>>>
>>>>>>> Arch Linux x86-64, kernel 4.16.6, btrfs-progs 4.16.=C2=A0 The fil=
esystem
>>>>>>> has
>>>>>>> about 25 snapshots at the moment, only a handful of compressed
>>>>>>> files,
>>>>>>> and nothing fancy like qgroups enabled.
>>>>>>>
>>>>>>> btrfs fi show:
>>>>>>>
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0Label: none=C2=A0 uuid: 9d4db9e3-b9c3-4f6=
d-8cb4-60ff55e96d82
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 Total devices 4 FS bytes used 2.48TiB
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 devid=C2=A0=C2=A0=C2=A0 1 size 1.36TiB used 1.13TiB path /dev/sdd1
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 devid=C2=A0=C2=A0=C2=A0 2 size 464.73GiB used 230.00GiB path /dev/sdc1
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 devid=C2=A0=C2=A0=C2=A0 3 size 1.36TiB used 1.13TiB path /dev/sdb1
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 devid=C2=A0=C2=A0=C2=A0 4 size 3.49TiB used 2.49TiB path /dev/sda1
>>>>>>>
>>>>>>> btrfs fi df:
>>>>>>>
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0Data, RAID1: total=3D2.49TiB, used=3D2.48=
TiB
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0System, RAID1: total=3D32.00MiB, used=3D4=
16.00KiB
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0Metadata, RAID1: total=3D7.00GiB, used=3D=
5.29GiB
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0GlobalReserve, single: total=3D512.00MiB,=
 used=3D0.00B
>>>>>>>
>>>>>>> dmesg output attached as well.
>>>>>>>
>>>>>>> Thanks in advance for any assistance!=C2=A0 I have backups of all=
 the
>>>>>>> important stuff here but it would be nice to fix the corruptions =
in
>>>>>>> place.
>>>>>>
>>>>>> And btrfs check doesn't report the same problem as the default
>>>>>> original
>>>>>> mode doesn't have such check.
>>>>>>
>>>>>> Please also post the result of "btrfs check --mode=3Dlowmem /dev/s=
da1"
>>>>>
>>>>> Also, attached.=C2=A0 It seems to notice the same off-by-one proble=
ms,
>>>>> though
>>>>> there also seem to be a couple of examples of being off by more tha=
n
>>>>> one.
>>>>
>>>> Unfortunately, it doesn't detect, as there is no off-by-one error at=

>>>> all.
>>>>
>>>> The problem is, kernel is reporting error on completely fine leaf.
>>>>
>>>> Further more, even in the same leaf, there are more inlined extents,=

>>>> and
>>>> they are all valid.
>>>>
>>>> So the kernel reports the error out of nowhere.
>>>>
>>>> More problems happens for extent_size where a lot of them is offset =
by
>>>> one.
>>>>
>>>> Moreover, the root owner is not printed correctly, thus I'm
>>>> wondering if
>>>> the memory is corrupted.
>>>>
>>>> Please try memtest+ to verify all your memory is correct, and if so,=

>>>> please try the attached patch and to see if it provides extra info.
>>>
>>> Memtest ran for about 12 hours last night, and didn't find any errors=
=2E
>>>
>>> New messages from patched kernel:
>>>
>>> =C2=A0=C2=A0BTRFS critical (device sdd1): corrupt leaf: root=3D1 bloc=
k=3D4970196795392
>>> slot=3D307 ino=3D206231 file_offset=3D0, invalid ram_bytes for uncomp=
ressed
>>> inline extent, have 3468 expect 3469 (21 + 3448)
>>
>> This output doesn't match with debug-tree dump.
>>
>> item 307 key (206231 EXTENT_DATA 0) itemoff 15118 itemsize 3468
>> =C2=A0=C2=A0=C2=A0=C2=A0generation 692987 type 0 (inline)
>> =C2=A0=C2=A0=C2=A0=C2=A0inline extent data size 3447 ram_bytes 3447 co=
mpression 0 (none)
>>
>> Where its ram_bytes is 3447, not 3448.
>>
>> Further more, there are 2 more inlined extent, if something really wen=
t
>> wrong reading ram_bytes, it should also trigger the same warning.
>>
>> item 26 key (206227 EXTENT_DATA 0) itemoff 30917 itemsize 175
>> =C2=A0=C2=A0=C2=A0=C2=A0generation 367 type 0 (inline)
>> =C2=A0=C2=A0=C2=A0=C2=A0inline extent data size 154 ram_bytes 154 comp=
ression 0 (none)
>>
>> and
>>
>> item 26 key (206227 EXTENT_DATA 0) itemoff 30917 itemsize 175
>> =C2=A0=C2=A0=C2=A0=C2=A0generation 367 type 0 (inline)
>> =C2=A0=C2=A0=C2=A0=C2=A0inline extent data size 154 ram_bytes 154 comp=
ression 0 (none)
>>
>> The only way to get the number 3448 is from its inode item.
>>
>> item 305 key (206231 INODE_ITEM 0) itemoff 18607 itemsize 160
>> =C2=A0=C2=A0=C2=A0=C2=A0generation 1136104 transid 1136104 size 3447 n=
bytes=C2=A0 >>3448<<
>> =C2=A0=C2=A0=C2=A0=C2=A0block group 0 mode 100644 links 1 uid 1000 gid=
 1000 rdev 0
>> =C2=A0=C2=A0=C2=A0=C2=A0sequence 4 flags 0x0(none)
>> =C2=A0=C2=A0=C2=A0=C2=A0atime 1390923260.43167583 (2014-01-28 15:34:20=
)
>> =C2=A0=C2=A0=C2=A0=C2=A0ctime 1416461176.910968309 (2014-11-20 05:26:1=
6)
>> =C2=A0=C2=A0=C2=A0=C2=A0mtime 1392531030.754511511 (2014-02-16 06:10:3=
0)
>> =C2=A0=C2=A0=C2=A0=C2=A0otime 0.0 (1970-01-01 00:00:00)
>>
>> But the slot is correct, and nothing wrong with these item offset/leng=
th.
>>
>> And the problem of wrong "root=3D" output also makes me pretty curious=
=2E
>>
>> Is it possible to make a btrfs-image dump if all the filenames in this=

>> fs are not sensitive?
>=20
> Hi Qu Wenruo,
>=20
> I sent details of the btrfs-image to you in a private message. Hopefull=
y
> you've received it and will find it useful.

Sorry, I didn't find the private message.

>=20
> But FYI I've been able to recover my damaged data from backups so at
> least now there's no issue of data loss for me personally.
>=20
> One question I had though - what's the easiest way to get rid of these
> problematic inodes?=C2=A0 I can't directly copy new files on top of the=
 old
> names now.=C2=A0 A couple of options spring to mind:

Sorry, not way right now.

The problem is, the whole kernel is not behaving as expected.
And I have no idea how this happened at all.

>=20
> - 'btrfs check'; how dangerous is it, really?=C2=A0 :)

As long as you don't use --repair, it's pretty safe.

And normally, btrfs community could provide enough help.
(Sometimes with black magic to manually modify tree blocks to fix it,
but it's not the case)

For this particular case, --repair should not be that dangerous, as most
problems are just inode's nbytes, which should be easily fixed by --repai=
r.

>=20
> - Make a new subvolume and reflink all of the surviving files over. The=
n
> copy the restored files in, and delete the old subvolume.=C2=A0 Would t=
hat
> actually work?

No. It's kernel refusing to read some tree blocks.
No way to fix using the current kernel.

>=20
> - Move all the enclosing directories to a self-made lost+found
> directory, and ignore them.

Nope, the same reason.

>=20
> - Any other ideas?

Since it's the latest kernel causing problem, reverting to old kernel
may help.
At least for older kernel, there is no such restrict check.

Thanks,
Qu

>=20
> Steve
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--fScuKnlUoC60V2djECIbL1hknizR47ecI--

--DuSkosoHBZefqKFhBkBbKzRWUKBSZlNC8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsKAl0ACgkQwj2R86El
/qgFvAf/XLDFchKg6jO7YJv6UdJL6PLLL0w7brcho9glpIZFFfBeiRfLtgTm5ZqF
0X+c5lSUueHoDK5ZwEfVACC3qZPSYA9oO547J0skEBxw+8oDvz8By8nrpEzEaEyX
zmNXb6SqlY9s4TuI4/Yuvk11n3CjLdx2c/eHx3CEzF8LY5SXWoeWidIYsEvotj3g
CtXCT8iJhlwf8arjRhB0lSk22Icc37WAxHuwYC3hA7YmvVBIR3SdpTnAq+Ote+44
e5hYsz/DiF05HNcjVcSMBy6cks3dCFdLAciTyuDiuc41pdkCdt5iki+lTb5s4nxk
HL/YFUOtQFEg3MloW1tihv83O1QkSQ==
=ZWYW
-----END PGP SIGNATURE-----

--DuSkosoHBZefqKFhBkBbKzRWUKBSZlNC8--
