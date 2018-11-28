Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D20CDC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 09:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2C2B208E7
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 09:33:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2C2B208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbeK1Uec (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 15:34:32 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:25054 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727774AbeK1Uec (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 15:34:32 -0500
X-IronPort-AV: E=Sophos;i="5.56,290,1539619200"; 
   d="scan'208";a="48783517"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 17:33:26 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1D04E4B6AE19;
        Wed, 28 Nov 2018 17:33:23 +0800 (CST)
Received: from fnst.localdomain (10.167.226.155) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 17:33:28 +0800
Date:   Wed, 28 Nov 2018 17:33:20 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     Nikolay Borisov <nborisov@suse.com>
CC:     <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] btrfs: remove always true if branch in
 find_delalloc_range
Message-ID: <20181128093320.GD3002@fnst.localdomain>
References: <20181128032130.11452-1-lufq.fnst@cn.fujitsu.com>
 <90ebfa89-32c8-6f05-9c13-1e557abc7d12@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90ebfa89-32c8-6f05-9c13-1e557abc7d12@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 1D04E4B6AE19.A8F1C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 09:01:42AM +0200, Nikolay Borisov wrote:
>
>
>On 28.11.18 г. 5:21 ч., Lu Fengqi wrote:
>> The @found is always false when it comes to the if branch. Besides, the
>> bool type is more suitable for @found.
>
>Well if you are ranging the type of found variable it also makes sense
>to change the return value of the function to bool as well.

Good catch.

-- 
Thanks,
Lu

>
>> 
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/extent_io.c | 7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 582b4b1c41e0..b4ee3399be96 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -1461,7 +1461,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
>>  	struct rb_node *node;
>>  	struct extent_state *state;
>>  	u64 cur_start = *start;
>> -	u64 found = 0;
>> +	bool found = false;
>>  	u64 total_bytes = 0;
>>  
>>  	spin_lock(&tree->lock);
>> @@ -1472,8 +1472,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
>>  	 */
>>  	node = tree_search(tree, cur_start);
>>  	if (!node) {
>> -		if (!found)
>> -			*end = (u64)-1;
>> +		*end = (u64)-1;
>>  		goto out;
>>  	}
>>  
>> @@ -1493,7 +1492,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
>>  			*cached_state = state;
>>  			refcount_inc(&state->refs);
>>  		}
>> -		found++;
>> +		found = true;
>>  		*end = state->end;
>>  		cur_start = state->end + 1;
>>  		node = rb_next(node);
>> 
>
>


