From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 1/6] Btrfs: Abstract similar code for btrfs_block_rsv_add{,
 _noflush}()
Date: Thu, 10 Nov 2011 15:31:08 +0800
Message-ID: <4EBB7DBC.8060701@cn.fujitsu.com>
References: <4EBB6F07.6000009@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EBB6F07.6000009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

The mail of PATCH 0 was always rejected, so I try to send it as the
reply of PATCH 1.
====================
Title: [PATCH 0/6] Random fix of the space relocation

This patchset fixes 5 bugs of the space relocation, one fixes the problem
that we forgot to reserve space for writing out i-node cache, one fixes
that the path is not released, this problem may cause the deadlock.
one fixes the no-cow problem, this problem will break the meta-data.
one fixes the deadlock that caused by the race between the relocation
and the snapshot creation, the last one fixes BUG_ON() which is triggered
by the orphan back-ref nodes.

NOTE: This patchset is based on the danger branch.

Miao Xie (6):
  Btrfs: Abstract similar code for btrfs_block_rsv_add{, _noflush}()
  Btrfs: fix no reserved space for writing out inode cache
  Btrfs: fix unreleased path in btrfs_orphan_cleanup()
  Btrfs: fix nocow when deleting the item
  Btrfs: fix deadlock caused by the race between relocation and snapshot creation
  Btrfs: fix orphan backref nodes

 fs/btrfs/extent-tree.c |   28 ++++++++++++----------------
 fs/btrfs/inode-map.c   |   28 ++++++++++++++++++++++++----
 fs/btrfs/inode.c       |    3 +++
 fs/btrfs/relocation.c  |    2 ++
 fs/btrfs/transaction.c |    4 ++--
 fs/btrfs/volumes.c     |    5 ++++-
 6 files changed, 47 insertions(+), 23 deletions(-)

On thu, 10 Nov 2011 14:28:23 +0800, Miao Xie wrote:
> btrfs_block_rsv_add{, _noflush}() have similar code, so abstract that code.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c |   28 ++++++++++++----------------
>  1 files changed, 12 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 1311beb..6703a43 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3796,16 +3796,16 @@ void btrfs_free_block_rsv(struct btrfs_root *root,
>  	kfree(rsv);
>  }
>  
> -int btrfs_block_rsv_add(struct btrfs_root *root,
> -			struct btrfs_block_rsv *block_rsv,
> -			u64 num_bytes)
> +static inline int __block_rsv_add(struct btrfs_root *root,
> +				  struct btrfs_block_rsv *block_rsv,
> +				  u64 num_bytes, int flush)
>  {
>  	int ret;
>  
>  	if (num_bytes == 0)
>  		return 0;
>  
> -	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, 1);
> +	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
>  	if (!ret) {
>  		block_rsv_add_bytes(block_rsv, num_bytes, 1);
>  		return 0;
> @@ -3814,22 +3814,18 @@ int btrfs_block_rsv_add(struct btrfs_root *root,
>  	return ret;
>  }
>  
> +int btrfs_block_rsv_add(struct btrfs_root *root,
> +			struct btrfs_block_rsv *block_rsv,
> +			u64 num_bytes)
> +{
> +	return __block_rsv_add(root, block_rsv, num_bytes, 1);
> +}
> +
>  int btrfs_block_rsv_add_noflush(struct btrfs_root *root,
>  				struct btrfs_block_rsv *block_rsv,
>  				u64 num_bytes)
>  {
> -	int ret;
> -
> -	if (num_bytes == 0)
> -		return 0;
> -
> -	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, 0);
> -	if (!ret) {
> -		block_rsv_add_bytes(block_rsv, num_bytes, 1);
> -		return 0;
> -	}
> -
> -	return ret;
> +	return __block_rsv_add(root, block_rsv, num_bytes, 0);
>  }
>  
>  int btrfs_block_rsv_check(struct btrfs_root *root,

