From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v2 5/5] Btrfs: Add BTRFS_IOC_SUBVOL_GETFLAGS/SETFLAGS
 ioctl
Date: Fri, 10 Dec 2010 15:12:41 +0800
Message-ID: <4D01D2E9.9000007@cn.fujitsu.com>
References: <4D009CD2.3060805@cn.fujitsu.com> <4D009D42.1020002@cn.fujitsu.com> <201012092109.05720.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012092109.05720.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli wrote:
> Hi Li,
> 
> On Thursday, 09 December, 2010, Li Zefan wrote:
>> This allows us to set a snapshot or a subvolume readonly or writable
>> on the fly.
>>
>> Usage:
>>
>> Set BTRFS_SUBVOL_RDONLY of btrfs_ioctl_vol_arg_v2->flags, and then
>> call ioctl(BTRFS_IOCTL_SUBVOL_SETFLAGS);
>>
>> Changelog for v2:
>> - Add _GETFLAGS ioctl.
>> - Check if the passed fd is the root of a subvolume.
>> - Change the name from _SNAP_SETFLAGS to _SUBVOL_SETFLAGS.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  fs/btrfs/ioctl.c |   92 
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/btrfs/ioctl.h |    4 ++
>>  2 files changed, 96 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index db2b231..29304c7 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -1010,6 +1010,94 @@ out:
> [...]
>> +	struct btrfs_ioctl_vol_args_v2 *vol_args;
>> +	int ret = 0;
>> +	u64 flags = 0;
>> +
>> +	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID)
>> +		return -EINVAL;
>> +
>> +	vol_args = memdup_user(arg, sizeof(*vol_args));
> 
> Would be better to avoid a dynamic allocation for a so small struct ? 
> And as more general comment: what is the reason to pass a so complex struct 
> only for setting/getting the flags ?
> Would be it better to pass directly a u64 variable.
> 

I was considering using the same structure for all subvolume ioctls,
but here seems it's overkill..

> [..]
>> +
>> +static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
>> +					      void __user *arg)
>> +{
>> +	struct inode *inode = fdentry(file)->d_inode;
>> +	struct btrfs_root *root = BTRFS_I(inode)->root;
>> +	struct btrfs_trans_handle *trans;
>> +	struct btrfs_ioctl_vol_args_v2 *vol_args;
>> +	u64 root_flags;
>> +	u64 flags;
>> +	int ret = 0;
>> +
>> +	if (root->fs_info->sb->s_flags & MS_RDONLY)
>> +		return -EROFS;
>> +
>> +	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID)
>> +		return -EINVAL;
>> +
>> +	vol_args = memdup_user(arg, sizeof(*vol_args));
> 
> Same as before.
> 
>> +	if (IS_ERR(vol_args))
>> +		return PTR_ERR(vol_args);
>> +	flags = vol_args->flags;
>> +
>> +	if (flags & ~BTRFS_SUBVOL_RDONLY) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	down_write(&root->fs_info->subvol_sem);
>> +
>> +	/* nothing to do */
>> +	if (!!(flags & BTRFS_SUBVOL_RDONLY) == root->readonly)
>> +		goto out_unlock;
> 
> This is only an aesthetic comment: I prefer a simpler style like
> 
> 	if ((flags & BTRFS_SUBVOL_RDONLY) && root->readonly)
> 		goto out_unlock;
> 

They are not equivalent. The former checks if the flags and the
root both have readonly bit set or cleared.

> But I know that every body has its style :-)
> 
>> +
>> +	root_flags = btrfs_root_flags(&root->root_item);
>> +	if (flags & BTRFS_SUBVOL_RDONLY)
>> +		btrfs_set_root_flags(&root->root_item,
>> +				     root_flags | BTRFS_ROOT_SNAP_RDONLY);
>> +	else
>> +		btrfs_set_root_flags(&root->root_item,
>> +				     root_flags & ~BTRFS_ROOT_SNAP_RDONLY);
>> +	root->readonly = !root->readonly;
> 
> I double checked this line. But if I read the code correctly I think that the 
> line above is wrong: the field "root->readonly" is flipped regardless the 
> value of the flags passed by the user.
> 

Yep, that's because if we don't need to flip it, we've already exited early.

Note, there's only one flag.

> Moreover I have another question: why internally the flags is 
> BTRFS_ROOT_SNAP_RDONLY, instead in user space the flag is BTRFS_SUBVOL_RDONLY 
> ? 
> 

That's my carelessness..

> I suggest to 
> - rename BTRFS_SUBVOL_RDONLY in BTRFS_SUBVOL_CREATE_SNAP_RDONLY (like 
> BTRFS_SUBVOL_CREATE_SNAP_ASYNC)
> - rename BTRFS_ROOT_SNAP_RDONLY in BTRFS_ROOT_FLAGS_RDONLY and use both in 
> userspace and in kernel space this flag. I suggested to remove SNAP because 
> the flag make sense also for a "standard" subvolume.
> 

I'd prefer not to mix flags for root_item flags and vol ioctl flags.

And CREATE_RDONLY and CREATE_ASYNC can also be valid for subvolumes too.
Support for async subvolume creation is already there, just lack of an
user interface. So I've changed _CREATE_SNAP_ASYNC to _CREATE_ASYNC
in the patch I sent just now.
