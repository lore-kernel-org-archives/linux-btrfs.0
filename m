Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B95C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 09:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10C7120821
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 09:22:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10C7120821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbeJaSTn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 14:19:43 -0400
Received: from mout.gmx.net ([212.227.17.20]:51491 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727716AbeJaSTn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 14:19:43 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MHrk1-1gGPn81hcr-003d2y; Wed, 31
 Oct 2018 10:22:17 +0100
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MHrk1-1gGPn81hcr-003d2y; Wed, 31
 Oct 2018 10:22:17 +0100
Subject: Re: [PATCH v3] fstests: btrfs/057: Fix false alerts due to orphan
 files
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20181030101819.19510-1-wqu@suse.com>
 <96e63270-1697-479a-b2b0-f6b2e78ede90@suse.com>
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
Message-ID: <c3617dc2-cbb0-492e-5161-bcc264cbf673@gmx.com>
Date:   Wed, 31 Oct 2018 17:22:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <96e63270-1697-479a-b2b0-f6b2e78ede90@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:oXUO90l587dLMSnMgY103TFcnshjp/1xw9Gns54dyaKH2GQUEft
 +GoCmGuklc2ZRN+bfyhStwB+npkLAIOeH55sIobmOnefUGf2lcl8Nf4/CfDFKzLZ5e3b292
 bSJ8voEJu+PGw+2vxwDOt4f5tlTx6/PnuQcpVglf4F4BYVtmB+2XfwXOGOmZhN1MAf2qmBe
 FJK8DFaniUcDgZ+sELK+A==
X-UI-Out-Filterresults: notjunk:1;V01:K0:gZ3KXQeLIh0=:bKLWpCsG70phxAVafJ5YGe
 rtccr1b01p4MrMqgUHPC4KaAff99FE6wm7Ko3+u4QChM9UJnYynMb40MspE+hl7DQA2TztdXv
 2eLhqV0sYEjUBGWXPcHc/yc0khNVzU4BZuOttxFGaRPthvTYLJKYOrBJGNJHbYTQ9KQThwVAC
 FVSHSSAgfuffvJAilyFuvZW2g3KTmjXTSF2crGCtityv+s+kyqlBl4QHDyS/UGdkrND/3q0UG
 YCFfkP6zJ5aZyV1ffS/eUial2PauraMkAvCQ0jbWPvqx3qu2bKLzOKdEn+y+TMR4TZHMd2Vqf
 IGoQS/sdJ30jJBQvKNupyuc5Zkzi3gDg3ksCJsfMyYItJWAPjzD+kJ5Q9JpOkLvb3Lz9lpccJ
 3pjGWE7ZFrATD4d+UTyBZPhHM8nsiUe7w9yfCUXFFDAtoAmAxZHYGLOGOYk05TdYUzxCRndYK
 w2gcrOv5fXJ6WLrLj61h3w+T9kksbzmPAmoY2Qfexy6VshfI5Th4yPIsS1x3PM7Z2L1cUFwEh
 TEWupFRaF+3eNTUwYtmNYcngEqxCRCkGtTLg82zjXQXrWT7MJxS56X+DFqrY/ix8Y1n4WeVtI
 jLIm8A3bPpUQcCEeiv1I9Z7/MIyiXaNn92Ofoa/iGSl0CJBgty8EwiUEdimM/02WBI1GGWOuq
 waCyQ7O8ffLxmP6YDId0x8ZokdsHOIWHJ7Xgey4VMhzRtNAchYkiNeKc0kSCmJqvZjc5L+MgO
 1TFML4qpGvSyTaO+rY7HtjussutD84CaTeqshKDQa21phbJqtiyOyi/uaEn9dmXxgHCxKVE0H
 UIjm2OzhvBWcSoKT7mPYCpdlhJ5Ey7tB86+XgC0OE22CSX0wepfZ4oFS5rBbg3SgzBqd1rV5f
 Qkq2l7Civi+CKrxgFLByD2MJtXM46DPPIi3e+LUDhQpbIJ5T3bClK8uMIY5QbGkbL5DjAdNzw
 Mws+1cQmyug==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/31 下午4:55, Nikolay Borisov wrote:
> 
> 
> On 30.10.18 г. 12:18 ч., Qu Wenruo wrote:
>> For any recent kernel, there is a chance that btrfs/057 reports false
>> errors.
>>
>> The false error would look like:
>>   btrfs/057 4s ... - output mismatch (see /home/adam/xfstests-dev/results//btrfs/057.out.bad)
>>       --- tests/btrfs/057.out	2017-08-21 09:25:33.166666666 +0800
>>       +++ /home/adam/xfstests-dev/results//btrfs/057.out.bad	2018-10-29 14:07:28.443651293 +0800
>>       @@ -1,3 +1,3 @@
>>        QA output created by 057
>>        4096 4096
>>       -4096 4096
>>       +28672 28672
>>
>> This is related to the fact that "btrfs subvolume sync" (or
>> vanilla sync) will not ensure orphan (unlinked but still exist) files to
>> be removed.
>>
>> In fact, for that false error case, if inspecting the fs after umount,
>> its qgroup number is correct and btrfs check won't report qgroup error.
>>
>> To fix the false alerts, just skip any manual qgroup number comparison,
>> and let fsck done after the test case to detect problem.
>>
>> This also elimiate the necessary of using specified mount and mkfs
>> option, allowing us to improve coverage.
> 
> Something's fishy about this test! THe description states that "
>  Quota rescan stress test, we run fsstress and quota rescan
> concurrently" yet fsstress is not run concurrently to quota. We first
> run fsstress, then trigger rescan with -w. How exactly are rescan and
> fsstress run concurrently ?

Indeed that description is just garbage.

The real objective looks like just fsstress + rescan test.
No concurrency at all from the very beginning.

Not sure what to do with it.

Thanks,
Qu

> 
>>
>> Reported-by: Nikolay Borisov <nborisov@suse.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>> ---
>> Changelog:
>> v2:
>>   Update commit message to show this is a long existing bug.
>> v3:
>>   Remove an old comment since now we don't need to specify the leaf
>>   size.
>>   Added Reviewed-by tags.
>> ---
>>  tests/btrfs/057     | 18 ++++--------------
>>  tests/btrfs/057.out |  3 +--
>>  2 files changed, 5 insertions(+), 16 deletions(-)
>>
>> diff --git a/tests/btrfs/057 b/tests/btrfs/057
>> index b019f4e1e054..82e3162ebfeb 100755
>> --- a/tests/btrfs/057
>> +++ b/tests/btrfs/057
>> @@ -32,13 +32,9 @@ _require_scratch
>>  
>>  rm -f $seqres.full
>>  
>> -# use small leaf size to get higher btree height.
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
>> @@ -53,14 +49,8 @@ run_check $FSSTRESS_PROG -d $SCRATCH_MNT/snap1 -w -p 5 -n 1000 \
>>  _run_btrfs_util_prog quota enable $SCRATCH_MNT
>>  _run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
>>  
>> -# remove all file/dir other than subvolume
>> -rm -rf $SCRATCH_MNT/snap1/* >& /dev/null
>> -rm -rf $SCRATCH_MNT/p* >& /dev/null
>> -
>> -_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
>> -units=`_btrfs_qgroup_units`
>> -$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' \
>> -	| $AWK_PROG '{print $2" "$3}'
>> +echo "Silence is golden"
>> +# btrfs check will detect any qgroup number mismatch.
>>  
>>  status=0
>>  exit
>> diff --git a/tests/btrfs/057.out b/tests/btrfs/057.out
>> index 60cb92d0926c..185023c79961 100644
>> --- a/tests/btrfs/057.out
>> +++ b/tests/btrfs/057.out
>> @@ -1,3 +1,2 @@
>>  QA output created by 057
>> -4096 4096
>> -4096 4096
>> +Silence is golden
>>
