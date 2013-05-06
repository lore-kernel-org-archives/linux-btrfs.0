Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894Ab3EFVUn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 17:20:43 -0400
Date: Mon, 6 May 2013 23:20:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add ioctl to wait for qgroup rescan completion
Message-ID: <20130506212039.GD16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1367867657-4630-1-git-send-email-list.btrfs@jan-o-sch.net>
 <1367867657-4630-2-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1367867657-4630-2-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 06, 2013 at 09:14:17PM +0200, Jan Schmidt wrote:
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -530,6 +530,7 @@ struct btrfs_ioctl_send_args {
>  			       struct btrfs_ioctl_quota_rescan_args)
>  #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
>  			       struct btrfs_ioctl_quota_rescan_args)
> +#define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)

Why do you need an ioctl when the same can be achieved by polling the
RESCAN_STATUS value ? The code does not anything special that has to be
done within kernel.

david
