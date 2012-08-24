Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:45003 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354Ab2HXOTn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 10:19:43 -0400
Date: Fri, 24 Aug 2012 16:19:37 +0200
From: David Sterba <dave@jikos.cz>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix ordered extent leak when failing to start a
 transaction
Message-ID: <20120824141937.GA17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1345605205-18685-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1345605205-18685-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 22, 2012 at 11:13:25AM +0800, bo.li.liu@oracle.com wrote:
> We cannot just return error before freeing ordered extent and releasing reserved
> space when we fail to start a transacion.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/inode.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 7131fac..f6c43ff 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1883,8 +1883,11 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>  				trans = btrfs_join_transaction_nolock(root);
>  			else
>  				trans = btrfs_join_transaction(root);
> -			if (IS_ERR(trans))
> -				return PTR_ERR(trans);
> +			if (IS_ERR(trans)) {
> +				ret = PTR_ERR(trans);
> +				trans = NULL;
> +				goto out;
> +			}

The same code is used a few lines below (after locking the range) when
transaction fails, so I agree that this should be done here as well. Ack.


david
