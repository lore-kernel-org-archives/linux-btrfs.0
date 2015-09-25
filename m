Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34858 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbbIYGzk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 02:55:40 -0400
Message-ID: <5604EF8B.5060503@oracle.com>
Date: Fri, 25 Sep 2015 14:54:03 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] btrfs: Do per-chunk degraded check for remount
References: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com> <1442801443-5132-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1442801443-5132-4-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/21/2015 10:10 AM, Qu Wenruo wrote:
> Just the same for mount time check, use new btrfs_check_degraded() to do
> per chunk check.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/super.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index c389c13..720c044 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1681,11 +1681,14 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>   			goto restore;
>   		}
>
> -		if (fs_info->fs_devices->missing_devices >
> -		     fs_info->num_tolerated_disk_barrier_failures &&
> -		    !(*flags & MS_RDONLY)) {
> +		ret = btrfs_check_degradable(fs_info, *flags);
> +		if (ret < 0) {
> +			btrfs_error(fs_info, ret,
> +				    "degraded writable remount failed");

btrfs_erorr() which is an error handling routine, isn't appropriate 
here, mainly because as we are in the remount context, I am not sure if 
you meant to change the fs state to readonly (on error) in the remount 
context ? or Instead btrfs_err() which is an error reporting/logging 
would be appropriate.

btrfs_erorr() and btrfs_err() are way different in action but very easy 
have an oversight and use the wrong one. the below patch changed it..

    Btrfs: consolidate btrfs_error() to btrfs_std_error()

Thanks, Anand


> +			goto restore;
> +		} else if (ret > 0 && !btrfs_test_opt(root, DEGRADED)) {
>   			btrfs_warn(fs_info,
> -				"too many missing devices, writeable remount is not allowed");
> +				"some device missing, but still degraded mountable, please remount with -o degraded option");
>   			ret = -EACCES;
>   			goto restore;
>   		}
>
