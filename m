Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab3D3O2Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 10:28:16 -0400
Date: Tue, 30 Apr 2013 16:28:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix off-by-one in lseek
Message-ID: <20130430142811.GV16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1357530788-5790-1-git-send-email-bo.li.liu@oracle.com>
 <20130107162050.GJ20089@twin.jikos.cz>
 <20130108024637.GA1916@liubo>
 <20130108083053.GD3763@twin.jikos.cz>
 <20130108172627.GP20089@twin.jikos.cz>
 <20130109043443.GA4527@liubo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130109043443.GA4527@liubo>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 09, 2013 at 12:34:45PM +0800, Liu Bo wrote:
> Thanks for coding this up, I've checked the code, these messages can
> be fixed by the following, please check if it works on your side :)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 1b319df..1688669 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3895,7 +3913,7 @@ int extent_fiemap(struct inode *inode, struct
> fiemap_extent_info *fieinfo,
>  		last_for_get_extent = isize;
>  	}
>  
> -	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + len, 0,
> +	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + len - 1, 0,
>  			 &cached_state);
>  
>  	em = get_extent_skip_holes(inode, start, last_for_get_extent,
> @@ -3982,7 +4000,7 @@ int extent_fiemap(struct inode *inode, struct
> fiemap_extent_info *fieinfo,
>  out_free:
>  	free_extent_map(em);
>  out:
> -	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, start + len,
> +	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, start + len - 1,
>  			     &cached_state, GFP_NOFS);
>  	return ret;
>  }

can you please resend this as a proper patch? I'm sending the debugging
helper and found out that this is still not fixed. You can add my

Tested-by: David Sterba <dsterba@suse.cz>
