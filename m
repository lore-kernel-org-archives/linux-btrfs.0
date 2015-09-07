Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbbIGMZF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Sep 2015 08:25:05 -0400
Date: Mon, 7 Sep 2015 14:24:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: memset cur_trans->delayed_refs to zero
Message-ID: <20150907122419.GT11834@suse.cz>
Reply-To: dsterba@suse.cz
References: <20150906122527.GA21685@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150906122527.GA21685@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 06, 2015 at 12:25:27PM +0000, Alexandru Moise wrote:
> Use memset() to null out the btrfs_delayed_ref_root of
> btrfs_transaction instead of setting all the members to 0 by hand.
> 
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
> ---
>  fs/btrfs/transaction.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 8f259b3..faccc1b 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -224,15 +224,7 @@ loop:
>  	cur_trans->start_time = get_seconds();
>  	cur_trans->dirty_bg_run = 0;
>  
> -	cur_trans->delayed_refs.href_root = RB_ROOT;
> -	cur_trans->delayed_refs.dirty_extent_root = RB_ROOT;
> -	atomic_set(&cur_trans->delayed_refs.num_entries, 0);

Please keep these. Even if it means duplicated setting to 0, it's using
the correct constructor, should it ever change (RB_ROOT) or does some
extra work (atomic_set).
