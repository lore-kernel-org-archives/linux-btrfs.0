Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab3HARu3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 13:50:29 -0400
Date: Thu, 1 Aug 2013 19:50:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't bug_on when we fail when cleaning up
 transactions
Message-ID: <20130801175023.GA24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375280963-2043-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375280963-2043-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 31, 2013 at 10:29:23AM -0400, Josef Bacik wrote:
> There is no reason for this sort of jackassery.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/transaction.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 18f7e71..ea8d522 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1942,6 +1942,5 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
>  	 * If we encounter a transaction abort during snapshot cleaning, we
>  	 * don't want to crash here
>  	 */
> -	BUG_ON(ret < 0 && ret != -EAGAIN && ret != -EROFS);
> -	return 1;
> +	return (ret < 0) ? 0 : 1;

The reason was to let known harmless error codes pass and catch the
unexpected ones, but the whitelist was incomplete and I guess you've seen
something like ENOMEM or EIO. As the cleaning process is restartable I'm
ok with removing the bugon.

Reviewed-by: David Sterba <dsterba@suse.cz>
