Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22203 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753888AbbAUETg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 23:19:36 -0500
Message-ID: <54BF28D4.80303@cn.fujitsu.com>
Date: Wed, 21 Jan 2015 12:19:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
Subject: Re: [PATCH] fstest: btrfs/006: Add extra check on return value and
 'fi show' by device
References: <1421373430-21915-1-git-send-email-quwenruo@cn.fujitsu.com> <20150121040315.GC16510@dastard>
In-Reply-To: <20150121040315.GC16510@dastard>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] fstest: btrfs/006: Add extra check on return value 
and 'fi show' by device
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年01月21日 12:03
> On Fri, Jan 16, 2015 at 09:57:10AM +0800, Qu Wenruo wrote:
>> Reported in Red Hat BZ#1181627, 'btrfs fi show' on unmounted device will
>> return 1 even no error happens.
> Please describe the bug in the commit message, don't make me have to
> go look at some web page to work out what you are trying to fix.
OK, I'll make the description more detailed.
>
>> Introduced by: commit 2513077f
>> btrfs-progs: fix device missing of btrfs fi show with seed devices
>>
>> Patch fixing it:
>> https://patchwork.kernel.org/patch/5626001/
>> btrfs-progs: Fix wrong return value when executing 'fi show' on
>> umounted device.
> What btrfs progs commit introduced and fixed is not actually
> relevant to fstests.
This just saves some time for some users who failed the test and what to 
check if the bug is fixed or not.
> If I have to go read other stuff to understand
> the change you are making, then the description needs more detail
> and less external references....
I understand that I need to make the description more detailed.
Although external reference does not help much for fstests, but it will 
really saves time
for some tests.
Like Fillipe Manana's test, which embedded such info into the test 
script, saved me a lot of
time to find the regression commit.
>
>
>> Reported-by: Vratislav Podzimek <vpodzime@redhat.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   tests/btrfs/006     | 51 ++++++++++++++++++++++++++++++++++++++++++++-------
>>   tests/btrfs/006.out | 10 ++++++++++
>>   2 files changed, 54 insertions(+), 7 deletions(-)
>>
>> diff --git a/tests/btrfs/006 b/tests/btrfs/006
>> index 715fd80..2d8c1c0 100755
>> --- a/tests/btrfs/006
>> +++ b/tests/btrfs/006
>> @@ -62,33 +62,70 @@ _scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
>>   
>>   # These have to be done unmounted...?
>>   echo "== Set filesystem label to $LABEL"
>> -$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV $LABEL
>> +$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV $LABEL || \
>> +	_fail "set lable failed"
> Apart from the typo, why not _run_btrfs_util_prog?
Oh thanks a lot for the existing infrastructure.

With this one, the PIPESTATUS[] is no longer needed.
>
> However, this will make the test fail on older btrfs progs
> installations that we previously passing the test just fine, right?
No, old tests will still pass, since it returns 0 as expected.
Add the return values test just in case.
>
> IOWs, if you want to test that `btrfs fi show` always returns the
> correct value, don't add that checking to an existing test: write a
> new test that tests the validity of the return value....
OK, creating a new one seems reasonable enough for me.
>
>
>>   echo "== Get filesystem label"
>> -$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV
>> +$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV || \
>> +	_fail "get lable failed"
>> +
>> +echo "== Show filesystem by device(offline)"
>> +$BTRFS_UTIL_PROG filesystem show $FIRST_POOL_DEV | \
>> +	_filter_btrfs_filesystem_show $TOTAL_DEVS $UUID
>> +[ ${PIPESTATUS[0]} -ne 0 ] && \
>> +	_fail "show filesystem by device(offline) return value wrong"
> That's a new function being tested. Again, this belongs in a new
> test, not an existing regression test....
>
> FWIW, Now that I've seen it used a couple of times, I don't really
> like the mess that checking errors via PIPESTATUS results in,
> especially as
>
> _run_btrfs_util_prog filesystem show $FIRST_POOL_DEV | \
> 	_filter_btrfs_filesystem_show $TOTAL_DEVS $UUID
>
> Gives *exactly* the same failure detection....
Thanks for the _run_btrfs_util_prog macro hint. That's great and makes 
codes look much nicer.

BTW, do I need to cleanup all the $BTRFS_UTIL_PROG in the original test?

Thanks,
Qu
>
> Cheers,
>
> Dave.

