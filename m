Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:39753 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727513AbeH1Reo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 13:34:44 -0400
Subject: Re: Scrub aborts due to corrupt leaf
To: Larkin Lowrey <llowrey@nuclearwinter.com>, linux-btrfs@vger.kernel.org
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
Date: Tue, 28 Aug 2018 21:42:39 +0800
MIME-Version: 1.0
In-Reply-To: <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="47Nd8bPl5z4w7DJQMH9t4uRRZww0YEk0M"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--47Nd8bPl5z4w7DJQMH9t4uRRZww0YEk0M
Content-Type: multipart/mixed; boundary="in5UNaxRtE8a4SofvyBTi4y2HkTE31O2l";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Larkin Lowrey <llowrey@nuclearwinter.com>, linux-btrfs@vger.kernel.org
Message-ID: <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
Subject: Re: Scrub aborts due to corrupt leaf
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
In-Reply-To: <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>

--in5UNaxRtE8a4SofvyBTi4y2HkTE31O2l
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/28 =E4=B8=8B=E5=8D=889:29, Larkin Lowrey wrote:
> On 8/27/2018 10:12 PM, Larkin Lowrey wrote:
>> On 8/27/2018 12:46 AM, Qu Wenruo wrote:
>>>
>>>> The system uses ECC memory and edac-util has not reported any errors=
=2E
>>>> However, I will run a memtest anyway.
>>> So it should not be the memory problem.
>>>
>>> BTW, what's the current generation of the fs?
>>>
>>> # btrfs inspect dump-super <device> | grep generation
>>>
>>> The corrupted leaf has generation 2862, I'm not sure how recent did t=
he
>>> corruption happen.
>>
>> generation=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 358392
>> chunk_root_generation=C2=A0=C2=A0 357256
>> cache_generation=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 358392
>> uuid_tree_generation=C2=A0=C2=A0=C2=A0 358392
>> dev_item.generation=C2=A0=C2=A0=C2=A0=C2=A0 0
>>
>> I don't recall the last time I ran a scrub but I doubt it has been
>> more than a year.
>>
>> I am running 'btrfs check --init-csum-tree' now. Hopefully that clears=

>> everything up.
>=20
> No such luck:
>=20
> Creating a new CRC tree
> Checking filesystem on /dev/Cached/Backups
> UUID: acff5096-1128-4b24-a15e-4ba04261edc3
> Reinitialize checksum tree
> csum result is 0 for block 2412149436416
> extent-tree.c:2764: alloc_tree_block: BUG_ON `ret` triggered, value -28=


It's ENOSPC, meaning btrfs can't find enough space for the new csum tree
blocks.

I could try to enhance the behavior, from current one to delete tree
blocks first and then refill.

But this needs some extra time to implement.

BTW, from the line number, it's not the latest btrfs-progs.

Thanks,
Qu

> btrfs(+0x1da16)[0x55cc43796a16]
> btrfs(btrfs_alloc_free_block+0x207)[0x55cc4379c177]
> btrfs(+0x1602f)[0x55cc4378f02f]
> btrfs(btrfs_search_slot+0xed2)[0x55cc43790be2]
> btrfs(btrfs_csum_file_block+0x48f)[0x55cc437a213f]
> btrfs(+0x55cef)[0x55cc437cecef]
> btrfs(cmd_check+0xd49)[0x55cc437ddbc9]
> btrfs(main+0x81)[0x55cc4378b4d1]
> /lib64/libc.so.6(__libc_start_main+0xeb)[0x7f4717e6324b]
> btrfs(_start+0x2a)[0x55cc4378b5ea]
> Aborted (core dumped)
>=20
> --Larkin


--in5UNaxRtE8a4SofvyBTi4y2HkTE31O2l--

--47Nd8bPl5z4w7DJQMH9t4uRRZww0YEk0M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluFUU8ACgkQwj2R86El
/qjslQf+LxNg5aeEf7RGeNUoX3R7ColRqPVO+0Dx3JnehX2GvNmabF4XNpMUamId
LBfDS92FOhnY7SYKZPC/daf2m9+KNX3MgSkWhOOfzlKtXNo0H5qlpjEzIVtFo7jS
3Iv1gA57J6jC1mLI+ih9tMqgpQ3R1Bf98tpeZYC9qRpOSQgj0PMeev+err028fju
eGnUF/YJEh98yMqnBJFPOGgjYsDEprkSKNUjMaH2yWuE2x0M6K017UWWgF14zEBe
hY1yFQXeAoIA+gswxF7VNwLEyHkGgqzRd0yFuCer4I7NVZilZ1SeQ4+Pgrd2ZENd
KBFmnM2JkqUFzr6RbQqXuUalYxOF3w==
=xt7y
-----END PGP SIGNATURE-----

--47Nd8bPl5z4w7DJQMH9t4uRRZww0YEk0M--
