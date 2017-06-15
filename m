Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48384 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdFOVyB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 17:54:01 -0400
Subject: Re: [PATCH 3/5] btrfs: move dev stats accounting out of
 wait_dev_flush
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1497544265.git.dsterba@suse.com>
 <4d289b92beb5c7d81ba1c6e26a18bcc7868a9f67.1497544265.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <3a9e9f54-3207-cd55-40ea-dd20d5ff63bd@oracle.com>
Date: Fri, 16 Jun 2017 06:00:16 +0800
MIME-Version: 1.0
In-Reply-To: <4d289b92beb5c7d81ba1c6e26a18bcc7868a9f67.1497544265.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/16/2017 12:49 AM, David Sterba wrote:
> We should really just wait in wait_dev_flush and let the caller decide
> what to do with the error value.

  Nice.
  Reviewed-by: Anand Jain <anand.jain@oracle.com>


> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/disk-io.c | 11 +++--------
>   1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 05ff81ecb887..59a732a13370 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3512,7 +3512,6 @@ static void write_dev_flush(struct btrfs_device *device)
>    */
>   static int wait_dev_flush(struct btrfs_device *device)
>   {
> -	int ret = 0;
>   	struct request_queue *q = bdev_get_queue(device->bdev);
>   	struct bio *bio = device->flush_bio;
>   
> @@ -3521,13 +3520,7 @@ static int wait_dev_flush(struct btrfs_device *device)
>   
>   	wait_for_completion_io(&device->flush_wait);
>   
> -	if (bio->bi_error) {
> -		ret = bio->bi_error;
> -		btrfs_dev_stat_inc_and_print(device,
> -				BTRFS_DEV_STAT_FLUSH_ERRS);
> -	}
> -
> -	return ret;
> +	return bio->bi_error;
>   }
>   
>   static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
> @@ -3586,6 +3579,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>   		ret = wait_dev_flush(dev);
>   		if (ret) {
>   			dev->last_flush_error = ret;
> +			btrfs_dev_stat_inc_and_print(dev,
> +					BTRFS_DEV_STAT_FLUSH_ERRS);
>   			errors_wait++;
>   		}
>   	}
> 
