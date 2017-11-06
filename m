Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:57039 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdKFFZy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 00:25:54 -0500
Received: by mail-ua0-f177.google.com with SMTP id n22so5613448uaj.13
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Nov 2017 21:25:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKuJGC-nnOmK-OnomfMD6BAzYgKM8JogdcBZRkyWq6zXQApURw@mail.gmail.com>
References: <CAKuJGC-nnOmK-OnomfMD6BAzYgKM8JogdcBZRkyWq6zXQApURw@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Mon, 6 Nov 2017 10:55:12 +0530
Message-ID: <CAKuJGC9ZXXhiVEYsZe8G1eO5qs5k8oRQq3rVgnv0_DBnDqw87Q@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.h:3457
To: btrfs <linux-btrfs@vger.kernel.org>, wqu@suse.com,
        David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Seems like output is messed by my email client: Here is formatted one:
https://bugzilla.kernel.org/show_bug.cgi?id=197587#c6

----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org


On Mon, Nov 6, 2017 at 10:47 AM, Lakshmipathi.G
<lakshmipathi.g@gmail.com> wrote:
> Hi.
>
> While running  xfstests/065 with 4.14.0-rc7 and latest btrfs-progs
> from devel branch, it crashes the system after dumping below log:
> (Note: For btrfs-devel, I'm still using SANITY_TESTS=y and
> FS_INTEGRITY=y and applied patch
> https://patchwork.kernel.org/patch/10038011/)
>
>
> Nov 06 05:08:09 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): disk space caching is enabled
> Nov 06 05:08:09 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): has skinny extents
> Nov 06 05:08:09 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): flagging fs with big metadata feature
> Nov 06 05:08:09 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): enabling ssd optimizations
> Nov 06 05:08:09 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): creating UUID tree
> Nov 06 05:08:10 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): dev_replace from /dev/xvdd (devid 2) to
> /dev/xvdg started
> Nov 06 05:08:12 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): dev_replace from /dev/xvdd (devid 2) to
> /dev/xvdg finished
> Nov 06 05:08:16 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS: device fsid 3ebc32b5-ba0a-405b-8acf-4785b0a4b81a devid 1
> transid 5 /dev/xvdc
> Nov 06 05:08:16 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS: device fsid 3ebc32b5-ba0a-405b-8acf-4785b0a4b81a devid 2
> transid 5 /dev/xvdd
> Nov 06 05:08:17 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS: device fsid 3ebc32b5-ba0a-405b-8acf-4785b0a4b81a devid 3
> transid 5 /dev/xvde
> Nov 06 05:08:17 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS: device fsid 3ebc32b5-ba0a-405b-8acf-4785b0a4b81a devid 4
> transid 5 /dev/xvdf
> Nov 06 05:08:17 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): disk space caching is enabled
> Nov 06 05:08:17 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): has skinny extents
> Nov 06 05:08:17 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): flagging fs with big metadata feature
> Nov 06 05:08:17 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): enabling ssd optimizations
> Nov 06 05:08:17 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): creating UUID tree
> Nov 06 05:08:18 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): dev_replace from /dev/xvdd (devid 2) to
> /dev/xvdg started
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS critical (device xvdf): corrupt leaf: root=9 block=4400742400
> slot=0, invalid nritems, have 0 should not be 0 for non-root leaf
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> BTRFS info (device xvdf): leaf 4400742400 total ptrs 0 free space
> 16283
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> assertion failed: 0, file: fs/btrfs/disk-io.c, line: 540
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> ------------[ cut here ]------------
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> kernel BUG at fs/btrfs/ctree.h:3457!
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> invalid opcode: 0000 [#1] SMP
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> Modules linked in: cirrus drm_kms_helper ttm drm intel_rapl sb_edac
> ppdev crct10dif_pclmul crc32_pclmul crc32c_intel xen_netfront
> ghash_clmulni_intel intel_rapl_perf parport_pc parport i2c_piix4
> xen_blkfront serio_raw ata_generic pata_acpi
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> CPU: 1 PID: 13413 Comm: fsstress Not tainted 4.14.0-rc7 #1
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> Hardware name: Xen HVM domU, BIOS 4.2.amazon 12/12/2016
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> task: ffff9d2331a48000 task.stack: ffffbc0f43fd4000
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RIP: 0010:assfail.constprop.49+0x1c/0x22
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RSP: 0018:ffffbc0f43fd79c0 EFLAGS: 00010282
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RAX: 0000000000000038 RBX: ffff9d2335078000 RCX: 0000000000000000
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RDX: 0000000000000000 RSI: ffff9d233fe4e0b8 RDI: ffff9d233fe4e0b8
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RBP: ffffbc0f43fd79c0 R08: 00000000000003f5 R09: 0000000000000000
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> R10: ffffbc0f43fd7938 R11: 0000000000000000 R12: 0000000000000000
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> R13: ffff9d23316f1bc0 R14: ffff9d2335813400 R15: ffff9d2335bd0000
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> FS:  00007f75051fde80(0000) GS:ffff9d233fe40000(0000)
> knlGS:0000000000000000
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> CR2: 00007f750509b000 CR3: 000000043bc7b006 CR4: 00000000001606e0
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel: Call Trace:
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> btree_csum_one_bio+0x14b/0x180
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> btree_submit_bio_hook+0x43/0xc0
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> submit_one_bio+0x5e/0x90
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> flush_epd_write_bio.isra.41+0x21/0x40
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> flush_write_bio+0xe/0x10
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> btree_write_cache_pages+0x2e8/0x420
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> btree_writepages+0x5d/0x70
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> do_writepages+0x48/0xe0
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:  ?
> _cond_resched+0x22/0x40
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:  ?
> merge_state.part.46+0x44/0x130
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> __filemap_fdatawrite_range+0xc1/0x100
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:  ?
> __filemap_fdatawrite_range+0xc1/0x100
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:  ?
> free_extent_state+0x98/0x100
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> filemap_fdatawrite_range+0x13/0x20
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> btrfs_write_marked_extents+0x68/0x140
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> btrfs_write_and_wait_marked_extents.constprop.21+0x4f/0x90
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> btrfs_commit_transaction+0x6ad/0x950
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:  ?
> btrfs_commit_transaction+0x6ad/0x950
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:  ?
> finish_wait+0x80/0x80
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> btrfs_sync_file+0x328/0x400
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> vfs_fsync_range+0x49/0xa0
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> do_fsync+0x3d/0x70
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> SyS_fsync+0x10/0x20
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> entry_SYSCALL_64_fastpath+0x1a/0xa5
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RIP: 0033:0x7f75049cf720
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RSP: 002b:00007fff253c0158 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RAX: ffffffffffffffda RBX: 0000000000000037 RCX: 00007f75049cf720
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RDX: 00007fff253c00c0 RSI: 00007fff253c00c0 RDI: 0000000000000003
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RBP: 0000000000007338 R08: 0000000001cd0160 R09: 00007fff253c016c
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000003
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> R13: 00000000000e04b9 R14: 0000000001cd0c00 R15: 0000000000000000
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> Code: 40 70 31 d2 48 89 86 88 00 00 00 89 d0 5d c3 55 89 f1 48 c7 c2
> db f7 cd bc 48 89 fe 48 c7 c7 a0 cd cd bc 48 89 e5 e8 e7 18 d5 ff <0f>
> 0b 90 90 90 90 0f 1f 44 00 00 48 8b 46 20 a8 02 0f 84 a3 00
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RIP: assfail.constprop.49+0x1c/0x22 RSP: ffffbc0f43fd79c0
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> ---[ end trace f9e6a562c32ec923 ]---
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> ------------[ cut here ]------------
> 1Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> WARNING: CPU: 1 PID: 13413 at kernel/exit.c:771 do_exit+0x51/0xb40
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> Modules linked in: cirrus drm_kms_helper ttm drm intel_rapl sb_edac
> ppdev crct10dif_pclmul crc32_pclmul crc32c_intel xen_netfront
> ghash_clmulni_intel intel_rapl_perf parport_pc parport i2c_piix4
> xen_blkfront serio_raw ata_generic pata_acpi
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> CPU: 1 PID: 13413 Comm: fsstress Tainted: G      D         4.14.0-rc7
> #1
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> Hardware name: Xen HVM domU, BIOS 4.2.amazon 12/12/2016
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> task: ffff9d2331a48000 task.stack: ffffbc0f43fd4000
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RIP: 0010:do_exit+0x51/0xb40
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RSP: 0018:ffffbc0f43fd7ed8 EFLAGS: 00010206
> Nov 06 05:08:23 ip-172-31-32-145.us-west-2.compute.internal kernel:
> RAX: ffffbc0f43fd7d40 RBX: ffff9d2331a48000 RCX: ffffbc0f43fd7d50
>
>
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
