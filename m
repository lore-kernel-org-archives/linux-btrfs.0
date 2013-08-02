Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab3HBA0r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 20:26:47 -0400
Date: Fri, 2 Aug 2013 02:26:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: fix closing of opendir()
Message-ID: <20130802002645.GF24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1373888210-5351-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373888210-5351-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 15, 2013 at 07:36:50PM +0800, Wang Shilong wrote:
> valgrind complains open_file_or_dir() causes a memory leak.That is because
> if we open a directoy by opendir(), and then we should call closedir()
> to free memory.

I've reviewed this and don't see a better way how to fix the leaks now.
One comment below, otherwise ok, thanks.


> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -91,9 +89,8 @@ static int cmd_df(int argc, char **argv)
>  	sargs = realloc(sargs, sizeof(struct btrfs_ioctl_space_args) +
>  			(count * sizeof(struct btrfs_ioctl_space_info)));
>  	if (!sargs) {
> -		close(fd);
> -		free(sargs_orig);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto out;

sargs_orig is leaked here, the out: block only frees sargs, but it's
null now, so

		sargs = sargs_orig;
		goto out;

should fix it.

>  	}
>  
>  	sargs->space_slots = count;
