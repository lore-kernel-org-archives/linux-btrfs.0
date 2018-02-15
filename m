Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:44349 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032245AbeBOBmo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 20:42:44 -0500
Subject: Re: Status of FST and mount times
To: Nikolay Borisov <nborisov@suse.com>,
        "Ellis H. Wilson III" <ellisw@panasas.com>,
        linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
Date: Thu, 15 Feb 2018 09:42:27 +0800
MIME-Version: 1.0
In-Reply-To: <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GLkAllR7Blrh6IE8TZgL621wYHzVYT5w3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GLkAllR7Blrh6IE8TZgL621wYHzVYT5w3
Content-Type: multipart/mixed; boundary="AM93RgscuHnAkQFhqmGVO2OF9YSaamkPE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>,
 "Ellis H. Wilson III" <ellisw@panasas.com>, linux-btrfs@vger.kernel.org
Message-ID: <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
Subject: Re: Status of FST and mount times
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
In-Reply-To: <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>

--AM93RgscuHnAkQFhqmGVO2OF9YSaamkPE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8815=E6=97=A5 01:08, Nikolay Borisov wrote:
>=20
>=20
> On 14.02.2018 18:00, Ellis H. Wilson III wrote:
>> Hi again -- back with a few more questions:
>>
>> Frame-of-reference here: RAID0.=C2=A0 Around 70TB raw capacity.=C2=A0 =
No
>> compression.=C2=A0 No quotas enabled.=C2=A0 Many (potentially tens to =
hundreds) of
>> subvolumes, each with tens of snapshots.=C2=A0 No control over size or=
 number
>> of files, but directory tree (entries per dir and general tree depth)
>> can be controlled in case that's helpful).
>>
>> 1. I've been reading up about the space cache, and it appears there is=
 a
>> v2 of it called the free space tree that is much friendlier to large
>> filesystems such as the one I am designing for.=C2=A0 It is listed as =
OK/OK
>> on the wiki status page, but there is a note that btrfs progs treats i=
t
>> as read only (i.e., btrfs check repair cannot help me without a full
>> space cache rebuild is my biggest concern) and the last status update =
on
>> this I can find was circa fall 2016.=C2=A0 Can anybody give me an upda=
ted
>> status on this feature?=C2=A0 From what I read, v1 and tens of TB file=
systems
>> will not play well together, so I'm inclined to dig into this.
>=20
> V1 for large filesystems is jut awful. Facebook have been experiencing
> the pain hence they implemented v2. You can view the spacecache tree as=

> the complement version of the extent tree. v1 cache is implemented as a=

> hidden inode and even though writes (aka flushing of the freespace
> cache) are metadata they are essentially treated as data. This could
> potentially lead to priority inversions if cgroups io controller is
> involved.
>=20
> Furthermore, there is at least 1 known deadlock problem in freespace
> cache v1. So yes, if you want to use btrfs ona multi-tb system v2 is
> really the way to go.
>=20
>>
>> 2. There's another thread on-going about mount delays.=C2=A0 I've been=

>> completely blind to this specific problem until it caught my eye.=C2=A0=
 Does
>> anyone have ballpark estimates for how long very large HDD-based
>> filesystems will take to mount?=C2=A0 Yes, I know it will depend on th=
e
>> dataset.=C2=A0 I'm looking for O() worst-case approximations for
>> enterprise-grade large drives (12/14TB), as I expect it should scale
>> with multiple drives so approximating for a single drive should be goo=
d
>> enough.
>>
>> 3. Do long mount delays relate to space_cache v1 vs v2 (I would guess
>> no, unless it needed to be regenerated)?
>=20
> No, the long mount times seems to be due to the fact that in order for =
a
> btrfs filesystem to mount it needs to enumerate its block_groups items
> and those are stored in the extent tree, which also holds all of the
> information pertaining to allocated extents. So mixing those
> data structures in the same tree and the fact that blockgroups are
> iterated linearly during mount (check btrfs_read_block_groups) means on=

> spinning rust with shitty seek times this can take a while.

And, space cache is not loaded at mount time.
It's delayed until we determine to allocate extent from one block group.

So space cache is completely unrelated to long mount time.

>=20
> However, this will really depend on the amount of extents you have and
> having taken a look at the thread you referred to it seems there is not=

> clear-cut reason why mounting is taking so long on that particular
> occasion .

Just as said by Nikolay, the biggest problem of slow mount is the size
of extent tree (and HDD seek time)

The easiest way to get a basic idea of how large your extent tree is
using debug tree:

# btrfs-debug-tree -r -t extent <device>

You would get something like:
btrfs-progs v4.15
extent tree key (EXTENT_TREE ROOT_ITEM 0) 30539776 level 0  <<<
total bytes 10737418240
bytes used 393216
uuid 651fcf0c-0ffd-4351-9721-84b1615f02e0

That level is would give you some basic idea of the size of your extent
tree.

For level 0, it could contains about 400 items for average.
For level 1, it could contains up to 197K items.
=2E..
For leven n, it could contains up to 400 * 493 ^ (n - 1) items.
( n <=3D 7 )

Thanks,
Qu

>=20
>=20
>>
>> Note that I'm not sensitive to multi-second mount delays.=C2=A0 I am
>> sensitive to multi-minute mount delays, hence why I'm bringing this up=
=2E
>>
>> FWIW: I am currently populating a machine we have with 6TB drives in i=
t
>> with real-world home dir data to see if I can replicate the mount issu=
e.
>>
>> Thanks,
>>
>> ellis
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.htm=
l
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--AM93RgscuHnAkQFhqmGVO2OF9YSaamkPE--

--GLkAllR7Blrh6IE8TZgL621wYHzVYT5w3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqE5YMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhSXAgAjFxow7p4NrAczhDM06+r0zar
Bz/9zKjEGSdWmF4yhu4dmf+aZKNiAmTxzEyXaD4FtgW5+JiCCq/UlT8jlhfILvcJ
ROXTnNReBrICMQEbfT0wyzF4sw3peip5AV1nABbiHUVmF+ksJ+A2MvVz4vOHXyg5
IEGRZZecK9YdZNEyTok7KTkYly+32i5JaG6T4AWv9xrgm83JnxK1mREKikCJy0TI
BJBCkgVACxSeoU1t/Se9vy9YyBt+q3FwLVnY1HRJrRxcVinnQor9K5vqZcTSQW7H
LxM4Q1123Fym8RfohbwDuKzRH28e8kG0zOaSMSFvM4g5In0JxAQD5D5ZU70G4g==
=Z5SC
-----END PGP SIGNATURE-----

--GLkAllR7Blrh6IE8TZgL621wYHzVYT5w3--
