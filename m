Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58200 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750953AbeGJHbE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 03:31:04 -0400
Subject: Re: [PATCH RFC 1/2] btrfs: scrub: Don't use inode page cache in
 scrub_handle_errored_block()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180710055751.13309-1-wqu@suse.com>
 <1565461a-2079-5236-0db7-efd9953e122a@suse.com>
 <3c590104-c26a-6a83-8ac6-2f5182566b31@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7e45ff8b-4e60-bb99-48d1-e231fe99015d@suse.com>
Date: Tue, 10 Jul 2018 10:31:01 +0300
MIME-Version: 1.0
In-Reply-To: <3c590104-c26a-6a83-8ac6-2f5182566b31@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.07.2018 10:14, Qu Wenruo wrote:
> 
> 
> On 2018年07月10日 15:00, Nikolay Borisov wrote:
>>
>>
>> On 10.07.2018 08:57, Qu Wenruo wrote:
>>> When we need to fixup error blocks during scrub/dev-replace for
>>> nodatasum extents, we still goes through the inode page cache and write
>>> them back onto disk.
>>>
>>> It's already proved that such usage of on-disk data could lead to
>>> serious data corruption for compressed extent.
>>> So here we also need to avoid such case, so avoid any calling to
>>> scrub_fixup_nodatasum().
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>
>> Is this patch supposed to replace the 'if (0 ...' one that is in 4.18 -
>> if not, then the small fix should be reverted as we are introducing a
>> regression in 4.18 and then your full fix should go into 4.19.
> 
> It's an enhancement to the original 4.18 fix.
> The fix in 4.18 is causing regression because I missed there is another
> routine which could do the similar work (but more lame) but at different
> timing.
> 
>>
>> I kind of lost the end of the whole nodatasum mess but your references
>> are really vague, if you have described somewhere (i.e in a mailing list
>> post or another, merged patch) how the corruption happens if we use the
>> page cache then put a reference in the changelog - either with a commit
>> id or use the Link: tag for the email thread.
> 
> For the whole mess, it's complex due to the complexity of scrub/replace.
> 
> The simple workflow is:
> scrub main work (prepare needed info for corresponding workqueue)
> |- copy_nocow_pages() if it's nodatasum and is doing replace
> |- scrub_pages() all other cases goes here
> 
> The v4.18 fixes the problem by removing copy_nocow_pages().
> 
> However after scrub main work, we have fixup worker to handle read/csum
> failure:
> scrub_handle_errored_block()
> |- scrub_fixup_nodatasum() if it's nodatasum
> |- Or build bios itself
> 
> In scrub_fixup_nodatasum() it iterates each inode referring the extent
> and tries to use inode page cache.
> The problem is, scrub_fixup_nodatasum() is not doing it correctly, inode
> extent lock is not even as good as copy_nocow_pages() and could cause a
> lot of lockdep warning in tests like btrfs/100.
> 
> I should detect the problem and delete it in the first fix, but since
> it's fixup worker I though the priority is not that high, until the
> v4.18 fix is causing regression.
> 
> 
> And for the description, it's a little hard to explain (well, just
> explained above).
> I'll try to make it more detailed in commit message.

Please do, because imagine it's hard for you who understands the code
and what about someone else who is going to work on it 6 months from
now. That's why we need detailed and correct changelogs.

> However since it's happening in a different timing, I can't just refer
> an existing test case/patch to explain this.
> 
> Thanks,
> Qu
> 
>>> ---
>>>  fs/btrfs/scrub.c | 18 ++++++++++--------
>>>  1 file changed, 10 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>>> index 572306036477..328232fa5646 100644
>>> --- a/fs/btrfs/scrub.c
>>> +++ b/fs/btrfs/scrub.c
>>> @@ -1151,11 +1151,6 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>>>  		return ret;
>>>  	}
>>>  
>>> -	if (sctx->is_dev_replace && !is_metadata && !have_csum) {
>>> -		sblocks_for_recheck = NULL;
>>> -		goto nodatasum_case;
>>> -	}
>>> -
>>>  	/*
>>>  	 * read all mirrors one after the other. This includes to
>>>  	 * re-read the extent or metadata block that failed (that was
>>> @@ -1268,13 +1263,20 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>>>  		goto out;
>>>  	}
>>>  
>>> -	if (!is_metadata && !have_csum) {
>>> +	/*
>>> +	 * NOTE: Even for nodatasum data case, it's still possible that it's
>>> +	 * compressed data extent, thus scrub_fixup_nodatasum(), which
>>> +	 * write inode page cache onto disk, could cause serious data
>>> +	 * corruption.
>>> +	 *
>>> +	 * So here we could only read from disk, and hopes our recovery
>>> +	 * could reach disk before newer write.
>>
>> If this code relies on 'hope' then I NACK it since hope cannot be
>> quantified hence the effect of this patch cannot be quantified. It
>> either fixes the problem or doesn't fix it. Sorry but this, coupled with
>> the vague changelog I'd rather not have it committed.
>>
>>> +	 */
>>> +	if (0 && !is_metadata && !have_csum) {
>>>  		struct scrub_fixup_nodatasum *fixup_nodatasum;
>>>  
>>>  		WARN_ON(sctx->is_dev_replace);
>>>  
>>> -nodatasum_case:
>>> -
>>>  		/*
>>>  		 * !is_metadata and !have_csum, this means that the data
>>>  		 * might not be COWed, that it might be modified
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
