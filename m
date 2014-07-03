Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbaGCRup (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jul 2014 13:50:45 -0400
Date: Thu, 3 Jul 2014 19:50:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs-progs: Add more meaningful return value for
 btrfs_read_dev_super() and corresponding error string.
Message-ID: <20140703175043.GJ1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1404380198-25948-4-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404380198-25948-4-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 03, 2014 at 05:36:37PM +0800, Qu Wenruo wrote:
> --- a/btrfs-find-root.c
> +++ b/btrfs-find-root.c
> @@ -96,7 +96,10 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
>  	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
>  				   disk_super, fs_info->super_bytenr, 1);
>  	if (ret) {
> -		printk("No valid btrfs found\n");
> +		if (ret == -ENOENT)
> +			printk("No valid btrfs found\n");

Please use fprintf(stderr, ...) for error messages, until we have a
better message logging helpers.
