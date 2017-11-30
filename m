Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54958 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752801AbdK3Cjf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 21:39:35 -0500
From: Nick Terrell <terrelln@fb.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Mahoney <jeffm@suse.com>, David Howells <dhowells@redhat.com>,
        Liu Bo <bo.li.liu@oracle.com>, Petr Mladek <pmladek@suse.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@01.org" <lkp@01.org>
Subject: Re: [btrfs_mount] general protection fault: 0000 [#1] SMP
Date: Thu, 30 Nov 2017 02:38:10 +0000
Message-ID: <3A84FF7B-0390-41EC-862D-5F83C2A656FA@fb.com>
References: <20171130022115.5gyvncjrnn2377ph@wfg-t540p.sh.intel.com>
In-Reply-To: <20171130022115.5gyvncjrnn2377ph@wfg-t540p.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Nov 29, 2017, at 6:21 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> Hello,
> 
> FYI this happens in mainline kernel 4.15.0-rc1.
> It looks like a new regression. Bisect is in progress.
> 
> It occurs in 11 out of 11 xfstests run.
> 
> [ 1456.361614]
> [ 1456.918942] BTRFS info (device vdb): disk space caching is enabled
> [ 1456.920760] BTRFS info (device vdb): has skinny extents
> [ 1457.111319] run fstests btrfs/094 at 2017-11-28 09:46:30
> [ 1457.702513] BTRFS: device fsid 5c26b547-822d-4338-be92-b2ec5f6b159d devid 1 transid 5 /dev/vdb
> [ 1457.920372] general protection fault: 0000 [#1] SMP
> [ 1457.921693] Modules linked in: dm_flakey btrfs xor zstd_decompress zstd_compress xxhash raid6_pq dm_mod rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver sr_mod cdrom sg ata_generic pata_acpi ppdev snd_pcm snd_timer snd soundcore pcspkr serio_raw ata_piix i2c_piix4 libata parport_pc floppy parport ip_tables
> [ 1457.927395] CPU: 3 PID: 19563 Comm: mount Not tainted 4.15.0-rc1 #1
> [ 1457.928804] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> [ 1457.930815] task: ffff880078f8ca00 task.stack: ffffc90004828000
> [ 1457.934242] RIP: 0010:btrfs_compress_str2level+0x17/0x50 [btrfs]

The stack trace looks like the bug fixed by

Qu Wenruo:
    btrfs: Fix wild memory access in compression level parser [1]

That fix looks to be included in the pull request for 4.15-rc2 [2].

[1] lkml.kernel.org/r/20171106024319.32584-1-wqu@suse.com
[2] lkml.kernel.org/r/cover.1511980478.git.dsterba@suse.com

> [ 1457.936653] RSP: 0018:ffffc9000482baa8 EFLAGS: 00010202
> [ 1457.938909] RAX: 0000000000000001 RBX: ffffffffa057967f RCX: 0000000000000004
> [ 1457.942574] RDX: 1ffff92000905763 RSI: 1ffff92000905763 RDI: ffffffffa057bc24
> [ 1457.946221] RBP: ffffc9000482bb40 R08: 0000000000000063 R09: ffff88007e8257a8
> [ 1457.948982] R10: 000000000000002c R11: ffffffff81a6a340 R12: ffff8800750b0000
> [ 1457.952494] R13: ffff88007e8257a0 R14: 0000000000000000 R15: 0000000000001000
> [ 1457.956106] FS:  00007fb80717d840(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
> [ 1457.960103] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1457.962466] CR2: 00000000010b6f88 CR3: 00000000750ce000 CR4: 00000000000006e0
> [ 1457.966100] Call Trace:
> [ 1457.966851]  btrfs_parse_options+0x96f/0xf20 [btrfs]
> [ 1457.970107]  ? open_ctree+0x1041/0x2410 [btrfs]
> [ 1457.971638]  open_ctree+0x1041/0x2410 [btrfs]
> [ 1457.973780]  btrfs_mount+0xcfa/0xe40 [btrfs]
> [ 1457.975889]  ? pcpu_alloc_area+0xc0/0x130:
> 						pcpu_alloc_area at mm/percpu.c:1010
> [ 1457.979028]  ? pcpu_next_unpop+0x37/0x50:
> 						pcpu_next_unpop at mm/percpu.c:264
> [ 1457.981051]  ? pcpu_alloc+0x2e1/0x650:
> 						pcpu_alloc at mm/percpu.c:1472 (discriminator 1)
> [ 1457.983074]  mount_fs+0x36/0x140:
> 						mount_fs at fs/super.c:1220
> [ 1457.983941]  vfs_kern_mount+0x62/0x130:
> 						vfs_kern_mount at fs/namespace.c:1038
> [ 1457.985951]  btrfs_mount+0x183/0xe40 [btrfs]
> [ 1457.989441]  ? pcpu_alloc_area+0xc0/0x130:
> 						pcpu_alloc_area at mm/percpu.c:1010
> [ 1457.991495]  ? pcpu_next_unpop+0x37/0x50:
> 						pcpu_next_unpop at mm/percpu.c:264
> [ 1457.993524]  ? pcpu_alloc+0x2e1/0x650:
> 						pcpu_alloc at mm/percpu.c:1472 (discriminator 1)
> [ 1457.995502]  mount_fs+0x36/0x140:
> 						mount_fs at fs/super.c:1220
> [ 1457.997415]  vfs_kern_mount+0x62/0x130:
> 						vfs_kern_mount at fs/namespace.c:1038
> [ 1457.999537]  do_mount+0x1d5/0xc90:
> 						do_new_mount at fs/namespace.c:2513
> 						 (inlined by) do_mount at fs/namespace.c:2841
> [ 1458.001440]  ? kmem_cache_alloc_trace+0x16d/0x1c0:
> 						slab_pre_alloc_hook at mm/slab.h:419
> 						 (inlined by) slab_alloc_node at mm/slub.c:2651
> 						 (inlined by) slab_alloc at mm/slub.c:2733
> 						 (inlined by) kmem_cache_alloc_trace at mm/slub.c:2750
> [ 1458.003603]  ? copy_mount_options+0x28/0x240:
> 						copy_mount_options at fs/namespace.c:2722
> [ 1458.005698]  SyS_mount+0x7e/0xd0
> [ 1458.007597]  entry_SYSCALL_64_fastpath+0x1a/0x7d:
> 						entry_SYSCALL_64_fastpath at arch/x86/entry/entry_64.S:210
> [ 1458.009808] RIP: 0033:0x7fb80683c98a
> [ 1458.011835] RSP: 002b:00007fffac136bc8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
> [ 1458.015803] RAX: ffffffffffffffda RBX: 00007fb806d57507 RCX: 00007fb80683c98a
> [ 1458.019432] RDX: 00000000010b4260 RSI: 00000000010b42e0 RDI: 00000000010b42c0
> [ 1458.023055] RBP: 00000000010b4140 R08: 00000000010b4280 R09: 0000000000000021
> [ 1458.025659] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 00007fb806f65e44
> [ 1458.029307] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000005
> [ 1458.031933] Code: 83 e3 05 e9 26 fe ff ff 31 db e9 1f fe ff ff 0f 1f 44 00 00 0f 1f 44 00 00 48 89 fa b9 04 00 00 00 48 c7 c7 24 bc 57 a0 48 89 d6 <f3> a6 40 0f 97 c6 0f 92 c1 31 c0 40 38 ce 75 06 80 7a 04 3a 74
> [ 1458.041233] RIP: btrfs_compress_str2level+0x17/0x50 [btrfs] RSP: ffffc9000482baa8
> [ 1458.045201] ---[ end trace e67558e75fd9eba6 ]---
> [ 1458.066398] Kernel panic - not syncing: Fatal exception
> 
> Attached the full dmesg, kconfig and reproduce scripts.
> 
> Thanks,
> Fengguang
> <dmesg-vm-kbuild-4G-1:20171128094640:x86_64-rhel-7.2:4.15.0-rc1:1><.config.txt><job-script.txt><reproduce-vm-kbuild-4G-1:20171128094640:x86_64-rhel-7.2:4.15.0-rc1:1>

