Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE165C43610
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 09:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77DB5206BA
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 09:07:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77DB5206BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbeKTTfk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 14:35:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:60038 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbeKTTfk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 14:35:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E3D98AE66
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 09:07:31 +0000 (UTC)
Subject: Re: [PATCH] btrfs: qgroup: Skip delayed data ref for reloc trees
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20181120084636.31346-1-wqu@suse.com>
 <970d0031-00ec-eb37-7245-f682f4f10569@suse.com>
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
Message-ID: <f8bf0702-973c-eec5-ccfc-f68e2cd7aa05@suse.de>
Date:   Tue, 20 Nov 2018 17:07:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <970d0031-00ec-eb37-7245-f682f4f10569@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/20 下午4:51, Nikolay Borisov wrote:
> 
> 
> On 20.11.18 г. 10:46 ч., Qu Wenruo wrote:
>> Currently we only check @ref_root in btrfs_add_delayed_data_ref() to
>> determine whether a data delayed ref is for reloc tree.
>>
>> Such check is insufficient as for relocation we could pass @ref_root
>> as the source file tree, causing qgroup to trace unchanged data extents
>> even we're only relocating metadata chunks.
>>
>> We could insert qgroup extent record for the following call trace even
>> we're only relocating metadata block group:
>>
>> do_relocation()
>> |- btrfs_cow_block(root=reloc_root)
>>    |- update_ref_for_cow(root=reloc_root)
>>       |- __btrfs_mod_ref(root=reloc_root)
>>          |- ref_root = btrfs_header_owner()
>>          |- btrfs_add_delayed_data_ref(ref_root=source_root)
>>
>> And another case when dropping reloc tree:
>>
>> clean_dirty_root()
>> |- btrfs_drop_snapshot(root=relocc_root)
>>    |- walk_up_tree(root=reloc_root)
>>       |- walk_up_proc(root=reloc_root)
>>          |- btrfs_dec_ref(root=reloc_root)
>>             |- __btrfs_mod_ref(root=reloc_root)
>>                |- ref_root = btrfs_header_owner()
>>                |- btrfs_add_delayed_data_ref(ref_root=source_root)
>>
>> This patch will introduce @root parameter for
>> btrfs_add_delayed_data_ref(), so that we could determine if this data
>> extent belongs to reloc tree or not.
>>
>> This could skip data extents which aren't really modified during
>> relocation.
>>
>> For the same real world 4G data 16 snapshots 4K nodesize metadata
>> balance test:
>>                      | v4.20-rc1 + delaye*  | w/ patch       | diff
>> -----------------------------------------------------------------------
>> relocated extents    | 22773                | 22656          | -0.1%
>> qgroup dirty extents | 122879               | 74316          | -39.5%
>> time (real)          | 23.073s              | 14.971         | -35.1%
>>
>> *: v4.20-rc1 + delayed subtree scan patchset
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/delayed-ref.c | 3 ++-
>>  fs/btrfs/delayed-ref.h | 1 +
>>  fs/btrfs/extent-tree.c | 6 +++---
>>  3 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index 9301b3ad9217..269bd6ecb8f3 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -798,6 +798,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>>   * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
>>   */
>>  int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
>> +			       struct btrfs_root *root,
> 
> I'm beginning to wonder, should we document
> btrfs_add_delayed_data_ref/btrfs_add_tree_ref arguments separate for
> each function, or should only the differences be documented - in this
> case the newly added root parameter. The rest of the arguments are being
> documented at init_delayed_ref_common.

You won't be happy with my later plan, it will add new parameter for
btrfs_add_delayed_tree_ref(), and it may not be @root, but some bool.

So I think we may need to document at least the difference.

Thanks,
Qu

> 
>>  			       u64 bytenr, u64 num_bytes,
>>  			       u64 parent, u64 ref_root,
>>  			       u64 owner, u64 offset, u64 reserved, int action,
>> @@ -835,7 +836,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
>>  	}
>>  
>>  	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
>> -	    is_fstree(ref_root)) {
>> +	    is_fstree(ref_root) && is_fstree(root->root_key.objectid)) {
>>  		record = kmalloc(sizeof(*record), GFP_NOFS);
>>  		if (!record) {
>>  			kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
>> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
>> index 8e20c5cb5404..6c60737e55d6 100644
>> --- a/fs/btrfs/delayed-ref.h
>> +++ b/fs/btrfs/delayed-ref.h
>> @@ -240,6 +240,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>>  			       struct btrfs_delayed_extent_op *extent_op,
>>  			       int *old_ref_mod, int *new_ref_mod);
>>  int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
>> +			       struct btrfs_root *root,
>>  			       u64 bytenr, u64 num_bytes,
>>  			       u64 parent, u64 ref_root,
>>  			       u64 owner, u64 offset, u64 reserved, int action,
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index a1febf155747..0554d2cc2ea1 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -2046,7 +2046,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>>  						 BTRFS_ADD_DELAYED_REF, NULL,
>>  						 &old_ref_mod, &new_ref_mod);
>>  	} else {
>> -		ret = btrfs_add_delayed_data_ref(trans, bytenr,
>> +		ret = btrfs_add_delayed_data_ref(trans, root, bytenr,
>>  						 num_bytes, parent,
>>  						 root_objectid, owner, offset,
>>  						 0, BTRFS_ADD_DELAYED_REF,
>> @@ -7104,7 +7104,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>>  						 BTRFS_DROP_DELAYED_REF, NULL,
>>  						 &old_ref_mod, &new_ref_mod);
>>  	} else {
>> -		ret = btrfs_add_delayed_data_ref(trans, bytenr,
>> +		ret = btrfs_add_delayed_data_ref(trans, root, bytenr,
>>  						 num_bytes, parent,
>>  						 root_objectid, owner, offset,
>>  						 0, BTRFS_DROP_DELAYED_REF,
>> @@ -8080,7 +8080,7 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
>>  			   root->root_key.objectid, owner, offset,
>>  			   BTRFS_ADD_DELAYED_EXTENT);
>>  
>> -	ret = btrfs_add_delayed_data_ref(trans, ins->objectid,
>> +	ret = btrfs_add_delayed_data_ref(trans, root, ins->objectid,
>>  					 ins->offset, 0,
>>  					 root->root_key.objectid, owner,
>>  					 offset, ram_bytes,
>>
