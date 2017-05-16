Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48145 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752345AbdEPJ0B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 05:26:01 -0400
Subject: Re: [PATCH] btrfs: add mount umount logs
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
References: <20170516084149.10147-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <392158e2-14a1-6499-5005-19dd5497e18b@cn.fujitsu.com>
Date: Tue, 16 May 2017 17:25:52 +0800
MIME-Version: 1.0
In-Reply-To: <20170516084149.10147-1-anand.jain@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, this is indeed a nice feature.

But what about only outputting this info when BTRFS_DEBUG is selected?
I'm sure there will be some guys not liking such kernel message flooding 
everywhere when doing testing.

Thanks,
Qu

At 05/16/2017 04:41 PM, Anand Jain wrote:
> By looking at the logs we should be able to know when the FS was
> mounted and unmounted and the options used, so to help forensic
> investigations.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   fs/btrfs/super.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 827a8305da50..a123bc46b521 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1408,6 +1408,17 @@ static char *setup_root_args(char *args)
>   	return buf;
>   }
>   
> +static void print_mount_info(struct btrfs_fs_info *info, int flag, char *opt,
> +		char *prefix)
> +{
> +	char f[10] = {0};
> +
> +	if (flag & MS_RDONLY)
> +		strcpy(f, "rdonly");

Isn't "ro" more common?

Thanks,
Qu

> +
> +	btrfs_notice(info, "%s: flags:%s opt:%s\n", prefix, f, opt);
> +}
> +
>   static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
>   				   int flags, const char *device_name,
>   				   char *data)
> @@ -1502,6 +1513,8 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
>   			dput(root);
>   			root = ERR_PTR(ret);
>   			deactivate_locked_super(s);
> +		} else {
> +			print_mount_info(fs_info, flags, data, "mount");
>   		}
>   	}
>   
> @@ -1882,6 +1895,9 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>   out:
>   	wake_up_process(fs_info->transaction_kthread);
>   	btrfs_remount_cleanup(fs_info, old_opts);
> +
> +	print_mount_info(fs_info, *flags, data, "remount");
> +
>   	return 0;
>   
>   restore:
> @@ -2212,6 +2228,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>   static void btrfs_kill_super(struct super_block *sb)
>   {
>   	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
> +	btrfs_notice(fs_info, "%s\n", "unmount");
>   	kill_anon_super(sb);
>   	free_fs_info(fs_info);
>   }
> 


