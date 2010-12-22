From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 2/6] btrfs: try to reclaim some space when chunk
	allocation fails
Date: Wed, 22 Dec 2010 14:21:23 -0500
Message-ID: <20101222192122.GA1669@dhcp231-156.rdu.redhat.com>
References: <4D11D738.3000700@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D11D738.3000700@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 22, 2010 at 06:47:20PM +0800, Miao Xie wrote:
> We cannot write data into files when when there is tiny space in the filesystem.
> 
> Reproduce steps:
>  # mkfs.btrfs /dev/sda1
>  # mount /dev/sda1 /mnt
>  # dd if=/dev/zero of=/mnt/tmpfile0 bs=4K count=1
>  # dd if=/dev/zero of=/mnt/tmpfile1 bs=4K count=99999999999999
>    (fill the filesystem)
>  # umount /mnt
>  # mount /dev/sda1 /mnt
>  # rm -f /mnt/tmpfile0
>  # dd if=/dev/zero of=/mnt/tmpfile0 bs=4K count=1
>    (failed with nospec)
> 
> But if we do the last step again, we can write data successfully. The reason of
> the problem is that btrfs didn't try to commit the current transaction and
> reclaim some space when chunk allocation failed.
> 
> This patch fixes it by committing the current transaction to to reclaim some
> space when chunk allocation fails.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
