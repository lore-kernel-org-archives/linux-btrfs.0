Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab3JUMaJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 08:30:09 -0400
Date: Mon, 21 Oct 2013 14:30:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Alexander Block <ablock84@googlemail.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, jbacik@fusionio.com
Subject: Re: [patch] Btrfs: fix access_ok() check in btrfs_ioctl_send()
Message-ID: <20131021123004.GI1032@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 10, 2013 at 11:57:25AM +0300, Dan Carpenter wrote:
> The closing parenthesis is in the wrong place.  We want to check
> "sizeof(*arg->clone_sources) * arg->clone_sources_count" instead of
> "sizeof(*arg->clone_sources * arg->clone_sources_count)".
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Original message id: <20130110085725.GA23063@elgon.mountain>

This patch hasn't been applied.

> ---
> This is also vulnerable to integer overflows.  It's only done under
> root, but these days we are trying to restrict what root can do without
> configuring Secure Boot in UEFI.

Although it's a security fix, it's not exploitable by a user so it's not
that urgent to get it merged. Nevertheless, I hope you can squeeze it
into 3.12-rc so we can then start pushing it to stable kernels (at least
3.10).

> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 5445454..4be3832 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -4553,8 +4553,8 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>  	}
>  
>  	if (!access_ok(VERIFY_READ, arg->clone_sources,
> -			sizeof(*arg->clone_sources *
> -			arg->clone_sources_count))) {
> +			sizeof(*arg->clone_sources) *
> +			arg->clone_sources_count)) {
>  		ret = -EFAULT;
>  		goto out;
>  	}

david
