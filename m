From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: [PATCH] btrfs-progs: add mounted-checking for btrfs-vol
Date: Tue, 2 Feb 2010 17:08:13 +0800
Message-ID: <20100202090813.GC4080@laptop.oracle.com>
References: <4B67E646.4050001@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B67E646.4050001@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

A problem that not in this patch.

On 10-02-02 16:45, Miao Xie wrote:
> Adding a mounted device is dangerous because it will destroy the filesystem
> on that mounted device. So we add mounted-checking for btrfs-vol.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  btrfs-vol.c |   16 +++++++++++++++-
>  1 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/btrfs-vol.c b/btrfs-vol.c
> index 8069778..f781c06 100644
> --- a/btrfs-vol.c
> +++ b/btrfs-vol.c
> @@ -108,10 +108,24 @@ int main(int ac, char **av)
>  	if (device && strcmp(device, "missing") == 0 &&
>  	    cmd == BTRFS_IOC_RM_DEV) {
>  		fprintf(stderr, "removing missing devices from %s\n", mnt);
> -	} else if (device) {
> +	} else if (cmd != BTRFS_IOC_BALANCE) {
> +		if (cmd == BTRFS_IOC_ADD_DEV) {
> +			ret = check_mounted(device);
> +			if (ret < 0) {
> +				fprintf(stderr,
> +					"error checking %s mount status\n",
> +					device);
> +				exit(1);
> +			}
> +			if (ret == 1) {
> +				fprintf(stderr, "%s is mounted\n", device);
> +				exit(1);
> +			}
> +		}
>  		devfd = open(device, O_RDWR);
>  		if (!devfd) {
I think open() returning -1 means an error. So it should be
		if (devfd < 0)
instead of 
		if (!devfd)

regards,
wengang.
>  			fprintf(stderr, "Unable to open device %s\n", device);
> +			exit(1);
>  		}
>  		ret = fstat(devfd, &st);
>  		if (ret) {
