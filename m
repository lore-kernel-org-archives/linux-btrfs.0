Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41296 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728313AbeIUUTd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 16:19:33 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3308DAEAE
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 14:30:24 +0000 (UTC)
Date: Fri, 21 Sep 2018 16:30:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: Factor out ref head locking code in
 __btrfs_run_delayed_refs
Message-ID: <20180921143021.GG5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534318796-23111-1-git-send-email-nborisov@suse.com>
 <1534318796-23111-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534318796-23111-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 15, 2018 at 10:39:54AM +0300, Nikolay Borisov wrote:
> This is in preparation to refactor the giant loop in
> __btrfs_run_delayed_refs. As a first step define a new function
> which implements acquiring a reference to a btrfs_delayed_refs_head and
> use it. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 54 ++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 37 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index de6f75f5547b..6a2c86c8a756 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2502,6 +2502,40 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>  	return 0;
>  }
>  
> +STATIC
> +struct btrfs_delayed_ref_head *btrfs_obtain_ref_head(
> +					struct btrfs_trans_handle *trans)

The STATIC is now gone from misc-next so it's just 'static'. Please
don't split the type and function name. It's allowed to fixup the style
once the function prototype is updated.

> +{
> +	struct btrfs_delayed_ref_root *delayed_refs =
> +		&trans->transaction->delayed_refs;
> +	struct btrfs_delayed_ref_head *head = NULL;
> +	int ret;
> +
> +	spin_lock(&delayed_refs->lock);
> +	head = btrfs_select_ref_head(trans);
> +	if (!head) {
> +		spin_unlock(&delayed_refs->lock);
> +		return head;
> +	}
> +
> +	/*
> +	 * grab the lock that says we are going to process  all the refs for
> +	 * this head
> +	 */
> +	ret = btrfs_delayed_ref_lock(trans, head);
> +	spin_unlock(&delayed_refs->lock);
> +	/*
> +	 * we may have dropped the spin lock to get the head
> +	 * mutex lock, and that might have given someone else
> +	 * time to free the head.  If that's true, it has been
> +	 * removed from our list and we can move on.
> +	 */

As you move the entire comment, you can reformat it or reword if you
find a better way what's is supposed to say.

Otherwise

Reviewed-by: David Sterba <dsterba@suse.com>
