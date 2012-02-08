From: Daniel Kuhn <cheeef@swissonline.ch>
Subject: BTRFS crash during mount
Date: Wed, 08 Feb 2012 23:19:46 +0100
Message-ID: <4F32F502.6070307@swissonline.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After a forced power turn-off the filesystem of my primary boot 
partition cannot be mounted anymore,
btrfs crashes during the mount process. I'm using OpenSuse 12.1 but I've 
also tried mounting with a newer kernel 3.2.2 (systemrescue cd) and with 
a usb-converter connected to another PC without success.

The kernel log seems pretty specific about the crash location, see below.

Best regards,
Daniel Kuhn


[   66.476674] ------------[ cut here ]------------
[   66.476684] kernel BUG at fs/btrfs/free-space-cache.c:1515!
[   66.476691] invalid opcode: 0000 [#1] SMP
[   66.476699] Modules linked in: tpm_tis tpm tpm_bios i2c_nforce2 
serio_raw pcspkr floppy k10temp asus_atk0110 raid10 raid456 
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx 
raid1 raid0 multipath linear ata_generic nouveau ttm drm_kms_helper drm 
i2c_algo_bit firewire_ohci i2c_core pata_acpi mxm_wmi forcedeth 
pata_marvell firewire_core pata_amd video wmi
[   66.476752]
[   66.476759] Pid: 1844, comm: mount Not tainted 3.2.2-alt250-i586 #2 
System manufacturer System Product Name/M3N-HT DELUXE
[   66.476772] EIP: 0060:[<c06f7b6f>] EFLAGS: 00010206 CPU: 2
[   66.476785] EIP is at remove_from_bitmap+0xa8/0x285
[   66.476792] EAX: 6a92c000 EBX: 00000000 ECX: 0005c000 EDX: 00000002
[   66.476799] ESI: f2f5baa8 EDI: f2f5ba8c EBP: f2f5ba48 ESP: f2f5b9ec
[   66.476805]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   66.476813] Process mount (pid: 1844, ti=f2f5a000 task=f2ff7080 
task.ti=f2f5a000)
[   66.476818] Stack:
[   66.476822]  f2f5ba2c 00000385 00000000 f2f5ba58 f2750370 f2f5ba48 
f2f5ba44 f2f5ba40
[   66.476837]  00000019 71bfffff 00000002 71c00000 00000002 f3159600 
073ba000 00000000
[   66.476851]  0005c000 00000000 6a92c000 00000002 f2f5baa8 00000000 
f2750370 f2f5baa0
[   66.476865] Call Trace:
[   66.476877]  [<c06f9bf4>] btrfs_remove_free_space+0x34c/0x370
[   66.476889]  [<c06bcfa3>] btrfs_alloc_logged_file_extent+0x114/0x211
[   66.476900]  [<c06af00c>] ? btrfs_free_path+0x1b/0x1e
[   66.476909]  [<c06af00c>] ? btrfs_free_path+0x1b/0x1e
[   66.476919]  [<c06f5afd>] replay_one_extent+0x470/0x5f2
[   66.476929]  [<c050ef9a>] ? __fsnotify_inode_delete+0x8/0xa
[   66.476941]  [<c06f6f55>] replay_one_buffer+0x1d6/0x229
[   66.476950]  [<c06f2cfe>] walk_down_log_tree+0x15b/0x2cd
[   66.476959]  [<c06f3062>] walk_log_tree+0x71/0x188
[   66.476968]  [<c06f5011>] btrfs_recover_log_trees+0x24a/0x257
[   66.476977]  [<c06f6d7f>] ? add_inode_ref+0x480/0x480
[   66.476987]  [<c06c78b8>] open_ctree+0x116a/0x1415
[   66.476998]  [<c06ac8a6>] btrfs_mount+0x43b/0x749
[   66.477009]  [<c04bf7b1>] ? cpumask_next+0x12/0x14
[   66.477018]  [<c04c0729>] ? pcpu_alloc+0x6ca/0x6ff
[   66.477027]  [<c0768c3a>] ? ida_get_new_above+0x14a/0x164
[   66.477036]  [<c04f9aa5>] ? alloc_vfsmnt+0x80/0x111
[   66.477046]  [<c04d9236>] ? __kmalloc_track_caller+0x134/0x13e
[   66.477055]  [<c04e86bf>] mount_fs+0x62/0x139
[   66.477064]  [<c04f9ff5>] vfs_kern_mount+0x4f/0x7b
[   66.477073]  [<c04fafef>] do_kern_mount+0x38/0xb6
[   66.477082]  [<c04fb67c>] do_mount+0x60f/0x65c
[   66.477090]  [<c04bcf78>] ? strndup_user+0x29/0x3a
[   66.477098]  [<c04fb731>] sys_mount+0x68/0x94
[   66.477108]  [<c09c69bc>] syscall_call+0x7/0xb
[   66.477112] Code: e4 8d 55 e4 89 45 e8 8b 45 d8 8d 4d ec 89 14 24 8b 
55 b4 e8 c6 f8 ff ff 85 c0 78 0f 8b 55 f0 3b 57 04 8b 45 ec 75 04 3b 07 
74 04 <0f> 0b eb fe 8b 4d b4 8b 5d b4 8b 49 0c 89 4d dc 8b 4b 10 39 ca
[   66.477179] EIP: [<c06f7b6f>] remove_from_bitmap+0xa8/0x285 SS:ESP 
0068:f2f5b9ec
[   66.477235] ---[ end trace 2e72e8358ee32e95 ]---
