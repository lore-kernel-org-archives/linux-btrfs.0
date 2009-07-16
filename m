From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BtrFS Hangs.
Date: Thu, 16 Jul 2009 07:47:30 -0400
Message-ID: <20090716114730.GB3883@think>
References: <4A5F1104.2070509@rambler.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Michael Raskin <a0091f122@rambler.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A5F1104.2070509@rambler.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 16, 2009 at 03:37:40PM +0400, Michael Raskin wrote:
> Please CC me: I subscribe and get ignored by the mailing list periodically..
> 
> If other parts of the message are needed, let me know.
> 
> dmesg after such a problem kills system immediately; system hangs on its
> own after some times.
> 
> It usually happens on symlink-intensive operations (creating tens of
> thousand of symlinks inside some tree).
> 
> I also have some more ghost files now..
> 
> [  741.527705] BUG: unable to handle kernel NULL pointer dereference at
> 00000008[  741.527867] IP: [<c1295e76>] __rb_rotate_left+0x12/0x8c

Thanks for sending this oops along.

The very first thing that jumps out is that this is a single bit
error.  It could be a bug in the inode tree code, but it could also be
bad ram.

Is the oops always the same?  Do you have this test setup in a script?

-chris

> [  741.527980] *pdpt = 0000000035562001 *pde = 0000000000000000
> [  741.528131] Oops: 0000 [#1] SMP
> [  741.528279] last sysfs file: /sys/class/power_supply/BAT0/energy_full
> [  741.530625]
> [  741.530625] Pid: 5101, comm: perl Tainted: G        W  (2.6.31-rc3
> #1) X51RL
> 
> [  741.530625] EIP: 0060:[<c1295e76>] EFLAGS: 00010282 CPU: 0
> [  741.530625] EIP is at __rb_rotate_left+0x12/0x8c
> [  741.530625] EAX: e75cc854 EBX: 00000000 ECX: c103393f EDX: e7f90fec
> [  741.530625] ESI: e75cc854 EDI: f58a7a64 EBP: f5514d4c ESP: f5514d40
> [  741.530625]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> 
> [  741.530625] Process perl (pid: 5101, ti=f5514000 task=e94fe280
> task.ti=f5514000)
> [  741.530625] Stack:
> [  741.530625]  e649d274 e649d274 e75cc854 f5514d68 c12960c8 f58a7a64
> e42d94fc e649d274
> [  741.530625] <0> e42d9564 e7f90ff0 f5514d84 f8c17178 f58a7800 e42d9440
> e42d9564 f5514dbc
> [  741.530625] <0> 00000000 f5514ddc f8c1d936 0035ce13 80000000 fffff000
> e42d9440 00000011
> 
> [  741.530625] Call Trace:
> [  741.530625]  [<c12960c8>] ? rb_insert_color+0x14c/0x19d
> [  741.530625]  [<f8c17178>] ? inode_tree_add+0x131/0x162 [btrfs]
> [  741.530625]  [<f8c1d936>] ? btrfs_iget+0x6cb/0x6f8 [btrfs]
> [  741.530625]  [<c103e22d>] ? kmap_atomic+0x22/0x32
> [  741.530625]  [<f8c1dbeb>] ? btrfs_lookup_dentry+0x288/0x2d1 [btrfs]
> [  741.530625]  [<f8c1dc6b>] ? btrfs_lookup+0x37/0x82 [btrfs]
> [  741.530625]  [<c1182ebb>] ? do_lookup+0x153/0x2cb
> [  741.530625]  [<c11847fe>] ? __link_path_walk+0xcf8/0xf61
> [  741.530625]  [<c1185599>] ? path_walk+0xb4/0x19b
> [  741.530625]  [<c118787b>] ? do_path_lookup+0x4f/0x193
> [  741.530625]  [<c118a06b>] ? user_path_at+0x94/0xe4
> [  741.530625]  [<c117b499>] ? vfs_fstatat+0x5f/0xc0
> [  741.530625]  [<c117b586>] ? vfs_lstat+0x24/0x34
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
