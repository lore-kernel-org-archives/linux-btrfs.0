Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60319 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbeHJMeY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 08:34:24 -0400
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: Dan Merillat <dan.merillat@gmail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com>
 <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
 <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com>
 <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e3b0929f-9415-5816-2a68-0e46f11454ba@gmx.com>
Date: Fri, 10 Aug 2018 18:05:07 +0800
MIME-Version: 1.0
In-Reply-To: <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Rsrz5jFxGrjpW4YZTJTdp7VQogDzW7s7b"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Rsrz5jFxGrjpW4YZTJTdp7VQogDzW7s7b
Content-Type: multipart/mixed; boundary="4twQs9TWC7ZlBYj1hO1c2JNMbgPUv4T64";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <e3b0929f-9415-5816-2a68-0e46f11454ba@gmx.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com>
 <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
 <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com>
 <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>
In-Reply-To: <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>

--4twQs9TWC7ZlBYj1hO1c2JNMbgPUv4T64
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/10/18 5:39 PM, Dan Merillat wrote:
> On Fri, Aug 10, 2018 at 5:13 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 8/10/18 4:47 PM, Dan Merillat wrote:
>>> Unfortunately that doesn't appear to be it, a forced restart and
>>> attempted to mount with skip_balance leads to the same thing.
>>
>> That's strange.
>>
>> Would you please provide the following output to determine whether we
>> have any balance running?
>>
>> # btrfs inspect dump-super -fFa <device>
[snip]

Nothing special for super dump.

>=20
>>
>> # btrfs inspect dump-tree -t root <device>
>>
>=20
> Too large to include inline, hopefully attaching works.

Although not sure about the details, but the fs looks pretty huge.
Tons of subvolume and its free space cache inodes.

But only 3 tree reloc trees, unless you have tons of reflinked files
(off-line deduped), it shouldn't cause a lot of problem.

At least, we have some progress dropping tree reloc tree for subvolume 64=
82.

If you check the dump-tree output for the following data, the "drop key"
should change during mount: (inspect dump-tree can be run mounted)
	item 175 key (TREE_RELOC ROOT_ITEM 6482) itemoff 8271 itemsize 439
	        <snip>
		drop key (2769795 EXTENT_DATA 12665933824) level 2
                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

So for the worst case scenario, there is some way to determine whether
it's processing.

And according to the level (3), which is not small for each subvolume, I
doubt that's the reason why it's so slow.

BTW, for last skip_balance mount, is there any kernel message like
"balance: resume skipped"?
Have you tried mount the fs readonly with skip_balance? And then remount
rw, still with skip_balance?

>=20
> I think there's a balance though:
>         item 178 key (BALANCE TEMPORARY_ITEM 0) itemoff 6945 itemsize 4=
48
>                 temporary item objectid BALANCE offset 0
>                 balance status flags 6
>                 DATA
>                 profiles 0 devid 0 target 0 flags 0
>                 usage_min 0 usage_max 0 pstart 0 pend 0
>                 vstart 0 vend 0 limit_min 0 limit_max 0
>                 stripes_min 0 stripes_max 0
>                 METADATA
>                 profiles 0 devid 0 target 0 flags 0
>                 usage_min 0 usage_max 0 pstart 0 pend 0
>                 vstart 0 vend 0 limit_min 0 limit_max 0
>                 stripes_min 0 stripes_max 0
>                 SYSTEM
>                 profiles 0 devid 0 target 0 flags 0
>                 usage_min 0 usage_max 0 pstart 0 pend 0
>                 vstart 0 vend 0 limit_min 0 limit_max 0
>                 stripes_min 0 stripes_max 0
>=20
> btrfs check is still running, it's found one thing so far:
>=20
> Checking filesystem on /dev/bcache0
> UUID: 16adc029-64c5-45ff-8114-e2f5b2f2d331
> checking extents
> ref mismatch on [13135707160576 16384] extent item 0, found 1
> tree backref 13135707160576 parent 13136850550784 root 13136850550784 n=
ot found
> in extent tree
> backpointer mismatch on [13135707160576 16384]

Just single error, not bad (compared to some catastrophic error).
It may be a false alert since it's a backref for reloc tree, which is
not that common for us to test.

So the fs should be OK to go, just need to figure out how and why
skip_balance is not working.

Thanks,
Qu

> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
>=20


--4twQs9TWC7ZlBYj1hO1c2JNMbgPUv4T64--

--Rsrz5jFxGrjpW4YZTJTdp7VQogDzW7s7b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlttY1MACgkQwj2R86El
/qjFMwgAiB/zAEeDUquRl0zO8m1za+CeouCPAEm3bP24XYdVJ7k3pthrDvAX5obg
Q7IvPd8Bf1k/AckiEFAEfjKvahVOu9mW8x4aa9bDDHETxEklRUNZCt32xtjrO+WA
mTsFsR8etUzxHKKm5qpzaMa0R9l/LzXSJz4jmiLtqvPG9npvJaugTDxMf2391ORi
BnS2w5Yk2LaGiGSqeAf6Ua3XKiH9Fay6PZccWEEufYE+qxSXb3729Mr9XIPdCk2w
tMpHCuyYL8Zk854dF18y0cxgQNb8h/QKHIbP5cMKSf73ynNMa+3zHYsHqWG2aht2
Vujd7NDF83k/19gOHcVlqPXdXQBJsA==
=qEoq
-----END PGP SIGNATURE-----

--Rsrz5jFxGrjpW4YZTJTdp7VQogDzW7s7b--
