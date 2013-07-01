Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30581 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab3GAIRX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 04:17:23 -0400
Message-ID: <51D13C20.1050104@oracle.com>
Date: Mon, 01 Jul 2013 16:21:52 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs-progs: remove unused code
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com> <1372593106-6593-4-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372593106-6593-4-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


good catch.

Reviewed-by: Anand Jain <anand.jain@oracle.com>


On 06/30/2013 07:51 PM, Filipe David Borba Manana wrote:
> The uuid_unparse() call in btrfs_scan_one_device() was
> a no-op.
>
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>   volumes.c |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/volumes.c b/volumes.c
> index ea1d401..9d5e97e 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -223,7 +223,6 @@ int btrfs_scan_one_device(int fd, const char *path,
>   	char *buf;
>   	int ret;
>   	u64 devid;
> -	char uuidbuf[37];
>
>   	buf = malloc(4096);
>   	if (!buf) {
> @@ -241,7 +240,6 @@ int btrfs_scan_one_device(int fd, const char *path,
>   		*total_devs = 1;
>   	else
>   		*total_devs = btrfs_super_num_devices(disk_super);
> -	uuid_unparse(disk_super->fsid, uuidbuf);
>
>   	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
>
>
