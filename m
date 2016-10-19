Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:36429 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938984AbcJSRYz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 13:24:55 -0400
Received: by mail-it0-f44.google.com with SMTP id 139so111179437itm.1
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 10:24:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC8ULPaOMgG66w3yvtkp1UfBHmffUE2iF9dR=xaCjyeZ6J919A@mail.gmail.com>
References: <CAC8ULPbST1tMtfW8MBdEXiFSxknQtUHYneZu8FpQij5DRon_gg@mail.gmail.com>
 <CAC8ULPaOMgG66w3yvtkp1UfBHmffUE2iF9dR=xaCjyeZ6J919A@mail.gmail.com>
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date: Wed, 19 Oct 2016 20:24:53 +0300
Message-ID: <CAOE4rSy3gspKYaY0dgydoGnsFjU5xYoxddynqwar4qy-Li1piA@mail.gmail.com>
Subject: Re: btrfs partition fails to mount - kernel BUG at ../fs/btrfs/extent-tree.c:1872
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Happens for me too with 4.8.2

[ 1002.265296] BTRFS info (device vdb): disk space caching is enabled
[ 1002.265299] BTRFS info (device vdb): has skinny extents
[ 1002.952569] BTRFS info (device vdb): continuing balance
[ 1003.079696] BTRFS info (device vdb): relocating block group
655951396864 flags 17
[ 1004.028703] BTRFS info (device vdb): found 105 extents
[ 1004.956861] ------------[ cut here ]------------
[ 1004.956910] kernel BUG at fs/btrfs/extent-tree.c:1868!
[ 1004.956946] invalid opcode: 0000 [#1] PREEMPT SMP
[ 1004.956978] Modules linked in: mousedev nls_iso8859_1 nls_cp437
vfat fat kvm_amd kvm irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul input_leds
snd_intel8x0 evdev glue_helper led_class ablk_helper ppdev cryptd
mac_hid snd_ac97_codec ac97_bus psmouse snd_pcm acpi_cpufreq snd_timer
parport_pc tpm_tis tpm_tis_core snd intel_agp tpm pcspkr button
qemu_fw_cfg parport intel_gtt i2c_piix4 soundcore sch_fq_codel
ip_tables x_tables btrfs xor sd_modraid6_pq virtio_gpu drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm virtio_net
virtio_console virtio_blk virtio_balloon xhci_pci xhci_hcd serio_raw
ahci atkbd usbcore libps2 libahci i8042 ata_generic virtio_pci
pata_acpi ata_piix virtio_ring usb_common floppy serio libata
crc32c_intel virtio scsi_mod
[ 1004.957638] CPU: 5 PID: 143 Comm: kworker/u12:6 Tainted: G        W
      4.8.2-1-ARCH #1
[ 1004.957690] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[ 1004.957767] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[ 1004.957812] task: ffff880233e40e40 task.stack: ffff880233e48000
[ 1004.957851] RIP: 0010:[<ffffffffa027a35b>]  [<ffffffffa027a35b>]
update_inline_extent_backref+0x2ab/0x2b0 [btrfs]
[ 1004.957930] RSP: 0018:ffff880233e4bac8  EFLAGS: 00010293
[ 1004.957965] RAX: 0000000000000005 RBX: 00000000000025f0 RCX: 0000000000000002
[ 1004.958010] RDX: ffff880000000000 RSI: 0000000000002621 RDI: 0000000000000000
[ 1004.958055] RBP: ffff880233e4bb18 R08: 0000000000004000 R09: 0000000000000000
[ 1004.958100] R10: 0000000000002609 R11: 0000000000000002 R12: ffff88022acee348
[ 1004.958145] R13: 00000000fffffffb R14: ffff880233638540 R15: 00000000000000b2
[ 1004.958194] FS:  0000000000000000(0000) GS:ffff88023fd40000(0000)
knlGS:0000000000000000
[ 1004.958246] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1004.958283] CR2: 00007f42b0906120 CR3: 0000000233db1000 CR4: 00000000000406e0
[ 1004.958331] Stack:
[ 1004.958348]  0000000000002609 ffff880233e4bbbc ffff88022d3b9000
fffffffffffffffb
[ 1004.958406]  0000000000002608 ffff88022d3b9000 0000000000000000
ffff88023295ee60
[ 1004.958463]  ffff880233638540 000000000000007f ffff880233e4bb30
ffffffffa027ac8f
[ 1004.958519] Call Trace:
[ 1004.958553]  [<ffffffffa027ac8f>] remove_extent_backref+0x3f/0x80 [btrfs]
[ 1004.958610]  [<ffffffffa027be78>]
__btrfs_free_extent.isra.33+0x6c8/0xca0 [btrfs]
[ 1004.958674]  [<ffffffffa02803b0>]
__btrfs_run_delayed_refs+0x5b0/0x12e0 [btrfs]
[ 1004.958727]  [<ffffffff811e3150>] ? kmem_cache_free+0x1e0/0x210
[ 1004.958769]  [<ffffffff810c7306>] ? cpuacct_charge+0x86/0xa0
[ 1004.958821]  [<ffffffffa02841a1>] btrfs_run_delayed_refs+0xa1/0x2a0 [btrfs]
[ 1004.958879]  [<ffffffffa0284434>] delayed_ref_async_start+0x94/0xb0 [btrfs]
[ 1004.958939]  [<ffffffffa02d037d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[ 1004.959007]  [<ffffffffa02d067e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[ 1004.959059]  [<ffffffff81095ef5>] process_one_work+0x1e5/0x470
[ 1004.959104]  [<ffffffff810961c8>] worker_thread+0x48/0x4e0
[ 1004.959148]  [<ffffffff81096180>] ? process_one_work+0x470/0x470
[ 1004.959194]  [<ffffffff8109be38>] kthread+0xd8/0xf0
[ 1004.959233]  [<ffffffff8102c782>] ? __switch_to+0x2d2/0x630
[ 1004.960132]  [<ffffffff815f7eff>] ret_from_fork+0x1f/0x40
[ 1004.960132]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[ 1004.960132] Code: b0 e9 6b ff ff ff 41 bf 0d 00 00 00 41 bd 0d 00
00 00 e9 8f fe ff ff 0f 0b 0f 0b 44 89 e8 f7 d8 48 98 48 39 c1 0f 83
4f ff ff ff <0f> 0b 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41
55 41
[ 1004.960132] RIP  [<ffffffffa027a35b>]
update_inline_extent_backref+0x2ab/0x2b0 [btrfs]
[ 1004.960132]  RSP <ffff880233e4bac8>
[ 1004.977825] ---[ end trace 8696bc20b65a0f77 ]---
[ 1004.979754] note: kworker/u12:6[143] exited with preempt_count 2



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
