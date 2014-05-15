Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaEORGg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 13:06:36 -0400
Date: Thu, 15 May 2014 19:06:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: save us an unnecessary ioctl call
Message-ID: <20140515170634.GR6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 13, 2014 at 05:05:05PM +0800, Wang Shilong wrote:
> Btrfs device id start from 1, not 0.

> --- a/utils.c
> +++ b/utils.c
> @@ -1765,7 +1765,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>  		goto out;
>  	}
>  
> -	for (; i <= fi_args->max_id; ++i) {
> +	for (i = 1; i <= fi_args->max_id; ++i) {

You're right about the device id start, but forcing 1 here breaks the
case when get_fs_info is called with block device as an argument and 'i'
is set to the devid a few lines above.

Initializing i to 1 in the declaration block is the right fix IMO, and
as this is a trivial change I'll do that myself, no need to resend.

>  		BUG_ON(ndevs >= fi_args->num_devices);
>  		ret = get_device_info(fd, i, &di_args[ndevs]);
>  		if (ret == -ENODEV)
