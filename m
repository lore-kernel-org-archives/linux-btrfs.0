Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35458 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751301AbdGQSbv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 14:31:51 -0400
Date: Mon, 17 Jul 2017 20:30:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: add skeleton code for compression heuristic
Message-ID: <20170717183035.GR2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170717135258.15865-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170717135258.15865-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So it basically looks good, I could not resist and rewrote the changelog
and comments. There's one code fix:

On Mon, Jul 17, 2017 at 04:52:58PM +0300, Timofey Titovets wrote:
> -static inline int inode_need_compress(struct inode *inode)
> +static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> 
>  	/* force compress */
>  	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
> -		return 1;
> +		return btrfs_compress_heuristic(inode, start, end);

This must stay 'return 1', if force-compress is on, so the change is
reverted.

I'm adding the patch to for-next.

>  	/* bad compression ratios */
>  	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
>  		return 0;
>  	if (btrfs_test_opt(fs_info, COMPRESS) ||
>  	    BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||
>  	    BTRFS_I(inode)->force_compress)
> -		return 1;
> +		return btrfs_compress_heuristic(inode, start, end);
>  	return 0;
>  }
