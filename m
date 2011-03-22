From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V4] btrfs: implement delayed inode items operation
Date: Tue, 22 Mar 2011 11:12:37 +0800
Message-ID: <4D8813A5.1040604@cn.fujitsu.com>
References: <4D8324DE.4010400@cn.fujitsu.com> <20110322113310.50eaceb2.kitayama@cl.bb4u.ne.jp>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	David Sterba <dave@jikos.cz>, Ito <t-itoh@jp.fujitsu.com>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110322113310.50eaceb2.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 22 Mar 2011 11:33:10 +0900, Itaru Kitayama wrote:
> Here is an excerpt of the V4 patch applied kernel boot log:
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.36-xie+ #117
> -------------------------------------------------------
> vgs/1210 is trying to acquire lock:
>  (&delayed_node->mutex){+.+...}, at: [<ffffffff8121184b>] btrfs_delayed_update_inode+0x45/0x101
> 
> but task is already holding lock:
>  (&mm->mmap_sem){++++++}, at: [<ffffffff810f6512>] sys_mmap_pgoff+0xd6/0x12e
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&mm->mmap_sem){++++++}:
>        [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>        [<ffffffff810edc79>] might_fault+0x95/0xb8
>        [<ffffffff8112b5ce>] filldir+0x75/0xd0
>        [<ffffffff811d77f8>] btrfs_real_readdir+0x3d7/0x528
>        [<ffffffff8112b75c>] vfs_readdir+0x79/0xb6
>        [<ffffffff8112b8e9>] sys_getdents+0x85/0xd8
>        [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
> 
> -> #0 (&delayed_node->mutex){+.+...}:
>        [<ffffffff81076612>] __lock_acquire+0xa98/0xda6
>        [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>        [<ffffffff814c38b1>] __mutex_lock_common+0x5a/0x444
>        [<ffffffff814c3d50>] mutex_lock_nested+0x39/0x3e
>        [<ffffffff8121184b>] btrfs_delayed_update_inode+0x45/0x101
>        [<ffffffff811dbd4f>] btrfs_update_inode+0x2e/0x129
>        [<ffffffff811de008>] btrfs_dirty_inode+0x57/0x113
>        [<ffffffff8113c2a5>] __mark_inode_dirty+0x33/0x1aa
>        [<ffffffff81130939>] touch_atime+0x107/0x12a
>        [<ffffffff811e15b2>] btrfs_file_mmap+0x3e/0x57
>        [<ffffffff810f5f40>] mmap_region+0x2bb/0x4c4
>        [<ffffffff810f63d9>] do_mmap_pgoff+0x290/0x2f3
>        [<ffffffff810f6532>] sys_mmap_pgoff+0xf6/0x12e
>        [<ffffffff81006e9a>] sys_mmap+0x22/0x24
>        [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
> 
> other info that might help us debug this:
> 
> 1 lock held by vgs/1210:
>  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff810f6512>] sys_mmap_pgoff+0xd6/0x12e
> 
> stack backtrace:
> Pid: 1210, comm: vgs Not tainted 2.6.36-xie+ #117
> Call Trace:
>  [<ffffffff81074c15>] print_circular_bug+0xaf/0xbd
>  [<ffffffff81076612>] __lock_acquire+0xa98/0xda6
>  [<ffffffff8121184b>] ? btrfs_delayed_update_inode+0x45/0x101
>  [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>  [<ffffffff8121184b>] ? btrfs_delayed_update_inode+0x45/0x101
>  [<ffffffff8121184b>] ? btrfs_delayed_update_inode+0x45/0x101
>  [<ffffffff814c38b1>] __mutex_lock_common+0x5a/0x444
>  [<ffffffff8121184b>] ? btrfs_delayed_update_inode+0x45/0x101
>  [<ffffffff8107162f>] ? debug_mutex_init+0x31/0x3c
>  [<ffffffff814c3d50>] mutex_lock_nested+0x39/0x3e
>  [<ffffffff8121184b>] btrfs_delayed_update_inode+0x45/0x101
>  [<ffffffff814c36c6>] ? __mutex_unlock_slowpath+0x129/0x13a
>  [<ffffffff811dbd4f>] btrfs_update_inode+0x2e/0x129
>  [<ffffffff811de008>] btrfs_dirty_inode+0x57/0x113
>  [<ffffffff8113c2a5>] __mark_inode_dirty+0x33/0x1aa
>  [<ffffffff81130939>] touch_atime+0x107/0x12a
>  [<ffffffff811e15b2>] btrfs_file_mmap+0x3e/0x57
>  [<ffffffff810f5f40>] mmap_region+0x2bb/0x4c4
>  [<ffffffff81229f10>] ? file_map_prot_check+0x9a/0xa3
>  [<ffffffff810f63d9>] do_mmap_pgoff+0x290/0x2f3
>  [<ffffffff810f6512>] ? sys_mmap_pgoff+0xd6/0x12e
>  [<ffffffff810f6532>] sys_mmap_pgoff+0xf6/0x12e
>  [<ffffffff814c4b75>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff81006e9a>] sys_mmap+0x22/0x24
>  [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
> 
> As the corresponding delayed node mutex lock is taken in btrfs_real_readdir, that seems deadlockable.
> vfs_readdir holds i_mutex, I wonder if we can execute btrfs_readdir_delayed_dir_index without
> taking the node lock. 

We can't fix it by this way, because the work threads may do insertion or deletion at the same time,
and we may lose some directory items.

Maybe we can fix it by adding a reference for the delayed directory items, we can do read dir just
like this:
1. hold the node lock
2. increase the directory items' reference and put all the directory items into a list
3. release the node lock
4. read dir
5. decrease the directory items' reference and free them if the reference is zero.
What do you think about?

Thanks
Miao

> 
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

