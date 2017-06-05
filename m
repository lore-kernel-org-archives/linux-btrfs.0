Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35214 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbdFEPf1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jun 2017 11:35:27 -0400
Received: by mail-it0-f49.google.com with SMTP id m62so65299779itc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Jun 2017 08:35:27 -0700 (PDT)
Subject: Re: [PATCH 07/10] fs: return on congested block device
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-api@vger.kernel.org,
        adam.manzanares@wdc.com, viro@zeniv.linux.org.uk,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20170605053540.19393-1-rgoldwyn@suse.de>
 <20170605053540.19393-8-rgoldwyn@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <dedfe92d-6452-4f29-044d-34837c4da825@kernel.dk>
Date: Mon, 5 Jun 2017 09:35:24 -0600
MIME-Version: 1.0
In-Reply-To: <20170605053540.19393-8-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/04/2017 11:35 PM, Goldwyn Rodrigues wrote:
> @@ -1900,6 +1905,17 @@ generic_make_request_checks(struct bio *bio)
>  		goto end_io;
>  	}
>  
> +	/*
> +	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
> +	 * if queue does not have QUEUE_FLAG_NOWAIT_SUPPORT set
> +	 * and if it is not a request based queue.
> +	 */
> +
> +	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_rq_based(q)) {
> +		err = -EOPNOTSUPP;
> +		goto end_io;
> +	}

There is no QUEUE_FLAG_NOWAIT, this looks like a somewhat stale comment.

This patch should be prefixed with 'block', not 'fs'.

-- 
Jens Axboe

