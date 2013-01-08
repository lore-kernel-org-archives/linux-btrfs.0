Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568Ab3AHTq5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 14:46:57 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r08Jkvk7016664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2013 14:46:57 -0500
Message-ID: <50EC77B0.3050400@redhat.com>
Date: Tue, 08 Jan 2013 13:46:56 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix btrfs_cont_expand() freeing IS_ERR em
References: <1357673878-25591-1-git-send-email-zab@redhat.com>
In-Reply-To: <1357673878-25591-1-git-send-email-zab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/8/13 1:37 PM, Zach Brown wrote:
> btrfs_cont_expand() tries to free an IS_ERR em as it gets an error from
> btrfs_get_extent() and breaks out of its loop.
> 
> An instance of -EEXIST was reported in the wild:
> 
>   https://bugzilla.redhat.com/show_bug.cgi?id=874407
> 
> I have no idea if that -EEXIST is surprising, or not.  Regardless, this
> error handling should be cleaned up to handle other reasonable errors
> (ENOMEM, EIO; whatever).
> 
> This seemed to be the only buggy freeing of the relatively rare IS_ERR
> em so I opted to fix the caller rather than teach free_extent_map() to
> use IS_ERR_OR_NULL().
> 
> Signed-off-by: Zach Brown <zab@redhat.com>

Looks good (maybe IS_ERR_OR_NULL would be more future-proof, but *shrug*)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/btrfs/inode.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index edd30ae..0bc7bb3 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3690,6 +3690,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
>  				block_end - cur_offset, 0);
>  		if (IS_ERR(em)) {
>  			err = PTR_ERR(em);
> +			em = NULL;
>  			break;
>  		}
>  		last_byte = min(extent_map_end(em), block_end);
> 

