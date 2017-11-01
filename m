Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:53256 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754478AbdKAJqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 05:46:34 -0400
Date: Wed, 1 Nov 2017 14:46:32 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Move loop termination condition in while()
Message-ID: <20171101144632.7c0b9e95@natsu>
In-Reply-To: <1509528738-4387-1-git-send-email-nborisov@suse.com>
References: <1509528738-4387-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed,  1 Nov 2017 11:32:18 +0200
Nikolay Borisov <nborisov@suse.com> wrote:

> Fallocating a file in btrfs goes through several stages. The one before actually
> inserting the fallocated extents is to create a qgroup reservation, covering
> the desired range. To this end there is a loop in btrfs_fallocate which checks
> to see if there are holes in the fallocated range or !PREALLOC extents past EOF
> and if so create qgroup reservations for them. Unfortunately, the main condition
> of the loop is burried right at the end of its body rather than in the actual
> while statement which makes it non-obvious. Fix this by moving the condition
> in the while statement where it belongs. No functional changes.

If it turns out that "cur_offset >= alloc_end" from the get go, previously the
loop body would be entered and executed once. With this change, it will not
anymore.

I did not examine the context to see if such case is possible, likely,
beneficial or harmful. But if you wanted 100% no functional changes no matter
what, maybe better use a "do ... while" loop?

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/file.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index e0d15c0d1641..ecbe186cb5da 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -3168,7 +3168,7 @@ static long btrfs_fallocate(struct file *file, int mode,
>  
>  	/* First, check if we exceed the qgroup limit */
>  	INIT_LIST_HEAD(&reserve_list);
> -	while (1) {
> +	while (cur_offset < alloc_end) {
>  		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, cur_offset,
>  				      alloc_end - cur_offset, 0);
>  		if (IS_ERR(em)) {
> @@ -3204,8 +3204,6 @@ static long btrfs_fallocate(struct file *file, int mode,
>  		}
>  		free_extent_map(em);
>  		cur_offset = last_byte;
> -		if (cur_offset >= alloc_end)
> -			break;
>  	}
>  
>  	/*



-- 
With respect,
Roman
