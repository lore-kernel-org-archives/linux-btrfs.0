Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53286 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752496AbeBFJSn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Feb 2018 04:18:43 -0500
Subject: Re: [PATCH] btrfs: Add enospc_debug printing in
 metadata_reserve_bytes
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1513332337-7068-1-git-send-email-nborisov@suse.com>
 <fd31d262-3b22-dbc0-6315-3ce734334625@suse.com>
 <b905db35-f6c6-2de3-f1fb-154d697cc747@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4317cffa-e7ef-6ded-dfd8-68ccfb84fe55@suse.com>
Date: Tue, 6 Feb 2018 11:18:41 +0200
MIME-Version: 1.0
In-Reply-To: <b905db35-f6c6-2de3-f1fb-154d697cc747@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  6.02.2018 03:29, Qu Wenruo wrote:
> 
> 
> On 2018年02月06日 00:20, Nikolay Borisov wrote:
>>
>>
>> On 15.12.2017 12:05, Nikolay Borisov wrote:
>>> Currently when enoscp_debug mount option is turned on we do not print
>>> any debug info in case metadata reservation failures happen. Fix this
>>> by adding the necessary hook in reserve_metadata_bytes.
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Looks good.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Yeah you already reviewed it back in December, I was bumping it to make
sure David won't miss it since it's a rather old patch :)

> 
> Thanks,
> Qu
> 
>>> ---
>>>  fs/btrfs/extent-tree.c | 7 ++++++-
>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 4497f937e8fb..7a281fc97bc5 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -5382,10 +5382,15 @@ static int reserve_metadata_bytes(struct btrfs_root *root,
>>>  		    !block_rsv_use_bytes(global_rsv, orig_bytes))
>>>  			ret = 0;
>>>  	}
>>> -	if (ret == -ENOSPC)
>>> +	if (ret == -ENOSPC) {
>>>  		trace_btrfs_space_reservation(fs_info, "space_info:enospc",
>>>  					      block_rsv->space_info->flags,
>>>  					      orig_bytes, 1);
>>> +
>>> +		if (btrfs_test_opt(fs_info, ENOSPC_DEBUG))
>>> +			dump_space_info(fs_info, block_rsv->space_info,
>>> +					orig_bytes, 0);
>>> +	}
>>>  	return ret;
>>>  }
>>>  
>>>
>>
>> Ping
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
