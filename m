Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62190 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932265AbeAXIt1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 03:49:27 -0500
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: "^m'e" <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com>
 <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com>
Date: Wed, 24 Jan 2018 16:49:20 +0800
MIME-Version: 1.0
In-Reply-To: <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1ephrlndrWgDpd1W5eyLEB2bB2ZLRmH93"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1ephrlndrWgDpd1W5eyLEB2bB2ZLRmH93
Content-Type: multipart/mixed; boundary="zoAJqiFraAuOBqY89smeKq50YOCPMUfwz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ^m'e <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com>
 <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
In-Reply-To: <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>

--zoAJqiFraAuOBqY89smeKq50YOCPMUfwz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Sorry for the late reply, I was off yesterday.

On 2018=E5=B9=B401=E6=9C=8822=E6=97=A5 23:04, ^m'e wrote:
> Thanks for the quick reply, Qu!
>=20
> I forgot to say that I see weird characters in the btrfs check repair
> in lines "ERROR: DIR_ITEM... name ..." output. Although that can be
> due to corruption, I seem to remember that a previous version of
> btrfs-progs I used didn't show that...
> I also see:
>=20
>    [19428.934684] init_special_inode: bogus i_mode (700) for inode
> sdb3:18446744073709551361
>=20
> BTW, no sensible names in the debug output, and as far as I can see,
> it might be all stuff in '[rootfs]/usr/portage': if that's the case,
> corrupted inodes can be safely removed, as the portage package tree
> can be easily rebuild. Here you are:
>=20
> ---------------------------------->8-----------------------------------=
--
> # cat btrfs-debug.30039322.log[snip]

This where the dir starts.

>     item 78 key (30039322 INODE_ITEM 0) itemoff 4203 itemsize 160
>         generation 136248 transid 229515 size 152 nbytes 0
>         block group 0 mode 40755 links 1 uid 250 gid 250 rdev 0
>         sequence 0 flags 0xf(none)
>         atime 1504685599.188061317 (2017-09-06 08:13:19)
>         ctime 1516557882.551679697 (2018-01-21 18:04:42)
>         mtime 1516557882.551679697 (2018-01-21 18:04:42)
>         otime 1504685599.188061317 (2017-09-06 08:13:19)
>     item 79 key (30039322 INODE_REF 30037720) itemoff 4161 itemsize 42
>         index 242 namelen 32 name: obs-service-download_src_package
>     item 80 key (30039322 DIR_ITEM 1076301169) itemoff 4083 itemsize 78=

>         location key (30039325 INODE_ITEM 0) type FILE
>         transid 136248 data_len 0 name_len 48
>         name: obs-service-download_src_package-20130318.ebuild
>     item 81 key (30039322 DIR_ITEM 2438219243) itemoff 4041 itemsize 42=

>         location key (0 UNKNOWN.0 0) type FILE
>         transid 136192 data_len 0 name_len 12
>         name: metadata.xml
>     item 82 key (30039322 DIR_ITEM 4007295565) itemoff 3927 itemsize 11=
4
>         location key (0 UNKNOWN.0 0) type DIR_ITEM.0
>         transid 0 data_len 0 name_len 0
>         name:
>         location key (0 UNKNOWN.125 72057594038112709) type DIR_ITEM.0
>         transid 0 data_len 32907 name_len 3
>         name:
>         data

The whole item is corrupted.
Seems to be a half-written item get flushed to disk.

I assume this is the DIR_ITEM for *two* Manifest, but that's just
insane, as we're going to have 2 files with the same name "Manifest"

>     item 83 key (30039322 DIR_INDEX 2) itemoff 3889 itemsize 38
>         location key (30039323 INODE_ITEM 0) type FILE
>         transid 3377699720527872 data_len 0 name_len 8

The transid seems corrupted too.

Maybe I need to delete this item too?

>         name: Manifest
>     item 84 key (30039322 DIR_INDEX 3) itemoff 3847 itemsize 42
>         location key (30039324 INODE_ITEM 0) type FILE
>         transid 136248 data_len 0 name_len 12
>         name: metadata.xml
>     item 85 key (30039322 DIR_INDEX 4) itemoff 3769 itemsize 78
>         location key (30039325 INODE_ITEM 0) type FILE
>         transid 136248 data_len 0 name_len 48
>         name: obs-service-download_src_package-20130318.ebuild
>     item 86 key (30039322 DIR_INDEX 5) itemoff 3731 itemsize 38
>         location key (47302013 INODE_ITEM 0) type FILE
>         transid 229515 data_len 0 name_len 8
>         name: Manifest
>     item 87 key (30039323 INODE_ITEM 0) itemoff 3571 itemsize 160
>         generation 136248 transid 202216 size 782 nbytes 782
>         block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
>         sequence 0 flags 0xb(none)
>         atime 1504685599.188061317 (2017-09-06 08:13:19)
>         ctime 1512818139.540278499 (2017-12-09 11:15:39)
>         mtime 1504685599.188061317 (2017-09-06 08:13:19)
>         otime 1504685599.188061317 (2017-09-06 08:13:19)
>     item 88 key (30039323 INODE_REF 30039322) itemoff 3553 itemsize 18
>         index 2 namelen 8 name: Manifest
>     item 89 key (30039323 EXTENT_DATA 0) itemoff 2750 itemsize 803
>         generation 136248 type 0 (inline)
>         inline extent data size 782 ram_bytes 782 compression 0 (none)
>     item 90 key (30039324 INODE_ITEM 0) itemoff 2590 itemsize 160
>         generation 136248 transid 202216 size 448 nbytes 448
>         block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
>         sequence 0 flags 0xb(none)
>         atime 1504685599.188061317 (2017-09-06 08:13:19)
>         ctime 1512818139.540278499 (2017-12-09 11:15:39)
>         mtime 1504685599.188061317 (2017-09-06 08:13:19)
>         otime 1504685599.188061317 (2017-09-06 08:13:19)
>     item 91 key (30039324 INODE_REF 30039322) itemoff 2568 itemsize 22
>         index 3 namelen 12 name: metadata.xml
> leaf 36701356032 items 44 free space 8701 generation 202216 owner 257
> leaf 36701356032 flags 0x1(WRITTEN) backref revision 1
> fs uuid de1723e2-150c-4448-bb36-be14d7d96093
> chunk uuid 443a227c-4f87-419a-b89a-3f5714eea403
>     item 0 key (30039324 EXTENT_DATA 0) itemoff 15814 itemsize 469
>         generation 136248 type 0 (inline)
>         inline extent data size 448 ram_bytes 448 compression 0 (none)
>     item 1 key (30039325 INODE_ITEM 0) itemoff 15654 itemsize 160
>         generation 136248 transid 202216 size 213 nbytes 213
>         block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
>         sequence 0 flags 0xb(none)
>         atime 1504685599.188061317 (2017-09-06 08:13:19)
>         ctime 1512818139.540278499 (2017-12-09 11:15:39)
>         mtime 1504685599.188061317 (2017-09-06 08:13:19)
>         otime 1504685599.188061317 (2017-09-06 08:13:19)
>     item 2 key (30039325 INODE_REF 30039322) itemoff 15596 itemsize 58
>         index 4 namelen 48 name:
> obs-service-download_src_package-20130318.ebuild
>     item 3 key (30039325 EXTENT_DATA 0) itemoff 15362 itemsize 234
>         generation 136248 type 0 (inline)
>         inline extent data size 213 ram_bytes 213 compression 0 (none)
>     item 4 key (30039326 INODE_ITEM 0) itemoff 15202 itemsize 160
>         generation 136248 transid 202216 size 120 nbytes 0
>         block group 0 mode 40755 links 1 uid 250 gid 250 rdev 0
>         sequence 0 flags 0xe(none)
>         atime 1504685599.188061317 (2017-09-06 08:13:19)
>         ctime 1512818139.541278502 (2017-12-09 11:15:39)
>         mtime 1504685599.188061317 (2017-09-06 08:13:19)
>         otime 1504685599.188061317 (2017-09-06 08:13:19)
>     item 5 key (30039326 INODE_REF 30037720) itemoff 15168 itemsize 34
>         index 243 namelen 24 name: obs-service-download_url
>     item 6 key (30039326 DIR_ITEM 1441374077) itemoff 15098 itemsize 70=

>         location key (30039329 INODE_ITEM 0) type FILE
>         transid 136248 data_len 0 name_len 40
>         name: obs-service-download_url-20130318.ebuild
>     item 7 key (30039326 DIR_ITEM 2438219243) itemoff 15056 itemsize 42=

>         location key (30039328 INODE_ITEM 0) type FILE
> --
>         generation 229515 transid 229515 size 26 nbytes 26
>         block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
>         sequence 0 flags 0x2(none)
>         atime 1516557882.505679580 (2018-01-21 18:04:42)
>         ctime 1516557882.505679580 (2018-01-21 18:04:42)
>         mtime 1516557882.505679580 (2018-01-21 18:04:42)
>         otime 1516557882.505679580 (2018-01-21 18:04:42)
>     item 61 key (47302010 INODE_REF 30002892) itemoff 11503 itemsize 14=

>         index 1798 namelen 4 name: HEAD
>     item 62 key (47302010 EXTENT_DATA 0) itemoff 11456 itemsize 47
>         generation 229515 type 0 (inline)
>         inline extent data size 26 ram_bytes 26 compression 0 (none)
>     item 63 key (47302013 INODE_ITEM 0) itemoff 11296 itemsize 160
>         generation 229515 transid 229516 size 782 nbytes 782
>         block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
>         sequence 0 flags 0x0(none)
>         atime 1516557882.551679697 (2018-01-21 18:04:42)
>         ctime 1516557882.551679697 (2018-01-21 18:04:42)
>         mtime 1516557882.551679697 (2018-01-21 18:04:42)
>         otime 1516557882.551679697 (2018-01-21 18:04:42)
>     item 64 key (47302013 INODE_REF 30039322) itemoff 11278 itemsize 18=

>         index 5 namelen 8 name: Manifest

Now we do have 2 "Manifest".

Which one do you prefer to delete?

The latter one, inode 47302013 seems newer, while previous one, inode
30039323 is pretty old.

Despite that, I didn't see big problem in the dump.

I'll just craft the dirty fix to delete one inode and the incorrect dir
index/item.

Thanks,
Qu

> leaf 186518913024 items 86 free space 3119 generation 229516 owner 257
> leaf 186518913024 flags 0x1(WRITTEN) backref revision 1
> fs uuid de1723e2-150c-4448-bb36-be14d7d96093
> chunk uuid 443a227c-4f87-419a-b89a-3f5714eea403
>     item 0 key (47302013 EXTENT_DATA 0) itemoff 15480 itemsize 803
>         generation 229516 type 0 (inline)
>         inline extent data size 782 ram_bytes 782 compression 0 (none)
>     item 1 key (47302018 INODE_ITEM 0) itemoff 15320 itemsize 160
>         generation 229515 transid 229515 size 41 nbytes 41
>         block group 0 mode 100644 links 1 uid 250 gid 250 rdev 0
>         sequence 0 flags 0x2(none)
>         atime 1516557883.180681304 (2018-01-21 18:04:43)
>         ctime 1516557883.180681304 (2018-01-21 18:04:43)
>         mtime 1516557883.180681304 (2018-01-21 18:04:43)
>         otime 1516557883.180681304 (2018-01-21 18:04:43)
>     item 2 key (47302018 INODE_REF 30002892) itemoff 15301 itemsize 19
>         index 1801 namelen 9 name: ORIG_HEAD
>     item 3 key (47302018 EXTENT_DATA 0) itemoff 15239 itemsize 62
>         generation 229515 type 0 (inline)
> ---------------------------------->8-----------------------------------=
--
>=20


--zoAJqiFraAuOBqY89smeKq50YOCPMUfwz--

--1ephrlndrWgDpd1W5eyLEB2bB2ZLRmH93
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpoSJAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgA3gf+MJMF80a0YqPH2FiigPIb/NSv
DGwrLif7HK95VzpGl5NOxSG1bi6I/kXi5Lm9did1yOkEpwQTvv78wogCxOdeLhps
U7E0F2u/ekG798y5G1xJFV3hFv2qZ7672weLsFte1ttP+IyKACGcgTKA+LNwhNzD
Wce5CNehw9wQY/FQJHpSYosKbN9xxLysRcyBfSkH9EJEtqR/19NoPrtWyPkG1Ggc
8dbcAjlUaGvmB7B2ujV7yBTP4RhA0V8ypAcWTykuuTWBcxS0to0LdWF24y1FdQVF
BeuGLJoHz9rebkNlDNieIUii4WxSXOHIYMUAojMrEnqwcH4+KP6hL5cMPVEpVA==
=5rH6
-----END PGP SIGNATURE-----

--1ephrlndrWgDpd1W5eyLEB2bB2ZLRmH93--
