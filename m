Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:47721 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751974AbeFGG6f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 02:58:35 -0400
Subject: Re: [PATCH] fstests: btrfs: Test if btrfs will corrupt nodatasum
 compressed extent when replacing device
To: Eryu Guan <guaneryu@gmail.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
References: <20180601013448.22450-1-wqu@suse.com>
 <20180607062122.GD2861@desktop>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bd581e60-2454-1f25-2c73-241dcf118118@gmx.com>
Date: Thu, 7 Jun 2018 14:58:21 +0800
MIME-Version: 1.0
In-Reply-To: <20180607062122.GD2861@desktop>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VaXIpiUj0QkQtmm06cJDRnRNv6oMuR7Bn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VaXIpiUj0QkQtmm06cJDRnRNv6oMuR7Bn
Content-Type: multipart/mixed; boundary="G67NvlH7HfnPdUsERHE5ITidEMW2efeyX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Eryu Guan <guaneryu@gmail.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <bd581e60-2454-1f25-2c73-241dcf118118@gmx.com>
Subject: Re: [PATCH] fstests: btrfs: Test if btrfs will corrupt nodatasum
 compressed extent when replacing device
References: <20180601013448.22450-1-wqu@suse.com>
 <20180607062122.GD2861@desktop>
In-Reply-To: <20180607062122.GD2861@desktop>

--G67NvlH7HfnPdUsERHE5ITidEMW2efeyX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8807=E6=97=A5 14:21, Eryu Guan wrote:
> On Fri, Jun 01, 2018 at 09:34:48AM +0800, Qu Wenruo wrote:
>> This is a long existing bug (from 2012) but exposed by a reporter
>> recently, that when compressed extent without data csum get written to=

>> device-replace target device, the written data is in fact uncompressed=
 data
>> other than the original compressed data.
>>
>> And since btrfs still consider the data is compressed and will try to =
read it
>> as compressed, it can cause read error.
>>
>> The root cause is located, and one RFC patch already sent to fix it,
>> titled "[PATCH RFC] btrfs: scrub: Don't use inode pages for device rep=
lace".
>> (The RFC is only for the extra possible way to fix the bug, the fix
>> itself should work without problem)
>>
>> Reported-by: James Harvey <jamespharvey20@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Looks fine to me overall, some minor issues inline. But I'd really like=

> an explicit ACK from btrfs folks.
>=20
>> ---
>>  tests/btrfs/161     | 91 ++++++++++++++++++++++++++++++++++++++++++++=
+
>>  tests/btrfs/161.out |  2 +
>>  tests/btrfs/group   |  1 +
>>  3 files changed, 94 insertions(+)
>>  create mode 100755 tests/btrfs/161
>>  create mode 100644 tests/btrfs/161.out
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
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation=
,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
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
>> +status=3D1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -f $tmp.*
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
>=20
> This is not needed, there's no point running fsck on $TEST_DEV after
> test when it's not used at all.

Forgot to remove that line.

>=20
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
>=20
> Better to explain the cycle mount with comments.

It's used to drop the page cache so that next read will fetch data from
disk other than using the cache.

I'll add the comment in the next version.

>=20
>> +
>> +# Since now the compressed extent contains *UNCOMPRESSED* data, readi=
ng it will
>> +# easily trigger a EIO error
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
>>  158 auto quick raid scrub
>>  159 auto quick
>>  160 auto quick
>> +161 auto quick replace
>=20
> Anand introduced a new 'volume' group in commit 144c8463d38b ("btrfs:
> introduce btrfs/volume group"), all 'replace' tests should be in
> 'volume' group now.

Makes sense.

Thanks,
Qu

>=20
> Thanks,
> Eryu
>=20
>> --=20
>> 2.17.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--G67NvlH7HfnPdUsERHE5ITidEMW2efeyX--

--VaXIpiUj0QkQtmm06cJDRnRNv6oMuR7Bn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsY140ACgkQwj2R86El
/qgdgQf9Emv952UYrkS9ikN7VMgEekn9FN1W5HxLnmHAE09D+u3jQKu8L/qlFi44
skO1J5BlJr97DgYbbzz+FvneZBwRKJ2rZbInHX7PJnTxvi6bNK8nBBd4abr3bYqD
OeKMR1fMlPo7OoZkD95r3MVJKSuc2RJ7B8dXRVSdim74jgj2X2RBB8fExmeyWBMn
/1sk9az8+WYgqAP/xWVrmpTEsHdUVXLoiLlZqo4Z+nSki3Fq3c9sgOvGwUgOZlKc
3sXvWoVBwtJYVxwgLzZaVl1y2j+pOc+xjd5Ekun3+HzdD0/JDWwsWLsrcNM3NQFC
XZprALS4xWJFSQTlkiU56iFu4pUxgA==
=qsf7
-----END PGP SIGNATURE-----

--VaXIpiUj0QkQtmm06cJDRnRNv6oMuR7Bn--
