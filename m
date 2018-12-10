Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193BDC04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 09:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D26472082F
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 09:48:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D26472082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbeLJJsy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 04:48:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:36646 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726324AbeLJJsy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 04:48:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0ED3EAD6F
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Dec 2018 09:48:51 +0000 (UTC)
Subject: Re: [PATCH 1/8] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181206065903.11343-1-wqu@suse.com>
 <20181206065903.11343-2-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <235ca34f-bcda-128d-dc3d-7465766271c7@suse.com>
Date:   Mon, 10 Dec 2018 11:48:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181206065903.11343-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 6.12.18 г. 8:58 ч., Qu Wenruo wrote:
> Current delayed ref interface has several problems:
> - Longer and longer parameter lists
>   bytenr
>   num_bytes
>   parent
>   ref_root
>   owner
>   offset
>   for_reloc << Only qgroup code cares.
> 
> - Different interpretation for the same parameter
>   Above @owner for data ref is ino owning this extent,
>   while for tree ref, it's level. They are even in different size range.
>   For level we only need 0~8, while for ino it's
>   BTRFS_FIRST_FREE_OBJECTID~BTRFS_LAST_FREE_OBJECTID.
> 
>   And @offset doesn't even makes sense for tree ref.
> 
>   Such parameter reuse may look clever as an hidden union, but it
>   destroys code readability.
> 
> To solve both problems, we introduce a new structure, btrfs_ref to solve
> them:
> 
> - Structure instead of long parameter list
>   This makes later expansion easier, and better documented.
> 
> - Use btrfs_ref::type to distinguish data and tree ref
> 
> - Use proper union to store data/tree ref specific structures.
> 
> - Use separate functions to fill data/tree ref data, with a common generic
>   function to fill common bytenr/num_bytes members.
> 
> All parameters will find its place in btrfs_ref, and an extra member,
> real_root, inspired by ref-verify code, is newly introduced for later
> qgroup code, to record which tree is triggered this extent modification.
> 
> This patch doesn't touch any code, but provides the basis for incoming
> refactors.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/delayed-ref.h | 109 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 109 insertions(+)
> 
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index d8fa12d3f2cc..e36d6b05d85e 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -176,6 +176,81 @@ struct btrfs_delayed_ref_root {
>  	u64 qgroup_to_skip;
>  };
>  
> +enum btrfs_ref_type {
> +	BTRFS_REF_NOT_SET = 0,

No need for explicit initialisation when your enums start from 0.

> +	BTRFS_REF_DATA,
> +	BTRFS_REF_METADATA,
> +	BTRFS_REF_LAST,
> +};
> +
> +struct btrfs_data_ref {
> +	/*
> +	 * For EXTENT_DATA_REF
> +	 *
> +	 * @ref_root:	current owner of the extent.
> +	 * 		may differ from btrfs_ref::real_root.

Here 'owner' is a bit ambiguous. Isn't this the root of the owner

> +	 * @ino: 	inode number of the owner. 

And the owner is really the owning inode?

> +	 * @offset:	*CALCULATED* offset. Not EXTENT_DATA key offset.

What does calculated mean here?

> +	 *
> +	 */

Ugh, this is ugly, why not have a single /* */ line above each member
and document them like that?

> +	u64 ref_root;
> +	u64 ino;
> +	u64 offset;
> +};
> +
> +struct btrfs_tree_ref {
> +	/* Common for all sub types and skinny combination */
> +	int level;

Like you've done here. Mention that this is the level in the tree that
this reference is located at.

> +
> +	/*
> +	 * For TREE_BLOCK_REF (skinny metadata, either inline or keyed)
> +	 *
> +	 * root here may differ from btrfs_ref::real_root.
> +	 */

Make it refer to the documentation of the generic btrfs_ref structure
because if someone reads this comment and doesn't read the one in
btrfs_ref then it's not clear under what conditions they might differ.

> +	u64 root;
> +
> +	/* For non-skinny metadata, no special member needed */
> +};
> +
> +struct btrfs_ref {
> +	enum btrfs_ref_type type;
> +	int action;
> +
> +	/*
> +	 * Use full backref(SHARED_BLOCK_REF or SHARED_DATA_REF) for this
> +	 * extent and its children.
> +	 * Set for reloc trees.
> +	 */
> +	unsigned int use_fullback:1;

'fullback' is too terse, use_backreferences or something conveying more
information? Also please use explicit bool type:

bool xxxx:1

> +
> +	/*
> +	 * Whether this extent should go through qgroup record.
> +	 * Normally false, but for certain case like delayed subtree scan,
> +	 * this can hugely reduce qgroup overhead.
> +	 */
> +	unsigned int skip_qgroup:1;

again, explicit bool type please.

> +
> +	/*
> +	 * Who owns this reference modification, optional.
> +	 *
> +	 * One example:
> +	 * When creating reloc tree for source fs, it will increase tree block
> +	 * ref for children tree blocks.
> +	 * In that case, btrfs_ref::real_root = reloc tree,
> +	 * while btrfs_ref::tree_ref::root = fs tree.
> +	 */
> +	u64 real_root;
> +	u64 bytenr;
> +	u64 len;
> +
> +	/* Common @parent for SHARED_DATA_REF/SHARED_BLOCK_REF */

OK, it's common but what does it really contain? Either document it or
rename it to parent_block or something.

> +	u64 parent;
> +	union {
> +		struct btrfs_data_ref data_ref;
> +		struct btrfs_tree_ref tree_ref;
> +	};
> +};
> +
>  extern struct kmem_cache *btrfs_delayed_ref_head_cachep;
>  extern struct kmem_cache *btrfs_delayed_tree_ref_cachep;
>  extern struct kmem_cache *btrfs_delayed_data_ref_cachep;
> @@ -184,6 +259,40 @@ extern struct kmem_cache *btrfs_delayed_extent_op_cachep;
>  int __init btrfs_delayed_ref_init(void);
>  void __cold btrfs_delayed_ref_exit(void);
>  
> +static inline void btrfs_init_generic_ref(struct btrfs_ref *generic_ref,
> +				int action, u64 bytenr, u64 len, u64 real_root,
> +				u64 parent)
> +{
> +	generic_ref->action = action;

IMO it makes sense in this series to have a patch which converts the
action defines to an enum and subsequently modify functions/structs to
actually be of enum type.

> +	generic_ref->bytenr = bytenr;
> +	generic_ref->len = len;
> +	generic_ref->real_root = real_root;
> +	generic_ref->parent = parent;
> +}
> +
> +static inline void btrfs_init_tree_ref(struct btrfs_ref *generic_ref,
> +				int level, u64 root)
> +{
> +	/* If @real_root not set, use @root as fallback */
> +	if (!generic_ref->real_root)
> +		generic_ref->real_root = root;
> +	generic_ref->tree_ref.level = level;
> +	generic_ref->tree_ref.root = root;
> +	generic_ref->type = BTRFS_REF_METADATA;
> +}
> +
> +static inline void btrfs_init_data_ref(struct btrfs_ref *generic_ref,
> +				u64 ref_root, u64 ino, u64 offset)
> +{
> +	/* If @real_root not set, use @root as fallback */
> +	if (!generic_ref->real_root)
> +		generic_ref->real_root = ref_root;
> +	generic_ref->data_ref.ref_root = ref_root;
> +	generic_ref->data_ref.ino = ino;
> +	generic_ref->data_ref.offset = offset;
> +	generic_ref->type = BTRFS_REF_DATA;
> +}
> +
>  static inline struct btrfs_delayed_extent_op *
>  btrfs_alloc_delayed_extent_op(void)
>  {
> 
