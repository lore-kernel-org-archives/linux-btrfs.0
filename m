Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22E1379C40
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 10:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784025047; cv=none; b=eUatFjmQAoNj67Ny8fAHcZyMre1K0iojUT8qsDcjROmtgHRSYQO7oY50R+qAedgxpssVX7kaSlCLREzMdN1FgAerXyL4ZGwHBDHx8UdAY78ZrUbYnzEd+oPW7IO3PQCOlR31IlgB9r4e/3tuwke2s/ySWeEbkzHG9Woy0HBCiCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784025047; c=relaxed/simple;
	bh=nGGOrnqC0jcXHJABX4Cm8xnYoClXFAoN2I+5rxnsrhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mv454RVSwBVeTxDpOoxHhYknYqByrhX7f2NZkNf0FuD8Jql+Q0FyViyf1dd445Gwwn0hdtaLBB/0K3l856xM29S7cNyZEScdYx7xyFguiTuK3gxfpSCfpC6zVAWMiAByVc1QYOLjOnG6rLRtlKHS87w717ApY87XzGGxFYigqZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NrRZwAon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NrRZwAon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B32B1F00A3A
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 10:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784025045;
	bh=tMR+swVJ2TKugWM8zXy99yc9w4clyBcBDFeC+23xEbg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NrRZwAonKwIFppxU8Fn456gnWIhXTK/G4RAeDGwRYhIkAjE0aMweImShYcjMAWZ1F
	 1obyH645DgfeS/os/gjszNEPQf/2vqI6a3o0Frt98ESOaINTSc0oyDrg9LSJXiDDyG
	 GfuBfoL6m306O5CUSGl+toMLtRG4ujmWGiD7CctXd3RxmeePf/AxW4Lfb/guAPJLGr
	 9sumFZVqwwdeUI9mme7Lb23s4RmYgtrzHb4AsTXlPKYq8O1abcrM8VJ5JekEPDtmAz
	 Yj2fx+1IUqvp5mKcRgZRyIop39VEZsG+NBxChz2kIksBVo7TNLVHgvNGmewIcBHhC2
	 m9+5SINzHav3Q==
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-738a5cc517eso763069137.2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 03:30:45 -0700 (PDT)
X-Gm-Message-State: AOJu0YwPzQLpz8uWNs+VJUyY6AitW5vkH3xkrf2iiySv7jVq9CT/W6ac
	gx5aXy5p+MnjVQHA6i2BYYPlaFFO+K3WFqX8+lvuJC5I0CygVAZr2BmuKyetwnOcYahqjC/TI1D
	i3cpyw3Ki2kUkpCXm8K6PunD+5G9Rwak=
X-Received: by 2002:a05:6102:5a9a:b0:727:fb8:f269 with SMTP id
 ada2fe7eead31-74533e17c26mr8108945137.22.1784025044622; Tue, 14 Jul 2026
 03:30:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <56200caf69e60463157fd4a49cf805802536bb6e.1783980768.git.wqu@suse.com>
In-Reply-To: <56200caf69e60463157fd4a49cf805802536bb6e.1783980768.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 14 Jul 2026 11:30:07 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4nQgtxv+zF3O-=F+3uHJojyH8_E6MxQgtcaZXX3yvXLQ@mail.gmail.com>
X-Gm-Features: AUfX_mzfkKHRmfznphIf9c1hqZVbOBHuTfFD0Y4X2R2vBN9GKqZmPRiv3S0c27g
Message-ID: <CAL3q7H4nQgtxv+zF3O-=F+3uHJojyH8_E6MxQgtcaZXX3yvXLQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix a lockdep caused by path resolution during
 device scan
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 11:14=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> [BUG]
> There is a lockdep report related to device scan:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> 7.2.0-20260712.rc2.git0.e3321fa3034d.300.fc44.s390x+debug #1 Not tainted
> ------------------------------------------------------
> (udev-worker)/1653 is trying to acquire lock:
> 0000006919232220 (&type->i_mutex_dir_key#2){++++}-{3:3}, at: lookup_slow+=
0x3e/0x70
> but task is already holding lock:
> 00000069238564d8 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: device_li=
st_add.constprop.0+0x148/0xc60
> which lock already depends on the new lock.
> the existing dependency chain (in reverse order) is:
> -> #5 (&fs_devs->device_list_mutex){+.+.}-{3:3}:
>        lock_acquire+0x150/0x3f0
>        __mutex_lock+0xba/0xdc0
>        mutex_lock_nested+0x32/0x40
>        write_all_supers+0x7a/0x670
>        btrfs_sync_log+0xae6/0xdd0
>        btrfs_sync_file+0x4fa/0x7a0
>        __s390x_sys_fsync+0x52/0xa0
>        __do_syscall+0x172/0x750
>        system_call+0x72/0x90
> -> #4 (&fs_info->tree_log_mutex){+.+.}-{3:3}:
>        lock_acquire+0x150/0x3f0
>        __mutex_lock+0xba/0xdc0
>        mutex_lock_nested+0x32/0x40
>        btrfs_sync_log+0xaba/0xdd0
>        btrfs_sync_file+0x4fa/0x7a0
>        __s390x_sys_fsync+0x52/0xa0
>        __do_syscall+0x172/0x750
>        system_call+0x72/0x90
> -> #3 (btrfs_trans_num_extwriters){.+.+}-{0:0}:
>        lock_acquire+0x150/0x3f0
>        join_transaction+0x108/0x680
>        start_transaction+0x21a/0x660
>        btrfs_join_transaction+0x32/0x40
>        btrfs_dirty_inode+0x52/0xf0
>        touch_atime+0x90/0xc0
>        filemap_read+0x446/0x450
>        vfs_read+0x208/0x370
>        ksys_read+0x88/0x120
>        __do_syscall+0x172/0x750
>        system_call+0x72/0x90
> -> #2 (btrfs_trans_num_writers){.+.+}-{0:0}:
>        reacquire_held_locks+0x14c/0x240
>        __lock_release.isra.0+0xd8/0x380
>        lock_release+0xf6/0x270
>        percpu_up_read+0x28/0xf0
>        __btrfs_end_transaction+0x178/0x1f0
>        btrfs_dirty_inode+0x82/0xf0
>        touch_atime+0x90/0xc0
>        btrfs_file_mmap_prepare+0x8c/0xa0
>        __mmap_region+0x214/0x780
>        mmap_region+0x108/0x160
>        do_mmap+0x402/0x5a0
>        vm_mmap_pgoff+0x156/0x230
>        ksys_mmap_pgoff+0x17e/0x220
>        __s390x_sys_old_mmap+0xa8/0x140
>        __do_syscall+0x172/0x750
>        system_call+0x72/0x90
> -> #1 (&mm->mmap_lock){++++}-{3:3}:
>        lock_acquire+0x150/0x3f0
>        __might_fault+0x7a/0xa0
>        filldir64+0x11c/0x210
>        offset_readdir+0x92/0x200
>        iterate_dir+0xcc/0x2d0
>        __do_sys_getdents64+0x7a/0x130
>        __do_syscall+0x172/0x750
>        system_call+0x72/0x90
> -> #0 (&type->i_mutex_dir_key#2){++++}-{3:3}:
>        check_prev_add+0x160/0xf40
>        __lock_acquire+0x12aa/0x15a0
>        lock_acquire+0x150/0x3f0
>        down_read+0x5a/0x280
>        lookup_slow+0x3e/0x70
>        path_lookupat+0x1f0/0x370
>        filename_lookup+0xce/0x1f0
>        kern_path+0x48/0x70
>        is_same_device+0x146/0x300
>        device_list_add.constprop.0+0x1be/0xc60
>        btrfs_scan_one_device+0x13a/0x2f0
>        btrfs_control_ioctl+0x110/0x1e0
>        __s390x_sys_ioctl+0xfa/0x130
>        __do_syscall+0x172/0x750
>        system_call+0x72/0x90
> other info that might help us debug this:
> Chain exists of:
>   &type->i_mutex_dir_key#2 --> &fs_info->tree_log_mutex --> &fs_devs->dev=
ice_list_mutex
>  Possible unsafe locking scenario:
>        CPU0                    CPU1
>        ----                    ----
>   lock(&fs_devs->device_list_mutex);
>                                lock(&fs_info->tree_log_mutex);
>                                lock(&fs_devs->device_list_mutex);
>   rlock(&type->i_mutex_dir_key#2);
>  *** DEADLOCK ***
> 2 locks held by (udev-worker)/1653:
>  #0: 0000016c727051c8 (uuid_mutex){+.+.}-{3:3}, at: btrfs_control_ioctl+0=
x102/0x1e0
>  #1: 00000069238564d8 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: devi=
ce_list_add.constprop.0+0x148/0xc60
> stack backtrace:
> CPU: 2 UID: 0 PID: 1653 Comm: (udev-worker) Not tainted 7.2.0-20260712.rc=
2.git0.e3321fa3034d.300.fc44.s390x+debug #1 PREEMPT
> Hardware name: IBM 3931 A01 701 (LPAR)
> Call Trace:
>  [<0000016c70680e3e>] dump_stack_lvl+0xae/0x108
>  [<0000016c7078aa44>] print_circular_bug+0x1a4/0x230
>  [<0000016c7078ac5c>] check_noncircular+0x18c/0x1b0
>  [<0000016c7078c030>] check_prev_add+0x160/0xf40
>  [<0000016c7078fbaa>] __lock_acquire+0x12aa/0x15a0
>  [<0000016c7078fff0>] lock_acquire+0x150/0x3f0
>  [<0000016c7180e2fa>] down_read+0x5a/0x280
>  [<0000016c70b88dde>] lookup_slow+0x3e/0x70
>  [<0000016c70b8f5d0>] path_lookupat+0x1f0/0x370
>  [<0000016c70b900ae>] filename_lookup+0xce/0x1f0
>  [<0000016c70b90218>] kern_path+0x48/0x70
>  [<0000016c70f5b4a6>] is_same_device+0x146/0x300
>  [<0000016c70f67cfe>] device_list_add.constprop.0+0x1be/0xc60
>  [<0000016c70f688da>] btrfs_scan_one_device+0x13a/0x2f0
>  [<0000016c70ed9cb0>] btrfs_control_ioctl+0x110/0x1e0
>  [<0000016c70b97d0a>] __s390x_sys_ioctl+0xfa/0x130
>  [<0000016c718004d2>] __do_syscall+0x172/0x750
>  [<0000016c718155d2>] system_call+0x72/0x90
>
> [CAUSE]
> Btrfs device scan will call is_same_device() with device_list_mutex
> held. But is_same_device() will call kern_path() which will do path
> resolution and lock the directory inode.
>
> This path resolution with device_list_mutex held will cause lock
> sequence to be reversed, as other call sites can lock an inode for fsync(=
),
> then then commit the transaction, which later locks device_list_mutex to
> write back super blocks.

I find this last paragraph very confusing, if not inaccurate:

1 - "other call sites can lock an inode for fsync" - what do you mean?
It's the fsync code, btrfs_sync_file(), that locks the inode (vfs
rwsem plus btrfs' mmap rwsem).

2 - "then commit the transaction" - what do you mean? Which call sites
invoke both fsync and commit a transaction?
Or are you referring to fsync committing a transaction? That happens
after it unlocks the inode, but none of the stack traces reflect that
case, there's no fsync falling back to a transaction commit there.
I think you mean that when fsync commits super blocks (part of the
standard log sync), by calling write_all_supers(), we lock
device_list_mutex.

Thanks.

>
> [FIX]
> Instead of a full path lookup, use dev_t to determine if two device
> paths are pointing to the same block device.
>
> Inside kernel dev_t is going to uniquely determine a block device, and
> the device path lookup is already done by lookup_bdev(), which is done
> without device_list_mutex held, thus no reversed locking sequence.
>
> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Link: https://lore.kernel.org/linux-btrfs/5a9d9847-4ae6-43c4-afdc-6e5fa51=
d6117@linux.ibm.com/
> Fixes: 2e8b6bc0ab41 ("btrfs: avoid unnecessary device path update for the=
 same device")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/volumes.c | 37 +------------------------------------
>  1 file changed, 1 insertion(+), 36 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6b1a98c6d46e..a8e27db8e4bc 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -740,41 +740,6 @@ const u8 *btrfs_sb_fsid_ptr(const struct btrfs_super=
_block *sb)
>         return has_metadata_uuid ? sb->metadata_uuid : sb->fsid;
>  }
>
> -static bool is_same_device(struct btrfs_device *device, const char *new_=
path)
> -{
> -       struct path old =3D { .mnt =3D NULL, .dentry =3D NULL };
> -       struct path new =3D { .mnt =3D NULL, .dentry =3D NULL };
> -       char AUTO_KFREE(old_path);
> -       bool is_same =3D false;
> -       int ret;
> -
> -       if (!device->name)
> -               goto out;
> -
> -       old_path =3D kzalloc(PATH_MAX, GFP_NOFS);
> -       if (!old_path)
> -               goto out;
> -
> -       rcu_read_lock();
> -       ret =3D strscpy(old_path, rcu_dereference(device->name), PATH_MAX=
);
> -       rcu_read_unlock();
> -       if (ret < 0)
> -               goto out;
> -
> -       ret =3D kern_path(old_path, LOOKUP_FOLLOW, &old);
> -       if (ret)
> -               goto out;
> -       ret =3D kern_path(new_path, LOOKUP_FOLLOW, &new);
> -       if (ret)
> -               goto out;
> -       if (path_equal(&old, &new))
> -               is_same =3D true;
> -out:
> -       path_put(&old);
> -       path_put(&new);
> -       return is_same;
> -}
> -
>  /*
>   * Add new device to list of registered devices
>   *
> @@ -895,7 +860,7 @@ static noinline struct btrfs_device *device_list_add(=
const char *path,
>                                 MAJOR(path_devt), MINOR(path_devt),
>                                 current->comm, task_pid_nr(current));
>
> -       } else if (!device->name || !is_same_device(device, path)) {
> +       } else if (!device->name || device->devt !=3D path_devt) {
>                 const char *old_name;
>
>                 /*
> --
> 2.54.0
>
>
