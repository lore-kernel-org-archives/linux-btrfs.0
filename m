Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39563 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbdLDTdQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 14:33:16 -0500
Date: Mon, 4 Dec 2017 20:31:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add helper for device path or missing
Message-ID: <20171204193116.GA3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171128024310.31095-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171128024310.31095-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 28, 2017 at 10:43:10AM +0800, Anand Jain wrote:
> This patch creates a helper function to get either the rcu device path
> or missing.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/dev-replace.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 7c655f9a7a50..4b6ceb38cb5f 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -304,6 +304,11 @@ void btrfs_after_dev_replace_commit(struct btrfs_fs_info *fs_info)
>  		dev_replace->cursor_left_last_write_of_item;
>  }
>  
> +static inline char *dev_missing_or_rcu_str(struct btrfs_device *device)
> +{
> +	return device->missing ? "<missing disk>" : rcu_str_deref(device->name);
> +}

I'd change it to dev_name, as long as it stays a local helper in
dev-replace. I'm now merging the dev_state patches which depend on this
patch so I'll rename it myself so you don't have to refresh and resend
the patches.

