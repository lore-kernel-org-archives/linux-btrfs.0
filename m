From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no
 read/write devices V2
Date: Mon, 28 Nov 2011 06:11:06 -0600
Message-ID: <20111128121041.GA19498@elie.hsd1.il.comcast.net>
References: <1312205910-13053-1-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Whitcroft <apw@canonical.com>, Josef Bacik <josef@redhat.com>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Ivan Vilata i Balaguer <ivan@selidor.net>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1312205910-13053-1-git-send-email-apw@canonical.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Andy Whitcroft wrote:

> When we mount a btrfs filesystem from read-only media there will be no
> read/write devices; for example mounting an SD card with its lock enabled.
> This triggers an immediate BUG during mount:
>
>   kernel BUG at .../fs/btrfs/super.c:984!
[...]
> BugLink: http://bugs.launchpad.net/bugs/816770
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---

Fixes http://bugs.debian.org/649847
Tested-by: Ivan Vilata i Balaguer <ivan@selidor.net>

This patch fixes a regression introduced by 6d07bcec969a ("btrfs: fix
wrong free space information of btrfs"), which hit mainline in
v2.6.38-rc1.  Josef Bacik acked the patch, but I can't seem to find it
in linux-next, linux-btrfs, or Josef's btrfs-work tree.  Maybe it was
just forgotten.

What can I do to help this patch get unstuck?

>  fs/btrfs/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 15634d4..ae4367a 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -980,7 +980,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
>  	int i = 0, nr_devices;
>  	int ret;
>  
> -	nr_devices = fs_info->fs_devices->rw_devices;
> +	nr_devices = fs_info->fs_devices->open_devices;
>  	BUG_ON(!nr_devices);
>  
>  	devices_info = kmalloc(sizeof(*devices_info) * nr_devices,
> -- 
> 1.7.4.1
>
