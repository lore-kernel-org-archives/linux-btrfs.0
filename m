Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47917 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3BAC4V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 21:56:21 -0500
Date: Fri, 1 Feb 2013 10:53:30 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [RFC][PATCH 2/2] Btrfs: implement unlocked dio write
Message-ID: <20130201025218.GA7690@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <510A3BB7.4090201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <510A3BB7.4090201@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 05:39:03PM +0800, Miao Xie wrote:
> This idea is from ext4. By this patch, we can make the dio write parallel,
> and improve the performance.

Interesting, AFAIK, ext4 can only do nolock dio write on some
conditions(should be a overwrite, file size remains unchanged,
no aligned/buffer io in flight), btrfs is ok without any conditions?

thanks,
liubo

> 
> We needn't worry about the race between dio write and truncate, because the
> truncate need wait untill all the dio write end.
> 
> And we also needn't worry about the race between dio write and punch hole,
> because we have extent lock to protect our operation.
> 
> I ran fio to test the performance of this feature.
> 
> == Hardware ==
> CPU: Intel(R) Core(TM)2 Duo CPU     E7500  @ 2.93GHz
> Mem: 2GB
> SSD: Intel X25-M 120GB (Test Partition: 60GB)
> 
> == config file ==
> [global]
> ioengine=psync
> direct=1
> bs=4k
> size=32G
> runtime=60
> directory=/mnt/btrfs/
> filename=testfile
> group_reporting
> thread
> 
> [file1]
> numjobs=1 # 2 4
> rw=randwrite
> 
> == result (KBps) ==
> write	1	2	4
> lock	24936	24738	24726
> nolock	24962	30866	32101
> 
> == result (iops) ==
> write	1	2	4
> lock	6234	6184	6181
> nolock	6240	7716	8025
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d17a04b..091593a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6589,31 +6589,33 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = file->f_mapping->host;
>  	int flags = 0;
> -	bool wakeup = false;
> +	bool wakeup = true;
>  	int ret;
>  
>  	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
>  			    offset, nr_segs))
>  		return 0;
>  
> -	if (rw == READ) {
> -		atomic_inc(&inode->i_dio_count);
> -		smp_mb__after_atomic_inc();
> -		if (unlikely(test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
> -				      &BTRFS_I(inode)->runtime_flags))) {
> -			inode_dio_done(inode);
> -			flags = DIO_LOCKING | DIO_SKIP_HOLES;
> -		} else {
> -			wakeup = true;
> -		}
> +	atomic_inc(&inode->i_dio_count);
> +	smp_mb__after_atomic_inc();
> +	if (rw == WRITE) {
> +		mutex_unlock(&inode->i_mutex);
> +	} else if (unlikely(test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
> +				     &BTRFS_I(inode)->runtime_flags))) {
> +		inode_dio_done(inode);
> +		flags = DIO_LOCKING | DIO_SKIP_HOLES;
> +		wakeup = false;
>  	}
>  
>  	ret = __blockdev_direct_IO(rw, iocb, inode,
>  			BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
>  			iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
>  			btrfs_submit_direct, flags);
> +
>  	if (wakeup)
>  		inode_dio_done(inode);
> +	if (rw == WRITE)
> +		mutex_lock(&inode->i_mutex);
>  	return ret;
>  }
>  
> -- 
> 1.7.11.7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
