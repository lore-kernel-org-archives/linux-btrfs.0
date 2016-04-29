Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59946 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752448AbcD2DUr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 23:20:47 -0400
Subject: Re: [PATCH] Btrfs: fix divide error upon chunk's stripe_len
To: <bo.li.liu@oracle.com>, <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        <dsterba@suse.com>
References: <1461718411-809-1-git-send-email-bo.li.liu@oracle.com>
 <20160427163903.GK29353@twin.jikos.cz>
 <20160427172335.GA15822@localhost.localdomain>
 <20160427173318.GN29353@twin.jikos.cz>
 <20160428174836.GA12012@localhost.localdomain>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <6c444bbf-9a59-9c95-e691-a5ec52d5f688@cn.fujitsu.com>
Date: Fri, 29 Apr 2016 11:20:31 +0800
MIME-Version: 1.0
In-Reply-To: <20160428174836.GA12012@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Liu Bo wrote on 2016/04/28 10:48 -0700:
> On Wed, Apr 27, 2016 at 07:33:18PM +0200, David Sterba wrote:
>> On Wed, Apr 27, 2016 at 10:23:35AM -0700, Liu Bo wrote:
>>> On Wed, Apr 27, 2016 at 06:39:03PM +0200, David Sterba wrote:
>>>> On Tue, Apr 26, 2016 at 05:53:31PM -0700, Liu Bo wrote:
>>>>> The struct 'map_lookup' uses type int for @stripe_len, while
>>>>> btrfs_chunk_stripe_len() can return a u64 value, and it may end up with
>>>>> @stripe_len being undefined value and it can lead to 'divide error' in
>>>>>  __btrfs_map_block().
>>>>>
>>>>> This changes 'map_lookup' to use type u64 for stripe_len, also right now
>>>>> we only use BTRFS_STRIPE_LEN for stripe_len, so this adds a valid checker for
>>>>> BTRFS_STRIPE_LEN.
>>>>>
>>>>> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
>>>>> Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
>>>>
>>>> I smell some fuzzing :) do you have the image available? I'll add it to
>>>> the rest in btrfsprogs.
>>>
>>> Sure, it's on the way, I'll send it along with a patch for btrfsck (we
>>> have to add the same validation check for superblock and chunk in
>>> btrfsck.)
>>
>> Great!
>>
>>>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>>>> ---
>>>>>  fs/btrfs/volumes.c | 2 +-
>>>>>  fs/btrfs/volumes.h | 2 +-
>>>>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>>>> index e2b54d5..b5cb859 100644
>>>>> --- a/fs/btrfs/volumes.c
>>>>> +++ b/fs/btrfs/volumes.c
>>>>> @@ -6242,7 +6242,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
>>>>>  			"invalid chunk length %llu", length);
>>>>>  		return -EIO;
>>>>>  	}
>>>>> -	if (!is_power_of_2(stripe_len)) {
>>>>> +	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
>
> We don't need the first 'is_power_of_2' check.
>
> And I think we may need to have another helper, such as btrfs_check_chunk_valid(),
> to cover all these (both current and future) validation checks.  What do you think?
>
> Thanks,
>
> -liubo
>

+1 for a btrfs_check_chunk_valid().

And I'm OK to remove is_power_of_2 check, as it's only used for future 
stripe_len.
But we only support fix STRIPE_LEN, it's OK to remove it.

BTW, did it crash btrfs-progs?

Thanks,
Qu

>>>>
>>>> Unfortunatelly this will break current state, as mkfs does not set the
>>>> stripe length to 64k but to 4k. But the value is otherwise ignored in
>>>> kernel.
>>>
>>> This is chunk's stripe_len, not superblock's stripe_len:
>>>
>>> make_btrfs() {
>>> 	...
>>> 	btrfs_set_super_stripesize(&super, cfg->stripesize); --> 4096
>>> 	...
>>> 	btrfs_set_chunk_stripe_len(buf, chunk, 64 * 1024);
>>> }
>>
>> Oh right, and the hardcoded stripe chunk size would need to be fixed in
>> a lot more places so it's fine. Consider this
>>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>>
>> and on the way to for-next.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


