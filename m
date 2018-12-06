Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A82CC04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 16:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37A3D20838
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 16:43:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37A3D20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbeLFQnv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 11:43:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:33486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbeLFQnv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 11:43:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1F096AEB2;
        Thu,  6 Dec 2018 16:43:48 +0000 (UTC)
Subject: Re: [PATCH 09/10] btrfs: don't run delayed refs in the end
 transaction logic
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20181203152038.21388-1-josef@toxicpanda.com>
 <20181203152038.21388-10-josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <c7ed4182-2dd8-f986-28af-35f0564cb914@suse.com>
Date:   Thu, 6 Dec 2018 18:43:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181203152038.21388-10-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.12.18 г. 17:20 ч., Josef Bacik wrote:
> Over the years we have built up a lot of infrastructure to keep delayed
> refs in check, mostly by running them at btrfs_end_transaction() time.
> We have a lot of different maths we do to figure out how much, if we
> should do it inline or async, etc.  This existed because we had no
> feedback mechanism to force the flushing of delayed refs when they
> became a problem.  However with the enospc flushing infrastructure in
> place for flushing delayed refs when they put too much pressure on the
> enospc system we have this problem solved.  Rip out all of this code as
> it is no longer needed.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/transaction.c | 38 --------------------------------------
>  1 file changed, 38 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 2d8401bf8df9..01f39401619a 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -798,22 +798,12 @@ static int should_end_transaction(struct btrfs_trans_handle *trans)
>  int btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
>  {
>  	struct btrfs_transaction *cur_trans = trans->transaction;
> -	int updates;
> -	int err;
>  
>  	smp_mb();
>  	if (cur_trans->state >= TRANS_STATE_BLOCKED ||
>  	    cur_trans->delayed_refs.flushing)
>  		return 1;
>  
> -	updates = trans->delayed_ref_updates;
> -	trans->delayed_ref_updates = 0;
> -	if (updates) {
> -		err = btrfs_run_delayed_refs(trans, updates * 2);
> -		if (err) /* Error code will also eval true */
> -			return err;
> -	}
> -
>  	return should_end_transaction(trans);
>  }
>  
> @@ -843,11 +833,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  {
>  	struct btrfs_fs_info *info = trans->fs_info;
>  	struct btrfs_transaction *cur_trans = trans->transaction;
> -	u64 transid = trans->transid;
> -	unsigned long cur = trans->delayed_ref_updates;
>  	int lock = (trans->type != TRANS_JOIN_NOLOCK);
>  	int err = 0;
> -	int must_run_delayed_refs = 0;
>  
>  	if (refcount_read(&trans->use_count) > 1) {
>  		refcount_dec(&trans->use_count);
> @@ -858,27 +845,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  	btrfs_trans_release_metadata(trans);
>  	trans->block_rsv = NULL;
>  
> -	if (!list_empty(&trans->new_bgs))
> -		btrfs_create_pending_block_groups(trans);

Is this being deleted because in delayed_refs_rsv you account also fo
new block groups?

> -
> -	trans->delayed_ref_updates = 0;
> -	if (!trans->sync) {
> -		must_run_delayed_refs =
> -			btrfs_should_throttle_delayed_refs(trans);
> -		cur = max_t(unsigned long, cur, 32);
> -
> -		/*
> -		 * don't make the caller wait if they are from a NOLOCK
> -		 * or ATTACH transaction, it will deadlock with commit
> -		 */
> -		if (must_run_delayed_refs == 1 &&
> -		    (trans->type & (__TRANS_JOIN_NOLOCK | __TRANS_ATTACH)))
> -			must_run_delayed_refs = 2;
> -	}
> -
> -	btrfs_trans_release_metadata(trans);
> -	trans->block_rsv = NULL;

Why remove those 2 lines as well ?

> -
>  	if (!list_empty(&trans->new_bgs))
>  		btrfs_create_pending_block_groups(trans);
>  
> @@ -923,10 +889,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  	}
>  
>  	kmem_cache_free(btrfs_trans_handle_cachep, trans);
> -	if (must_run_delayed_refs) {
> -		btrfs_async_run_delayed_refs(info, cur, transid,
> -					     must_run_delayed_refs == 1);
> -	}
>  	return err;
>  }
>  
> 
