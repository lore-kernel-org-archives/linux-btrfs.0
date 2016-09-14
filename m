Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36051 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753970AbcINUP5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 16:15:57 -0400
Received: by mail-qk0-f170.google.com with SMTP id z190so26621759qkc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Sep 2016 13:15:56 -0700 (PDT)
Message-ID: <1473884149.1129.12.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: Wed, 14 Sep 2016 17:15:49 -0300
In-Reply-To: <57C426AB.3020607@cn.fujitsu.com>
References: <1471023419.16857.9.camel@gmail.com>
         <57C426AB.3020607@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

The problem happened again, but now it was way more serious. I was
doing a big Tumbleweed update (4680 packages) and I got the ENOSPC
during the update. To avoid being left with a broken system, as it has
already happened in the past, I, unfortunately, needed to delete data
that I really was not planning to. This is a disaster, because I have
more than 1 TiB of **free space**.

After deleting 7GiB of data, I could run rebalance and the update
finished successfully. However, the ENOSPC happened 3 more times (!)
and I always needed to run rebalance to keep the update going.

Sometimes, during the rebalance, I saw the message:

[28736.688266] BTRFS info (device sda6): relocating block group
389998968832 flags 34
[28737.376302] BTRFS info (device sda6): found 4 extents
[28737.712815] BTRFS info (device sda6): relocating block group
343760961536 flags 36
[28738.010030] BTRFS info (device sda6): relocating block group
343224090624 flags 36
[28738.343461] BTRFS info (device sda6): relocating block group
342687219712 flags 36
[28738.660023] BTRFS info (device sda6): relocating block group
342150348800 flags 36
[28738.665241] use_block_rsv: 11 callbacks suppressed
[28738.665247] ------------[ cut here ]------------
[28738.665290] WARNING: CPU: 10 PID: 639 at ../fs/btrfs/extent-
tree.c:8097 btrfs_alloc_tree_block+0x3f1/0x4c0 [btrfs]
[28738.665292] BTRFS: block rsv returned -28
[28738.665295] Modules linked in: dm_mod fuse nf_log_ipv6 xt_pkttype
nf_log_ipv4 nf_log_common xt_LOG xt_limit af_packet iscsi_ibft
iscsi_boot_sysfs msr ip6t_REJECT nf_reject_ipv6 xt_tcpudp
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT nf_reject_ipv4
iptable_raw xt_CT snd_hda_codec_hdmi snd_hda_codec_realtek
nvidia_drm(PO) snd_hda_codec_generic snd_hda_intel nvidia_modeset(PO)
snd_hda_codec snd_hda_core snd_hwdep iptable_filter nvidia(PO) joydev
drm_kms_helper intel_rapl drm fb_sys_fops iTCO_wdt mei_wdt syscopyarea
snd_pcm snd_timer iTCO_vendor_support sysfillrect sb_edac snd i2c_i801
mei_me lpc_ich edac_core sysimgblt ip6table_mangle x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel aesni_intel soundcore mei aes_x86_64
[28738.665359]  lrw gf128mul glue_helper ablk_helper cryptd e1000e
hp_wmi ioatdma fjes nf_conntrack_netbios_ns ptp shpchp pps_core
sparse_keymap pcspkr mfd_core nf_conntrack_broadcast rfkill
tpm_infineon tpm_tis dca tpm nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables btrfs xor
raid6_pq hid_generic usbhid crc32c_intel serio_raw xhci_pci ehci_pci
sr_mod firewire_ohci xhci_hcd ehci_hcd cdrom firewire_core crc_itu_t
usbcore isci usb_common libsas ata_generic mpt3sas raid_class
scsi_transport_sas wmi button sg
[28738.665419] CPU: 10 PID: 639 Comm: systemd-journal Tainted:
P        W  O    4.7.1-1-default #1
[28738.665421] Hardware name: Hewlett-Packard HP Z820 Workstation/158B,
BIOS J63 v03.65 12/19/2013
[28738.665425]  0000000000000000 ffffffff81393104 ffff88080bc63a68
0000000000000000
[28738.665430]  ffffffff8107ca1e ffff8804eaa73300 ffff88080bc63ab8
0000000000004000
[28738.665434]  0000000000000000 ffff88017be9a000 ffff880f51b31760
ffffffff8107ca8f
[28738.665438] Call Trace:
[28738.665464]  [<ffffffff8102ed5e>] dump_trace+0x5e/0x320
[28738.665472]  [<ffffffff8102f12c>] show_stack_log_lvl+0x10c/0x180
[28738.665478]  [<ffffffff8102fe41>] show_stack+0x21/0x40
[28738.665486]  [<ffffffff81393104>] dump_stack+0x5c/0x78
[28738.665496]  [<ffffffff8107ca1e>] __warn+0xbe/0xe0
[28738.665503]  [<ffffffff8107ca8f>] warn_slowpath_fmt+0x4f/0x60
[28738.665529]  [<ffffffffa029d911>] btrfs_alloc_tree_block+0x3f1/0x4c0
[btrfs]
[28738.665560]  [<ffffffffa02846a2>] btrfs_copy_root+0xf2/0x280 [btrfs]
[28738.665593]  [<ffffffffa02fd141>] create_reloc_root+0x171/0x1e0
[btrfs]
[28738.665623]  [<ffffffffa030316f>] btrfs_init_reloc_root+0x8f/0xa0
[btrfs]
[28738.665652]  [<ffffffffa02ac992>] record_root_in_trans+0xb2/0x110
[btrfs]
[28738.665679]  [<ffffffffa02adb11>]
btrfs_record_root_in_trans+0x41/0x70 [btrfs]
[28738.665704]  [<ffffffffa02afd00>] start_transaction+0xa0/0x4f0
[btrfs]
[28738.665732]  [<ffffffffa02b6153>] btrfs_dirty_inode+0x33/0xc0
[btrfs]
[28738.665741]  [<ffffffff8122aa59>] file_update_time+0x99/0xf0
[28738.665770]  [<ffffffffa02c11a3>] btrfs_page_mkwrite+0xa3/0x450
[btrfs]
[28738.665779]  [<ffffffff811bd2c9>] do_page_mkwrite+0x69/0xc0
[28738.665785]  [<ffffffff811c00f4>] handle_pte_fault+0xf4/0x1760
[28738.665792]  [<ffffffff811c1bfe>] handle_mm_fault+0x29e/0x5a0
[28738.665798]  [<ffffffff81064fc0>] __do_page_fault+0x1e0/0x510
[28738.665809]  [<ffffffff816bd608>] page_fault+0x28/0x30
[28738.669296] DWARF2 unwinder stuck at page_fault+0x28/0x30

[28738.669300] Leftover inexact backtrace:

[28738.669327] ---[ end trace 8ef9cfba38cc9bfc ]---

Look what happened to my METADATA during the update:

1) When the problem occured:

# btrfs fi usage /
Overall:
    Device size:		   1.26TiB
    Device allocated:		  63.07GiB
    Device unallocated:		   1.20TiB
    Device missing:		     0.00B
    Used:			  50.21GiB
    Free (estimated):		   1.20TiB	(min: 612.49GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 400.00MiB	(used: 0.00B)

Data,single: Size:48.01GiB, Used:47.91GiB
   /dev/sda6	  48.01GiB

Metadata,DUP: Size:7.50GiB, Used:1.15GiB
   /dev/sda6	  15.00GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
   /dev/sda6	  64.00MiB

Unallocated:
   /dev/sda6	   1.20TiB

2) After deleting 7GiB of data and run rebalance:

# btrfs fi usage /
Overall:
    Device size:		   1.26TiB
    Device allocated:		 133.07GiB
    Device unallocated:		   1.13TiB
    Device missing:		     0.00B
    Used:			  43.16GiB
    Free (estimated):		   1.13TiB	(min: 584.46GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 384.00MiB	(used: 0.00B)

Data,single: Size:48.01GiB, Used:40.94GiB
   /dev/sda6	  48.01GiB

Metadata,DUP: Size:42.50GiB, Used:1.11GiB
   /dev/sda6	  85.00GiB

System,DUP: Size:32.00MiB, Used:48.00KiB
   /dev/sda6	  64.00MiB

Unallocated:
   /dev/sda6	   1.13TiB

3) After another rebalance (I saw the ENOSPC again):

# btrfs fi usage /
Overall:
    Device size:		   1.26TiB
    Device allocated:		 207.07GiB
    Device unallocated:		   1.05TiB
    Device missing:		     0.00B
    Used:			  43.87GiB
    Free (estimated):		   1.06TiB	(min: 540.83GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 400.00MiB	(used: 0.00B)

Data,single: Size:42.01GiB, Used:41.57GiB
   /dev/sda6	  42.01GiB

Metadata,DUP: Size:82.50GiB, Used:1.15GiB
   /dev/sda6	 165.00GiB

System,DUP: Size:32.00MiB, Used:48.00KiB
   /dev/sda6	  64.00MiB

Unallocated:
   /dev/sda6	   1.05TiB

4) After another rebalance (I saw the ENOSPC again):

# btrfs fi usage /
Overall:
    Device size:		   1.26TiB
    Device allocated:		 344.07GiB
    Device unallocated:		 943.79GiB
    Device missing:		     0.00B
    Used:			  44.69GiB
    Free (estimated):		 944.45GiB	(min: 472.55GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 416.00MiB	(used: 0.00B)

Data,single: Size:43.01GiB, Used:42.34GiB
   /dev/sda6	  43.01GiB

Metadata,DUP: Size:150.50GiB, Used:1.17GiB
   /dev/sda6	 301.00GiB

System,DUP: Size:32.00MiB, Used:80.00KiB
   /dev/sda6	  64.00MiB

Unallocated:
   /dev/sda6	 943.79GiB

Yes, 150 GiB of METADATA, 3x more than my actual data.

This problem is really causing me problems. I am starting to think that
Tumbleweed, at least, should not choose BTRFS as the default file
system, since this distribution is supposed to be stable. I think that
BTRFS has some serious problems at least in kernels 4.6 and 4.7.

I reported this problem more than 1 month ago, and yet nobody could
provide me at least a workaround so I can keep working here. I think
the best will be to format this machine (**again**) and use EXT4 of
XFS, if nobody could help me to fix or avoid this problem in the
following days.

Best regards,
Ronan Arraes
