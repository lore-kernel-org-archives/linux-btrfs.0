Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301Ab3HGUCc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 16:02:32 -0400
Date: Wed, 7 Aug 2013 13:02:30 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: deal with enomem in the rewind path V2
Message-ID: <20130807200230.GT12314@lenny.home.zabbo.net>
References: <1375902376-13632-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375902376-13632-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1211,7 +1211,8 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
>  		BUG_ON(tm->slot != 0);
>  		eb_rewin = alloc_dummy_extent_buffer(eb->start,
>  						fs_info->tree_root->nodesize);
> -		BUG_ON(!eb_rewin);
> +		if (!eb_rewin)
> +			return ERR_PTR(-ENOMEM);

Don't these error paths need to unlock and free eb...

> @@ -2772,6 +2774,10 @@ again:
>  							  BTRFS_READ_LOCK);
>  			}
>  			b = tree_mod_log_rewind(root->fs_info, b, time_seq);
> +			if (IS_ERR(b)) {
> +				ret = PTR_ERR(b);
> +				goto done;
> +			}

... because this b = doit(, b, ) will leak the b input eb if the b
return is an error pointer?

- z
