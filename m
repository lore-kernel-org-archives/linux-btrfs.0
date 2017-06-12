Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55086 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751944AbdFLN10 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 09:27:26 -0400
Date: Mon, 12 Jun 2017 15:26:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Liu Bo <bo.li.liu@oracle.com>, kernel-team@fb.com
Subject: Re: [PATCH 2/7] Btrfs: make BUG_ON() in add_pinned_bytes() an
 ASSERT()
Message-ID: <20170612132621.GK25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1496792333.git.osandov@fb.com>
 <5e543709c942292f3e97cbd22fd3137dd521bb16.1496792333.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5e543709c942292f3e97cbd22fd3137dd521bb16.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 04:45:27PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 7c01b4e9e3b6..6032e9a635f2 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -782,7 +782,7 @@ static void add_pinned_bytes(struct btrfs_fs_info *fs_info, s64 num_bytes,
>  	}
>  
>  	space_info = __find_space_info(fs_info, flags);
> -	BUG_ON(!space_info); /* Logic bug */
> +	ASSERT(space_info);

Why?
