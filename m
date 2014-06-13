Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35777 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaFMEgL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 00:36:11 -0400
Message-ID: <539A7FAC.60708@oracle.com>
Date: Fri, 13 Jun 2014 12:35:56 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: When devices with same dev uuid occurs, only add
 the one with largest generation.
References: <1402390387-28730-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1402390387-28730-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Qu,

  Kindly note, device->generation is not updated when user scan the
  device for the first time.

  I have sent out patch:
   [PATCH 2/2] btrfs: check generation as replace duplicates devid+uuid

  Please feel free to add your Signed-off-by, if you think so.

  review comments are appreciated as usual.

Thanks, Anand


On 10/06/2014 16:53, Qu Wenruo wrote:
> Since btrfs currently use dulicated dev uuid when doing device replace,
> the following problem will happen:
>
> 1) mount with device A missing using degraded mode.
> 2) replace device A with device B.
> 3) device A reappears.
> 4) umount btrfs fs.
> 5) mount btrfs fs.
>
> After step 5), btrfs will still use device A even device B has a larger
> generation.
>
> The patch will judge generation when difference device with same dev
> uuid.
> And the patch should be applied after Anand's patch:
> https://patchwork.kernel.org/patch/4309651/
>
> Cc: Anand Jain <Anand.Jain@oracle.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/volumes.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0a5017a..07f0cf7 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -508,7 +508,8 @@ static noinline int device_list_add(const char *path,
>
>   		ret = 1;
>   		device->fs_devices = fs_devices;
> -	} else if (!device->name || strcmp(device->name->str, path)) {
> +	} else if (!device->name || (strcmp(device->name->str, path) &&
> +		   found_transid > device->generation)) {
>   		/*
>   		 * When FS is already mounted.
>   		 * 1. If you are here and if the device->name is NULL that means
>
