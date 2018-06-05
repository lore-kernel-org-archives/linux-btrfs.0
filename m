Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:43487 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751726AbeFELje (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 07:39:34 -0400
Subject: Re: [PATCH] fstests: btrfs: Test if btrfs will corrupt nodatasum
 compressed extent when replacing device
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
References: <20180601013448.22450-1-wqu@suse.com>
 <ab3e01d0-5171-eb6d-d7cc-a14ce1f55db3@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <59e06aba-3071-1f34-8095-a27ee1df77d4@gmx.com>
Date: Tue, 5 Jun 2018 19:39:16 +0800
MIME-Version: 1.0
In-Reply-To: <ab3e01d0-5171-eb6d-d7cc-a14ce1f55db3@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="r2IM2rIkIcO23TJqIyDXH9aD8Eyj0Aljs"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r2IM2rIkIcO23TJqIyDXH9aD8Eyj0Aljs
Content-Type: multipart/mixed; boundary="hnqEqOu2yWf9HaaFZY2hC0JIDXdNp8R1v";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <59e06aba-3071-1f34-8095-a27ee1df77d4@gmx.com>
Subject: Re: [PATCH] fstests: btrfs: Test if btrfs will corrupt nodatasum
 compressed extent when replacing device
References: <20180601013448.22450-1-wqu@suse.com>
 <ab3e01d0-5171-eb6d-d7cc-a14ce1f55db3@oracle.com>
In-Reply-To: <ab3e01d0-5171-eb6d-d7cc-a14ce1f55db3@oracle.com>

--hnqEqOu2yWf9HaaFZY2hC0JIDXdNp8R1v
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8805=E6=97=A5 18:42, Anand Jain wrote:
>=20
>=20
> On 06/01/2018 09:34 AM, Qu Wenruo wrote:
>> This is a long existing bug (from 2012) but exposed by a reporter
>> recently, that when compressed extent without data csum get written to=

>> device-replace target device, the written data is in fact uncompressed=

>> data
>> other than the original compressed data.
>>
>> And since btrfs still consider the data is compressed and will try to
>> read it
>> as compressed, it can cause read error.
>>
>> The root cause is located, and one RFC patch already sent to fix it,
>> titled "[PATCH RFC] btrfs: scrub: Don't use inode pages for device
>> replace".
>> (The RFC is only for the extra possible way to fix the bug, the fix
>> itself should work without problem)
>>
>> Reported-by: James Harvey <jamespharvey20@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> =C2=A0 tests/btrfs/161=C2=A0=C2=A0=C2=A0=C2=A0 | 91 ++++++++++++++++++=
+++++++++++++++++++++++++++
>> =C2=A0 tests/btrfs/161.out |=C2=A0 2 +
>> =C2=A0 tests/btrfs/group=C2=A0=C2=A0 |=C2=A0 1 +
>> =C2=A0 3 files changed, 94 insertions(+)
>> =C2=A0 create mode 100755 tests/btrfs/161
>> =C2=A0 create mode 100644 tests/btrfs/161.out
>>
>> diff --git a/tests/btrfs/161 b/tests/btrfs/161
>> new file mode 100755
>> index 00000000..d4a2b474
>> --- /dev/null
>> +++ b/tests/btrfs/161
>> @@ -0,0 +1,91 @@
>> +#! /bin/bash
>> +# FS QA Test 161
>> +#
>> +# Test if btrfs will corrupt compressed data extent without data csum=

>> +# by replacing it with uncompressed data, when doing replacing device=
=2E
>> +#
>> +# This could be fixed by the following RFC patch:
>> +# "[PATCH RFC] btrfs: scrub: Don't use inode pages for device replace=
"
>> +#
>> +#--------------------------------------------------------------------=
---
>> +# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=C2=A0 See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation=
,
>> +# Inc.,=C2=A0 51 Franklin St, Fifth Floor, Boston, MA=C2=A0 02110-130=
1=C2=A0 USA
>> +#--------------------------------------------------------------------=
---
>> +#
>> +
>> +seq=3D`basename $0`
>> +seqres=3D$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=3D`pwd`
>> +tmp=3D/tmp/$$
>> +status=3D1=C2=A0=C2=A0=C2=A0 # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +=C2=A0=C2=A0=C2=A0 cd /
>> +=C2=A0=C2=A0=C2=A0 rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_test
>> +_require_scratch_dev_pool 2
>> +_require_scratch_dev_pool_equal_size
>> +
>> +
>> +_scratch_dev_pool_get 1
>> +_spare_dev_get
>> +_scratch_pool_mkfs >> $seqres.full 2>&1
>> +
>> +# Create nodatasum inode
>> +_scratch_mount "-o nodatasum"
>> +touch $SCRATCH_MNT/nodatasum_file
>> +_scratch_remount "datasum,compress"
>> +_pwrite_byte 0xcd 0 128K $SCRATCH_MNT/nodatasum_file > /dev/null
>> +
>> +# Write the compressed data back to disk
>> +sync
>> +
>> +# Replace the device
>> +_run_btrfs_util_prog replace start -Bf 1 $SPARE_DEV $SCRATCH_MNT
>> +
>> +_scratch_unmount
>> +
>> +_mount $SPARE_DEV $SCRATCH_MNT
>> +
>> +# Since now the compressed extent contains *UNCOMPRESSED* data,
>> reading it will
>> +# easily trigger a EIO error
>=20
> =C2=A0This sentence is confusing. Are you referring to the bug?

Yes.

> =C2=A0what is compressed extent containing uncompressed data?

The data extent has lzo compression flag.
While its on-disk data is in fact the uncompressed data.

With the test case, just check the on-disk data extent, you'll find
that's all 0xcd, other the lzo compressed data.

Thanks,
Qu

>=20
> Thanks, Anand
>=20
>> +cat $SCRATCH_MNT/nodatasum_file > /dev/null
>> +
>> +_scratch_unmount
>> +_spare_dev_put
>> +_scratch_dev_pool_put
>> +
>> +echo "Silence is golden"
>> +# success, all done
>> +status=3D0
>> +exit
>> diff --git a/tests/btrfs/161.out b/tests/btrfs/161.out
>> new file mode 100644
>> index 00000000..1752a243
>> --- /dev/null
>> +++ b/tests/btrfs/161.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 161
>> +Silence is golden
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index f04ee8d5..f900b3d0 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -163,3 +163,4 @@
>> =C2=A0 158 auto quick raid scrub
>> =C2=A0 159 auto quick
>> =C2=A0 160 auto quick
>> +161 auto quick replace
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--hnqEqOu2yWf9HaaFZY2hC0JIDXdNp8R1v--

--r2IM2rIkIcO23TJqIyDXH9aD8Eyj0Aljs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsWdmQACgkQwj2R86El
/qhNJwf/cSfHDV/l9A347sTZbk6JipsjL0OsJSabRWcCeqSksggllezXFJpWVYja
VPkyCQB0GyuZieGbiM0YtmnbxcDzSb8JG+ngAcOLuHlhaPxNG9ua77fOKE4A5WQL
m4PrDGgev7k54u6KjbOJJCw343w6tVAqlOJVE7egIiuW5EK0bwWiDZQYcOtBOQO4
kHwjehpUOvJhw0LWePIE0gNzdrZwtzix1EZ3XzFEEeXOd+j+rYSpOZfxPlCghXdW
4wsiHmFwHR6yk15/HKBibp47jnb/bmLYnAqk397yb4n5npeQuu8hRYtN/E3x47P2
LDA9/wQEPCc2w3hA/tnYjH23WOrGdQ==
=rtFa
-----END PGP SIGNATURE-----

--r2IM2rIkIcO23TJqIyDXH9aD8Eyj0Aljs--
