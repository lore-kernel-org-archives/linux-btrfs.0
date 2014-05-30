Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20461 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaE3KRf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 06:17:35 -0400
Message-ID: <53885B6D.5010604@oracle.com>
Date: Fri, 30 May 2014 18:20:29 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: dsterba@suse.cz, quwenruo@cn.fujitsu.com, clm@fb.com
Subject: Re: [PATCH] btrfs: kobject_uevent should use bd_part instead of bd_disk
References: <1401436259-17647-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1401436259-17647-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


   Nack for this as of now. sorry. Qu finds, this doesn't fix.
   my test case was dev delete and then ls -l dev by hand.
   Qu's test case is same but a script. Looks like that time
   gap is the key.

   Looking more.

Thanks,  Anand


On 30/05/14 15:50, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
>
> reproducer 1:
>   mkfs.btrfs -L test /dev/sdg1
>   mount LABEL=test /btrfs
>   btrfs dev add /dev/sdg2 /btrfs
>   btrfs dev del /dev/sdg1 /btrfs
>   umount /btrfs
>   mount LABEL=test /btrfs
>     mount: special device LABEL-test1 does not exist
>
>   It does not reproduce this problem when whole disk is used.
>   And when newer kernel is used not sure what change in udev
>   is doing the trick. But in any case reproducer2 below is
>   more compelling.
>
> reproducer 2:
>   btrfs dev del /dev/sdh2 /btrfs
>   ls -l /dev/sdh1 /dev/sdh2 /dev/sdh3
>   mtime of deleted disk is stale.
>
>   Fix it by providing bd_part for the kobject_uevent().
>
>   I have tested to confirm it doesn't break on the same thing
>   when whole disk is used.
>
> Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> ---
>   fs/btrfs/volumes.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f58ea9e..1aba687 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -124,7 +124,7 @@ static void btrfs_kobject_uevent(struct block_device *bdev,
>   {
>   	int ret;
>
> -	ret = kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, action);
> +	ret = kobject_uevent(&part_to_dev(bdev->bd_part)->kobj, action);
>   	if (ret)
>   		pr_warn("BTRFS: Sending event '%d' to kobject: '%s' (%p): failed\n",
>   			action,
>
