Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab3KLNt7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 08:49:59 -0500
Date: Mon, 4 Nov 2013 16:16:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Aldo Iljazi <mail@aldo.io>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FS: BTRFS: fixed coding style issues
Message-ID: <20131104151619.GB16999@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1383571658-7440-1-git-send-email-mail@aldo.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1383571658-7440-1-git-send-email-mail@aldo.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 04, 2013 at 03:27:38PM +0200, Aldo Iljazi wrote:
> Fixed three coding style issues. Replaced spaces with tabs.
> 
> Signed-off-by: Aldo Iljazi <mail@aldo.io>
> ---
>  fs/btrfs/dev-replace.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 9efb94e..b2fe609 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -377,7 +377,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
>  	printk_in_rcu(KERN_INFO
>  		      "btrfs: dev_replace from %s (devid %llu) to %s) started\n",
>  		      src_device->missing ? "<missing disk>" :
> -		        rcu_str_deref(src_device->name),
> +			rcu_str_deref(src_device->name),

What's the change here? I don't think we need to fix whitespace, this
makes searching in patch history more boring, namely in case where the
code looks exactly the same before and after the patch.

The style issues should be best fixed when the patch is about to be
merged, doing it later like this is kind of not welcome, speaking for
myself. There are lots of opportunities to do real code cleanups.


david
