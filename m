Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19483 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdJXBmB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 21:42:01 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: fi: move dev_to_fsid() to cmds-fi-usage
 for later use
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <01e66c4f-9f8d-0bf2-1f7a-bc5784a907f3@jp.fujitsu.com>
 <816d894d-58df-8dba-9e3c-10d2ea5eb5bb@jp.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <dede4e79-3493-f27c-e6a4-29bd779964b5@oracle.com>
Date: Tue, 24 Oct 2017 09:41:55 +0800
MIME-Version: 1.0
In-Reply-To: <816d894d-58df-8dba-9e3c-10d2ea5eb5bb@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/23/2017 12:44 PM, Misono, Tomohiro wrote:
> Move dev_to_fsid() from cmds-filesystem.c to cmds-fi-usage.c in order to
> call it from both "fi show" and "fi usage".
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>   cmds-fi-usage.c   | 29 +++++++++++++++++++++++++++++
>   cmds-fi-usage.h   |  1 +
>   cmds-filesystem.c | 27 ---------------------------
>   3 files changed, 30 insertions(+), 27 deletions(-)
> 
> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
> index 6c846c1..a72fb4e 100644
> --- a/cmds-fi-usage.c
> +++ b/cmds-fi-usage.c
> @@ -22,6 +22,7 @@
>   #include <errno.h>
>   #include <stdarg.h>
>   #include <getopt.h>
> +#include <fcntl.h>
>   
>   #include "utils.h"
>   #include "kerncompat.h"
> @@ -29,6 +30,7 @@
>   #include "string-table.h"
>   #include "cmds-fi-usage.h"
>   #include "commands.h"
> +#include "disk-io.h"
>   
>   #include "version.h"
>   #include "help.h"
> @@ -506,6 +508,33 @@ static int cmp_device_info(const void *a, const void *b)
>   			((struct device_info *)b)->path);
>   }
>   
> +int dev_to_fsid(const char *dev, __u8 *fsid)
> +{
> +	struct btrfs_super_block *disk_super;
> +	char buf[BTRFS_SUPER_INFO_SIZE];
> +	int ret;
> +	int fd;
> +
> +	fd = open(dev, O_RDONLY);
> +	if (fd < 0) {
> +		ret = -errno;
> +		return ret;
> +	}
> +
> +	disk_super = (struct btrfs_super_block *)buf;
> +	ret = btrfs_read_dev_super(fd, disk_super,
> +				   BTRFS_SUPER_INFO_OFFSET, SBREAD_DEFAULT);
> +	if (ret)
> +		goto out;
> +
> +	memcpy(fsid, disk_super->fsid, BTRFS_FSID_SIZE);
> +	ret = 0;
> +
> +out:
> +	close(fd);
> +	return ret;
> +}
> +
>   /*
>    *  This function loads the device_info structure and put them in an array
>    */
> diff --git a/cmds-fi-usage.h b/cmds-fi-usage.h
> index a399517..0e82951 100644
> --- a/cmds-fi-usage.h
> +++ b/cmds-fi-usage.h
> @@ -50,5 +50,6 @@ void print_device_chunks(struct device_info *devinfo,
>   		struct chunk_info *chunks_info_ptr,
>   		int chunks_info_count, unsigned unit_mode);
>   void print_device_sizes(struct device_info *devinfo, unsigned unit_mode);
> +int dev_to_fsid(const char *dev, __u8 *fsid);
>   
>   #endif
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index c39f2d1..3dc86a2 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -431,33 +431,6 @@ out:
>   	return !found;
>   }
>   
> -static int dev_to_fsid(const char *dev, __u8 *fsid)
> -{
> -	struct btrfs_super_block *disk_super;
> -	char buf[BTRFS_SUPER_INFO_SIZE];
> -	int ret;
> -	int fd;
> -
> -	fd = open(dev, O_RDONLY);
> -	if (fd < 0) {
> -		ret = -errno;
> -		return ret;
> -	}
> -
> -	disk_super = (struct btrfs_super_block *)buf;
> -	ret = btrfs_read_dev_super(fd, disk_super,
> -				   BTRFS_SUPER_INFO_OFFSET, SBREAD_DEFAULT);
> -	if (ret)
> -		goto out;
> -
> -	memcpy(fsid, disk_super->fsid, BTRFS_FSID_SIZE);
> -	ret = 0;
> -
> -out:
> -	close(fd);
> -	return ret;
> -}
> -
>   static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
>   {
>   	struct btrfs_fs_devices *cur_seed, *next_seed;
> 
