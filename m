Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-cys01nam02on0076.outbound.protection.outlook.com ([104.47.37.76]:33920
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932942AbeBVQbc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 11:31:32 -0500
Subject: Re: [RFC PATCH] btrfs: Speedup btrfs_read_block_groups()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180222045215.16426-1-wqu@suse.com>
 <c85baf37-d030-1718-1ee8-c64d2f031101@gmx.com>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <59c448b6-cc46-da82-a0bf-3b64d1a79081@panasas.com>
Date: Thu, 22 Feb 2018 11:31:26 -0500
MIME-Version: 1.0
In-Reply-To: <c85baf37-d030-1718-1ee8-c64d2f031101@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/21/2018 11:56 PM, Qu Wenruo wrote:
> On 2018年02月22日 12:52, Qu Wenruo wrote:
>> btrfs_read_block_groups() is used to build up the block group cache for
>> all block groups, so it will iterate all block group items in extent
>> tree.
>>
>> For large filesystem (TB level), it will search for BLOCK_GROUP_ITEM
>> thousands times, which is the most time consuming part of mounting
>> btrfs.
>>
>> So this patch will try to speed it up by:
>>
>> 1) Avoid unnecessary readahead
>>     We were using READA_FORWARD to search for block group item.
>>     However block group items are in fact scattered across quite a lot of
>>     leaves. Doing readahead will just waste our IO (especially important
>>     for HDD).
>>
>>     In real world case, for a filesystem with 3T used space, it would
>>     have about 50K extent tree leaves, but only have 3K block group
>>     items. Meaning we need to iterate 16 leaves to meet one block group
>>     on average.
>>
>>     So readahead won't help but waste slow HDD seeks.
>>
>> 2) Use chunk mapping to locate block group items
>>     Since one block group item always has one corresponding chunk item,
>>     we could use chunk mapping to get the block group item size.
>>
>>     With block group item size, we can do a pinpoint tree search, instead
>>     of searching with some uncertain value and do forward search.
>>
>>     In some case, like next BLOCK_GROUP_ITEM is in the next leaf of
>>     current path, we could save such unnecessary tree block read.
>>
>> Cc: Ellis H. Wilson III <ellisw@panasas.com>
> 
> Hi Ellis,
> 
> Would you please try this patch to see if it helps to speedup the mount
> of your large filesystem?

I will try either tomorrow or over the weekend.  I'm waiting on hardware 
to be able to build and load a custom kernel on.

Thanks so much for taking a stab at this!

ellis
