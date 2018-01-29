Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49960 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753655AbeA2Bef (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Jan 2018 20:34:35 -0500
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: "^m'e" <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
 <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com>
 <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
 <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
 <6d5bfa3f-3c49-1380-2bcf-d6eeca57020a@gmx.com>
 <CAAxOLF_wRCxgebwXUy7A5AqKtKchGLz46DKNiM-iPejVpfjbFg@mail.gmail.com>
 <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com>
 <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
 <80321b99-a89c-fadf-8f1a-26ed8f598a66@gmx.com>
 <CAAxOLF9wYwUzT_AAx1Wa12XyCwACo7vp021BytHn-VaANC--=Q@mail.gmail.com>
 <802534f4-55cd-8404-5c21-4f383468c7e5@gmx.com>
 <CAAxOLF9_N0zEhED9ZQfitcNu8j=8krYbWAYNqr271o_LnMKfmw@mail.gmail.com>
 <1e6c6814-d120-144b-bed7-c1dac0d140d3@gmx.com>
 <CAAxOLF-sp1nbhbBu7TeNwfvjwRuX9i7QrRGx3Jbm=wh1n+2zQA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <365e746e-de87-2977-daee-7b2335c545b1@gmx.com>
Date: Mon, 29 Jan 2018 09:34:28 +0800
MIME-Version: 1.0
In-Reply-To: <CAAxOLF-sp1nbhbBu7TeNwfvjwRuX9i7QrRGx3Jbm=wh1n+2zQA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ABPRjByFdulKYCzAjrPLtXNR80eEta7gm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ABPRjByFdulKYCzAjrPLtXNR80eEta7gm
Content-Type: multipart/mixed; boundary="Qnefuqh9lbe58wXwyVetKwUpddlt6WmJl";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ^m'e <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <365e746e-de87-2977-daee-7b2335c545b1@gmx.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
 <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com>
 <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
 <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com>
 <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
 <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
 <6d5bfa3f-3c49-1380-2bcf-d6eeca57020a@gmx.com>
 <CAAxOLF_wRCxgebwXUy7A5AqKtKchGLz46DKNiM-iPejVpfjbFg@mail.gmail.com>
 <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com>
 <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
 <80321b99-a89c-fadf-8f1a-26ed8f598a66@gmx.com>
 <CAAxOLF9wYwUzT_AAx1Wa12XyCwACo7vp021BytHn-VaANC--=Q@mail.gmail.com>
 <802534f4-55cd-8404-5c21-4f383468c7e5@gmx.com>
 <CAAxOLF9_N0zEhED9ZQfitcNu8j=8krYbWAYNqr271o_LnMKfmw@mail.gmail.com>
 <1e6c6814-d120-144b-bed7-c1dac0d140d3@gmx.com>
 <CAAxOLF-sp1nbhbBu7TeNwfvjwRuX9i7QrRGx3Jbm=wh1n+2zQA@mail.gmail.com>
In-Reply-To: <CAAxOLF-sp1nbhbBu7TeNwfvjwRuX9i7QrRGx3Jbm=wh1n+2zQA@mail.gmail.com>

--Qnefuqh9lbe58wXwyVetKwUpddlt6WmJl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 23:15, ^m'e wrote:
> On Fri, Jan 26, 2018 at 12:16 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>> Branch updated, problem in 1399 should be fixed.
>>
>> Seems the remaining problems are less and less now.
>>
>> Thanks,
>> Qu
>>
>=20
> Great! The fix worked, and repair goes throught at last :-) though
> we're still left with some inconsistencies at check:
> (1st run)
> -----------------------------------------------------------------------=
---
> checking fs roots
> ERROR: root 1385 INODE[30039323] is orphan item
> ERROR: root 1385 INODE[18446744073709551361] is orphan item
> ERROR: root 1399 DIR INODE [30039322] size 99 not equal to 96

As you could see, dir isize can be fixed by both repair mode.
(Just in case, lowmem mode also supports repair)

> ERROR: root 1399 INODE[18446744073709551361] is orphan item
> ERROR: errors found in fs roots
> ...
> -----------------------------------------------------------------------=
---
>=20
> repair (1st run)
> -----------------------------------------------------------------------=
---
> Fixed 0 roots.
> checking extents
> checking free space cache
> checking fs roots
> warning line 4682
> checking csums
> checking root refs
> enabling repair mode
> Checking filesystem on /dev/sdb3
> UUID: de1723e2-150c-4448-bb36-be14d7d96093
> No device size related problem found
> cache and super generation don't match, space cache will be invalidated=

> reset isize for dir 30039322 root 1399
> found 104509362176 bytes used, no error found
> total csum bytes: 99690492
> total tree bytes: 2394259456
> total fs tree bytes: 2173468672
> total extent tree bytes: 87900160
> btree space waste bytes: 574264314
> file data blocks allocated: 190189735936
>  referenced 150679924736
> -----------------------------------------------------------------------=
---
>=20
> check (2nd run)
> -----------------------------------------------------------------------=
---
> checking fs roots
> ERROR: root 1385 INODE[30039323] is orphan item
> ERROR: root 1385 INODE[18446744073709551361] is orphan item
> ERROR: root 1399 INODE[18446744073709551361] is orphan item

I'm not sure if the orphan item report is necessary for lowmem mode.

IIRC orphan item is completely valid.

I'll dig it further to fit it.

> ERROR: errors found in fs roots
> Checking filesystem on /dev/sdb3
> UUID: de1723e2-150c-4448-bb36-be14d7d96093
> cache and super generation don't match, space cache will be invalidated=

> found 104509362176 bytes used, error(s) found
> total csum bytes: 99690492
> total tree bytes: 14561427456
> total fs tree bytes: 14340636672
> total extent tree bytes: 87900160
> btree space waste bytes: 3163391144
> file data blocks allocated: 362059718656
>  referenced 315586768896
> -----------------------------------------------------------------------=
---
>=20
> repair (2nd run)
> -----------------------------------------------------------------------=
---
> Fixed 0 roots.
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> enabling repair mode
> Checking filesystem on /dev/sdb3
> UUID: de1723e2-150c-4448-bb36-be14d7d96093
> No device size related problem found
> cache and super generation don't match, space cache will be invalidated=

> found 104509362176 bytes used, no error found
> total csum bytes: 99690492
> total tree bytes: 2394259456
> total fs tree bytes: 2173468672
> total extent tree bytes: 87900160
> btree space waste bytes: 574264314
> file data blocks allocated: 190189735936
>  referenced 150679924736
> -----------------------------------------------------------------------=
---
>=20
> It looks like it didn't detect anything bad...
> As a side note, check in "original" mode doesn't detect the issues as
> in runs reported above.
>=20
> Debugging:
> -----------------------------------------------------------------------=
---
> # ./btrfs.static inspect dump-tree -t 1385 /dev/sdb3 | grep -C 20
> 18446744073709551361
>     item 45 key (47329988 INODE_REF 256) itemoff 9768 itemsize 20
>         index 28 namelen 10 name: lost+found
>     item 46 key (47329988 DIR_ITEM 2438219243) itemoff 9726 itemsize 42=

>         location key (30039324 INODE_ITEM 0) type FILE
>         transid 0 data_len 0 name_len 12
>         name: metadata.xml
>     item 47 key (47329988 DIR_INDEX 2) itemoff 9684 itemsize 42
>         location key (30039324 INODE_ITEM 0) type FILE
>         transid 0 data_len 0 name_len 12
>         name: metadata.xml
>     item 48 key (MULTIPLE INODE_ITEM 0) itemoff 9524 itemsize 160
>         generation 461639 transid 0 size 0 nbytes 0
>         block group 0 mode 100700 links 0 uid 0 gid 0 rdev 0
>         sequence 0 flags 0x0(none)
>         atime 1516888573.0 (2018-01-25 13:56:13)
>         ctime 1516888573.0 (2018-01-25 13:56:13)
>         mtime 1516888573.0 (2018-01-25 13:56:13)
>         otime 0.0 (1970-01-01 00:00:00)
>     item 49 key (ORPHAN ORPHAN_ITEM 30039323) itemoff 9524 itemsize 0
>         orphan item
>     item 50 key (ORPHAN ORPHAN_ITEM 18446744073709551361) itemoff 9524
> itemsize 0
>         orphan item

At least for me (and original mode), it's seems valid.

Please try mount the fs, and do some write, then sync the fs, and
finally umount it.

If everything goes as planned, the ORPHAN things will just be gone and
no more lowmem mode errors.

Thanks,
Qu

> total bytes 247335313408
> bytes used 104509362176
> uuid de1723e2-150c-4448-bb36-be14d7d96093
> -----------------------------------------------------------------------=
---
>=20
> -----------------------------------------------------------------------=
---
> # ./btrfs.static inspect dump-tree -t 1399 /dev/sdb3 | grep -C 20
> 18446744073709551361
>     item 17 key (47343871 INODE_REF 6928733) itemoff 13096 itemsize 21
>         index 2746 namelen 11 name: cron.hourly
>     item 18 key (47343872 INODE_ITEM 0) itemoff 12936 itemsize 160
>         generation 460550 transid 460550 size 0 nbytes 0
>         block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
>         sequence 0 flags 0x1(none)
>         atime 1516784116.26956368 (2018-01-24 08:55:16)
>         ctime 1516784116.26956368 (2018-01-24 08:55:16)
>         mtime 1516784116.26956368 (2018-01-24 08:55:16)
>         otime 1516784116.26956368 (2018-01-24 08:55:16)
>     item 19 key (47343872 INODE_REF 6928733) itemoff 12916 itemsize 20
>         index 2747 namelen 10 name: cron.daily
>     item 20 key (MULTIPLE INODE_ITEM 0) itemoff 12756 itemsize 160
>         generation 461641 transid 0 size 0 nbytes 0
>         block group 0 mode 700 links 0 uid 0 gid 0 rdev 0
>         sequence 0 flags 0x0(none)
>         atime 1516888641.0 (2018-01-25 13:57:21)
>         ctime 1516888641.0 (2018-01-25 13:57:21)
>         mtime 1516888641.0 (2018-01-25 13:57:21)
>         otime 0.0 (1970-01-01 00:00:00)
>     item 21 key (ORPHAN ORPHAN_ITEM 18446744073709551361) itemoff
> 12756 itemsize 0
>         orphan item
> total bytes 247335313408
> bytes used 104509362176
> uuid de1723e2-150c-4448-bb36-be14d7d96093
> -----------------------------------------------------------------------=
---
>=20
> -----------------------------------------------------------------------=
---
> # ./btrfs.static inspect dump-tree -t 1385 /dev/sdb3 | grep -C 20 30039=
323
>         mtime 1516557882.551679697 (2018-01-21 18:04:42)
>         otime 1504685599.188061317 (2017-09-06 08:13:19)
>     item 79 key (30039322 INODE_REF 30037720) itemoff 4161 itemsize 42
>         index 242 namelen 32 name: obs-service-download_src_package
>     item 80 key (30039322 DIR_ITEM 1076301169) itemoff 4083 itemsize 78=

>         location key (30039325 INODE_ITEM 0) type FILE
>         transid 136248 data_len 0 name_len 48
>         name: obs-service-download_src_package-20130318.ebuild
>     item 81 key (30039322 DIR_ITEM 4007295565) itemoff 4045 itemsize 38=

>         location key (47302013 INODE_ITEM 0) type FILE
>         transid 3377699720527872 data_len 0 name_len 8
>         name: Manifest
>     item 82 key (30039322 DIR_INDEX 4) itemoff 3967 itemsize 78
>         location key (30039325 INODE_ITEM 0) type FILE
>         transid 136248 data_len 0 name_len 48
>         name: obs-service-download_src_package-20130318.ebuild
>     item 83 key (30039322 DIR_INDEX 5) itemoff 3929 itemsize 38
>         location key (47302013 INODE_ITEM 0) type FILE
>         transid 3861419965563273305 data_len 0 name_len 8
>         name: Manifest
>     item 84 key (30039323 INODE_ITEM 0) itemoff 3769 itemsize 160
>         generation 136248 transid 202216 size 782 nbytes 782
>         block group 0 mode 100644 links 0 uid 250 gid 250 rdev 0
>         sequence 0 flags 0xb(none)
>         atime 1504685599.188061317 (2017-09-06 08:13:19)
>         ctime 1512818139.540278499 (2017-12-09 11:15:39)
>         mtime 1504685599.188061317 (2017-09-06 08:13:19)
>         otime 1504685599.188061317 (2017-09-06 08:13:19)
>     item 85 key (30039323 EXTENT_DATA 0) itemoff 2966 itemsize 803
>         generation 136248 type 0 (inline)
>         inline extent data size 782 ram_bytes 782 compression 0 (none)
>     item 86 key (30039324 INODE_ITEM 0) itemoff 2806 itemsize 160
>         generation 136248 transid 202216 size 448 nbytes 448
>         block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
>         sequence 0 flags 0xb(none)
>         atime 1504685599.188061317 (2017-09-06 08:13:19)
>         ctime 1512818139.540278499 (2017-12-09 11:15:39)
>         mtime 1504685599.188061317 (2017-09-06 08:13:19)
>         otime 1504685599.188061317 (2017-09-06 08:13:19)
>     item 87 key (30039324 INODE_REF 47329988) itemoff 2784 itemsize 22
>         index 2 namelen 12 name: metadata.xml
> leaf 36701356032 items 44 free space 8701 generation 202216 owner 257
> leaf 36701356032 flags 0x1(WRITTEN) backref revision 1
> fs uuid de1723e2-150c-4448-bb36-be14d7d96093
> chunk uuid 443a227c-4f87-419a-b89a-3f5714eea403
>     item 0 key (30039324 EXTENT_DATA 0) itemoff 15814 itemsize 469
>         generation 136248 type 0 (inline)
>         inline extent data size 448 ram_bytes 448 compression 0 (none)
>     item 1 key (30039325 INODE_ITEM 0) itemoff 15654 itemsize 160
> --
>         mtime 1516888573.0 (2018-01-25 13:56:13)
>         otime 0.0 (1970-01-01 00:00:00)
>     item 45 key (47329988 INODE_REF 256) itemoff 9768 itemsize 20
>         index 28 namelen 10 name: lost+found
>     item 46 key (47329988 DIR_ITEM 2438219243) itemoff 9726 itemsize 42=

>         location key (30039324 INODE_ITEM 0) type FILE
>         transid 0 data_len 0 name_len 12
>         name: metadata.xml
>     item 47 key (47329988 DIR_INDEX 2) itemoff 9684 itemsize 42
>         location key (30039324 INODE_ITEM 0) type FILE
>         transid 0 data_len 0 name_len 12
>         name: metadata.xml
>     item 48 key (MULTIPLE INODE_ITEM 0) itemoff 9524 itemsize 160
>         generation 461639 transid 0 size 0 nbytes 0
>         block group 0 mode 100700 links 0 uid 0 gid 0 rdev 0
>         sequence 0 flags 0x0(none)
>         atime 1516888573.0 (2018-01-25 13:56:13)
>         ctime 1516888573.0 (2018-01-25 13:56:13)
>         mtime 1516888573.0 (2018-01-25 13:56:13)
>         otime 0.0 (1970-01-01 00:00:00)
>     item 49 key (ORPHAN ORPHAN_ITEM 30039323) itemoff 9524 itemsize 0
>         orphan item
>     item 50 key (ORPHAN ORPHAN_ITEM 18446744073709551361) itemoff 9524
> itemsize 0
>         orphan item
> total bytes 247335313408
> bytes used 104509362176
> uuid de1723e2-150c-4448-bb36-be14d7d96093
> -----------------------------------------------------------------------=
---
>=20
> Cheers,
>=20
>    Marco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Qnefuqh9lbe58wXwyVetKwUpddlt6WmJl--

--ABPRjByFdulKYCzAjrPLtXNR80eEta7gm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpueiUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh3gAf/eDUja9qMeyjtZ2acBbJKYJjy
+s7U5VlzURhNk6MOh3tBYT65LxJqrzRZh1CZLTxgbUxtK0f+TeeYFsDlXWk8OgLp
WRXfzel3fmUGUhBDtPVvKC6hOZNdSfwTIHzQ9U7+8x4v6QogliaWrWebkA+qEalP
Ik2fi+q70bDP5DA7YVSn+w3oYjfd50gaQax5fzemxK7GSOpo8AXFPau/NmFQzRNo
fnWFvqm5VKj//gNka+AjVXQ5mIzIv3p1AdixpCOUDomRUtTFABy6bAAlyUDOPfGb
Eqoh2PPiw4sYkyGmaSjNvzIaUGo+CneNPbUYZs3SRK7LU71K/qd+bUSIOgcsIA==
=PFMv
-----END PGP SIGNATURE-----

--ABPRjByFdulKYCzAjrPLtXNR80eEta7gm--
