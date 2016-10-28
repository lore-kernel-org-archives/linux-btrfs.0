Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63399 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S934542AbcJ1HMh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 03:12:37 -0400
Subject: Re: [PATCH v3] generic: make 17[1-4] work well when btrfs compression
 is enabled
To: Eryu Guan <eguan@redhat.com>
References: <20161026095211.30091-1-wangxg.fnst@cn.fujitsu.com>
 <20161027112527.GE27776@eguan.usersys.redhat.com>
CC: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <5812F8D3.80109@cn.fujitsu.com>
Date: Fri, 28 Oct 2016 15:05:55 +0800
MIME-Version: 1.0
In-Reply-To: <20161027112527.GE27776@eguan.usersys.redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

On 10/27/2016 07:25 PM, Eryu Guan wrote:
> On Wed, Oct 26, 2016 at 05:52:11PM +0800, Wang Xiaoguang wrote:
>> When enabling btrfs compression, original codes can not fill fs
>> correctly, here we introduce _fill_fs() in common/rc, which'll keep
>> creating and writing files until enospc error occurs. Note _fill_fs
>> is copied from tests/generic/256, but with some minor modifications.
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Looks fine to me overall, generic/17[1-4] and generic/256 passed on xfs,
> btrfs and btrfs with compress. But I'd like Darrick to review it as well :)
Could you please give me your btrfs's kernel version?
When enabling btrfs compression run these 4 test cases, I often got
enospc error, it seems that you didn't run into enospc errors.

>
>> ---
>> V2: In common/, I did't find an existing function suitable for
>>      these 4 test cases to fill fs, so I still use _pwrite_byte() with
>>      a big enough file length fo fill fs. Note, for btrfs, metadata space
>>      still is not full, only data space is full, but it's OK for these
>>      4 test cases.
>>
>>      All these 4 cases pass in xfs and btrfs(without compression), if
>>      btrfs has compression enabled, these 4 cases will fail for false
>>      enospc error, I have sent kernel patches to fix this bug.
>>
>> V3: Introduce  _fill_fs in common/rc to fill fs.
>> ---
>>   common/rc         | 50 ++++++++++++++++++++++++++++++++++++++++++
>>   tests/generic/171 |  4 +---
>>   tests/generic/172 |  4 ++--
>>   tests/generic/173 |  4 +---
>>   tests/generic/174 |  4 +---
>>   tests/generic/256 | 65 +++++--------------------------------------------------
>>   6 files changed, 60 insertions(+), 71 deletions(-)
>>
>> diff --git a/common/rc b/common/rc
>> index 7a9fc90..0e1ac5d 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -4003,6 +4003,56 @@ _require_xfs_mkfs_without_validation()
>>   	fi
>>   }
>>   
>> +# Fill a file system by repeatedly creating files in the given folder
>> +# starting with the given file size.  Files are reduced in size when
>> +# they can no longer fit until no more files can be created.
>> +_fill_fs()
>> +{
>> +	local file_size=$1
>> +	local dir=$2
>> +	local block_size=$3
>> +	local switch_user=$4
>> +	local file_count=1
>> +	local bytes_written=0
>> +
>> +	if [ $# -ne 4 ]; then
>> +		echo "Usage: _fill_fs filesize dir blocksize"
> The usage info here is wrong, missing the "switch user" argument.
Thanks for review, I'll fix it in v4.

Regards,
Xiaoguang Wang
>
> Thanks,
> Eryu
>
>



