Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:58806 "EHLO zlom.siedziba.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751398AbdHGNml (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Aug 2017 09:42:41 -0400
Received: from [192.168.9.3] (31-178-177-195.dynamic.chello.pl [31.178.177.195])
        (Authenticated sender: pp)
        by zlom.siedziba.pl (Postfix) with ESMTPSA id 529855204EF
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Aug 2017 15:37:16 +0200 (CEST)
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <btrfs@pp.siedziba.pl>
Subject: kernel BUG at
 /build/linux-H5UzH8/linux-4.10.0/fs/btrfs/extent_io.c:2318
To: linux-btrfs@vger.kernel.org
Message-ID: <b6624a14-d63f-4372-b6b8-662a61973547@siedziba.pl>
Date: Mon, 7 Aug 2017 15:26:16 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

my btrfs raid1 fs with 4 drives crashed after only one drive developed a
couple of bad blocks.

Seems similar to https://bugzilla.kernel.org/show_bug.cgi?id=196251 but
it happened during normal usage instead of during replace.

As a sidenote, I tried to make the system less noisy during the day,
when it's not doing nightly backups, by setting drives to spin down
after a few minutes. Unfortunately btrfs kept them spinning for no
reason, so I tried systemd's automount to unmount the fs when not in
use. It worked, but it seems it uncovered some kind of umount/mount race
condition, where mount unexpectedly failed with:

sie 06 03:47:39 pps kernel: BTRFS error (device dm-1): super_total_bytes 3855366488064 mismatch with fs_devices total_rw_bytes 7710732976128
sie 06 03:47:39 pps kernel: BTRFS error (device dm-1): failed to read chunk tree: -22
sie 06 03:47:39 pps kernel: BTRFS error (device dm-1): open_ctree failed

...and then the next mount worked properly as if nothing had happened.

Full log: https://pp.siedziba.pl/btrfs_raid1_fail/kernel.log

# uname -a
Linux pps 4.10.0-30-generic #34-Ubuntu SMP Mon Jul 31 19:38:17 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

# btrfs device usage /backup
/dev/mapper/pps-backup1, ID: 2
   Device size:           465.76GiB
   Device slack:              0.00B
   Data,RAID1:            387.00GiB
   Metadata,RAID1:         16.00GiB
   Unallocated:            62.76GiB

/dev/mapper/pps-backup2, ID: 8
   Device size:             1.81TiB
   Device slack:              0.00B
   Data,RAID1:              1.48TiB
   Metadata,RAID1:         26.00GiB
   System,RAID1:           32.00MiB
   Unallocated:           314.29GiB

/dev/mapper/pps-backup3, ID: 6
   Device size:           334.69GiB
   Device slack:              0.00B
   Data,RAID1:            268.00GiB
   Metadata,RAID1:          5.00GiB
   System,RAID1:           32.00MiB
   Unallocated:            61.66GiB

/dev/mapper/pps-backup4, ID: 7
   Device size:           931.51GiB
   Device slack:              0.00B
   Data,RAID1:            863.00GiB
   Metadata,RAID1:          5.00GiB
   System,RAID1:           64.00MiB
   Unallocated:            63.45GiB

# btrfs device stats /backup
[/dev/mapper/pps-backup1].write_io_errs    0
[/dev/mapper/pps-backup1].read_io_errs     0
[/dev/mapper/pps-backup1].flush_io_errs    0
[/dev/mapper/pps-backup1].corruption_errs  0
[/dev/mapper/pps-backup1].generation_errs  0
[/dev/mapper/pps-backup3].write_io_errs    0
[/dev/mapper/pps-backup3].read_io_errs     0
[/dev/mapper/pps-backup3].flush_io_errs    0
[/dev/mapper/pps-backup3].corruption_errs  0
[/dev/mapper/pps-backup3].generation_errs  0
[/dev/mapper/pps-backup4].write_io_errs    0
[/dev/mapper/pps-backup4].read_io_errs     0
[/dev/mapper/pps-backup4].flush_io_errs    0
[/dev/mapper/pps-backup4].corruption_errs  0
[/dev/mapper/pps-backup4].generation_errs  0
[/dev/mapper/pps-backup2].write_io_errs    1
[/dev/mapper/pps-backup2].read_io_errs     22
[/dev/mapper/pps-backup2].flush_io_errs    0
[/dev/mapper/pps-backup2].corruption_errs  0
[/dev/mapper/pps-backup2].generation_errs  0

sie 07 04:45:05 pps kernel: ------------[ cut here ]------------
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS info (device dm-1): csum failed ino 1340360 extent 5370531217408 csum 4180793733 wanted 722897355 mirror -2118091264
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS info (device dm-1): csum failed ino 1340360 extent 5370531217408 csum 1247241319 wanted 722897355 mirror -2118091264
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS info (device dm-1): csum failed ino 1340360 extent 5370531217408 csum 2555610504 wanted 722897355 mirror -2118091264
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS info (device dm-1): csum failed ino 1340360 extent 5370531217408 csum 2566472073 wanted 722897355 mirror -2118091264
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS info (device dm-1): csum failed ino 1340360 extent 5370531217408 csum 2377887016 wanted 722897355 mirror -2118091264
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS info (device dm-1): csum failed ino 1340360 extent 5370531217408 csum 1742047832 wanted 722897355 mirror -2118091264
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS info (device dm-1): csum failed ino 1340360 extent 5370531217408 csum 3196580372 wanted 722897355 mirror -2118091264
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS info (device dm-1): csum failed ino 1340360 extent 5370531217408 csum 1719006478 wanted 722897355 mirror -2118091264
sie 07 04:45:05 pps kernel: BTRFS info (device dm-1): csum failed ino 1340360 extent 5370531217408 csum 1459008984 wanted 722897355 mirror -2118091264
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:05 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS critical (device dm-1): stripe index math went horribly wrong, got stripe_index=2176876031, num_stripes=2
sie 07 04:45:06 pps kernel: BTRFS info (device dm-1): csum failed ino 1340360 extent 5370531217408 csum 716315696 wanted 722897355 mirror -2118091264
sie 07 04:45:06 pps kernel: kernel BUG at /build/linux-H5UzH8/linux-4.10.0/fs/btrfs/extent_io.c:2318!
sie 07 04:45:06 pps kernel: invalid opcode: 0000 [#1] SMP
sie 07 04:45:06 pps kernel: Modules linked in: xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_tcpudp bridge stp llc ip6table_filter ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6_tables iptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle binfmt_misc intel_rapl intel_soc_dts_iosf intel_powerclamp ppdev coretemp kvm_intel snd_soc_rt5670 snd_intel_sst_acpi snd_soc_rt5645 kvm snd_intel_sst_core snd_soc_sst_mfld_platform snd_hda_codec_hdmi irqbypass snd_hda_codec_realtek snd_hda_codec_generic snd_soc_rt5640 punit_atom_debug snd_soc_sst_match crct10dif_pclmul crc32_pclmul snd_soc_rl6231 ghash_clmulni_intel snd_soc_core snd_hda_intel cryptd snd_hda_codec snd_compress snd_hda_core ac97_bus intel_cstate snd_pcm_dmaengine
sie 07 04:45:06 pps kernel:  snd_hwdep hci_uart btbcm btqca btintel snd_pcm lpc_ich dw_dmac bluetooth rfkill_gpio 8250_dw dw_dmac_core spi_pxa2xx_platform parport_pc snd_timer snd pwm_lpss_platform mac_hid parport mei_txe mei soundcore i2c_designware_platform i2c_designware_core pwm_lpss shpchp sunrpc w83627ehf hwmon_vid ip_tables x_tables autofs4 btrfs xor raid6_pq 9pnet_virtio 9p 9pnet fscache uas usb_storage i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops r8169 drm mii ahci libahci video fjes i2c_hid hid sdhci_acpi sdhci
sie 07 04:45:06 pps kernel: CPU: 3 PID: 7259 Comm: kworker/u8:6 Not tainted 4.10.0-30-generic #34-Ubuntu
sie 07 04:45:06 pps kernel: Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Q1900DC-ITX, BIOS P1.20 07/08/2014
sie 07 04:45:06 pps kernel: Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
sie 07 04:45:06 pps kernel: task: ffff883849279540 task.stack: ffffa4f6c212c000
sie 07 04:45:06 pps kernel: RIP: 0010:btrfs_check_repairable+0xf2/0x100 [btrfs]
sie 07 04:45:06 pps kernel: RSP: 0018:ffffa4f6c212fcf0 EFLAGS: 00010a83
sie 07 04:45:06 pps kernel: RAX: 0000000000000001 RBX: ffff8839437de580 RCX: 0000000000000002
sie 07 04:45:06 pps kernel: RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8839745fae58
sie 07 04:45:06 pps kernel: RBP: ffffa4f6c212fd10 R08: 000004e243b00000 R09: 000004e283b00000
sie 07 04:45:06 pps kernel: R10: ffff8837957c4360 R11: 000000004e980780 R12: 000000004e980780
sie 07 04:45:06 pps kernel: R13: ffff8839745fa000 R14: ffff88394e981328 R15: ffff8837533c2ff0
sie 07 04:45:06 pps kernel: FS:  0000000000000000(0000) GS:ffff88397fd80000(0000) knlGS:0000000000000000
sie 07 04:45:06 pps kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
sie 07 04:45:06 pps kernel: CR2: 00007f035058e3a0 CR3: 0000000008c09000 CR4: 00000000001006e0
sie 07 04:45:06 pps kernel: Call Trace:
sie 07 04:45:06 pps kernel:  end_bio_extent_readpage+0x419/0x5b0 [btrfs]
sie 07 04:45:06 pps kernel:  bio_endio+0x56/0x60
sie 07 04:45:06 pps kernel:  end_workqueue_fn+0x3c/0x40 [btrfs]
sie 07 04:45:06 pps kernel:  btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
sie 07 04:45:06 pps kernel:  btrfs_endio_helper+0xe/0x10 [btrfs]
sie 07 04:45:06 pps kernel:  process_one_work+0x1fc/0x4b0
sie 07 04:45:06 pps kernel:  worker_thread+0x4b/0x500
sie 07 04:45:06 pps kernel:  kthread+0x109/0x140
sie 07 04:45:06 pps kernel:  ? process_one_work+0x4b0/0x4b0
sie 07 04:45:06 pps kernel:  ? kthread_create_on_node+0x60/0x60
sie 07 04:45:06 pps kernel:  ret_from_fork+0x2c/0x40
sie 07 04:45:06 pps kernel: Code: 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d5 8d 48 02 eb d9 45 89 e0 48 c7 c6 90 74 73 c0 4c 89 ef e8 93 a7 fa ff e9 78 ff ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 
sie 07 04:45:06 pps kernel: RIP: btrfs_check_repairable+0xf2/0x100 [btrfs] RSP: ffffa4f6c212fcf0
sie 07 04:45:06 pps kernel: ------------[ cut here ]------------
