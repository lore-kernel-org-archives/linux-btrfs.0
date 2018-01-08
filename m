Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42204 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932155AbeAHTbg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 14:31:36 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 19399AD6E
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Jan 2018 19:31:35 +0000 (UTC)
Date: Mon, 8 Jan 2018 20:29:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] bytrfs-progs: Print error on invalid extent item format
 during check
Message-ID: <20180108192928.GL13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1514538104-20005-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1514538104-20005-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 29, 2017 at 11:01:44AM +0200, Nikolay Borisov wrote:
> While performing normal mode check if the code comes across an invalid
> extent format it will just BUG() and exit without printing any useful
> information for debugging. Improve the situation by outputting the
> key/leaf bytenr/slot which will enable to quickly inspect the tree and
> see what the corruption is.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Applied, thanks.

> ---
>  cmds-check.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index a93ac2c88a38..371516709ed8 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -8362,7 +8362,12 @@ static int process_extent_item(struct btrfs_root *root,
>  	if (item_size < sizeof(*ei)) {
>  #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
>  		struct btrfs_extent_item_v0 *ei0;
> -		BUG_ON(item_size != sizeof(*ei0));
> +		if (item_size != sizeof(*ei0)) {
> +			error("invalid extent item format: ITEM[%llu %u %llu] leaf: %llu slot: %d",

String un-indented.
