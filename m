Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:46600 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3J2QkV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 12:40:21 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 55CEA9A0687
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 10:40:21 -0600 (MDT)
Date: Tue, 29 Oct 2013 12:40:19 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: lblkid wouldn't find non mapper path input
Message-ID: <20131029164019.GG4543@localhost.localdomain>
References: <1383064490-28875-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1383064490-28875-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 30, 2013 at 12:34:50AM +0800, Anand Jain wrote:
> A new test case when disk is unmounted and if the non mapper
> disk path is given as the argument to the btrfs filesystem show <arg>
> we still need this to work but lblkid will pull only mapper disks,
> it won't match. So this will normalize the input to find btrfs
> by fsid and pass it to the search.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  cmds-filesystem.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 49 insertions(+), 3 deletions(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index fcabdb0..3a494fd 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -37,6 +37,7 @@
>  #include "version.h"
>  #include "commands.h"
>  #include "list_sort.h"
> +#include "disk-io.h"
>  
>  static const char * const filesystem_cmd_group_usage[] = {
>  	"btrfs filesystem [<group>] <command> [<args>]",
> @@ -414,6 +415,39 @@ static int btrfs_scan_kernel(void *search)
>  	return 0;
>  }
>  
> +static int dev_to_fsid(char *dev, __u8 *fsid)
> +{
> +	struct btrfs_super_block *disk_super;
> +	char *buf;
> +	int ret;
> +	int fd;
> +
> +	buf = malloc(4096);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	fd = open(dev, O_RDONLY);
> +	if (fd < 0) {
> +		ret = -errno;
> +		free(buf);
> +		return ret;
> +	}
> +
> +	disk_super = (struct btrfs_super_block *)buf;
> +	ret = btrfs_read_dev_super(fd, disk_super,
> +			BTRFS_SUPER_INFO_OFFSET);
> +	if (ret)
> +		goto out;
> +
> +	memcpy(fsid, disk_super->fsid, BTRFS_FSID_SIZE);
> +	ret = 0;
> +
> +out:
> +	close(fd);
> +	free(buf);
> +	return ret;
> +}
> +
>  static const char * const cmd_show_usage[] = {
>  	"btrfs filesystem show [options] [<path>|<uuid>|<device>|label]",
>  	"Show the structure of a filesystem",
> @@ -434,6 +468,8 @@ static int cmd_show(int argc, char **argv)
>  	int type = 0;
>  	char mp[BTRFS_PATH_NAME_MAX + 1];
>  	char path[PATH_MAX];
> +	__u8 fsid[BTRFS_FSID_SIZE];
> +	char uuid_buf[37];
>  

No magic numbers.

>  	while (1) {
>  		int long_index;
> @@ -480,11 +516,21 @@ static int cmd_show(int argc, char **argv)
>  				if (!ret)
>  					/* given block dev is mounted*/
>  					search = mp;
> -				else
> +				else {

This isn't the right format, needs to add braces for the if part too.

> +					ret = dev_to_fsid(search, fsid);
> +					if (ret) {
> +						fprintf(stderr,
> +							"ERROR: No btrfs on %s\n",
> +							search);
> +						return 1;
> +					}
> +					uuid_unparse(fsid, uuid_buf);
> +					search = uuid_buf;
> +					type = BTRFS_ARG_UUID;
>  					goto devs_only;
> +				}
>  			}
> -		}
> -		if (type == BTRFS_ARG_MNTPOINT) {
> +		} else if (type == BTRFS_ARG_MNTPOINT) {

This looks like it will break something if we fall through from above?  Thanks,

Josef
