Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16128 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756392AbbHZHVP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 03:21:15 -0400
Subject: Re: [PATCH v5] fstests: btrfs: Add reserved space leak check for
 rewrite dirty page
To: Eryu Guan <eguan@redhat.com>
References: <1440119834-31504-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150826064146.GS17933@dhcp-13-216.nay.redhat.com>
CC: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55DD68E8.2020702@cn.fujitsu.com>
Date: Wed, 26 Aug 2015 15:21:12 +0800
MIME-Version: 1.0
In-Reply-To: <20150826064146.GS17933@dhcp-13-216.nay.redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Eryu Guan wrote on 2015/08/26 14:41 +0800:
> On Fri, Aug 21, 2015 at 09:17:14AM +0800, Qu Wenruo wrote:
>> Btrfs qgroup reserve codes lacks check for rewrite dirty page, causing
>> every write, even rewriting a uncommitted dirty page, to reserve space.
>>
>> But only written data will free the reserved space, causing reserved
>> space leaking.
>>
>> The bug exists almost from the beginning of btrfs qgroup codes, but
>> nobody found it.
>>
>> For example:
>>
>> 1)Write [0, 12K) into file A
>>    reserve 12K space
>>
>> File A:
>> 0	4K	8K	12K
>> |<--------dirty-------->|
>> reserved: 12K
>>
>> 2)Write [0,4K) into file A
>> 0	4K	8K	12K
>> |<--------dirty-------->|
>> reserved: 16K <<< Should be 12K
>>
>> 3) Commit transaction
>> Dirty pages [0,12) written to disk.
>> Free 12K reserved space.
>> reserved: 4K <<< Should be 0
>>
>> This testcase will test such problem.
>> Kernel fix will need some huge change, so won't be soon.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>> ---
>> Changelog:
>> v2:
>>    Use smaller write size inside loop, in case commit is trigger by dirty
>>    page threshold, and ensure following write won't trigger EQUOT
>> v3:
>>    Add more comments and fix some expression.
>> v4:
>>    Rebase to latest fstests.
>> v5:
>>    Use larger number to avoid conflicts with the test from Filipe Manana.
>> ---
>>   tests/btrfs/099     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/btrfs/099.out | 13 ++++++++
>>   tests/btrfs/group   |  1 +
>>   3 files changed, 100 insertions(+)
>>   create mode 100755 tests/btrfs/099
>>   create mode 100644 tests/btrfs/099.out
>>
>> diff --git a/tests/btrfs/099 b/tests/btrfs/099
>> new file mode 100755
>> index 0000000..ba531e1
>> --- /dev/null
>> +++ b/tests/btrfs/099
>> @@ -0,0 +1,86 @@
>> +#! /bin/bash
>> +# FS QA Test 099
>> +#
>> +# Check for qgroup reserved space leaks caused by re-writing dirty ranges
>> +# This bug has been present in btrfs qgroup for a long time
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
>> +# real QA test starts here
>> +
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch
>> +_need_to_be_root
>> +
>> +# Use big blocksize to ensure there is still enough space left for metadata
>> +# space reserve.
>> +BLOCKSIZE=$(( 2 * 1024 * 1024 )) # 2M block size
>> +FILESIZE=$(( 128 * 1024 * 1024 )) # 128M file size
>> +
>> +_scratch_mkfs >> $seqres.full 2>&1
>
> Just one minor issue here, please remove $seqres.full before test,
> otherwise $seqres.full will keep growing.
>
> Thanks,
> Eryu
>
Oh, you're right.
I did forgot to remove it.

BTW, is it better to add 'rm $seqres.full' to the template?

Thanks,
Qu
