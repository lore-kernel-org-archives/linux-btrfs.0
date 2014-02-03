Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaBCPGZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 10:06:25 -0500
Date: Mon, 3 Feb 2014 15:48:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: disable snapshot aware defrag for now
Message-ID: <20140203144802.GK1364@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1391029530-17686-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391029530-17686-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 29, 2014 at 04:05:30PM -0500, Josef Bacik wrote:
> It's just broken and it's taking a lot of effort to fix it, so for now just
> disable it so people can defrag in peace.  Thanks,
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3b65987..8c0bc31 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2628,7 +2628,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>  			EXTENT_DEFRAG, 1, cached_state);
>  	if (ret) {
>  		u64 last_snapshot = btrfs_root_last_snapshot(&root->root_item);
> -		if (last_snapshot >= BTRFS_I(inode)->generation)
> +		if (0 && last_snapshot >= BTRFS_I(inode)->generation)

That's not very flexible, how are we supposed to test that in the
meantime? Editing sources is not the peferred way.

I was thinking about adding a config option that would cover any
experimental/broken features, this one be the first, as we currently
have no other way to disable it. I'd rather avoid adding a temporary
mount option.
