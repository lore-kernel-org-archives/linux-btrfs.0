Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46344C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 11:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BF11217F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 11:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbfC2LAd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 07:00:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:60256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728694AbfC2LAd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 07:00:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9CA78AEFE
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 11:00:31 +0000 (UTC)
Subject: Re: [PATCH 3/7] btrfs-progs: check/lowmem: Repair invalid inode mode
 in root tree
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190325082253.19583-1-wqu@suse.com>
 <20190325082253.19583-4-wqu@suse.com>
 <d93c7e2d-fd0f-3a61-8a92-09f096dce55b@suse.com>
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
Message-ID: <3920ba29-e2ab-be17-0072-134f68e637ad@suse.de>
Date:   Fri, 29 Mar 2019 19:00:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <d93c7e2d-fd0f-3a61-8a92-09f096dce55b@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/29 下午5:36, Nikolay Borisov wrote:
> 
> 
> On 25.03.19 г. 10:22 ч., Qu Wenruo wrote:
>> In root tree, we only have 2 types of inodes:
>> - ROOT_TREE_DIR inode
>>   Its mode is fixed to 40755
>> - free space cache inodes
>>   Its mode is fixed to 100600
>>
>> This patch will add the ability to repair such inodes to lowmem mode.
>> For fs/subvolume tree error, at least we haven't see such corruption
>> yet, so we don't need to rush to fix corruption in fs trees yet.
>>
>> The repair function, repair_imode() can be reused by later original mode
>> patch, so it's placed in check/mode-common.c.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  check/mode-common.c | 48 +++++++++++++++++++++++++++++++++++++++++++
>>  check/mode-common.h |  2 ++
>>  check/mode-lowmem.c | 50 ++++++++++++++++++++++++++++++++++++++++++++-
>>  3 files changed, 99 insertions(+), 1 deletion(-)
>>
>> diff --git a/check/mode-common.c b/check/mode-common.c
>> index fed102b0ce7a..1c150a3d5a7c 100644
>> --- a/check/mode-common.c
>> +++ b/check/mode-common.c
>> @@ -795,3 +795,51 @@ out:
>>  	btrfs_release_path(&path);
>>  	return ret;
>>  }
>> +
>> +/*
>> + * Reset inode mode with invalid mode to its known correct value.
>> + *
>> + * Only support free space cache inode and root tree dir inode of root tree.
>> + * Caller should ensure such condition.
>> + *
>> + * Return 0 if repair is done, @path will point to the correct inode item.
>> + * Return <0 for errors.
>> + */
>> +int repair_imode(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>> +		 struct btrfs_path *path, u64 ino)
>> +{
> 
> How about renaming this function to reset_imode/set_imode:
> 
> reset_imode and make it take a u32 parameter for the imode.
[snip]
>> +	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +	ASSERT(key.type == BTRFS_INODE_ITEM_KEY);
>> +	if (key.objectid != BTRFS_ROOT_TREE_DIR_OBJECTID &&
>> +	    !is_fstree(key.objectid)) {
>> +		error("unsupported ino %llu", key.objectid);
>> +		return -ENOTTY;
>> +	}
>> +
>> +	trans = btrfs_start_transaction(root, 1);
>> +	if (IS_ERR(trans)) {
>> +		ret = PTR_ERR(trans);
>> +		errno = -ret;
>> +		error("failed to start transaction: %m");
>> +		return ret;
>> +	}
>> +	btrfs_release_path(path);
>> +
>> +	ret = repair_imode(trans, root, path, key.objectid);
> 
> And calling it here with the correct parameter based on whether ino is
> BTRFS_ROOT_TREE_DIR_OBJECTID. Also move the asserts from reset_imode to
> this function.

Makes sense.

I'll go that direction.

Thanks,
Qu

> 
> Otherwise you are separating the checks/asserts across 2 function and
> this is somewhat cumbersome to follow.
> 
