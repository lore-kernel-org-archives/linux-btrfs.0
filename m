Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36452 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbbJGJAs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Oct 2015 05:00:48 -0400
Message-ID: <5614DEF7.3050202@oracle.com>
Date: Wed, 07 Oct 2015 16:59:35 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] Btrfs: optimize check for stale device
References: <1444035437-9442-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444035437-9442-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/05/2015 04:57 PM, Anand Jain wrote:
> optimize check for stale device to only be checked when there
> is device added or changed. If there is no update to the
> device, there is no need to call btrfs_free_stale_device().
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   fs/btrfs/volumes.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b8b1171..ec1fcfa 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -620,7 +620,8 @@ static noinline int device_list_add(const char *path,
>   	 * if there is new btrfs on an already registered device,
>   	 * then remove the stale device entry.
>   	 */
> -	btrfs_free_stale_device(device);
> +	if (ret > 0)
> +		btrfs_free_stale_device(device);
>
>   	*fs_devices_ret = fs_devices;
>
>

  I have to withdraw this. The ret is 0 when there is new fsid on a
  previously known device that means we need to clear the stale. v.sorry.

Thanks, Anand
