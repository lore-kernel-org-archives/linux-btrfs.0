Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9FFC04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 12:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0E9020892
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 12:38:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0E9020892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbeLFMi1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 07:38:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:39384 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727832AbeLFMi1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 07:38:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 33217AFCC;
        Thu,  6 Dec 2018 12:38:24 +0000 (UTC)
Subject: Re: [PATCH 02/10] btrfs: add cleanup_ref_head_accounting helper
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
 <20181203152038.21388-3-josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <cf65c838-74a9-4cdc-ff2c-4beb8f23cd6e@suse.com>
Date:   Thu, 6 Dec 2018 14:38:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181203152038.21388-3-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.12.18 г. 17:20 ч., Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> We were missing some quota cleanups in check_ref_cleanup, so break the
> ref head accounting cleanup into a helper and call that from both
> check_ref_cleanup and cleanup_ref_head.  This will hopefully ensure that
> we don't screw up accounting in the future for other things that we add.
> 
> Reviewed-by: Omar Sandoval <osandov@fb.com>
> Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Doesn't this also need a stable tag? Furthermore, doesn't the missing
code dealing with total_bytes_pinned in check_ref_cleanup mean that
every time the last reference for a block was freed we were leaking
bytes in total_bytes_pinned? Shouldn't this have lead to eventually
total_bytes_pinned dominating the usage in a space_info ?

Codewise lgtm:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/extent-tree.c | 67 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 39 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index c36b3a42f2bb..e3ed3507018d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2443,6 +2443,41 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
>  	return ret ? ret : 1;
>  }
>  
> +static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
> +					struct btrfs_delayed_ref_head *head)
> +{
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
> +	struct btrfs_delayed_ref_root *delayed_refs =
> +		&trans->transaction->delayed_refs;
> +
> +	if (head->total_ref_mod < 0) {
> +		struct btrfs_space_info *space_info;
> +		u64 flags;
> +
> +		if (head->is_data)
> +			flags = BTRFS_BLOCK_GROUP_DATA;
> +		else if (head->is_system)
> +			flags = BTRFS_BLOCK_GROUP_SYSTEM;
> +		else
> +			flags = BTRFS_BLOCK_GROUP_METADATA;
> +		space_info = __find_space_info(fs_info, flags);
> +		ASSERT(space_info);
> +		percpu_counter_add_batch(&space_info->total_bytes_pinned,
> +				   -head->num_bytes,
> +				   BTRFS_TOTAL_BYTES_PINNED_BATCH);
> +
> +		if (head->is_data) {
> +			spin_lock(&delayed_refs->lock);
> +			delayed_refs->pending_csums -= head->num_bytes;
> +			spin_unlock(&delayed_refs->lock);
> +		}
> +	}
> +
> +	/* Also free its reserved qgroup space */
> +	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
> +				      head->qgroup_reserved);
> +}
> +
>  static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>  			    struct btrfs_delayed_ref_head *head)
>  {
> @@ -2478,31 +2513,6 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>  	spin_unlock(&head->lock);
>  	spin_unlock(&delayed_refs->lock);
>  
> -	trace_run_delayed_ref_head(fs_info, head, 0);
> -
> -	if (head->total_ref_mod < 0) {
> -		struct btrfs_space_info *space_info;
> -		u64 flags;
> -
> -		if (head->is_data)
> -			flags = BTRFS_BLOCK_GROUP_DATA;
> -		else if (head->is_system)
> -			flags = BTRFS_BLOCK_GROUP_SYSTEM;
> -		else
> -			flags = BTRFS_BLOCK_GROUP_METADATA;
> -		space_info = __find_space_info(fs_info, flags);
> -		ASSERT(space_info);
> -		percpu_counter_add_batch(&space_info->total_bytes_pinned,
> -				   -head->num_bytes,
> -				   BTRFS_TOTAL_BYTES_PINNED_BATCH);
> -
> -		if (head->is_data) {
> -			spin_lock(&delayed_refs->lock);
> -			delayed_refs->pending_csums -= head->num_bytes;
> -			spin_unlock(&delayed_refs->lock);
> -		}
> -	}
> -
>  	if (head->must_insert_reserved) {
>  		btrfs_pin_extent(fs_info, head->bytenr,
>  				 head->num_bytes, 1);
> @@ -2512,9 +2522,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>  		}
>  	}
>  
> -	/* Also free its reserved qgroup space */
> -	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
> -				      head->qgroup_reserved);
> +	cleanup_ref_head_accounting(trans, head);
> +
> +	trace_run_delayed_ref_head(fs_info, head, 0);
>  	btrfs_delayed_ref_unlock(head);
>  	btrfs_put_delayed_ref_head(head);
>  	return 0;
> @@ -6991,6 +7001,7 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
>  	if (head->must_insert_reserved)
>  		ret = 1;
>  
> +	cleanup_ref_head_accounting(trans, head);
>  	mutex_unlock(&head->mutex);
>  	btrfs_put_delayed_ref_head(head);
>  	return ret;
> 
