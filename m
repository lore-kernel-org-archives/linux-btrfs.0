Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752933AbeFNHJe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Jun 2018 03:09:34 -0400
Subject: Re: [PATCH v3] fstests: btrfs: Test if btrfs will corrupt nodatasum
 compressed extent when replacing device
To: Qu Wenruo <wqu@suse.de>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20180614063053.8780-1-wqu@suse.com>
 <f015b589-cf7a-10af-f3b1-5204f845f336@suse.com>
 <41ac826f-9652-61ed-6610-7ce744844fb2@suse.de>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <20c5830b-a2e8-2a90-b579-497a30a15f4a@suse.com>
Date: Thu, 14 Jun 2018 10:09:31 +0300
MIME-Version: 1.0
In-Reply-To: <41ac826f-9652-61ed-6610-7ce744844fb2@suse.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.06.2018 10:04, Qu Wenruo wrote:
> 
> 
> On 2018年06月14日 14:45, Nikolay Borisov wrote:
>>
>>
>> On 14.06.2018 09:30, Qu Wenruo wrote:
>>> This is a long existing bug (from 2012) but exposed by a reporter
>>> recently, that when compressed extent without data csum get written to
>>> device-replace target device, the written data is in fact uncompressed data
>>> other than the original compressed data.
>>>
>>> And since btrfs still consider the data is compressed and will try to read it
>>> as compressed, it can cause read error.
>>>
>>> The root cause is located, and fix already sent.
>>> "btrfs: scrub: Don't use inode pages for device replace".
>>>
>>> Reported-by: James Harvey <jamespharvey20@gmail.com>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>
>> Codewise lgtm:
>>
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>>
>> However, I'm having a bit of trouble reconciling the explanation so bear
>> with me, please look below.
>>
>>> ----
>>> changelog:
>>> v2:
>>>   Now the fix patch is no longer RFC.
>>>   Remove _require_test as we don't really touch it.
>>>   Add comment on the mount cycle.
>>>   Add the test to group 'volume'.
>>> v3:
>>>   Use latest template.
>>>   Rebased to latest upstream base.
>>> ---
>>>  tests/btrfs/165     | 76 +++++++++++++++++++++++++++++++++++++++++++++
>>>  tests/btrfs/165.out |  2 ++
>>>  tests/btrfs/group   |  1 +
>>>  3 files changed, 79 insertions(+)
>>>  create mode 100755 tests/btrfs/165
>>>  create mode 100644 tests/btrfs/165.out
>>>
>>> diff --git a/tests/btrfs/165 b/tests/btrfs/165
>>> new file mode 100755
>>> index 000000000000..eb9bb61c9ea3
>>> --- /dev/null
>>> +++ b/tests/btrfs/165
>>> @@ -0,0 +1,76 @@
>>> +#! /bin/bash
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
>>> +#
>>> +# FS QA Test 165
>>> +#
>>> +# Test if btrfs will corrupt compressed data extent without data csum
>>> +# by replacing it with uncompressed data, when doing device replace.
>>> +#
>>> +# This could be fixed by the following patch:
>>> +# "btrfs: scrub: Don't use inode pages for device replace"
>>> +#
>>> +seq=`basename $0`
>>> +seqres=$RESULT_DIR/$seq
>>> +echo "QA output created by $seq"
>>> +
>>> +here=`pwd`
>>> +tmp=/tmp/$$
>>> +status=1	# failure is the default!
>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>> +
>>> +_cleanup()
>>> +{
>>> +	cd /
>>> +	rm -f $tmp.*
>>> +}
>>> +
>>> +# get standard environment, filters and checks
>>> +. ./common/rc
>>> +. ./common/filter
>>> +
>>> +# remove previous $seqres.full before test
>>> +rm -f $seqres.full
>>> +
>>> +# real QA test starts here
>>> +
>>> +# Modify as appropriate.
>>> +_supported_fs btrfs
>>> +_supported_os Linux
>>> +_require_scratch_dev_pool 2
>>> +_require_scratch_dev_pool_equal_size
>>> +
>>> +_scratch_dev_pool_get 1
>>> +_spare_dev_get
>>> +_scratch_pool_mkfs >> $seqres.full 2>&1
>>> +
>>> +# Create nodatasum inode
>>> +_scratch_mount "-o nodatasum"
>>> +touch $SCRATCH_MNT/nodatasum_file
>>
>> So we create an inode with nodatasum
>>
>>> +_scratch_remount "datasum,compress"
>>> +_pwrite_byte 0xcd 0 128K $SCRATCH_MNT/nodatasum_file > /dev/null
>>
>> Then we remount the fs with datasum and compress. Now, what should the
>> behavior of that particular inode be. IMO all rights to it should be
>> nodatasum and shouldn't really be compressed (because the inode retained
>> it's original nodatasum profile).
> 
> Yes, that should be the ultimate fix.
> 
> So here we have 2 fixes:
> 1) Just fix the inode page error
>    The fix submitted upstream
> 
> 2) Fix the nodatasum/nodatacow/compression mess
>    I submitted similar fix some time ago.
>    (that inode_need_compress() patch)
> 
> The 2) one has one problem, it won't save the already generated
> compressed nodatasum extent.
> 
> So 1) is still needed anyway, if only 2) is applied, a replace can still
> corrupt affected extents.
> (And 1) can be super small to get into current pull request)
> 
>>
>>> +
>>> +# Write the compressed data back to disk
>>> +sync
>>> +
>>> +# Replace the device
>>> +_run_btrfs_util_prog replace start -Bf 1 $SPARE_DEV $SCRATCH_MNT
>>> +
>>> +# Unmount to drop all cache so next read will read from disk
>>> +_scratch_unmount
>>> +_mount $SPARE_DEV $SCRATCH_MNT
>>> +
>>> +# Now the EXTENT_DATA item still marks the extent as compressed,
>>
>> I think the actual bug is that EXTENT_DATA item shouldn't be marked as
>> compressed in the first place because the indoe is in nodatasum mode, no ?
> 
> Yes, but also explained above, the damage is already done, and even we
> fix that way, the affected users/inodes can still hit the corruption bug
> anyway.

Fair enough, but in this case there are really 2 fixes. One which fixes
the root of the issue - which still hasn't landed. And it's changelog
should be along the lines of "ensure we don't compress inodes which have
been in nodatasum mode". And a second one, which fixes just the symptom
for already corrupted extents - this is the if (0...) commit which was
in latest pull req, correct?

> 
> So the upstream fix is more or less a reminder of what we did wrong in
> the far past.
> 
> Thanks,
> Qu
> 
>>
>> All things considered, isn't the actual bug that an extent item is
>> erroneously flagged as compressed when it shouldn't have been due to the
>> presence of nodatasum?
>>
>>> +# but the on-disk data is uncompressed, thus reading it as compressed
>>> +# will definitely cause EIO.
>>> +cat $SCRATCH_MNT/nodatasum_file > /dev/null
>>> +
>>> +_scratch_unmount
>>> +_spare_dev_put
>>> +_scratch_dev_pool_put
>>> +
>>> +echo "Silence is golden"
>>> +
>>> +# success, all done
>>> +status=0
>>> +exit
>>> diff --git a/tests/btrfs/165.out b/tests/btrfs/165.out
>>> new file mode 100644
>>> index 000000000000..94ec17dc1075
>>> --- /dev/null
>>> +++ b/tests/btrfs/165.out
>>> @@ -0,0 +1,2 @@
>>> +QA output created by 165
>>> +Silence is golden
>>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>>> index 35354de2ea6f..91a1ebadae7c 100644
>>> --- a/tests/btrfs/group
>>> +++ b/tests/btrfs/group
>>> @@ -167,3 +167,4 @@
>>>  162 auto quick volume
>>>  163 auto quick volume
>>>  164 auto quick volume
>>> +165 auto quick replace volume
>>>
