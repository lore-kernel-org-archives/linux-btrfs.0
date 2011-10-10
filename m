From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs root + mount subvolid=0 problem
Date: Mon, 10 Oct 2011 19:09:44 +0700
Message-ID: <CAG1y0sdtMQTxj_wvjPCqVmajw19mRgjKQugSc6By2QX3PktNRQ@mail.gmail.com>
References: <CAG1y0scXmy=DAGisOh9_6=LzueBhM5VMxpPWGeNPc+iOEc3scA@mail.gmail.com>
	<20111010102028.GD17912@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111010102028.GD17912@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 10, 2011 at 5:20 PM, David Sterba <dave@jikos.cz> wrote:
> On Mon, Oct 10, 2011 at 02:30:30PM +0700, Fajar A. Nugraha wrote:
>> This happens both with natty's 2.6.38-11-generic and kernel 3.0.4
>> (backported from oneiric). Does anyone know if this is a know problem,
>> or how to get further information to fix this?
>
> I'm afraid with the kernels that old, nobody will try to fix it unless
> you reproduce it on the most recent kernels.

3.0.4 is considered old already? Wow, 3.1 is not even out yet

I'll retry with 3.1-rc9 then.

>
> Do you see any relevant messages in the log before/while the ls is
> stuck?

Nope

> I'd be good to know where excatly the ls is stuck by 'cat
> /proc/<lspid>/stack', and if it's in D state, possibly gethering stacks
> of all such processes.

cpu usage of the ls process is 96-99%

The good news is that it seems to be doing something (the stack
changes somewhat). The bad news is that it seems stuck in a loop. This
is on kernel 3.0.4

$ for n in `seq 1 10`;do echo "=============================";sudo cat
/proc/9354/stack;done
=============================
[<c1041ebb>] __cond_resched+0x1b/0x30
[<c113b3f9>] iget5_locked+0x79/0x1a0
[<f8572ccc>] btrfs_iget+0x3c/0x4a0 [btrfs]
[<f8573278>] btrfs_orphan_cleanup+0x148/0x320 [btrfs]
[<f8573757>] btrfs_lookup_dentry+0x307/0x4a0 [btrfs]
[<f8573900>] btrfs_lookup+0x10/0x30 [btrfs]
[<c112cf27>] d_alloc_and_lookup+0x37/0x70
[<c112eb89>] do_lookup+0x279/0x2f0
[<c112f977>] path_lookupat+0x107/0x5e0
[<c112fe7c>] do_path_lookup+0x2c/0xb0
[<c11302b3>] user_path_at+0x43/0x80
[<c1128165>] vfs_fstatat+0x55/0xa0
[<c11281d0>] vfs_lstat+0x20/0x30
[<c11285a6>] sys_lstat64+0x16/0x30
[<c150b3e4>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff
=============================
[<c1041ebb>] __cond_resched+0x1b/0x30
[<c113b3f9>] iget5_locked+0x79/0x1a0
[<f8572ccc>] btrfs_iget+0x3c/0x4a0 [btrfs]
[<f8573278>] btrfs_orphan_cleanup+0x148/0x320 [btrfs]
[<f8573757>] btrfs_lookup_dentry+0x307/0x4a0 [btrfs]
[<f8573900>] btrfs_lookup+0x10/0x30 [btrfs]
[<c112cf27>] d_alloc_and_lookup+0x37/0x70
[<c112eb89>] do_lookup+0x279/0x2f0
[<c112f977>] path_lookupat+0x107/0x5e0
[<c112fe7c>] do_path_lookup+0x2c/0xb0
[<c11302b3>] user_path_at+0x43/0x80
[<c1128165>] vfs_fstatat+0x55/0xa0
[<c11281d0>] vfs_lstat+0x20/0x30
[<c11285a6>] sys_lstat64+0x16/0x30
[<c150b3e4>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff
=============================
[<f8545273>] generic_bin_search.clone.39+0x1b3/0x210 [btrfs]
[<c102cf7e>] kmap_atomic_prot+0xde/0x100
[<ffffffff>] 0xffffffff
=============================
[<f8545273>] generic_bin_search.clone.39+0x1b3/0x210 [btrfs]
[<f854617a>] bin_search+0x4a/0x90 [btrfs]
[<f854ac44>] btrfs_search_slot+0x104/0x5c0 [btrfs]
[<f85731c7>] btrfs_orphan_cleanup+0x97/0x320 [btrfs]
[<f8573757>] btrfs_lookup_dentry+0x307/0x4a0 [btrfs]
[<f8573900>] btrfs_lookup+0x10/0x30 [btrfs]
[<c112cf27>] d_alloc_and_lookup+0x37/0x70
[<c112eb89>] do_lookup+0x279/0x2f0
[<c112f977>] path_lookupat+0x107/0x5e0
[<c112fe7c>] do_path_lookup+0x2c/0xb0
[<c11302b3>] user_path_at+0x43/0x80
[<c1128165>] vfs_fstatat+0x55/0xa0
[<c11281d0>] vfs_lstat+0x20/0x30
[<c11285a6>] sys_lstat64+0x16/0x30
[<c150b3e4>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff
=============================
[<ffffffff>] 0xffffffff
=============================
[<f8545222>] generic_bin_search.clone.39+0x162/0x210 [btrfs]
[<f854617a>] bin_search+0x4a/0x90 [btrfs]
[<f854accc>] btrfs_search_slot+0x18c/0x5c0 [btrfs]
[<f85731c7>] btrfs_orphan_cleanup+0x97/0x320 [btrfs]
[<f8573757>] btrfs_lookup_dentry+0x307/0x4a0 [btrfs]
[<f8573900>] btrfs_lookup+0x10/0x30 [btrfs]
[<c112cf27>] d_alloc_and_lookup+0x37/0x70
[<c112eb89>] do_lookup+0x279/0x2f0
[<c112f977>] path_lookupat+0x107/0x5e0
[<c112fe7c>] do_path_lookup+0x2c/0xb0
[<c11302b3>] user_path_at+0x43/0x80
[<c1128165>] vfs_fstatat+0x55/0xa0
[<c11281d0>] vfs_lstat+0x20/0x30
[<c11285a6>] sys_lstat64+0x16/0x30
[<c150b3e4>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff
=============================
[<c1041ebb>] __cond_resched+0x1b/0x30
[<c113b3f9>] iget5_locked+0x79/0x1a0
[<f8572ccc>] btrfs_iget+0x3c/0x4a0 [btrfs]
[<f8573278>] btrfs_orphan_cleanup+0x148/0x320 [btrfs]
[<f8573757>] btrfs_lookup_dentry+0x307/0x4a0 [btrfs]
[<f8573900>] btrfs_lookup+0x10/0x30 [btrfs]
[<c112cf27>] d_alloc_and_lookup+0x37/0x70
[<c112eb89>] do_lookup+0x279/0x2f0
[<c112f977>] path_lookupat+0x107/0x5e0
[<c112fe7c>] do_path_lookup+0x2c/0xb0
[<c11302b3>] user_path_at+0x43/0x80
[<c1128165>] vfs_fstatat+0x55/0xa0
[<c11281d0>] vfs_lstat+0x20/0x30
[<c11285a6>] sys_lstat64+0x16/0x30
[<c150b3e4>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff
=============================
[<c1041ebb>] __cond_resched+0x1b/0x30
[<c113b3f9>] iget5_locked+0x79/0x1a0
[<f8572ccc>] btrfs_iget+0x3c/0x4a0 [btrfs]
[<f8573278>] btrfs_orphan_cleanup+0x148/0x320 [btrfs]
[<f8573757>] btrfs_lookup_dentry+0x307/0x4a0 [btrfs]
[<f8573900>] btrfs_lookup+0x10/0x30 [btrfs]
[<c112cf27>] d_alloc_and_lookup+0x37/0x70
[<c112eb89>] do_lookup+0x279/0x2f0
[<c112f977>] path_lookupat+0x107/0x5e0
[<c112fe7c>] do_path_lookup+0x2c/0xb0
[<c11302b3>] user_path_at+0x43/0x80
[<c1128165>] vfs_fstatat+0x55/0xa0
[<c11281d0>] vfs_lstat+0x20/0x30
[<c11285a6>] sys_lstat64+0x16/0x30
[<c150b3e4>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff
=============================
[<c1041ebb>] __cond_resched+0x1b/0x30
[<c113b3f9>] iget5_locked+0x79/0x1a0
[<f8572ccc>] btrfs_iget+0x3c/0x4a0 [btrfs]
[<f8573278>] btrfs_orphan_cleanup+0x148/0x320 [btrfs]
[<f8573757>] btrfs_lookup_dentry+0x307/0x4a0 [btrfs]
[<f8573900>] btrfs_lookup+0x10/0x30 [btrfs]
[<c112cf27>] d_alloc_and_lookup+0x37/0x70
[<c112eb89>] do_lookup+0x279/0x2f0
[<c112f977>] path_lookupat+0x107/0x5e0
[<c112fe7c>] do_path_lookup+0x2c/0xb0
[<c11302b3>] user_path_at+0x43/0x80
[<c1128165>] vfs_fstatat+0x55/0xa0
[<c11281d0>] vfs_lstat+0x20/0x30
[<c11285a6>] sys_lstat64+0x16/0x30
[<c150b3e4>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff
=============================
[<f8545273>] generic_bin_search.clone.39+0x1b3/0x210 [btrfs]
[<ffffffff>] 0xffffffff


>
> I have seen problems with mounting subvolumes when there is a
> non-toplevel one set as deafult, but this was more related to the
> 'subvol' option, subvolid does not suffer from this.

I didn't change the default subvol. The root subvol was explicitly
selected with subvolid option, both in fstab and grub.cfg.

-- 
Fajar
