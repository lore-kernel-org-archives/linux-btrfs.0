Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38018 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbeHJT2g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 15:28:36 -0400
Received: by mail-wm0-f66.google.com with SMTP id t25-v6so2578594wmi.3
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 09:57:54 -0700 (PDT)
From: Giuseppe Della Bianca <giusdbg@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can hangs.
Date: Fri, 10 Aug 2018 18:57:16 +0200
Message-ID: <1906340.inu0YyYjfj@exnet.gdb.it>
In-Reply-To: <3834bc23-03bf-f6e4-dd56-2cf028469a82@suse.com>
References: <2543962.HIiRWmuHEy@exnet.gdb.it> <3834bc23-03bf-f6e4-dd56-2cf028469a82@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In data giovedì 9 agosto 2018 20:48:03 CEST, Jeff Mahoney ha scritto:
> On 8/9/18 11:15 AM, Giuseppe Della Bianca wrote:
> > Hi.
> > 
> > My system:
> > - Fedora 28 x86_64
> > - kernel-4.17.7-200
> > - btrfs-progs-4.15.1-1
> > 
> > The command 'btrfs subvolume sync -s 2 xyz' hangs in this case:
> > 
> > - Run command 'btrfs subvolume sync -s 2 xyz' .
> > - After some time the kernel reports an error on the filesystem.
> > 
> >   (error that existed before the command was launched.)
> > 
> > - The filesystem goes in read-only mode.
> > - The command hangs.
> 
> Can you provide the output of 'dmesg' and the contents of
> /proc/<pid>/stack where <pid> is the pid of the btrfs command process?
> 
> -Jeff

For pid info we have to wait for the problem to reoccur.
(the filesystem has been restored.)

Kernel messages

Aug  7 15:45:33 exnet kernel: WARNING: CPU: 2 PID: 9700 at fs/btrfs/extent-
tree.c:7001 __btrfs_free_extent.isra.70+0x782/0xb10 [btrfs]
Aug  7 15:45:33 exnet kernel: Modules linked in: ppp_deflate bsd_comp 
ppp_async ppp_generic slhc cdc_ether usbnet option mii usb_wwan uas 
usb_storage fuse tun bridge devlink ebtable_filter ebtables bnx2fc cnic uio 
8021q fcoe libfcoe garp mrp stp llc libfc scsi_transport_fc nf_log_ipv4 
nf_log_common xt_LOG xt_limit xt_multiport xt_CHECKSUM iptable_mangle 
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 
nf_defrag_ipv4 nf_nat_ipv4 nf_nat ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 
nf_defrag_ipv6 xt_conntrack nf_conntrack uinput ip6table_filter ip6_tables 
eeepc_wmi asus_wmi sparse_keymap iTCO_wdt iTCO_vendor_support rfkill ppdev 
snd_hda_codec_hdmi wmi_bmof mxm_wmi snd_usb_audio snd_hda_codec_realtek 
snd_usbmidi_lib snd_hda_codec_generic snd_rawmidi intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp
Aug  7 15:45:33 exnet kernel: snd_hda_intel kvm_intel kvm snd_hda_codec 
snd_hda_core snd_hwdep snd_seq snd_seq_device irqbypass crct10dif_pclmul 
crc32_pclmul snd_pcm ghash_clmulni_intel intel_cstate intel_uncore 
intel_rapl_perf snd_timer snd mei_me soundcore i2c_i801 mei shpchp parport_pc 
parport wmi acpi_pad vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) binfmt_misc 
vboxdrv(OE) btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq 
i915 i2c_algo_bit drm_kms_helper e1000e nvme drm crc32c_intel serio_raw 
nvme_core video analog gameport joydev i2c_dev
Aug  7 15:45:33 exnet kernel: CPU: 2 PID: 9700 Comm: btrfs-cleaner Tainted: G           
OE     4.17.7-200.fc28.x86_64 #1
Aug  7 15:45:33 exnet kernel: Hardware name: System manufacturer System 
Product Name/Z170M-PLUS, BIOS 0704 02/18/2016
Aug  7 15:45:33 exnet kernel: RIP: 0010:__btrfs_free_extent.isra.
70+0x782/0xb10 [btrfs]
Aug  7 15:45:33 exnet kernel: RSP: 0018:ffffaf1c4992bc30 EFLAGS: 00010246
Aug  7 15:45:33 exnet kernel: RAX: 00000000fffffffe RBX: ffff8fe421682230 RCX: 
0000000000000000
Aug  7 15:45:33 exnet kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
ffff8fe428f7b068
Aug  7 15:45:33 exnet kernel: RBP: 0000000e401ec000 R08: ffffaf1c4992bba4 R09: 
0000000000000046
Aug  7 15:45:33 exnet kernel: R10: 00000000000002ef R11: 0000000000000000 R12: 
ffff8fe43cd50000
Aug  7 15:45:33 exnet kernel: R13: 00000000fffffffe R14: 0000000000000000 R15: 
0000000000000578
Aug  7 15:45:33 exnet kernel: FS:  0000000000000000(0000) 
GS:ffff8fe5bbd00000(0000) knlGS:0000000000000000
Aug  7 15:45:33 exnet kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Aug  7 15:45:33 exnet kernel: CR2: 0000564e5fb75650 CR3: 000000028f20a004 CR4: 
00000000003606e0
Aug  7 15:45:33 exnet kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
Aug  7 15:45:33 exnet kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
Aug  7 15:45:33 exnet kernel: Call Trace:
Aug  7 15:45:33 exnet kernel: __btrfs_run_delayed_refs+0x216/0x10b0 [btrfs]
Aug  7 15:45:33 exnet kernel: ? btrfs_set_disk_extent_flags+0x72/0xb0 [btrfs]
Aug  7 15:45:33 exnet kernel: btrfs_run_delayed_refs+0x78/0x180 [btrfs]
Aug  7 15:45:33 exnet kernel: btrfs_should_end_transaction+0x3e/0x60 [btrfs]
Aug  7 15:45:33 exnet kernel: btrfs_drop_snapshot+0x3cf/0x820 [btrfs]
Aug  7 15:45:33 exnet kernel: ? btree_submit_bio_start+0x20/0x20 [btrfs]
Aug  7 15:45:33 exnet kernel: btrfs_clean_one_deleted_snapshot+0xba/0xe0 
[btrfs]
Aug  7 15:45:33 exnet kernel: cleaner_kthread+0x129/0x160 [btrfs]
Aug  7 15:45:33 exnet kernel: kthread+0x112/0x130
Aug  7 15:45:33 exnet kernel: ? kthread_create_worker_on_cpu+0x70/0x70
Aug  7 15:45:33 exnet kernel: ret_from_fork+0x35/0x40
Aug  7 15:45:33 exnet kernel: Code: b8 00 00 00 48 8b 7c 24 18 e8 bb b7 ff ff 
41 89 c5 58 5a c6 44 24 24 00 45 85 ed 0f 84 97 f9 ff ff 41 83 fd fe 0f 85 63 
fc ff ff <0f> 0b 48 8b 3b e8 94 ca 00 00 4d 89 f8 4c 89 f1 48 89 ea ff b4 
Aug  7 15:45:33 exnet kernel: ---[ end trace 961b1007d36aa769 ]---
Aug  7 15:45:33 exnet kernel: BTRFS info (device sda3): leaf 88886329344 gen 
1601 total ptrs 135 free space 5456 owner 2
Aug  7 15:45:33 exnet kernel: #011item 0 key (61204873216 169 0) itemoff 16142 
itemsize 141
Aug  7 15:45:33 exnet kernel: #011#011extent refs 13 gen 1476 flags 258
Aug  7 15:45:33 exnet kernel: #011#011ref#0: tree block backref root 1407
Aug  7 15:45:33 exnet kernel: #011#011ref#1: tree block backref root 1405
Aug  7 15:45:33 exnet kernel: #011#011ref#2: tree block backref root 1403
Aug  7 15:45:33 exnet kernel: #011#011ref#3: shared block backref parent 
88626577408
Aug  7 15:45:33 exnet kernel: #011#011ref#4: shared block backref parent 
88508121088
Aug  7 15:45:33 exnet kernel: #011#011ref#5: shared block backref parent 
88417042432
Aug  7 15:45:33 exnet kernel: #011#011ref#6: shared block backref parent 
88244256768
Aug  7 15:45:33 exnet kernel: #011#011ref#7: shared block backref parent 
88084234240
Aug  7 15:45:33 exnet kernel: #011#011ref#8: shared block backref parent 
80272637952

................................................................

................................................................

................................................................

Aug  7 15:45:33 exnet kernel: #011#011extent refs 1 gen 1476 flags 258
Aug  7 15:45:33 exnet kernel: #011#011ref#0: shared block backref parent 
61205299200
Aug  7 15:45:33 exnet kernel: #011item 134 key (61207068672 169 0) itemoff 
8831 itemsize 33
Aug  7 15:45:33 exnet kernel: #011#011extent refs 1 gen 1476 flags 258
Aug  7 15:45:33 exnet kernel: #011#011ref#0: shared block backref parent 
61205299200
Aug  7 15:45:33 exnet kernel: BTRFS error (device sda3): unable to find ref 
byte nr 61205299200 parent 0 root 1400  owner 1 offset 0
Aug  7 15:45:33 exnet kernel: ------------[ cut here ]------------
Aug  7 15:45:33 exnet kernel: WARNING: CPU: 2 PID: 9700 at fs/btrfs/extent-
tree.c:7007 __btrfs_free_extent.isra.70+0x7e2/0xb10 [btrfs]
Aug  7 15:45:33 exnet kernel: Modules linked in: ppp_deflate bsd_comp 
ppp_async ppp_generic slhc cdc_ether usbnet option mii usb_wwan uas 
usb_storage fuse tun bridge devlink ebtable_filter ebtables bnx2fc cnic uio 
8021q fcoe libfcoe garp mrp stp llc libfc scsi_transport_fc nf_log_ipv4 
nf_log_common xt_LOG xt_limit xt_multiport xt_CHECKSUM iptable_mangle 
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 
nf_defrag_ipv4 nf_nat_ipv4 nf_nat ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 
nf_defrag_ipv6 xt_conntrack nf_conntrack uinput ip6table_filter ip6_tables 
eeepc_wmi asus_wmi sparse_keymap iTCO_wdt iTCO_vendor_support rfkill ppdev 
snd_hda_codec_hdmi wmi_bmof mxm_wmi snd_usb_audio snd_hda_codec_realtek 
snd_usbmidi_lib snd_hda_codec_generic snd_rawmidi intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp
Aug  7 15:45:33 exnet kernel: snd_hda_intel kvm_intel kvm snd_hda_codec 
snd_hda_core snd_hwdep snd_seq snd_seq_device irqbypass crct10dif_pclmul 
crc32_pclmul snd_pcm ghash_clmulni_intel intel_cstate intel_uncore 
intel_rapl_perf snd_timer snd mei_me soundcore i2c_i801 mei shpchp parport_pc 
parport wmi acpi_pad vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) binfmt_misc 
vboxdrv(OE) btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq 
i915 i2c_algo_bit drm_kms_helper e1000e nvme drm crc32c_intel serio_raw 
nvme_core video analog gameport joydev i2c_dev
Aug  7 15:45:33 exnet kernel: CPU: 2 PID: 9700 Comm: btrfs-cleaner Tainted: G        
W  OE     4.17.7-200.fc28.x86_64 #1
Aug  7 15:45:33 exnet kernel: Hardware name: System manufacturer System 
Product Name/Z170M-PLUS, BIOS 0704 02/18/2016
Aug  7 15:45:33 exnet kernel: RIP: 0010:__btrfs_free_extent.isra.
70+0x7e2/0xb10 [btrfs]
Aug  7 15:45:33 exnet kernel: RSP: 0018:ffffaf1c4992bc30 EFLAGS: 00010286
Aug  7 15:45:33 exnet kernel: RAX: 0000000000000000 RBX: ffff8fe421682230 RCX: 
0000000000000006
Aug  7 15:45:33 exnet kernel: RDX: 0000000000000007 RSI: 0000000000000086 RDI: 
ffff8fe5bbd16930
Aug  7 15:45:33 exnet kernel: RBP: 0000000e401ec000 R08: 0000000000000038 R09: 
00000000000006d1
Aug  7 15:45:33 exnet kernel: R10: 0000000000000000 R11: 0000000000000001 R12: 
ffff8fe43cd50000
Aug  7 15:45:33 exnet kernel: R13: 00000000fffffffe R14: 0000000000000000 R15: 
0000000000000578
Aug  7 15:45:33 exnet kernel: FS:  0000000000000000(0000) 
GS:ffff8fe5bbd00000(0000) knlGS:0000000000000000
Aug  7 15:45:33 exnet kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Aug  7 15:45:33 exnet kernel: CR2: 0000564e5fb75650 CR3: 000000028f20a004 CR4: 
00000000003606e0
Aug  7 15:45:33 exnet kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
Aug  7 15:45:33 exnet kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
Aug  7 15:45:33 exnet kernel: Call Trace:
Aug  7 15:45:33 exnet kernel: __btrfs_run_delayed_refs+0x216/0x10b0 [btrfs]
Aug  7 15:45:33 exnet kernel: ? btrfs_set_disk_extent_flags+0x72/0xb0 [btrfs]
Aug  7 15:45:33 exnet kernel: btrfs_run_delayed_refs+0x78/0x180 [btrfs]
Aug  7 15:45:33 exnet kernel: btrfs_should_end_transaction+0x3e/0x60 [btrfs]
Aug  7 15:45:33 exnet kernel: btrfs_drop_snapshot+0x3cf/0x820 [btrfs]
Aug  7 15:45:33 exnet kernel: ? btree_submit_bio_start+0x20/0x20 [btrfs]
Aug  7 15:45:33 exnet kernel: btrfs_clean_one_deleted_snapshot+0xba/0xe0 
[btrfs]
Aug  7 15:45:33 exnet kernel: cleaner_kthread+0x129/0x160 [btrfs]
Aug  7 15:45:33 exnet kernel: kthread+0x112/0x130
Aug  7 15:45:33 exnet kernel: ? kthread_create_worker_on_cpu+0x70/0x70
Aug  7 15:45:33 exnet kernel: ret_from_fork+0x35/0x40
Aug  7 15:45:33 exnet kernel: Code: 10 48 8b 40 50 f0 48 0f ba a8 30 23 00 00 
02 0f 92 c0 41 59 84 c0 0f 85 6c a9 09 00 44 89 ee 48 c7 c7 e8 2e 7c c0 e8 68 
9a 99 ed <0f> 0b e9 56 a9 09 00 48 89 df e8 bf 0c ff ff 49 8b 74 24 28 4d 
Aug  7 15:45:33 exnet kernel: ---[ end trace 961b1007d36aa76a ]---
Aug  7 15:45:33 exnet kernel: BTRFS: error (device sda3) in 
__btrfs_free_extent:7007: errno=-2 No such entry
Aug  7 15:45:33 exnet kernel: BTRFS info (device sda3): forced readonly
Aug  7 15:45:33 exnet kernel: BTRFS: error (device sda3) in 
btrfs_run_delayed_refs:3076: errno=-2 No such entry


gdb
