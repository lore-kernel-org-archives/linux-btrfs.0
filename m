From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH v2 4/5] Btrfs: Add readonly snapshots support
Date: Thu, 9 Dec 2010 20:34:10 +0100
Message-ID: <201012092034.11019.kreijack@libero.it>
References: <4D009CD2.3060805@cn.fujitsu.com> <4D009D28.3060509@cn.fujitsu.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D009D28.3060509@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Li,

On Thursday, 09 December, 2010, Li Zefan wrote:
> Usage:
> 
> Set BTRFS_SUBVOL_RDONLY of btrfs_ioctl_vol_arg_v2->flags, and call
> ioctl(BTRFS_I0CTL_SNAP_CREATE_V2).
> 
> Implementation:
> 
> - In disk set readonly bit of btrfs_root_item->flags, and in memory
> set btrfs_root->readonly.
> 
> - Add readonly checks in btrfs_permission (inode_permission),
> btrfs_setattr, btrfs_set/remove_xattr and some ioctls.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/btrfs/ctree.h       |    3 +++
>  fs/btrfs/disk-io.c     |    5 +++++
>  fs/btrfs/inode.c       |    8 ++++++++
>  fs/btrfs/ioctl.c       |   40 +++++++++++++++++++++++++++++++---------
>  fs/btrfs/ioctl.h       |    1 +
>  fs/btrfs/transaction.c |    8 ++++++++
>  fs/btrfs/transaction.h |    1 +
>  fs/btrfs/xattr.c       |   18 ++++++++++++++++++
>  8 files changed, 75 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index af52f6d..ad37c78 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -597,6 +597,8 @@ struct btrfs_dir_item {
>  	u8 type;
>  } __attribute__ ((__packed__));
>  
> +#define BTRFS_ROOT_SNAP_RDONLY	(1ULL << 0)
> +
>  struct btrfs_root_item {
>  	struct btrfs_inode_item inode;
>  	__le64 generation;
> @@ -1116,6 +1118,7 @@ struct btrfs_root {
>  	int defrag_running;
>  	char *name;
>  	int in_sysfs;
> +	bool readonly;

Does make sense to store the same information in two places ?
If we have access to root->readonly, we have also access to "root-
>root_item.flags". Because we need the latter, we can get rid of the former.


We can replace a test like

	if(root->readonly) 

with

	if(root->root_item.flags & BTRFS_ROOT_SNAP_RDONLY)

Or better we can create a two macros like:

#define btrfs_root_readonly(x) ((x)->root_item.flags & BTRFS_ROOT_SNAP_RDONLY)
#define btrfs_root_set_readonly(x, ro) 					    \
	do{ 	(x)->root_item.flags = 					    \
			((x)->root_item.flags & ~BTRFS_ROOT_SNAP_RDONLY) |  \
			(ro ? BTRFS_ROOT_SNAP_RDONLY : 0 ); 		    \
	}while(0)


Sorry for to be too late for this kind of suggestion. But I think that this 
optimization may help to avoid misalignment between the two variables (see my 
reply in the next patch).
[...]
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
