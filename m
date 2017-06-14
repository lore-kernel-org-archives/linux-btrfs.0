Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33097 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754424AbdFNIpj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Jun 2017 04:45:39 -0400
Received: by mail-it0-f68.google.com with SMTP id l6so16864597iti.0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Jun 2017 01:45:39 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <8046b838-500b-fc29-d6f9-cfdbbdb9fc88@suse.com>
References: <8046b838-500b-fc29-d6f9-cfdbbdb9fc88@suse.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 14 Jun 2017 09:45:37 +0100
Message-ID: <CAL3q7H4VjnA09jWoV562eNzj8WjydjqVyyFjuE4nfW6PNWao-A@mail.gmail.com>
Subject: Re: regression in 4.12 caused by a7e3b975a0f9 ("Btrfs: fix reported
 number of inode blocks")
To: Nikolay Borisov <nborisov@suse.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 14, 2017 at 8:24 AM, Nikolay Borisov <nborisov@suse.com> wrote:
> Hello Filipe,
>
> It seems the above commit causes  various underflows in
> some btrfs internal counters. This is evident during generic/439 running:

Yes, it's evident - I wrote that test recently to fix a bug that
existed for a long time, which that commit exposes more easily. The
fix is at:

https://patchwork.kernel.org/patch/9760695/

If you read the changelog for the fstests commit, you'll see that it
refers to that patch.

>
> The first one is in BTRFS_I(inode)->csum_bytes
>
> [   16.710508] ------------[ cut here ]------------
> [   16.710524] WARNING: CPU: 3 PID: 1080 at fs/btrfs/inode.c:9449 btrfs_destroy_inode+0x275/0x2c0
> [   16.710525] Modules linked in:
> [   16.710530] CPU: 3 PID: 1080 Comm: umount Not tainted 4.12.0-rc5-nbor #317
> [   16.710531] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [   16.710533] task: ffff8801309bd4c0 task.stack: ffff880132ff4000
> [   16.710535] RIP: 0010:btrfs_destroy_inode+0x275/0x2c0
> [   16.710537] RSP: 0018:ffff880132ff7d08 EFLAGS: 00010286
> [   16.710540] RAX: 0000000000000000 RBX: ffff8801369ee000 RCX: 0000000000000000
> [   16.710541] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880131f21aa0
> [   16.710542] RBP: ffff880132ff7d38 R08: 0000000000000000 R09: 0000000000000000
> [   16.710543] R10: 0000000000000001 R11: 0000000080b489d8 R12: ffff880131f21aa0
> [   16.710544] R13: ffff88012ff60000 R14: ffff8801396c57a8 R15: ffff8801396c57a8
> [   16.710546] FS:  00007f4ca857a840(0000) GS:ffff88013fcc0000(0000) knlGS:0000000000000000
> [   16.710548] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   16.710550] CR2: 00007f4ca7da0170 CR3: 00000001347fe000 CR4: 00000000000006a0
> [   16.710553] Call Trace:
> [   16.710562]  destroy_inode+0x3b/0x60
> [   16.710565]  evict+0x135/0x1c0
> [   16.710567]  dispose_list+0x4d/0x80
> [   16.710570]  evict_inodes+0x16d/0x180
> [   16.710588]  generic_shutdown_super+0x3f/0x120
> [   16.710590]  kill_anon_super+0x12/0x20
> [   16.710597]  btrfs_kill_super+0x16/0xa0
> [   16.710599]  deactivate_locked_super+0x4c/0x80
> [   16.710602]  deactivate_super+0x45/0x60
> [   16.710604]  cleanup_mnt+0x3f/0x70
> [   16.710605]  __cleanup_mnt+0x12/0x20
> [   16.710609]  task_work_run+0x7e/0xc0
> [   16.710614]  exit_to_usermode_loop+0x6c/0x93
> [   16.710618]  syscall_return_slowpath+0x9f/0xd0
> [   16.710625]  entry_SYSCALL_64_fastpath+0xc0/0xc2
>
> What's peculiar about this one is that it always underflows by a single page size.
> When the warning triggers csum_bytes is -4096. Perhaps some off-by-one which is then
> multiplied by PAGE_SIZE? I've investigated it a bit further and here are the 2 types of
> stack traces that lead to freeing csum_bytes:
>
> ==========================
> Freeing 4096 bytes for ino 257
>  0xffffffff813d0042 : calc_csum_metadata_size+0x62/0x100 [kernel]
>  0xffffffff813d94b1 : btrfs_delalloc_release_metadata+0x1a1/0x210 [kernel]
>  0xffffffff813f8d66 : btrfs_clear_bit_hook+0xd6/0x410 [kernel]
>  0xffffffff814182ce : clear_state_bit+0x6e/0x180 [kernel] clear_state_bit at fs/btrfs/extent_io.c:549
>  0xffffffff81418517 : __clear_extent_bit+0x137/0x370 [kernel] fs/btrfs/extent_io.c:726
>  0xffffffff81418c2a : clear_extent_bit+0x2a/0x30 [kernel]
>  0xffffffff8140b565 : lock_and_cleanup_extent_if_need+0x1e5/0x370 [kernel] fs/btrfs/file.c:1514
>  0xffffffff8140c9b4 : __btrfs_buffered_write+0x204/0x6e0 [kernel]
>  0xffffffff814104cc : btrfs_file_write_iter+0x19c/0x500 [kernel]
>  0xffffffff811d19c5 : __vfs_write+0xc5/0x140 [kernel]
>  0xffffffff811d39bc : vfs_write+0xcc/0x1a0 [kernel]
>  0xffffffff811d3e65 : sys_pwrite64+0x85/0xa0 [kernel]
>  0xffffffff8178ca85 : entry_SYSCALL_64_fastpath+0x23/0xc2 [kernel]
>  0x0 (inexact)
>
> ==========================
> Freeing 155648 bytes for ino 257
>          UNDERFLOW !!!
>  0xffffffff813d0042 : calc_csum_metadata_size+0x62/0x100 [kernel]
>  0xffffffff813d94b1 : btrfs_delalloc_release_metadata+0x1a1/0x210 [kernel]
>  0xffffffff8140103d : btrfs_finish_ordered_io+0x16d/0x6a0 [kernel] fs/btrfs/inode.c:3038
>  0xffffffff81401585 : finish_ordered_fn+0x15/0x20 [kernel]
>  0xffffffff8142d083 : normal_work_helper+0x93/0x650 [kernel]
>  0xffffffff8142d832 : btrfs_endio_write_helper+0x12/0x20 [kernel]
>  0xffffffff8107259b : process_one_work+0x1cb/0x5f0 [kernel]
>  0xffffffff81072a4d : worker_thread+0x4d/0x380 [kernel]
>  0xffffffff81079ce4 : kthread+0x114/0x150 [kernel]
>  0xffffffff8178cd1a : ret_from_fork+0x2a/0x40 [kernel]
>  0x0 (inexact)
>
> The underflow always happens from finish_ordered_io.
>
> The next one is:
>
> [   55.007633] ------------[ cut here ]------------
> [   55.007652] WARNING: CPU: 1 PID: 1078 at fs/btrfs/extent-tree.c:5709 btrfs_free_block_groups+0x365/0x3f0
> [   55.007654] Modules linked in:
> [   55.007660] CPU: 1 PID: 1078 Comm: umount Tainted: G        W       4.12.0-rc5-nbor #318
> [   55.007662] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [   55.007663] task: ffff8801329eb880 task.stack: ffff880130c10000
> [   55.007666] RIP: 0010:btrfs_free_block_groups+0x365/0x3f0
> [   55.007668] RSP: 0018:ffff880130c13d68 EFLAGS: 00010286
> [   55.007672] RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff880130c13cbc
> [   55.007673] RDX: 0000000000000002 RSI: 0000000000000002 RDI: ffff880136bf5000
> [   55.007675] RBP: ffff880130c13d98 R08: 0000000000000000 R09: 0000000000000000
> [   55.007677] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880136bf4400
> [   55.007679] R13: ffff88012fe20000 R14: ffff88012fe200c0 R15: ffff88012fe20100
> [   55.007681] FS:  00007fcbfc1b9840(0000) GS:ffff88013fc40000(0000) knlGS:0000000000000000
> [   55.007683] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   55.007685] CR2: 00007fcbfb9e1903 CR3: 000000012fd8f000 CR4: 00000000000006a0
> [   55.007690] Call Trace:
> [   55.007698]  close_ctree+0x13b/0x330
> [   55.007703]  ? evict_inodes+0x16d/0x180
> [   55.007710]  btrfs_put_super+0x15/0x20
> [   55.007714]  generic_shutdown_super+0x6a/0x120
> [   55.007718]  kill_anon_super+0x12/0x20
> [   55.007721]  btrfs_kill_super+0x16/0xa0
> [   55.007725]  deactivate_locked_super+0x4c/0x80
> [   55.007728]  deactivate_super+0x45/0x60
> [   55.007732]  cleanup_mnt+0x3f/0x70
> [   55.007734]  __cleanup_mnt+0x12/0x20
> [   55.007738]  task_work_run+0x7e/0xc0
> [   55.007743]  exit_to_usermode_loop+0x6c/0x93
> [   55.007749]  syscall_return_slowpath+0x9f/0xd0
> [   55.007760]  entry_SYSCALL_64_fastpath+0xc0/0xc2
> [   55.007874] ---[ end trace 06f22a84784e2e1d ]---
>
> [   55.007876] fs_info->delalloc_block_rsv.size == 1
>
> And this one:
>
> [   55.007888] WARNING: CPU: 1 PID: 1078 at fs/btrfs/extent-tree.c:5712 btrfs_free_block_groups+0x3d5/0x3f0
> [   55.007890] Modules linked in:
> [   55.007894] CPU: 1 PID: 1078 Comm: umount Tainted: G        W       4.12.0-rc5-nbor #318
> [   55.007895] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [   55.007897] task: ffff8801329eb880 task.stack: ffff880130c10000
> [   55.007899] RIP: 0010:btrfs_free_block_groups+0x3d5/0x3f0
> [   55.007901] RSP: 0018:ffff880130c13d68 EFLAGS: 00010206
> [   55.007904] RAX: 0000000000000029 RBX: 0000000000000000 RCX: 0000000000000006
> [   55.007906] RDX: 0000000000000000 RSI: 0000000000138000 RDI: ffff88013fc4c9d0
> [   55.007908] RBP: ffff880130c13d98 R08: 0000000000000000 R09: 0000000000000000
> [   55.007909] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880136bf4400
> [   55.007911] R13: ffff88012fe20000 R14: ffff88012fe200c0 R15: ffff88012fe20100
> [   55.007913] FS:  00007fcbfc1b9840(0000) GS:ffff88013fc40000(0000) knlGS:0000000000000000
> [   55.007915] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   55.007917] CR2: 00007fcbfb9e1903 CR3: 000000012fd8f000 CR4: 00000000000006a0
> [   55.007920] Call Trace:
> [   55.007926]  close_ctree+0x13b/0x330
> [   55.007929]  ? evict_inodes+0x16d/0x180
> [   55.007934]  btrfs_put_super+0x15/0x20
> [   55.007937]  generic_shutdown_super+0x6a/0x120
> [   55.007941]  kill_anon_super+0x12/0x20
> [   55.007944]  btrfs_kill_super+0x16/0xa0
> [   55.007948]  deactivate_locked_super+0x4c/0x80
> [   55.007951]  deactivate_super+0x45/0x60
> [   55.007954]  cleanup_mnt+0x3f/0x70
> [   55.007957]  __cleanup_mnt+0x12/0x20
> [   55.007959]  task_work_run+0x7e/0xc0
> [   55.007964]  exit_to_usermode_loop+0x6c/0x93
> [   55.007968]  syscall_return_slowpath+0x9f/0xd0
> [   55.007972]  entry_SYSCALL_64_fastpath+0xc0/0xc2
> [   55.008080] ---[ end trace 06f22a84784e2e1e ]---
> [   55.008082] fs_info->delalloc_block_rsv.reserved == 1277952
>
>
> There's also this one:
>
> [   16.729373] ------------[ cut here ]------------
> [   16.729375] WARNING: CPU: 3 PID: 1080 at fs/btrfs/extent-tree.c:9836 btrfs_free_block_groups+0x2c5/0x3e0
> [   16.729375] Modules linked in:
> [   16.729378] CPU: 3 PID: 1080 Comm: umount Tainted: G        W       4.12.0-rc5-nbor #317
> [   16.729379] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [   16.729380] task: ffff8801309bd4c0 task.stack: ffff880132ff4000
> [   16.729381] RIP: 0010:btrfs_free_block_groups+0x2c5/0x3e0
> [   16.729382] RSP: 0018:ffff880132ff7d68 EFLAGS: 00010286
> [   16.729384] RAX: ffff88013089e0e8 RBX: 0000000000000000 RCX: 0000000000000006
> [   16.729385] RDX: 0000000000000000 RSI: ffff8801309bdfc8 RDI: ffff88013fccc9d0
> [   16.729386] RBP: ffff880132ff7d98 R08: 0000000000000000 R09: 0000000000000000
> [   16.729387] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88013089e800
> [   16.729388] R13: ffff88012ff60000 R14: ffff88013089e0e8 R15: ffff88013089e000
> [   16.729391] FS:  00007f4ca857a840(0000) GS:ffff88013fcc0000(0000) knlGS:0000000000000000
> [   16.729393] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   16.729394] CR2: 00007f4ca7da0170 CR3: 00000001347fe000 CR4: 00000000000006a0
> [   16.729396] Call Trace:
> [   16.729399]  close_ctree+0x13b/0x330
> [   16.729401]  ? evict_inodes+0x16d/0x180
> [   16.729404]  btrfs_put_super+0x15/0x20
> [   16.729406]  generic_shutdown_super+0x6a/0x120
> [   16.729408]  kill_anon_super+0x12/0x20
> [   16.729410]  btrfs_kill_super+0x16/0xa0
> [   16.729412]  deactivate_locked_super+0x4c/0x80
> [   16.729415]  deactivate_super+0x45/0x60
> [   16.729416]  cleanup_mnt+0x3f/0x70
> [   16.729418]  __cleanup_mnt+0x12/0x20
> [   16.729420]  task_work_run+0x7e/0xc0
> [   16.729422]  exit_to_usermode_loop+0x6c/0x93
> [   16.729425]  syscall_return_slowpath+0x9f/0xd0
> [   16.729427]  entry_SYSCALL_64_fastpath+0xc0/0xc2
> [   16.729519] BTRFS info (device vdc): space_info 1 has 7974912 free, is not full
> [   16.729537] BTRFS info (device vdc): space_info total=8388608, used=417792, pinned=0, reserved=0, may_use=18446744073709547520, readonly=0
>
> Here may_use has clearly underflowed and if you convert it to a signed value
> it actually becomes -4096.
>
> This doesn't happen when DIO is used. Perhaps this commit should be reverted?
> In the meantime I will continue investigating why this is happening.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
