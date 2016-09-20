Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54248 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753014AbcITAdL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 20:33:11 -0400
Subject: Re: [PATCH] Btrfs: handle quota reserve failure properly
To: <dsterba@suse.cz>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        <linux-btrfs@vger.kernel.org>
References: <1473965868-9675-1-git-send-email-jbacik@fb.com>
 <pan$e2095$fbe056c8$f4eac82$cda700a2@applied-asynchrony.com>
 <20160919180845.GR16983@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <7d1bdc34-0148-0b76-7177-2a2c36a946b2@cn.fujitsu.com>
Date: Tue, 20 Sep 2016 08:33:08 +0800
MIME-Version: 1.0
In-Reply-To: <20160919180845.GR16983@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/20/2016 02:08 AM, David Sterba wrote:
> On Fri, Sep 16, 2016 at 09:02:22AM +0000, Holger Hoffstätte wrote:
>> On Thu, 15 Sep 2016 14:57:48 -0400, Josef Bacik wrote:
>>
>>> btrfs/022 was spitting a warning for the case that we exceed the quota.  If we
>>> fail to make our quota reservation we need to clean up our data space
>>> reservation.  Thanks,
>>>
>>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>>> ---
>>>  fs/btrfs/extent-tree.c | 9 +++------
>>>  1 file changed, 3 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 03da2f6..d72eaae 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -4286,13 +4286,10 @@ int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
>>>  	if (ret < 0)
>>>  		return ret;
>>>
>>> -	/*
>>> -	 * Use new btrfs_qgroup_reserve_data to reserve precious data space
>>> -	 *
>>> -	 * TODO: Find a good method to avoid reserve data space for NOCOW
>>> -	 * range, but don't impact performance on quota disable case.
>>> -	 */
>>> +	/* Use new btrfs_qgroup_reserve_data to reserve precious data space. */
>>>  	ret = btrfs_qgroup_reserve_data(inode, start, len);
>>> +	if (ret)
>>> +		btrfs_free_reserved_data_space_noquota(inode, start, len);
>>>  	return ret;
>>>  }
>>>
>>> --
>>> 2.7.4
>>
>> This came up before, though slightly different:
>> http://www.spinics.net/lists/linux-btrfs/msg56644.html
>>
>> Which version is correct - with or without _noquota ?
>
> Seems that it's the _noquota variant.

Josef and David is right, _noquota variant is more proper.

The case is, if the start, len range covers some already reserved range, 
then such free will also free such range.

Causing the reserved range being freed too early.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


