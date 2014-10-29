Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40690 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaJ2K4V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 06:56:21 -0400
Message-ID: <5450C7CA.5010005@oracle.com>
Date: Wed, 29 Oct 2014 18:56:10 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: fix dev stats error output related to replace
 handle
References: <1414029371-6765-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1414029371-6765-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Gui,

  We don't need this patch. Actually you should back out this patch to
  get this correct.

[PATCH] btrfs-progs: do a separate probe for _transient_ replacing device

  OR apply. this

[PATCH] revert btrfs-progs: do a separate probe for _transient_ 
replacing device

  Try it out. Lets know.

Thanks




On 10/23/14 09:56, Gui Hecheng wrote:
> Steps to reproduce:
> 	# mkfs.btrfs -f /dev/sdb7
> 	# mount /dev/sdb7 /mnt
> 	# btrfs dev stats /dev/sdb7
> output:
> 	[/dev/sdb7].write_io_errs   0
> 	[/dev/sdb7].read_io_errs    0
> 	[/dev/sdb7].flush_io_errs   0
> 	[/dev/sdb7].corruption_errs 0
> 	[/dev/sdb7].generation_errs 0
> 	* ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on  failed: No such device
>
> while the following cmd:
> 	# btrfs dev stats /mnt
> yields the right thing:
> 	[/dev/sdb7].write_io_errs   0
> 	[/dev/sdb7].read_io_errs    0
> 	[/dev/sdb7].flush_io_errs   0
> 	[/dev/sdb7].corruption_errs 0
> 	[/dev/sdb7].generation_errs 0
>
> This is caused by commit:
> 	commit d0588bfa479409b2a0f6243f894338a01a56221a
> 	btrfs-progs: do a separate probe for transient replacing device
>
> The above commit trys to handle the fi show problem with device under
> replacing, but it changes the @get_fs_info() logic which annoys dev stats.
> For @get_fs_info():
> o If the passed in @path is a mount point, then the @get_device_info() to
>    probe the replacing device will be glad to accept the device index
>    var @i as its init value 0 and the following i++ correctly sets @i
>    to 1 as the start of all devices in btrfs.
> o If @path is a block device, then the problem comes...
>    The device index @i is set to devid of the block device passed in,
>    and the @get_device_info() will be forced to accept the devid unwillingly.
>    Then the following i++ do the evil of skip the block device desired and an
>    empty piece is handled next which causes the ERROR above.
>
> To fix this problem, let's just pass 0 to the @get_device_info() explicitly,
> and set the index @i to 1 if a mount point is passed in.
>
> Under my own test, this will not affect the original fix of the fi show
> problem with device under replacing.
>
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>   utils.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/utils.c b/utils.c
> index f10c178..0ba2b26 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1881,12 +1881,15 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>   	}
>
>   	/* get the replace target device if it is there */
> -	ret = get_device_info(fd, i, &di_args[ndevs]);
> +	ret = get_device_info(fd, 0, &di_args[ndevs]);
>   	if (!ret) {
>   		ndevs++;
>   		fi_args->num_devices++;
>   	}
> -	i++;
> +
> +	/* if a mount point is passed in, start from devid 1 */
> +	if (fi_args->num_devices != 1)
> +		i = 1;
>
>   	for (; i <= fi_args->max_id; ++i) {
>   		BUG_ON(ndevs >= fi_args->num_devices);
>
