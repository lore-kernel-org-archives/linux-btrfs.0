Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50152 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab3IXBaf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 21:30:35 -0400
Message-ID: <5240EB6D.101@cn.fujitsu.com>
Date: Tue, 24 Sep 2013 09:31:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] Btrfs: fix sync fs to actually wait for all data to
 be persisted
References: <1379883353-7358-1-git-send-email-fdmanana@gmail.com> <1379932511-16265-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1379932511-16265-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	mon, 23 Sep 2013 11:35:11 +0100, Filipe David Borba Manana wrote:
> Currently the fs sync function (super.c:btrfs_sync_fs()) doesn't
> wait for delayed work to finish before returning success to the
> caller. This change fixes this, ensuring that there's no data loss
> if a power failure happens right after fs sync returns success to
> the caller and before the next commit happens.
> 
> Steps to reproduce the data loss issue:
> 
> $ mkfs.btrfs -f /dev/sdb3
> $ mount /dev/sdb3 /mnt/btrfs
> $ perl -e '$d = ("\x41" x 6001); open($f,">","/mnt/btrfs/foobar"); print $f $d; close($f);' && btrfs fi sync /mnt/btrfs
> 
> Right after the btrfs fi sync command (a second or 2 for example), power
> off the machine and reboot it. The file will be empty, as it can be verified
> after mounting the filesystem and through btrfs-debug-tree:
> 
> $ btrfs-debug-tree /dev/sdb3 | egrep '\(257 INODE_ITEM 0\) itemoff' -B 3 -A 8
>         item 3 key (256 DIR_INDEX 2) itemoff 3751 itemsize 36
>                 location key (257 INODE_ITEM 0) type FILE
>                 namelen 6 datalen 0 name: foobar
>         item 4 key (257 INODE_ITEM 0) itemoff 3591 itemsize 160
>                 inode generation 7 transid 7 size 0 block group 0 mode 100644 links 1
>         item 5 key (257 INODE_REF 256) itemoff 3575 itemsize 16
>                 inode ref index 2 namelen 6 name: foobar
> checksum tree key (CSUM_TREE ROOT_ITEM 0)
> leaf 29429760 items 0 free space 3995 generation 7 owner 7
> fs uuid 6192815c-af2a-4b75-b3db-a959ffb6166e
> chunk uuid b529c44b-938c-4d3d-910a-013b4700bcae
> uuid tree key (UUID_TREE ROOT_ITEM 0)
> 
> After this patch, the data loss no longer happens after a power failure and
> btrfs-debug-tree shows:
> 
> $ btrfs-debug-tree /dev/sdb3 | egrep '\(257 INODE_ITEM 0\) itemoff' -B 3 -A 8
> 	item 3 key (256 DIR_INDEX 2) itemoff 3751 itemsize 36
> 		location key (257 INODE_ITEM 0) type FILE
> 		namelen 6 datalen 0 name: foobar
> 	item 4 key (257 INODE_ITEM 0) itemoff 3591 itemsize 160
> 		inode generation 6 transid 6 size 6001 block group 0 mode 100644 links 1
> 	item 5 key (257 INODE_REF 256) itemoff 3575 itemsize 16
> 		inode ref index 2 namelen 6 name: foobar
> 	item 6 key (257 EXTENT_DATA 0) itemoff 3522 itemsize 53
> 		extent data disk byte 12845056 nr 8192
> 		extent data offset 0 nr 8192 ram 8192
> 		extent compression 0
> checksum tree key (CSUM_TREE ROOT_ITEM 0)
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
> 
> V2: Use writeback_inodes_sb() instead of btrfs_start_all_delalloc_inodes(), as
>     suggested by Miao Xie.
> V3: Use btrfs_start_all_delalloc_inodes() instead but outside btrfs_sync_fs(),
>     in the sync IOCTL handler. Using writeback_inodes_sb() is not very honest
>     because it doesn't guarantee inode data is persisted and we have no way
>     to know if persistence really happened or not, returning 0 (success) always.
>     Thanks Liu Bo for the suggestion.
> V4: Be even more honest in the sync IOCTL handler - don't always return success
>     regardless of the result of the btrfs_sync_fs() call.
> 
>  fs/btrfs/ioctl.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9d46f60..385c58f 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4557,9 +4557,15 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_logical_to_ino(root, argp);
>  	case BTRFS_IOC_SPACE_INFO:
>  		return btrfs_ioctl_space_info(root, argp);
> -	case BTRFS_IOC_SYNC:
> -		btrfs_sync_fs(file->f_dentry->d_sb, 1);
> -		return 0;
> +	case BTRFS_IOC_SYNC: {
> +		int ret;
> +
> +		ret = btrfs_start_all_delalloc_inodes(root->fs_info, 0);
> +		if (ret)
> +			return ret;
> +		ret = btrfs_sync_fs(file->f_dentry->d_sb, 1);
> +		return ret;
> +	}
>  	case BTRFS_IOC_START_SYNC:
>  		return btrfs_ioctl_start_sync(root, argp);
>  	case BTRFS_IOC_WAIT_SYNC:
> 

