Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:64175 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750854AbdLaBAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Dec 2017 20:00:36 -0500
Subject: Re: Hand Patching a BTRFS Superblock?
To: swestrup@gmail.com
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
 <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
 <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
 <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com>
 <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>
 <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com>
 <CAJt7KB8OcRWE0=MUcA+tXgSYUr_=2RXsWTZcdEjhuN1agqh_nw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <17d329d2-5881-b3ab-70e7-2a95234ddcf5@gmx.com>
Date: Sun, 31 Dec 2017 09:00:27 +0800
MIME-Version: 1.0
In-Reply-To: <CAJt7KB8OcRWE0=MUcA+tXgSYUr_=2RXsWTZcdEjhuN1agqh_nw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="r8NBwXX5AEq0Ne5eG8kZvlt8xQS5YmUJo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r8NBwXX5AEq0Ne5eG8kZvlt8xQS5YmUJo
Content-Type: multipart/mixed; boundary="lV1weSd2HQ6a7wEYlpFyUZ6I8rgedGG8L";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: swestrup@gmail.com
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <17d329d2-5881-b3ab-70e7-2a95234ddcf5@gmx.com>
Subject: Re: Hand Patching a BTRFS Superblock?
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
 <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com>
 <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
 <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com>
 <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>
 <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com>
 <CAJt7KB8OcRWE0=MUcA+tXgSYUr_=2RXsWTZcdEjhuN1agqh_nw@mail.gmail.com>
In-Reply-To: <CAJt7KB8OcRWE0=MUcA+tXgSYUr_=2RXsWTZcdEjhuN1agqh_nw@mail.gmail.com>

--lV1weSd2HQ6a7wEYlpFyUZ6I8rgedGG8L
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8831=E6=97=A5 03:54, Stirling Westrup wrote:
> Okay, so I've gone back to your earlier suggestion of dumping the
> chunk tree to get info for rebuiling a superblock by hand, but its not
> working.
>=20
> /usr/local/bin/btrfs ins dump-tree -t chunk /dev/sdc
> btrfs-progs v4.14
> bytenr mismatch, want=3D294191104, have=3D314114048
> Couldn't read tree root
> ERROR: unable to open /dev/sdc
>=20
> I get the exact same error (except for device name) for every valid
> device in the FS.

The system is more damaged than your expectation.

Tree root is also corrupted.

Although I could make dump-tree to skip root tree, but even with hand
crafted super, the corrupted tree root is still a big problem.

Thanks,
Qu

>=20
>=20
>=20
> On Thu, Dec 28, 2017 at 9:08 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>>
>> Yes, this means you could get the needed device UUID and hand craft a
>> superblock.
>> But I really doubt about the possibility to success.
>>
>> If you really want to do that, there is needed steps for you:
>>
>> 1) Get device info from your existing fs
>>    # btrfs ins dump-tree -t chunk </dev/sda>
>>    And looking for the following thing:
>> ------
>>        item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16185 itemsize 98
>>                 devid 2 total_bytes 10737418240 bytes_used 289406976
>>                 io_align 4096 io_width 4096 sector_size 4096 type 0
>>                 generation 0 start_offset 0 dev_group 0
>>                 seek_speed 0 bandwidth 0
>>                 uuid f1d9b288-7865-463f-a65c-ca8b1fbde09b
>>                 fsid 1dd513fb-45f8-404f-ae23-979e3acb78ad
>> ------
>>    Look for the key (DEV_ITEMS DEV_ITEM 2) and grab the "uuid"
>>    "total_bytes" "bytes_used" (other fields are mostly fixed)
>>
>> 2) Fill the fields of dev_item of a good superblock.
>>    If you feel it hard, I could help to do it if you provide the binar=
y
>>    dump of any valid superblock, with above tree dump info.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--lV1weSd2HQ6a7wEYlpFyUZ6I8rgedGG8L--

--r8NBwXX5AEq0Ne5eG8kZvlt8xQS5YmUJo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpINqsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiyqwf/fpNAPfaxIXHzoey8inZbsJ1W
/ZbSp6GEoMAkJH/SCRsqDzWiWygtg14mol18Ft6pnqt1TxFeUXLUwTP+XkV+J/VI
OIPacQmCe9NyQx39B2oC6ka0+RyfiCCTsTHAHUNWGMQM+3Tfn12zPynMHl0kPvOz
HZRRfUd4xliTRsjeECrSmd5p1APcbPi2KO6mdKV+HL8H/d5VVyXQxLiXCmS3zTi0
WRrejydSZE4PsZe881Itlg9a6MCo157DWTJ+kBojGdZFEttilFiRscJhXfNkmRF4
xSWPrfRGYUhN5fVavmSO8G1U/HTUI28nBgg+WqbhSskbvx0glMRitDOf9i16iQ==
=5PCD
-----END PGP SIGNATURE-----

--r8NBwXX5AEq0Ne5eG8kZvlt8xQS5YmUJo--
