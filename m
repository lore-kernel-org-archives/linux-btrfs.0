From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: fix early abort in 'remount'
Date: Mon, 16 Apr 2012 09:12:52 +0800
Message-ID: <4F8B7214.5010702@cn.fujitsu.com>
References: <1334529975-13289-1-git-send-email-slyich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org,
	Sergei Trofimovich <slyfox@gentoo.org>,
	Jeff Mahoney <jeffm@suse.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334529975-13289-1-git-send-email-slyich@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/16/2012 06:46 AM, Sergei Trofimovich wrote:

> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: Josef Bacik <josef@redhat.com>
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> ---
>  fs/btrfs/super.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 8d5d380..0b296f2 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1149,12 +1149,16 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  			goto restore;
>  	} else {
>  		if (fs_info->fs_devices->rw_devices == 0)
> +		{
>  			ret = -EACCES;
>  			goto restore;
> +		}
>  
>  		if (btrfs_super_log_root(fs_info->super_copy) != 0)
> +		{
>  			ret = -EINVAL;
>  			goto restore;
> +		}
>  
>  		ret = btrfs_cleanup_fs_roots(fs_info);
>  		if (ret)


I prefer to
if (xxx) {
	yyy;
}

thanks, 
liubo 
