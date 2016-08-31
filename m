Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:34362 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760001AbcHaUtV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 16:49:21 -0400
Received: by mail-qk0-f179.google.com with SMTP id t7so64772305qkh.1
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 13:49:20 -0700 (PDT)
Message-ID: <1472676550.8145.1.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Wed, 31 Aug 2016 17:49:10 -0300
In-Reply-To: <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
         <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
         <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
         <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys!

And the problem happened again. This time, I was only using Mozilla
Firefox. I could get the very first message after the error. I hope it
brings more information:

[28039.672199] ------------[ cut here ]------------
[28039.672253] WARNING: CPU: 3 PID: 31800 at ../fs/btrfs/qgroup.c:2667
btrfs_qgroup_free_meta+0x88/0x90 [btrfs]
[28039.672255] Modules linked in: fuse nf_log_ipv6 xt_pkttype
nf_log_ipv4 nf_log_common xt_LOG xt_limit af_packet iscsi_ibft
iscsi_boot_sysfs msr ip6t_REJECT nf_reject_ipv6 xt_tcpudp
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT nf_reject_ipv4
iptable_raw xt_CT nvidia_drm(PO) nvidia_modeset(PO) iptable_filter
nvidia(PO) ip6table_mangle nf_conntrack_netbios_ns
nf_conntrack_broadcast drm_kms_helper nf_conntrack_ipv4 drm
nf_defrag_ipv4 fb_sys_fops snd_hda_codec_hdmi joydev
snd_hda_codec_realtek ip_tables syscopyarea snd_hda_codec_generic
xt_conntrack snd_hda_intel sysfillrect intel_rapl sb_edac edac_core
snd_hda_codec hp_wmi x86_pkg_temp_thermal intel_powerclamp snd_hda_core
snd_hwdep nf_conntrack sparse_keymap sysimgblt coretemp kvm_intel kvm
rfkill irqbypass snd_pcm snd_timer crct10dif_pclmul
[28039.672305]  e1000e crc32_pclmul ghash_clmulni_intel snd aesni_intel
ip6table_filter aes_x86_64 lrw gf128mul glue_helper ablk_helper
iTCO_wdt iTCO_vendor_support mei_wdt ioatdma pcspkr cryptd ip6_tables
ptp lpc_ich fjes i2c_i801 dca mfd_core soundcore pps_core shpchp
tpm_infineon tpm_tis tpm mei_me mei x_tables btrfs xor raid6_pq
hid_generic usbhid crc32c_intel serio_raw xhci_pci ehci_pci sr_mod
firewire_ohci xhci_hcd ehci_hcd cdrom firewire_core crc_itu_t isci
usbcore usb_common libsas ata_generic mpt3sas raid_class
scsi_transport_sas wmi button sg
[28039.672373] CPU: 3 PID: 31800 Comm: gnome-terminal- Tainted:
P        W  O    4.7.1-1-default #1
[28039.672375] Hardware name: Hewlett-Packard HP Z820 Workstation/158B,
BIOS J63 v03.65 12/19/2013
[28039.672378]  0000000000000000 ffffffff81393104 0000000000000000
0000000000000000
[28039.672382]  ffffffff8107ca1e ffff881008780800 0000000000014000
ffff881008780800
[28039.672386]  ffffffffffffffe4 ffff88100b297c00 ffff88053b7e3540
ffffffffa02c9f58
[28039.672390] Call Trace:
[28039.672406]  [<ffffffff8102ed5e>] dump_trace+0x5e/0x320
[28039.672413]  [<ffffffff8102f12c>] show_stack_log_lvl+0x10c/0x180
[28039.672419]  [<ffffffff8102fe41>] show_stack+0x21/0x40
[28039.672425]  [<ffffffff81393104>] dump_stack+0x5c/0x78
[28039.672430]  [<ffffffff8107ca1e>] __warn+0xbe/0xe0
[28039.672461]  [<ffffffffa02c9f58>] btrfs_qgroup_free_meta+0x88/0x90
[btrfs]
[28039.672492]  [<ffffffffa0261023>] start_transaction+0x3c3/0x4f0
[btrfs]
[28039.672521]  [<ffffffffa0271078>] btrfs_create+0x38/0x1d0 [btrfs]
[28039.672528]  [<ffffffff8121e8fb>] path_openat+0x139b/0x14a0
[28039.672535]  [<ffffffff8121fb2e>] do_filp_open+0x7e/0xe0
[28039.672541]  [<ffffffff8120e7a4>] do_sys_open+0x124/0x1f0
[28039.672547]  [<ffffffff816bb4f6>]
entry_SYSCALL_64_fastpath+0x1e/0xa8
[28039.676186] DWARF2 unwinder stuck at
entry_SYSCALL_64_fastpath+0x1e/0xa8

Best regards,
Ronan
