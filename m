Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35057 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab2I3WqO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 18:46:14 -0400
Date: Mon, 1 Oct 2012 00:46:05 +0200
From: David Sterba <dave@jikos.cz>
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Robin Dong <sanbai@taobao.com>
Subject: Re: [PATCH v2 1/2] btrfs-progs: limit the max value of leafsize and
 nodesize
Message-ID: <20120930224605.GL14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348801360-1851-1-git-send-email-robin.k.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348801360-1851-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 28, 2012 at 11:02:39AM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1201,6 +1201,27 @@ static int zero_output_file(int out_fd, u64 size, u32 sectorsize)
>  	return ret;
>  }
>  
> +static int check_leaf_or_node_size(u32 size, u32 sectorsize)
> +{
> +	if (size < sectorsize) {
> +		fprintf(stderr,
> +			"Illegal leafsize (or nodesize) %u (smaller than %u)\n",
> +			size, sectorsize);

First looking at the message, the absolute limit value might be
confusing, the condition is really 'if node/leaf is smaller than
sectorsize', and sectorsize will become a varaible eventually (though
now it's fixed to the system's PAGE_SIZE and 4k in most cases).

So, even if this will make the erro message more verbose, I suggest to
enhance the explanation with

"... (smaller than sectorsize %u)"

(If you se a better way how to format the value and the word, please don't
hasitate to change it.)

> +		return -1;
> +	} else if (size > BTRFS_MAX_METADATA_BLOCKSIZE) {
> +		fprintf(stderr,
> +			"Illegal leafsize (or nodesize) %u (larger than %u)\n",
> +			size, BTRFS_MAX_METADATA_BLOCKSIZE);
> +		return -1;
> +	} else if (size & (sectorsize - 1)) {
> +		fprintf(stderr,
> +			"Illegal leafsize (or nodesize) %u (not align to %u)\n",

align -> aligned

> +			size, sectorsize);
> +		return -1;
> +	}
> +	return 0;
> +}
> +

thanks,
david
