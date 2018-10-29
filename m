Return-Path: <SRS0=e2uI=NJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287A5C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 11:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D175A2082D
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 11:33:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D175A2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbeJ2UWE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Oct 2018 16:22:04 -0400
Received: from mout.gmx.net ([212.227.15.18]:35603 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbeJ2UWE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Oct 2018 16:22:04 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MCcvy-1gPJHE1f2A-009Nkf; Mon, 29
 Oct 2018 12:33:39 +0100
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MCcvy-1gPJHE1f2A-009Nkf; Mon, 29
 Oct 2018 12:33:39 +0100
Subject: Re: [PATCH] fstests: btrfs/057: Fix false alerts due to orphan files
To:     fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181029063053.21130-1-wqu@suse.com>
 <CAL3q7H4tGLCpFUm-GR7cGng66zu3A342O7eM6jbfFsqx1-Zw=Q@mail.gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <140cc051-9e73-a051-c1e5-71590d829606@gmx.com>
Date:   Mon, 29 Oct 2018 19:33:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4tGLCpFUm-GR7cGng66zu3A342O7eM6jbfFsqx1-Zw=Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IscnwqMvqC7PdjjxJCkxFKcP5R2AaeBQW"
X-Provags-ID: V03:K1:AFeOjES49zSPZDeIQMSUszLRtJaGxvHp6u9cE2SHrwnmhodl1zr
 tLTW+Fq24XbN2mha/88jHT3eHCh9cGGO4rl7DUc8/13yzc6h7EXCX3fCf71vvE6p7YS6coT
 ESrB8sY8LlYMoWkrNOs4yEuG2aVh3oLtz5zcuLGZRnBNservHEdVQ3txCMrCtg1koIUwOf7
 NBR9/PGBhkW83l/uptPKA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:mC609qyCo9M=:lYa/w1Eu7Y10MdQ8vs/dOy
 KCaP6vo2phBQ7kp7o/f3iCoKK7nxG1xaq/Toit2JXqDNzrVu/RSUpJs3Y/4OS933F6uzO66sV
 Wjlo8LV8Q/s6APACvxPGkzhr3Tf3ab7Cbas5OEiJEfRWEiXMne77lTX85HGWUUHZidNJyZXu9
 KX/ACGffvpeOVIsh9Dw9R5FqA/Z96gvThdFDRrMIEQ0BsPfmTYf1c3v4kyGTbE0l8us/FDF5Q
 qbhYp+vqEFOTme7BVruCVykvZltrg8RizAD8YxGzDAlhOyLiyHW2LExFpLBAa34aSQYzIV07P
 6b7d2kqgcFzzHLZH6IyeI7ou9wUJ0qLok0sY5a9j/lWQNKg5h4k1zPf3wztixR3uXfXjexqPl
 EUJqPCX2sULhttU/TjoysXkmxdIIi0XD2JFoU0kXlHp3t8vf7CgXTcU11tCShMZGZEQAqnCMf
 yEYFuLJ7GX1tpZnbhV6o6MX53FJ9ILEdrOIWaFhckVjiiyUbXY10aV54dWhN0M5oF6xwLR7ga
 P9tWBcSLDyJ8Z82G8f9krwBWjpvG5rTmyzIhR/tJjeqAkugx50BxWk4VtgxT0/Mg0dbV1CnPR
 07oVuxuIlWh20ULjjJzKR9f4erGR3iqY2T4q71OKDRwVIyw5tI9HhOnvYW0Enk3hkQCCDGYG3
 dMKJQZCae/+csiOay0GGaNTGib5guW9QRFty63/zrzYh6v4HL7n9VzHf2lD5W0NnU7Z0cx183
 S7HialVwflWubJZOAR/R7cBuZ1JWrYvfA2YUFNXSVThDSae8UuXuzSu7xM8bVlnc9rnBiYc8L
 l0EZT5Q0aXA/h5kNZDlOY5DDQLDbg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IscnwqMvqC7PdjjxJCkxFKcP5R2AaeBQW
Content-Type: multipart/mixed; boundary="ZrnnDiw1CVrT4X8D4ueASpbVkWZnV4OYw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <140cc051-9e73-a051-c1e5-71590d829606@gmx.com>
Subject: Re: [PATCH] fstests: btrfs/057: Fix false alerts due to orphan files
References: <20181029063053.21130-1-wqu@suse.com>
 <CAL3q7H4tGLCpFUm-GR7cGng66zu3A342O7eM6jbfFsqx1-Zw=Q@mail.gmail.com>
In-Reply-To: <CAL3q7H4tGLCpFUm-GR7cGng66zu3A342O7eM6jbfFsqx1-Zw=Q@mail.gmail.com>

--ZrnnDiw1CVrT4X8D4ueASpbVkWZnV4OYw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/29 =E4=B8=8B=E5=8D=885:52, Filipe Manana wrote:
> On Mon, Oct 29, 2018 at 6:31 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> For latest kernel, there is a chance that btrfs/057 reports false
>> errors.
>=20
> By latest kernel you mean 4.20?

I mean almost all kernels.

>=20
>>
>> The false error would look like:
>>   btrfs/057 4s ... - output mismatch (see /home/adam/xfstests-dev/resu=
lts//btrfs/057.out.bad)
>>       --- tests/btrfs/057.out   2017-08-21 09:25:33.166666666 +0800
>>       +++ /home/adam/xfstests-dev/results//btrfs/057.out.bad    2018-1=
0-29 14:07:28.443651293 +0800
>>       @@ -1,3 +1,3 @@
>>        QA output created by 057
>>        4096 4096
>>       -4096 4096
>>       +28672 28672
>>
>> This is related to the fact that "btrfs subvolume sync" (or
>> vanilla sync) will not ensure orphan (unlinked but still exist) files =
to
>> be removed.
>=20
> So when did that happen, which commit introduced the behaviour change?

No behavior change, it's always the case.
Just not that easy to hit.

Thanks,
Qu

>=20
>>
>> In fact, for that false error case, if inspecting the fs after umount,=

>> its qgroup number is correct and btrfs check won't report qgroup error=
=2E
>>
>> To fix the false alerts, just skip any manual qgroup number comparison=
,
>> and let fsck done after the test case to detect problem.
>>
>> This also elimiate the necessary of using specified mount and mkfs
>> option, allowing us to improve coverage.
>>
>> Reported-by: Nikolay Borisov <nborisov@suse.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  tests/btrfs/057     | 17 ++++-------------
>>  tests/btrfs/057.out |  3 +--
>>  2 files changed, 5 insertions(+), 15 deletions(-)
>>
>> diff --git a/tests/btrfs/057 b/tests/btrfs/057
>> index b019f4e1..0b5a36d3 100755
>> --- a/tests/btrfs/057
>> +++ b/tests/btrfs/057
>> @@ -33,12 +33,9 @@ _require_scratch
>>  rm -f $seqres.full
>>
>>  # use small leaf size to get higher btree height.
>> -run_check _scratch_mkfs "-b 1g --nodesize 4096"
>> +run_check _scratch_mkfs "-b 1g"
>>
>> -# inode cache is saved in the FS tree itself for every
>> -# individual FS tree,that affects the sizes reported by qgroup show
>> -# so we need to explicitly turn it off to get consistent values.
>> -_scratch_mount "-o noinode_cache"
>> +_scratch_mount
>>
>>  # -w ensures that the only ops are ones which cause write I/O
>>  run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p 5 -n 1000 \
>> @@ -53,14 +50,8 @@ run_check $FSSTRESS_PROG -d $SCRATCH_MNT/snap1 -w -=
p 5 -n 1000 \
>>  _run_btrfs_util_prog quota enable $SCRATCH_MNT
>>  _run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
>>
>> -# remove all file/dir other than subvolume
>> -rm -rf $SCRATCH_MNT/snap1/* >& /dev/null
>> -rm -rf $SCRATCH_MNT/p* >& /dev/null
>> -
>> -_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
>> -units=3D`_btrfs_qgroup_units`
>> -$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $SED_PROG -n '/[0-=
9]/p' \
>> -       | $AWK_PROG '{print $2" "$3}'
>> +echo "Silence is golden"
>> +# btrfs check will detect any qgroup number mismatch.
>>
>>  status=3D0
>>  exit
>> diff --git a/tests/btrfs/057.out b/tests/btrfs/057.out
>> index 60cb92d0..185023c7 100644
>> --- a/tests/btrfs/057.out
>> +++ b/tests/btrfs/057.out
>> @@ -1,3 +1,2 @@
>>  QA output created by 057
>> -4096 4096
>> -4096 4096
>> +Silence is golden
>> --
>> 2.18.0
>>
>=20
>=20


--ZrnnDiw1CVrT4X8D4ueASpbVkWZnV4OYw--

--IscnwqMvqC7PdjjxJCkxFKcP5R2AaeBQW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvW8A0ACgkQwj2R86El
/qiOUAf+PrC8uIM36tbw03N1n1nFmnJZpBUQ96SUTXFLfYP1xF2Q5Z/OS2YeUaD1
3szI8Af2VMBVlY+ml/AiY0AqFZlNAOYa3HyBgLLasC59mzB20xoLNJfdxI+4/WJ+
IK4Pt5EQqfX/zC2y9plhNmB0YbAnvX3R6mlbIj+CgGcul6nnnWMAW8SbIHQJybyA
iHEEJ90FRGA4EBeXd8Xv/YuVRIy81JUXzBGPPZpIJptXF9YJfLr/hKcs9lWZwK0h
1qF5xPHq+Qb/XX0FN0Dk4PNxXLkONWMxElpW/Px5nAgTfaCdvW70ukfiQ9XBTh+L
hKSfrXKLi+nIziCzvqwCzNJiD9GRsQ==
=BJ5y
-----END PGP SIGNATURE-----

--IscnwqMvqC7PdjjxJCkxFKcP5R2AaeBQW--
