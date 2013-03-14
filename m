Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab3CNEgD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 00:36:03 -0400
Message-ID: <514153B0.7020100@redhat.com>
Date: Wed, 13 Mar 2013 23:36:00 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3 v4] btrfs-progs: disable using backup superblock by
 default
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com> <1363230357-7438-1-git-send-email-anand.jain@oracle.com> <1363230357-7438-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1363230357-7438-4-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/13/13 10:05 PM, Anand Jain wrote:

<maybe a little more commit log would be good?>

So here is what confuses me now. :)  

*every* caller of btrfs_read_dev_super() is now called with
0 for the flags variable, so it never reads the backup
under any circumstance.

If it's always called w/ 0, what is the point of the argument?
Is there another patch you have planned that would use this argument
later?

-Eric

> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  disk-io.c   | 2 +-
>  find-root.c | 2 +-
>  volumes.c   | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 796394f..c2e1c8a 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -880,7 +880,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>  	disk_super = fs_info->super_copy;
>  	ret = 
(fs_devices->latest_bdev,
>  				   disk_super, sb_bytenr,
> -				   BTRFS_SCAN_BACKUP_SB);
> +				   0ull);

Isn't just "0" enough?

-Eric

>  	if (ret) {
>  		printk("No valid btrfs found\n");
>  		goto out_devices;
> diff --git a/find-root.c b/find-root.c
> index 9be4fc7..9923209 100644
> --- a/find-root.c
> +++ b/find-root.c
> @@ -151,7 +151,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
>  	disk_super = fs_info->super_copy;
>  	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
>  				   disk_super, BTRFS_SUPER_INFO_OFFSET,
> -				   BTRFS_SCAN_BACKUP_SB);
> +				   0ull);
>  	if (ret) {
>  		printk("No valid btrfs found\n");
>  		goto out_devices;
> diff --git a/volumes.c b/volumes.c
> index 1a28cdd..9003412 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -228,7 +228,7 @@ int btrfs_scan_one_device(int fd, const char *path,
>  	}
>  	disk_super = (struct btrfs_super_block *)buf;
>  	ret = btrfs_read_dev_super(fd, disk_super, super_offset,
> -		BTRFS_SCAN_BACKUP_SB);
> +				   0ull);
>  	if (ret < 0) {
>  		ret = -EIO;
>  		goto error_brelse;
> 

