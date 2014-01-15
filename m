Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:49371 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaAOUUp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 15:20:45 -0500
Received: by mail-vb0-f54.google.com with SMTP id w20so598775vbb.41
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 12:20:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389806820-15250-1-git-send-email-dsterba@suse.cz>
References: <1389806820-15250-1-git-send-email-dsterba@suse.cz>
Date: Wed, 15 Jan 2014 21:20:45 +0100
Message-ID: <CACeaM88nDat+soEwxwww1UsYf=he_3dwz7K22zbnio_6k3HMhw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: call permission checks earlier in ioctls and
 return EPERM
From: Gerhard Heift <gerhard@heift.name>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014/1/15 David Sterba <dsterba@suse.cz>:
> The owner and capability checks in IOC_SUBVOL_SETFLAGS and
> SET_RECEIVED_SUBVOL should be called before any other checks are done.
>
> Also unify the error code to EPERM.
>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  fs/btrfs/ioctl.c | 22 +++++++++-------------
>  1 file changed, 9 insertions(+), 13 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 21da5762b0b1..f21facd84947 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -190,6 +190,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>         unsigned int i_oldflags;
>         umode_t mode;
>
> +       if (!inode_owner_or_capable(inode))
> +               return -PERM;

You forgot an "E".
