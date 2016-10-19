Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36299 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942191AbcJSR7s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 13:59:48 -0400
Received: by mail-it0-f66.google.com with SMTP id 66so1986536itl.3
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 10:59:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOE4rSyGW3TUG75_iRuBRJ-Ekmrmwt_BhOoXgRDNvgEL62M53g@mail.gmail.com>
References: <CAOE4rSwPNAY7fXjVa=Hyeb1yVMtVmpPhUvMVbZt6Qq9P+a0LCA@mail.gmail.com>
 <CAOE4rSxn756hHWJB9T32__dbRNeF0aQOCvCe1738G_HHqy3+Xw@mail.gmail.com>
 <bd6d731e-583c-b5f7-d95f-3ad70242297a@mendix.com> <CAOE4rSyGW3TUG75_iRuBRJ-Ekmrmwt_BhOoXgRDNvgEL62M53g@mail.gmail.com>
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date: Wed, 19 Oct 2016 20:59:46 +0300
Message-ID: <CAOE4rSz1SsAwrKNEhJB_Y7ESaRdVs2Z3Vp2ww2rdH6wQnzpAnw@mail.gmail.com>
Subject: Re: [BUG] kernel BUG at fs/btrfs/extent_io.c:2062 (v4.2.0-rc8)
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now when trying to read this one file on 4.8.2

[  131.497595] ------------[ cut here ]------------
[  131.499411] kernel BUG at fs/btrfs/extent_io.c:2315!
[  131.500786] invalid opcode: 0000 [#1] PREEMPT SMP
[  131.500786] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  131.500786] CPU: 1 PID: 145 Comm: kworker/u12:7 Not tainted 4.8.2-1-ARCH #1
[  131.500786] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  131.500786] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  131.500786] task: ffff880233f1e3c0 task.stack: ffff880233f30000
[  131.500786] RIP: 0010:[<ffffffffa02b5bec>]  [<ffffffffa02b5bec>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[  131.500786] RSP: 0018:ffff880233f33cc0  EFLAGS: 00010206
[  131.500786] RAX: 0000000000000001 RBX: ffff8802292e2f80 RCX: 0000000000000000
[  131.500786] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff880236148f70
[  131.500786] RBP: ffff880233f33cd8 R08: 0000001721c00000 R09: 0000001761c00000
[  131.500786] R10: ffffea0008d496c0 R11: 000000003294a8c0 R12: 000000003294a8c0
[  131.500786] R13: ffff88023294b5a8 R14: ffff88023294b5a8 R15: ffff8802327a2830
[  131.500786] FS:  0000000000000000(0000) GS:ffff88023fc40000(0000)
knlGS:0000000000000000
[  131.500786] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  131.500786] CR2: 00000000007477e0 CR3: 0000000002806000 CR4: 00000000000406e0
[  131.500786] Stack:
[  131.500786]  ffffea0008a2b240 00000000000a3000 ffff88023294b630
ffff880233f33d90
[  131.500786]  ffffffffa02b612f ffff880235d82d00 ffff880233f33d10
ffff880233f1e3c0
[  131.500786]  ffff880233f1e3c0 ffff88023294b540 ffff8802327a2680
0000000000000000
[  131.500786] Call Trace:
[  131.500786]  [<ffffffffa02b612f>] end_bio_extent_readpage+0x44f/0x5f0 [btrfs]
[  131.500786]  [<ffffffff812c4f93>] bio_endio+0x53/0x60
[  131.500786]  [<ffffffffa0288a0c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[  131.500786]  [<ffffffffa02c837d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[  131.500786]  [<ffffffffa02c872e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[  131.500786]  [<ffffffff81095ef5>] process_one_work+0x1e5/0x470
[  131.500786]  [<ffffffff810961c8>] worker_thread+0x48/0x4e0
[  131.500786]  [<ffffffff81096180>] ? process_one_work+0x470/0x470
[  131.500786]  [<ffffffff81096180>] ? process_one_work+0x470/0x470
[  131.500786]  [<ffffffff8109be38>] kthread+0xd8/0xf0
[  131.500786]  [<ffffffff8102c782>] ? __switch_to+0x2d2/0x630
[  131.500786]  [<ffffffff815f7eff>] ret_from_fork+0x1f/0x40
[  131.500786]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  131.500786] Code: 25 89 4b 28 e9 7c ff ff ff 44 3b 63 28 75 1c c7
43 30 00 00 00 00 c7 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d2 8d
48 02 eb d6 <0f> 0b 66 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55
41 54
[  131.500786] RIP  [<ffffffffa02b5bec>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[  131.500786]  RSP <ffff880233f33cc0>
[  132.075621] ------------[ cut here ]------------
[  132.078829] kernel BUG at fs/btrfs/extent_io.c:2315!
[  132.086719] ---[ end trace 6a5a7b58c27bde1c ]---
[  132.096386] systemd-journald[230]: Compressed data object 806 ->
744 using LZ4
[  132.086711] invalid opcode: 0000 [#2] PREEMPT SMP
[  132.086711] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  132.086711] CPU: 5 PID: 142 Comm: kworker/u12:4 Tainted: G      D
      4.8.2-1-ARCH #1
[  132.086711] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  132.086711] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  132.086711] task: ffff880233f1aac0 task.stack: ffff880233f24000
[  132.086711] RIP: 0010:[<ffffffffa02b5bec>]  [<ffffffffa02b5bec>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[  132.086711] RSP: 0018:ffff880233f27cc0  EFLAGS: 00010202
[  132.086711] RAX: 0000000000000001 RBX: ffff8802292e2240 RCX: 0000000000000000
[  132.086711] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff880236148f70
[  132.086711] RBP: ffff880233f27cd8 R08: 0000001721c00000 R09: 0000001761c00000
[  132.086711] R10: ffff88022932e870 R11: 000000003294b180 R12: 000000003294b180
[  132.086711] R13: ffff88023294af68 R14: ffff88023294af68 R15: ffff8802327a2830
[  132.086711] FS:  0000000000000000(0000) GS:ffff88023fd40000(0000)
knlGS:0000000000000000
[  132.086711] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  132.086711] CR2: 00007f1118094160 CR3: 0000000234a12000 CR4: 00000000000406e0
[  132.086711] Stack:
[  132.086711]  ffffea0008a2b1c0 00000000000a1000 ffff88023294aff0
ffff880233f27d90
[  132.086711]  ffffffffa02b612f 00000001801c0019 ffff880233f27d10
ffff880233f1aac0
[  132.086711]  ffff880233f1aac0 ffff88023294af00 ffff8802327a2680
0000000000000000
[  132.086711] Call Trace:
[  132.086711]  [<ffffffffa02b612f>] end_bio_extent_readpage+0x44f/0x5f0 [btrfs]
[  132.086711]  [<ffffffff812c4f93>] bio_endio+0x53/0x60
[  132.086711]  [<ffffffffa0288a0c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[  132.086711]  [<ffffffffa02c837d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[  132.086711]  [<ffffffffa02c872e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[  132.086711]  [<ffffffff81095ef5>] process_one_work+0x1e5/0x470
[  132.086711]  [<ffffffff810961c8>] worker_thread+0x48/0x4e0
[  132.086711]  [<ffffffff81096180>] ? process_one_work+0x470/0x470
[  132.086711]  [<ffffffff8109be38>] kthread+0xd8/0xf0
[  132.086711]  [<ffffffff8102c782>] ? __switch_to+0x2d2/0x630
[  132.086711]  [<ffffffff815f7eff>] ret_from_fork+0x1f/0x40
[  132.086711]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  132.086711] Code: 25 89 4b 28 e9 7c ff ff ff 44 3b 63 28 75 1c c7
43 30 00 00 00 00 c7 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d2 8d
48 02 eb d6 <0f> 0b 66 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55
41 54
[  132.086711] RIP  [<ffffffffa02b5bec>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[  132.086711]  RSP <ffff880233f27cc0>
[  133.028698] BUG: unable to handle kernel paging request at 00000000c70566d9
[  133.095163] ---[ end trace 6a5a7b58c27bde1d ]---
[  133.028698] IP: [<ffffffff810bfd1b>] __wake_up_common+0x2b/0x80
[  133.116711] PGD 0
[  133.116711] Oops: 0000 [#3] PREEMPT SMP
[  133.116711] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  133.116711] CPU: 1 PID: 145 Comm: kworker/u12:7 Tainted: G      D
      4.8.2-1-ARCH #1
[  133.116711] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  133.116711] task: ffff880233f1e3c0 task.stack: ffff880233f30000
[  133.116711] RIP: 0010:[<ffffffff810bfd1b>]  [<ffffffff810bfd1b>]
__wake_up_common+0x2b/0x80
[  133.116711] RSP: 0018:ffff880233f33e40  EFLAGS: 00010096
[  133.116711] RAX: 0000000000000282 RBX: ffff880233f33f10 RCX: 0000000000000000
[  133.116711] RDX: 00000000c70566d9 RSI: 0000000000000003 RDI: ffff880233f33f10
[  133.116711] RBP: ffff880233f33e78 R08: 0000000000000000 R09: 0000000000000024
[  133.116711] R10: ffffffff81805200 R11: 0000000000073618 R12: ffff880233f33f18
[  133.116711] R13: 0000000000000282 R14: 0000000000000000 R15: 0000000000000003
[  133.116711] FS:  0000000000000000(0000) GS:ffff88023fc40000(0000)
knlGS:0000000000000000
[  133.116711] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.116711] CR2: 0000000000000028 CR3: 0000000002806000 CR4: 00000000000406e0
[  133.116711] Stack:
[  133.116711]  0000000100000088 0000000000000000 ffff880233f33f10
ffff880233f33f08
[  133.116711]  0000000000000282 0000000000000000 0000000000000000
ffff880233f33e88
[  133.116711]  ffffffff810bfdd3 ffff880233f33eb0 ffffffff810c0827
ffff880233f1ead0
[  133.116711] Call Trace:
[  133.116711]  [<ffffffff810bfdd3>] __wake_up_locked+0x13/0x20
[  133.116711]  [<ffffffff810c0827>] complete+0x37/0x50
[  133.116711]  [<ffffffff81079eef>] mm_release+0xbf/0x140
[  133.116711]  [<ffffffff81080bcf>] do_exit+0x7af/0xb50
[  133.116711]  [<ffffffff815f9497>] rewind_stack_do_exit+0x17/0x20
[  133.116711]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  133.116711] Code: 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41
54 4c 8d 67 08 53 41 89 f7 48 83 ec 10 89 55 cc 48 8b 57 08 4c 89 45
d0 49 39 d4 <48> 8b 32 74 40 48 8d 42 e8 4c 8d 6e e8 41 89 ce 8b 18 48
8b 4d
[  133.116711] RIP  [<ffffffff810bfd1b>] __wake_up_common+0x2b/0x80
[  133.116711]  RSP <ffff880233f33e40>
[  133.116711] CR2: 00000000c70566d9
[  133.116711] ---[ end trace 6a5a7b58c27bde1e ]---
[  132.085895] ------------[ cut here ]------------
[  132.085895] kernel BUG at fs/btrfs/extent_io.c:2315!
[  132.085895] invalid opcode: 0000 [#4] PREEMPT SMP
[  132.085895] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  132.085895] CPU: 2 PID: 72 Comm: kworker/u12:1 Tainted: G      D
     4.8.2-1-ARCH #1
[  132.085895] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  132.085895] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  132.085895] task: ffff88023449e3c0 task.stack: ffff880234530000
[  132.085895] RIP: 0010:[<ffffffffa02b5bec>]  [<ffffffffa02b5bec>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[  132.085895] RSP: 0018:ffff880234533cc0  EFLAGS: 00010206
[  132.085895] RAX: 0000000000000001 RBX: ffff8802292e2140 RCX: 0000000000000000
[  132.085895] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff880236148f70
[  132.085895] RBP: ffff880234533cd8 R08: 0000001721c00000 R09: 0000001761c00000
[  132.085895] R10: ffff88022932e2d0 R11: 000000003294b400 R12: 000000003294b400
[  132.085895] R13: ffff88023294a7e8 R14: ffff88023294a7e8 R15: ffff8802327a2830
[  132.085895] FS:  0000000000000000(0000) GS:ffff88023fc80000(0000)
knlGS:0000000000000000
[  132.085895] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  132.085895] CR2: 0000000000e08000 CR3: 000000022ab61000 CR4: 00000000000406e0
[  132.085895] Stack:
[  132.085895]  ffffea0008a2b680 00000000000a0000 ffff88023294a870
ffff880234533d90
[  132.085895]  ffffffffa02b612f 00000001801c0018 ffff880234533d20
ffff88023449e3c0
[  132.085895]  ffff88023449e3c0 ffff88023294a780 ffff8802327a2680
0000000000000000
[  132.085895] Call Trace:
[  132.085895]  [<ffffffffa02b612f>] end_bio_extent_readpage+0x44f/0x5f0 [btrfs]
[  132.085895]  [<ffffffff812c4f93>] bio_endio+0x53/0x60
[  132.085895]  [<ffffffffa0288a0c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[  132.085895]  [<ffffffffa02c837d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[  132.085895]  [<ffffffffa02c872e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[  132.085895]  [<ffffffff81095ef5>] process_one_work+0x1e5/0x470
[  132.085895]  [<ffffffff810961c8>] worker_thread+0x48/0x4e0
[  132.085895]  [<ffffffff81096180>] ? process_one_work+0x470/0x470
[  132.085895]  [<ffffffff8109be38>] kthread+0xd8/0xf0
[  132.085895]  [<ffffffff8102c782>] ? __switch_to+0x2d2/0x630
[  132.085895]  [<ffffffff815f7eff>] ret_from_fork+0x1f/0x40
[  132.085895]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  132.085895] Code: 25 89 4b 28 e9 7c ff ff ff 44 3b 63 28 75 1c c7
43 30 00 00 00 00 c7 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d2 8d
48 02 eb d6 <0f> 0b 66 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55
41 54
[  132.085895] RIP  [<ffffffffa02b5bec>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[  132.085895]  RSP <ffff880234533cc0>
[  133.107915] ------------[ cut here ]------------
[  133.107915] kernel BUG at fs/btrfs/extent_io.c:2315!
[  133.107915] invalid opcode: 0000 [#5] PREEMPT SMP
[  133.107915] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  133.107915] CPU: 4 PID: 6 Comm: kworker/u12:0 Tainted: G      D
    4.8.2-1-ARCH #1
[  133.107915] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  133.107915] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  133.107915] task: ffff8802361c5580 task.stack: ffff880236218000
[  133.107915] RIP: 0010:[<ffffffffa02b5bec>]  [<ffffffffa02b5bec>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[  133.107915] RSP: 0018:ffff88023621bcc0  EFLAGS: 00010206
[  133.107915] RAX: 0000000000000001 RBX: ffff8802292e24c0 RCX: 0000000000000000
[  133.107915] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff880236148f70
[  133.107915] RBP: ffff88023621bcd8 R08: 0000001721c00000 R09: 0000001761c00000
[  133.107915] R10: ffff88022932ecf0 R11: 000000003294a3c0 R12: 000000003294a3c0
[  133.107915] R13: ffff88023294b828 R14: ffff88023294b828 R15: ffff8802327a2830
[  133.107915] FS:  0000000000000000(0000) GS:ffff88023fd00000(0000)
knlGS:0000000000000000
[  133.107915] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.107915] CR2: 00007f739b2a1010 CR3: 0000000233397000 CR4: 00000000000406e0
[  133.107915] Stack:
[  133.107915]  ffffea0008a2b200 00000000000a2000 ffff88023294b8b0
ffff88023621bd90
[  133.107915]  ffffffffa02b612f 00000001801c0016 ffff88023621bd20
ffff8802361c5580
[  133.107915]  ffff8802361c5580 ffff88023294b7c0 ffff8802327a2680
0000000000000000
[  133.107915] Call Trace:
[  133.107915]  [<ffffffffa02b612f>] end_bio_extent_readpage+0x44f/0x5f0 [btrfs]
[  133.107915]  [<ffffffff812c4f93>] bio_endio+0x53/0x60
[  133.107915]  [<ffffffffa0288a0c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[  133.107915]  [<ffffffffa02c837d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[  133.107915]  [<ffffffffa02c872e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[  133.107915]  [<ffffffff81095ef5>] process_one_work+0x1e5/0x470
[  133.107915]  [<ffffffff810961c8>] worker_thread+0x48/0x4e0
[  133.107915]  [<ffffffff81096180>] ? process_one_work+0x470/0x470
[  133.107915]  [<ffffffff8109be38>] kthread+0xd8/0xf0
[  133.107915]  [<ffffffff8102c782>] ? __switch_to+0x2d2/0x630
[  133.107915]  [<ffffffff815f7eff>] ret_from_fork+0x1f/0x40
[  133.107915]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  133.107915] Code: 25 89 4b 28 e9 7c ff ff ff 44 3b 63 28 75 1c c7
43 30 00 00 00 00 c7 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d2 8d
48 02 eb d6 <0f> 0b 66 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55
41 54
[  133.107915] RIP  [<ffffffffa02b5bec>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[  133.107915]  RSP <ffff88023621bcc0>
[  133.948564] ---[ end trace 6a5a7b58c27bde1f ]---
[  133.948594] BUG: unable to handle kernel paging request at 00000000e3c8f6ef
[  133.948601] IP: [<ffffffff810bfd1b>] __wake_up_common+0x2b/0x80
[  133.948604] PGD 22a005067 PUD 0
[  133.948606] Oops: 0000 [#6] PREEMPT SMP
[  133.948645] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  133.948653] CPU: 2 PID: 72 Comm: kworker/u12:1 Tainted: G      D
     4.8.2-1-ARCH #1
[  133.948654] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  133.948685] task: ffff88023449e3c0 task.stack: ffff880234530000
[  133.948691] RIP: 0010:[<ffffffff810bfd1b>]  [<ffffffff810bfd1b>]
__wake_up_common+0x2b/0x80
[  133.948693] RSP: 0018:ffff880234533e40  EFLAGS: 00010092
[  133.948694] RAX: 0000000000000282 RBX: ffff880234533f10 RCX: 0000000000000000
[  133.948696] RDX: 00000000e3c8f6ef RSI: 0000000000000003 RDI: ffff880234533f10
[  133.948697] RBP: ffff880234533e78 R08: 0000000000000000 R09: 0000000000000024
[  133.948699] R10: ffffffff81805200 R11: 000000000006fd28 R12: ffff880234533f18
[  133.948700] R13: 0000000000000282 R14: 0000000000000000 R15: 0000000000000003
[  133.948705] FS:  0000000000000000(0000) GS:ffff88023fc80000(0000)
knlGS:0000000000000000
[  133.948707] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.948708] CR2: 0000000000000028 CR3: 000000022ab61000 CR4: 00000000000406e0
[  133.948713] Stack:
[  133.948717]  0000000100000088 0000000000000000 ffff880234533f10
ffff880234533f08
[  133.948720]  0000000000000282 0000000000000000 0000000000000000
ffff880234533e88
[  133.948724]  ffffffff810bfdd3 ffff880234533eb0 ffffffff810c0827
ffff88023449ead0
[  133.948724] Call Trace:
[  133.948730]  [<ffffffff810bfdd3>] __wake_up_locked+0x13/0x20
[  133.948733]  [<ffffffff810c0827>] complete+0x37/0x50
[  133.948737]  [<ffffffff81079eef>] mm_release+0xbf/0x140
[  133.948741]  [<ffffffff81080bcf>] do_exit+0x7af/0xb50
[  133.948745]  [<ffffffff815f9497>] rewind_stack_do_exit+0x17/0x20
[  133.948749]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  133.948780] Code: 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41
54 4c 8d 67 08 53 41 89 f7 48 83 ec 10 89 55 cc 48 8b 57 08 4c 89 45
d0 49 39 d4 <48> 8b 32 74 40 48 8d 42 e8 4c 8d 6e e8 41 89 ce 8b 18 48
8b 4d
[  133.948783] RIP  [<ffffffff810bfd1b>] __wake_up_common+0x2b/0x80
[  133.948784]  RSP <ffff880234533e40>
[  133.948785] CR2: 00000000e3c8f6ef
[  133.948788] ---[ end trace 6a5a7b58c27bde20 ]---
[  133.948789] Fixing recursive fault but reboot is needed!
[  133.948791] BUG: scheduling while atomic: kworker/u12:1/72/0x00000003
[  133.948828] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  133.948837] CPU: 2 PID: 72 Comm: kworker/u12:1 Tainted: G      D
     4.8.2-1-ARCH #1
[  133.948838] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  133.948857]  0000000000000086 00000000e3c8f6ef ffff880234533e50
ffffffff812fe280
[  133.948861]  ffff88023fc97f80 0000000000000009 ffff880234533e60
ffffffff810a3434
[  133.948864]  ffff880234533eb8 ffffffff815f3bc0 00ffffff811760fd
ffff880200000008
[  133.948865] Call Trace:
[  133.948886]  [<ffffffff812fe280>] dump_stack+0x63/0x83
[  133.948891]  [<ffffffff810a3434>] __schedule_bug+0x54/0x70
[  133.948894]  [<ffffffff815f3bc0>] __schedule+0x600/0x780
[  133.948896]  [<ffffffff815f3d7c>] schedule+0x3c/0x90
[  133.948900]  [<ffffffff81080d59>] do_exit+0x939/0xb50
[  133.948904]  [<ffffffff815f9497>] rewind_stack_do_exit+0x17/0x20
[  133.948908]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  133.948920] BUG: unable to handle kernel paging request at ffffffffffffffd8
[  133.948923] IP: [<ffffffff8109c370>] kthread_data+0x10/0x20
[  133.948933] PGD 2809067 PUD 280b067 PMD 0
[  133.948935] Oops: 0000 [#7] PREEMPT SMP
[  133.948973] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  133.948982] CPU: 2 PID: 72 Comm: kworker/u12:1 Tainted: G      D W
     4.8.2-1-ARCH #1
[  133.948983] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  133.949000] task: ffff88023449e3c0 task.stack: ffff880234530000
[  133.949004] RIP: 0010:[<ffffffff8109c370>]  [<ffffffff8109c370>]
kthread_data+0x10/0x20
[  133.949005] RSP: 0018:ffff880234533e50  EFLAGS: 00010002
[  133.949007] RAX: 0000000000000000 RBX: ffff88023fc97f80 RCX: 0000000000000002
[  133.949008] RDX: ffff8802370050c0 RSI: ffff88023449e440 RDI: ffff88023449e3c0
[  133.949009] RBP: ffff880234533e50 R08: 00000000ffffffff R09: 0000000000000000
[  133.949011] R10: 0000000000000000 R11: 0000000000056400 R12: ffff88023449e980
[  133.949012] R13: ffff88023fc97f80 R14: ffff88023449e3c0 R15: 0000000000017f80
[  133.949018] FS:  0000000000000000(0000) GS:ffff88023fc80000(0000)
knlGS:0000000000000000
[  133.949019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.949021] CR2: 0000000000000028 CR3: 000000022ab61000 CR4: 00000000000406e0
[  133.949025] Stack:
[  133.949029]  ffff880234533e60 ffffffff81096aae ffff880234533eb8
ffffffff815f3ae7
[  133.949032]  00ffffff811760fd ffff880200000008 ffff88023449e3c0
ffff880234533e98
[  133.949036]  ffff880234534000 0000000000000009 ffff880234533d98
00000000e3c8f6ef
[  133.949037] Call Trace:
[  133.949041]  [<ffffffff81096aae>] wq_worker_sleeping+0xe/0x80
[  133.949044]  [<ffffffff815f3ae7>] __schedule+0x527/0x780
[  133.949047]  [<ffffffff815f3d7c>] schedule+0x3c/0x90
[  133.949050]  [<ffffffff81080d59>] do_exit+0x939/0xb50
[  133.949054]  [<ffffffff815f9497>] rewind_stack_do_exit+0x17/0x20
[  133.949057]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  133.949089] Code: 89 df e8 e4 d5 fd ff e9 3c ff ff ff 0f 1f 44 00
00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 60 05 00 00
55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
00 00
[  133.949092] RIP  [<ffffffff8109c370>] kthread_data+0x10/0x20
[  133.949093]  RSP <ffff880234533e50>
[  133.949095] CR2: ffffffffffffffd8
[  133.949096] ---[ end trace 6a5a7b58c27bde21 ]---
[  133.949097] Fixing recursive fault but reboot is needed!
[  133.949099] BUG: scheduling while atomic: kworker/u12:1/72/0x00000003
[  133.949145] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  133.949154] CPU: 2 PID: 72 Comm: kworker/u12:1 Tainted: G      D W
     4.8.2-1-ARCH #1
[  133.949155] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  133.949174]  0000000000000086 00000000e3c8f6ef ffff880234533e50
ffffffff812fe280
[  133.949177]  ffff88023fc97f80 0000000000000009 ffff880234533e60
ffffffff810a3434
[  133.949180]  ffff880234533eb8 ffffffff815f3bc0 00ffffff811760fd
ffff880200000008
[  133.949181] Call Trace:
[  133.949185]  [<ffffffff812fe280>] dump_stack+0x63/0x83
[  133.949189]  [<ffffffff810a3434>] __schedule_bug+0x54/0x70
[  133.949191]  [<ffffffff815f3bc0>] __schedule+0x600/0x780
[  133.949194]  [<ffffffff815f3d7c>] schedule+0x3c/0x90
[  133.949197]  [<ffffffff81080d59>] do_exit+0x939/0xb50
[  133.949201]  [<ffffffff815f9497>] rewind_stack_do_exit+0x17/0x20
[  133.949204]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  133.098411] BUG: unable to handle kernel paging request at 00000000c6d63b2c
[  133.098411] IP: [<ffffffff810bfd1b>] __wake_up_common+0x2b/0x80
[  133.098411] PGD 0
[  133.098411] Oops: 0000 [#8] PREEMPT SMP
[  133.098411] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  133.098411] CPU: 5 PID: 142 Comm: kworker/u12:4 Tainted: G      D W
      4.8.2-1-ARCH #1
[  133.098411] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  133.098411] task: ffff880233f1aac0 task.stack: ffff880233f24000
[  133.098411] RIP: 0010:[<ffffffff810bfd1b>]  [<ffffffff810bfd1b>]
__wake_up_common+0x2b/0x80
[  133.098411] RSP: 0018:ffff880233f27e40  EFLAGS: 00010092
[  133.098411] RAX: 0000000000000282 RBX: ffff880233f27f10 RCX: 0000000000000000
[  133.098411] RDX: 00000000c6d63b2c RSI: 0000000000000003 RDI: ffff880233f27f10
[  133.098411] RBP: ffff880233f27e78 R08: 0000000000000000 R09: 0000000000000024
[  133.098411] R10: ffffffff81805200 R11: 000000000007271c R12: ffff880233f27f18
[  133.098411] R13: 0000000000000282 R14: 0000000000000000 R15: 0000000000000003
[  133.098411] FS:  0000000000000000(0000) GS:ffff88023fd40000(0000)
knlGS:0000000000000000
[  133.098411] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.098411] CR2: 0000000000000028 CR3: 0000000234a12000 CR4: 00000000000406e0
[  133.098411] Stack:
[  133.098411]  0000000100000088 0000000000000000 ffff880233f27f10
ffff880233f27f08
[  133.098411]  0000000000000282 0000000000000000 0000000000000000
ffff880233f27e88
[  133.098411]  ffffffff810bfdd3 ffff880233f27eb0 ffffffff810c0827
ffff880233f1b1d0
[  133.098411] Call Trace:
[  133.098411]  [<ffffffff810bfdd3>] __wake_up_locked+0x13/0x20
[  133.098411]  [<ffffffff810c0827>] complete+0x37/0x50
[  133.098411]  [<ffffffff81079eef>] mm_release+0xbf/0x140
[  133.098411]  [<ffffffff81080bcf>] do_exit+0x7af/0xb50
[  133.098411]  [<ffffffff815f9497>] rewind_stack_do_exit+0x17/0x20
[  133.098411]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  133.098411] Code: 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41
54 4c 8d 67 08 53 41 89 f7 48 83 ec 10 89 55 cc 48 8b 57 08 4c 89 45
d0 49 39 d4 <48> 8b 32 74 40 48 8d 42 e8 4c 8d 6e e8 41 89 ce 8b 18 48
8b 4d
[  133.098411] RIP  [<ffffffff810bfd1b>] __wake_up_common+0x2b/0x80
[  133.098411]  RSP <ffff880233f27e40>
[  133.098411] CR2: 00000000c6d63b2c
[  133.098411] ---[ end trace 6a5a7b58c27bde22 ]---
[  133.098411] Fixing recursive fault but reboot is needed!
[  133.098411] BUG: scheduling while atomic: kworker/u12:4/142/0x00000003
[  133.098411] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  133.098411] CPU: 5 PID: 142 Comm: kworker/u12:4 Tainted: G      D W
      4.8.2-1-ARCH #1
[  133.098411] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  133.098411]  0000000000000086 00000000c6d63b2c ffff880233f27e50
ffffffff812fe280
[  133.098411]  ffff88023fd57f80 0000000000000009 ffff880233f27e60
ffffffff810a3434
[  133.098411]  ffff880233f27eb8 ffffffff815f3bc0 00ffffff811760fd
ffff880200000008
[  133.098411] Call Trace:
[  133.098411]  [<ffffffff812fe280>] dump_stack+0x63/0x83
[  133.098411]  [<ffffffff810a3434>] __schedule_bug+0x54/0x70
[  133.098411]  [<ffffffff815f3bc0>] __schedule+0x600/0x780
[  133.098411]  [<ffffffff815f3d7c>] schedule+0x3c/0x90
[  133.098411]  [<ffffffff81080d59>] do_exit+0x939/0xb50
[  133.098411]  [<ffffffff815f9497>] rewind_stack_do_exit+0x17/0x20
[  133.098411]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  133.098411] BUG: unable to handle kernel paging request at ffffffffffffffd8
[  133.098411] IP: [<ffffffff8109c370>] kthread_data+0x10/0x20
[  133.098411] PGD 2809067 PUD 280b067 PMD 0
[  133.098411] Oops: 0000 [#9] PREEMPT SMP
[  133.098411] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  133.098411] CPU: 5 PID: 142 Comm: kworker/u12:4 Tainted: G      D W
      4.8.2-1-ARCH #1
[  133.098411] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  133.098411] task: ffff880233f1aac0 task.stack: ffff880233f24000
[  133.098411] RIP: 0010:[<ffffffff8109c370>]  [<ffffffff8109c370>]
kthread_data+0x10/0x20
[  133.098411] RSP: 0018:ffff880233f27e50  EFLAGS: 00010002
[  133.098411] RAX: 0000000000000000 RBX: ffff88023fd57f80 RCX: 0000000000000005
[  133.098411] RDX: ffff8802370050c0 RSI: ffff880233f1ab40 RDI: ffff880233f1aac0
[  133.098411] RBP: ffff880233f27e50 R08: 00000000ffffffff R09: 0000000000000000
[  133.098411] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880233f1b080
[  133.098411] R13: ffff88023fd57f80 R14: ffff880233f1aac0 R15: 0000000000017f80
[  133.098411] FS:  0000000000000000(0000) GS:ffff88023fd40000(0000)
knlGS:0000000000000000
[  133.098411] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.098411] CR2: 0000000000000028 CR3: 0000000234a12000 CR4: 00000000000406e0
[  133.098411] Stack:
[  133.098411]  ffff880233f27e60 ffffffff81096aae ffff880233f27eb8
ffffffff815f3ae7
[  133.098411]  00ffffff811760fd ffff880200000008 ffff880233f1aac0
ffff880233f27e98
[  133.098411]  ffff880233f28000 0000000000000009 ffff880233f27d98
00000000c6d63b2c
[  133.098411] Call Trace:
[  133.098411]  [<ffffffff81096aae>] wq_worker_sleeping+0xe/0x80
[  133.098411]  [<ffffffff815f3ae7>] __schedule+0x527/0x780
[  133.098411]  [<ffffffff815f3d7c>] schedule+0x3c/0x90
[  133.098411]  [<ffffffff81080d59>] do_exit+0x939/0xb50
[  133.098411]  [<ffffffff815f9497>] rewind_stack_do_exit+0x17/0x20
[  133.098411]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  133.098411] Code: 89 df e8 e4 d5 fd ff e9 3c ff ff ff 0f 1f 44 00
00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 60 05 00 00
55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
00 00
[  133.098411] RIP  [<ffffffff8109c370>] kthread_data+0x10/0x20
[  133.098411]  RSP <ffff880233f27e50>
[  133.098411] CR2: ffffffffffffffd8
[  133.098411] ---[ end trace 6a5a7b58c27bde23 ]---
[  133.098411] Fixing recursive fault but reboot is needed!
[  133.098411] BUG: scheduling while atomic: kworker/u12:4/142/0x00000003
[  133.098411] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  133.098411] CPU: 5 PID: 142 Comm: kworker/u12:4 Tainted: G      D W
      4.8.2-1-ARCH #1
[  133.098411] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  133.098411]  0000000000000086 00000000c6d63b2c ffff880233f27e50
ffffffff812fe280
[  133.098411]  ffff88023fd57f80 0000000000000009 ffff880233f27e60
ffffffff810a3434
[  133.098411]  ffff880233f27eb8 ffffffff815f3bc0 00ffffff811760fd
ffff880200000008
[  133.098411] Call Trace:
[  133.098411]  [<ffffffff812fe280>] dump_stack+0x63/0x83
[  133.098411]  [<ffffffff810a3434>] __schedule_bug+0x54/0x70
[  133.098411]  [<ffffffff815f3bc0>] __schedule+0x600/0x780
[  133.098411]  [<ffffffff815f3d7c>] schedule+0x3c/0x90
[  133.098411]  [<ffffffff81080d59>] do_exit+0x939/0xb50
[  133.098411]  [<ffffffff815f9497>] rewind_stack_do_exit+0x17/0x20
[  133.098411]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  133.954423] ---[ end trace 6a5a7b58c27bde24 ]---
[  133.954450] BUG: unable to handle kernel paging request at 000000008ee59acd
[  133.954457] IP: [<ffffffff810bfd1b>] __wake_up_common+0x2b/0x80
[  133.954460] PGD 0
[  133.954463] Oops: 0000 [#10] PREEMPT SMP
[  133.954520] Modules linked in: rpcsec_gss_krb5 auth_rpcgss
oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache kvm_amd
mousedev kvm irqbypass crct10dif_pclmul crc32_pclmul nls_iso8859_1
ghash_clmulni_intel nls_cp437 aesni_intel vfat snd_intel8x0 input_leds
aes_x86_64 fat ppdev evdev snd_ac97_codec led_class ac97_bus lrw
snd_pcm snd_timer gf128mul glue_helper ablk_helper acpi_cpufreq cryptd
mac_hid snd psmouse pcspkr tpm_tis intel_agp parport_pc soundcore
intel_gtt qemu_fw_cfg i2c_piix4 tpm_tis_core parport tpm button
sch_fq_codel ip_tables x_tables btrfs xor raid6_pq virtio_gpu
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
sd_mod virtio_balloon virtio_console virtio_blk virtio_net ata_generic
drm pata_acpi xhci_pci xhci_hcd ahci serio_raw virtio_pci atkbd libps2
libahci usbcore ata_piix virtio_ring libata scsi_mod usb_common virtio
crc32c_intel i8042 serio floppy
[  133.954531] CPU: 4 PID: 6 Comm: kworker/u12:0 Tainted: G      D W
    4.8.2-1-ARCH #1
[  133.954533] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[  133.954551] task: ffff8802361c5580 task.stack: ffff880236218000
[  133.954556] RIP: 0010:[<ffffffff810bfd1b>]  [<ffffffff810bfd1b>]
__wake_up_common+0x2b/0x80
[  133.954558] RSP: 0018:ffff88023621be40  EFLAGS: 00010096
[  133.954560] RAX: 0000000000000282 RBX: ffff88023621bf10 RCX: 0000000000000000
[  133.954562] RDX: 000000008ee59acd RSI: 0000000000000003 RDI: ffff88023621bf10
[  133.954564] RBP: ffff88023621be78 R08: 0000000000000000 R09: 0000000000000024
[  133.954565] R10: ffffffff81805200 R11: 000000000006aa28 R12: ffff88023621bf18
[  133.954567] R13: 0000000000000282 R14: 0000000000000000 R15: 0000000000000003
[  133.954572] FS:  0000000000000000(0000) GS:ffff88023fd00000(0000)
knlGS:0000000000000000
[  133.954573] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.954575] CR2: 0000000000000028 CR3: 0000000233397000 CR4: 00000000000406e0
[  133.954580] Stack:
[  133.954585]  0000000100000088 0000000000000000 ffff88023621bf10
ffff88023621bf08
[  133.954589]  0000000000000282 0000000000000000 0000000000000000
ffff88023621be88
[  133.954593]  ffffffff810bfdd3 ffff88023621beb0 ffffffff810c0827
ffff8802361c5c90
[  133.954594] Call Trace:
[  133.954600]  [<ffffffff810bfdd3>] __wake_up_locked+0x13/0x20
[  133.954603]  [<ffffffff810c0827>] complete+0x37/0x50
[  133.954606]  [<ffffffff81079eef>] mm_release+0xbf/0x140
[  133.954610]  [<ffffffff81080bcf>] do_exit+0x7af/0xb50
[  133.954615]  [<ffffffff815f9497>] rewind_stack_do_exit+0x17/0x20
[  133.954619]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[  133.954701] Code: 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41
54 4c 8d 67 08 53 41 89 f7 48 83 ec 10 89 55 cc 48 8b 57 08 4c 89 45
d0 49 39 d4 <48> 8b 32 74 40 48 8d 42 e8 4c 8d 6e e8 41 89 ce 8b 18 48
8b 4d
[  133.954705] RIP  [<ffffffff810bfd1b>] __wake_up_common+0x2b/0x80
[  133.954706]  RSP <ffff88023621be40>
[  133.954707] CR2: 000000008ee59acd
[  133.954710] ---[ end trace 6a5a7b58c27bde25 ]---



Label: 'RAID1'  uuid: 247e6249-6de1-45cb-9dd0-fa8a654234bf
        Total devices 2 FS bytes used 360.15GiB
        devid    1 size 2.73TiB used 363.03GiB path /dev/vdb
        devid    2 size 2.73TiB used 363.03GiB path /dev/vda


Overall:
    Device size:                   5.46TiB
    Device allocated:            726.06GiB
    Device unallocated:            4.75TiB
    Device missing:                  0.00B
    Used:                        720.30GiB
    Free (estimated):              2.38TiB      (min: 2.38TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:360.00GiB, Used:358.52GiB
   /dev/vda      360.00GiB
   /dev/vdb      360.00GiB

Metadata,RAID1: Size:3.00GiB, Used:1.63GiB
   /dev/vda        3.00GiB
   /dev/vdb        3.00GiB

System,RAID1: Size:32.00MiB, Used:80.00KiB
   /dev/vda       32.00MiB
   /dev/vdb       32.00MiB

Unallocated:
   /dev/vda        2.37TiB
   /dev/vdb        2.37TiB


Data, RAID1: total=360.00GiB, used=358.52GiB
System, RAID1: total=32.00MiB, used=80.00KiB
Metadata, RAID1: total=3.00GiB, used=1.63GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
