From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: forced readonly mounts on errors
Date: Mon, 17 Jan 2011 14:56:53 -0500
Message-ID: <1295293927-sup-5879@think>
References: <4D24160C.6070900@cn.fujitsu.com> <4D252E42.5060803@cn.fujitsu.com> <4D258BC7.8040105@cn.fujitsu.com> <4D25A7D1.7050602@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D25A7D1.7050602@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from liubo's message of 2011-01-06 06:30:25 -0500:
> 
> This patch comes from "Forced readonly mounts on errors" ideas.
> 
> As we know, this is the first step in being more fault tolerant of disk
> corruptions instead of just using BUG() statements.
> 
> The major content:
> - add a framework for generating errors that should result in filesystems
>   going readonly.
> - keep FS state in disk super block.
> - make sure that all of resource will be freed and released at umount time.
> - make sure that after FS is forced readonly on error, there will be no more
>   disk change before FS is corrected. For this, we should stop write operation.
> 
> After this patch is applied, the conversion from BUG() to such a framework can
> happen incrementally.

I think this is a good overall framework and it will meet our needs
nicely as we scale up the error handling in the filesystem.

One concern I have is where we save the error state to disk:

> +static void __save_error_info(struct btrfs_fs_info *fs_info)
> +{
> +    struct btrfs_super_block *disk_super = &fs_info->super_copy;
> +
> +    fs_info->fs_state = BTRFS_SUPER_FLAG_ERROR;
> +    disk_super->flags |= cpu_to_le64(BTRFS_SUPER_FLAG_ERROR);
> +
> +    mutex_lock(&fs_info->trans_mutex);
> +    memcpy(&fs_info->super_for_commit, disk_super,
> +           sizeof(fs_info->super_for_commit));
> +    mutex_unlock(&fs_info->trans_mutex);

The super_for_commit isn't changed until we have a fully consistent set
of fields in the super block.  The super_copy is changed as the
transaction progresses.

So, this memcpy isn't quite safe.  We should simply set the flag on the
super_for_commit and the super_copy individually.

I'll make this change and pull it in.  We can build from here.

-chris
