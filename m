Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:25738 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3K2PTZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 10:19:25 -0500
Message-ID: <5298B079.2020907@giantdisaster.de>
Date: Fri, 29 Nov 2013 16:19:21 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs-progs: avoid using btrfs internal subvolume path
 to send
References: <1385734989-8839-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1385734989-8839-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 29 Nov 2013 22:23:09 +0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> 
> Steps to reproduce:
> 	# mkfs.btrfs -f /dev/sda
> 	# mount /dev/sda /mnt
> 	# btrfs subvolume create /mnt/foo
> 	# umount /mnt
> 	# mount -o subvol=foo /dev/sda /mnt
> 	# btrfs sub snapshot -r /mnt /mnt/snap
> 	# btrfs send /mnt/snap > /dev/null
> 
> We will fail to send '/mnt/snap',this is because btrfs send try to
> open '/mnt/snap' by btrfs internal subvolume path 'foo/snap' rather
> than relative path based on mounted point, this will return us 'no
> such file or directory',this is not right, fix it.
> 
> Reported-by: Thomas Scheiblauer <tom@sharkbay.at>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  cmds-send.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/cmds-send.c b/cmds-send.c
> index 53e9a53..b3dde83 100644
> --- a/cmds-send.c
> +++ b/cmds-send.c
> @@ -283,7 +283,7 @@ out:
>  }
>  
>  static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root_id,
> -		   int is_first_subvol, int is_last_subvol)
> +		   int is_first_subvol, int is_last_subvol, char *subvol)
>  {
>  	int ret;
>  	pthread_t t_read;
> @@ -303,10 +303,10 @@ static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root_id,
>  		goto out;
>  	}
>  
> -	subvol_fd = openat(send->mnt_fd, si->path, O_RDONLY | O_NOATIME);
> +	subvol_fd = openat(send->mnt_fd, subvol, O_RDONLY | O_NOATIME);
>  	if (subvol_fd < 0) {
>  		ret = -errno;
> -		fprintf(stderr, "ERROR: open %s failed. %s\n", si->path,
> +		fprintf(stderr, "ERROR: open %s failed. %s\n", subvol,
>  				strerror(-ret));
>  		goto out;
>  	}
> @@ -701,7 +701,7 @@ int cmd_send(int argc, char **argv)
>  			is_last_subvol = 1;
>  		}
>  		ret = do_send(&send, root_id, parent_root_id,
> -			      is_first_subvol, is_last_subvol);
> +			      is_first_subvol, is_last_subvol, subvol);
>  		if (ret < 0)
>  			goto out;
>  
> 

You've removed that the subvol_info si is used in do_send().
Then you can remove all the subvol_info si code:

        struct subvol_info *si;
...
        si = subvol_uuid_search(&send->sus, root_id, NULL, 0, NULL,
                        subvol_search_by_root_id);
        if (!si) {
                ret = -ENOENT;
                fprintf(stderr, "ERROR: could not find subvol info for
%llu",
                                root_id);
                goto out;
        }
...
        if (si) {
                free(si->path);
                free(si);
        }

