Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B097BC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 08:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88A96214AE
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 08:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfCLIFq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:05:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:42784 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726633AbfCLIFp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 04:05:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1107DB608;
        Tue, 12 Mar 2019 08:05:44 +0000 (UTC)
Subject: Re: [PATCH] btrfs: Check the first key and level for cached extent
 buffer
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190312074558.32393-1-wqu@suse.com>
 <f11bba01-1955-b3ba-f824-d999c18578a6@suse.com>
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
Message-ID: <37ff2d4f-5823-e150-175e-2a397d84ea13@suse.de>
Date:   Tue, 12 Mar 2019 16:05:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <f11bba01-1955-b3ba-f824-d999c18578a6@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/12 下午3:57, Nikolay Borisov wrote:
[snip]
>>  			*eb_ret = tmp;
>>  			return 0;
>>  		}
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 298b34721bc0..e2a0cb362d28 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -423,9 +423,9 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>>  	return ret;
>>  }
>>  
>> -static int verify_level_key(struct btrfs_fs_info *fs_info,
>> -			    struct extent_buffer *eb, int level,
>> -			    struct btrfs_key *first_key, u64 parent_transid)
>> +int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
>> +			   struct extent_buffer *eb, int level,
>> +			   struct btrfs_key *first_key, u64 parent_transid)
>>  {
>>  	int found_level;
>>  	struct btrfs_key found_key;
>> @@ -500,8 +500,8 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
>>  			if (verify_parent_transid(io_tree, eb,
>>  						   parent_transid, 0))
>>  				ret = -EIO;
>> -			else if (verify_level_key(fs_info, eb, level,
>> -						  first_key, parent_transid))
>> +			else if (btrfs_verify_level_key(fs_info, eb, level,
>> +						first_key, parent_transid))
>>  				ret = -EUCLEAN;
> 
> Actually why is the buffer still held when we return EUCLEAN since in
> read_tree_block if btree_read_extent_buffer_pages returns an error
> free_extent_buffer should be called and it should delete the eb from eb
> cache, no ?

Yes, that's the ideal case.

But there is a hole where we could read tree block without first_key
check, just as mentioned it's scrub.

In that case extent buffer will be cached anyway, so we can't skip the
check here.

Thanks,
Qu

> IMO the correct behavior should be to remove the corrupted
> buffer ASAP and not rely on later validation.
> 
>>  			else
>>  				break;
>> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
>> index 987a64bc0c66..67a9fe2d29c7 100644
>> --- a/fs/btrfs/disk-io.h
>> +++ b/fs/btrfs/disk-io.h
>> @@ -39,6 +39,9 @@ static inline u64 btrfs_sb_offset(int mirror)
>>  struct btrfs_device;
>>  struct btrfs_fs_devices;
>>  
>> +int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
>> +			   struct extent_buffer *eb, int level,
>> +			   struct btrfs_key *first_key, u64 parent_transid);
>>  struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
>>  				      u64 parent_transid, int level,
>>  				      struct btrfs_key *first_key);
>>
