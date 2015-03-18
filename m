Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651AbbCRN4C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 09:56:02 -0400
Date: Wed, 18 Mar 2015 14:56:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] Btrfs: just free dummy extent buffers
Message-ID: <20150318135600.GB20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1426624683-3085-1-git-send-email-jbacik@fb.com>
 <1426624683-3085-3-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426624683-3085-3-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 17, 2015 at 04:38:01PM -0400, Josef Bacik wrote:
> If we fail during our sanity tests we could get NULL deref's because we unload
> the module before the dummy extent buffers are free'd via RCU.  So check for
> this case and just free the things directly.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent_io.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 29850d4..d13cead 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4968,6 +4968,12 @@ static int release_extent_buffer(struct extent_buffer *eb)
>  
>  		/* Should be safe to release our pages at this point */
>  		btrfs_release_extent_buffer_page(eb);
> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS

Please use btrfs_test_is_dummy_root, it's there to avoid the #ifdefs

> +		if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))) {
> +			__free_extent_buffer(eb);
> +			return 1;
> +		}
> +#endif
>  		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
>  		return 1;
>  	}
