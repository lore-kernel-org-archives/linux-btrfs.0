Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:48754 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754507AbcK1M1P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 07:27:15 -0500
Date: Mon, 28 Nov 2016 17:27:10 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix hole read corruption for compressed inline
 extents
Message-ID: <20161128172710.202587ce@natsu>
In-Reply-To: <1480309392-4786-1-git-send-email-ce3g8jdj@umail.furryterror.org>
References: <1480309392-4786-1-git-send-email-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 28 Nov 2016 00:03:12 -0500
Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:

> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8e3a5a2..b1314d6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6803,6 +6803,12 @@ static noinline int uncompress_inline(struct btrfs_path *path,
>  	max_size = min_t(unsigned long, PAGE_SIZE, max_size);
>  	ret = btrfs_decompress(compress_type, tmp, page,
>  			       extent_offset, inline_size, max_size);
> +	WARN_ON(max_size > PAGE_SIZE);
> +	if (max_size < PAGE_SIZE) {
> +		char *map = kmap(page);
> +		memset(map + max_size, 0, PAGE_SIZE - max_size);
> +		kunmap(page);
> +	}
>  	kfree(tmp);
>  	return ret;
>  }

Wasn't this already posted as:

btrfs: fix silent data corruption while reading compressed inline extents
https://patchwork.kernel.org/patch/9371971/

but you don't indicate that's a V2 or something, and in fact the patch seems
exactly the same, just the subject and commit message are entirely different.
Quite confusing.

-- 
With respect,
Roman
