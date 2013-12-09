Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hera.mpi-klsb.mpg.de ([139.19.1.49]:32947 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3LIVPv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Dec 2013 16:15:51 -0500
Message-ID: <52A63302.4020301@mpi-sws.org>
Date: Mon, 09 Dec 2013 22:15:46 +0100
From: Pedro Fonseca <pfonseca@mpi-sws.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Warning in inode_tree_add() -- !(entry->vfs_inode.i_state & (I_WILL_FREE
 | I_FREEING)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've got multiple instances of warnings caused by the statement 
"WARN_ON(!(entry->vfs_inode.i_state & (I_WILL_FREE | I_FREEING)));" in 
inode_tree_add(). The tests were executed on the official 3.12.2 kernel. 
Do you think it's something serious?

Pedro



Warning message (for test 1):
> [  257.691419] btrfs: new size for /dev/loop0 is 308281344
> [  271.929976] ------------[ cut here ]------------
> [  271.945240] WARNING: CPU: 0 PID: 2726 at 
> /local/pfonseca/piking/kernel-build/linux-3.12.2-fs-static2/fs/btrfs/inode.c:4709 
> inode_tree_add+0x89/0xd9()
> [  271.949424] Modules linked in: loop rtc_cmos tpm_tis freq_table 
> pcspkr i2c_piix4
> [  271.951685] CPU: 0 PID: 2726 Comm: btrfs-endio-wri Not tainted 
> 3.12.2 #2
> [  271.952213] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [  271.952879]  00000000 00000000 c53d5d58 c16415c4 00000000 c53d5d70 
> c102b699 c11edd24
> [  271.953485]  d952e8d4 c4e6ac00 d9548458 c53d5d80 c102b6bf 00000009 
> 00000000 c53d5da4
> [  271.953995]  c11edd24 00000000 00000109 c4e6af9c d95483e4 d9548458 
> 00000109 00000000
> [  271.954594] Call Trace:
> [  271.955905]  [<c16415c4>] dump_stack+0x41/0x52
> [  271.956200]  [<c102b699>] warn_slowpath_common+0x5c/0x73
> [  271.956474]  [<c11edd24>] ? inode_tree_add+0x89/0xd9
> [  271.956716]  [<c102b6bf>] warn_slowpath_null+0xf/0x13
> [  271.956959]  [<c11edd24>] inode_tree_add+0x89/0xd9
> [  271.957196]  [<c11f4c5f>] btrfs_iget+0x39c/0x3d6
> [  271.957433]  [<c11f4d9f>] relink_extent_backref+0x106/0x67c
> [  271.957698]  [<c12321a9>] ? iterate_inodes_from_logical+0x7d/0x93
> [  271.957975]  [<c11eeb00>] ? btrfs_clear_bit_hook+0x1bb/0x1f9
> [  271.958251]  [<c11f5b02>] btrfs_finish_ordered_io+0x7ed/0x8ad
> [  271.958525]  [<c102e851>] ? irq_exit+0x42/0x44
> [  271.959161]  [<c11f5bcd>] finish_ordered_fn+0xb/0xd
> [  271.959404]  [<c121003c>] worker_loop+0xf5/0x3d1
> [  271.959643]  [<c120ff47>] ? btrfs_queue_worker+0x1e4/0x1e4
> [  271.959898]  [<c103e612>] kthread+0x6e/0x73
> [  271.960122]  [<c1648797>] ret_from_kernel_thread+0x1b/0x28
> [  271.960378]  [<c103e5a4>] ? __kthread_parkme+0x54/0x54
> [  271.961028] ---[ end trace 00b972e1196e8ac0 ]---

* Test 1:
>     CPU: 1 Op: dread
>     CPU: 1 Op: chown
>     CPU: 1 Op: dwrite
> CPU: 0 Op: chown
> CPU: 0 Op: rmdir
> CPU: 0 Op: chown
> CPU: 0 Op: chown
> CPU: 0 Op: chown
> CPU: 0 Op: btrfs_subvol_list
> CPU: 0 Op: btrfs_ioctl_filesystem_resize
>     CPU: 1 Op: write
>     CPU: 1 Op: read
>     CPU: 1 Op: dwrite
>     CPU: 1 Op: dread
>     CPU: 1 Op: btrfs_ioctl_filesystem_defragment

* Test 2:
>     CPU: 1 Op: dread
>     CPU: 1 Op: chown
>     CPU: 1 Op: dwrite
>     CPU: 1 Op: write
>     CPU: 1 Op: read
>     CPU: 1 Op: dwrite
> CPU: 0 Op: dread
> CPU: 0 Op: chown
> CPU: 0 Op: dwrite
>     CPU: 1 Op: dread
>     CPU: 1 Op: btrfs_ioctl_filesystem_defragment
> CPU: 0 Op: write
> CPU: 0 Op: read
> CPU: 0 Op: dwrite
> CPU: 0 Op: dread
> CPU: 0 Op: btrfs_ioctl_filesystem_defragment

* Test 3:
>     CPU: 1 Op: dread
>     CPU: 1 Op: stat
>     CPU: 1 Op: btrfs_ioctl_filesystem_resize
>     CPU: 1 Op: write
>     CPU: 1 Op: mkdir
>     CPU: 1 Op: creat
>     CPU: 1 Op: chown
>     CPU: 1 Op: rename
> CPU: 0 Op: dread
> CPU: 0 Op: chown
> CPU: 0 Op: dwrite
> CPU: 0 Op: write
> CPU: 0 Op: read
> CPU: 0 Op: dwrite
> CPU: 0 Op: dread
> CPU: 0 Op: btrfs_ioctl_filesystem_defragment


