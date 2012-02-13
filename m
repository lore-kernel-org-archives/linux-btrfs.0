From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS crash during mount
Date: Mon, 13 Feb 2012 09:46:28 -0500
Message-ID: <20120213144628.GD1573@shiny>
References: <4F32F502.6070307@swissonline.ch>
 <CAE5mzvi2UXyVYYxPeHA19RV=Gy90c7c_CA3rPZN5rrAUJB-07A@mail.gmail.com>
 <4F367EB8.4090202@swissonline.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
To: Daniel Kuhn <cheeef@swissonline.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F367EB8.4090202@swissonline.ch>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 11, 2012 at 03:44:08PM +0100, Daniel Kuhn wrote:
> The mount option "-o recovery" doesn't change anything, the
> segmentation fault still occurs. Any ideas?

Sorry for the hassle, you should be able to get by this by zeroing the
log root.

Run btrfs-zero-log /dev/xxx

-chris

> 
> Daniel
> 
> 
> cwillu wrote:
> >On Wed, Feb 8, 2012 at 4:19 PM, Daniel Kuhn <cheeef@swissonline.ch> wrote:
> >>After a forced power turn-off the filesystem of my primary boot partition
> >>cannot be mounted anymore,
> >>btrfs crashes during the mount process. I'm using OpenSuse 12.1 but I've
> >>also tried mounting with a newer kernel 3.2.2 (systemrescue cd) and with a
> >>usb-converter connected to another PC without success.
> >>
> >>The kernel log seems pretty specific about the crash location, see below.
> >>
> >>Best regards,
> >>Daniel Kuhn
> >>
> >>
> >>[   66.476674] ------------[ cut here ]------------
> >>[   66.476684] kernel BUG at fs/btrfs/free-space-cache.c:1515!
> >>[   66.476691] invalid opcode: 0000 [#1] SMP
> >>[   66.476699] Modules linked in: tpm_tis tpm tpm_bios i2c_nforce2 serio_raw
> >>pcspkr floppy k10temp asus_atk0110 raid10 raid456 async_raid6_recov async_pq
> >>raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
> >>ata_generic nouveau ttm drm_kms_helper drm i2c_algo_bit firewire_ohci
> >>i2c_core pata_acpi mxm_wmi forcedeth pata_marvell firewire_core pata_amd
> >>video wmi
> >>[   66.476752]
> >>[   66.476759] Pid: 1844, comm: mount Not tainted 3.2.2-alt250-i586 #2
> >>System manufacturer System Product Name/M3N-HT DELUXE
> >>[   66.476772] EIP: 0060:[<c06f7b6f>] EFLAGS: 00010206 CPU: 2
> >>[   66.476785] EIP is at remove_from_bitmap+0xa8/0x285
> >>[   66.476792] EAX: 6a92c000 EBX: 00000000 ECX: 0005c000 EDX: 00000002
> >>[   66.476799] ESI: f2f5baa8 EDI: f2f5ba8c EBP: f2f5ba48 ESP: f2f5b9ec
> >>[   66.476805]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> >>[   66.476813] Process mount (pid: 1844, ti=f2f5a000 task=f2ff7080
> >>task.ti=f2f5a000)
> >>[   66.476818] Stack:
> >>[   66.476822]  f2f5ba2c 00000385 00000000 f2f5ba58 f2750370 f2f5ba48
> >>f2f5ba44 f2f5ba40
> >>[   66.476837]  00000019 71bfffff 00000002 71c00000 00000002 f3159600
> >>073ba000 00000000
> >>[   66.476851]  0005c000 00000000 6a92c000 00000002 f2f5baa8 00000000
> >>f2750370 f2f5baa0
> >>[   66.476865] Call Trace:
> >>[   66.476877]  [<c06f9bf4>] btrfs_remove_free_space+0x34c/0x370
> >>[   66.476889]  [<c06bcfa3>] btrfs_alloc_logged_file_extent+0x114/0x211
> >>[   66.476900]  [<c06af00c>] ? btrfs_free_path+0x1b/0x1e
> >>[   66.476909]  [<c06af00c>] ? btrfs_free_path+0x1b/0x1e
> >>[   66.476919]  [<c06f5afd>] replay_one_extent+0x470/0x5f2
> >>[   66.476929]  [<c050ef9a>] ? __fsnotify_inode_delete+0x8/0xa
> >>[   66.476941]  [<c06f6f55>] replay_one_buffer+0x1d6/0x229
> >>[   66.476950]  [<c06f2cfe>] walk_down_log_tree+0x15b/0x2cd
> >>[   66.476959]  [<c06f3062>] walk_log_tree+0x71/0x188
> >>[   66.476968]  [<c06f5011>] btrfs_recover_log_trees+0x24a/0x257
> >>[snip]
> >
> >-o recovery under 3.2 or later should fix it up.  You'll want to
> >remain on 3.2 at that point, and then switch to 3.3 when that's
> >released, and so on.
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
