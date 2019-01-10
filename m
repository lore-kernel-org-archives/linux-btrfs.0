Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2B7C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 13:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30EA920879
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 13:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfAJNtv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 08:49:51 -0500
Received: from mout.gmx.net ([212.227.17.20]:51155 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729112AbfAJNts (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 08:49:48 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M0yaB-1hYihb0bgF-00v7yv; Thu, 10
 Jan 2019 14:49:37 +0100
Subject: Re: [PATCH 2/2] fstests: btrfs: Introduce stress test for deadlock
 between snapshot delete and other read-write operations
To:     fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
References: <20190110061415.32045-1-wqu@suse.com>
 <20190110061415.32045-2-wqu@suse.com>
 <CAL3q7H7gG4gLWaSHhLmxR-ngT-WBPXtx1=iziwcK4iquaQ6-xw@mail.gmail.com>
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
Message-ID: <c2306946-c239-2cfa-b397-699ee42b4190@gmx.com>
Date:   Thu, 10 Jan 2019 21:49:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7gG4gLWaSHhLmxR-ngT-WBPXtx1=iziwcK4iquaQ6-xw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RteSPvmFPy7O7JAkGM3LWrXEorvMkZe5M"
X-Provags-ID: V03:K1:VGupTcRiSme/Z8kIrsyUnAFHP9WvcTxPzjyzidHeZBolxJFnl8i
 tZEmwXb1aNO9HG3+IXurS69FRxipjicAEdibECBA2r/2mXZy+yf99AVdXDJmVliZ316Hm7i
 XlH+4b67cvDAH+K+UaXhSL7SgbM1dklQNSSLBhlZ8J0iN2AdKPEs9iPOVaxN1DvqIarFhAr
 TAG3aaguMX4lsX1Ei1R2g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ulsqY1OMwTI=:xxRKbJ5EDsiPCZxYVgxjUT
 hAMWwa9s5rcKGRsB5IzS3jZ79Kp1xQP9WXtlFiLMP8gf6omh2/UdDshYNNoF1ShY9MFKPzYxs
 /dSrqPvwrerBTEzK2p0feoWk13pRmrMQpb7P5jDv1P9AOWkmp6JZuWnFT/T11gUhYc7/a/3qV
 cfropeis3+WYXm2vuqZTlWuMbVON2usaJ3zzu92SjqT4sukyJp17pxbEguoR0ZzhfP5st2WKB
 Dtp6IrSOO+8uZBshxCqR9ybx0XKWewyoq9rjqdtsVOFzoyjjQdDBxRu/D2OTIzUbTx6OnrhDP
 05kjmWw31yslptmqDwZRhA3OWEWgxbD2N7FMRUEs8tKqTLHMW4Tm/vu11bQmCZaEyvbZr9bx7
 T+GJw395+rUjtHEMpAQR+U/HLiBYRdhQnERl7w6+dFeCVkI2I7bhres5vfV7tT46Vc6359zEK
 kCtgbjVprzNmL/2JYkqnhAEAF+uf66a95iVZAjD4AHfhJ5JR88U3g3jNzxqDEtEp+XwfeemVx
 EFi3eotBl7yiPsZh8QJLk+tAbrWMCBe5KHcDinQe8l1BqxEcyb25IXC4PYxuw6e9z5r4QpBEp
 +iMnF7Sy2CTHnZd6isx+Ief/cEYMomxK2J5WBI0N/rbEMmznNKiWbWYvnubrnqjPR8rN+XtKh
 xF2JJAby3v/Yan1paKDYnhwfzRet1YX8vk2bdHL+E5ZoG+CxNPofgKUx+uXjEZVwDlz0iB32z
 t+cL+YwT4MiOEt/8NS7G5+89g94NT+X5z3Kip3h4e9V7zkk4EVcqD+9J6plZrJp5RUA4N4Rp+
 ip23uDVCFDdmUju6VH1PiiPcN38AnPGhOR9BfLWkvzmDeoygmfsbEPCu2z+Rv4Kvyzhw+Ev8c
 06T2AGmjdJDkNU5Pf2NPahktZq8Elvc7TAmM9G5a2n5UdrwAK4C65fwZBLwKdM
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RteSPvmFPy7O7JAkGM3LWrXEorvMkZe5M
Content-Type: multipart/mixed; boundary="xweoOpA08ZhglxcwQxqhpW9T0nx823Vke";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
 fstests <fstests@vger.kernel.org>
Message-ID: <c2306946-c239-2cfa-b397-699ee42b4190@gmx.com>
Subject: Re: [PATCH 2/2] fstests: btrfs: Introduce stress test for deadlock
 between snapshot delete and other read-write operations
References: <20190110061415.32045-1-wqu@suse.com>
 <20190110061415.32045-2-wqu@suse.com>
 <CAL3q7H7gG4gLWaSHhLmxR-ngT-WBPXtx1=iziwcK4iquaQ6-xw@mail.gmail.com>
In-Reply-To: <CAL3q7H7gG4gLWaSHhLmxR-ngT-WBPXtx1=iziwcK4iquaQ6-xw@mail.gmail.com>

--xweoOpA08ZhglxcwQxqhpW9T0nx823Vke
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/10 =E4=B8=8B=E5=8D=888:08, Filipe Manana wrote:
> On Thu, Jan 10, 2019 at 6:15 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> Commit fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accountin=
g
>> time out of commit trans") could cause ABBA deadlock between backref
>> lookup with write lock hold (subvolume deletion) and other read/write
>> operations.
>>
>> It's going to be fixed by "btrfs: qgroup: Don't trigger backref walk a=
t
>> delayed ref insert time".
>>
>> This test will generate pwrite background workload, along with
>> constantly subvolume creation and deletion to trigger the bug.
>=20
> constantly -> constant
>>
>> It needs some time to generate enough files to bump the tree height to=

>> trigger the bug.
>> In my test environment, with 'unsafe' cache mode for the VM, it trigge=
rs
>> the bug at around 70~90 seconds. So I leave the default runtime to 120=
s
>> to make sure the bug will be triggered.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  tests/btrfs/179     | 121 +++++++++++++++++++++++++++++++++++++++++++=
+
>>  tests/btrfs/179.out |   2 +
>>  tests/btrfs/group   |   1 +
>>  3 files changed, 124 insertions(+)
>>  create mode 100755 tests/btrfs/179
>>  create mode 100644 tests/btrfs/179.out
>>
>> diff --git a/tests/btrfs/179 b/tests/btrfs/179
>> new file mode 100755
>> index 000000000000..771d12fc49e3
>> --- /dev/null
>> +++ b/tests/btrfs/179
>> @@ -0,0 +1,121 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
>> +#
>> +# FS QA Test 179
>> +#
>> +# Test if btrfs will lockup at subvolume deletion.
>=20
> Misses the most important part in the short description: "... when
> qgroups are enabled."
>=20
>> +#
>> +# The bug is caused by commit fb235dc06fac ("btrfs: qgroup: Move half=
 of the
>> +# qgroup accounting time out of commit trans").
>> +# Backref lookup with write lock hold (subvolue deletion) could cause=
 ABBA lock
>> +# with normal top-down tree locking sequence.
>=20
> I would omit this. Relevant information on how and why the bug happens
> is in the kernel patch, QA
> people only need to know the test's purpose.
>=20
>> +#
>> +# This bug deadlock is going to be fixed by "btrfs: qgroup: Don't tri=
gger
>=20
> "This bug is going ... by a patch for the kernel titled ..."
>=20
>> +# backref walk at delayed ref insert time" which reverts above commit=
=2E
>> +#
>> +seq=3D`basename $0`
>> +seqres=3D$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=3D`pwd`
>> +tmp=3D/tmp/$$
>> +status=3D1       # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +       cd /
>> +       rm -f $tmp.*
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
>> +
>> +# default sleep interval
>> +sleep_time=3D1
>> +
>> +# stress test runtime
>> +runtime=3D120
>> +
>> +_scratch_mkfs > /dev/null 2>&1
>> +_scratch_mount
>> +
>> +mkdir -p "$SCRATCH_MNT/snapshots"
>> +$BTRFS_UTIL_PROG subvolume create "$SCRATCH_MNT/src" > /dev/null
>> +$BTRFS_UTIL_PROG quota enable "$SCRATCH_MNT" > /dev/null
>> +$BTRFS_UTIL_PROG quota rescan -w "$SCRATCH_MNT" > /dev/null
>> +
>> +fill_workload()
>> +{
>> +       local i=3D0
>> +       while true; do
>> +               _pwrite_byte 0xcd 0 8K "$SCRATCH_MNT/src/large_$i" > /=
dev/null
>> +               _pwrite_byte 0xcd 0 2K "$SCRATCH_MNT/src/inline_$i" > =
/dev/null
>> +
>> +               # Randomly remove some files for every 5 loop
>> +               if [ $(( $i % 5 )) -eq 0 ]; then
>> +                       victim=3D$(ls "$SCRATCH_MNT/src" | sort -R | h=
ead -n1)
>> +                       rm "$SCRATCH_MNT/src/$victim"
>> +               fi
>> +               i=3D$((i + 1))
>> +       done
>> +}
>> +
>> +snapshot_workload()
>> +{
>> +       local i=3D0
>> +       while true; do
>> +               sleep $sleep_time
>> +               $BTRFS_UTIL_PROG subvolume snapshot "$SCRATCH_MNT/src"=
 \
>> +                       "$SCRATCH_MNT/snapshots/$i" > /dev/null
>> +               i=3D$((i + 1))
>> +       done
>> +}
>> +
>> +delete_workload()
>> +{
>> +       while true; do
>> +               sleep $((sleep_time * 2))
>> +               victim=3D$(ls "$SCRATCH_MNT/snapshots" | sort -R | hea=
d -n1)
>> +               $BTRFS_UTIL_PROG subvolume delete \
>> +                       "$SCRATCH_MNT/snapshots/$victim" > /dev/null
>> +       done
>> +}
>> +
>> +fill_workload &
>> +fill_pid=3D$!
>> +
>> +sleep $((sleep_time * 2))
>> +snapshot_workload &
>> +snapshot_pid=3D$!
>> +delete_workload &
>> +delete_pid=3D$!
>> +
>> +sleep $runtime
>> +kill $fill_pid
>> +wait $fill_pid
>> +kill $snapshot_pid
>> +wait $snapshot_pid
>> +kill $delete_pid
>> +wait $delete_pid
>> +
>> +# Workaround to handle killed workload with unreturned syscall
>> +sync
>=20
> I can't understand that comment, nor why the call to sync (probably
> most readers won't either).
> What do you mean by "unreturned syscall"? It hangs, blocked? Because
> of the deadlock? How does the sync makes it "return"?

I mean normal "btrfs subvolume create/delete" ioctl syscalls.

>=20
> When you say killed workload, you mean though the kill commands above?
> For all pids or just some in particular?

For the workload, it will be a forked bash process, and then executing
"btrfs" program.
While "btrfs subvolume create/delete" could call ioctl and fall into
kernel space, kill/wait for the bash process could return before the
ioctl returned.

So here we try to call sync which will commit current transaction, more
or less wait for unfinished "btrfs" ioctls to return.

Or should I change to the more common loop of check "btrfs" process and
wait?

Thanks,
Qu

>=20
>> +
>> +# success, all done
>> +echo "Silence is golden"
>> +
>> +status=3D0
>> +exit
>> diff --git a/tests/btrfs/179.out b/tests/btrfs/179.out
>> new file mode 100644
>> index 000000000000..cb9eba3d34b1
>> --- /dev/null
>> +++ b/tests/btrfs/179.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 179
>> +Silence is golden
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index 04c0254aa4bf..46dd3c9523c2 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -181,3 +181,4 @@
>>  176 auto quick swap volume
>>  177 auto quick swap balance
>>  178 auto quick send
>> +179 auto qgroup dangerous
>> --
>> 2.20.1
>>
>=20
>=20


--xweoOpA08ZhglxcwQxqhpW9T0nx823Vke--

--RteSPvmFPy7O7JAkGM3LWrXEorvMkZe5M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw3TWoACgkQwj2R86El
/qh12gf/fRoHtAlBUlRQHuGe1XevrCRhtagsy6Ja/MgbYB6k64NZ/7NHMkSo3vce
didFtq/PLj43K/36LgkD8q2gCmfttSwRqZJwv5qrWaM0DbmFIpaBqIVoTo6FSoIl
S5WVZQb0pxKNYeUaAft1VMUvCAZRvxj9yL9oed9sYZjY0rEQY/SZ1+oE0fmcXS+n
sNK2ugem3MUmHFYTARWWmie6jMOS3c/XNzq0mPU31A3t769yJqcVHPbPAnr4fxTu
S/Voq+RyPo0MYEq/QAPbrHn8zaMIRMegMSIl3jSJDIjDPOqB9OZ/6YHhEgGtLeSY
S+u7vNr5D4hZvZ5UHYcjbgmj9ZsPPg==
=tIxB
-----END PGP SIGNATURE-----

--RteSPvmFPy7O7JAkGM3LWrXEorvMkZe5M--
