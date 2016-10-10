Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53054 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753015AbcJJPu2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 11:50:28 -0400
Date: Mon, 10 Oct 2016 17:50:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, lakshmipathi.g@gmail.com
Subject: Re: [PATCH 2/4] btrfs-progs: Make btrfs-debug-tree print all
 readable strings for inode flags
Message-ID: <20161010155026.GL11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161010031121.5017-1-quwenruo@cn.fujitsu.com>
 <20161010031121.5017-3-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161010031121.5017-3-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 10, 2016 at 11:11:19AM +0800, Qu Wenruo wrote:
> Before this patch, only 3 inode flags have readable string: NODATACOW,
> NODATASUM, READONLY.
> 
> This patch will output all readable strings for remaining inode flags,
> making debug-tree tool more handy.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  print-tree.c | 46 ++++++++++++++++++++++++++--------------------
>  1 file changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/print-tree.c b/print-tree.c
> index 4444a14..f015646 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -851,29 +851,35 @@ static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
>  	}
>  }
>  
> -/* Caller should ensure sizeof(*ret) >= 29 "NODATASUM|NODATACOW|READONLY" */
> +#define copy_one_inode_flag(flags, name, empty, dst) ({			\
> +	if (flags & BTRFS_INODE_##name) {				\
> +		if (!empty)						\
> +			strcat(dst, "|");				\
> +		strcat(dst, #name);					\
> +		empty = 0;						\
> +	}								\
> +})

Can you please avoid using the macro? Or at least make it uppercase so
it's visible. Similar in the next patch.
