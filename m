Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49665 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbeCZNcJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 09:32:09 -0400
Subject: Re: [PATCH 2/2] btrfs-progs: Add test for collision DIR_ITEM handling
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
References: <1521816494-22947-1-git-send-email-nborisov@suse.com>
 <1521816494-22947-2-git-send-email-nborisov@suse.com>
 <617236e1-acc0-33b7-8697-a29036296829@gmx.com>
 <558444ee-efb6-e0c6-ecd0-10776b06106d@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0a89f383-26d2-16c2-0486-c7c8cffcabc0@gmx.com>
Date: Mon, 26 Mar 2018 21:31:54 +0800
MIME-Version: 1.0
In-Reply-To: <558444ee-efb6-e0c6-ecd0-10776b06106d@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fDgrrPIppJpkUgxpnxlpjxTSZTlgnNGux"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fDgrrPIppJpkUgxpnxlpjxTSZTlgnNGux
Content-Type: multipart/mixed; boundary="S9Ly8OmncHW8u2Yn5xmnZ3KHQlrWMu2JL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Message-ID: <0a89f383-26d2-16c2-0486-c7c8cffcabc0@gmx.com>
Subject: Re: [PATCH 2/2] btrfs-progs: Add test for collision DIR_ITEM handling
References: <1521816494-22947-1-git-send-email-nborisov@suse.com>
 <1521816494-22947-2-git-send-email-nborisov@suse.com>
 <617236e1-acc0-33b7-8697-a29036296829@gmx.com>
 <558444ee-efb6-e0c6-ecd0-10776b06106d@suse.com>
In-Reply-To: <558444ee-efb6-e0c6-ecd0-10776b06106d@suse.com>

--S9Ly8OmncHW8u2Yn5xmnZ3KHQlrWMu2JL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8826=E6=97=A5 21:24, Nikolay Borisov wrote:
>=20
>=20
> On 25.03.2018 14:44, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8823=E6=97=A5 22:48, Nikolay Borisov wrote:
>>> Verify that if we have an otherwise clean filesystem, containging col=
lided=20
>>> DIR_ITEM, btrfs check lowmem's mode can correctly handle those and no=
t produce
>>> any false positives.=20
>>>
>>> This if fixed by commit titled:
>>>
>>>  "btrfs-progs: Fix DIR_ITEM checking in lowmem"=20
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>
>> Looks pretty good.
>>
>> However a nitpick inlined below.
>>
>>> ---
>>>  .../031-lowmem-collission-dir-items/test.sh        | 27 ++++++++++++=
++++++++++
>>>  1 file changed, 27 insertions(+)
>>>  create mode 100755 tests/fsck-tests/031-lowmem-collission-dir-items/=
test.sh
>>>
>>> diff --git a/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh=
 b/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh
>>> new file mode 100755
>>> index 0000000..8a01889
>>> --- /dev/null
>>> +++ b/tests/fsck-tests/031-lowmem-collission-dir-items/test.sh
>>> @@ -0,0 +1,27 @@
>>> +#!/bin/bash
>>> +# Ensure that running btrfs check in lowmem mode on a fs
>>> +# which contains DIR_ITEM with collissions handles it
>>> +# properly
>>> +source "$TEST_TOP/common"
>>> +
>>> +check_prereq btrfs
>>> +check_prereq mkfs.btrfs
>>> +
>>> +setup_root_helper
>>> +prepare_test_dev
>>> +
>>> +run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
>>> +run_check_mount_test_dev
>>> +
>>> +# Create 2 files whose names collide
>>> +
>>> +run_check $SUDO_HELPER touch "$TEST_MNT/5ab4e206~~~~~~~~XVT1U3ZF647Y=
S2PD4AKAG826"
>>> +run_check $SUDO_HELPER touch "$TEST_MNT/5ab4e26a~~~~~~~~AP1C3VQBE79I=
JOTVOEZIR9YU"
>>> +
>>> +run_check_umount_test_dev
>>> +
>>> +# The fs is clean so lowmem shouldn't produce any warnings
>>> +run_check "$TOP/btrfs" check --mode=3Dlowmem --readonly "$TEST_DEV"
>>
>> I understand this is a pinpoint test case for lowmem mode, but for
>> lowmem mode test, we set TEST_ENABLE_OVERRIDE and the whole test case
>> will use lowmem mode.
>=20
> So how exactly is this argument supposed to be used. I tried:

TEST_ARGS_CHECK=3D"--mode=3Dlowmem" is forgot.

>=20
> TEST_ENABLE_OVERRIDE=3Dtrue TEST=3D031\* ./fsck-tests.sh  - no --lowmem=
 is
> appended
>=20
> I modify the TEST_ENABLE_OVERRIDE=3Dfalse to TEST_ENABLE_OVERRIDE=3Dtru=
e in
> common.local and then just run TEST=3D031\* ./fsck-tests.sh and it work=
s.
>=20
> TEST_ENABLE_OVERRIDE=3Dtrue TEST_ARGS_CHECK=3D--mode=3Dlowmem TEST=3D03=
1\*
> ./fsck-tests.sh - this also works?

Yep

>=20
>=20
> I'm not entirely sure what the ci config is but at this point I'm
> beginning to worry that if I omit the explicit --mode option this test
> might never be run in lowmem mode.
>=20
> The whole TEST_ENABLE_OVERRIDE situation seems a bit finicky.

I'm not familiar with CI things so it may be a good time point to check
and enhance it if possible?

Thanks,
Qu

>=20
>>
>> So it doesn't seem necessary to explicitly call lowmem check here.
>> Just normal run_check "$TOP/btrfs" check would be enough.
>> (And this will also test original mode)
>>
>>> +if [ $? -ne 0 ]; then
>>> +	_fail "check --lowmem doesn't handle collissioned DIR_ITEMs correct=
ly"
>>> +fi
>>>
>> IIRC run_check() will check the return value and exit if failure.
>> So this seems not necessary.
>>
>> Thanks,
>> Qu
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--S9Ly8OmncHW8u2Yn5xmnZ3KHQlrWMu2JL--

--fDgrrPIppJpkUgxpnxlpjxTSZTlgnNGux
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlq49koACgkQwj2R86El
/qiujgf/f1T1nGwKwgawtA8DGYahPUrhEcaOWvickXrgktDd5YJVNOQwb8MYQksf
8bZQ6/pe5TSG6xsinLXcmdNlA/cWUN69kwcNwzlyH3UNEwMclSoUzorGx9hGIyEc
2cMVfj+lz1/JeHcxI+2PkWMK6aDrgJn4IjCu6gRdV8hDDz3KCHSX7jwZp9QYG3dD
Rm388EXJOKNxUrRkcKZ51L3r5NKWHwysF32wqtdNKtpdFxZc0nC7y8ZqrfwG3TN1
GMAdl7MDOiXvVgwCi5cp6nelaW08Icgwggksf4cbjdXg6SvOLv7RNCvGRpIcPv8e
lnU6sw+HTJl50fPIGHB2HaQcQLY/7A==
=09DI
-----END PGP SIGNATURE-----

--fDgrrPIppJpkUgxpnxlpjxTSZTlgnNGux--
