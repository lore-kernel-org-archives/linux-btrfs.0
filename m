From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 2/3] Btrfs: add ioctl to get and reset the device stats
Date: Sun, 11 Dec 2011 11:24:16 +0100
Message-ID: <1328320.x7SNYXeJA2@venice>
References: <cover.1323448299.git.sbehrens@giantdisaster.de> <f2f1de6869aab38ff48d60235081257ce2c03bf4.1323448299.git.sbehrens@giantdisaster.de>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f2f1de6869aab38ff48d60235081257ce2c03bf4.1323448299.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 09 December, 2011 17:40:27 Stefan Behrens wrote:
> An ioctl interface is added to get the device statistic counters.
> A second ioctl is added to atomically get and reset these counters.

[...]

> 
> +static long btrfs_ioctl_get_device_stats(struct btrfs_root *root,
> +					 void __user *arg, int reset_after_read)
> +{
> +	struct btrfs_ioctl_get_device_stats *sa;
> +	int ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +

I agree that the BTRFS_IOC_GET_AND_RESET_DEVICE_STATS should be a privileged 
operation. But I think that the BTRFS_IOC_GET_DEVICE_STATS should be allowed 
to everyone. Think about a daemon which look at the error, and then send an 
email to warn about possible defect. Allowing BTRFS_IOC_GET_DEVICE_STATS to 
everyone, prevent to run the deamon with root privileges.

BR
G.Baroncelli


[...]
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
