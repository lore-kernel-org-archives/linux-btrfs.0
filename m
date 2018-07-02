Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49880 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753366AbeGBItz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 04:49:55 -0400
Subject: Re: [PATCH v2] btrfs: tree-checker: Verify block_group_item
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180702083414.13670-1-wqu@suse.com>
 <933bbbb4-157b-c966-17ce-b246aa056ff2@suse.com>
 <36f376ae-87d5-c614-5c2b-61c3baf62cd5@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1190012f-7ebf-3743-9cb1-5026980298c0@suse.com>
Date: Mon, 2 Jul 2018 11:49:52 +0300
MIME-Version: 1.0
In-Reply-To: <36f376ae-87d5-c614-5c2b-61c3baf62cd5@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.07.2018 11:47, Qu Wenruo wrote:
> 
> 
> On 2018年07月02日 16:37, Nikolay Borisov wrote:
>>
>>
>> On  2.07.2018 11:34, Qu Wenruo wrote:
>>> +	if (hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) > 1) {
>>> +		block_group_err(fs_info, leaf, slot,
>>> +"invalid profile flags, have 0x%llx (%lu bits set) expect no more than 1 bit set",
>>> +			flags & BTRFS_BLOCK_GROUP_PROFILE_MASK,
>>> +			hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK));
>>
>> Shouldn't this also be a hweight64() != 1 check ?
> 
> What about SINGLE profile on disk?
> It doesn't has any profile bit set.

Agh, it's implied, doesn't even have a define. Then it's fine I guess,
huhz so many "special cases" ...

Reviewed-by: Nikolay Borisov <nborisov@suse.com>


> 
> Thanks,
> Qu
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
