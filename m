Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:43695 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932126AbeGBIre (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 04:47:34 -0400
Subject: Re: [PATCH v2] btrfs: tree-checker: Verify block_group_item
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180702083414.13670-1-wqu@suse.com>
 <933bbbb4-157b-c966-17ce-b246aa056ff2@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <36f376ae-87d5-c614-5c2b-61c3baf62cd5@gmx.com>
Date: Mon, 2 Jul 2018 16:47:24 +0800
MIME-Version: 1.0
In-Reply-To: <933bbbb4-157b-c966-17ce-b246aa056ff2@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月02日 16:37, Nikolay Borisov wrote:
> 
> 
> On  2.07.2018 11:34, Qu Wenruo wrote:
>> +	if (hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) > 1) {
>> +		block_group_err(fs_info, leaf, slot,
>> +"invalid profile flags, have 0x%llx (%lu bits set) expect no more than 1 bit set",
>> +			flags & BTRFS_BLOCK_GROUP_PROFILE_MASK,
>> +			hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK));
> 
> Shouldn't this also be a hweight64() != 1 check ?

What about SINGLE profile on disk?
It doesn't has any profile bit set.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
