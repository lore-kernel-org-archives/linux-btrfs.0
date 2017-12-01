Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48113 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdLAXXE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 18:23:04 -0500
Subject: Re: [PATCH 5/5] btrfs: Greatly simplify btrfs_read_dev_super
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
 <1512119984-12708-6-git-send-email-nborisov@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <96aafd8d-a1e8-2846-0aa3-59b3ff97edb7@oracle.com>
Date: Sat, 2 Dec 2017 07:23:19 +0800
MIME-Version: 1.0
In-Reply-To: <1512119984-12708-6-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/01/2017 05:19 PM, Nikolay Borisov wrote:
> Currently this function executes the inner loop at most 1 due to the i = 0;
> i < 1 condition. Furthermore, the btrfs_super_generation(super) > transid code
> in the if condition is never executed due to latest always set to NULL hence the
> first part of the condition always triggering. The gist of btrfs_read_dev_super
> is really to read the first superblock.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>   fs/btrfs/disk-io.c | 27 ++++-----------------------
>   1 file changed, 4 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 82c96607fc46..6d5f632fd1e7 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3170,37 +3170,18 @@ int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
>   struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
>   {
>   	struct buffer_head *bh;
> -	struct buffer_head *latest = NULL;
> -	struct btrfs_super_block *super;
> -	int i;
> -	u64 transid = 0;
> -	int ret = -EINVAL;
> +	int ret;
>   
>   	/* we would like to check all the supers, but that would make
>   	 * a btrfs mount succeed after a mkfs from a different FS.
>   	 * So, we need to add a special mount option to scan for
>   	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>   	 */

  We need below loop to support the above comment at some point,
  instead of removing I would prefer to fix as per above comments.

Thanks, Anand


> -	for (i = 0; i < 1; i++) {
> -		ret = btrfs_read_dev_one_super(bdev, i, &bh);
> -		if (ret)
> -			continue;
> -
> -		super = (struct btrfs_super_block *)bh->b_data;
> -
> -		if (!latest || btrfs_super_generation(super) > transid) {
> -			brelse(latest);
> -			latest = bh;
> -			transid = btrfs_super_generation(super);
> -		} else {
> -			brelse(bh);
> -		}
> -	}
> -
> -	if (!latest)
> +	ret = btrfs_read_dev_one_super(bdev, 0, &bh);
> +	if (ret)
>   		return ERR_PTR(ret);
>   
> -	return latest;
> +	return bh;
>   }
>   
>   /*
> 
