Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53834 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757099Ab3BVNdy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 08:33:54 -0500
Received: from mailout-de.gmx.net ([10.1.76.10]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Lx1bL-1UxECm0F7B-016k3S for
 <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 14:33:53 +0100
Message-ID: <51277409.6040007@gmx.net>
Date: Fri, 22 Feb 2013 14:35:05 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RESEND RFC PATCH 2/2] Btrfs: disable the qgroup level 0 for
 userspace use
References: <1361534990-2627-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1361534990-2627-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/22/13 13:09, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> This patch tries to stop users to create/destroy qgroup level 0,
> users can only create/destroy qgroup level more than 0.
> 
> See the fact:
> 	a subvolume/snapshot qgroup was created automatically
> when creating subvolume/snapshot, so creating a qgroup level 0 can't
> be a subvolume/snapshot qgroup, the only way to use it is that assigning
> subvolume/snapshot qgroup to it, the point is that we don't want to have a
> parent qgroup whose level is 0.
> 
> 	So we want to force users to use qgroup with clear relations
> which means a parent qgroup's level > child qgroup's level.For example:
> 
>                           2/0
>                          /    \
>                         /      \
>                        /        \
>                       1/0       1/1
>                     /     \        \
>                    /       \        \       
>                   /         \        \
>             	0/256     0/257    0/258
> 
> This pattern of quota is nature and easy for users to understand, otherwise it will
> make the quota configuration confusing and difficult to maintain.

I agree that a strict hierarchy of the levels should be enforced.
Currently the kernel has no idea of 'level', it's just an artificial
concept that lives in userspace. This patch would be the first place
to add that magic shift '48' to the kernel.
In my opinion it would be sufficient to do the enforcement in user
space, as it is of no technical nature.

-Arne

> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> Acked-by: Miao Xie <miaox@cn.fujitsu.com>
> Cc: Arne Jansen <sensille@gmx.net>
> ---
>  fs/btrfs/ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a31cd93..3590c21 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3755,7 +3755,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>  		goto drop_write;
>  	}
>  
> -	if (!sa->qgroupid) {
> +	if (!(sa->qgroupid >> 48)) {
>  		ret = -EINVAL;
>  		goto out;
>  	}
> 

