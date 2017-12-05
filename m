Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30710 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753043AbdLEIyN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 03:54:13 -0500
Subject: Re: [PATCH] btrfs/124: add balance --full-balance option
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
References: <20171205082628.1676-1-anand.jain@oracle.com>
 <0a70d47c-7bcc-a6ff-c79e-b988fd305818@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <098dfc82-e08f-4ba8-f06f-798994b4c187@oracle.com>
Date: Tue, 5 Dec 2017 16:54:40 +0800
MIME-Version: 1.0
In-Reply-To: <0a70d47c-7bcc-a6ff-c79e-b988fd305818@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/05/2017 04:30 PM, Qu Wenruo wrote:
> 
> 
> On 2017年12月05日 16:26, Anand Jain wrote:
>> btrfs balance needs --full-balance option since 4.6, so check the
>> version and then use it.
>>
>> As this may be useful for other btrfs tests as well, so this patch
>> adds _btrfs_full_balance_option() to the common/btrfs file.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   common/btrfs    | 13 +++++++++++++
>>   tests/btrfs/124 |  3 ++-
>>   2 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/common/btrfs b/common/btrfs
>> index c09206c6f292..8ca6486b26dc 100644
>> --- a/common/btrfs
>> +++ b/common/btrfs
>> @@ -356,3 +356,16 @@ _btrfs_compression_algos()
>>   		echo "${feature#/sys/fs/btrfs/features/compress_}"
>>   	done
>>   }
>> +
>> +#btrfs-progs adds required --full-balance option since v4.6 so check for
>> +#that and then return the required option.
>> +_btrfs_full_balance_option()
>> +{
>> +	ver=$($BTRFS_UTIL_PROG --version|awk '{print $2}'|cut -d"-" -f1 | cut -d"v" -f2)
> 
> I'm never a fan of version check.
> Backporting or modified package version can easily screw this up.
> 
> Why not directly checking the help message of "btrfs balance start"?

  Agreed. Will do.

Thanks, Anand

> Thanks,
> Qu
> 
>> +	tup1=$(echo $ver| cut -d"." -f1)
>> +	tup2=$(echo $ver| cut -d"." -f2)
>> +
>> +	RET=""
>> +	(("$tup1" > "4")) && RET="--full-balance"
>> +	(("$tup1" == "4")) && (("tup2" >= "6")) && RET="--full-balance"
>> +}
>> diff --git a/tests/btrfs/124 b/tests/btrfs/124
>> index a6486270a972..ec1d24b5ef42 100755
>> --- a/tests/btrfs/124
>> +++ b/tests/btrfs/124
>> @@ -129,7 +129,8 @@ _run_btrfs_util_prog device scan
>>   _scratch_mount >> $seqres.full 2>&1
>>   _run_btrfs_util_prog filesystem show
>>   echo >> $seqres.full
>> -_run_btrfs_util_prog balance start ${SCRATCH_MNT}
>> +_btrfs_full_balance_option
>> +_run_btrfs_util_prog balance start $RET ${SCRATCH_MNT}
>>   
>>   checkpoint2=`md5sum $SCRATCH_MNT/tf2`
>>   echo $checkpoint2 >> $seqres.full 2>&1
>>
> 
