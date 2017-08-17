Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53582 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752368AbdHQLro (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 07:47:44 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 433D5ABB1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 11:47:43 +0000 (UTC)
Date: Thu, 17 Aug 2017 13:46:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove never-reached WARN_ON
Message-ID: <20170817114620.GO2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1502956348-5041-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1502956348-5041-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 17, 2017 at 10:52:28AM +0300, Nikolay Borisov wrote:
> We have a WARN_ON(!var) inside an if branch which is executed (among others)
> only when var is true.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 21c78c48e15b..8552d550a048 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6755,7 +6755,6 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
>  		if (!readonly && return_free_space &&
>  		    global_rsv->space_info == space_info) {
>  			u64 to_add = len;
> -			WARN_ON(!return_free_space);

Right. And also an example where the coding style can be improved as a
sideefect, ie. the missing line between declarations and statements.

>  			spin_lock(&global_rsv->lock);
>  			if (!global_rsv->full) {
>  				to_add = min(len, global_rsv->size -
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
