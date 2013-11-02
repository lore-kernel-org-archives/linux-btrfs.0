Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:51313 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3KBQ7R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 12:59:17 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by slow1-d.mail.gandi.net (Postfix) with ESMTP id 0CD6F5357C0
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Nov 2013 17:56:57 +0100 (CET)
Date: Sat, 2 Nov 2013 09:56:29 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com, linux-btrfs@vger.kernel.org
Subject: Re: [OPW kernel] [PATCH v2] btrfs: Remove useless variable in
 write_ctree_super()
Message-ID: <20131102165628.GG15704@leaf>
References: <20131030215915.GA26170@gmail.com>
 <1383218442-27700-1-git-send-email-rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1383218442-27700-1-git-send-email-rashika.kheria@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 31, 2013 at 04:50:42PM +0530, Rashika Kheria wrote:
> The function write_ctree_super() in disk-io.c uses variable ret to return
> the result of function write_all_supers(). Since, this variable serves
> no purpose, hence the patch removes it and returns the call of the
> called function.
> 
> Reviewed-by: Zach Brown <zab@redhat.com>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

(Also, in general, Reviewed-by should go after Signed-off-by.)

> ---
> 
> This patch fixes the following issues of the previous revision-
> Change Subject line
> 
>  fs/btrfs/disk-io.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 25fb77a..cc95d55 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3425,10 +3425,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
>  int write_ctree_super(struct btrfs_trans_handle *trans,
>  		      struct btrfs_root *root, int max_mirrors)
>  {
> -	int ret;
> -
> -	ret = write_all_supers(root, max_mirrors);
> -	return ret;
> +	return write_all_supers(root, max_mirrors);
>  }
>  
>  /* Drop a fs root from the radix tree and free it. */
> -- 
> 1.7.9.5
> 
> -- 
> You received this message because you are subscribed to the Google Groups "opw-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to opw-kernel+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/groups/opt_out.
