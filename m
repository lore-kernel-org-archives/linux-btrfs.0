Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1085C169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 13:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7E09218A6
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 13:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfBKNXn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 08:23:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:43238 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727383AbfBKNXm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 08:23:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 29A6EAED6
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 13:23:41 +0000 (UTC)
Subject: Re: [PATCH v3 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190211051653.3167-1-wqu@suse.com>
 <20190211051653.3167-2-wqu@suse.com>
 <216f4acf-faf9-6ca3-c9f2-68a9eaa763fa@suse.com>
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
Message-ID: <77f7ed38-aca5-f799-08eb-e8a3100fe57c@suse.de>
Date:   Mon, 11 Feb 2019 21:23:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <216f4acf-faf9-6ca3-c9f2-68a9eaa763fa@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/2/11 下午8:55, Nikolay Borisov wrote:
> 
> 
> On 11.02.19 г. 7:16 ч., Qu Wenruo wrote:
>> Current delayed ref interface has several problems:
>> - Longer and longer parameter lists
>>   bytenr
>>   num_bytes
>>   parent
>>   ---------- so far so good
>>   ref_root
>>   owner
>>   offset
>>   ---------- I don't feel good now
>>
>> - Different interpretation for the same parameter
>>   Above @owner for data ref is inode number (u64),
>>   while for tree ref, it's level (int).
>>
>>   They are even in different size range.
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
>> @real_root, inspired by ref-verify code, is newly introduced for later
>> qgroup code, to record which tree is triggered this extent modification.
>>
>> This patch doesn't touch any code, but provides the basis for incoming
>> refactors.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/delayed-ref.h | 116 +++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 116 insertions(+)
>>
>> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
>> index d2af974f68a1..24addc5163bc 100644
>> --- a/fs/btrfs/delayed-ref.h
>> +++ b/fs/btrfs/delayed-ref.h
>> @@ -187,6 +187,90 @@ struct btrfs_delayed_ref_root {
>>  	u64 qgroup_to_skip;
>>  };
>>  
>> +enum btrfs_ref_type {
>> +	BTRFS_REF_NOT_SET,
>> +	BTRFS_REF_DATA,
>> +	BTRFS_REF_METADATA,
>> +	BTRFS_REF_LAST,
>> +};
>> +
>> +struct btrfs_data_ref {
>> +	/* For EXTENT_DATA_REF */
>> +
>> +	/* Root who refers to this data extent */
> nit: s/who/which/
>> +	u64 ref_root;
>> +
>> +	/* Inode who refers to this data extent */
> nit: DITTO
>> +	u64 ino;
>> +
>> +	/*
>> +	 * file_offset - extent_offset
>> +	 *
>> +	 * file_offset is the key.offset of the EXTENT_DATA key.
>> +	 * extent_offset is btrfs_file_extent_offset() of the EXTENT_DATA data.
>> +	 */
> 
> This needs rewording since it's rather cryptic now.

It's cryptic due to the EXTENT_ITEM design from the very beginning.
I'm all ears to improve this description.

> Looking at the dev
> docs and the description for 'offset' field in btrfs_file_extent_item I
> can sort of deduce that this field will only be different than null if
> this reference is for an extent which is shared between 2 snapshots.

Don't forget reflink and data CoW.

Like this:

	item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
		generation 6 type 1 (regular)
		extent data disk byte 13631488 nr 1048576
		extent data offset 0 nr 4096 ram 1048576
	item 7 key (257 EXTENT_DATA 4096) itemoff 15760 itemsize 53
		generation 7 type 1 (regular)
		extent data disk byte 14680064 nr 4096
		extent data offset 0 nr 4096 ram 4096
	item 8 key (257 EXTENT_DATA 8192) itemoff 15707 itemsize 53
		generation 6 type 1 (regular)
		extent data disk byte 13631488 nr 1048576
		extent data offset 8192 nr 1040384 ram 1048576

EXTENT_DATA items at 0 and 8K offset are original from one larger
extent, EXTENT_DATA item at 4K offset is newly written one.

But the current design makes EXTENT_ITEM inline data backref pretty clean:

        item 0 key (13631488 EXTENT_ITEM 1048576) itemoff 16230 itemsize 53
                refs 2 gen 6 flags DATA
                extent data backref root FS_TREE objectid 257 offset 0
count 2

No need for an extra inline data backref, just increase the original
count from 1 to 2.
> 
> So if file foo is shared between two snapshots, has 1 extent and in
> snapshot2 this extent is partially changed then I'd expect extent_offset
> to point to the start in the original (unchanged extent), correct?

As long as there is some new DATA_EXTENT pointing to the original
unchanged extent, then yes, the 'offset' will change.

Just like the EXTENT_DATA at 8K offset above.

> 
>> +	u64 offset;
>> +};
>> +
>> +struct btrfs_tree_ref {
>> +	/*
>> +	 * Level of this tree block
>> +	 *
>> +	 * Shared for skinny (TREE_BLOCK_REF) and normal tree ref.
> 
> This sentence is also not very clear? You mean this level applies to
> tree block refs (irrespective of whether they are shared or normal tree
> block refs)?

This is for any keyed or inlined tree ref who uses skinny metadata
(level stored in key.offset, the common case now) or non-skinny
EXTENT_ITEM who uses btrfs_tree_block_info like:

	item 7 key (30507008 EXTENT_ITEM 16384) itemoff 15956 itemsize 51
		refs 1 gen 4 flags TREE_BLOCK
		tree block key (0 UNKNOWN.0 0) level 0 <<< here.
		tree block backref root UUID_TREE


It's possible for extent tree to not include above cases, like the
following case:
        item 1 key (12648448 EXTENT_ITEM 16384) itemoff 16235 itemsize 24
                refs 9 gen 7 flags TREE_BLOCK
        item 2 key (12648448 SHARED_BLOCK_REF 4481024) itemoff 3461
itemsize 0
                shared block backref

So I'm not sure how to describe such case clearly.

Thanks,
Qu

> 
>> +	 */
>> +	int level;
>> +
>> +	/*
>> +	 * Root who refers to this tree block.
> 
> nit:s/who/which
> 
>> +	 *
>> +	 * For TREE_BLOCK_REF (skinny metadata, either inline or keyed)
>> +	 */
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
>> +	 * Only use parent pointers as backref (SHARED_BLOCK_REF or
>> +	 * SHARED_DATA_REF) for this extent and its children.
>> +	 * Set for reloc trees.
>> +	 */
>> +	bool only_backreferences:1;
>> +
>> +	/*
>> +	 * Whether this extent should go through qgroup record.
>> +	 *
>> +	 * Normally false, but for certain case like delayed subtree scan,
>> +	 * setting this flag can hugely reduce qgroup overhead.
>> +	 */
>> +	bool skip_qgroup:1;
>> +
>> +	/*
>> +	 * Optional. To which root this modification is for.
>> +	 * Mostly used for qgroup optimization.
>> +	 *
>> +	 * When unset, data/tree ref init code will populate it.
>> +	 * In certain case, we're modifying reference for a different root.
>> +	 * E.g. Cow fs tree blocks for balance.
>> +	 * In that case, tree_ref::root will be fs tree, but we're doing this
>> +	 * for reloc tree, then we should set @real_root to reloc tree.
>> +	 */
>> +	u64 real_root;
>> +	u64 bytenr;
>> +	u64 len;
>> +
>> +	/* Bytenr of the parent tree block */
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
>> @@ -195,6 +279,38 @@ extern struct kmem_cache *btrfs_delayed_extent_op_cachep;
>>  int __init btrfs_delayed_ref_init(void);
>>  void __cold btrfs_delayed_ref_exit(void);
>>  
>> +static inline void btrfs_init_generic_ref(struct btrfs_ref *generic_ref,
>> +				int action, u64 bytenr, u64 len, u64 parent)
>> +{
>> +	generic_ref->action = action;
>> +	generic_ref->bytenr = bytenr;
>> +	generic_ref->len = len;
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
