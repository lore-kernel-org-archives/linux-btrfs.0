Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53755 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751831AbbCPBeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Mar 2015 21:34:24 -0400
Message-ID: <5506331C.2070003@cn.fujitsu.com>
Date: Mon, 16 Mar 2015 09:34:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <fstests@vger.kernel.org>
Subject: Re: [PATCH v2] fstest: btrfs/083: Test for incorrect exclusive refernce
 number after file clone.
References: <1426211137-15233-1-git-send-email-quwenruo@cn.fujitsu.com> <CAL3q7H4TsmHANvMp548ssUvkteU6N4uCb5BVcyeZfAj64A0LKA@mail.gmail.com>
In-Reply-To: <CAL3q7H4TsmHANvMp548ssUvkteU6N4uCb5BVcyeZfAj64A0LKA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH v2] fstest: btrfs/083: Test for incorrect exclusive 
refernce number after file clone.
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年03月13日 21:00

> On Fri, Mar 13, 2015 at 1:45 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> [Problem]
>> Since commit fcebe4562dec83b3f8d308 ("Btrfs: rework qgroup accounting"),
>> quota data update is delayed after delayed_ref calculation, and lacks
>> correct protection to detect root reference which shouldn't be counted
>> in current sequence number but already written into extent backref.
>>
>> This makes exclusive reference not decreased correctly and give incorrect
>> result.
>>
>> [Test procedure]
>> 1. Create a btrfs with 3 subvolumes, quota enabled and rescanned.
>> 2. Create a file in 1st subvolume
>> 3. Clone the file to 2nd and 3rd subvolume
>> 4. Sync the fs to reflect the changes in qgroup.
>> 5. Check the qgroup data
>>
>> [Expected result]
>> None of the subvolume has exclusive reference to the file.
>>
>> [Actual result]
>> The first subvolume still have exclusive reference to the file.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> changelog:
>> v2: Redirect error output of dd to seqres.full for debug in case dd failed.
>> ---
>>   tests/btrfs/083     | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/083.out |  5 ++++
>>   tests/btrfs/group   |  1 +
>>   3 files changed, 82 insertions(+)
>>   create mode 100755 tests/btrfs/083
>>   create mode 100644 tests/btrfs/083.out
>>
>> diff --git a/tests/btrfs/083 b/tests/btrfs/083
>> new file mode 100755
>> index 0000000..0996cff
>> --- /dev/null
>> +++ b/tests/btrfs/083
>> @@ -0,0 +1,76 @@
>> +#! /bin/bash
>> +# FS QA Test No. 083
>> +#
>> +# Test for incorrect exclusive reference count after cloning file
>> +# between subvolumes.
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2015 Fujitsu. All Rights Reserved.
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
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#-----------------------------------------------------------------------
>> +#
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1       # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +    rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_need_to_be_root
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch
>> +_require_cp_reflink
>> +
>> +run_check _scratch_mkfs "--nodesize 4096"
>
> Replying to your and Josef's previous answers, I don't see it obvious
> why it's easier to test with node size of 4Kb vs 64Kb (I would say
> only the golden output's values would change).
>
> So ok, the patchset to allow for block sizes smaller then the page
> size seems it will be merged soon. But what if some QA team wants to
> test on an older kernel that doesn't have that commit that introduced
> the regression? Then the test won't pass on a machine with a page size
>> 4Kb.
> Same reasoning applies to the -o noinode_cache mount option.
>
> I always thought fstests were supposed to run on the widest possible
> range of platforms, kernel and utilities versions.
For best compatibility, 64k is the valid choice.
And for this case, I'm OK to change golden output and use 64K node/leafsize.

But I'm not a big fan to always use 64K to get compatibility, in some 
case, for example, a hidden bug can only be triggered by a given number 
of tree level, and 64K nodesize will makes things much much harder or 
takes much longer time to reproduce.

The best method should be determine the minimal nodesize automatically, 
using options like --maxnodesize or --minnodesize, and fstests filter 
the nodesize we need.

> But I guess in this
> case it's not too bad, since qgroups seem to have always been broken
> in one way or another.
Yep, poor quota seems not to be loved by a lot of devs :(

>
>> +
>> +# inode cache will also take space in fs tree, disable them to get consistent
>> +# result.
>> +run_check _scratch_mount "-o noinode_cache"
>> +
>> +_run_btrfs_util_prog subvolume create $SCRATCH_MNT/subv1
>> +_run_btrfs_util_prog subvolume create $SCRATCH_MNT/subv2
>> +_run_btrfs_util_prog subvolume create $SCRATCH_MNT/subv3
>> +
>> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
>> +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
>> +
>> +dd if=/dev/zero of=$SCRATCH_MNT/subv1/file1 bs=4K count=64 2> $seqres.full
>
> The idea was not to redirect stderr, so that if dd fails you'll see it
> in the diff. This is just what all (or most at least) do, pretty sure
> Dave makes this observation very often. Plus by using '>' you are
> overriding the $seqtes.full's contents.
Overriding is indeed a problem, but I don't consider redirect dd output 
into golden output is needed.

1) Most of the dd usage in test cases don't do it.
Only cases which really cares how much dd writes will filter output into 
golden output, the rest just redirect it to seqres.full.

2) If a error really happens, golden output will diff in that case
If dd fails, then seqres will diff from expected output, and fstest will 
prompt you to check seqres.full, and you will find out the problem anyway.
IIRC, Dave taught me this in such case, where I add "|| _fail" after a 
dd command trying to catch error of dd.

So I don't see the need to add output for minority error case in golden 
output.
>
>> +cp --reflink $SCRATCH_MNT/subv1/file1 $SCRATCH_MNT/subv2/file1
>> +cp --reflink $SCRATCH_MNT/subv1/file1 $SCRATCH_MNT/subv3/file1
>> +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
>
> The sync vs btrfs specific sync is also something I used to do and
> Dave pointed it to me that it's always better to use standard/fs
> independent commands whenever possible.
>
> It wouldn't also hurt to add a comment or 2 here telling what's
> happening and specifically why the sync is needed before qgroup show
> is called.
Both point makes sense. I'll update soon.

Thanks,
Qu

>
> thanks
>
>> +
>> +units=`_btrfs_qgroup_units`
>> +$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' | \
>> +       $AWK_PROG '{print $2" "$3}'
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/btrfs/083.out b/tests/btrfs/083.out
>> new file mode 100644
>> index 0000000..359b4a0
>> --- /dev/null
>> +++ b/tests/btrfs/083.out
>> @@ -0,0 +1,5 @@
>> +QA output created by 083
>> +4096 4096
>> +266240 4096
>> +266240 4096
>> +266240 4096
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index fd2fa76..04d5d67 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -85,3 +85,4 @@
>>   080 auto snapshot
>>   081 auto quick clone
>>   082 auto quick remount
>> +083 auto quick qgroup
>> --
>> 2.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
