Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:45432 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751461AbdG0T16 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 15:27:58 -0400
Subject: Re: [PATCH v2] Btrfs: Do not use data_alloc_cluster in ssd mode
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <20170726195925.10715-1-hans.van.kranenburg@mendix.com>
 <pan$12971$566fe832$ff60933c$6921c466@cox.net>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <f8e0ea32-4b6a-778b-10e2-99676160e422@mendix.com>
Date: Thu, 27 Jul 2017 21:27:56 +0200
MIME-Version: 1.0
In-Reply-To: <pan$12971$566fe832$ff60933c$6921c466@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/27/2017 09:11 PM, Duncan wrote:
> Hans van Kranenburg posted on Wed, 26 Jul 2017 21:59:25 +0200 as
> excerpted:
> 
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 4f8f75d9e839..b091dd3f5b38 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -472,7 +472,7 @@ struct btrfs_block_rsv {
>>  /*
>>   * free clusters are used to claim free space in relatively large chunks,
>>   * allowing us to do less seeky writes.  They are used for all metadata
>> - * allocations and data allocations in ssd mode.
>> + * allocations and data allocations in ssd_spread mode.
>>   */
>>  struct btrfs_free_cluster {
>>  	spinlock_t lock;
> 
> That (post-patch) comment says all metadata and data allocations in
> ssd_spread mode, but if my understanding is correct, it'll also use
> free clusters for metadata (only, not data, the patch only changing)
> the data behavior) in normal ssd mode.
> 
> Perhaps that (metadata only use of free clusers in ssd mode) should be
> mentioned as well, since post-patch there's now a distinction to be made?

The text is confusing yes.

It can be read as...
  (all metadata allocations and data allocations) in ssd_spread mode
or...
  (all metadata allocations) and (data allocations in ssd_spread mode)
...the second one being correct.

Good catch.

I changed it in: "They are used for all metadata allocations. In
ssd_spread mode they are also used for data allocations."

-- 
Hans van Kranenburg
