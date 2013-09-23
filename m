Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab3IWPIJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 11:08:09 -0400
Message-ID: <52405958.4050209@redhat.com>
Date: Mon, 23 Sep 2013 10:08:08 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check if device supports trim
References: <1379695327-30046-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1379695327-30046-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/20/13 11:42 AM, David Sterba wrote:
> The message about trim was printed unconditionally, we should check if
> trim is supported at all.

Good idea, but I wonder if there's any risk that discard(0,0) will ever
be optimized away on the kernel side & pass unconditionally?

I was thinking we could get this from blkid, but maybe not.

In the meantime it does do the right thing, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  utils.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/utils.c b/utils.c
> index 5fa193b..6c74654 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -597,13 +597,16 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
>  	}
>  
>  	if (discard) {
> -		fprintf(stderr, "Performing full device TRIM (%s) ...\n",
> -				pretty_size(block_count));
>  		/*
> -		 * We intentionally ignore errors from the discard ioctl.  It is
> -		 * not necessary for the mkfs functionality but just an optimization.
> +		 * We intentionally ignore errors from the discard ioctl.  It
> +		 * is not necessary for the mkfs functionality but just an
> +		 * optimization.
>  		 */
> -		discard_blocks(fd, 0, block_count);
> +		if (discard_blocks(fd, 0, 0) == 0) {
> +			fprintf(stderr, "Performing full device TRIM (%s) ...\n",
> +				pretty_size(block_count));
> +			discard_blocks(fd, 0, block_count);
> +		}
>  	}
>  
>  	ret = zero_dev_start(fd);
> 

