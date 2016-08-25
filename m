Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:35122 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbcHYUN7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 16:13:59 -0400
Received: by mail-ua0-f175.google.com with SMTP id n59so103432847uan.2
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 13:13:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC8ULPbST1tMtfW8MBdEXiFSxknQtUHYneZu8FpQij5DRon_gg@mail.gmail.com>
References: <CAC8ULPbST1tMtfW8MBdEXiFSxknQtUHYneZu8FpQij5DRon_gg@mail.gmail.com>
From: Robert Munteanu <robert.munteanu@gmail.com>
Date: Thu, 25 Aug 2016 23:06:46 +0300
Message-ID: <CAC8ULPaOMgG66w3yvtkp1UfBHmffUE2iF9dR=xaCjyeZ6J919A@mail.gmail.com>
Subject: Re: btrfs partition fails to mount - kernel BUG at ../fs/btrfs/extent-tree.c:1872
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 25, 2016 at 1:19 AM, Robert Munteanu
<robert.munteanu@gmail.com> wrote:
> I've managed to capture one of the error messages,
> but via screenshot only.


And here's the full output below, via netconsole

[ 2806.245627] BTRFS error (device sda1): Duplicate entries in free
space cache, dumping
[ 2806.277699] ------------[ cut here ]------------
[ 2806.277733] kernel BUG at ../fs/btrfs/extent-tree.c:1872!
[ 2806.277748] invalid opcode: 0000 [#1] PREEMPT SMP
[ 2806.277759] Modules linked in: netconsole configfs af_packet
nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit
ip6t_REJECT nf_reject_ipv6 xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_raw ipt_REJECT nf_reject_ipv4 iptable_raw xt_CT
iptable_filter btrfs snd_hda_codec_hdmi ip6table_mangle
nf_conntrack_ipv4 nf_defrag_ipv4 snd_hda_codec_realtek xor ip_tables
snd_hda_codec_generic intel_rapl snd_hda_intel xt_conntrack
snd_hda_codec nf_conntrack x86_pkg_temp_thermal
i2c_designware_platform raid1 snd_hda_core intel_powerclamp 8250_dw
i2c_designware_core snd_hwdep md_mod joydev raid6_pq coretemp snd_pcm
idma64 hci_uart virt_dma firewire_ohci iTCO_wdt kvm_intel snd_timer
snd ip6table_filter btbcm firewire_core iTCO_vendor_support btqca
intel_lpss_pci kvm acpi_als btintel ip6_tables irqbypass bluetooth
pinctrl_sunrisepoint rfkill intel_lpss_acpi mei_me intel_lpss mfd_core
battery mei shpchp pinctrl_intel x_tables kfifo_buf serio_raw
industrialio soundcore i2c_i801 pcspkr acpi_pad thermal fan tpm_tis
tpm ppdev efivarfs overlay sg st udf crc_itu_t fuse squashfs loop
virtio_blk virtio_ring virtio dm_mod brd hid_logitech_hidpp
hid_logitech_dj hid_generic usbhid uas usb_storage crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64
lrw gf128mul glue_helper ablk_helper cryptd r8169 mii nouveau sr_mod
cdrom mxm_wmi i2c_algo_bit ttm xhci_pci drm_kms_helper syscopyarea
xhci_hcd sysfillrect sysimgblt fb_sys_fops usbcore usb_common drm
i2c_hid parport_pc parport wmi video button fjes jitterentropy_rng
drbg ansi_cprng
[ 2806.278828] CPU: 0 PID: 7974 Comm: kworker/u8:1 Tainted: G        W
 O    4.7.1-1-default #1
[ 2806.278843] Hardware name: MSI MS-7971/H170A PC MATE (MS-7971),
BIOS B.80 07/27/2016
[ 2806.278905] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[ 2806.278988] task: ffff88045da280c0 ti: ffff88044ba4c000 task.ti:
ffff88044ba4c000
[ 2806.279002] RIP: 0010:[<ffffffffa09802a3>]  [<ffffffffa09802a3>]
update_inline_extent_backref+0x2a3/0x2b0 [btrfs]
[ 2806.279052] RSP: 0018:ffff88044ba4fb40  EFLAGS: 00010293
[ 2806.279063] RAX: 0000000000000005 RBX: 0000000000003ac7 RCX: 0000000000000002
[ 2806.279076] RDX: ffff880000000000 RSI: 0000000000003af8 RDI: ffff88042a123158
[ 2806.279089] RBP: ffff88042a123158 R08: 0000000000004000 R09: 0000000000000000
[ 2806.279102] R10: 0000000000003ae0 R11: 0000000000000003 R12: 00000000fffffffb
[ 2806.279115] R13: ffff880429f4ec40 R14: 0000000000003adf R15: 00000000000000b2
[ 2806.279129] FS:  0000000000000000(0000) GS:ffff88046ec00000(0000)
knlGS:0000000000000000
[ 2806.279144] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2806.279156] CR2: 00007fc300010000 CR3: 0000000001e06000 CR4: 00000000003406f0
[ 2806.279169] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2806.279182] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 2806.279194] Stack:
[ 2806.279202]  fffffffffffffffb ffff880436696800 ffff88044ba4fc0c
0000000000003ae0
[ 2806.279231]  000000c61a90e000 0000000000000000 ffff880436696800
000000000000000c
[ 2806.279259]  000000000000001d ffff880429f4ec40 ffffffffa098212a
ffffffffa09842b2
[ 2806.279287] Call Trace:
[ 2806.279354]  [<ffffffffa098212a>] remove_extent_backref+0x3a/0x60 [btrfs]
[ 2806.279469]  [<ffffffffa09842b2>]
__btrfs_free_extent.isra.70+0x712/0xd10 [btrfs]
[ 2806.279519]  [<ffffffffa09883fb>]
__btrfs_run_delayed_refs+0x51b/0x1270 [btrfs]
[ 2806.279568]  [<ffffffffa098bff5>] btrfs_run_delayed_refs+0x95/0x2c0 [btrfs]
[ 2806.279615]  [<ffffffffa098c2a9>] delayed_ref_async_start+0x89/0xa0 [btrfs]
[ 2806.279676]  [<ffffffffa09d42c2>] btrfs_scrubparity_helper+0xd2/0x350 [btrfs]
[ 2806.279702]  [<ffffffff810950ed>] process_one_work+0x1ed/0x4e0
[ 2806.279722]  [<ffffffff81095427>] worker_thread+0x47/0x4c0
[ 2806.279738]  [<ffffffff8109affd>] kthread+0xbd/0xe0
[ 2806.279754]  [<ffffffff816bb71f>] ret_from_fork+0x1f/0x40
[ 2806.283579] DWARF2 unwinder stuck at ret_from_fork+0x1f/0x40
[ 2806.283591]
[ 2806.283598] Leftover inexact backtrace:
[ 2806.283598]
[ 2806.283615]  [<ffffffff8109af40>] ? kthread_worker_fn+0x170/0x170
[ 2806.283627] Code: ff ff ff 41 bf 0d 00 00 00 41 bc 0d 00 00 00 e9
98 fe ff ff 0f 0b e8 f0 ce 09 00 44 89 e0 f7 d8 48 98 48 39 c1 0f 83
52 ff ff ff <0f> 0b 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41
57 41
[ 2806.284036] RIP  [<ffffffffa09802a3>]
update_inline_extent_backref+0x2a3/0x2b0 [btrfs]
[ 2806.284082]  RSP <ffff88044ba4fb40>
[ 2806.287843] ---[ end trace 20d31075ee702942 ]---
[ 2806.287855] note: kworker/u8:1[7974] exited with preempt_count 2
[ 2806.287895] BUG: unable to handle kernel paging request at ffffffffffffffd8
[ 2806.287922] IP: [<ffffffff8109b4bc>] kthread_data+0xc/0x20
[ 2806.287941] PGD 1e09067 PUD 1e0b067 PMD 0
[ 2806.287966] Oops: 0000 [#2] PREEMPT SMP
[ 2806.287977] Modules linked in: netconsole configfs af_packet
nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit
ip6t_REJECT nf_reject_ipv6 xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_raw ipt_REJECT nf_reject_ipv4 iptable_raw xt_CT
iptable_filter btrfs snd_hda_codec_hdmi ip6table_mangle
nf_conntrack_ipv4 nf_defrag_ipv4 snd_hda_codec_realtek xor ip_tables
snd_hda_codec_generic intel_rapl snd_hda_intel xt_conntrack
snd_hda_codec nf_conntrack x86_pkg_temp_thermal
i2c_designware_platform raid1 snd_hda_core intel_powerclamp 8250_dw
i2c_designware_core snd_hwdep md_mod joydev raid6_pq coretemp snd_pcm
idma64 hci_uart virt_dma firewire_ohci iTCO_wdt kvm_intel snd_timer
snd ip6table_filter btbcm firewire_core iTCO_vendor_support btqca
intel_lpss_pci kvm acpi_als btintel ip6_tables irqbypass bluetooth
pinctrl_sunrisepoint rfkill intel_lpss_acpi mei_me intel_lpss mfd_core
battery mei shpchp pinctrl_intel x_tables kfifo_buf serio_raw
industrialio soundcore i2c_i801 pcspkr acpi_pad thermal fan tpm_tis
tpm ppdev efivarfs overlay sg st udf crc_itu_t fuse squashfs loop
virtio_blk virtio_ring virtio dm_mod brd hid_logitech_hidpp
hid_logitech_dj hid_generic usbhid uas usb_storage crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64
lrw gf128mul glue_helper ablk_helper cryptd r8169 mii nouveau sr_mod
cdrom mxm_wmi i2c_algo_bit ttm xhci_pci drm_kms_helper syscopyarea
xhci_hcd sysfillrect sysimgblt fb_sys_fops usbcore usb_common drm
i2c_hid parport_pc parport wmi video button fjes jitterentropy_rng
drbg ansi_cprng
[ 2806.289010] CPU: 0 PID: 7974 Comm: kworker/u8:1 Tainted: G      D W
 O    4.7.1-1-default #1
[ 2806.291886] Hardware name: MSI MS-7971/H170A PC MATE (MS-7971),
BIOS B.80 07/27/2016
[ 2806.293953] task: ffff88045da280c0 ti: ffff88044ba4c000 task.ti:
ffff88044ba4c000
[ 2806.294888] RIP: 0010:[<ffffffff8109b4bc>]  [<ffffffff8109b4bc>]
kthread_data+0xc/0x20
[ 2806.295837] RSP: 0018:ffff88044ba4f8d8  EFLAGS: 00010002
[ 2806.296781] RAX: 0000000000000000 RBX: ffff88046ec18240 RCX: 0000000000000000
[ 2806.297590] RDX: ffff88017fc06dc0 RSI: ffff88045da28140 RDI: ffff88045da280c0
[ 2806.298220] RBP: ffff88044ba4f930 R08: 00000000ffffffff R09: 0000000000000000
[ 2806.298846] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88045da286d8
[ 2806.299479] R13: ffff88046ec18240 R14: ffff88045da280c0 R15: 0000000000018240
[ 2806.300103] FS:  0000000000000000(0000) GS:ffff88046ec00000(0000)
knlGS:0000000000000000
[ 2806.300728] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2806.301337] CR2: 0000000000000028 CR3: 0000000001e06000 CR4: 00000000003406f0
[ 2806.301944] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2806.302408] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 2806.302836] Stack:
[ 2806.303259]  ffffffff81095dda ffffffff816b6f37 00ad000000000200
0000000000000011
[ 2806.303700]  ffff88045da280c0 ffff88017fc12d80 ffff88044ba50000
ffff88044ba4f440
[ 2806.304132]  ffffffff81a16a2f 0000000000000000 ffff88017e26e040
ffff88044ba4f948
[ 2806.304573] Call Trace:
[ 2806.305002]  [<ffffffff81095dda>] wq_worker_sleeping+0xa/0x80
[ 2806.305426]  [<ffffffff816b6f37>] thread_return+0x274/0x4dd
[ 2806.305851]  [<ffffffff816b71dc>] schedule+0x3c/0x90
[ 2806.306269]  [<ffffffff81080a77>] do_exit+0x807/0xbc0
[ 2806.306691]  [<ffffffff8102f7cc>] oops_end+0x9c/0xd0
[ 2806.307106]  [<ffffffff8102d0f0>] do_error_trap+0x70/0xd0
[ 2806.307436]  [<ffffffff816bcf2e>] invalid_op+0x1e/0x30
[ 2806.309293] DWARF2 unwinder stuck at invalid_op+0x1e/0x30
[ 2806.309622]
[ 2806.309948] Leftover inexact backtrace:
[ 2806.309948]
[ 2806.310626]  [<ffffffffa09802a3>] ?
update_inline_extent_backref+0x2a3/0x2b0 [btrfs]
[ 2806.311016]  [<ffffffffa098212a>] ? remove_extent_backref+0x3a/0x60 [btrfs]
[ 2806.311406]  [<ffffffffa09842b2>] ?
__btrfs_free_extent.isra.70+0x712/0xd10 [btrfs]
[ 2806.311801]  [<ffffffffa09883fb>] ?
__btrfs_run_delayed_refs+0x51b/0x1270 [btrfs]
[ 2806.312170]  [<ffffffff811ee06e>] ? kmem_cache_alloc+0x9e/0x570
[ 2806.312567]  [<ffffffffa098bff5>] ? btrfs_run_delayed_refs+0x95/0x2c0 [btrfs]
[ 2806.312956]  [<ffffffffa098c2a9>] ? delayed_ref_async_start+0x89/0xa0 [btrfs]
[ 2806.313351]  [<ffffffffa09d42c2>] ?
btrfs_scrubparity_helper+0xd2/0x350 [btrfs]
[ 2806.313727]  [<ffffffff810950ed>] ? process_one_work+0x1ed/0x4e0
[ 2806.314115]  [<ffffffff81095427>] ? worker_thread+0x47/0x4c0
[ 2806.314509]  [<ffffffff810953e0>] ? process_one_work+0x4e0/0x4e0
[ 2806.314967]  [<ffffffff8109affd>] ? kthread+0xbd/0xe0
[ 2806.315276]  [<ffffffff816bb71f>] ? ret_from_fork+0x1f/0x40
[ 2806.315659]  [<ffffffff8109af40>] ? kthread_worker_fn+0x170/0x170
[ 2806.316043] Code: ff ff e8 80 7b f6 ff e9 f4 fe ff ff e8 76 7b f6
ff 44 89 e0 5b 5d 41 5c c3 66 0f 1f 44 00 00 0f 1f 44 00 00 48 8b 87
b8 05 00 00 <48> 8b 40 d8 c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00
00 0f
[ 2806.316699] RIP  [<ffffffff8109b4bc>] kthread_data+0xc/0x20
[ 2806.317004]  RSP <ffff88044ba4f8d8>
[ 2806.317368] CR2: ffffffffffffffd8
[ 2806.317770] ---[ end trace 20d31075ee702943 ]---
[ 2806.317771] Fixing recursive fault but reboot is needed!
[ 2806.317772] BUG: scheduling while atomic: kworker/u8:1/7974/0x00000003
[ 2806.317774] Modules linked in: netconsole configfs af_packet
nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit
ip6t_REJECT nf_reject_ipv6 xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_raw ipt_REJECT nf_reject_ipv4 iptable_raw xt_CT
iptable_filter btrfs snd_hda_codec_hdmi ip6table_mangle
nf_conntrack_ipv4 nf_defrag_ipv4 snd_hda_codec_realtek xor ip_tables
snd_hda_codec_generic intel_rapl snd_hda_intel xt_conntrack
snd_hda_codec nf_conntrack x86_pkg_temp_thermal
i2c_designware_platform raid1 snd_hda_core intel_powerclamp 8250_dw
i2c_designware_core snd_hwdep md_mod joydev raid6_pq coretemp snd_pcm
idma64 hci_uart virt_dma firewire_ohci iTCO_wdt kvm_intel snd_timer
snd ip6table_filter btbcm firewire_core iTCO_vendor_support btqca
intel_lpss_pci kvm acpi_als btintel ip6_tables irqbypass bluetooth
pinctrl_sunrisepoint rfkill intel_lpss_acpi mei_me intel_lpss mfd_core
battery mei shpchp pinctrl_intel x_tables kfifo_buf serio_raw
industrialio soundcore i2c_i801 pcspkr acpi_pad thermal fan tpm_tis
tpm ppdev efivarfs overlay sg st udf crc_itu_t fuse squashfs loop
virtio_blk virtio_ring virtio dm_mod brd hid_logitech_hidpp
hid_logitech_dj hid_generic usbhid uas usb_storage crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64
lrw gf128mul glue_helper ablk_helper cryptd r8169 mii nouveau sr_mod
cdrom mxm_wmi i2c_algo_bit ttm xhci_pci drm_kms_helper syscopyarea
xhci_hcd sysfillrect sysimgblt fb_sys_fops usbcore usb_common drm
i2c_hid parport_pc parport wmi video button fjes jitterentropy_rng
drbg ansi_cprng
[ 2806.318922] CPU: 0 PID: 7974 Comm: kworker/u8:1 Tainted: G      D W
 O    4.7.1-1-default #1
[ 2806.318923] Hardware name: MSI MS-7971/H170A PC MATE (MS-7971),
BIOS B.80 07/27/2016
[ 2806.318930]  0000000000000000 ffffffff81393104 ffff88046ec18240
ffff88044ba4f6c0
[ 2806.318934]  ffffffff810a12cc ffff88044ba4f718 ffffffff816b6fdb
0000000000000046
[ 2806.319044]  ffffffff8118b419 ffff88045da280c0 ffff88044ba4f740
ffff88044ba50000
[ 2806.319047] Call Trace:
[ 2806.319053]  [<ffffffff8102ed5e>] dump_trace+0x5e/0x320
[ 2806.319057]  [<ffffffff8102f12c>] show_stack_log_lvl+0x10c/0x180
[ 2806.319060]  [<ffffffff8102fe41>] show_stack+0x21/0x40
[ 2806.319063]  [<ffffffff81393104>] dump_stack+0x5c/0x78
[ 2806.319066]  [<ffffffff810a12cc>] __schedule_bug+0x4c/0x60
[ 2806.319070]  [<ffffffff816b6fdb>] thread_return+0x318/0x4dd
[ 2806.319073]  [<ffffffff816b71dc>] schedule+0x3c/0x90
[ 2806.319076]  [<ffffffff81080c0a>] do_exit+0x99a/0xbc0
[ 2806.319079]  [<ffffffff8102f7cc>] oops_end+0x9c/0xd0
[ 2806.319082]  [<ffffffff8106473c>] no_context+0x10c/0x370
[ 2806.319085]  [<ffffffff816bd608>] page_fault+0x28/0x30
[ 2806.320182] DWARF2 unwinder stuck at page_fault+0x28/0x30
[ 2806.320241]
[ 2806.320242] Leftover inexact backtrace:
[ 2806.320242]
[ 2806.320244]  [<ffffffff8109b4bc>] ? kthread_data+0xc/0x20
[ 2806.320247]  [<ffffffff81095dda>] ? wq_worker_sleeping+0xa/0x80
[ 2806.320249]  [<ffffffff816b6f37>] ? thread_return+0x274/0x4dd
[ 2806.320252]  [<ffffffff816b71dc>] ? schedule+0x3c/0x90
[ 2806.320254]  [<ffffffff81080a77>] ? do_exit+0x807/0xbc0
[ 2806.320256]  [<ffffffff8102f7cc>] ? oops_end+0x9c/0xd0
[ 2806.320258]  [<ffffffff8102d0f0>] ? do_error_trap+0x70/0xd0
[ 2806.320268]  [<ffffffffa09802a3>] ?
update_inline_extent_backref+0x2a3/0x2b0 [btrfs]
[ 2806.320276]  [<ffffffffa097b87a>] ? btrfs_search_slot+0x97a/0xa20 [btrfs]
[ 2806.320278]  [<ffffffff816bcf2e>] ? invalid_op+0x1e/0x30
[ 2806.320286]  [<ffffffffa09802a3>] ?
update_inline_extent_backref+0x2a3/0x2b0 [btrfs]
[ 2806.320295]  [<ffffffffa098212a>] ? remove_extent_backref+0x3a/0x60 [btrfs]
[ 2806.320303]  [<ffffffffa09842b2>] ?
__btrfs_free_extent.isra.70+0x712/0xd10 [btrfs]
[ 2806.320311]  [<ffffffffa09883fb>] ?
__btrfs_run_delayed_refs+0x51b/0x1270 [btrfs]
[ 2806.320314]  [<ffffffff811ee06e>] ? kmem_cache_alloc+0x9e/0x570
[ 2806.320323]  [<ffffffffa098bff5>] ? btrfs_run_delayed_refs+0x95/0x2c0 [btrfs]
[ 2806.320331]  [<ffffffffa098c2a9>] ? delayed_ref_async_start+0x89/0xa0 [btrfs]
[ 2806.320343]  [<ffffffffa09d42c2>] ?
btrfs_scrubparity_helper+0xd2/0x350 [btrfs]
[ 2806.320346]  [<ffffffff810950ed>] ? process_one_work+0x1ed/0x4e0
[ 2806.320348]  [<ffffffff81095427>] ? worker_thread+0x47/0x4c0
[ 2806.320350]  [<ffffffff810953e0>] ? process_one_work+0x4e0/0x4e0
[ 2806.320351]  [<ffffffff8109affd>] ? kthread+0xbd/0xe0
[ 2806.320353]  [<ffffffff816bb71f>] ? ret_from_fork+0x1f/0x40
[ 2806.320355]  [<ffffffff8109af40>] ? kthread_worker_fn+0x170/0x170
[ 2823.930151] NMI watchdog: Watchdog detected hard LOCKUP on cpu
1 dModules linked in: netconsole configfs af_packet nf_log_ipv6
xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit ip6t_REJECT
nf_reject_ipv6 xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw
ipt_REJECT nf_reject_ipv4 iptable_raw xt_CT iptable_filter btrfs
snd_hda_codec_hdmi ip6table_mangle nf_conntrack_ipv4 nf_defrag_ipv4
snd_hda_codec_realtek xor ip_tables snd_hda_codec_generic intel_rapl
snd_hda_intel xt_conntrack snd_hda_codec nf_conntrack
x86_pkg_temp_thermal i2c_designware_platform raid1 snd_hda_core
intel_powerclamp 8250_dw i2c_designware_core snd_hwdep md_mod joydev
raid6_pq coretemp snd_pcm idma64 hci_uart virt_dma firewire_ohci
iTCO_wdt kvm_intel snd_timer snd ip6table_filter btbcm firewire_core
iTCO_vendor_support btqca intel_lpss_pci kvm acpi_als btintel
ip6_tables irqbypass bluetooth pinctrl_sunrisepoint rfkill
intel_lpss_acpi mei_me intel_lpss mfd_core battery mei shpchp
pinctrl_intel x_tables kfifo_buf[ 2823.930151] CPU: 1 PID: 0 Comm:
swapper/1 Tainted: G      D W  O    4.7.1-1-default #1
[ 2823.930152] Hardware name: MSI MS-7971/H170A PC MATE (MS-7971),
BIOS B.80 07/27/2016
[ 2823.930152] task: ffff88017dcc4040 ti: ffff88017dcc8000 task.ti:
ffff88017dcc8000
[ 2823.930152] RIP: 0010:[<ffffffff81579c4a>]  [<ffffffff81579c4a>]
cpuidle_enter_state+0x11a/0x2e0
[ 2823.930152] RSP: 0018:ffff88017dccbeb8  EFLAGS: 00000246
[ 2823.930152] RAX: 0000000000000000 RBX: 0000000000000006 RCX: 000000000000001f
[ 2823.930153] RDX: 0000000000000000 RSI: ffff88046ec95918 RDI: 0000000000000000
[ 2823.930153] RBP: ffffe8ffffc8b7d0 R08: cccccccccccccccd R09: 0000000000000008
[ 2823.930153] R10: 0000000000000ed3 R11: 0000000000000ed4 R12: ffffffff81eb2578
[ 2823.930153] R13: 0000000000000006 R14: 0000000000000006 R15: 0000028dd070d3c3
[ 2823.930154] FS:  0000000000000000(0000) GS:ffff88046ec80000(0000)
knlGS:0000000000000000
[ 2823.930154] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2823.930154] CR2: 00007fc30000a000 CR3: 0000000001e06000 CR4: 00000000003406e0
[ 2823.930154] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2823.930154] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 2823.930155] Stack:
[ 2823.930155]  0000028dd033df61 0000000000000000 ffff88017dccc000
ffffe8ffffc8b7d0
[ 2823.930155]  ffffffff81f1b480 ffff88017dcc8000 0000000000000000
ffffffff81eb2320
[ 2823.930155]  ffffffff810be06e ffff88017dcc8000 80645f44d0bc5d52
0000000000000000
[ 2823.930155] Call Trace:
[ 2823.930156]  [<ffffffff810be06e>] cpu_startup_entry+0x2be/0x380
[ 2823.930156]  [<ffffffff8104d5b8>] start_secondary+0x148/0x170
[ 2823.930156] Code: a9 7e 89 c3 e8 b8 0d b3 ff 49 89 c7 0f 1f 44 00
00 31 ff e8 89 40 b4 ff 8b 44 24 0c 85 c0 0f 85 4e 01 00 00 fb 66 0f
1f 44 00 00 <4c> 2b 3c 24 48 ba cf f7 53 e3 a5 9b c4 20 4c 89 f8 49 c1
ff 3f
[ 2823.930156] Kernel panic - not syncing: Hard LOCKUP
[ 2824.983144] Shutting down cpus with NMI
[ 2824.983145] Kernel Offset: disabled

Note that mounting with -o skip_balance works for 10-15 minutes, after
that I still get a lockup.

Robert


-- 
http://robert.muntea.nu/
