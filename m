Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36877 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab2IQQ4d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 12:56:33 -0400
Date: Mon, 17 Sep 2012 18:56:27 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4 01/12] Btrfs: fix error path in
 create_pending_snapshot()
Message-ID: <20120917165627.GW17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50487434.1010305@cn.fujitsu.com>
 <50487440.7050202@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50487440.7050202@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2012 at 06:00:32PM +0800, Miao Xie wrote:
> This patch fixes the following problem:
> - If we failed to deal with the delayed dir items, we should abort transaction,
>   just as its comment said. Fix it.
> - If root reference or root back reference insertion failed, we should
>   abort transaction. Fix it.
> - Fix the double free problem of pending->inherit.
> - Do not restore the trans->rsv if we doesn't change it.
> - make the error path more clearly.

I've noticed a pattern in the error + transaction abort paths, that is
touched in this patch and would like to ask you to update it:

> @@ -1018,10 +1016,9 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  				BTRFS_FT_DIR, index);
>  	if (ret == -EEXIST) {
>  		pending->error = -EEXIST;
> -		dput(parent);
>  		goto fail;

normal exit path: here we don't abort transaction, just go the exit
block and do the cleanup

>  	} else if (ret) {
> -		goto abort_trans_dput;
> +		goto abort_trans;

a transaction abort path: here we jump to a common block that calls
abort, but we lose the information where the abort occured

I went through the code and saw several uses of this pattern (and I
remember more than one bugreport that pointed to a abort_transaction
call without leaving any traces what condition failed).

(Search regex I used 'goto.*abort')

So the proposed pattern to use is

---
	if (condition) {
		btrfs_transaction_abort(...);
		goto fail;
	}


fail:
	<cleanup>
	return ...;
---

> @@ -1120,15 +1114,15 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  	ret = btrfs_reloc_post_snapshot(trans, pending);
>  	if (ret)
>  		goto abort_trans;
> -	ret = 0;
>  fail:
> -	kfree(new_root_item);
> +	dput(parent);
>  	trans->block_rsv = rsv;
> +no_free_objectid:
> +	kfree(new_root_item);
> +root_item_alloc_fail:
>  	btrfs_block_rsv_release(root, &pending->block_rsv, (u64)-1);
>  	return ret;
>  
> -abort_trans_dput:
> -	dput(parent);
>  abort_trans:
>  	btrfs_abort_transaction(trans, root, ret);
>  	goto fail;
^^^^^^^^^^^^^^^^
(end of function here)

this will also remove all the instances where a function ends with a
'goto'. All instances are convertible to the pattern described above.

Atlernate approach that I originally considered for fixing was to
introduce a call like 'btrfs_mark_transaction_abort_callsite' which
would need to add a field to fs_info and print it later. But, if we're
going to touch all the code, it makes sense to utilize the
infrastructure we already have.

Please consider updating your patch, I'll send a separate patch that
deals with aborts outside of create_pending_snapshot.

TIA,
david
