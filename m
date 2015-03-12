Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2323 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbbCLMtN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 08:49:13 -0400
Message-ID: <55018B3C.6070104@fb.com>
Date: Thu, 12 Mar 2015 08:49:00 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <fstests@vger.kernel.org>
Subject: Re: [PATCH] fstest: btrfs/083: Test for incorrect exclusive refernce
 number after file clone.
References: <1425973594-31936-1-git-send-email-quwenruo@cn.fujitsu.com> <CAL3q7H54-k-MEZnNzZn8Pyc6YH3okp+LUrncbMR=Kq6q5_xd7w@mail.gmail.com>
In-Reply-To: <CAL3q7H54-k-MEZnNzZn8Pyc6YH3okp+LUrncbMR=Kq6q5_xd7w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/12/2015 08:38 AM, Filipe David Manana wrote:
> On Tue, Mar 10, 2015 at 7:46 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
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
>>   tests/btrfs/083     | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/083.out |  5 ++++
>>   tests/btrfs/group   |  1 +
>>   3 files changed, 82 insertions(+)
>>   create mode 100755 tests/btrfs/083
>>   create mode 100644 tests/btrfs/083.out
>>
>> diff --git a/tests/btrfs/083 b/tests/btrfs/083
>> new file mode 100755
>> index 0000000..17fd30b
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
> --nodesize 65536
> Otherwise the test fails (unnecessarily) on platforms with a page size > 4Kb.
>

Leave this bit, we're going to merge the sub-page blocksize stuff soon 
anyway, and it makes the numbers add up easier for qgroup stuff.

>> +
>> +# inode cache will also take space in fs tree, disable them to get consistent
>> +# result.
>> +run_check _scratch_mount "-o noinode_cache"
>
> -o noinode_cache, unlike -o inode_cache, is still a relatively new
> mount option (early 2014). Won't the test fail on older kernels that
> don't recognize this mount option?

Yeah but my qgroup patch wasnt in until late last year anyway, we're not 
super worried about older kernels failing tests, we already know they're 
broken.  The other comments are fine.  Thanks,

Josef
