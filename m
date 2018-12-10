Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC50C04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 11:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C4BD204FD
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 11:20:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C4BD204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbeLJLUf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 06:20:35 -0500
Received: from mout.gmx.net ([212.227.15.19]:40571 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbeLJLUe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 06:20:34 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MS5xC-1gtuza3mW2-00TBan; Mon, 10
 Dec 2018 12:20:26 +0100
Subject: Re: [PATCH 1/8] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181206065903.11343-1-wqu@suse.com>
 <20181206065903.11343-2-wqu@suse.com>
 <235ca34f-bcda-128d-dc3d-7465766271c7@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
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
Message-ID: <fc949474-f177-0d8c-2773-8112ff06c3c4@gmx.com>
Date:   Mon, 10 Dec 2018 19:20:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <235ca34f-bcda-128d-dc3d-7465766271c7@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:/sWR0MWODMiT07alHk7GaIBOKokf5yca5uOGCyVQ7gxGmgVlv6M
 GVSVQUIFYVW9JiEBiCT40PoOMhD1HhHSRi7dEncISEUh6/6I0qqZb/2zPCSzsIScgqothcw
 t1TzA5juAoMfx7oh5v9FSWHXDoWgMQSJ0kG8E+/B5F/VsrQEw8PU55xZlzTfxpiAonHsEg8
 AHFmqkojW65gQd3ph0qBQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:09uCyTrZhtE=:FMoj4v3BYFnOhwabdMcyg+
 /xeuduAgCMttUME2Qq7xnPhNtl8SwP8ib6BCRfzmvEodNbaHcbqpcNx0fz2KLoJJpSJDG/+JW
 UAi/+Z++IrAHEX30OrWwxqVQM9VtL5/abEvtVjgGrdCWueEimDf7lTtXnr5lfzDroUX9bP3nw
 D95Ylpd4odD5Fe5km4/CmBFv01LqDMQrWzakjlc6qoibMSOTFukXCwbp+t/7rzuY2pVWR/pFi
 WWdG9axc8EIg1lGfKNn9J4UlRIb7yaTV1tmQW6pykH9Kr4nHfwqLiCg/gIi5GMSGg3bdxXFuK
 uKLblwPRs2KPOigli0nulSh6k0+khEdsHYrWiT9hTAJQH5XN1LVU8yJ0SO+Qc87HgR+fXoM3n
 C72EwbcL5lsT0vA6avWG7buu35XCVszpW8JsVQNk09dI2+7KVfgELH1AEPhDHslalotz0cfPX
 Ewrgkyid0aGLMtFv3ksZ/9tDuBDTMiIwJcPBtUl56mUf1Yx3ZlQIPw1c0fxBd65kGVwYzDTr8
 yNGCVh+xpKq270SzHJ5xS7euI5j/6/mT/qoF+KFZBcWHwd35q2hBPswm+IvP9ZS3xm32QYpmd
 8HLPkE7lrNl65h4eFOA9+4LYxgW/Su3SnVH+twtnXUQC2rh+yG1DwuEhxgz4tR5FCn9h2xinR
 iXFt0lgdPF47MFGa6Lqh23Ldo0p/tVfVNb0kpczOCCqzRZALcplelwZNDay+QyN7q6MKi9B1r
 TcYFl27ngmy8sCeV4PGi23gTO0QeFuLR+CQ+V8Is6MiBD2RWOLcjIYc1UQwgI1fgUZM8Ah7Ht
 FlWV5BCQm8/I62R2B7KUNwCdHXXIjy6q93BkuhctY3BU31gGt8pw3skF9y6+EZBxm8ZhNuiP6
 NPQ/8bKot9PRfLXzTSKIyIzcL8JI0QUwJURLjphAYMZUUvdvdOhBsyNNUC6T3uStKqxhvVAqB
 kQ7K+Z4kjqA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/10 下午5:48, Nikolay Borisov wrote:
> 
> 
> On 6.12.18 г. 8:58 ч., Qu Wenruo wrote:
>> Current delayed ref interface has several problems:
>> - Longer and longer parameter lists
>>   bytenr
>>   num_bytes
>>   parent
>>   ref_root
>>   owner
>>   offset
>>   for_reloc << Only qgroup code cares.
>>
>> - Different interpretation for the same parameter
>>   Above @owner for data ref is ino owning this extent,
>>   while for tree ref, it's level. They are even in different size range.
>>   For level we only need 0~8, while for ino it's
>>   BTRFS_FIRST_FREE_OBJECTID~BTRFS_LAST_FREE_OBJECTID.
>>
>>   And @offset doesn't even makes sense for tree ref.
>>
>>   Such parameter reuse may look clever as an hidden union, but it
>>   destroys code readability.
>>
>> To solve both problems, we introduce a new structure, btrfs_ref to solve
>> them:
>>
>> - Structure instead of long parameter list
>>   This makes later expansion easier, and better documented.
>>
>> - Use btrfs_ref::type to distinguish data and tree ref
>>
>> - Use proper union to store data/tree ref specific structures.
>>
>> - Use separate functions to fill data/tree ref data, with a common generic
>>   function to fill common bytenr/num_bytes members.
>>
>> All parameters will find its place in btrfs_ref, and an extra member,
>> real_root, inspired by ref-verify code, is newly introduced for later
>> qgroup code, to record which tree is triggered this extent modification.
>>
>> This patch doesn't touch any code, but provides the basis for incoming
>> refactors.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/delayed-ref.h | 109 +++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 109 insertions(+)
>>
>> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
>> index d8fa12d3f2cc..e36d6b05d85e 100644
>> --- a/fs/btrfs/delayed-ref.h
>> +++ b/fs/btrfs/delayed-ref.h
>> @@ -176,6 +176,81 @@ struct btrfs_delayed_ref_root {
>>  	u64 qgroup_to_skip;
>>  };
>>  
>> +enum btrfs_ref_type {
>> +	BTRFS_REF_NOT_SET = 0,
> 
> No need for explicit initialisation when your enums start from 0.

Forgot that.

> 
>> +	BTRFS_REF_DATA,
>> +	BTRFS_REF_METADATA,
>> +	BTRFS_REF_LAST,
>> +};
>> +
>> +struct btrfs_data_ref {
>> +	/*
>> +	 * For EXTENT_DATA_REF
>> +	 *
>> +	 * @ref_root:	current owner of the extent.
>> +	 * 		may differ from btrfs_ref::real_root.
> 
> Here 'owner' is a bit ambiguous. Isn't this the root of the owner

Well, the @ref_root is a little confusing.
Here it could mean "the current btrfs_header_owner(eb)".

I don't really know the correct term here.

> 
>> +	 * @ino: 	inode number of the owner. 
> 
> And the owner is really the owning inode?

Yes, the owning inode.

> 
>> +	 * @offset:	*CALCULATED* offset. Not EXTENT_DATA key offset.
> 
> What does calculated mean here?

Because btrfs data backref instead of using the offset of the owning
EXTENT_DATA key, it uses key->offset - extent_offset.

> 
>> +	 *
>> +	 */
> 
> Ugh, this is ugly, why not have a single /* */ line above each member
> and document them like that?

Because the complexity of @ref_root can't really go one line.

> 
>> +	u64 ref_root;
>> +	u64 ino;
>> +	u64 offset;
>> +};
>> +
>> +struct btrfs_tree_ref {
>> +	/* Common for all sub types and skinny combination */
>> +	int level;
> 
> Like you've done here. Mention that this is the level in the tree that
> this reference is located at.
> 
>> +
>> +	/*
>> +	 * For TREE_BLOCK_REF (skinny metadata, either inline or keyed)
>> +	 *
>> +	 * root here may differ from btrfs_ref::real_root.
>> +	 */
> 
> Make it refer to the documentation of the generic btrfs_ref structure
> because if someone reads this comment and doesn't read the one in
> btrfs_ref then it's not clear under what conditions they might differ.
> 
>> +	u64 root;
>> +
>> +	/* For non-skinny metadata, no special member needed */
>> +};
>> +
>> +struct btrfs_ref {
>> +	enum btrfs_ref_type type;
>> +	int action;
>> +
>> +	/*
>> +	 * Use full backref(SHARED_BLOCK_REF or SHARED_DATA_REF) for this
>> +	 * extent and its children.
>> +	 * Set for reloc trees.
>> +	 */
>> +	unsigned int use_fullback:1;
> 
> 'fullback' is too terse, use_backreferences or something conveying more
> information?

@use_backreferences looks even stranger to me.

Here the point is, if this bit set, all backref will use
SHARED_BLOCK_REF or SHARED_DATA_REF subtype, and just leave a pointer to
its parent.

Any good idea for explaining this?

> Also please use explicit bool type:
> 
> bool xxxx:1

Is this valid? Haven't seen such usage in kernel code IIRC.

> 
>> +
>> +	/*
>> +	 * Whether this extent should go through qgroup record.
>> +	 * Normally false, but for certain case like delayed subtree scan,
>> +	 * this can hugely reduce qgroup overhead.
>> +	 */
>> +	unsigned int skip_qgroup:1;
> 
> again, explicit bool type please.
> 
>> +
>> +	/*
>> +	 * Who owns this reference modification, optional.
>> +	 *
>> +	 * One example:
>> +	 * When creating reloc tree for source fs, it will increase tree block
>> +	 * ref for children tree blocks.
>> +	 * In that case, btrfs_ref::real_root = reloc tree,
>> +	 * while btrfs_ref::tree_ref::root = fs tree.
>> +	 */
>> +	u64 real_root;
>> +	u64 bytenr;
>> +	u64 len;
>> +
>> +	/* Common @parent for SHARED_DATA_REF/SHARED_BLOCK_REF */
> 
> OK, it's common but what does it really contain? Either document it or
> rename it to parent_block or something.
> 
>> +	u64 parent;
>> +	union {
>> +		struct btrfs_data_ref data_ref;
>> +		struct btrfs_tree_ref tree_ref;
>> +	};
>> +};
>> +
>>  extern struct kmem_cache *btrfs_delayed_ref_head_cachep;
>>  extern struct kmem_cache *btrfs_delayed_tree_ref_cachep;
>>  extern struct kmem_cache *btrfs_delayed_data_ref_cachep;
>> @@ -184,6 +259,40 @@ extern struct kmem_cache *btrfs_delayed_extent_op_cachep;
>>  int __init btrfs_delayed_ref_init(void);
>>  void __cold btrfs_delayed_ref_exit(void);
>>  
>> +static inline void btrfs_init_generic_ref(struct btrfs_ref *generic_ref,
>> +				int action, u64 bytenr, u64 len, u64 real_root,
>> +				u64 parent)
>> +{
>> +	generic_ref->action = action;
> 
> IMO it makes sense in this series to have a patch which converts the
> action defines to an enum and subsequently modify functions/structs to
> actually be of enum type.

Makes sense.

Thanks,
Qu

> 
>> +	generic_ref->bytenr = bytenr;
>> +	generic_ref->len = len;
>> +	generic_ref->real_root = real_root;
>> +	generic_ref->parent = parent;
>> +}
>> +
>> +static inline void btrfs_init_tree_ref(struct btrfs_ref *generic_ref,
>> +				int level, u64 root)
>> +{
>> +	/* If @real_root not set, use @root as fallback */
>> +	if (!generic_ref->real_root)
>> +		generic_ref->real_root = root;
>> +	generic_ref->tree_ref.level = level;
>> +	generic_ref->tree_ref.root = root;
>> +	generic_ref->type = BTRFS_REF_METADATA;
>> +}
>> +
>> +static inline void btrfs_init_data_ref(struct btrfs_ref *generic_ref,
>> +				u64 ref_root, u64 ino, u64 offset)
>> +{
>> +	/* If @real_root not set, use @root as fallback */
>> +	if (!generic_ref->real_root)
>> +		generic_ref->real_root = ref_root;
>> +	generic_ref->data_ref.ref_root = ref_root;
>> +	generic_ref->data_ref.ino = ino;
>> +	generic_ref->data_ref.offset = offset;
>> +	generic_ref->type = BTRFS_REF_DATA;
>> +}
>> +
>>  static inline struct btrfs_delayed_extent_op *
>>  btrfs_alloc_delayed_extent_op(void)
>>  {
>>
