Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC10FC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 14:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B3362075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 14:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfBUOcQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:32:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:44566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725932AbfBUOcQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 09:32:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5F49EB626
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2019 14:32:14 +0000 (UTC)
Subject: Re: [RFC PATCH] btrfs: Introduce developer-oriented check to ensure
 all tree blocks are written back before writing super blocks
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190221082249.24187-1-wqu@suse.com>
 <c2aea5d2-5039-0243-6fd7-fed0880a0be0@suse.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <e07446e9-7aff-9f12-582e-310135c8ec30@suse.de>
Date:   Thu, 21 Feb 2019 22:32:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <c2aea5d2-5039-0243-6fd7-fed0880a0be0@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/2/21 下午10:25, Nikolay Borisov wrote:
> 
> 
> On 21.02.19 г. 10:22 ч., Qu Wenruo wrote:
>> There are a lot of error reports complaining about transid error in the
>> mail list.
>>
>> Under most case, the on-disk transid is lower than expected transid.
>> This may indicate that some tree blocks are not written back to disk
>> before writing super blocks.
>>
>> This patch will add a safe net for developers, by calling
>> btrfs_write_and_wait_transaction() before setting transaction unblocked
>> and double check btree_inode and dirty_pages io_tree, to ensure no tree
>> blocks are still dirty or under writeback.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> The reason for RFC is, I'm not sure why we currently call
>> btrfs_write_and_wait_transaction() after setting transaction UNBLOCKED.
>>
>> It looks like an optimization, but I don't see much performance
>> difference during regression test.
>>
>> I hope to move the call before we unblock transaction so we can do such
>> sanity check for all builds and hope to catch some clue of transid
>> error.
> 
> Even current code ensures that all allocated blocks in the current
> transaction (which is what all those EXTENT_DIRTY extents in the
> dirty_pages tree ) are written before the new superblocks are.
> 
> Slight offtopic: In fact instead of playing games with the flags and
> having an extent_io_tree called dirty_pages o_O it can be replaced with
> a simple linked list that holds all newly allocated buffers so writing
> all such buffers will result in simply iterating the list.
> 
> In any case this patch is buggy, see below on why
> 
>> ---
>>  fs/btrfs/transaction.c | 38 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 38 insertions(+)
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 4ec2b660d014..30b7ed0bf873 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -2213,6 +2213,44 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>>  
>>  	btrfs_trans_release_chunk_metadata(trans);
>>  
>> +	/* Last safenet or developer to catch any unwritten tree blocks */
>> +	if (IS_ENABLED(CONFIG_BTRFS_DEBUG)) {
>> +		u64 found_start = 0;
>> +		u64 found_end = 0;
>> +
>> +		ret = btrfs_write_and_wait_transaction(trans);
>> +		if (ret) {
>> +			btrfs_handle_fs_error(fs_info, ret,
>> +					      "Error while writing out transaction");
>> +			mutex_unlock(&fs_info->tree_log_mutex);
>> +			goto scrub_continue;
>> +		}
>> +
>> +		/* No dirty extent should exist in btree inode */
>> +		ret = test_range_bit(&trans->transaction->dirty_pages, 0,
>> +				(u64)-1, EXTENT_DIRTY | EXTENT_WRITEBACK,
> 
> Why do you check EXTENT_WRITEBACK, AFAICS that flag is not currently
> used in the code and should perhahps be deleted? I don't see anything
> setting it, it's only being checked for (as part of EXTENT_IOBITS).
> 
> Additionally this check is pointless because
> btrfs_write_and_wait_transaction calls clear_btree_io_tree which purges
> the tree.

But we still have BTRFS_I(fs_info->btree_inode)->io_tree, and that's the
main part of the check.

I don't really think the dirty_pages is really an important thing
compared to btree_inode.
If there is some way to find any dirty pages from an address_space, it
would be even better.

Thanks,
Qu

> 
>> +				0, NULL);
>> +		if (ret > 0) {
>> +			WARN(1,
>> +		"dirty_pages not fully written back, start=%llu len=%llu\n",
>> +			     found_start, found_end + 1 - found_start);
>> +			ret = -EUCLEAN;
>> +			mutex_unlock(&fs_info->tree_log_mutex);
>> +			goto scrub_continue;
>> +		}
>> +		ret = test_range_bit(&BTRFS_I(fs_info->btree_inode)->io_tree, 0,
>> +				     (u64)-1, EXTENT_DIRTY | EXTENT_WRITEBACK,
>> +				     0, NULL);
>> +		if (ret > 0) {
>> +			WARN(1,
>> +		"btree io_tree not fully written back, start=%llu len=%llu\n",
>> +			     found_start, found_end + 1 - found_start);
>> +			ret = -EUCLEAN;
>> +			mutex_unlock(&fs_info->tree_log_mutex);
>> +			goto scrub_continue;
>> +		}
>> +	}
>> +
>>  	spin_lock(&fs_info->trans_lock);
>>  	cur_trans->state = TRANS_STATE_UNBLOCKED;
>>  	fs_info->running_transaction = NULL;
>>
