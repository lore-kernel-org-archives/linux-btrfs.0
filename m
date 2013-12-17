Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:19424 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3LQIBj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 03:01:39 -0500
Message-ID: <52B004E1.706@giantdisaster.de>
Date: Tue, 17 Dec 2013 09:01:37 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] btrfs-progs: handle error in the btrfs_prepare_device
In-Reply-To: <1387247616-1574-3-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1387247616-1574-1-git-send-email-anand.jain@oracle.com>
 <1387247616-1574-3-git-send-email-anand.jain@oracle.com>

On Tue, 17 Dec 2013 10:33:36 +0800, Anand Jain wrote:
> this patch will handle the strerror reporting of the error instead of
> printing errno,  and also replaced the BUG_ON with the error handling
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  v2: commit update
> ---
>  cmds-device.c  |  7 +++----
>  cmds-replace.c | 10 ++++------
>  mkfs.c         |  9 ++++++++-
>  utils.c        | 30 +++++++++++++++++++-----------
>  4 files changed, 34 insertions(+), 22 deletions(-)
> 
[...]
> diff --git a/cmds-replace.c b/cmds-replace.c
> index d9b0940..8160107 100644
> --- a/cmds-replace.c
> +++ b/cmds-replace.c
> @@ -276,13 +276,11 @@ static int cmd_start_replace(int argc, char **argv)
>  	}
>  	strncpy((char *)start_args.start.tgtdev_name, dstdev,
>  		BTRFS_DEVICE_PATH_NAME_MAX);
> -	if (btrfs_prepare_device(fddstdev, dstdev, 1, &dstdev_block_count, 0,
> -				 &mixed, 0)) {
> -		fprintf(stderr, "Error: Failed to prepare device '%s'\n",
> -			dstdev);
> -		goto leave_with_error;
> -	}
> +	ret = btrfs_prepare_device(fddstdev, dstdev, 1, &dstdev_block_count, 0,
> +				 &mixed, 0);
>  	close(fddstdev);
> +	if (ret)
> +		goto leave_with_error;
>  	fddstdev = -1;

You change the code to call close(fddstdev) twice.

[...]
> +zero_dev_error:
> +	if (ret) {
> +		ret < 0 ?
> +		fprintf(stderr, "ERROR: failed to zero device start '%s' - %s\n",
> +			file, strerror(-ret)) :
> +		fprintf(stderr, "ERROR: failed to zero device start '%s' - %d\n",
> +			file, ret);

This is not funny.



