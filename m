Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45672 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932408AbeCVOUr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 10:20:47 -0400
Subject: Re: [PATCH] btrfs: Validate child tree block's level and first key
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180319091841.18603-1-wqu@suse.com>
 <20180322134058.GA6955@twin.jikos.cz>
 <806f4931-f224-7168-f4c2-b08af0a05278@gmx.com>
 <20180322140041.GB6955@twin.jikos.cz>
 <1cecd52c-74f5-5c2b-73ba-c5b817bbe18f@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <47bb1e1a-97f2-817c-7b80-6190cc5da18e@suse.com>
Date: Thu, 22 Mar 2018 16:20:45 +0200
MIME-Version: 1.0
In-Reply-To: <1cecd52c-74f5-5c2b-73ba-c5b817bbe18f@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.03.2018 16:17, Qu Wenruo wrote:
> 
> 
> On 2018年03月22日 22:00, David Sterba wrote:
>> On Thu, Mar 22, 2018 at 09:53:46PM +0800, Qu Wenruo wrote:
>>>>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>>>>> index 26484648d090..3866b8ab20f1 100644
>>>>> --- a/fs/btrfs/backref.c
>>>>> +++ b/fs/btrfs/backref.c
>>>>> @@ -738,7 +738,8 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
>>>>>  		BUG_ON(ref->key_for_search.type);
>>>>>  		BUG_ON(!ref->wanted_disk_byte);
>>>>>  
>>>>> -		eb = read_tree_block(fs_info, ref->wanted_disk_byte, 0);
>>>>> +		eb = read_tree_block(fs_info, ref->wanted_disk_byte, 0, NULL,
>>>>> +				     0);
>>>>
>>>> Please add 2nd function that will take the extended parameters and
>>>> keep read_tree_block as is.
>>>
>>> So for any new caller of read_tree_block(), reviewer is the last person
>>> to info the author to use these parameters for safety check?
>>>
>>> And in fact, the old function should be avoid if possible, I think the
>>> new parameters act as a pretty good sign to make any caller double think
>>> about this.
>>
>> I saw half of the new parameters were just 0, NULL, so this looks like a
>> lot of code churn and I haven't looked closer if there's a chance to
>> fill the parameters in all callsites. So if it's a matter of adding them
>> incrementally then fine.
>>
> I'm afraid some of the call sites (ones I left with NULL, 0) are unable
> to pass the new parameters by its nature.
> 
> Such callers include:
> 1) Tree root
>    Just @bytenr and @gen from ROOT_ITEM. No @first_key.
> 
> 2) Backref walker for FULL_BACKREF
>    Only parent bytenr, no extra info on @first_key.
> 
> But despite of such call sites, every top-down reader should grab first
> key and level. (And so I did in the patch).
> 
> BTW, about half of the read_tree_block() callers are using the new
> parameters.
> So a new function seems a little embarrassing here.


Is it possible to centralise those checks in the read tree verifier,
rather than sprinkling them around the code?

> 
> Thanks,
> Qu
> 
