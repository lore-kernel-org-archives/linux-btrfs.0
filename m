Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28471 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbaHZI1S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 04:27:18 -0400
Message-ID: <53FC44DC.80206@oracle.com>
Date: Tue, 26 Aug 2014 16:27:08 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] btrfs-progs: scan /proc/partitions not all of /dev
 with "-d"
References: <53F51F4D.2090203@redhat.com> <53F51F95.8060400@redhat.com>
In-Reply-To: <53F51F95.8060400@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Reviewed-by: Anand Jain <anand.jain@oracle.com>

On 21/08/2014 06:22, Eric Sandeen wrote:
> We can scan for btrfs devices in a few ways.  By default
> libblkid is used for "device scan" and "filesystem show";
> with the -m option only mounted filesystems are scanned,
> and with -d we physically read every system device.
>
> But there's no reason for the complexity of a descent through
> /dev; /proc/partitions has every device known to the kernel, so
> just use that when -d is specified.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> diff --git a/cmds-device.c b/cmds-device.c
> index b6772b9..519681a 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -224,7 +224,7 @@ static int cmd_scan_dev(int argc, char **argv)
>   			break;
>   		switch (c) {
>   		case 'd':
> -			where = BTRFS_SCAN_DEV;
> +			where = BTRFS_SCAN_PROC;
>   			all = 1;
>   			break;
>   		default:
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index bf87bbe..0ad7e8f 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -614,7 +614,7 @@ static int cmd_show(int argc, char **argv)
>   			break;
>   		switch (c) {
>   		case 'd':
> -			where = BTRFS_SCAN_DEV;
> +			where = BTRFS_SCAN_PROC;
>   			break;
>   		case 'm':
>   			where = BTRFS_SCAN_MOUNTED;
> @@ -638,7 +638,7 @@ static int cmd_show(int argc, char **argv)
>   		 * right away
>   		 */
>   		if (type == BTRFS_ARG_BLKDEV) {
> -			if (where == BTRFS_SCAN_DEV) {
> +			if (where == BTRFS_SCAN_PROC) {
>   				/* we need to do this because
>   				 * legacy BTRFS_SCAN_DEV
>   				 * provides /dev/dm-x paths
> @@ -681,7 +681,7 @@ static int cmd_show(int argc, char **argv)
>   		}
>   	}
>
> -	if (where == BTRFS_SCAN_DEV)
> +	if (where == BTRFS_SCAN_PROC)
>   		goto devs_only;
>
>   	/* show mounted btrfs */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
