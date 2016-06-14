Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8222 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751834AbcFNJIn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 05:08:43 -0400
Subject: Re: [PATCH v3] fstests: btrfs: add test for qgroup handle extent
 de-reference
To: <fdmanana@gmail.com>
References: <1465783850-13501-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160613030449.GI5140@eguan.usersys.redhat.com>
 <196ba573-3f1b-753b-42ad-988054283fe6@cn.fujitsu.com>
 <57a95603-0abf-583b-9c73-43fe4f3f97a7@cn.fujitsu.com>
 <CAL3q7H4THn_ErZUxzSo+nSjcxbMBmcA4c45bsmjKHH_Bj4rOxQ@mail.gmail.com>
 <b27737d1-fe46-a33c-c7e7-433dd5ad2cdb@cn.fujitsu.com>
 <CAL3q7H5BL5pt9k9J088D0_5gH6rNRVNU1oOaKruaWnuKvJOWAg@mail.gmail.com>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Eryu Guan <eguan@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <fstests@vger.kernel.org>, Mark Fasheh <mfasheh@suse.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a0702b7d-caee-f436-e820-50bb2d3e9776@cn.fujitsu.com>
Date: Tue, 14 Jun 2016 17:08:35 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5BL5pt9k9J088D0_5gH6rNRVNU1oOaKruaWnuKvJOWAg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/14/2016 04:41 PM, Filipe Manana wrote:
> On Tue, Jun 14, 2016 at 1:58 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> At 06/13/2016 05:49 PM, Filipe Manana wrote:
>>>
>>> On Mon, Jun 13, 2016 at 9:06 AM, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>> wrote:
>>>>
>>>> At 06/13/2016 03:29 PM, Lu Fengqi wrote:
>>>>>
>>>>>
>>>>> At 06/13/2016 11:04 AM, Eryu Guan wrote:
>>>>>>
>>>>>>
>>>>>> On Mon, Jun 13, 2016 at 10:10:50AM +0800, Lu Fengqi wrote:
>>>>>>>
>>>>>>>
>>>>>>> Test if qgroup can handle extent de-reference during reallocation.
>>>>>>> "extent de-reference" means that reducing an extent's reference count
>>>>>>> or freeing an extent.
>>>>>>> Although current qgroup can handle it, we still need to prevent any
>>>>>>> regression which may break current qgroup.
>>>>>>>
>>>>>>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>>>>>> ---
>>>>>>>  common/rc           |  4 +--
>>>>>>>  tests/btrfs/028     | 98
>>>>>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>>  tests/btrfs/028.out |  2 ++
>>>>>>>  tests/btrfs/group   |  1 +
>>>>>>>  4 files changed, 103 insertions(+), 2 deletions(-)
>>>>>>>  create mode 100755 tests/btrfs/028
>>>>>>>  create mode 100644 tests/btrfs/028.out
>>>>>>>
>>>>>>> diff --git a/common/rc b/common/rc
>>>>>>> index 51092a0..650d198 100644
>>>>>>> --- a/common/rc
>>>>>>> +++ b/common/rc
>>>>>>> @@ -3284,9 +3284,9 @@ _btrfs_get_profile_configs()
>>>>>>>  # stress btrfs by running balance operation in a loop
>>>>>>>  _btrfs_stress_balance()
>>>>>>>  {
>>>>>>> -    local btrfs_mnt=$1
>>>>>>> +    local options=$@
>>>>>>>      while true; do
>>>>>>> -        $BTRFS_UTIL_PROG balance start $btrfs_mnt
>>>>>>> +        $BTRFS_UTIL_PROG balance start $options
>>>>>>>      done
>>>>>>>  }
>>>>>>>
>>>>>>> diff --git a/tests/btrfs/028 b/tests/btrfs/028
>>>>>>> new file mode 100755
>>>>>>> index 0000000..8cea49a
>>>>>>> --- /dev/null
>>>>>>> +++ b/tests/btrfs/028
>>>>>>> @@ -0,0 +1,98 @@
>>>>>>> +#! /bin/bash
>>>>>>> +# FS QA Test 028
>>>>>>> +#
>>>>>>> +# Test if qgroup can handle extent de-reference during reallocation.
>>>>>>> +# "extent de-reference" means that reducing an extent's reference
>>>>>>> count
>>>>>>> +# or freeing an extent.
>>>>>>> +# Although current qgroup can handle it, we still need to prevent any
>>>>>>> +# regression which may break current qgroup.
>>>>>>> +#
>>>>>>>
>>>>>>>
>>>>>>> +#-----------------------------------------------------------------------
>>>>>>>
>>>>>>> +# Copyright (c) 2016 Fujitsu. All Rights Reserved.
>>>>>>> +#
>>>>>>> +# This program is free software; you can redistribute it and/or
>>>>>>> +# modify it under the terms of the GNU General Public License as
>>>>>>> +# published by the Free Software Foundation.
>>>>>>> +#
>>>>>>> +# This program is distributed in the hope that it would be useful,
>>>>>>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>>>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>>>> +# GNU General Public License for more details.
>>>>>>> +#
>>>>>>> +# You should have received a copy of the GNU General Public License
>>>>>>> +# along with this program; if not, write the Free Software
>>>>>>> Foundation,
>>>>>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>>>>>>
>>>>>>>
>>>>>>> +#-----------------------------------------------------------------------
>>>>>>>
>>>>>>> +#
>>>>>>> +
>>>>>>> +seq=`basename $0`
>>>>>>> +seqres=$RESULT_DIR/$seq
>>>>>>> +echo "QA output created by $seq"
>>>>>>> +
>>>>>>> +here=`pwd`
>>>>>>> +tmp=/tmp/$$
>>>>>>> +status=1    # failure is the default!
>>>>>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>>>>>> +
>>>>>>> +_cleanup()
>>>>>>> +{
>>>>>>> +    cd /
>>>>>>> +    rm -f $tmp.*
>>>>>>> +}
>>>>>>> +
>>>>>>> +# get standard environment, filters and checks
>>>>>>> +. ./common/rc
>>>>>>> +. ./common/filter
>>>>>>> +
>>>>>>> +# remove previous $seqres.full before test
>>>>>>> +rm -f $seqres.full
>>>>>>> +
>>>>>>> +# real QA test starts here
>>>>>>> +_supported_fs btrfs
>>>>>>> +_supported_os Linux
>>>>>>> +_require_scratch
>>>>>>> +
>>>>>>> +_scratch_mkfs
>>>>>>> +_scratch_mount
>>>>>>> +
>>>>>>> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
>>>>>>> +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
>>>>>>> +
>>>>>>> +# Increase the probability of generating de-refer extent, and
>>>>>>> decrease
>>>>>>> +# other.
>>>>>>> +args=`_scale_fsstress_args -z \
>>>>>>> +    -f write=10 -f unlink=10 \
>>>>>>> +    -f creat=10 -f fsync=10 \
>>>>>>> +    -f fsync=10 -n 100000 -p 2 \
>>>>>>> +    -d $SCRATCH_MNT/stress_dir`
>>>>>>> +echo "Run fsstress $args" >>$seqres.full
>>>>>>> +$FSSTRESS_PROG $args >/dev/null 2>&1 &
>>>>>>> +fsstress_pid=$!
>>>>>>> +
>>>>>>> +echo "Start balance" >>$seqres.full
>>>>>>> +_btrfs_stress_balance -d $SCRATCH_MNT >/dev/null 2>&1 &
>>>>>>> +balance_pid=$!
>>>>>>> +
>>>>>>> +# 30s is enough to trigger bug
>>>>>>> +sleep $((30*$TIME_FACTOR))
>>>>>>> +kill $fsstress_pid $balance_pid
>>>>>>> +wait
>>>>>>> +
>>>>>>> +# kill _btrfs_stress_balance can't end balance, so call btrfs
>>>>>>> balance cancel
>>>>>>> +# to cancel running or paused balance.
>>>>>>> +$BTRFS_UTIL_PROG balance cancel $SCRATCH_MNT &> /dev/null
>>>>>>> +
>>>>>>> +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
>>>>>>> +
>>>>>>> +_scratch_unmount
>>>>>>> +
>>>>>>> +# generate a qgroup report and look for inconsistent groups
>>>>>>> +$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV 2>&1 | \
>>>>>>> +            grep -q -E "Counts for qgroup.*are different"
>>>>>>> +if [ $? -ne 0 ]; then
>>>>>>> +    echo "Silence is golden"
>>>>>>> +    # success, all done
>>>>>>> +    status=0
>>>>>>> +fi
>>>>>>
>>>>>>
>>>>>>
>>>>>> I'm testing with 4.7-rc1 kernel and btrfs-progs v4.4, this test fails,
>>>>>> which means btrfs check finds inconsistent groups. But according to
>>>>>> your
>>>>>> commit log, current kernel should pass the test. So is the failure
>>>>>> expected?
>>>>>>
>>>>>> Also, just grep for different qgroup counts and print the message out
>>>>>> if
>>>>>> grep finds the message, so it breaks golden image on error and we know
>>>>>> something really goes wrong. Right now test fails just because of
>>>>>> missing "Silence is golden", which is unclear why it fails:
>>>>>>
>>>>>>  @@ -1,2 +1 @@
>>>>>>   QA output created by 028
>>>>>>  -Silence is golden
>>>>>>
>>>>>> Do the following instead:
>>>>>>
>>>>>>     $BTRFS_UTIL_PROG check ... | grep -E "..."
>>>>>>     echo "Silence is golden"
>>>>>>     status=0
>>>>>>     exit
>>>>>>
>>>>>> And we see this on failure:
>>>>>>
>>>>>>  @@ -1,2 +1,3 @@
>>>>>>   QA output created by 028
>>>>>>  +Counts for qgroup id: 5 are different
>>>>>>   Silence is golden
>>>>>>
>>>>>> Thanks,
>>>>>> Eryu
>>>>>>
>>>>>>> +
>>>>>>> +exit
>>>>>>> diff --git a/tests/btrfs/028.out b/tests/btrfs/028.out
>>>>>>> new file mode 100644
>>>>>>> index 0000000..2615f73
>>>>>>> --- /dev/null
>>>>>>> +++ b/tests/btrfs/028.out
>>>>>>> @@ -0,0 +1,2 @@
>>>>>>> +QA output created by 028
>>>>>>> +Silence is golden
>>>>>>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>>>>>>> index da0e27f..35ecf59 100644
>>>>>>> --- a/tests/btrfs/group
>>>>>>> +++ b/tests/btrfs/group
>>>>>>> @@ -30,6 +30,7 @@
>>>>>>>  025 auto quick send clone
>>>>>>>  026 auto quick compress prealloc
>>>>>>>  027 auto replace
>>>>>>> +028 auto qgroup balance
>>>>>>>  029 auto quick clone
>>>>>>>  030 auto quick send
>>>>>>>  031 auto quick subvol clone
>>>>>>> --
>>>>>>> 2.5.5
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>> Excuse me, I tried several versions of the kernel (4.6-rc7+ / 4.7-rc1 /
>>>>> 4.7-rc3), the test didn't fail. Can you provide me with more information
>>>>> about your test environment?
>>>>>
>>>>>
>>>> Sorry, this test fails after I perform it more times. It seems to be a
>>>> bug
>>>> of btrfs qgroup. We will continue to track this bug.
>>>
>>>
>>> Which is already known and reported some time ago:
>>>
>>> http://thread.gmane.org/gmane.comp.file-systems.btrfs/56687/focus=56824
>>>
>>> It's another regression introduced in kernel 4.2 with the large
>>> qgroups rewrite (data extents are not accounted anymore after
>>> balance).
>>> It's trivial to reproduce with:
>>>
>>>
>>> #!/bin/bash -x
>>>
>>> MNT="/mnt/sdi"
>>> DEV="/dev/sdi"
>>>
>>> mkfs.btrfs --nodesize=4096 -f $DEV
>>> mount -t btrfs $DEV $MNT
>>>
>>> # fill metadata space, create a tree with 1 node and 2 leaves
>>> for ((i = 1; i <= 10; i++)); do
>>>         mkdir $MNT/d$i
>>> done
>>> for ((i = 1; i <= 1; i++)); do
>>>         xfs_io -f -c "pwrite -S 0xaa 0 8K" $MNT/f$i
>>> done
>>>
>>> btrfs fi sync $MNT
>>> btrfs quota enable $MNT
>>> btrfs quota rescan -w $MNT
>>> btrfs qg show $MNT
>>>
>>> umount $MNT
>>> btrfsck $DEV
>>>
>>> mount -t btrfs $DEV $MNT
>>>
>>> time btrfs balance start -d $MNT
>>>
>>> umount $MNT
>>> btrfsck $DEV
>>
>> Yes, we also found this internally.
>>
>> And the direct cause is already located.
>>
>> The direct cause is, we're increasing new data extents' reference even the
>> referencer(fs tree) is still referring to old extents.
>>
>> If using ftrace to trace add/run_delayed_data_ref() and
>> qgroup_account_extent(), one should find that, new data extents' reference
>> is increased with both data reloc tree and final referencer.(fs tree in the
>> test script).
>>
>> In that timing, backref walk can't find any root referring the new data
>> extents.
>> The data reloc tree is the current referencer, but qgroup won't account data
>> reloc tree.
>> While new data extents have fs tree backref, fs tree still refers to the old
>> extent. So backref walk won't count it either.
>>
>> And the commit_trans before we really merges reloc roots makes the
>> accounting wrong.
>>
>> So it seems to be an existing problem before the qgroup rework.
>
> How can it be an existing problem before the qgroup rework if this
> example (and others more complex involving snapshots and a large
> number of data extents) worked on 4.1 and previous kernels?

Because in old kernels, backref walk is unreliable, especially for such 
tricky tree block swap thing.

As you can see, it's very obvious that, while fs tree is still referring 
to the old extent, it's never possible to get nr_old/new_roots to 
anything other than 0 for new extent.

So for old kernels, either backref walk got wrong(as it just happend), 
or it doesn't go through qgroup accounting at all.

Thanks,
Qu

>
>
>
>>
>> The quick fix won't be hard, just re-dirty the new data extent at
>> merge_reloc_roots() time.
>>
>> But I'm still investigating if we can fix it in a better method, to increase
>> the new data extents' reference at correct time.
>>
>> Thanks,
>> Qu
>>
>>
>>>
>>>
>>> Also, please, when you send a new version of a patch, add a changelog
>>> describing what changed between versions. See [1] for an example.
>>> I noticed you do this for all patches you send.
>>>
>>> [1]
>>> https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Repeated_submissions
>>>
>>>>
>>>>
>>>> --
>>>> Thanks,
>>>> Lu
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>>
>>
>>
>
>
>


