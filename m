From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH 1/2] btrfs-progs: multidevice support for check_mounted
Date: Sat, 21 Nov 2009 21:21:10 +0100
Message-ID: <20091121202109.GD16301@nb.net.home>
References: <200911211533.25878.lists-receive@programmierforen.de> <200911211538.38351.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	"Yan, Zheng" <yanzheng@21cn.com>
To: Andi Drebes <lists-receive@programmierforen.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911211538.38351.lists-receive@programmierforen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 21, 2009 at 03:38:38PM +0100, Andi Drebes wrote:
> +
> +/* Checks if an mntentry represents a pseudo FS */
> +int is_pseudo_fs(const struct mntent* mnt)
> +{
> +	struct stat st_buf;
> +
> +	if(stat(mnt->mnt_fsname, &st_buf) < 0) {
> +		if(errno == ENOENT)
> +			return 1;
> +		else
> +			return -errno;
> +	}
> +
> +	return 0;
> +}

 This is bad idea. The mnt_fsname field could be an arbitrary string
 include valid paths.

        # grep sysfs /proc/mounts 
        /sys /sys sysfs rw,relatime 0 0

 Karel

-- 
 Karel Zak  <kzak@redhat.com>
