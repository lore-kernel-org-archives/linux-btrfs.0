Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:58174 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3EOPAf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 11:00:35 -0400
Received: by mail-lb0-f182.google.com with SMTP id r11so1940226lbv.41
        for <linux-btrfs@vger.kernel.org>; Wed, 15 May 2013 08:00:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADYPuQ5ESOPv_zymxAkCzKyMGDAy9Bh8Nu8UQyb161a=Jb+a8w@mail.gmail.com>
References: <CADYPuQ5ESOPv_zymxAkCzKyMGDAy9Bh8Nu8UQyb161a=Jb+a8w@mail.gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Wed, 15 May 2013 17:00:09 +0200
Message-ID: <CAFWF=anRmFTAp0e0yAsGh6hxhzVDZ+BvLFssGCf0Gw+1Wef3-g@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/free-space-cache.c:1567!, Kernel 3.9.1
To: Philipp Dreimann <philipp@dreimann.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 15, 2013 at 4:19 PM, Philipp Dreimann <philipp@dreimann.net> wrote:
> Hello,
>
> my btrfs filesystem was not mountable anymore after a loss of power:
>
> kernel BUG at fs/btrfs/free-space-cache.c:1567!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: btrfs libcrc32c xor zlib_deflate raid6_pq i915(+)
> i2c_algo_bit drm_kms_helper drm i2c_core video uinput
> CPU 3
> Pid: 147, comm: mount Not tainted 3.9.1-301.fc19.x86_64 #1 LENOVO
> 4290W4H/4290W4H
> RIP: 0010:[<ffffffffa01c5984>]  [<ffffffffa01c5984>]
> remove_from_bitmap+0x1f4/0x210 [btrfs]
> RSP: 0018:ffff88020fddd698  EFLAGS: 00010287
> RAX: 0000001454248000 RBX: ffff880211399180 RCX: 0000001454253000
> RDX: 0000000000013000 RSI: 00000000000051c0 RDI: 0000000000002e40
> RBP: ffff88020fddd6e8 R08: ffff88020fecf5c8 R09: 0000001459400000
> R10: ffff8802124ce240 R11: ffff880211399198 R12: ffff880210025240
> R13: ffff88020fddd708 R14: ffff88020fddd700 R15: ffff8802113991a8
> FS:  00007f019f213880(0000) GS:ffff88021e2c0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4cdd4223f0 CR3: 000000020ff03000 CR4: 00000000000407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process mount (pid: 147, threadinfo ffff88020fddc000, task ffff8802100b4650)
> Stack:
>  ffff88020fddd6e8 0000001459400000 ffff880210025264 0000001454253000
>  0000000000013000 ffff880210025240 ffff880210025264 0000000000000000
>  ffff880210025248 ffff88020ff4ec00 ffff88020fddd738 ffffffffa01c714b
> Call Trace:
>  [<ffffffffa01c714b>] btrfs_remove_free_space+0x5b/0x290 [btrfs]
>  [<ffffffff810810e0>] ? wake_up_bit+0x30/0x30
>  [<ffffffffa0176bff>] btrfs_alloc_logged_file_extent+0x1af/0x1d0 [btrfs]
>  [<ffffffffa0162e86>] ? btrfs_free_path+0x26/0x30 [btrfs]
>  [<ffffffffa01c1ef7>] replay_one_extent+0x607/0x690 [btrfs]
>  [<ffffffffa01c224b>] replay_one_buffer+0x2cb/0x390 [btrfs]
>  [<ffffffffa01a77b4>] ? alloc_extent_buffer+0x94/0x3f0 [btrfs]
>  [<ffffffffa01bd484>] walk_down_log_tree+0x224/0x410 [btrfs]
>  [<ffffffffa01bd95f>] walk_log_tree+0xbf/0x1f0 [btrfs]
>  [<ffffffffa01c43c1>] btrfs_recover_log_trees+0x1f1/0x360 [btrfs]
>  [<ffffffffa01c1f80>] ? replay_one_extent+0x690/0x690 [btrfs]
>  [<ffffffffa0186a1b>] open_ctree+0x18eb/0x1f90 [btrfs]
>  [<ffffffff812dac54>] ? disk_name+0x54/0xb0
>  [<ffffffffa015f94e>] btrfs_mount+0x5ce/0x6c0 [btrfs]
>  [<ffffffff8129525d>] ? selinux_sb_copy_data+0x14d/0x220
>  [<ffffffff8119d1a9>] mount_fs+0x39/0x1b0
>  [<ffffffff811b635f>] vfs_kern_mount+0x5f/0xf0
>  [<ffffffffa015f4fc>] btrfs_mount+0x17c/0x6c0 [btrfs]
>  [<ffffffff8129525d>] ? selinux_sb_copy_data+0x14d/0x220
>  [<ffffffff8119d1a9>] mount_fs+0x39/0x1b0
>  [<ffffffff811b635f>] vfs_kern_mount+0x5f/0xf0
>  [<ffffffff811b862e>] do_mount+0x23e/0xa20
>  [<ffffffff811b8276>] ? copy_mount_options+0x36/0x170
>  [<ffffffff811b8e93>] sys_mount+0x83/0xc0
>  [<ffffffff8164db19>] system_call_fastpath+0x16/0x1b
>  Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 40 00 31 c0 48 83 7b 20
> 00 75 e4 48 89 de 4c 89 e7 89 45 c0 e8 b1 ed ff ff 8b 45 c0 eb d1 <0f>
> 0b e8 69 a4 02 00 0f 1f 44 00 00 e8 59 a4 02 00 66 66 2e 0f
>  RIP  [<ffffffffa01c5984>] remove_from_bitmap+0x1f4/0x210 [btrfs]
>  RSP <ffff88020fddd698>
>
> Mounting the fs with "-o recovery,ro", and using btrfsck did not work.
> btrfsck segfaulted, but I can not provide the error message.
> btrfs-zero-log allowed me to mount the fs again.
>
> BR,
>  Philipp Dreimann
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks to me like you should have been able to mount with -o
clear_cache. Did you try that? Does it work again now?
