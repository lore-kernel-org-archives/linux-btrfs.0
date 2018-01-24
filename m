Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36573 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932756AbeAXJSk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 04:18:40 -0500
Received: by mail-wm0-f51.google.com with SMTP id f3so7125937wmc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jan 2018 01:18:39 -0800 (PST)
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com>
 <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com>
From: Foo Bar <marcoep@gmail.com>
Message-ID: <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
Date: Wed, 24 Jan 2018 10:18:32 +0100
MIME-Version: 1.0
In-Reply-To: <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="UgHDlGxTzPAi3WXxyUIsRBwU8MRqEYy60"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UgHDlGxTzPAi3WXxyUIsRBwU8MRqEYy60
Content-Type: multipart/mixed; boundary="Qo11GKuNhzSb5xaArWjfpzlF1sFO0K76z";
 protected-headers="v1"
From: Foo Bar <marcoep@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com>
 <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com>
In-Reply-To: <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com>

--Qo11GKuNhzSb5xaArWjfpzlF1sFO0K76z
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Qu Wenruo wrote on 2018-01-24 09:49:
> Sorry for the late reply, I was off yesterday.
>

No problem :-)

Booted normally today, system up, but see this (I forgot to stop the snap=
shot
cron task...)

  [  115.127961] BTRFS error (device sdb3): Send: inconsistent snapshot, =
found
deleted reference for inode 30039323 without updated inode item, send roo=
t is
1399, parent root is 1385

So inode 30039323 looks definitely the bad one. Let's get rid of it and k=
eep
the newest dups, if any, thanks!

Cheers,

  Marco

> On 2018=E5=B9=B401=E6=9C=8822=E6=97=A5 23:04, ^m'e wrote:
>> Thanks for the quick reply, Qu!
>>
>> I forgot to say that I see weird characters in the btrfs check repair
>> in lines "ERROR: DIR_ITEM... name ..." output. Although that can be
>> due to corruption, I seem to remember that a previous version of
>> btrfs-progs I used didn't show that...
>> I also see:
>>
>>    [19428.934684] init_special_inode: bogus i_mode (700) for inode
>> sdb3:18446744073709551361
>>
>> BTW, no sensible names in the debug output, and as far as I can see,
>> it might be all stuff in '[rootfs]/usr/portage': if that's the case,
>> corrupted inodes can be safely removed, as the portage package tree
>> can be easily rebuild. Here you are:
>>
>> ---------------------------------->8----------------------------------=
---
>> # cat btrfs-debug.30039322.log[snip]
>=20
> This where the dir starts.
>=20
>>     item 78 key (30039322 INODE_ITEM 0) itemoff 4203 itemsize 160
>>         generation 136248 transid 229515 size 152 nbytes 0
>>         block group 0 mode 40755 links 1 uid 250 gid 250 rdev 0
>>         sequence 0 flags 0xf(none)
>>         atime 1504685599.188061317 (2017-09-06 08:13:19)
>>         ctime 1516557882.551679697 (2018-01-21 18:04:42)
>>         mtime 1516557882.551679697 (2018-01-21 18:04:42)
>>         otime 1504685599.188061317 (2017-09-06 08:13:19)
>>     item 79 key (30039322 INODE_REF 30037720) itemoff 4161 itemsize 42=

>>         index 242 namelen 32 name: obs-service-download_src_package
>>     item 80 key (30039322 DIR_ITEM 1076301169) itemoff 4083 itemsize 7=
8
>>         location key (30039325 INODE_ITEM 0) type FILE
>>         transid 136248 data_len 0 name_len 48
>>         name: obs-service-download_src_package-20130318.ebuild
>>     item 81 key (30039322 DIR_ITEM 2438219243) itemoff 4041 itemsize 4=
2
>>         location key (0 UNKNOWN.0 0) type FILE
>>         transid 136192 data_len 0 name_len 12
>>         name: metadata.xml
>>     item 82 key (30039322 DIR_ITEM 4007295565) itemoff 3927 itemsize 1=
14
>>         location key (0 UNKNOWN.0 0) type DIR_ITEM.0
>>         transid 0 data_len 0 name_len 0
>>         name:
>>         location key (0 UNKNOWN.125 72057594038112709) type DIR_ITEM.0=

>>         transid 0 data_len 32907 name_len 3
>>         name:
>>         data
>=20
> The whole item is corrupted.
> Seems to be a half-written item get flushed to disk.
>=20
> I assume this is the DIR_ITEM for *two* Manifest, but that's just
> insane, as we're going to have 2 files with the same name "Manifest"
>=20
>>     item 83 key (30039322 DIR_INDEX 2) itemoff 3889 itemsize 38
>>         location key (30039323 INODE_ITEM 0) type FILE
>>         transid 3377699720527872 data_len 0 name_len 8
>=20
> The transid seems corrupted too.
>=20
> Maybe I need to delete this item too?
>=20
>>     item 64 key (47302013 INODE_REF 30039322) itemoff 11278 itemsize 1=
8
>>         index 5 namelen 8 name: Manifest
>=20
> Now we do have 2 "Manifest".
>=20
> Which one do you prefer to delete?
>=20
> The latter one, inode 47302013 seems newer, while previous one, inode
> 30039323 is pretty old.
>=20
> Despite that, I didn't see big problem in the dump.
>=20
> I'll just craft the dirty fix to delete one inode and the incorrect dir=

> index/item.
>=20
> Thanks,
> Qu
>=20

--=20
              /\        /\
             /  \  _____)/ ____
             \/\/ /     \_/ __ \
                 |  Y Y  \  ___/
                 |__|_|  /\___  >
                       \/     \/
    VoIP-CH .. <0225085743@sip.netvoip.ch>
    VoIP-IT . <0683394229@voip.eutelia.it>
    VoIP-2 ........... <marcoep@ekiga.net>
    VoIP-3 .... <marcoep@sip.linphone.org>
    PSTN CH ............. +41 22 508 57 43
    PSTN IT ............. +39 06 8339 4229
    fax IT .............. +39 06 9838 1481


--Qo11GKuNhzSb5xaArWjfpzlF1sFO0K76z--

--UgHDlGxTzPAi3WXxyUIsRBwU8MRqEYy60
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQSlw1wbkxaFBDeIxXyuA5jWaaoJ0AUCWmhPbAAKCRCuA5jWaaoJ
0OpmAJ9MjsPXquye0T0MyiCNvhDDXPAXnACfXh81ALHz1vx5bw4NqNTyKIAwpcE=
=D7hf
-----END PGP SIGNATURE-----

--UgHDlGxTzPAi3WXxyUIsRBwU8MRqEYy60--
