Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFADC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 01:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71D6721733
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 01:03:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71D6721733
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbeI1HYb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 03:24:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:49706 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbeI1HYb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 03:24:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 546B9B03E;
        Fri, 28 Sep 2018 01:03:25 +0000 (UTC)
Subject: Re: [PATCH] btrfs: tree-checker: Check level for leaves and nodes
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180927235934.5215-1-wqu@suse.com>
 <63dbf4f5-f576-c37e-a3a6-ba513d9c015b@cn.fujitsu.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <c3159d8b-d27c-0f94-1efb-49d20970c0ed@suse.de>
Date:   Fri, 28 Sep 2018 09:03:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <63dbf4f5-f576-c37e-a3a6-ba513d9c015b@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/9/28 上午9:08, Su Yue wrote:
> 
> 
> On 9/28/18 7:59 AM, Qu Wenruo wrote:
>> Although we have tree level check at tree read runtime, it's completely
>> based on its parent level.
>> We still need to do accurate level check to avoid invalid tree blocks
>> sneak into kernel space.
>>
>> The check itself is simple, for leaf its level should always be 0.
>> For nodes its level should be in range [1, BTRFS_MAX_LEVEL - 1].
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/tree-checker.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index db835635372f..cab0b1f1f741 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -487,6 +487,13 @@ static int check_leaf(struct btrfs_fs_info
>> *fs_info, struct extent_buffer *leaf,
>>       u32 nritems = btrfs_header_nritems(leaf);
>>       int slot;
>>   +    if (btrfs_header_level(leaf) != 0) {
>> +        generic_err(fs_info, leaf, 0,
>> +            "invalid level for leaf, have %d expect 0",
>> +            btrfs_header_level(leaf));
>> +        return -EUCLEAN;
>> +    }
>> +
> BTW, output more info(bytenr, root) of the corrupted node/leaf may be
> better?

That's what will be outputted by generic_err() function.

Thanks,
Qu

> 
>>       /*
>>        * Extent buffers from a relocation tree have a owner field that
>>        * corresponds to the subvolume tree they are based on. So just
>> from an
>> @@ -645,9 +652,16 @@ int btrfs_check_node(struct btrfs_fs_info
>> *fs_info, struct extent_buffer *node)
>>       unsigned long nr = btrfs_header_nritems(node);
>>       struct btrfs_key key, next_key;
>>       int slot;
>> +    int level = btrfs_header_level(node);
>>       u64 bytenr;
>>       int ret = 0;
>>   +    if (level <= 0 || level >= BTRFS_MAX_LEVEL) {
>> +        generic_err(fs_info, node, 0,
>> +            "invalid level for node, have %d expect [1, %d]",
>> +            level, BTRFS_MAX_LEVEL - 1);
>> +        return -EUCLEAN;
>> +    }
>>       if (nr == 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(fs_info)) {
>>           btrfs_crit(fs_info,
>>   "corrupt node: root=%llu block=%llu, nritems too %s, have %lu expect
>> range [1,%u]",
>>
> 
> 
> 
