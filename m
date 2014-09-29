Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbaI2QHl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 12:07:41 -0400
Date: Mon, 29 Sep 2014 18:07:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: fix sparse address space warnings
Message-ID: <20140929160738.GC11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1411894092-28784-1-git-send-email-osandov@osandov.com>
 <1411894092-28784-2-git-send-email-osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411894092-28784-2-git-send-email-osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 28, 2014 at 01:48:11AM -0700, Omar Sandoval wrote:
> The buffer passed to vfs_write in send and several casts of ioctl fields are
> missing the __user annotation. Also fixes a couple of related trivial style
> issues.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

> @@ -639,8 +640,7 @@ static int send_header(struct send_ctx *sctx)
> -	return write_buf(sctx->send_filp, &hdr, sizeof(hdr),
> -					&sctx->send_off);
> +	return write_buf(sctx->send_filp, &hdr, sizeof(hdr), &sctx->send_off);

>  	ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
> -					&sctx->send_off);
> +			&sctx->send_off);

Please do not fold unrelated changes.
