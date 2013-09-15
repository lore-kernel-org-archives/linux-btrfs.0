Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40793 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3IOE7o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Sep 2013 00:59:44 -0400
Message-ID: <52353EAE.4050102@oracle.com>
Date: Sun, 15 Sep 2013 12:59:26 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] Btrfs-progs: fix typo in btrfs_err_str()
References: <1378706892-5341-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1378706892-5341-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Glad that you noticed. as I did when error strings
  were given the error-code at the kernel patch
     183860f btrfs: device delete to get errors from the kernel

  which didn't alter the original error strings.

  Now, The new error string proposed here is wrong as shown below..

-----
# btrfs fi show
Label: none  uuid: 22bcca66-a10e-4f1b-b333-c79dba190db7 mounted: /btrfs
	Group profile: Metadata: RAID5    <--------
	Total devices 3 FS bytes used 32.00KiB
	devid    1 size 1.98GiB used 164.00MiB path /dev/mapper/mpatha
	devid    2 size 2.00GiB used 160.00MiB path /dev/mapper/mpathb
	devid    3 size 1.07GiB used 160.00MiB path /dev/sdd

# btrfs dev del /dev/sdd /btrfs
# btrfs fi show
Label: none  uuid: 22bcca66-a10e-4f1b-b333-c79dba190db7 mounted: /btrfs
	Group profile: Metadata: RAID5
	Total devices 2 FS bytes used 28.00KiB
	devid    1 size 1.98GiB used 292.00MiB path /dev/mapper/mpatha
	devid    2 size 2.00GiB used 288.00MiB path /dev/mapper/mpathb

# btrfs dev del /dev/mapper/mpathb /btrfs
ERROR: error removing the device '/dev/mapper/mpathb' - unable to go 
below three devices on raid5
#
-------
   ^^^  we are already at two disks !


Thanks, Anand


On 09/09/2013 02:08 PM, Wang Shilong wrote:
> Raid5 and raid6 at least need three and foure devices respectively,
> fix it.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
> based on david's integration 20130903
> ---
>   ioctl.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/ioctl.h b/ioctl.h
> index e959720..c0dcc06 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -484,9 +484,9 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
>   		case BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET:
>   			return "unable to go below four devices on raid10";
>   		case BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET:
> -			return "unable to go below two devices on raid5";
> +			return "unable to go below three devices on raid5";
>   		case BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET:
> -			return "unable to go below three devices on raid6";
> +			return "unable to go below four devices on raid6";
>   		case BTRFS_ERROR_DEV_TGT_REPLACE:
>   			return "unable to remove the dev_replace target dev";
>   		case BTRFS_ERROR_DEV_MISSING_NOT_FOUND:
>

