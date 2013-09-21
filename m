Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:22435 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3IUHLa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Sep 2013 03:11:30 -0400
Message-ID: <523D46AA.8060408@giantdisaster.de>
Date: Sat, 21 Sep 2013 09:11:38 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: create the uuid tree on remount rw
References: <20130921023320.GD5672@localhost.localdomain>
In-Reply-To: <20130921023320.GD5672@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/21/2013 04:33, Josef Bacik wrote:
> Users have been complaining of the uuid tree stuff warning that there is no uuid
> root when trying to do snapshot operations.  This is because if you mount -o ro
> we will not create the uuid tree.  But then if you mount -o rw,remount we will
> still not create it and then any subsequent snapshot/subvol operations you try
> to do will fail gloriously.  Fix this by creating the uuid_root on remount rw if
> it was not already there.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>   fs/btrfs/super.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 6ab0df5..05cfd79 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1383,6 +1383,16 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>   			pr_warn("btrfs: failed to resume dev_replace\n");
>   			goto restore;
>   		}
> +
> +		if (!fs_info->uuid_root) {
> +			pr_info("btrfs: creating UUID tree\n");
> +			ret = btrfs_create_uuid_tree(fs_info);
> +			if (ret) {
> +				pr_warn("btrfs: failed to create the uuid "
> +					"%d\n", ret);

pr_warn("btrfs: failed to create the uuid tree "
                                           ^^^^

And I'm just wondering what would happen if you remount -o ro,remount 
(or umount -rf or shutdown on a busy filesystem which also causes a ro 
remount) while the uuid tree create/check thread is running. There is no 
code to stop the thread. There is only code for the regulat umount case 
that waits for this thread to complete. But that's not related to your 
patch. I'll put it on my todo list.


> +				goto restore;
> +			}
> +		}
>   		sb->s_flags &= ~MS_RDONLY;
>   	}
>   out:
>


