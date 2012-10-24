Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab2JXIPT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 04:15:19 -0400
Date: Wed, 24 Oct 2012 10:15:15 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
cc: linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: [PATCH] btrfs: Return EINVAL when length to trim is less than
 FSB
In-Reply-To: <1350380076-15997-1-git-send-email-lczerner@redhat.com>
Message-ID: <alpine.LFD.2.00.1210241015080.25196@dhcp-1-104.brq.redhat.com>
References: <1350380076-15997-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 16 Oct 2012, Lukas Czerner wrote:

> Date: Tue, 16 Oct 2012 11:34:36 +0200
> From: Lukas Czerner <lczerner@redhat.com>
> To: linux-btrfs@vger.kernel.org
> Cc: jbacik@fusionio.com, Lukas Czerner <lczerner@redhat.com>
> Subject: [PATCH] btrfs: Return EINVAL when length to trim is less than FSB
> 
> Currently if len argument in btrfs_ioctl_fitrim() is smaller than
> one FSB we will continue and finally return 0 bytes discarded.
> However if the length to discard is smaller then file system block
> we should really return EINVAL.

ping

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/btrfs/ioctl.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 6116880..3b8b509 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -343,7 +343,8 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
>  		return -EOPNOTSUPP;
>  	if (copy_from_user(&range, arg, sizeof(range)))
>  		return -EFAULT;
> -	if (range.start > total_bytes)
> +	if (range.start > total_bytes ||
> +	    range.len < fs_info->sb->s_blocksize)
>  		return -EINVAL;
>  
>  	range.len = min(range.len, total_bytes - range.start);
> 
