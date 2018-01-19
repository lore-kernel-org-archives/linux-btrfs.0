Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754836AbeASKVH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 05:21:07 -0500
Subject: Re: [PATCH v2 2/3] btrfs-progs: dir-item: Don't do extra filetype
 validaction check for btrfs_match_dir_item_name
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180119072536.22286-1-wqu@suse.com>
 <20180119072536.22286-3-wqu@suse.com>
 <56ce96dd-a711-c19e-b0b7-df65d305c763@suse.com>
 <cf26e3d3-61c4-2086-4414-64b5a004c0f7@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <36928b14-2f3b-d072-de63-fb79a1734ea7@suse.com>
Date: Fri, 19 Jan 2018 12:21:05 +0200
MIME-Version: 1.0
In-Reply-To: <cf26e3d3-61c4-2086-4414-64b5a004c0f7@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.01.2018 12:03, Qu Wenruo wrote:
> 
> 
> On 2018年01月19日 17:40, Nikolay Borisov wrote:
>>
>>
>> On 19.01.2018 09:25, Qu Wenruo wrote:
>>> btrfs_match_dir_item_name() will check if its filetype is valid before
>>> doing search, this makes btrfs-progs unable to locate and remove invalid
>>> dir_index for btrfs_unlink().>
>>> This function only affects btrfs_link() and btrfs_unlink() in upper
>>> layer, and normal check can find invalid filetype by itself.
>>
>> There is no function btrfs_link in btrfs-progs, there is, however,
>> btrfs_add_link did you mean that function?
> 
> Yep, sorry for the wrong name.
> 
>> However, it doesn't seem to
>> use verify_dir_item hence the check you are removing. I think this part
>> of the commit log should be more precise. Also it's not really clear
>> what you mean by "normal check" in this sentence.
> 
> I skipped several function calls.
> 
> btrfs_add_link()
> |- check_dir_conflict
>    |- btrfs_lookup_dir_index() / btrfs_lookup_dir_item()
>       |- btrfs_match_dir_item_name()
>          |- verify_dir_item()
> 
> And for btrfs_add_link() without checking invalid filetype, we can avoid
> case like inserting duplicated DIR_ITEM/DIR_INDEX to avoid further
> screwing up things.

Right, since if verify_dir_item fails we just return NULL as opposed to
an error from btrfs_match_dir_item_name.

<offtopic>
Hm, so is it really possible to get a result for (key DIR_ITEM offset)
and have btrfs_match_dir_item_name fail for that result?

What I'm getting is that if btrfs_Search_slot returns 0 for such a query
irrespective of whether the string name matches or not we should return
some error code other than NULL ?
</offtopic>


> 
> For btrfs_unlink() it will be different story, as btrfs_unlink() can
> locate the conflicting but invalid DIR_ITEM/DIR_INDEX and remove it,
> allow us to fix the problem.
> 
> And by "normal check" I mean btrfs check.
> 
> I'll add the call trace to it.
> 
>>>
>>> So remove the filetype check is completely safe in this case, and will
>>> enhance btrfs_unlink() to remove invalid dir_index/dir_item for repair.
>>
>> So the problem is that since btrfs_unlink calls verify_item and the
>> latter has the filetype check in case of wrong filetype (corruption)
>> verify_dir_item fails, hence we cannot perform the unlink? If my
>> understanding is correct how about something like:
>>
>>
>> If we have a corrupted dir item and enough information to repair it we
>> need to first delete the old/corrupted version and then insert a new
>> one.
>> However, btrfs_unlink calls btrfs_match_dir_item_name to locate the
>> offending dir item for deletion. The latter, in turn, uses
>> verify_dir_item which checks if the value for DIR item's type is sane.
>> In case of a corrupted type value then verify_dir_item will fail which
>> in turn will prevent btrfs_unlink from deleting the offending item.
> 
> Your understanding is completely right, and much shorter than my planned
> explanation.
> 
> I'll take it with extra call trace.
> 
> Thanks,
> Qu
> 
>>
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  dir-item.c | 6 ------
>>>  1 file changed, 6 deletions(-)
>>>
>>> diff --git a/dir-item.c b/dir-item.c
>>> index 462546c0eaf4..e0a0ab4d7a5d 100644
>>> --- a/dir-item.c
>>> +++ b/dir-item.c
>>> @@ -294,12 +294,6 @@ static int verify_dir_item(struct btrfs_root *root,
>>>  	u16 namelen = BTRFS_NAME_LEN;
>>>  	u8 type = btrfs_dir_type(leaf, dir_item);
>>>  
>>> -	if (type >= BTRFS_FT_MAX) {
>>> -		fprintf(stderr, "invalid dir item type: %d\n",
>>> -		       (int)type);
>>> -		return 1;
>>> -	}
>>> -
>>>  	if (type == BTRFS_FT_XATTR)
>>>  		namelen = XATTR_NAME_MAX;
>>>  
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
