Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17754 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216AbbFSFZm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 01:25:42 -0400
Subject: Re: [PATCH RFC v7 1/9] vfs: Add sb_want_write() function to grant
 write access to sb without the struct file/vfsmount.
To: <linux-btrfs@vger.kernel.org>
References: <1423201534-19309-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1423201534-19309-2-git-send-email-quwenruo@cn.fujitsu.com>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5583A7D1.1030208@cn.fujitsu.com>
Date: Fri, 19 Jun 2015 13:25:37 +0800
MIME-Version: 1.0
In-Reply-To: <1423201534-19309-2-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any new comments?

BTW, who is responsible to merge the vfs change patch?
Should btrfs maintainers to merge it or vfs maintainer?

Thanks,
Qu

Qu Wenruo wrote on 2015/02/06 13:45 +0800:
> There are sysfs interfaces in some fs, only btrfs yet, which will modify
> on-disk data.
> Unlike normal file operation routine we can use mnt_want_write_file() to
> protect the operation, change through sysfs won't to be binded to any file
> in the filesystem.
>
> So introduce new sb_want_write() to do the protection against a super
> block, which acts much like mnt_want_write() but will return success if
> the super block is read-write.
>
> The implement is to use a atomic value as a simplified rw-semaphore,
> which only provides non-block lock method.
> We don't use the traditional rw-sem because in do_umount(), we need to
> block incoming sb_want_write() until the sb is killed if this is the
> last mount instance.
> However kill_sb() can be delayed to other thread, so down_write() and
> up_write() will happen in different thread, and this is not allowed.
>
> This patch also slightly modified struct super_block and
> do_umount/remount(), where we do extra check for blocking sb_want_write()
> and don't allow the umount of the *last* mount instance of a super block
> or remount it ro.
>
> Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Al Viro <viro@ZenIV.linux.org.uk>
> Reviewed-by: David Sterba <dsterba@suse.cz>
> ---
> Changelog:
> v4:
>    Newly introduced.
> v5:
>    Change name to sb_want_write() and receive sb and parameter.
> v6:
>    Add better check when umounting the last instance of a super block. So
>    sb_want_write() waiting for fs unfrozen/transaction will prevent
>    umount.
> v7:
>    Use atomic instead of manually implemented rw-sem.
>    Add check for remount ro.
>    Fix some missing unlock in error handler.
>    Add internal helper function instead open-code.
> ---
>   fs/internal.h         | 25 ++++++++++++++++++
>   fs/namespace.c        | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/super.c            | 15 ++++++++++-
>   include/linux/fs.h    |  6 +++++
>   include/linux/mount.h |  2 ++
>   5 files changed, 117 insertions(+), 1 deletion(-)
>
> diff --git a/fs/internal.h b/fs/internal.h
> index e9a61fe..8d6ef11 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -69,6 +69,31 @@ extern int __mnt_want_write_file(struct file *);
>   extern void __mnt_drop_write(struct vfsmount *);
>   extern void __mnt_drop_write_file(struct file *);
>
> +/* rw_sem like read/write down trylock helpers for sb_want_write() */
> +static inline int __sb_read_down_trylock(struct super_block *sb)
> +{
> +	if (!atomic_add_unless(&sb->s_want_write_count, 1, -1))
> +		return 0;
> +	return 1;
> +}
> +
> +static inline int __sb_write_down_trylock(struct super_block *sb)
> +{
> +	if (atomic_cmpxchg(&sb->s_want_write_count, 0, -1))
> +		return 0;
> +	return 1;
> +}
> +
> +static inline void __sb_read_up(struct super_block *sb)
> +{
> +	atomic_dec(&sb->s_want_write_count);
> +}
> +
> +static inline void __sb_write_up(struct super_block *sb)
> +{
> +	atomic_set(&sb->s_want_write_count, 0);
> +}
> +
>   /*
>    * fs_struct.c
>    */
> diff --git a/fs/namespace.c b/fs/namespace.c
> index cd1e968..a4e8946 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1105,6 +1105,47 @@ struct vfsmount *mntget(struct vfsmount *mnt)
>   }
>   EXPORT_SYMBOL(mntget);
>
> +/**
> + * sb_want_write - get write acess to a super block
> + * @sb: the superblock of the filesystem
> + *
> + * This tells the low-level filesystem that a write is about to be performed to
> + * it, and makes sure that the writes are allowed (superblock is read-write,
> + * filesystem is not frozen) before returning success.
> + * When the write operation is finished, sb_drop_write() must be called.
> + * This is much like mnt_want_write() as a refcount, but only needs
> + * the superblock to be read-write.
> + */
> +int sb_want_write(struct super_block *sb)
> +{
> +
> +	if (!__sb_read_down_trylock(sb))
> +		return -EBUSY;
> +
> +	sb_start_write(sb);
> +	if (sb->s_readonly_remount || sb->s_flags & MS_RDONLY) {
> +		sb_drop_write(sb);
> +		return -EROFS;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(sb_want_write);
> +
> +/**
> + * sb_drop_write - give up write acess to a super block
> + * @sb: the superblock on which to give up write access
> + *
> + * Tells the low-level filesystem that we are done performing writes to it and
> + * also allows filesystem to be frozen/remount ro again. Must be matched with
> + * sb_want_write() call above.
> + */
> +void sb_drop_write(struct super_block *sb)
> +{
> +	sb_end_write(sb);
> +	__sb_read_up(sb);
> +}
> +EXPORT_SYMBOL(sb_drop_write);
> +
>   struct vfsmount *mnt_clone_internal(struct path *path)
>   {
>   	struct mount *p;
> @@ -1382,6 +1423,9 @@ static void shrink_submounts(struct mount *mnt);
>   static int do_umount(struct mount *mnt, int flags)
>   {
>   	struct super_block *sb = mnt->mnt.mnt_sb;
> +	struct mount *tmp;
> +	int mounts = 0;
> +	int sb_write_hold = 0;
>   	int retval;
>
>   	retval = security_sb_umount(&mnt->mnt, flags);
> @@ -1455,6 +1499,25 @@ static int do_umount(struct mount *mnt, int flags)
>   	lock_mount_hash();
>   	event++;
>
> +	/*
> +	 * Check for blocking sb_want_write if the mount is the last mount
> +	 * instance of the superblock (+1 for namespace mount), and block
> +	 * further comming sb_want_write().
> +	 */
> +	list_for_each_entry(tmp, &sb->s_mounts, mnt_instance) {
> +		mounts++;
> +		if (mounts > 2)
> +			break;
> +	}
> +
> +	if (mounts == 2) {
> +		if (!__sb_write_down_trylock(sb)) {
> +			retval = -EBUSY;
> +			goto out;
> +		}
> +		sb_write_hold = 1;
> +	}
> +
>   	if (flags & MNT_DETACH) {
>   		if (!list_empty(&mnt->mnt_list))
>   			umount_tree(mnt, 2);
> @@ -1468,6 +1531,13 @@ static int do_umount(struct mount *mnt, int flags)
>   			retval = 0;
>   		}
>   	}
> +out:
> +	/*
> +	 * Only unblock sb_want_write() if umount of last instance failed
> +	 * If umount succeeded, no need to unblock and let it die with sb.
> +	 */
> +	if (sb_write_hold && retval)
> +		__sb_write_up(sb);
>   	unlock_mount_hash();
>   	namespace_unlock();
>   	return retval;
> diff --git a/fs/super.c b/fs/super.c
> index eae088f..10f49e4 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -230,6 +230,9 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
>   	s->s_shrink.count_objects = super_cache_count;
>   	s->s_shrink.batch = 1024;
>   	s->s_shrink.flags = SHRINKER_NUMA_AWARE;
> +
> +	atomic_set(&s->s_want_write_count, 0);
> +
>   	return s;
>
>   fail:
> @@ -694,6 +697,7 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>   {
>   	int retval;
>   	int remount_ro;
> +	int sb_write_hold = 0;
>
>   	if (sb->s_writers.frozen != SB_UNFROZEN)
>   		return -EBUSY;
> @@ -716,6 +720,10 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>   				return -EBUSY;
>   			remount_ro = (flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY);
>   		}
> +		/* Don't remount ro if there is sb_want_write() waiting */
> +		if (!__sb_write_down_trylock(sb))
> +			return -EBUSY;
> +		sb_write_hold = 1;
>   	}
>   	shrink_dcache_sb(sb);
>
> @@ -728,7 +736,7 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>   		} else {
>   			retval = sb_prepare_remount_readonly(sb);
>   			if (retval)
> -				return retval;
> +				goto cancel_readonly;
>   		}
>   	}
>
> @@ -757,10 +765,15 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>   	 */
>   	if (remount_ro && sb->s_bdev)
>   		invalidate_bdev(sb->s_bdev);
> +	if (sb_write_hold)
> +		__sb_write_up(sb);
> +
>   	return 0;
>
>   cancel_readonly:
>   	sb->s_readonly_remount = 0;
> +	if (sb_write_hold)
> +		__sb_write_up(sb);
>   	return retval;
>   }
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 42efe13..dc852e8 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1305,6 +1305,12 @@ struct super_block {
>   	 * Indicates how deep in a filesystem stack this SB is
>   	 */
>   	int s_stack_depth;
> +
> +	/*
> +	 * sb_want_write() protector, to ensure remount ro or umount the last
> +	 * instance to return -EBUSY if there is sb_want_write() waiting.
> +	 */
> +	atomic_t		s_want_write_count;
>   };
>
>   extern struct timespec current_fs_time(struct super_block *sb);
> diff --git a/include/linux/mount.h b/include/linux/mount.h
> index c2c561d..abf4495 100644
> --- a/include/linux/mount.h
> +++ b/include/linux/mount.h
> @@ -74,8 +74,10 @@ struct path;
>   extern int mnt_want_write(struct vfsmount *mnt);
>   extern int mnt_want_write_file(struct file *file);
>   extern int mnt_clone_write(struct vfsmount *mnt);
> +extern int sb_want_write(struct super_block *sb);
>   extern void mnt_drop_write(struct vfsmount *mnt);
>   extern void mnt_drop_write_file(struct file *file);
> +extern void sb_drop_write(struct super_block *sb);
>   extern void mntput(struct vfsmount *mnt);
>   extern struct vfsmount *mntget(struct vfsmount *mnt);
>   extern struct vfsmount *mnt_clone_internal(struct path *path);
>
