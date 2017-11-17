Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52757 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752487AbdKQBb6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 20:31:58 -0500
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
 <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
 <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
 <9b81b628-d10b-b62e-74f7-86c8ba2f939b@redhat.com>
 <3ba90cc2-30bb-2867-94fa-895def5f2826@gmx.com>
 <391774c5-81f8-cdda-3dbe-4d3d1c2fa3d7@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b439a2d7-18f6-62cd-2038-a2f052ae554a@gmx.com>
Date: Fri, 17 Nov 2017 09:30:32 +0800
MIME-Version: 1.0
In-Reply-To: <391774c5-81f8-cdda-3dbe-4d3d1c2fa3d7@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mhnmA8GNFPln2VsTRP4KUpLI4p6A5qq5I"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mhnmA8GNFPln2VsTRP4KUpLI4p6A5qq5I
Content-Type: multipart/mixed; boundary="A3jHX5gP2ovnarOXtNfF3kXB5N5JkCrbc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 Zdenek Kabelac <zkabelac@redhat.com>, Nikolay Borisov <nborisov@suse.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <b439a2d7-18f6-62cd-2038-a2f052ae554a@gmx.com>
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
 <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
 <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
 <9b81b628-d10b-b62e-74f7-86c8ba2f939b@redhat.com>
 <3ba90cc2-30bb-2867-94fa-895def5f2826@gmx.com>
 <391774c5-81f8-cdda-3dbe-4d3d1c2fa3d7@gmail.com>
In-Reply-To: <391774c5-81f8-cdda-3dbe-4d3d1c2fa3d7@gmail.com>

--A3jHX5gP2ovnarOXtNfF3kXB5N5JkCrbc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8817=E6=97=A5 00:47, Austin S. Hemmelgarn wrote:=


>>
>> This is at least less complicated than dm-integrity.
>>
>> Just a new hook for READ bio. And it can start from easy part.
>> Like starting from dm-raid1 and other fs support.
> It's less complicated for end users (in theory, but cryptsetup devs are=

> working on that for dm-integrity), but significantly more complicated
> for developers.
>=20
> It also brings up the question of what happens when you want some other=

> layer between the filesystem and the MD/DM RAID layer (say, running
> bcache or dm-cache on top of the RAID array).=C2=A0 In the case of
> dm-integrity, that's not an issue because dm-integrity is entirely
> self-contained, it doesn't depend on other layers beyond the standard
> block interface.

Each layer can choose to drop the support for extra verification.

If the layer is not modifying the data, it can pass it do lower layer.
Just as integrity payload.

>=20
> As I mentioned in my other reply on this thread, running with
> dm-integrity _below_ the RAID layer instead of on top of it will provid=
e
> the same net effect, and in fact provide a stronger guarantee than what=

> you are proposing (because dm-integrity does real cryptographic
> integrity verification, as opposed to just checking for bit-rot).

Although with more CPU usage for each device even they are containing
same data.

>>
>>>
>>> If your checksum is calculated and checked at FS level there is no ad=
ded
>>> value when you spread this logic to other layers.
>>
>> That's why I'm moving the checking part to lower level, to make more
>> value from the checksum.
>>
>>>
>>> dm-integrity adds basic 'check-summing' to any filesystem without the=

>>> need to modify fs itself
>>
>> Well, despite the fact that modern filesystem has already implemented
>> their metadata csum.
>>
>> =C2=A0 - the paid price is - if there is bug between
>>> passing data from=C2=A0 'fs' to dm-integrity'=C2=A0 it cannot be capt=
ured.
>>>
>>> Advantage of having separated 'fs' and 'block' layer is in its
>>> separation and simplicity at each level.
>>
>> Totally agreed on this.
>>
>> But the idea here should not bring that large impact (compared to big
>> things like ZFS/Btrfs).
>>
>> 1) It only affect READ bio
>> 2) Every dm target can choose if to support or pass down the hook.
>> =C2=A0=C2=A0=C2=A0 no mean to support it for RAID0 for example.
>> =C2=A0=C2=A0=C2=A0 And for complex raid like RAID5/6 no need to suppor=
t it from the very
>> =C2=A0=C2=A0=C2=A0 beginning.
>> 3) Main part of the functionality is already implemented
>> =C2=A0=C2=A0=C2=A0 The core complexity contains 2 parts:
>> =C2=A0=C2=A0=C2=A0 a) checksum calculation and checking
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Modern fs is already doing this, =
at least for metadata.
>> =C2=A0=C2=A0=C2=A0 b) recovery
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dm targets already have this impl=
emented for supported raid
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 profile.
>> =C2=A0=C2=A0=C2=A0 All these are already implemented, just moving them=
 to different
>> =C2=A0=C2=A0=C2=A0 timing is not bringing such big modification IIRC.
>>>
>>> If you want integrated solution - you are simply looking for btrfs wh=
ere
>>> multiple layers are integrated together.
>>
>> If with such verification hook (along with something extra to handle
>> scrub), btrfs chunk mapping can be re-implemented with device-mapper:
>>
>> In fact btrfs logical space is just a dm-linear device, and each chunk=

>> can be implemented by its corresponding dm-* module like:
>>
>> dm-linear:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | btrfs chunk 1 | btrfs=
 chunk 2 | ... | btrfs chunk n |
>> and
>> btrfs chunk 1: metadata, using dm-raid1 on diskA and diskB
>> btrfs chunk 2: data, using dm-raid0 on disk A B C D
>> ...
>> btrfs chunk n: system, using dm-raid1 on disk A B
>>
>> At least btrfs can take the advantage of the simplicity of separate
>> layers.
>>
>> And other filesystem can get a little higher chance to recover its
>> metadata if built on dm-raid.
> Again, just put dm-integrity below dm-raid.=C2=A0 The other filesystems=

> primarily have metadata checksums to catch data corruption, not repair
> it,

Because they have no extra copy.
If they have, they will definitely use the extra copy to repair.

> and I severely doubt that you will manage to convince developers to
> add support in their filesystem (especially XFS) because:
> 1. It's a layering violation (yes, I know BTRFS is too, but that's a bi=
t
> less of an issue because it's a completely self-contained layering
> violation, while this isn't).

If passing something along with bio is violating layers, then integrity
payload is already doing this for a long time.

> 2. There's no precedent in hardware (I challenge you to find a block
> device that lets you respond to a read completing with 'Hey, this data
> is bogus, give me the real data!').
> 3. You can get the same net effect with a higher guarantee of security
> using dm-integrity.

With more CPU and IO overhead (journal mode will write data twice, one
for journal and one for real data).

Thanks,
Qu

>>
>> Thanks,
>> Qu
>>
>>>
>>> You are also possibly missing feature of dm-interity - it's not just
>>> giving you 'checksum' - it also makes you sure - device has proper
>>> content - you can't just 'replace block' even with proper checksum fo=
r a
>>> block somewhere in the middle of you device... and when joined with
>>> crypto - it makes it way more secure...
>>>
>>> Regards
>>>
>>> Zdenek
>>
>=20


--A3jHX5gP2ovnarOXtNfF3kXB5N5JkCrbc--

--mhnmA8GNFPln2VsTRP4KUpLI4p6A5qq5I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloOO7gXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhYGQf/TLII1fQLEfiqp0b6aO0WIuhQ
U3H639Q2Hds1FLxpmjQjbR4TaryQvD8H/jDb6egv6wv2xTv4nRdlGwlXfcrgkKBX
GgzuzhY221na9/QnCLtr4AGEliZKiqkck/joNsGXBrm3ngG650m67IOS0pqWFZ3D
cv+0C9MTwb0KZEUweqnyAkGffPaDTqg5zbycqAiTTbYqAkVpCLI4Sl2TQMJwt726
Znssu8iTtZXCQyzvwjbZP5PaDF706Gvw35Y5ytznVREiCFV8KmhXrI4GxcU98Cfo
H/muQ+OggmpU9C2gxPgt/L+1FEqz6Ihu9UpzbjCuq2xwZr9/iO1hB/lodknHKw==
=8IcW
-----END PGP SIGNATURE-----

--mhnmA8GNFPln2VsTRP4KUpLI4p6A5qq5I--
