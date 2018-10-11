Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3812C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 12:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 860E22077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 12:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 860E22077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbeJKTnr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 15:43:47 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:35294 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726212AbeJKTnr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 15:43:47 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45974243"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Oct 2018 20:16:19 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id D5A744B6ED69;
        Thu, 11 Oct 2018 20:16:02 +0800 (CST)
Received: from fnst.localdomain (10.167.226.155) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 11 Oct 2018 20:16:08 +0800
Date:   Thu, 11 Oct 2018 20:15:58 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     Nikolay Borisov <nborisov@suse.com>
CC:     <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/6] btrfs: simplify btrfs_select_ref_head and cleanup
 some local variables
Message-ID: <20181011121558.GF5899@fnst.localdomain>
References: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
 <20181011054038.5428-6-lufq.fnst@cn.fujitsu.com>
 <e5bb27d0-fea5-30c6-afd4-aea2eae1871e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e5bb27d0-fea5-30c6-afd4-aea2eae1871e@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: D5A744B6ED69.ACBF5
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 09:40:52AM +0300, Nikolay Borisov wrote:
>
>
>On 11.10.2018 08:40, Lu Fengqi wrote:
>> If the return value of find_ref_head() is NULL, the only possibility is
>> that delayed_refs' head ref rbtree is empty. Hence, the second
>> find_ref_head() is pointless.
>> > Besides, the local variables loop and start are unnecessary, just remove
>> them.
>
>So the objective of that function is to get a reference to the first
>delayed head which is not processed. This is done by essentially keeping
>track of the last range that was processed in
>delayed_refs->run_delayed_start
>> 
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/delayed-ref.c | 17 +++--------------
>>  1 file changed, 3 insertions(+), 14 deletions(-)
>> 
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index 885581852bea..2726d2fb4bbe 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -354,20 +354,11 @@ struct btrfs_delayed_ref_head *
>>  btrfs_select_ref_head(struct btrfs_delayed_ref_root *delayed_refs)
>>  {
>>  	struct btrfs_delayed_ref_head *head;
>> -	u64 start;
>> -	bool loop = false;
>>  
>>  again:
>> -	start = delayed_refs->run_delayed_start;
>> -	head = find_ref_head(delayed_refs, start, 1);
>> -	if (!head && !loop) {
>> +	head = find_ref_head(delayed_refs, delayed_refs->run_delayed_start, 1);
>> +	if (!head) {
>>  		delayed_refs->run_delayed_start = 0;
>> -		start = 0;
>> -		loop = true;
>> -		head = find_ref_head(delayed_refs, start, 1);
>> -		if (!head)
>> -			return NULL;
>> -	} else if (!head && loop) {
>
>I believe this will have a negative impact since it actually will
>prevent finding a head which was added BEFORE the last processed head.
>So when a ref head is selected in btrfs_obtain_ref_head then the
>delayed_refs->lock is dropped and the given head is locked and
>delayed_refs->run_delayed_start points to the end of the selected range
>that the head represents. At this point it's possible that another
>thread modifies a different range which is before the one we have
>selected so graphically it will be something like:
>
>
>---[HEAD2]----->[HEAD1]------
>0                            N
>
>Where HEAD1 is the head returned from first invocation of
>btrfs_obtain_ref_head. Once  btrfs_obtain_ref_head is called the 2nd
>time it will not find HEAD2 so will just reset run_delayed_start to 0
>and return. So it will be up to another run of the delayed refs to
>actually find head2. Essentially you made btrfs_obtain_ref_head less

Not exactly. In fact, find_ref_head hides such a logic. When
return_bigger is set, if there is no larger entry to return, the first
entry will be returned. Please see the comment I add in the PATCH 6.

Hence, the 2nd invocation of btrfs_obtain_ref_head still will return
HEAD2. There is no functional change here.

However, your question makes me consider whether such hidden logic
should be extracted from find_ref_head to btrfs_select_ref_head.

>greedy. Have you characterized what kind of performance impact this have?

I noticed that there is a macro called SCRAMBLE_DELAYED_REFS in the
extent-tree.c. I am a bit curious whether it has been forgotten by
everyone, I have not found any test results about its performance impact.

-- 
Thanks,
Lu

>
>
>
>
>>  		return NULL;
>>  	}
>>  
>> @@ -376,11 +367,9 @@ btrfs_select_ref_head(struct btrfs_delayed_ref_root *delayed_refs)
>>  
>>  		node = rb_next(&head->href_node);
>>  		if (!node) {
>> -			if (loop)
>> +			if (delayed_refs->run_delayed_start == 0)
>>  				return NULL;
>>  			delayed_refs->run_delayed_start = 0;
>> -			start = 0;
>> -			loop = true;
>>  			goto again;
>>  		}
>>  		head = rb_entry(node, struct btrfs_delayed_ref_head,
>> 
>
>


