Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A304C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 09:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E962081C
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 09:16:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25E962081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbeK1URf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 15:17:35 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15704 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727341AbeK1URf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 15:17:35 -0500
X-IronPort-AV: E=Sophos;i="5.56,290,1539619200"; 
   d="scan'208";a="48782719"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 17:16:37 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 8BF154B6ED56;
        Wed, 28 Nov 2018 17:16:32 +0800 (CST)
Received: from [10.167.226.22] (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 17:16:38 +0800
Subject: Re: [RFC PATCH 01/17] btrfs: priority alloc: prepare of priority
 aware allocator
To:     Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
 <20181128031148.357-2-suy.fnst@cn.fujitsu.com>
 <3abe66e9-d836-71d1-8e93-8facc8a5576a@suse.com>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <989b9bb8-991a-438e-90d4-b0998541949e@cn.fujitsu.com>
Date:   Wed, 28 Nov 2018 17:24:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <3abe66e9-d836-71d1-8e93-8facc8a5576a@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: 8BF154B6ED56.ADA69
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/28/18 4:24 PM, Nikolay Borisov wrote:
> 
> 
> On 28.11.18 г. 5:11 ч., Su Yue wrote:
>> To implement priority aware allocator, this patch:
>> Introduces struct btrfs_priority_tree which contains block groups
>> in same level.
>> Adds member priority to struct btrfs_block_group_cache and pointer
>> points to the priority tree it's located.
>>
>> Adds member priority_trees to struct btrfs_space_info to represents
>> priority trees in different raid types.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/ctree.h | 24 ++++++++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index e62824cae00a..5c4651d8a524 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -437,6 +437,8 @@ struct btrfs_space_info {
>>   	struct rw_semaphore groups_sem;
>>   	/* for block groups in our same type */
>>   	struct list_head block_groups[BTRFS_NR_RAID_TYPES];
>> +	/* for priority trees in our same type */
>> +	struct rb_root priority_trees[BTRFS_NR_RAID_TYPES];
>>   	wait_queue_head_t wait;
>>   
>>   	struct kobject kobj;
>> @@ -558,6 +560,21 @@ struct btrfs_full_stripe_locks_tree {
>>   	struct mutex lock;
>>   };
>>   
>> +/*
>> + * Tree to record all block_groups in same priority level.
>> + * Only used in priority aware allocator.
>> + */
>> +struct btrfs_priority_tree {
>> +	/* protected by groups_sem */
>> +	struct rb_root block_groups;
>> +	struct rw_semaphore groups_sem;
>> +
>> +	/* for different level priority trees in same index*/
>> +	struct rb_node node;
>> +
>> +	int level;
> 
> Do you ever expect the level to be a negative number? If not then use
> u8/u32 depending on the range of levels you expect.
> 

Indeed, level is not expected to be negative. u8 is more proper.

>> +};
>> +
>>   struct btrfs_block_group_cache {
>>   	struct btrfs_key key;
>>   	struct btrfs_block_group_item item;
>> @@ -571,6 +588,8 @@ struct btrfs_block_group_cache {
>>   	u64 flags;
>>   	u64 cache_generation;
>>   
>> +	/* It's used only when priority aware allocator is enabled. */
>> +	long priority;
> 
> What's the range of priorities you are expecting, wouldn't an u8 be
> sufficient, that gives us 256 priorities?
> 

The 6th patch introduces three special priorities. That's what I called
dirty codes.

Thanks,
Su

>>   	/*
>>   	 * If the free space extent count exceeds this number, convert the block
>>   	 * group to bitmaps.
>> @@ -616,6 +635,9 @@ struct btrfs_block_group_cache {
>>   	/* for block groups in the same raid type */
>>   	struct list_head list;
>>   
>> +	/* for block groups in the same priority level */
>> +	struct rb_node node;
>> +
>>   	/* usage count */
>>   	atomic_t count;
>>   
>> @@ -670,6 +692,8 @@ struct btrfs_block_group_cache {
>>   
>>   	/* Record locked full stripes for RAID5/6 block group */
>>   	struct btrfs_full_stripe_locks_tree full_stripe_locks_root;
>> +
>> +	struct btrfs_priority_tree *priority_tree;
>>   };
>>   
>>   /* delayed seq elem */
>>
> 
> 


