Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41810 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751602AbdADHxE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jan 2017 02:53:04 -0500
Subject: Re: [PATCH] btrfs: fix false enospc error when truncating heavily
 reflinked file
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <20160907121738.23713-1-wangxg.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4e3e1e7e-aeaf-9b81-0b0e-d1311f2b7ef1@cn.fujitsu.com>
Date: Wed, 4 Jan 2017 15:52:47 +0800
MIME-Version: 1.0
In-Reply-To: <20160907121738.23713-1-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Any comment on this patch?

Without it, btrfs will always fail for generic/387.

Thanks,
Qu

At 09/07/2016 08:17 PM, Wang Xiaoguang wrote:
> Below test script can reveal this bug:
>     dd if=/dev/zero of=fs.img bs=$((1024*1024)) count=100
>     dev=$(losetup --show -f fs.img)
>     mkdir -p /mnt/mntpoint
>     mkfs.btrfs  -f $dev
>     mount $dev /mnt/mntpoint
>     cd /mnt/mntpoint
>
>     echo "workdir is: /mnt/mntpoint"
>     blocksize=$((128 * 1024))
>     dd if=/dev/zero of=testfile bs=$blocksize count=1
>     sync
>     count=$((17*1024*1024*1024/blocksize))
>     echo "file size is:" $((count*blocksize))
>     for ((i = 1; i <= $count; i++)); do
>         dst_offset=$((blocksize * i))
>         xfs_io -f -c "reflink testfile 0 $dst_offset $blocksize"\
>                 testfile > /dev/null
>     done
>     sync
>     truncate --size 0 testfile
>
> The last truncate operation will fail for ENOSPC reason, but indeed
> it should not fail.
>
> In btrfs_truncate(), we use a temporary block_rsv to do truncate
> operation. With every btrfs_truncate_inode_items() call, we migrate space
> to this block_rsv, but forget to cleanup previous reservation, which
> will make this block_rsv's reserved bytes keep growing, and this reserved
> space will only be released in the end of btrfs_truncate(), this metadata
> leak will impact other's metadata reservation. In this case, it's
> "btrfs_start_transaction(root, 2);" fails for enospc error, which make
> this truncate operation fail.
>
> Call btrfs_block_rsv_release() to fix this bug.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e6811c4..40f0762 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9206,6 +9206,7 @@ static int btrfs_truncate(struct inode *inode)
>  			break;
>  		}
>
> +		btrfs_block_rsv_release(root, rsv, -1);
>  		ret = btrfs_block_rsv_migrate(&root->fs_info->trans_block_rsv,
>  					      rsv, min_size, 0);
>  		BUG_ON(ret);	/* shouldn't happen */
>


