Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50427 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751705AbeDYNTb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 09:19:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC510ADDF
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 13:19:30 +0000 (UTC)
Date: Wed, 25 Apr 2018 15:16:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Change bit number of BTRFS_FS_BALANCE_RUNNING
Message-ID: <20180425131657.GO21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524660809-9065-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524660809-9065-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 25, 2018 at 03:53:29PM +0300, Nikolay Borisov wrote:
> Commit ddd93ef3b9d6 ("btrfs: track running balance in a simpler way")
> which introduced this bit assigned it number 17. Unfortunately this bit
> is already occupied by the BTRFS_FS_NEED_ASYNC_COMMIT bit. This was
> causing bit 17 to be cleared while __btrfs_balance was running which
> resulted in fs_info->balance_ctl being deleted while we have balance
> running. This manifested in an UAF crash. Fix it by putting the
> definition of the newly introduced balance bit after NEED_ASYNC_COMMIT
> and giving it number 18.
> 
> Fixes: ddd93ef3b9d6 ("btrfs: track running balance in a simpler way")

Uh, thanks for catching it. The bit was free when the volume mutex
removal patchset was in development, but the number 17 got used by the
recent qgroup patch and I did not adjust it afterwards.

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ctree.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 59998d5f6985..5a7893d7c668 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -733,16 +733,16 @@ struct btrfs_delayed_root;
>   */
>  #define BTRFS_FS_EXCL_OP			16
>  /*
> - * Indicate that balance has been set up from the ioctl and is in the main
> - * phase. The fs_info::balance_ctl is initialized.
> - */
> -#define BTRFS_FS_BALANCE_RUNNING		17
> -
> -/*
>   * To info transaction_kthread we need an immediate commit so it doesn't
>   * need to wait for commit_interval
>   */
>  #define BTRFS_FS_NEED_ASYNC_COMMIT		17
> +/*
> + * Indicate that balance has been set up from the ioctl and is in the main
> + * phase. The fs_info::balance_ctl is initialized.
> + */
> +#define BTRFS_FS_BALANCE_RUNNING		18

I'll fold the fix so we don't have an intermediate breakage in the
history.
