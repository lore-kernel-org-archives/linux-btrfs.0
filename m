Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57235 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755298AbaEICNZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 May 2014 22:13:25 -0400
From: Josef Bacik <jbacik@fb.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] xfstests/btrfs: add qgroup rescan stress test
Date: Fri, 9 May 2014 02:13:01 +0000
Message-ID: <xmifb9cukl6cxjty7n8malrf.1399601580721@email.android.com>
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <536A9E73.90802@fb.com> <536AFC3B.7070502@cn.fujitsu.com>
 <536BCDF7.7070404@fb.com>,<536C2C99.6020506@cn.fujitsu.com>
In-Reply-To: <536C2C99.6020506@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The inode cache is saved in the FS tree itself for every individual FS tree, that affects the sizes reported by qgroup show so we need to explicitly turn it off to get consistent values.  Thanks,

Josef

Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:


On 05/09/2014 02:33 AM, Josef Bacik wrote:
> On 05/07/2014 11:38 PM, Wang Shilong wrote:
>> On 05/08/2014 04:58 AM, Josef Bacik wrote:
>>> On 03/09/2014 11:44 PM, Wang Shilong wrote:
>>>> Test flow is to run fsstress after triggering quota rescan.
>>>> the ruler is simple, we just remove all files and directories,
>>>> sync filesystem and see if qgroup's ref and excl are nodesize.
>>>>
>>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>> ---
>>>> v1->v2:
>>>>     switch into new helper _run_btrfs_util_prog()
>>>> ---
>>>>   tests/btrfs/041     | 76
>>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>   tests/btrfs/041.out |  3 +++
>>>>   tests/btrfs/group   |  1 +
>>>>   3 files changed, 80 insertions(+)
>>>>   create mode 100644 tests/btrfs/041
>>>>   create mode 100644 tests/btrfs/041.out
>>>>
>>>> diff --git a/tests/btrfs/041 b/tests/btrfs/041
>>>> new file mode 100644
>>>> index 0000000..92bd080
>>>> --- /dev/null
>>>> +++ b/tests/btrfs/041
>>>> @@ -0,0 +1,76 @@
>>>> +#! /bin/bash
>>>> +# FSQA Test No. btrfs/041
>>>> +#
>>>> +# Quota rescan stress test, we run fsstress and quota rescan
>>>> concurrently
>>>> +#
>>>> +#-----------------------------------------------------------------------
>>>>
>>>>
>>>> +# Copyright (C) 2014 Fujitsu.  All rights reserved.
>>>> +#
>>>> +# This program is free software; you can redistribute it and/or
>>>> +# modify it under the terms of the GNU General Public License as
>>>> +# published by the Free Software Foundation.
>>>> +#
>>>> +# This program is distributed in the hope that it would be useful,
>>>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> +# GNU General Public License for more details.
>>>> +#
>>>> +# You should have received a copy of the GNU General Public License
>>>> +# along with this program; if not, write the Free Software
>>>> Foundation,
>>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
>>>> +#
>>>> +#-----------------------------------------------------------------------
>>>>
>>>>
>>>> +#
>>>> +
>>>> +seq=`basename $0`
>>>> +seqres=$RESULT_DIR/$seq
>>>> +echo "QA output created by $seq"
>>>> +
>>>> +here=`pwd`
>>>> +tmp=/tmp/$$
>>>> +status=1
>>>> +
>>>> +_cleanup()
>>>> +{
>>>> +    cd /
>>>> +    rm -f $tmp.*
>>>> +}
>>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>>> +
>>>> +# get standard environment, filters and checks
>>>> +. ./common/rc
>>>> +. ./common/filter
>>>> +
>>>> +# real QA test starts here
>>>> +_need_to_be_root
>>>> +_supported_fs btrfs
>>>> +_supported_os Linux
>>>> +_require_scratch
>>>> +
>>>> +rm -f $seqres.full
>>>> +
>>>> +run_check _scratch_mkfs "-b 1g --nodesize 4096"
>>>> +run_check _scratch_mount
>>>> +
>>>
>>> Add "-o nospace_cache" here please, otherwise I don't get the same
>>> output.
>>
>> I am little confused why we need specify this mount option explicitly?
>> As far as i know, space cache is not included into qgroup accounting
>> space.
>>
>
> It is.  Thanks,
Free space cache are inserted in tree root, they can not be shared with
other trees(fs/file tree).
So normal fs/file tree's qgroup accounting is independeng of free space
cache.

With or without the option, subvolume qgroup's value should not have any
differences.
Did i miss something here?:-)

Thanks,
Wang
>
> Josef
>
> .
>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  https://urldefense.proofpoint.com/v1/url?u=http://vger.kernel.org/majordomo-info.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=G4HqImi%2Fy7KWWbAvCZf%2Bl8CSV3XzU9ODKrgtdQCTPYQ%3D%0A&s=e27422f119365ab04dddfb06e08c152eec84c4de29e19b6811310607e6a15c99
