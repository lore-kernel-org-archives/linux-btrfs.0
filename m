From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Revert "Btrfs: increase the global block reserve
 estimates"
Date: Wed, 11 Apr 2012 18:00:30 +0200
Message-ID: <20120411160030.GG11041@twin.jikos.cz>
References: <1333928451-26468-1-git-send-email-dsterba@suse.cz>
 <4F823D44.5070200@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
	stable@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F823D44.5070200@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2012 at 09:37:08AM +0800, Liu Bo wrote:
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a844204..1b692c2 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3844,6 +3844,7 @@ again:
>  
>  		spin_lock(&root->fs_info->free_chunk_lock);
>  		avail = root->fs_info->free_chunk_space;
> +		spin_unlock(&root->fs_info->free_chunk_lock);
>  
>  		/*
>  		 * If we have dup, raid1 or raid10 then only half of the free
> @@ -3854,17 +3855,6 @@ again:
>  			       BTRFS_BLOCK_GROUP_RAID10))
>  			avail >>= 1;
>  
> -		/*
> -		 * If we aren't flushing don't let us overcommit too much, say
> -		 * 1/8th of the space.  If we can flush, let it overcommit up to
> -		 * 1/2 of the space.
> -		 */
> -		if (flush)
> -			avail >>= 3;
> -		else
> -			avail >>= 1;
> -		 spin_unlock(&root->fs_info->free_chunk_lock);
> -
>  		if (used + num_bytes < space_info->total_bytes + avail) {
>  			space_info->bytes_may_use += orig_bytes;
>  			trace_btrfs_space_reservation(root->fs_info,

Hangs during xfstests/013 with freshly made fs with just -o space_cache
mount:

$ btrfs fi df /mnt/a1
Data, RAID0: total=4.00GB, used=652.00KB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=1.00GB, used=52.00KB
Metadata: total=8.00MB, used=0.00

/root/xfstests/ltp/fsstress -r -v -m 8 -n 1000 -d /mnt/a1/fsstress.26492.1

[<ffffffffa004e845>] btrfs_start_ordered_extent+0x85/0x140 [btrfs]
[<ffffffffa004ea44>] btrfs_wait_ordered_extents+0x144/0x230 [btrfs]
[<ffffffffa0004962>] btrfs_sync_fs+0x52/0x100 [btrfs]
[<ffffffff81172983>] __sync_filesystem+0x63/0x90
[<ffffffff811729cf>] sync_one_sb+0x1f/0x30
[<ffffffff81147611>] iterate_supers+0xf1/0x100
[<ffffffff811728d0>] sync_filesystems+0x20/0x30
[<ffffffff81172a76>] sys_sync+0x26/0x40
[<ffffffff818a65a9>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
