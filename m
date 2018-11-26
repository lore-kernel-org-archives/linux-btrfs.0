Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACD4C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 09:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0A1A20850
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 09:44:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0A1A20850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbeKZUiH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 15:38:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:46564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726184AbeKZUiH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 15:38:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 75CFFACA9;
        Mon, 26 Nov 2018 09:44:31 +0000 (UTC)
Subject: Re: [PATCH 6/6] btrfs: fix truncate throttling
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20181121185912.24288-1-josef@toxicpanda.com>
 <20181121185912.24288-7-josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <c37d25d1-bdfd-3c76-ff04-f90126e1c53e@suse.com>
Date:   Mon, 26 Nov 2018 11:44:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181121185912.24288-7-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 21.11.18 г. 20:59 ч., Josef Bacik wrote:
> We have a bunch of magic to make sure we're throttling delayed refs when
> truncating a file.  Now that we have a delayed refs rsv and a mechanism
> for refilling that reserve simply use that instead of all of this magic.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/inode.c | 79 ++++++++++++--------------------------------------------
>  1 file changed, 17 insertions(+), 62 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8532a2eb56d1..cae30f6c095f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4437,31 +4437,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
>  	return err;
>  }
>  
> -static int truncate_space_check(struct btrfs_trans_handle *trans,
> -				struct btrfs_root *root,
> -				u64 bytes_deleted)
> -{
> -	struct btrfs_fs_info *fs_info = root->fs_info;
> -	int ret;
> -
> -	/*
> -	 * This is only used to apply pressure to the enospc system, we don't
> -	 * intend to use this reservation at all.
> -	 */
> -	bytes_deleted = btrfs_csum_bytes_to_leaves(fs_info, bytes_deleted);
> -	bytes_deleted *= fs_info->nodesize;
> -	ret = btrfs_block_rsv_add(root, &fs_info->trans_block_rsv,
> -				  bytes_deleted, BTRFS_RESERVE_NO_FLUSH);
> -	if (!ret) {
> -		trace_btrfs_space_reservation(fs_info, "transaction",
> -					      trans->transid,
> -					      bytes_deleted, 1);
> -		trans->bytes_reserved += bytes_deleted;
> -	}
> -	return ret;
> -
> -}
> -
>  /*
>   * Return this if we need to call truncate_block for the last bit of the
>   * truncate.
> @@ -4506,7 +4481,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  	u64 bytes_deleted = 0;
>  	bool be_nice = false;
>  	bool should_throttle = false;
> -	bool should_end = false;
>  
>  	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
>  
> @@ -4719,15 +4693,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  				btrfs_abort_transaction(trans, ret);
>  				break;
>  			}
> -			if (btrfs_should_throttle_delayed_refs(trans))
> -				btrfs_async_run_delayed_refs(fs_info,
> -					trans->delayed_ref_updates * 2,
> -					trans->transid, 0);
>  			if (be_nice) {
> -				if (truncate_space_check(trans, root,
> -							 extent_num_bytes)) {
> -					should_end = true;
> -				}
>  				if (btrfs_should_throttle_delayed_refs(trans))
>  					should_throttle = true;
>  			}
> @@ -4738,7 +4704,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  
>  		if (path->slots[0] == 0 ||
>  		    path->slots[0] != pending_del_slot ||
> -		    should_throttle || should_end) {
> +		    should_throttle) {
>  			if (pending_del_nr) {
>  				ret = btrfs_del_items(trans, root, path,
>  						pending_del_slot,
> @@ -4750,23 +4716,24 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  				pending_del_nr = 0;
>  			}
>  			btrfs_release_path(path);
> -			if (should_throttle) {
> -				unsigned long updates = trans->delayed_ref_updates;
> -				if (updates) {
> -					trans->delayed_ref_updates = 0;
> -					ret = btrfs_run_delayed_refs(trans,
> -								   updates * 2);
> -					if (ret)
> -						break;
> -				}
> -			}
> +
>  			/*
> -			 * if we failed to refill our space rsv, bail out
> -			 * and let the transaction restart
> +			 * We can generate a lot of delayed refs, so we need to
> +			 * throttle every once and a while and make sure we're
> +			 * adding enough space to keep up with the work we are
> +			 * generating.  Since we hold a transaction here we
> +			 * can't flush, and we don't want to FLUSH_LIMIT because
> +			 * we could have generated too many delayed refs to
> +			 * actually allocate, so just bail if we're short and
> +			 * let the normal reservation dance happen higher up.
>  			 */
> -			if (should_end) {
> -				ret = -EAGAIN;
> -				break;
> +			if (should_throttle) {
> +				ret = btrfs_throttle_delayed_refs(fs_info,
> +							BTRFS_RESERVE_NO_FLUSH);
> +				if (ret) {
> +					ret = -EAGAIN;
> +					break;
> +				}
>  			}
>  			goto search_again;
>  		} else {
> @@ -4792,18 +4759,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  	}
>  
>  	btrfs_free_path(path);
> -
> -	if (be_nice && bytes_deleted > SZ_32M && (ret >= 0 || ret == -EAGAIN)) {
> -		unsigned long updates = trans->delayed_ref_updates;
> -		int err;
> -
> -		if (updates) {
> -			trans->delayed_ref_updates = 0;
> -			err = btrfs_run_delayed_refs(trans, updates * 2);
> -			if (err)
> -				ret = err;
> -		}
> -	}
>  	return ret;
>  }
>  
> 
