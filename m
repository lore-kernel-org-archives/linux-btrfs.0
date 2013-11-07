Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16622 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3KGIZw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 03:25:52 -0500
Message-ID: <527B5092.701@oracle.com>
Date: Thu, 07 Nov 2013 16:34:26 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 13/16] btrfs-progs: check btrfs_scan_one_device in btrfs_scan_lblkid()
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com> <1383779755-18228-14-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-14-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



reviewed-by: Anand Jain <anand.jain@oracle.com>


On 11/07/2013 07:15 AM, Eric Sandeen wrote:
> Even if it's "definitely" btrfs at this point,
> btrfs_scan_one_device could fail for other reasons.
>
> Check the return value, warn if it fails, and skip
> the device register.
>
> Resolves-Coverity-CID: 1125925
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>   utils.c |    9 ++++++++-
>   1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/utils.c b/utils.c
> index 8471148..ecacc29 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1937,6 +1937,7 @@ int test_skip_this_disk(char *path)
>   int btrfs_scan_lblkid(int update_kernel)
>   {
>   	int fd = -1;
> +	int ret;
>   	u64 num_devices;
>   	struct btrfs_fs_devices *tmp_devices;
>   	blkid_dev_iterate iter = NULL;
> @@ -1965,8 +1966,14 @@ int btrfs_scan_lblkid(int update_kernel)
>   			printf("ERROR: could not open %s\n", path);
>   			continue;
>   		}
> -		btrfs_scan_one_device(fd, path, &tmp_devices,
> +		ret = btrfs_scan_one_device(fd, path, &tmp_devices,
>   				&num_devices, BTRFS_SUPER_INFO_OFFSET);
> +		if (ret) {
> +			printf("ERROR: could not scan %s\n", path);
> +			close (fd);
> +			continue;
> +		}
> +
>   		close(fd);
>   		if (update_kernel)
>   			btrfs_register_one_device(path);
>
