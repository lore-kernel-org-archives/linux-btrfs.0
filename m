Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55136 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754367AbbAUEVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 23:21:50 -0500
Message-ID: <54BF295C.6060902@cn.fujitsu.com>
Date: Wed, 21 Jan 2015 12:21:48 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
Subject: Re: [PATCH] fstests: btrfs/079: Fix wrong value passed to available
 space check.
References: <1419837438-13771-1-git-send-email-quwenruo@cn.fujitsu.com> <20150121041911.GE16510@dastard>
In-Reply-To: <20150121041911.GE16510@dastard>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] fstests: btrfs/079: Fix wrong value passed to 
available space check.
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年01月21日 12:19
> On Mon, Dec 29, 2014 at 03:17:18PM +0800, Qu Wenruo wrote:
>> Before the patch, we passed wrong value to _require_fs_space, which
>> should be in unit of 1024, but passed in unit of GB.
> Yes, that needs fixing.
>
>> Fix it and add better prompt for falloc failure.
> That doesn't....
>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   tests/btrfs/079 | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/tests/btrfs/079 b/tests/btrfs/079
>> index 202d3e6..99d0187 100755
>> --- a/tests/btrfs/079
>> +++ b/tests/btrfs/079
>> @@ -73,8 +73,9 @@ rm -f $seqres.full
>>   
>>   _scratch_mkfs >>$seqres.full 2>&1
>>   _scratch_mount
>> -_require_fs_space $SCRATCH_MNT $(($filesize / 1024 / 1024 / 1024))
>> -$XFS_IO_PROG -f -c "falloc 0 $filesize" $testfile
>> +_require_fs_space $SCRATCH_MNT $(($filesize / 1024))
>> +$XFS_IO_PROG -f -c "falloc 0 $filesize" $testfile || \
>> +	_fail "falloc failed"
> If the falloc fails, then the golden output match will fail. Let the
> test run, regardless, because the first thing it does is try to
> overwrite the fallocated region where the success or failure of the
> writes are completely ignored. Hence a falloc failure should also be
> ignored...
>
> Cheers,
>
> Dave.
OK, I'll send a V2 one for this.

Thanks for reviewing.
Qu
