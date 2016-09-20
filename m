Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33928 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750922AbcITAgn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 20:36:43 -0400
Subject: Re: [PATCH] Btrfs: handle quota reserve failure properly
To: Jeff Mahoney <jeffm@suse.com>, Josef Bacik <jbacik@fb.com>,
        <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
References: <1473965868-9675-1-git-send-email-jbacik@fb.com>
 <d4cc1bae-bbfa-e29c-9eeb-75f7cc1876fe@suse.com>
From: Chris Mason <clm@fb.com>
Message-ID: <eecbcd7c-3363-9c8a-01a1-c5951f17e3de@fb.com>
Date: Mon, 19 Sep 2016 20:35:04 -0400
MIME-Version: 1.0
In-Reply-To: <d4cc1bae-bbfa-e29c-9eeb-75f7cc1876fe@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/19/2016 02:50 PM, Jeff Mahoney wrote:
> On 9/15/16 2:57 PM, Josef Bacik wrote:
>> btrfs/022 was spitting a warning for the case that we exceed the quota.  If we
>> fail to make our quota reservation we need to clean up our data space
>> reservation.  Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>>  fs/btrfs/extent-tree.c | 9 +++------
>>  1 file changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 03da2f6..d72eaae 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -4286,13 +4286,10 @@ int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
>>  	if (ret < 0)
>>  		return ret;
>>
>> -	/*
>> -	 * Use new btrfs_qgroup_reserve_data to reserve precious data space
>> -	 *
>> -	 * TODO: Find a good method to avoid reserve data space for NOCOW
>> -	 * range, but don't impact performance on quota disable case.
>> -	 */
>> +	/* Use new btrfs_qgroup_reserve_data to reserve precious data space. */
>>  	ret = btrfs_qgroup_reserve_data(inode, start, len);
>> +	if (ret)
>> +		btrfs_free_reserved_data_space_noquota(inode, start, len);
>>  	return ret;
>>  }
>>
>>
>
> Tested-by: Jeff Mahoney <jeffm@suse.com>
>
> btrfs/022 passes now.
>

Thanks guys, I'll get this in for -final.

-chris

