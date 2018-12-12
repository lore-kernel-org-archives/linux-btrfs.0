Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD845C04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 05:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 973352084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 05:51:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 973352084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbeLLFvI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 00:51:08 -0500
Received: from mout.gmx.net ([212.227.17.20]:52547 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbeLLFvI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 00:51:08 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MMkgl-1gWiJJ2VZv-008Xdc; Wed, 12
 Dec 2018 06:50:59 +0100
Subject: Re: [PATCH 3/8] btrfs: delayed-ref: Use btrfs_ref to refactor
 btrfs_add_delayed_tree_ref()
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181206065903.11343-1-wqu@suse.com>
 <20181206065903.11343-4-wqu@suse.com>
 <167bf109-41cf-f10b-4364-9af5701f5ee0@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <f2d5a621-1321-5ddf-1e3d-76b3e2617d93@gmx.com>
Date:   Wed, 12 Dec 2018 13:50:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <167bf109-41cf-f10b-4364-9af5701f5ee0@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:/+YCw07PYMe7VBovSxdwby3HtLBVWVK2oasAUeFDbxhRY9nyR92
 3RA6UAEO2xmWGhDrDXa6h5xkxsBvk531i0/uHInetDZ0I/Xq5Hsvl5PQ4CznPRes1Rhmcgq
 dslYK7G1FP850unkt+QiNTKuOeIHlU0U2vCgeRwQ316G92P6QgI1IU9sq+ujGc5HTsdpWip
 cMFOEuZzZyhcZhIxujX0g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:h7AvtLZlOqg=:ywZ357AU1FAST/dYRK52Uy
 pX31fyTM4mTSg+OlAsSdkI87phtTdxHMCeTDT9QwwsvEW2S0MP4tGzEIgGGY/AGBvAgNeLGGo
 J7E/ZXXryPqy+++L7T0HZbspG9ekgM21+b2AHzbwTTC86m+DDkbikH/mPuNSbM2v0+w3y8cgY
 HmQfPCT3JElBfUcY1HViFNgv04aLymRY43Cc1lRvYRssEGfvH6x2/8JPgZqu4uCP3XRllggay
 dCoykc0pNtk+tcRy238CQv481E3yiinkcwKUdNiDZPgn8ZK3e1jwQSZwc07Wvm0M4gyt17jem
 y2+MEoRxzPt1bLdtHFr4x4EmaXofWFsRfmeqvCleV4Oxb/aSQDh66mgLBjLW1LSBHuVz9gj9Q
 2jDEUCIxhEu2PPLR1uqqyedwUXHMlXx+X+BKbTD4o/MMGfp/v8jFZleTCXZxhkW0H3rJdCtDK
 UwL1ZJ8bVPMec8QrRafU4OW4IQR8mcscTkb5Bf2jvw9UJJAcx558njMclduNrimXLBUbzaky2
 /7mAAyXMa8wm+qBcwp8U7msfU055/wAbTudFOX5R7IctZBaXjzVOyqAzZDtRB/gFHa+EVOkWA
 tWv8EGdrAZQDkgrpN2JsdtF5yH+Lwm/U4d2mest4t1FKz5Ljxy3tBJqTonoBAKx1Rr0qGMHNU
 gUO1dSAMzrEALYstC9sQ+109y71WdIxJCqmM3c8cUAzdQdc+T9j+DqVNylpdjmV290uqaTSJO
 JjFmtsoYKwpH4auhdvdClR+AUlRSVt6AaJW4WRNHmibiHr4vlRKM4F/VKapewFx/rs0VrICJy
 ETTqkqyS3lPDjZ4wX2QC0cLjySIRkYvJaMPz2hlpxMneFZPJvmMpI2mVXUpCu8H52LXHI6He2
 //hXz/C/YMJIX8f2cl/cFGZMD59FeGAr0E9nYoQY8VPcSwaoPiRJU9MFO99c5Ggl3g34Ead5z
 flrZs2V3tLw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/10 下午5:21, Nikolay Borisov wrote:
> 
> 
> On 6.12.18 г. 8:58 ч., Qu Wenruo wrote:
>> btrfs_add_delayed_tree_ref() has a longer and longer parameter list, and
>> some caller like btrfs_inc_extent_ref() are using @owner as level for
>> delayed tree ref.
>>
>> Instead of making the parameter list longer and longer, use btrfs_ref to
>> refactor it, so each parameter assignment should be self-explaining
>> without dirty level/owner trick, and provides the basis for later refactor.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/delayed-ref.c | 24 ++++++++++++++-------
>>  fs/btrfs/delayed-ref.h |  4 +---
>>  fs/btrfs/extent-tree.c | 48 ++++++++++++++++++++++++------------------
>>  3 files changed, 44 insertions(+), 32 deletions(-)
>>
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index 11dd46be4017..c42b8ade7b07 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -710,9 +710,7 @@ static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
>>   * transaction commits.
>>   */
>>  int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>> -			       u64 bytenr, u64 num_bytes, u64 parent,
>> -			       u64 ref_root,  int level, bool for_reloc,
>> -			       int action,
>> +			       struct btrfs_ref *generic_ref,
>>  			       struct btrfs_delayed_extent_op *extent_op,
>>  			       int *old_ref_mod, int *new_ref_mod)
>>  {
>> @@ -722,10 +720,17 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>>  	struct btrfs_delayed_ref_root *delayed_refs;
>>  	struct btrfs_qgroup_extent_record *record = NULL;
>>  	int qrecord_inserted;
>> -	bool is_system = (ref_root == BTRFS_CHUNK_TREE_OBJECTID);
>> +	bool is_system = (generic_ref->real_root == BTRFS_CHUNK_TREE_OBJECTID);
>> +	int action = generic_ref->action;
>> +	int level = generic_ref->tree_ref.level;
>>  	int ret;
>> +	u64 bytenr = generic_ref->bytenr;
>> +	u64 num_bytes = generic_ref->len;
>> +	u64 parent = generic_ref->parent;
>>  	u8 ref_type;
>>  
>> +	ASSERT(generic_ref && generic_ref->type == BTRFS_REF_METADATA &&
>> +		generic_ref->action);
> 
> You have already dereferenced generic_ref by the time you ASSERT and
> would have crashed. I guess the first condition in the assert can be
> removed.
> 
>>  	BUG_ON(extent_op && extent_op->is_data);
>>  	ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
>>  	if (!ref)
> 
> <snip>
> 
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -2031,6 +2031,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>>  			 bool for_reloc)
>>  {
>>  	struct btrfs_fs_info *fs_info = root->fs_info;
>> +	struct btrfs_ref generic_ref = { 0 };
>>  	int old_ref_mod, new_ref_mod;
>>  	int ret;
>>  
>> @@ -2040,13 +2041,13 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>>  	btrfs_ref_tree_mod(root, bytenr, num_bytes, parent, root_objectid,
>>  			   owner, offset, BTRFS_ADD_DELAYED_REF);
>>  
>> +	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_REF, bytenr,
>> +			       num_bytes, root->root_key.objectid, parent);
>> +	generic_ref.skip_qgroup = for_reloc;
>>  	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
>> -		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
>> -						 num_bytes, parent,
>> -						 root_objectid, (int)owner,
>> -						 for_reloc,
>> -						 BTRFS_ADD_DELAYED_REF, NULL,
>> -						 &old_ref_mod, &new_ref_mod);
>> +		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);
> 
> The cast is now redundant since the parameter definition of
> btrfs_init_tree_ref is an int.

It will be redundant when btrfs_free_extent() is converted to use btrfs_ref.
But not now.

As @owner is still u64, while parameter of btrfs_init_tree_ref() is
still using int for @level.

Thanks,
Qu

>> +		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
>> +				NULL, &old_ref_mod, &new_ref_mod);
>>  	} else {
>>  		ret = btrfs_add_delayed_data_ref(trans, root, bytenr,
>>  						 num_bytes, parent,
> 
> <snip>
> 
>> @@ -7102,11 +7110,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>>  		old_ref_mod = new_ref_mod = 0;
>>  		ret = 0;
>>  	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
>> -		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
>> -						 num_bytes, parent,
>> -						 root_objectid, (int)owner,
>> -						 for_reloc,
>> -						 BTRFS_DROP_DELAYED_REF, NULL,
>> +		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);
> 
> ditto about the cast
>> +		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
>>  						 &old_ref_mod, &new_ref_mod);
>>  	} else {
>>  		ret = btrfs_add_delayed_data_ref(trans, root, bytenr,
> 
> <sniop>
> 
