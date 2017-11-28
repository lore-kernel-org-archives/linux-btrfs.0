Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63871 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750850AbdK1HEE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 02:04:04 -0500
Subject: Re: splat on 4.15-rc1: invalid ram_bytes for uncompressed inline
 extent
To: Nikolay Borisov <nborisov@suse.com>, Adam Borowski <kilobyte@angband.pl>,
        linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
References: <20171127132349.cm7c3mgegbqhlnrm@angband.pl>
 <d39b049e-258f-fd3d-bafd-7a1264098c89@suse.com>
 <fd1ba2f8-1036-85c4-f2c2-d46efb5d12e8@gmx.com>
 <27db4f13-dace-75f6-29e4-ddd1050101f8@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f5bf4809-7f84-97fb-21fa-c07e1745468c@gmx.com>
Date: Tue, 28 Nov 2017 15:03:19 +0800
MIME-Version: 1.0
In-Reply-To: <27db4f13-dace-75f6-29e4-ddd1050101f8@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cECupRwBs3FrKlg6NuGCDnV0sLDiQUDxi"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cECupRwBs3FrKlg6NuGCDnV0sLDiQUDxi
Content-Type: multipart/mixed; boundary="JgAVxUUlMNKcOFGHALCL6pN5i41Td49ix";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Adam Borowski <kilobyte@angband.pl>,
 linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
 David Sterba <dsterba@suse.com>
Message-ID: <f5bf4809-7f84-97fb-21fa-c07e1745468c@gmx.com>
Subject: Re: splat on 4.15-rc1: invalid ram_bytes for uncompressed inline
 extent
References: <20171127132349.cm7c3mgegbqhlnrm@angband.pl>
 <d39b049e-258f-fd3d-bafd-7a1264098c89@suse.com>
 <fd1ba2f8-1036-85c4-f2c2-d46efb5d12e8@gmx.com>
 <27db4f13-dace-75f6-29e4-ddd1050101f8@suse.com>
In-Reply-To: <27db4f13-dace-75f6-29e4-ddd1050101f8@suse.com>

--JgAVxUUlMNKcOFGHALCL6pN5i41Td49ix
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8828=E6=97=A5 14:59, Nikolay Borisov wrote:
>=20
>=20
> On 28.11.2017 02:37, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8827=E6=97=A5 23:29, Nikolay Borisov wrote:
>>>
>>>
>>> On 27.11.2017 15:23, Adam Borowski wrote:
>>>> Hi!
>>>> On 4.15-rc1, I get the following failure:
>>>>
>>>> BTRFS critical (device sda1): corrupt leaf: root=3D1 block=3D3820662=
898688
>>>> slot=3D43 ino=3D35691 file_offset=3D0, invalid ram_bytes for uncompr=
essed inline
>>>> extent, have 134 expect 281474976710677
>>>>
>>>> Repeatable every boot attempt.  4.14 and earlier boot fine; btrfs ch=
eck
>>>> (progs 4.13.3) doesn't find any badness either.
>>>
>>> The reason why you hit this on 4.15 is because this error is coming f=
rom the tree checker.=20
>>> So how big is the file which inode 35691 represents?=20
>>
>> The problem is, the reporter is using CONFIG_BTRFS_FS_CHECK_INTEGRITY,=

>> which will call btrfs_check_leaf() every time btrfs_mark_buffer_dirty(=
).
>>
>> However just as explained in the fixing patch:
>> https://patchwork.kernel.org/patch/10047489/
>>
>> The timing of call btrfs_mark_buffer_dirty() is not right, one of the
>> most obvious place is for EXTENT_DATA.
>=20
> Right, that was one of the things which I suspected. So in this case,
> David, do we want to push those fixes to 4.15-rc in some of the upcomin=
g
> pull reqs or are we gonna have FS_INTEGRITY left broken for a release
> (imo not a good thing) ?

BTW, compression level wild memory access fix is even more important.

Just try to mount with "-o compress" then kernel will crash.

Thanks,
Qu

>=20
>=20
>>
>> So please apply the above patch to see if it solves the problem.
>>
>> Thanks,
>> Qu
>>>
>>> So the check which fails is:=20
>>>
>>>             if (item_size !=3D BTRFS_FILE_EXTENT_INLINE_DATA_START + =
        =20
>>>                     btrfs_file_extent_ram_bytes(leaf, fi)) {         =
          =20
>>>                         file_extent_err(root, leaf, slot,            =
          =20
>>>         "invalid ram_bytes for uncompressed inline extent, have %u ex=
pect %llu",
>>>                                 item_size, BTRFS_FILE_EXTENT_INLINE_D=
ATA_START +
>>>                                 btrfs_file_extent_ram_bytes(leaf, fi)=
);        =20
>>>                         return -EUCLEAN;                             =
          =20
>>>                 }
>>>
>>> BTRFS_FILE_EXTENT_INLINE_DATA_START is 21 based on pahole's output:=20
>>>
>>> struct btrfs_file_extent_item {
>>> 	__le64                     generation;           /*     0     8 */
>>> 	__le64                     ram_bytes;            /*     8     8 */
>>> 	__u8                       compression;          /*    16     1 */
>>> 	__u8                       encryption;           /*    17     1 */
>>> 	__le16                     other_encoding;       /*    18     2 */
>>> 	__u8                       type;                 /*    20     1 */
>>> 	__le64                     disk_bytenr;          /*    21     8 */
>>> 	__le64                     disk_num_bytes;       /*    29     8 */
>>> 	__le64                     offset;               /*    37     8 */
>>> 	__le64                     num_bytes;            /*    45     8 */
>>>
>>> 	/* size: 53, cachelines: 1, members: 10 */
>>> 	/* last cacheline: 53 bytes */
>>> };
>>>
>>> The inline extent size is 113 so 21 + 113 should is 134 which equals =
to what we expect. However,=20
>>> the printing code uses btrfs_file_extent_inline_len and the tree-chec=
ker code uses directly the=20
>>> ram bytes. And this function does the correct thing according to whet=
her the file is compressed or not.=20
>>> So Qu, perhaps the code needs to be changed or is this a genuine bug =
?=20
>>>
>>>>
>>>> [   11.347451] BTRFS info (device sda1): use lzo compression
>>>> [   11.352914] BTRFS info (device sda1): using free space tree
>>>> [....] Activating lvm and md swap...[ ok done.
>>>> [....] Checking file systems...fsck from util-l
>>>> [   11.660352] BTRFS critical (device sda1): corrupt leaf: root=3D1 =
block=3D3820662898688 slot=3D43 ino=3D35691 file_offset=3D0, invalid ram_=
bytes for uncompressed inline extent, have 134 expect 281474976710677
>>>> inux 2.30.2
>>>> [   11.678550] BTRFS info (device sda1): leaf 3820662898688 total pt=
rs 103 free space 4350
>>>> [   11.687767] 	item 0 key (35663 12 32909) itemoff 16263 itemsize 2=
0
>>>> [   11.695021] 	item 1 key (35663 108 0) itemoff 15751 itemsize 512
>>>> [   11.701274] 		inline extent data size 509
>>>>  ok
>>>> [   11.705704] 	item 2 key (35664 1 0) itemoff 15591 itemsize 160
>>>> [   11.713034] 		inode generation 1292 size 509 mode 100644
>>>> [   11.718811] 	item 3 key (35664 12 32909) itemoff 15571 itemsize 2=
0
>>>> [   11.725113] 	item 4 key (35664 108 0) itemoff 15059 itemsize 512
>>>> [   11.732168] 		inline extent data size 509
>>>> done.
>>>> [   11.736280] 	item 5 key (35665 1 0) itemoff 14899 itemsize 160
>>>> [   11.742681] 		inode generation 1292 size 457 mode 100644
>>>> [   11.748275] 	item 6 key (35665 12 32909) itemoff 14879 itemsize 2=
0
>>>> [   11.754584] 	item 7 key (35665 108 0) itemoff 14411 itemsize 468
>>>> [   11.760674] 		inline extent data size 457
>>>> [   11.764780] 	item 8 key (35666 1 0) itemoff 14251 itemsize 160
>>>> [   11.770711] 		inode generation 1292 size 533 mode 100644
>>>> [....]
>>>> [   11.776145] 	item 9 key (35666 12 32909) itemoff 14231 itemsize 2=
0
>>>> Cleaning up temp
>>>> [   11.783069] 	item 10 key (35666 108 0) itemoff 13697 itemsize 534=

>>>> orary files...
>>>> [   11.790666] 		inline extent data size 533
>>>> [   11.795980] 	item 11 key (35668 1 0) itemoff 13537 itemsize 160
>>>> [   11.801989] 		inode generation 1292 size 319 mode 100644
>>>>  /tmp
>>>> [   11.807413] 	item 12 key (35668 12 32909) itemoff 13517 itemsize =
20
>>>> [   11.814250] 	item 13 key (35668 108 0) itemoff 13247 itemsize 270=

>>>> [   11.820512] 		inline extent data size 319
>>>> [   11.825539] 	item 14 key (35669 1 0) itemoff 13087 itemsize 160
>>>> [   11.831577] 		inode generation 1292 size 375 mode 100644
>>>> [   11.837149] 	item 15 key (35669 12 32909) itemoff 13067 itemsize =
20
>>>> [   11.843873] 	item 16 key (35669 108 0) itemoff 12783 itemsize 284=

>>>>  ok=20
>>>> [   11.850098] 		inline extent data size 375
>>>> [   11.855579] 	item 17 key (35670 1 0) itemoff 12623 itemsize 160
>>>> [   11.862861] 		inode generation 1292 size 168 mode 100644
>>>> .
>>>> [   11.869194] 	item 18 key (35670 12 33512) itemoff 12588 itemsize =
35
>>>> [   11.876467] 	item 19 key (35670 108 0) itemoff 12399 itemsize 189=

>>>> [   11.883564] 		inline extent data size 168
>>>> [   11.888551] 	item 20 key (35676 1 0) itemoff 12239 itemsize 160
>>>> [   11.895421] 		inode generation 1292 size 512 mode 100600
>>>> [   11.901719] 	item 21 key (35676 12 32911) itemoff 12218 itemsize =
21
>>>> [   11.909045] 	item 22 key (35676 108 0) itemoff 11685 itemsize 533=

>>>> [   11.916136] 		inline extent data size 512
>>>> [   11.921125] 	item 23 key (35685 1 0) itemoff 11525 itemsize 160
>>>> [   11.928047] 		inode generation 1292 size 32128 mode 100644
>>>> [   11.934553] 	item 24 key (35685 12 32783) itemoff 11508 itemsize =
17
>>>> [....] Mounting=20
>>>> [   11.941874] 	item 25 key (35685 108 0) itemoff 11455 itemsize 53
>>>> local filesystem
>>>> [   11.949377] 		extent data disk bytenr 3757990555648 nr 4096
>>>> s...
>>>> [   11.956471] 		extent data offset 0 nr 4096 ram 4096
>>>> [   11.962383] 	item 26 key (35685 108 4096) itemoff 11402 itemsize =
53
>>>> [   11.969704] 		extent data disk bytenr 3755041128448 nr 4096
>>>> [   11.976324] 		extent data offset 4096 nr 24576 ram 32768
>>>> [   11.982686] 	item 27 key (35685 108 28672) itemoff 11349 itemsize=
 53
>>>> [   11.990140] 		extent data disk bytenr 3749090922496 nr 4096
>>>> [   11.996786] 		extent data offset 0 nr 4096 ram 4096
>>>> [   12.002732] 	item 28 key (35686 1 0) itemoff 11189 itemsize 160
>>>> [   12.009755] 		inode generation 1292 size 5023 mode 100644
>>>> [   12.016204] 	item 29 key (35686 12 32783) itemoff 11165 itemsize =
24
>>>> [   12.023576] 	item 30 key (35686 108 0) itemoff 11112 itemsize 53
>>>> [   12.030665] 		extent data disk bytenr 3651995594752 nr 4096
>>>> [   12.037298] 		extent data offset 0 nr 8192 ram 8192
>>>> [   12.043184] 	item 31 key (35687 1 0) itemoff 10952 itemsize 160
>>>> [   12.050181] 		inode generation 1292 size 293168 mode 100664
>>>> [   12.056793] 	item 32 key (35687 12 32783) itemoff 10935 itemsize =
17
>>>> [   12.064082] 	item 33 key (35687 108 0) itemoff 10882 itemsize 53
>>>> [   12.071154] 		extent data disk bytenr 3752314163200 nr 4096
>>>> [   12.077745] 		extent data offset 0 nr 4096 ram 4096
>>>> [   12.083610] 	item 34 key (35687 108 4096) itemoff 10829 itemsize =
53
>>>> [   12.090908] 		extent data disk bytenr 3755041230848 nr 4096
>>>> [   12.097483] 		extent data offset 4096 nr 24576 ram 131072
>>>> [   12.103877] 	item 35 key (35687 108 28672) itemoff 10776 itemsize=
 53
>>>> [   12.111242] 		extent data disk bytenr 3757145198592 nr 4096
>>>> [   12.117770] 		extent data offset 0 nr 4096 ram 4096
>>>> [   12.123604] 	item 36 key (35687 108 32768) itemoff 10723 itemsize=
 53
>>>> [   12.130962] 		extent data disk bytenr 3758049980416 nr 4096
>>>> [   12.137514] 		extent data offset 0 nr 4096 ram 4096
>>>> [   12.143391] 	item 37 key (35687 108 36864) itemoff 10670 itemsize=
 53
>>>> [   12.150753] 		extent data disk bytenr 3755041230848 nr 4096
>>>> [   12.157273] 		extent data offset 36864 nr 94208 ram 131072
>>>> [   12.163722] 	item 38 key (35687 108 131072) itemoff 10617 itemsiz=
e 53
>>>> [   12.171129] 		extent data disk bytenr 3749813366784 nr 212992
>>>> [   12.177888] 		extent data offset 0 nr 131072 ram 212992
>>>> [   12.184058] 	item 39 key (35687 108 262144) itemoff 10564 itemsiz=
e 53
>>>> [   12.191461] 		extent data disk bytenr 3749925076992 nr 4096
>>>> [   12.197995] 		extent data offset 0 nr 28672 ram 32768
>>>> [   12.204026] 	item 40 key (35687 108 290816) itemoff 10511 itemsiz=
e 53
>>>> [   12.211465] 		extent data disk bytenr 3748484284416 nr 4096
>>>> [   12.218010] 		extent data offset 0 nr 4096 ram 4096
>>>> [   12.223846] 	item 41 key (35691 1 0) itemoff 10351 itemsize 160
>>>> [   12.230746] 		inode generation 1292 size 122 mode 100640
>>>> [   12.237049] 	item 42 key (35691 12 33516) itemoff 10334 itemsize =
17
>>>> [   12.244314] 	item 43 key (35691 108 0) itemoff 10200 itemsize 134=

>>>> [   12.251432] 		inline extent data size 113
>>>> [   12.256397] 	item 44 key (35692 1 0) itemoff 10040 itemsize 160
>>>> [   12.263321] 		inode generation 1292 size 31 mode 100640
>>>> [   12.269506] 	item 45 key (35692 12 33516) itemoff 10021 itemsize =
19
>>>> [   12.276744] 	item 46 key (35692 108 0) itemoff 9969 itemsize 52
>>>> [   12.283645] 		inline extent data size 31
>>>> [   12.288531] 	item 47 key (35704 1 0) itemoff 9809 itemsize 160
>>>> [   12.295350] 		inode generation 1298 size 23572480 mode 100644
>>>> [   12.302089] 	item 48 key (35704 12 32788) itemoff 9787 itemsize 2=
2
>>>> [   12.309269] 	item 49 key (35704 108 0) itemoff 9734 itemsize 53
>>>> [   12.316116] 		extent data disk bytenr 3753633746944 nr 4096
>>>> [   12.322679] 		extent data offset 0 nr 4096 ram 4096
>>>> [   12.328524] 	item 50 key (35704 108 4096) itemoff 9681 itemsize 5=
3
>>>> [   12.335688] 		extent data disk bytenr 3750878265344 nr 20480
>>>> [   12.342346] 		extent data offset 4096 nr 12288 ram 20480
>>>> [   12.348615] 	item 51 key (35704 108 16384) itemoff 9628 itemsize =
53
>>>> [   12.355835] 		extent data disk bytenr 3753633751040 nr 4096
>>>> [   12.362340] 		extent data offset 0 nr 4096 ram 4096
>>>> [   12.368180] 	item 52 key (35704 108 36864) itemoff 9575 itemsize =
53
>>>> [   12.375435] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.382334] 		extent data offset 0 nr 3108864 ram 21381120
>>>> [   12.388784] 	item 53 key (35704 108 3145728) itemoff 9522 itemsiz=
e 53
>>>> [   12.396187] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.403096] 		extent data offset 3108864 nr 131072 ram 21381120
>>>> [   12.409971] 	item 54 key (35704 108 3276800) itemoff 9469 itemsiz=
e 53
>>>> [   12.417383] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.424276] 		extent data offset 3239936 nr 1441792 ram 21381120
>>>> [   12.431256] 	item 55 key (35704 108 4718592) itemoff 9416 itemsiz=
e 53
>>>> [   12.438694] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.445582] 		extent data offset 4681728 nr 131072 ram 21381120
>>>> [   12.452490] 	item 56 key (35704 108 4849664) itemoff 9363 itemsiz=
e 53
>>>> [   12.459924] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.466841] 		extent data offset 4812800 nr 1048576 ram 21381120
>>>> [   12.473841] 	item 57 key (35704 108 5898240) itemoff 9310 itemsiz=
e 53
>>>> [   12.481276] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.488166] 		extent data offset 5861376 nr 131072 ram 21381120
>>>> [   12.495028] 	item 58 key (35704 108 6029312) itemoff 9257 itemsiz=
e 53
>>>> [   12.502473] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.509355] 		extent data offset 5992448 nr 786432 ram 21381120
>>>> [   12.516241] 	item 59 key (35704 108 6815744) itemoff 9204 itemsiz=
e 53
>>>> [   12.523670] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.530573] 		extent data offset 6778880 nr 131072 ram 21381120
>>>> [   12.537469] 	item 60 key (35704 108 6946816) itemoff 9151 itemsiz=
e 53
>>>> [   12.544918] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.551821] 		extent data offset 6909952 nr 131072 ram 21381120
>>>> [   12.558715] 	item 61 key (35704 108 7077888) itemoff 9098 itemsiz=
e 53
>>>> [   12.566119] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.572994] 		extent data offset 7041024 nr 131072 ram 21381120
>>>> [   12.579854] 	item 62 key (35704 108 7208960) itemoff 9045 itemsiz=
e 53
>>>> [   12.587270] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.594157] 		extent data offset 7172096 nr 131072 ram 21381120
>>>> [   12.601029] 	item 63 key (35704 108 7340032) itemoff 8992 itemsiz=
e 53
>>>> [   12.608416] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.615303] 		extent data offset 7303168 nr 131072 ram 21381120
>>>> [   12.622212] 	item 64 key (35704 108 7471104) itemoff 8939 itemsiz=
e 53
>>>> [   12.629625] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.636499] 		extent data offset 7434240 nr 131072 ram 21381120
>>>> [   12.643360] 	item 65 key (35704 108 7602176) itemoff 8886 itemsiz=
e 53
>>>> [   12.650739] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.657597] 		extent data offset 7565312 nr 131072 ram 21381120
>>>> [   12.664472] 	item 66 key (35704 108 7733248) itemoff 8833 itemsiz=
e 53
>>>> [   12.671876] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.678740] 		extent data offset 7696384 nr 131072 ram 21381120
>>>> [   12.685635] 	item 67 key (35704 108 7864320) itemoff 8780 itemsiz=
e 53
>>>> [   12.693033] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.699875] 		extent data offset 7827456 nr 131072 ram 21381120
>>>> [   12.706725] 	item 68 key (35704 108 7995392) itemoff 8727 itemsiz=
e 53
>>>> [   12.714077] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.720926] 		extent data offset 7958528 nr 131072 ram 21381120
>>>> [   12.727750] 	item 69 key (35704 108 8126464) itemoff 8674 itemsiz=
e 53
>>>> [   12.735091] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.741929] 		extent data offset 8089600 nr 131072 ram 21381120
>>>> [   12.748755] 	item 70 key (35704 108 8257536) itemoff 8621 itemsiz=
e 53
>>>> [   12.756090] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.762925] 		extent data offset 8220672 nr 131072 ram 21381120
>>>> [   12.769761] 	item 71 key (35704 108 8388608) itemoff 8568 itemsiz=
e 53
>>>> [   12.777122] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.783942] 		extent data offset 8351744 nr 655360 ram 21381120
>>>> [   12.790748] 	item 72 key (35704 108 9043968) itemoff 8515 itemsiz=
e 53
>>>> [   12.798089] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.804933] 		extent data offset 9007104 nr 131072 ram 21381120
>>>> [   12.811794] 	item 73 key (35704 108 9175040) itemoff 8462 itemsiz=
e 53
>>>> [   12.819126] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.825941] 		extent data offset 9138176 nr 131072 ram 21381120
>>>> [   12.832765] 	item 74 key (35704 108 9306112) itemoff 8409 itemsiz=
e 53
>>>> [   12.840111] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.846925] 		extent data offset 9269248 nr 2490368 ram 21381120
>>>> [   12.853862] 	item 75 key (35704 108 11796480) itemoff 8356 itemsi=
ze 53
>>>> [   12.861333] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.868147] 		extent data offset 11759616 nr 131072 ram 21381120
>>>> [   12.875036] 	item 76 key (35704 108 11927552) itemoff 8303 itemsi=
ze 53
>>>> [   12.882489] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.889300] 		extent data offset 11890688 nr 1179648 ram 21381120=

>>>> [   12.896289] 	item 77 key (35704 108 13107200) itemoff 8250 itemsi=
ze 53
>>>> [   12.903722] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.910524] 		extent data offset 13070336 nr 131072 ram 21381120
>>>> [   12.917452] 	item 78 key (35704 108 13238272) itemoff 8197 itemsi=
ze 53
>>>> [   12.924903] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.931720] 		extent data offset 13201408 nr 262144 ram 21381120
>>>> [   12.938630] 	item 79 key (35704 108 13500416) itemoff 8144 itemsi=
ze 53
>>>> [   12.946076] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.952907] 		extent data offset 13463552 nr 131072 ram 21381120
>>>> [   12.959817] 	item 80 key (35704 108 13631488) itemoff 8091 itemsi=
ze 53
>>>> [   12.967252] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.974078] 		extent data offset 13594624 nr 131072 ram 21381120
>>>> [   12.980986] 	item 81 key (35704 108 13762560) itemoff 8038 itemsi=
ze 53
>>>> [   12.988461] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   12.995310] 		extent data offset 13725696 nr 131072 ram 21381120
>>>> [   13.002223] 	item 82 key (35704 108 13893632) itemoff 7985 itemsi=
ze 53
>>>> [   13.009719] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.016561] 		extent data offset 13856768 nr 131072 ram 21381120
>>>> [   13.023514] 	item 83 key (35704 108 14024704) itemoff 7932 itemsi=
ze 53
>>>> [   13.030966] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.037806] 		extent data offset 13987840 nr 393216 ram 21381120
>>>> [   13.044762] 	item 84 key (35704 108 14417920) itemoff 7879 itemsi=
ze 53
>>>> [   13.052256] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.059093] 		extent data offset 14381056 nr 131072 ram 21381120
>>>> [   13.066051] 	item 85 key (35704 108 14548992) itemoff 7826 itemsi=
ze 53
>>>> [   13.073541] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.080431] 		extent data offset 14512128 nr 131072 ram 21381120
>>>> [   13.087390] 	item 86 key (35704 108 14680064) itemoff 7773 itemsi=
ze 53
>>>> [   13.094859] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.101722] 		extent data offset 14643200 nr 131072 ram 21381120
>>>> [   13.108669] 	item 87 key (35704 108 14811136) itemoff 7720 itemsi=
ze 53
>>>> [   13.116149] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.123004] 		extent data offset 14774272 nr 655360 ram 21381120
>>>> [   13.129966] 	item 88 key (35704 108 15466496) itemoff 7667 itemsi=
ze 53
>>>> [   13.137470] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.144337] 		extent data offset 15429632 nr 131072 ram 21381120
>>>> [   13.151302] 	item 89 key (35704 108 15597568) itemoff 7614 itemsi=
ze 53
>>>> [   13.158810] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.165699] 		extent data offset 15560704 nr 131072 ram 21381120
>>>> [   13.172663] 	item 90 key (35704 108 15728640) itemoff 7561 itemsi=
ze 53
>>>> [   13.180161] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.187003] 		extent data offset 15691776 nr 131072 ram 21381120
>>>> [   13.193969] 	item 91 key (35704 108 15859712) itemoff 7508 itemsi=
ze 53
>>>> [   13.201464] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.208335] 		extent data offset 15822848 nr 131072 ram 21381120
>>>> [   13.215338] 	item 92 key (35704 108 15990784) itemoff 7455 itemsi=
ze 53
>>>> [   13.222803] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.229673] 		extent data offset 15953920 nr 786432 ram 21381120
>>>> [   13.236676] 	item 93 key (35704 108 16777216) itemoff 7402 itemsi=
ze 53
>>>> [   13.244164] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.251047] 		extent data offset 16740352 nr 131072 ram 21381120
>>>> [   13.257996] 	item 94 key (35704 108 16908288) itemoff 7349 itemsi=
ze 53
>>>> [   13.265517] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.272404] 		extent data offset 16871424 nr 262144 ram 21381120
>>>> [   13.279356] 	item 95 key (35704 108 17170432) itemoff 7296 itemsi=
ze 53
>>>> [   13.286886] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.293767] 		extent data offset 17133568 nr 131072 ram 21381120
>>>> [   13.300730] 	item 96 key (35704 108 17301504) itemoff 7243 itemsi=
ze 53
>>>> [   13.308253] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.315145] 		extent data offset 17264640 nr 131072 ram 21381120
>>>> [   13.322155] 	item 97 key (35704 108 17432576) itemoff 7190 itemsi=
ze 53
>>>> [   13.329668] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.336582] 		extent data offset 17395712 nr 524288 ram 21381120
>>>> [   13.343576] 	item 98 key (35704 108 17956864) itemoff 7137 itemsi=
ze 53
>>>> [   13.351102] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.358009] 		extent data offset 17920000 nr 131072 ram 21381120
>>>> [   13.364968] 	item 99 key (35704 108 18087936) itemoff 7084 itemsi=
ze 53
>>>> [   13.372493] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.379398] 		extent data offset 18051072 nr 131072 ram 21381120
>>>> [   13.386367] 	item 100 key (35704 108 18219008) itemoff 7031 items=
ize 53
>>>> [   13.394000] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.400911] 		extent data offset 18182144 nr 131072 ram 21381120
>>>> [   13.407917] 	item 101 key (35704 108 18350080) itemoff 6978 items=
ize 53
>>>> [   13.415531] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.422432] 		extent data offset 18313216 nr 393216 ram 21381120
>>>> [   13.429439] 	item 102 key (35704 108 18743296) itemoff 6925 items=
ize 53
>>>> [   13.437056] 		extent data disk bytenr 3753678123008 nr 21381120
>>>> [   13.443964] 		extent data offset 18706432 nr 131072 ram 21381120
>>>> [   13.450985] assertion failed: 0, file: fs/btrfs/disk-io.c, line: =
3863
>>>
>>> I guess the code here is :=20
>>>
>>> void btrfs_mark_buffer_dirty(struct extent_buffer *buf)              =
          =20
>>> {
>>>
>>> #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY                               =
          =20
>>>         if (btrfs_header_level(buf) =3D=3D 0 && btrfs_check_leaf(root=
, buf)) {     =20
>>>                 btrfs_print_leaf(buf);                               =
          =20
>>>                 ASSERT(0);                                           =
          =20
>>>         }                                                            =
          =20
>>> #endif
>>> }
>>>
>>>
>>> There was an issue with the leaf checker being used in btrfs_mark_buf=
fer_dirty, Qu is this yet another instance of that ?
>>>
>>>> [   13.458466] ------------[ cut here ]------------
>>>> [   13.464054] kernel BUG at fs/btrfs/ctree.h:3457!
>>>> [   13.469655] invalid opcode: 0000 [#1] SMP
>>>> [   13.474609] Modules linked in: nouveau video ttm
>>>> [   13.480174] CPU: 2 PID: 79 Comm: kworker/u12:1 Tainted: G        =
W        4.15.0-rc1-debug-ubsan-00019-g1ff31238a542 #1
>>>> [   13.492026] Hardware name: System manufacturer System Product Nam=
e/M4A77T, BIOS 2401    05/18/2011
>>>> [   13.502055] Workqueue: btrfs-delalloc btrfs_delalloc_helper
>>>> [   13.508626] task: ffff880220110280 task.stack: ffffc900010bc000
>>>> [   13.515553] RIP: 0010:assfail.constprop.19+0x18/0x30
>>>> [   13.521512] RSP: 0018:ffffc900010bfa58 EFLAGS: 00010292
>>>> [   13.527739] RAX: 0000000000000039 RBX: ffff880221a223f8 RCX: 0000=
000000000000
>>>> [   13.535935] RDX: 0000000000000001 RSI: 0000000000000086 RDI: ffff=
ffff8378eb8c
>>>> [   13.544106] RBP: ffff88021dfa7800 R08: ffff880223eba800 R09: ffff=
8802202d9200
>>>> [   13.552276] R10: 0000000000001000 R11: 0000000000000000 R12: ffff=
880226246000
>>>> [   13.560446] R13: 00000000002625ed R14: ffffc900010bfaf0 R15: ffff=
c900010bfc78
>>>> [   13.568642] FS:  0000000000000000(0000) GS:ffff88022fc80000(0000)=
 knlGS:0000000000000000
>>>> [   13.577785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [   13.584521] CR2: 0000561bd0bcfe90 CR3: 0000000002609000 CR4: 0000=
0000000006e0
>>>> [   13.592717] Call Trace:
>>>> [   13.596166]  btrfs_mark_buffer_dirty+0x19c/0x290
>>>> [   13.601921]  setup_items_for_insert+0x231/0x5c0
>>>> [   13.607603]  __btrfs_drop_extents+0xc72/0x12d0
>>>> [   13.613165]  cow_file_range_inline.constprop.38+0x1f8/0xa50
>>>> [   13.619853]  ? btrfs_compress_pages+0xfe/0x200
>>>> [   13.625431]  compress_file_range.constprop.36+0x52a/0xaa0
>>>> [   13.631982]  ? ttwu_do_wakeup+0x2b/0x230
>>>> [   13.637008]  ? submit_compressed_extents+0x610/0x610
>>>> [   13.643078]  async_cow_start+0x33/0x70
>>>> [   13.647923]  normal_work_helper+0x88/0x3c0
>>>> [   13.653118]  process_one_work+0x21a/0x670
>>>> [   13.658223]  ? pwq_activate_delayed_work+0x5c/0x100
>>>> [   13.664194]  worker_thread+0x53/0x500
>>>> [   13.668936]  ? manage_workers+0x1e0/0x1e0
>>>> [   13.674019]  kthread+0x169/0x220
>>>> [   13.678301]  ? kthread_create_worker_on_cpu+0x40/0x40
>>>> [   13.684446]  ret_from_fork+0x1f/0x30
>>>> [   13.688998] Code: 00 00 31 c0 48 83 c4 28 5b 5d 41 5c 41 5d 41 5e=
 41 5f c3 89 f1 48 c7 c2 13 61 3e 82 48 89 fe 48 c7 c7 c0 2e 3e 82 e8 04 =
76 b4 ff <0f> 0b 48 c7 c7 d0 29 b1 82 e8 6a c0 2b 00 90 90 90 90 90 90 90=
=20
>>>> [   13.710797] RIP: assfail.constprop.19+0x18/0x30 RSP: ffffc900010b=
fa58
>>>> [   13.718372] ---[ end trace 5e6a02f9afd2bb3c ]---
>>>> [   13.874374] BTRFS info (device sdb1): enabling auto defrag
>>>> [   13.880974] BTRFS info (device sdb1): using free space tree
>>>> [   13.887613] BTRFS info (device sdb1): has skinny extents
>>>> [   86.768192] sysrq: SysRq : Emergency Sync
>>>> [   87.344192] sysrq: SysRq : Emergency Remount R/O
>>>> [   87.600191] sysrq: SysRq : Resetting
>>>>
>>>>
>>>> Meow!
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--JgAVxUUlMNKcOFGHALCL6pN5i41Td49ix--

--cECupRwBs3FrKlg6NuGCDnV0sLDiQUDxi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlodCjcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgCnwf/eU4rk1wfOdrJM9TfcfVAOsWK
J6C+JiHG03cjA/ZxpJyLingvfCqiQn0cOgm7burGfZ0e7Y/66bsw0sfvWuCp0hnb
PdQsU2TGUIXg2RTIwADgN1KgUVpdJda8YMCTRlRf50zpyfIzUtjpvYow+QNHiaRO
F3RWlhZ1xGGijkKY9Lc+b6KZAMUBQY2vMqK/Zh+fgTs0Z8vy0tgcgTtJTUBNzKXj
Ic1ISULbfeQYeSYHWqEx0SYs6ecN/MUjs3tTnchencEviDTCeVa34/t+QOJW9qgi
55CCqJeqSrxitxVK/SlBM7pUagL8XueCyW7791oE/rkhX1DJYNQIiFdXprZitw==
=ruPu
-----END PGP SIGNATURE-----

--cECupRwBs3FrKlg6NuGCDnV0sLDiQUDxi--
