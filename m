Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B200C169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 14:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D95BD2073F
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 14:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfBKOU2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 09:20:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:52262 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726796AbfBKOU2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 09:20:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 30FE4AE6B
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 14:20:26 +0000 (UTC)
Subject: Re: [PATCH v3 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
To:     Qu Wenruo <wqu@suse.de>, linux-btrfs@vger.kernel.org
References: <20190211051653.3167-1-wqu@suse.com>
 <20190211051653.3167-2-wqu@suse.com>
 <216f4acf-faf9-6ca3-c9f2-68a9eaa763fa@suse.com>
 <77f7ed38-aca5-f799-08eb-e8a3100fe57c@suse.de>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <8e4f62e1-f0ab-5f1f-6fc6-684d3e53b8b8@suse.com>
Date:   Mon, 11 Feb 2019 16:20:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <77f7ed38-aca5-f799-08eb-e8a3100fe57c@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11.02.19 г. 15:23 ч., Qu Wenruo wrote:
> 
> 
> On 2019/2/11 下午8:55, Nikolay Borisov wrote:
>>
>>
>> On 11.02.19 г. 7:16 ч., Qu Wenruo wrote:
>>> Current delayed ref interface has several problems:
>>> - Longer and longer parameter lists
>>>   bytenr
>>>   num_bytes
>>>   parent
>>>   ---------- so far so good
>>>   ref_root
>>>   owner
>>>   offset
>>>   ---------- I don't feel good now
>>>
>>> - Different interpretation for the same parameter
>>>   Above @owner for data ref is inode number (u64),
>>>   while for tree ref, it's level (int).
>>>
>>>   They are even in different size range.
>>>   For level we only need 0~8, while for ino it's
>>>   BTRFS_FIRST_FREE_OBJECTID~BTRFS_LAST_FREE_OBJECTID.
>>>
>>>   And @offset doesn't even makes sense for tree ref.
>>>
>>>   Such parameter reuse may look clever as an hidden union, but it
>>>   destroys code readability.
>>>
>>> To solve both problems, we introduce a new structure, btrfs_ref to solve
>>> them:
>>>
>>> - Structure instead of long parameter list
>>>   This makes later expansion easier, and better documented.
>>>
>>> - Use btrfs_ref::type to distinguish data and tree ref
>>>
>>> - Use proper union to store data/tree ref specific structures.
>>>
>>> - Use separate functions to fill data/tree ref data, with a common generic
>>>   function to fill common bytenr/num_bytes members.
>>>
>>> All parameters will find its place in btrfs_ref, and an extra member,
>>> @real_root, inspired by ref-verify code, is newly introduced for later
>>> qgroup code, to record which tree is triggered this extent modification.
>>>
>>> This patch doesn't touch any code, but provides the basis for incoming
>>> refactors.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  fs/btrfs/delayed-ref.h | 116 +++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 116 insertions(+)
>>>
>>> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
>>> index d2af974f68a1..24addc5163bc 100644
>>> --- a/fs/btrfs/delayed-ref.h
>>> +++ b/fs/btrfs/delayed-ref.h
>>> @@ -187,6 +187,90 @@ struct btrfs_delayed_ref_root {
>>>  	u64 qgroup_to_skip;
>>>  };
>>>  
>>> +enum btrfs_ref_type {
>>> +	BTRFS_REF_NOT_SET,
>>> +	BTRFS_REF_DATA,
>>> +	BTRFS_REF_METADATA,
>>> +	BTRFS_REF_LAST,
>>> +};
>>> +
>>> +struct btrfs_data_ref {
>>> +	/* For EXTENT_DATA_REF */
>>> +
>>> +	/* Root who refers to this data extent */
>> nit: s/who/which/
>>> +	u64 ref_root;
>>> +
>>> +	/* Inode who refers to this data extent */
>> nit: DITTO
>>> +	u64 ino;
>>> +
>>> +	/*
>>> +	 * file_offset - extent_offset
>>> +	 *
>>> +	 * file_offset is the key.offset of the EXTENT_DATA key.
>>> +	 * extent_offset is btrfs_file_extent_offset() of the EXTENT_DATA data.
>>> +	 */
>>
>> This needs rewording since it's rather cryptic now.
> 
> It's cryptic due to the EXTENT_ITEM design from the very beginning.
> I'm all ears to improve this description.
> 
>> Looking at the dev
>> docs and the description for 'offset' field in btrfs_file_extent_item I
>> can sort of deduce that this field will only be different than null if
>> this reference is for an extent which is shared between 2 snapshots.
> 
> Don't forget reflink and data CoW.
> 
> Like this:
> 
> 	item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
> 		generation 6 type 1 (regular)
> 		extent data disk byte 13631488 nr 1048576
> 		extent data offset 0 nr 4096 ram 1048576
> 	item 7 key (257 EXTENT_DATA 4096) itemoff 15760 itemsize 53
> 		generation 7 type 1 (regular)
> 		extent data disk byte 14680064 nr 4096
> 		extent data offset 0 nr 4096 ram 4096
> 	item 8 key (257 EXTENT_DATA 8192) itemoff 15707 itemsize 53
> 		generation 6 type 1 (regular)
> 		extent data disk byte 13631488 nr 1048576
> 		extent data offset 8192 nr 1040384 ram 1048576
> 
> EXTENT_DATA items at 0 and 8K offset are original from one larger
> extent, EXTENT_DATA item at 4K offset is newly written one.

Okay this makes sense, however if we take item 8 being inserted then
according to the comments, the 'offset' member for this data ref will be
0 since 8k (from key.offset) - 8k (from btrfs_file_extent_offset)?  WHy
is that, shouldn't the offset here be 8k rather than 0?

> 
> But the current design makes EXTENT_ITEM inline data backref pretty clean:
> 
>         item 0 key (13631488 EXTENT_ITEM 1048576) itemoff 16230 itemsize 53
>                 refs 2 gen 6 flags DATA
>                 extent data backref root FS_TREE objectid 257 offset 0
> count 2
> 
> No need for an extra inline data backref, just increase the original
> count from 1 to 2.
>>
>> So if file foo is shared between two snapshots, has 1 extent and in
>> snapshot2 this extent is partially changed then I'd expect extent_offset
>> to point to the start in the original (unchanged extent), correct?
> 
> As long as there is some new DATA_EXTENT pointing to the original
> unchanged extent, then yes, the 'offset' will change.
> 
> Just like the EXTENT_DATA at 8K offset above.
> 
>>
>>> +	u64 offset;
>>> +};
>>> +
>>> +struct btrfs_tree_ref {
>>> +	/*
>>> +	 * Level of this tree block
>>> +	 *
>>> +	 * Shared for skinny (TREE_BLOCK_REF) and normal tree ref.
>>
>> This sentence is also not very clear? You mean this level applies to
>> tree block refs (irrespective of whether they are shared or normal tree
>> block refs)?
> 
> This is for any keyed or inlined tree ref who uses skinny metadata
> (level stored in key.offset, the common case now) or non-skinny
> EXTENT_ITEM who uses btrfs_tree_block_info like:
> 
> 	item 7 key (30507008 EXTENT_ITEM 16384) itemoff 15956 itemsize 51
> 		refs 1 gen 4 flags TREE_BLOCK
> 		tree block key (0 UNKNOWN.0 0) level 0 <<< here.
> 		tree block backref root UUID_TREE
> 
> 
> It's possible for extent tree to not include above cases, like the
> following case:
>         item 1 key (12648448 EXTENT_ITEM 16384) itemoff 16235 itemsize 24
>                 refs 9 gen 7 flags TREE_BLOCK
>         item 2 key (12648448 SHARED_BLOCK_REF 4481024) itemoff 3461
> itemsize 0
>                 shared block backref
> 
> So I'm not sure how to describe such case clearly.
> 
> Thanks,
> Qu
> 
>>
>>> +	 */
>>> +	int level;
>>> +
>>> +	/*
>>> +	 * Root who refers to this tree block.
>>
>> nit:s/who/which
>>
>>> +	 *
>>> +	 * For TREE_BLOCK_REF (skinny metadata, either inline or keyed)
>>> +	 */
>>> +	u64 root;
>>> +
>>> +	/* For non-skinny metadata, no special member needed */
>>> +};
>>> +
>>> +struct btrfs_ref {
>>> +	enum btrfs_ref_type type;
>>> +	int action;
>>> +
>>> +	/*
>>> +	 * Only use parent pointers as backref (SHARED_BLOCK_REF or
>>> +	 * SHARED_DATA_REF) for this extent and its children.
>>> +	 * Set for reloc trees.
>>> +	 */
>>> +	bool only_backreferences:1;
>>> +
>>> +	/*
>>> +	 * Whether this extent should go through qgroup record.
>>> +	 *
>>> +	 * Normally false, but for certain case like delayed subtree scan,
>>> +	 * setting this flag can hugely reduce qgroup overhead.
>>> +	 */
>>> +	bool skip_qgroup:1;
>>> +
>>> +	/*
>>> +	 * Optional. To which root this modification is for.
>>> +	 * Mostly used for qgroup optimization.
>>> +	 *
>>> +	 * When unset, data/tree ref init code will populate it.
>>> +	 * In certain case, we're modifying reference for a different root.
>>> +	 * E.g. Cow fs tree blocks for balance.
>>> +	 * In that case, tree_ref::root will be fs tree, but we're doing this
>>> +	 * for reloc tree, then we should set @real_root to reloc tree.
>>> +	 */
>>> +	u64 real_root;
>>> +	u64 bytenr;
>>> +	u64 len;
>>> +
>>> +	/* Bytenr of the parent tree block */
>>> +	u64 parent;
>>> +	union {
>>> +		struct btrfs_data_ref data_ref;
>>> +		struct btrfs_tree_ref tree_ref;
>>> +	};
>>> +};
>>> +
>>>  extern struct kmem_cache *btrfs_delayed_ref_head_cachep;
>>>  extern struct kmem_cache *btrfs_delayed_tree_ref_cachep;
>>>  extern struct kmem_cache *btrfs_delayed_data_ref_cachep;
>>> @@ -195,6 +279,38 @@ extern struct kmem_cache *btrfs_delayed_extent_op_cachep;
>>>  int __init btrfs_delayed_ref_init(void);
>>>  void __cold btrfs_delayed_ref_exit(void);
>>>  
>>> +static inline void btrfs_init_generic_ref(struct btrfs_ref *generic_ref,
>>> +				int action, u64 bytenr, u64 len, u64 parent)
>>> +{
>>> +	generic_ref->action = action;
>>> +	generic_ref->bytenr = bytenr;
>>> +	generic_ref->len = len;
>>> +	generic_ref->parent = parent;
>>> +}
>>> +
>>> +static inline void btrfs_init_tree_ref(struct btrfs_ref *generic_ref,
>>> +				int level, u64 root)
>>> +{
>>> +	/* If @real_root not set, use @root as fallback */
>>> +	if (!generic_ref->real_root)
>>> +		generic_ref->real_root = root;
>>> +	generic_ref->tree_ref.level = level;
>>> +	generic_ref->tree_ref.root = root;
>>> +	generic_ref->type = BTRFS_REF_METADATA;
>>> +}
>>> +
>>> +static inline void btrfs_init_data_ref(struct btrfs_ref *generic_ref,
>>> +				u64 ref_root, u64 ino, u64 offset)
>>> +{
>>> +	/* If @real_root not set, use @root as fallback */
>>> +	if (!generic_ref->real_root)
>>> +		generic_ref->real_root = ref_root;
>>> +	generic_ref->data_ref.ref_root = ref_root;
>>> +	generic_ref->data_ref.ino = ino;
>>> +	generic_ref->data_ref.offset = offset;
>>> +	generic_ref->type = BTRFS_REF_DATA;
>>> +}
>>> +
>>>  static inline struct btrfs_delayed_extent_op *
>>>  btrfs_alloc_delayed_extent_op(void)
>>>  {
>>>
> 
