Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41254 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933251AbcFMCJ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 22:09:56 -0400
Subject: Re: [PATCH v2] fstests: btrfs: add test for qgroup handle extent
 de-reference
To: Eryu Guan <eguan@redhat.com>
References: <1464763211-17762-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160611163804.GX5140@eguan.usersys.redhat.com>
CC: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>,
        <fdmanana@gmail.com>, <mfasheh@suse.de>
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Message-ID: <2472f26d-cb4f-ee5f-06f9-2c16cf3b1332@cn.fujitsu.com>
Date: Mon, 13 Jun 2016 10:09:43 +0800
MIME-Version: 1.0
In-Reply-To: <20160611163804.GX5140@eguan.usersys.redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At 06/12/2016 12:38 AM, Eryu Guan wrote:
> On Wed, Jun 01, 2016 at 02:40:11PM +0800, Lu Fengqi wrote:
>> Test if qgroup can handle extent de-reference during reallocation.
>> "extent de-reference" means that reducing an extent's reference count
>> or freeing an extent.
>> Although current qgroup can handle it, we still need to prevent any
>> regression which may break current qgroup.
>>
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> ---
>>  common/rc           |   4 +--
>>  tests/btrfs/028     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/028.out |   2 ++
>>  tests/btrfs/group   |   1 +
>>  4 files changed, 107 insertions(+), 2 deletions(-)
>>  create mode 100755 tests/btrfs/028
>>  create mode 100644 tests/btrfs/028.out
>>
>> diff --git a/common/rc b/common/rc
>> index 51092a0..650d198 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -3284,9 +3284,9 @@ _btrfs_get_profile_configs()
>>  # stress btrfs by running balance operation in a loop
>>  _btrfs_stress_balance()
>>  {
>> -	local btrfs_mnt=$1
>> +	local options=$@
>>  	while true; do
>> -		$BTRFS_UTIL_PROG balance start $btrfs_mnt
>> +		$BTRFS_UTIL_PROG balance start $options
>>  	done
>>  }
>>
>> diff --git a/tests/btrfs/028 b/tests/btrfs/028
>> new file mode 100755
>> index 0000000..04a3508
>> --- /dev/null
>> +++ b/tests/btrfs/028
>> @@ -0,0 +1,102 @@
>> +#! /bin/bash
>> +# FS QA Test 028
>> +#
>> +# Test if qgroup can handle extent de-reference during reallocation.
>> +# "extent de-reference" means that reducing an extent's reference count
>> +# or freeing an extent.
>> +# Although current qgroup can handle it, we still need to prevent any
>> +# regression which may break current qgroup.
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2016 Fujitsu. All Rights Reserved.
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
>> +status=1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch
>> +
>> +# Currently in btrfs the node/leaf size can not be smaller than the page
>> +# size (but it can be greater than the page size). So use the largest
>> +# supported node/leaf size (64Kb) so that the test can run on any platform
>> +# that Linux supports.
>> +_scratch_mkfs "--nodesize 64k"
>
> I'm not sure if this is necessary, wouldn't mkfs.btrfs pick the proper
> node/leaf size according to the platform at mkfs time?
>
> Thanks,
> Eryu
>
>

Yes, you're right. I check the output of `btrfs qgroup show ` command in 
the previous version, so I need a fixed nodesize. Now it is not 
necessary, I will update this patch and cc you.

-- 
Thanks,
Lu


