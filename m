Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:49081 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752089AbdKDOBs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Nov 2017 10:01:48 -0400
Received: by mail-ua0-f182.google.com with SMTP id z4so3728582uaz.5
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Nov 2017 07:01:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKuJGC_g04HuRFBBmaQ70gJLnEreVCNG5-idvSeTxrS1vH4UVQ@mail.gmail.com>
References: <CAKuJGC_g04HuRFBBmaQ70gJLnEreVCNG5-idvSeTxrS1vH4UVQ@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Sat, 4 Nov 2017 19:31:46 +0530
Message-ID: <CAKuJGC_3VEX0be87ceL4jT9A7J41ydvnmD0iL_+b7ZGHhUDxJA@mail.gmail.com>
Subject: Re: xfstests:btrfs/025, 026 fails
To: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay I narrowed it down to

/bin/mount -t btrfs -o context=system_u:object_r:root_t:s0 -o compress
/dev/xvdc /mnt/scratch

command from xfstests/btrfs/026.

Cheers.

On 11/4/17, Lakshmipathi.G <lakshmipathi.g@gmail.com> wrote:
> Hi .
>
> While running xfstests with 4.14.0-rc7 the test hangs on btrfs/026
> (after running 025) and produces below trace:
>
> [ 2134.147940] run fstests btrfs/026 at 2017-11-04 09:46:19
> [ 2134.388024] BTRFS: device fsid d3de0b02-8b7e-422a-8165-c074f834e909
> devid 1 transid 5 /dev/xvdc
> [ 2134.405001] general protection fault: 0000 [#1] SMP
> [ 2134.408660] Modules linked in: cirrus drm_kms_helper ttm drm ppdev
> intel_rapl sb_edac parport_pc crct10dif_pclmul parport crc32_pclmul
> crc32c_intel ghash_clmulni_intel xen_netfront intel_rapl_perf
> i2c_piix4 xen_blkfront serio_raw ata_generic pata_acpi
> [ 2134.420112] CPU: 1 PID: 8478 Comm: mount Not tainted 4.14.0-rc7 #1
> [ 2134.423711] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
> [ 2134.427557] task: ffff8ec43c672600 task.stack: ffffa90fc886c000
> [ 2134.431351] RIP: 0010:btrfs_compress_str2level+0x18/0x4e
> [ 2134.434764] RSP: 0018:ffffa90fc886fa10 EFLAGS: 00010202
> [ 2134.438128] RAX: 0000000000000001 RBX: ffff8ec434c80000 RCX:
> 0000000000000004
> [ 2134.442160] RDX: 5485389ff3298000 RSI: 5485389ff3298000 RDI:
> ffffffff94cdb929
> [ 2134.446266] RBP: ffffa90fc886fac0 R08: 0000000000000000 R09:
> 5485389ff3298000
> [ 2134.450252] R10: 000000000000002c R11: ffffffff94a917c0 R12:
> ffffffff94d1ec8a
> [ 2134.454875] R13: ffff8ec434d1c720 R14: 0000000000000000 R15:
> 0000000000000000
> [ 2134.459141] FS:  00007f9e870c8480(0000) GS:ffff8ec43fe40000(0000)
> knlGS:0000000000000000
> [ 2134.464051] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2134.467519] CR2: 00007f5ae9499710 CR3: 00000004343e4002 CR4:
> 00000000001606e0
> [ 2134.471549] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 2134.475601] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [ 2134.480049] Call Trace:
> [ 2134.482285]  ? btrfs_parse_options+0x9fd/0x1020
> [ 2134.485502]  open_ctree+0x1244/0x24df
> [ 2134.488245]  ? open_ctree+0x1244/0x24df
> [ 2134.490954]  btrfs_mount+0xe16/0xefc
> [ 2134.493481]  ? find_next_bit+0xb/0x10
> [ 2134.496095]  ? cpumask_next+0x1b/0x20
> [ 2134.498643]  mount_fs+0x32/0x150
> [ 2134.501001]  ? __alloc_percpu+0x15/0x20
> [ 2134.504016]  vfs_kern_mount.part.22+0x5d/0x120
> [ 2134.507094]  vfs_kern_mount+0x13/0x20
> [ 2134.509737]  btrfs_mount+0x1a8/0xefc
> [ 2134.512338]  ? find_next_bit+0xb/0x10
> [ 2134.514963]  mount_fs+0x32/0x150
> [ 2134.517289]  ? __alloc_percpu+0x15/0x20
> [ 2134.519917]  vfs_kern_mount.part.22+0x5d/0x120
> [ 2134.522754]  do_mount+0x5c7/0xca0
> [ 2134.525101]  ? kmem_cache_alloc_trace+0x165/0x1d0
> [ 2134.528554]  ? copy_mount_options+0x2c/0x220
> [ 2134.531459]  SyS_mount+0x98/0xe0
> [ 2134.533880]  entry_SYSCALL_64_fastpath+0x1a/0xa5
> [ 2134.536942] RIP: 0033:0x7f9e8611c28a
> [ 2134.539496] RSP: 002b:00007fff6cddbf68 EFLAGS: 00000246 ORIG_RAX:
> 00000000000000a5
> [ 2134.543632] RAX: ffffffffffffffda RBX: 00007f9e86c9c7ef RCX:
> 00007f9e8611c28a
> [ 2134.547646] RDX: 00005562a4af82f0 RSI: 00005562a4af83b0 RDI:
> 00005562a4af8390
> [ 2134.552254] RBP: 00007f9e86eae184 R08: 00005562a4af8310 R09:
> 00007fff6cddae68
> [ 2134.556487] R10: 00000000c0ed0000 R11: 0000000000000246 R12:
> 00005562a4af8140
> [ 2134.560647] R13: 00007fff6cddc288 R14: 00005562a359f4a0 R15:
> 00000000ffffffff
> [ 2134.564622] Code: ad 31 db eb a9 0f 1f 40 00 66 2e 0f 1f 84 00 00
> 00 00 00 0f 1f 44 00 00 55 48 89 fa b9 04 00 00 00 48 89 d6 48 c7 c7
> 29 b9 cd 94 <f3> a6 48 89 e5 40 0f 97 c6 0f 92 c1 31 c0 40 38 ce 75 06
> 80 7a
> [ 2134.574756] RIP: btrfs_compress_str2level+0x18/0x4e RSP:
> ffffa90fc886fa10
> [ 2134.578890] ---[ end trace 47a5851d0ed3c8fd ]---
>
>
> https://bugzilla.kernel.org/show_bug.cgi?id=197771
>
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
>


-- 
----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org
