Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22647 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbaF2TYD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 15:24:03 -0400
Message-ID: <53B067CD.4050903@fb.com>
Date: Sun, 29 Jun 2014 15:23:57 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix use-after-free when cloning a trailing file
 hole
References: <1404071004-20724-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1404071004-20724-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/29/2014 03:43 PM, Filipe David Borba Manana wrote:
> The transaction handle was being used after being freed.
> 
> Cc: Chris Mason <clm@fb.com>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/ioctl.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 02dc64b..2562dc7 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3565,12 +3565,10 @@ process_slot:
>  			btrfs_end_transaction(trans, root);
>  			goto out;
>  		}
> -		ret = clone_finish_inode_update(trans, inode, destoff + len,
> -						destoff, olen);
> -		if (ret)
> -			goto out;
>  		clone_update_extent_map(inode, trans, path, NULL, last_dest_end,
>  					destoff + len - last_dest_end);
> +		ret = clone_finish_inode_update(trans, inode, destoff + len,
> +						destoff, olen);
>  	}
>  
>  out:
> 

What about the path?  It has been released, so it should either be NULL
or we have other problems ;)

-chris
