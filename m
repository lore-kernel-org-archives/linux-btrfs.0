Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B3AC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 07:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 665EE20857
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 07:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfCSHLB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 03:11:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:49530 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbfCSHLA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 03:11:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CED18ACA8
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 07:10:58 +0000 (UTC)
Subject: Re: [PATCH 2/2] btrfs: Introduce new tree block flag,
 BTRFS_HEADER_FLAG_LOG
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190319060418.29575-1-wqu@suse.com>
 <20190319060418.29575-2-wqu@suse.com>
 <a5b8cb2f-7f5e-5e7c-e4d0-2f04678c47aa@suse.com>
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
Message-ID: <c7a1fdae-3556-2f8a-9f71-86b8e4c197d4@suse.de>
Date:   Tue, 19 Mar 2019 15:10:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <a5b8cb2f-7f5e-5e7c-e4d0-2f04678c47aa@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/19 下午3:04, Nikolay Borisov wrote:
> 
> 
> On 19.03.19 г. 8:04 ч., Qu Wenruo wrote:
>> This new tree block flag is to indicate the tree block belongs to a log
>> tree.
>>
>> For btrfs on-disk format, there are several different trees could use
>> the same owner number:
>> - ordinary subvolume tree
>> - log tree for ordinary subvolume
>> - reloc tree for ordinary subvolume
>>
>> It's possible to do the backref walk or use the content to determine the
>> real owner of the tree block.
>> But backref walk is too expensive, content detection is not reliable.
>>
>> So adding a new flag to explicitly show the owner of log tree.
>>
>> Thankfully, tree-checker hasn't checked header flags yet, and there is
>> no real user for this flag yet.
>> So we don't need to introduce any compatibility flag for this
>> modification.
>>
>> The introduction of this new flag makes tree block owner easier to
>> distinguish, making life easier for:
>> - tree checker on log tree
>>   Log tree could contain some items impossible for regular trees
>> - performance profiler
>>   Now it's much easier to distinguish log tree.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/disk-io.c              | 1 +
>>  include/uapi/linux/btrfs_tree.h | 6 ++++++
>>  2 files changed, 7 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 6fe9197f6ee4..8cffdb7789d8 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1362,6 +1362,7 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
>>  		return ERR_CAST(leaf);
>>  	}
>>  
>> +	btrfs_set_header_flag(leaf, BTRFS_HEADER_FLAG_LOG);
>>  	root->node = leaf;
> 
> Unless you are going to tag ALL extent buffers which are allocated as
> part of the log tree this patch is redundant, because even now you can
> detect the root of the log tree by simply checking for the
> root->root_key.objectid.

That is obvious.

As mentioned, the purpose is to detect owner for root->log_root.
So it's to tag all log tree blocks.

> Alternatively if you are going to be tagging
> all such blocks then those 2 patches need to be part of a larger series
> so the intended usage is more clear.

The problem is, the larger part is not going to be a kernel patch.

Mostly btrfs-progs patch and 3rd-part kernel profiling tool.

> 
>>  
>>  	btrfs_mark_buffer_dirty(root->node);
>> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
>> index e974f4bb5378..d4ef80b702a0 100644
>> --- a/include/uapi/linux/btrfs_tree.h
>> +++ b/include/uapi/linux/btrfs_tree.h
>> @@ -447,9 +447,15 @@ struct btrfs_free_space_header {
>>  	__le64 num_bitmaps;
>>  } __attribute__ ((__packed__));
>>  
>> +/* Tree/super has written to disk */
> tree block has been correctly written to disk

The trick here is, super block reuses this flag.
So we still need to mention the super block part.

Thanks,
Qu

> 
>>  #define BTRFS_HEADER_FLAG_WRITTEN	(1ULL << 0)
>> +
>> +/* Tree block which gets relocated */
> 
> tree block belongs to a relocation tree
> 
>>  #define BTRFS_HEADER_FLAG_RELOC		(1ULL << 1)
>>  
>> +/* Tree block which belows to log tree */
>> +#define BTRFS_HEADER_FLAG_LOG		(1ULL << 2)
>> +
>>  /* Super block flags */
>>  /* Errors detected */
>>  #define BTRFS_SUPER_FLAG_ERROR		(1ULL << 2)
>>
