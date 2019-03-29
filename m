Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D25BC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 11:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2280F217F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 11:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbfC2LCJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 07:02:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:60516 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728500AbfC2LCJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 07:02:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 21C77AEFF
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 11:02:07 +0000 (UTC)
Subject: Re: [PATCH 5/7] btrfs: check/lowmem: Check and repair free space
 cache inode mode
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190325082253.19583-1-wqu@suse.com>
 <20190325082253.19583-6-wqu@suse.com>
 <6e9857a2-163e-27f4-8128-7af73e5d18b1@suse.com>
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
Message-ID: <a608f9c1-e3e9-875a-e472-726e2c696eac@suse.de>
Date:   Fri, 29 Mar 2019 19:02:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <6e9857a2-163e-27f4-8128-7af73e5d18b1@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[snip]
>> +/*
>> + * For free space inodes, we can't call check_inode_item() as free space
>> + * cache inode doesn't have INODE_REF.
>> + * We just check its inode mode.
>> + */
>> +int check_repair_free_space_inode(struct btrfs_fs_info *fs_info,
>> +				  struct btrfs_path *path)
>> +{
>> +	struct btrfs_inode_item *iitem;
>> +	struct btrfs_key key;
>> +	u32 mode;
>> +	int ret = 0;
>> +
>> +	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +	ASSERT(key.type == BTRFS_INODE_ITEM_KEY && is_fstree(key.objectid));
>> +	iitem = btrfs_item_ptr(path->nodes[0], path->slots[0],
>> +			       struct btrfs_inode_item);
>> +	mode = btrfs_inode_mode(path->nodes[0], iitem);
>> +	if (mode != FREE_SPACE_CACHE_INODE_MODE) {
>> +		error(
>> +	"free space cache inode %llu has invalid mode: has 0%o expect 0%o",
>> +			key.objectid, mode, FREE_SPACE_CACHE_INODE_MODE);
>> +		ret = -EUCLEAN;
>> +		if (repair) {
>> +			ret = repair_imode_lowmem(fs_info->tree_root,
>> +						  path);
>> +			if (ret < 0)
>> +				return ret;
>> +			return ret;
>> +		}
>> +	}
>> +	return ret;
>> +}
> 
> You put this function in mode-lowmem, yet it's also used in the next
> patch to implement check/repair for original mode. Since you are oging
> to re-use function across the 2 modes it makes no sense to separate them
> in their names. Perhaps put them in mode-common.c
> 

The limitation is due to repair_imode_lowmem().

Thanks,
Qu

>> +
>>  /*
>>   * Check all fs/file tree in low_memory mode.
>>   *
>> @@ -5130,6 +5164,17 @@ int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info)
>>  		btrfs_item_key_to_cpu(node, &key, slot);
>>  		if (key.objectid > BTRFS_LAST_FREE_OBJECTID)
>>  			goto out;
>> +		if (key.type == BTRFS_INODE_ITEM_KEY &&
>> +		    is_fstree(key.objectid)) {
>> +			ret = check_repair_free_space_inode(fs_info, &path);
>> +			/* Check if we still have a valid path to continue */
>> +			if (ret < 0 && path.nodes[0]) {
>> +				err |= ret;
>> +				goto next;
>> +			}
>> +			if (ret < 0 && !path.nodes[0])
>> +				goto out;
>> +		}
>>  		if (key.type == BTRFS_ROOT_ITEM_KEY &&
>>  		    fs_root_objectid(key.objectid)) {
>>  			if (key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
>> diff --git a/check/mode-lowmem.h b/check/mode-lowmem.h
>> index e0ab30b770d5..d2983fd12eb4 100644
>> --- a/check/mode-lowmem.h
>> +++ b/check/mode-lowmem.h
>> @@ -67,5 +67,7 @@
>>  
>>  int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info);
>>  int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info);
>> +int check_repair_free_space_inode(struct btrfs_fs_info *fs_info,
>> +				  struct btrfs_path *path);
>>  
>>  #endif
>>
