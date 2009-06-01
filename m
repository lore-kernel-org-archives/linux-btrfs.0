From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Make an error msg look nicer by inserting a space between
 number and word.
Date: Mon, 1 Jun 2009 10:52:37 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0906011052040.11359@wotan.suse.de>
References: <1243825692-31516-1-git-send-email-hu.taoo@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, trivial@kernel.org,
	Hu Tao <hu.taoo@gmail.com>
To: Hu Tao <cnhutao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1243825692-31516-1-git-send-email-hu.taoo@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 1 Jun 2009, Hu Tao wrote:

> Signed-off-by: Hu Tao <hu.taoo@gmail.com>
> ---
>  fs/btrfs/extent-tree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 3e2c7c7..8bb0550 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -1843,7 +1843,7 @@ again:
>  
>  		printk(KERN_ERR "no space left, need %llu, %llu delalloc bytes"
>  		       ", %llu bytes_used, %llu bytes_reserved, "
> -		       "%llu bytes_pinned, %llu bytes_readonly, %llu may use"
> +		       "%llu bytes_pinned, %llu bytes_readonly, %llu may use "
>  		       "%llu total\n", (unsigned long long)bytes,
>  		       (unsigned long long)data_sinfo->bytes_delalloc,
>  		       (unsigned long long)data_sinfo->bytes_used,

Applied to trivial tree. If it has been picked up by subsystem tree, 
please let me know and I will drop it.

Thanks,

-- 
Jiri Kosina
