Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24451 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbAUFYv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Jan 2015 00:24:51 -0500
Message-ID: <54BF396A.9000101@oracle.com>
Date: Wed, 21 Jan 2015 13:30:18 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, fdmanana@gmail.com
Subject: Re: [PATCH v2] xfstests: btrfs: fix up 001.out
References: <1420055304-4633-1-git-send-email-anand.jain@oracle.com> <1420203869-26085-1-git-send-email-anand.jain@oracle.com> <20150121042627.GF16510@dastard>
In-Reply-To: <20150121042627.GF16510@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Dave,

On 01/21/2015 12:26 PM, Dave Chinner wrote:
> On Fri, Jan 02, 2015 at 09:04:29PM +0800, Anand Jain wrote:
>> The subvol delete output has changed with btrfs-progs
>>      -Delete subvolume 'SCRATCH_MNT/snap'
>>      +Delete subvolume (no-commit): 'SCRATCH_MNT/snap'
>>
>> so fix 001 failing.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>
>> v2: Thanks Filipe for mentioning now we have _run_btrfs_util_prog. and
>>      commit update
>> ---
>>   tests/btrfs/001     | 2 +-
>>   tests/btrfs/001.out | 1 -
>>   2 files changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/tests/btrfs/001 b/tests/btrfs/001
>> index 8258d06..a7747c8 100755
>> --- a/tests/btrfs/001
>> +++ b/tests/btrfs/001
>> @@ -99,7 +99,7 @@ echo "Listing subvolumes"
>>   $BTRFS_UTIL_PROG subvolume list $SCRATCH_MNT | awk '{ print $NF }'
>>
>>   # Delete the snapshot
>> -$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/snap | _filter_btrfs_subvol_delete
>> +_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap
>
> This is also the wrong way to fix the problem.
>
> We have output filters for a reason, people:

  actually I purposely discouraged using the output filters (instead use
  command exit code), mainly because output filters are
  unnecessary hindrance to the good changes. And UIs using btrfs-progs
  anyway has to depend on the exit code to check the command status,
  so we should rightfully check that in our test scripts, this may
  apply lightly for commands like show, but would fit well for commands
  like delete as in here. just my point of view.

Thanks,

> _filter_btrfs_subvol_delete()
> {
> 	_filter_scratch | _filter_transcation_commit_default
> }
>
> Simply becomes:
>
> _filter_btrfs_subvol_delete()
> {
> 	_filter_scratch | _filter_transcation_commit_default | \
> 		sed -e 's/^Delete subvolume.*:/Delete subvolume/'
> }
>
> The golden output does not change - the filter simply removes the
> part of the message that changed between versions.
>
> Cheers,
>
> Dave.
>
