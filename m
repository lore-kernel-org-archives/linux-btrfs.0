Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:34141 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbcDEHpM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 03:45:12 -0400
Received: by mail-vk0-f42.google.com with SMTP id e185so7446213vkb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 00:45:11 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 Apr 2016 10:45:09 +0300
Message-ID: <CAC8ULPYz=Cj=PtE2mKVjn-WHXwCz-y2-p4s-3T+XMNtjWdF2ZA@mail.gmail.com>
Subject: BTRFS warnings in dmesg / scrub errors - Transaction aborted ( error
 -95 )
From: Robert Munteanu <robert.munteanu@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a btrfs partition which exhibits some strange behaviours:

- btrfs scrub seems to force the filesystem in read-only mode
- transactions aborted with error -95

For context, this is a partition converted from ext4 which 'survived'
through the issues described at

  http://www.spinics.net/lists/linux-btrfs/msg44660.html

The errors that I receive at runtime, during regular usage are

[   49.297851] ------------[ cut here ]------------
[   49.297905] WARNING: CPU: 0 PID: 72 at ../fs/btrfs/inode.c:2937
btrfs_finish_ordered_io+0x5f5/0x650 [b
trfs]()
[   49.297911] BTRFS warning (device sda1):
btrfs_finish_ordered_io:2937: Aborting unused transaction(unk
nown).
[   49.297916] BTRFS: Transaction aborted (error -95)
[   49.297919] Modules linked in: bnep af_packet vboxpci(O)
vboxnetadp(O) vboxnetflt(O) ip6t_REJECT nf_re
ject_ipv6 nf_log_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw
ipt_REJECT nf_reject_ipv4 xt_tcpudp x
t_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit iptable_raw xt_CT
iptable_filter vboxdrv(O) ip6table_
mangle nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_connt
rack nf_conntrack ip6table_filter ip6_tables x_tables msr xfs
libcrc32c snd_hda_codec_hdmi snd_hda_codec_
realtek snd_hda_codec_generic i915 raid1 joydev intel_rapl
drm_kms_helper fb_sys_fops x86_pkg_temp_therma
l syscopyarea intel_powerclamp sysfillrect sysimgblt i2c_algo_bit
coretemp kvm_intel i2c_designware_platform snd_hda_intel
i2c_designware_core 8250_dw md_mod ppdev kvm snd_hda_codec
[   49.297991]  snd_hda_core irqbypass snd_seq crct10dif_pclmul
snd_hwdep crc32_pclmul ghash_clmulni_intel aesni_intel snd_pcm
aes_x86_64 hci_uart lrw gf128mul btbcm glue_helper ablk_helper cryptd
snd_seq_device pcspkr r8169 btqca i2c_i801 btintel snd_timer mii
bluetooth parport_pc dm_mod rfkill battery 8250_fintek parport snd
idma64 virt_dma pinctrl_sunrisepoint pinctrl_intel intel_lpss_acpi
soundcore mei_me intel_lpss_pci intel_lpss mei acpi_als mfd_core
kfifo_buf industrialio shpchp tpm_tis thermal acpi_pad fan tpm fjes
hid_generic hid_logitech_hidpp hid_logitech_dj usbhid btrfs xor uas
usb_storage mxm_wmi raid6_pq crc32c_intel serio_raw nvidia_uvm(PO)
nvidia(PO) sr_mod cdrom xhci_pci xhci_hcd usbcore usb_common drm
i2c_hid wmi video button sg
[   49.298081] CPU: 0 PID: 72 Comm: kworker/u8:4 Tainted: P
O    4.5.0-2-default #1
[   49.298084] Hardware name: MSI MS-7971/H170A PC MATE (MS-7971),
BIOS B.60 02/23/2016
[   49.298131] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[   49.298135]  0000000000000000 ffff88045b837c98 ffffffff81395921
ffff88045b837ce0
[   49.298142]  ffffffffa0d096be ffff88045b837cd0 ffffffff8107d912
ffff880089ab85c8
[   49.298147]  ffff88045b9c5000 00000000ffffffa1 ffff88045dea5690
ffff880459efd0c0
[   49.298153] Call Trace:
[   49.298170]  [<ffffffff8101b175>] try_stack_unwind+0x175/0x190
[   49.298185]  [<ffffffff8101a0c9>] dump_trace+0x69/0x3a0
[   49.298193]  [<ffffffff8101b1db>] show_trace_log_lvl+0x4b/0x60
[   49.298201]  [<ffffffff8101a50c>] show_stack_log_lvl+0x10c/0x180
[   49.298208]  [<ffffffff8101b275>] show_stack+0x25/0x50
[   49.298218]  [<ffffffff81395921>] dump_stack+0x63/0x82
[   49.298230]  [<ffffffff8107d912>] warn_slowpath_common+0x82/0xc0
[   49.298240]  [<ffffffff8107d99c>] warn_slowpath_fmt+0x4c/0x50
[   49.298281]  [<ffffffffa0c8f885>] btrfs_finish_ordered_io+0x5f5/0x650 [btrfs]
[   49.298326]  [<ffffffffa0c8fbb5>] finish_ordered_fn+0x15/0x20 [btrfs]
[   49.298369]  [<ffffffffa0cb74bb>] btrfs_scrubparity_helper+0xcb/0x350 [btrfs]
[   49.298413]  [<ffffffffa0cb77ce>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[   49.298421]  [<ffffffff81095c3c>] process_one_work+0x15c/0x4b0
[   49.298428]  [<ffffffff81095fd8>] worker_thread+0x48/0x4e0
[   49.298436]  [<ffffffff8109beb9>] kthread+0xc9/0xe0
[   49.298445]  [<ffffffff816cc38f>] ret_from_fork+0x3f/0x70
[   49.302378] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70

[   49.302383] Leftover inexact backtrace:

[   49.302392]  [<ffffffff8109bdf0>] ? kthread_worker_fn+0x180/0x180
[   49.302488] ---[ end trace a383d63cdc6dbae3 ]---
[   49.302502] BTRFS warning (device sda1):
btrfs_finish_ordered_io:2937: Aborting unused transaction(unknown).

I also recently got an error related to scrubbing which (IIRC) caused
the fs to become read-only

Apr 05 10:13:06 mars kernel: ------------[ cut here ]------------
Apr 05 10:13:06 mars kernel: WARNING: CPU: 0 PID: 72 at
../fs/btrfs/inode.c:2937 btrfs_finish_ordered_io+0x5f5/0x650 [btrfs]()
Apr 05 10:13:06 mars kernel: BTRFS warning (device sda1):
btrfs_finish_ordered_io:2937: Aborting unused transaction(unknown).
Apr 05 10:13:06 mars kernel: BTRFS: Transaction aborted (error -95)
Apr 05 10:13:06 mars kernel: Modules linked in: bnep af_packet
vboxpci(O) vboxnetadp(O) vboxnetflt(O) ip6t_REJECT nf_reject_ipv6
nf_log_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
nf_reject_ipv
Apr 05 10:13:06 mars kernel:  snd_hda_core irqbypass snd_seq
crct10dif_pclmul snd_hwdep crc32_pclmul ghash_clmulni_intel
aesni_intel snd_pcm aes_x86_64 hci_uart lrw gf128mul btbcm glue_helper
ablk_helper cryptd
Apr 05 10:13:06 mars kernel: CPU: 0 PID: 72 Comm: kworker/u8:4
Tainted: P           O    4.5.0-2-default #1
Apr 05 10:13:06 mars kernel: Hardware name: MSI MS-7971/H170A PC MATE
(MS-7971), BIOS B.60 02/23/2016
Apr 05 10:13:06 mars kernel: Workqueue: btrfs-endio-write
btrfs_endio_write_helper [btrfs]
Apr 05 10:13:06 mars kernel:  0000000000000000 ffff88045b837c98
ffffffff81395921 ffff88045b837ce0
Apr 05 10:13:06 mars kernel:  ffffffffa0d096be ffff88045b837cd0
ffffffff8107d912 ffff880089ab85c8
Apr 05 10:13:06 mars kernel:  ffff88045b9c5000 00000000ffffffa1
ffff88045dea5690 ffff880459efd0c0
Apr 05 10:13:06 mars kernel: Call Trace:
Apr 05 10:13:06 mars kernel:  [<ffffffff8101b175>] try_stack_unwind+0x175/0x190
Apr 05 10:13:06 mars kernel:  [<ffffffff8101a0c9>] dump_trace+0x69/0x3a0
Apr 05 10:13:06 mars kernel:  [<ffffffff8101b1db>] show_trace_log_lvl+0x4b/0x60
Apr 05 10:13:06 mars kernel:  [<ffffffff8101a50c>]
show_stack_log_lvl+0x10c/0x180
Apr 05 10:13:06 mars kernel:  [<ffffffff8101b275>] show_stack+0x25/0x50
Apr 05 10:13:06 mars kernel:  [<ffffffff81395921>] dump_stack+0x63/0x82
Apr 05 10:13:06 mars kernel:  [<ffffffff8107d912>]
warn_slowpath_common+0x82/0xc0
Apr 05 10:13:06 mars kernel:  [<ffffffff8107d99c>] warn_slowpath_fmt+0x4c/0x50
Apr 05 10:13:06 mars kernel:  [<ffffffffa0c8f885>]
btrfs_finish_ordered_io+0x5f5/0x650 [btrfs]
Apr 05 10:13:06 mars kernel:  [<ffffffffa0c8fbb5>]
finish_ordered_fn+0x15/0x20 [btrfs]
Apr 05 10:13:06 mars kernel:  [<ffffffffa0cb74bb>]
btrfs_scrubparity_helper+0xcb/0x350 [btrfs]
Apr 05 10:13:06 mars kernel:  [<ffffffffa0cb77ce>]
btrfs_endio_write_helper+0xe/0x10 [btrfs]
Apr 05 10:13:06 mars kernel:  [<ffffffff81095c3c>] process_one_work+0x15c/0x4b0
Apr 05 10:13:06 mars kernel:  [<ffffffff81095fd8>] worker_thread+0x48/0x4e0
Apr 05 10:13:06 mars kernel:  [<ffffffff8109beb9>] kthread+0xc9/0xe0
Apr 05 10:13:06 mars kernel:  [<ffffffff816cc38f>] ret_from_fork+0x3f/0x70
Apr 05 10:13:06 mars kernel: DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
Apr 05 10:13:06 mars kernel:
Apr 05 10:13:06 mars kernel: Leftover inexact backtrace:
Apr 05 10:13:06 mars kernel:  [<ffffffff8109bdf0>] ?
kthread_worker_fn+0x180/0x180
Apr 05 10:13:06 mars kernel: ---[ end trace a383d63cdc6dbae3 ]---
Apr 05 10:13:06 mars kernel: BTRFS warning (device sda1):
btrfs_finish_ordered_io:2937: Aborting unused transaction(unknown).

Kernel version: 4.5.0-2 ( openSUSE Tumbleweed x86_64 )
btrfsprogs: 4.4.1-2.1

I've booted a live usb disk ( also openSUSE TW ) and run a btrfs check
( and a second run with --repair ). I only have pictures of the output
( http://i.imgur.com/xKr6qKj.jpg ) , but what stands out for me is:

- btrfs check outputs 5 entries with 'bad metadata(...,...) crossing
stripe boundary
- btrfs check --repair reports 'repaired damaged extent references'
and 'cache and super generation don't match, space cache will be
invalidated', but that does not seem to help

It would be great if anyone can suggest a workaround or provide a fix.

Thanks,

Robert

-- 
http://robert.muntea.nu/
