Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07758C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 23:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFACB218D0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 23:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbfAYXiW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 18:38:22 -0500
Received: from mout.gmx.net ([212.227.15.18]:57797 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfAYXiV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 18:38:21 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LiTF6-1hL7l721Iy-00cgfK; Sat, 26
 Jan 2019 00:38:10 +0100
Subject: Re: [PATCH RFC] fstests: btrfs: Test if balance takes too long time
 or return -ENOSPC unexpected
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        josef@toxicpanda.com
References: <20190114082043.31220-1-wqu@suse.com>
 <20190125185738.GD2900@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <b8181a19-46ce-126f-b61d-9fea22aa0bc4@gmx.com>
Date:   Sat, 26 Jan 2019 07:38:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190125185738.GD2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bwofuVIKbKM5dAHdnsq7O7ZMQN5jjFVPf"
X-Provags-ID: V03:K1:FL7lLdo23r2SyCV9LFzQDZUxS7T7aTeASY9X2ieFHRvyg3r4Uj4
 0rYPLRq/5+a7z/qEquZOZlI6S4+81hrJ/uPgLC0BXtfUiTGzjjkeofmQ6lT6WGfzN9FNJJ5
 oeDFc3KCbzsYlsjVPVj8W+IsTJq9tLg21x0zDHjVd3lKvQfqSR9zjC3rGRFZSzsFZcRbdr2
 9te4IPeSoyapkrlPFk3cw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3uvqixMkcrA=:6O7UNmuNk1a0spz/OL7Dl+
 GwyvSXKlJZPx6pWfSUXNFqCYJjpX79C11FI870QQ9277DEuF72AATKVb1E1/eqFJz/uln4QSK
 FCyTpDHkvB9RfH1218NeqIF9cYob+u59n7RNUGFBpBWuHrJtAZuEPz+m2jisBErC82RknI+z4
 Fpnzmnt3lrwMOTMJ2yDBG6XLhobruXkslahz53CNOPqGuXJcN52ENdZkt/dmaiKB9AJIfdXWl
 nKgknFmoeO6lej16KUbkoxBhXPkR8MAc0P/SqwfbTHzA3XVi6e+7F7fZq2WQT+uCWW0pR4vsm
 bXDWrF2DDI1l61EohJnVtqLxkpzl7cwhkC6q6Dlx29uRXBzDAJTits2PKv6lNCxUuF1jWaFjy
 Xk/D13sXhtHngnubiqdssr5BIUarQjRgCk18z1Vtwzp+StOROa+VfK5ACpvdREcnaSBOv7Kxw
 FXxLGbXe9TmgjBLn+BBRrbOtD/aYH/3hrb8+l78ot2/HSOyO21HKuf6utqpGIiodDBbBMGDxd
 945+jh+rXnk+qdHmmicV/5JVc9+MiwlabCo4+G4XZgJw22NVTftvJ3ghIPOlHA2s5RMBcoEBf
 s16EA2+X5UyhN9shjWdX9MdpZKW/wyNx0jhKvG+tvKn+Gz/ynBT3lWUJGJ9a7WhxG0XPHeF4C
 NqIkym5/fmVi/iLyvcAz3CIhrrMTchCf3B/112PNVmAw81UiMG+CtL8BjmG6vK2ACJcBniMMz
 Vrbk5MRXo2TXTdscA+Lwk9Y+/kXksGnyCx2WwJm8xZF09bTrq7ePy7JHZu0lZb6yDnekH+Jx2
 obJGI20KrVYILBB4s/sTDHulEwZ5IutiOV2RNxvTuOSWpBHzy3AMu78WzLRxip0QPStqBdWjo
 nToFeJemaAz6S22lBK/nkTvCgIbh6qYkOAsWTiN6NI44Gjkpn+0p9kmorLybns
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bwofuVIKbKM5dAHdnsq7O7ZMQN5jjFVPf
Content-Type: multipart/mixed; boundary="ODNEYOP3zJYaCjKG8vsChlXLWNBjLUkh1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 fstests@vger.kernel.org, josef@toxicpanda.com
Message-ID: <b8181a19-46ce-126f-b61d-9fea22aa0bc4@gmx.com>
Subject: Re: [PATCH RFC] fstests: btrfs: Test if balance takes too long time
 or return -ENOSPC unexpected
References: <20190114082043.31220-1-wqu@suse.com>
 <20190125185738.GD2900@twin.jikos.cz>
In-Reply-To: <20190125185738.GD2900@twin.jikos.cz>

--ODNEYOP3zJYaCjKG8vsChlXLWNBjLUkh1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/26 =E4=B8=8A=E5=8D=882:57, David Sterba wrote:
> On Mon, Jan 14, 2019 at 04:20:43PM +0800, Qu Wenruo wrote:
>> Kernel commit 64403612b73a ("btrfs: rework
>> btrfs_check_space_for_delayed_refs") is introducing a regression for
>> btrfs balance performance.
>>
>> Originally, the workload used in the test case only takes seconds for
>> balance on v4.20 while now it takes over 400 seconds for balance.
>>
>> During that 400 seconds balance, it commits over 2000 transactions jus=
t
>> for nothing, compare to original several transactions.
>>
>> Add test cases to detect such regression.
>=20
> How do you detect that the test regressed, other than comparing the
> runtime recorded between runs of the testsuite? I don't actually know
> how this could be done inside the script, as there can't be a fixed
> number of seconds to compare with. The run time depends on the
> underlying storage.

I have a better idea for detecting this, by using super generation as
failure criteria.

So then we could have a simple FAIL/PASS check.
Although, we still need to take a long time to run if we hit that
regression.

Thanks,
Qu

>=20
> I takes 14 seconds on a physical machine on a rotational disk and 9
> seconds on a SSD.
>=20
> Other than the, I've used this test to validate the fix, for that
>=20
> Tested-by: David Sterba <dsterba@suse.com>
>=20
> It would be good to have the test in the testsuite so possibly some
> large timeout can be set and the test will print a message, this should=

> catch attention at least and let us decide.
>=20
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Extra note:
>> In fact, without the snapshots created in the test case, it would retu=
rn
>> -ENOSPC even we have enough unallocated space.
>> ---
>>  tests/btrfs/180     | 80 ++++++++++++++++++++++++++++++++++++++++++++=
+
>>  tests/btrfs/180.out |  2 ++
>>  tests/btrfs/group   |  1 +
>>  3 files changed, 83 insertions(+)
>>  create mode 100755 tests/btrfs/180
>>  create mode 100644 tests/btrfs/180.out
>>
>> diff --git a/tests/btrfs/180 b/tests/btrfs/180
>> new file mode 100755
>> index 00000000..534fea01
>> --- /dev/null
>> +++ b/tests/btrfs/180
>> @@ -0,0 +1,80 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
>> +#
>> +# FS QA Test 180
>> +#
>> +# Test if metadata balance would take forever to finish or return ENO=
SPC even
>> +# there there are tons of space.
>> +#
>> +# This is regression caused by upstream commit 64403612b73a
>> +# ("btrfs: rework btrfs_check_space_for_delayed_refs")
>> +#
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
>> +_require_scratch
>> +_require_xfs_io_command falloc
>> +
>> +i=3D0
>> +loop=3D16384
>> +
>> +_scratch_mkfs > /dev/null 2>&1
>> +_scratch_mount
>> +
>> +$BTRFS_UTIL_PROG subvolume create "$SCRATCH_MNT/src" > /dev/null
>> +
>> +while [ $i -le $loop ]; do
>> +	# Use small file to create inline extent
>> +	_pwrite_byte 0x00 0 2K "$SCRATCH_MNT/src/inline_$i" > /dev/null
>> +	#$XFS_IO_PROG -f -c "falloc 0 4K" "$SCRATCH_MNT/src/regular_$i" > /d=
ev/null
>=20
> You can delete the commented command
>=20
>> +	i=3D$((i + 1))
>> +done
>> +
>> +# Create enough snapshots so at space reservation part of relocation,=
 we could
>> +# generate enough space pressure
>> +for i in $(seq -w 0 16); do
>> +	$BTRFS_UTIL_PROG subvolume snapshot "$SCRATCH_MNT/src" \
>> +		"$SCRATCH_MNT/snapshot_$i" > /dev/null
>> +	# touch random files to create some new tree blocks
>> +	for j in $(seq -w 0 16); do
>> +		victim=3D"$(ls $SCRATCH_MNT/snapshot_$i | sort -R | head -n1)"
>> +		touch "$SCRATCH_MNT/snapshot_$i/$victim"
>> +	done
>> +done
>> +
>> +# Balancing metadata shouldn't be too time consuming, as the amount o=
f metadata
>> +# is less than 8M, thus normally it should finish very quick.
>> +#
>> +# However with that offending commit, it will take forever to finish =
or return
>> +# ENOSPC after a long wait.
>> +$BTRFS_UTIL_PROG balance start -m "$SCRATCH_MNT" > /dev/null
>> +
>> +echo "Silence is golden"
>> +# success, all done
>> +status=3D0
>> +exit
>> diff --git a/tests/btrfs/180.out b/tests/btrfs/180.out
>> new file mode 100644
>> index 00000000..50aba766
>> --- /dev/null
>> +++ b/tests/btrfs/180.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 180
>> +Silence is golden
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index 46dd3c95..e724968b 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -182,3 +182,4 @@
>>  177 auto quick swap balance
>>  178 auto quick send
>>  179 auto qgroup dangerous
>> +180 auto balance dangerous
>=20
> I don't think it falls to the dangerous category, it does not crash the=

> machine, only that the test could take long.
>=20


--ODNEYOP3zJYaCjKG8vsChlXLWNBjLUkh1--

--bwofuVIKbKM5dAHdnsq7O7ZMQN5jjFVPf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxLndsACgkQwj2R86El
/qgFHQgAlSm3pfJBwNBMkEllLEXYromKInKyTDaXRp36B68lfZufTfr2NutPeZmi
jJkAdMoxrTS379yEvSfU0V0jyVSx6rsOGbiUs8W43sJ4NYjMO9PW4l2nRhbbR917
nvIdRfuq2TzAuxChVTdB91C3M5o+z11sWfAMKTk8zeL8PvI1vBJEnAMs7Jpmm5ba
eTKyJUH7qTJ0ki9jWIkeC7soGQG9FL3OmHoSWxvYwQTMElJFS5bBkwnrGeUTExCh
/dC2mhs3uPR6XK8OwGo396bxI2CXmyeaHr13SAfg0cnrJB/zG1haWbW/0yHU6BQH
3hX8bKPIwG6yNeIx4+5UwysdMSZUaA==
=GFyo
-----END PGP SIGNATURE-----

--bwofuVIKbKM5dAHdnsq7O7ZMQN5jjFVPf--
