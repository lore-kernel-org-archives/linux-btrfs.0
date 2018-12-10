Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475ECC04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 09:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F067020821
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 09:21:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F067020821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbeLJJVO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 04:21:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:60422 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726209AbeLJJVO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 04:21:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2787EADDD
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Dec 2018 09:21:11 +0000 (UTC)
Subject: Re: [PATCH 3/8] btrfs: delayed-ref: Use btrfs_ref to refactor
 btrfs_add_delayed_tree_ref()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181206065903.11343-1-wqu@suse.com>
 <20181206065903.11343-4-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <167bf109-41cf-f10b-4364-9af5701f5ee0@suse.com>
Date:   Mon, 10 Dec 2018 11:21:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181206065903.11343-4-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 6.12.18 г. 8:58 ч., Qu Wenruo wrote:
> btrfs_add_delayed_tree_ref() has a longer and longer parameter list, and
> some caller like btrfs_inc_extent_ref() are using @owner as level for
> delayed tree ref.
> 
> Instead of making the parameter list longer and longer, use btrfs_ref to
> refactor it, so each parameter assignment should be self-explaining
> without dirty level/owner trick, and provides the basis for later refactor.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/delayed-ref.c | 24 ++++++++++++++-------
>  fs/btrfs/delayed-ref.h |  4 +---
>  fs/btrfs/extent-tree.c | 48 ++++++++++++++++++++++++------------------
>  3 files changed, 44 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 11dd46be4017..c42b8ade7b07 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -710,9 +710,7 @@ static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
>   * transaction commits.
>   */
>  int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
> -			       u64 bytenr, u64 num_bytes, u64 parent,
> -			       u64 ref_root,  int level, bool for_reloc,
> -			       int action,
> +			       struct btrfs_ref *generic_ref,
>  			       struct btrfs_delayed_extent_op *extent_op,
>  			       int *old_ref_mod, int *new_ref_mod)
>  {
> @@ -722,10 +720,17 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>  	struct btrfs_delayed_ref_root *delayed_refs;
>  	struct btrfs_qgroup_extent_record *record = NULL;
>  	int qrecord_inserted;
> -	bool is_system = (ref_root == BTRFS_CHUNK_TREE_OBJECTID);
> +	bool is_system = (generic_ref->real_root == BTRFS_CHUNK_TREE_OBJECTID);
> +	int action = generic_ref->action;
> +	int level = generic_ref->tree_ref.level;
>  	int ret;
> +	u64 bytenr = generic_ref->bytenr;
> +	u64 num_bytes = generic_ref->len;
> +	u64 parent = generic_ref->parent;
>  	u8 ref_type;
>  
> +	ASSERT(generic_ref && generic_ref->type == BTRFS_REF_METADATA &&
> +		generic_ref->action);

You have already dereferenced generic_ref by the time you ASSERT and
would have crashed. I guess the first condition in the assert can be
removed.

>  	BUG_ON(extent_op && extent_op->is_data);
>  	ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
>  	if (!ref)

<snip>

> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2031,6 +2031,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>  			 bool for_reloc)
>  {
>  	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct btrfs_ref generic_ref = { 0 };
>  	int old_ref_mod, new_ref_mod;
>  	int ret;
>  
> @@ -2040,13 +2041,13 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>  	btrfs_ref_tree_mod(root, bytenr, num_bytes, parent, root_objectid,
>  			   owner, offset, BTRFS_ADD_DELAYED_REF);
>  
> +	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_REF, bytenr,
> +			       num_bytes, root->root_key.objectid, parent);
> +	generic_ref.skip_qgroup = for_reloc;
>  	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
> -		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
> -						 num_bytes, parent,
> -						 root_objectid, (int)owner,
> -						 for_reloc,
> -						 BTRFS_ADD_DELAYED_REF, NULL,
> -						 &old_ref_mod, &new_ref_mod);
> +		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);

The cast is now redundant since the parameter definition of
btrfs_init_tree_ref is an int.
> +		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
> +				NULL, &old_ref_mod, &new_ref_mod);
>  	} else {
>  		ret = btrfs_add_delayed_data_ref(trans, root, bytenr,
>  						 num_bytes, parent,

<snip>

> @@ -7102,11 +7110,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>  		old_ref_mod = new_ref_mod = 0;
>  		ret = 0;
>  	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
> -		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
> -						 num_bytes, parent,
> -						 root_objectid, (int)owner,
> -						 for_reloc,
> -						 BTRFS_DROP_DELAYED_REF, NULL,
> +		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);

ditto about the cast
> +		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
>  						 &old_ref_mod, &new_ref_mod);
>  	} else {
>  		ret = btrfs_add_delayed_data_ref(trans, root, bytenr,

<sniop>
