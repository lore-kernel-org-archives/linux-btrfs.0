Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13628 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750838AbdE2Bs0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 May 2017 21:48:26 -0400
Subject: Re: [PATCH 6/6] Btrfs: add sanity check of extent item in scrub
To: <bo.li.liu@oracle.com>, <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
 <20170526002631.8546-7-bo.li.liu@oracle.com>
 <20170526183316.GN30842@twin.jikos.cz>
 <20170526202014.GD7859@lim.localdomain>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <6375fc01-2e03-798e-5226-3a201c7d2ce5@cn.fujitsu.com>
Date: Mon, 29 May 2017 09:48:19 +0800
MIME-Version: 1.0
In-Reply-To: <20170526202014.GD7859@lim.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/27/2017 04:20 AM, Liu Bo wrote:
> On Fri, May 26, 2017 at 08:33:16PM +0200, David Sterba wrote:
>> On Thu, May 25, 2017 at 06:26:31PM -0600, Liu Bo wrote:
>>> Currently scrub only verify checksum of both metadata and data and
>>> couldn't detect an invalid extent_item.
>>
>> This is a different kind of check that scrub was never designed to do.
>> Scrub just verifies the checksums, not the sructural integrity. This has
>> been referred to as an "on-line fsck". AFAIK xfs does not use 'scrub' in
>> the same sense as btrfs, so things are going to be confusing for the
>> users.
>>
>> The on-line fsck is still desired, but I'd like to see a discussion how
>> exactly it should work, whether to extend scrub or add a new ioctl etc.
>>
> 
> I was hesitating about scrub vs online fsck when posting, just thought
> it'd be good when users got this error while doing a regular scrub
> ahead of really getting into trouble.  If we have a plan for online
> fsck, I'm happy to let fsck do the job.

IIRC on-line fsck will be too challenging for kernel.

Just check how current btrfs check does, it's doing tons of cross 
checking for lowmem mode or uses tons of memory to record forward refs 
and backward refs.

Doing it in kernel will be a disaster.

> 
> Or we can do this kind of sanity check at the time when reading the
> eb.

This seems more reasonable, just like what Su Yue did for 
inode_ref/dir_item/dir_index.

Thanks,
Qu
> 
> Thanks,
> -liubo
> 
>>> This adds sanity check for extent item, now it can check if
>>> extent_inline_ref_type is valid.
>>>
>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>> ---
>>>   fs/btrfs/scrub.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 43 insertions(+)
>>>
>>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>>> index b0251eb..e87b752 100644
>>> --- a/fs/btrfs/scrub.c
>>> +++ b/fs/btrfs/scrub.c
>>> @@ -3058,6 +3058,39 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
>>>   	return ret < 0 ? ret : 0;
>>>   }
>>>   
>>> +static int check_extent_item(struct extent_buffer *l, int slot,
>>
>> Please use 'eb' for the extent_buffer.
>>
>>> +			     struct btrfs_extent_item *ei, int key_type)
>>
>> key_type should be u8
>>
>>> +{
>>> +	unsigned long ptr;
>>> +	unsigned long end;
>>> +	struct btrfs_extent_inline_ref *iref;
>>> +	u64 flags = btrfs_extent_flags(l, ei);
>>> +	int is_data = !!(flags & BTRFS_EXTENT_FLAG_DATA);
>>> +	int type;
>>> +
>>> +	ptr = (unsigned long)(ei + 1);
>>> +	if (!is_data &&
>>> +	    key_type != BTRFS_METADATA_ITEM_KEY)
>>> +		ptr += sizeof(struct btrfs_tree_block_info);
>>> +	end = (unsigned long)ei +
>>> +		btrfs_item_size_nr(l, slot);
>>
>> This will fit to one line
>>
>>> +
>>> +	while (1) {
>>> +		if (ptr >= end) {
>>> +			WARN_ON(ptr > end);
>>
>> Please add some verbose error message or get rid of the WARN_ON
>> completely if possible.
>>
>>> +			break;
>>> +		}
>>> +
>>> +		iref = (struct btrfs_extent_inline_ref *)ptr;
>>> +		type = btrfs_get_extent_inline_ref_type(l, iref, is_data);
>>> +		if (type < 0)
>>> +			return type;
>>> +
>>> +		ptr += btrfs_extent_inline_ref_size(type);
>>> +	}
>>> +	return 0;
>>> +}
>>> +
>>>   static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
>>>   					   struct map_lookup *map,
>>>   					   struct btrfs_device *scrub_dev,
>>> @@ -3318,6 +3351,16 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
>>>   				goto next;
>>>   			}
>>>   
>>> +			/* sanity check for extent inline ref type */
>>> +			if (check_extent_item(l, slot, extent, key.type)) {
>>> +				btrfs_err(fs_info,
>>> +					  "scrub: extent %llu(0x%llx) has an invalid extent inline ref type, ignored.",
>>
>> Strings can be un-indented to the left.
>>
>>> +					  key.objectid, key.objectid);
>>> +				spin_lock(&sctx->stat_lock);
>>> +				sctx->stat.uncorrectable_errors++;
>>
>> Yeah, this is an example where the uncorrectable_error would gain a new
>> meaning. We'd need to extend the scrub error reporting so the various
>> metadata errors get reported properly and not mangled with the rest.
>>
>>> +				spin_unlock(&sctx->stat_lock);
>>> +				goto next;
>>> +			}
>>>   again:
>>>   			extent_logical = key.objectid;
>>>   			extent_len = bytes;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


