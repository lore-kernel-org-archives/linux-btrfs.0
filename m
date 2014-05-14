Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbaENOPV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 10:15:21 -0400
Date: Wed, 14 May 2014 16:15:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs: return errno instead of -1 from compression
Message-ID: <20140514141519.GL6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1399670110-3335-1-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399670110-3335-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 09, 2014 at 05:15:08PM -0400, Zach Brown wrote:
> --- a/fs/btrfs/zlib.c
> +++ b/fs/btrfs/zlib.c
> @@ -136,7 +136,7 @@ static int zlib_compress_pages(struct list_head *ws,
>  		if (workspace->def_strm.total_in > 8192 &&
>  		    workspace->def_strm.total_in <
>  		    workspace->def_strm.total_out) {
> -			ret = -1;
> +			ret = -EIO;

E2BIG, the comment above the code says

  /* we're making it bigger, give up */

and the error code is consistent with lzo.c

The rest is ok.
