From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v3] btrfs: fix early abort in 'remount'
Date: Fri, 20 Apr 2012 17:27:50 -0400
Message-ID: <20120420212750.GF1957@localhost.localdomain>
References: <1334788058-435-1-git-send-email-slyich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org,
	Sergei Trofimovich <slyfox@gentoo.org>,
	Jeff Mahoney <jeffm@suse.com>,
	Chris Mason <chris.mason@oracle.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334788058-435-1-git-send-email-slyich@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 19, 2012 at 01:27:38AM +0300, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Chris Mason <chris.mason@oracle.com>
> Reviewed-by: Josef Bacik <josef@redhat.com>
> Reviewed-by: Sergey V. <sftp.mtuci@gmail.com>
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> ---
> v1->v2: fixed indentation of 'if (cond) {' suggested by Liu Bo
> v2->v3: added 'Reviewed-by'
>  fs/btrfs/super.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 8d5d380..2f28fc0 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1148,13 +1148,15 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  		if (ret)
>  			goto restore;
>  	} else {
> -		if (fs_info->fs_devices->rw_devices == 0)
> +		if (fs_info->fs_devices->rw_devices == 0) {
>  			ret = -EACCES;
>  			goto restore;
> +		}
>  
> -		if (btrfs_super_log_root(fs_info->super_copy) != 0)
> +		if (btrfs_super_log_root(fs_info->super_copy) != 0) {
>  			ret = -EINVAL;
>  			goto restore;
> +		}
>  
>  		ret = btrfs_cleanup_fs_roots(fs_info);
>  		if (ret)
> -- 
> 1.7.8.5
> 

I just noticed this doesn't have a changelog when I was putting it into
btrfs-next, can you resend with a proper changelog so I can update the one in
btrfs-next?  Thanks,

Josef
