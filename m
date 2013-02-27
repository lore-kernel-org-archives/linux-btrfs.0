Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:47268 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3B0NUV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 08:20:21 -0500
Received: by mail-ee0-f41.google.com with SMTP id c13so490310eek.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 05:20:19 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-btrfs@vger.kernel.org
Date: Wed, 27 Feb 2013 14:20:16 +0100
Subject: Running Apache Derby on 3.8 and BTRFS cause kernel oops
MIME-Version: 1.0
From: =?utf-8?Q?Daniel_Koz=C3=A1k?= <kozzi11@gmail.com>
Message-ID: <op.ws51z2nllpxuyk@kozzifx.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On my both machine I have ArchLinux with recent kernel 3.8.0 btrfs as a  
filesystem (with lzo compression). When I try use Apache derby (create  
database), I almost every time get this kernel oops:

  ------------[ cut here ]------------
[ 7169.133088] WARNING: at fs/btrfs/extent_io.c:4718  
map_private_extent_buffer+0xd4/0xe0 [btrfs]()
[ 7169.133092] Hardware name: To Be Filled By O.E.M.
[ 7169.133096] btrfs bad mapping eb start 277946368 len 4096, wanted 4096 8
[ 7169.133099] Modules linked in: fuse ip6table_filter ip6_tables  
ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat  
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT  
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables  
bridge stp llc w83627ehf hwmon_vid nls_cp437 vfat fat ext4 crc16 jbd2  
mbcache acpi_cpufreq mperf kvm_amd kvm ghash_clmulni_intel aesni_intel  
sp5100_tco aes_x86_64 snd_hda_codec_hdmi xts lrw gf128mul fglrx(PO)  
ablk_helper cryptd snd_hda_codec_realtek psmouse i2c_piix4 processor  
serio_raw pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_pcm  
snd_page_alloc snd_timer snd soundcore i2c_core amd_iommu_v2 r8169 mii  
joydev edac_core evdev edac_mce_amd button k10temp microcode fam15h_power  
btrfs libcrc32c zlib_deflate sd_mod ata_generic pata_acpi
[ 7169.133175]  hid_generic usbhid hid crc32c_intel ahci pata_atiixp  
libahci ehci_pci ohci_hcd ehci_hcd xhci_hcd libata scsi_mod usbcore  
usb_common
[ 7169.133194] Pid: 19609, comm: java Tainted: P           O 3.8.0-2-ARCH  
#1
[ 7169.133197] Call Trace:
[ 7169.133208]  [<ffffffff810574ff>] warn_slowpath_common+0x7f/0xc0
[ 7169.133215]  [<ffffffff810575f6>] warn_slowpath_fmt+0x46/0x50
[ 7169.133244]  [<ffffffffa02f9d74>] map_private_extent_buffer+0xd4/0xe0  
[btrfs]
[ 7169.133269]  [<ffffffffa02efbfb>] btrfs_set_token_64+0x6b/0x100 [btrfs]
[ 7169.133294]  [<ffffffffa031225b>] btrfs_log_changed_extents+0x3ab/0x670  
[btrfs]
[ 7169.133320]  [<ffffffffa031291a>] btrfs_log_inode+0x3fa/0x690 [btrfs]
[ 7169.133327]  [<ffffffff81130946>] ? pagevec_lookup_tag+0x26/0x40
[ 7169.133352]  [<ffffffffa0313ffc>] btrfs_log_inode_parent+0x17c/0x450  
[btrfs]
[ 7169.133376]  [<ffffffffa0314317>] btrfs_log_dentry_safe+0x47/0x70  
[btrfs]
[ 7169.133402]  [<ffffffffa02ea47e>] btrfs_sync_file+0x19e/0x260 [btrfs]
[ 7169.133410]  [<ffffffff811bc6cd>] generic_write_sync+0x4d/0x60
[ 7169.133435]  [<ffffffffa02ebd59>] btrfs_file_aio_write+0x3e9/0x5d0  
[btrfs]
[ 7169.133441]  [<ffffffff811bea80>] ? __wait_on_buffer+0x30/0x30
[ 7169.133449]  [<ffffffff814ccc1c>] ? out_of_line_wait_on_bit+0x7c/0x90
[ 7169.133457]  [<ffffffff8118c7c7>] do_sync_write+0xa7/0xe0
[ 7169.133466]  [<ffffffff8118ce98>] vfs_write+0xa8/0x180
[ 7169.133471]  [<ffffffff8118d1e2>] sys_write+0x52/0xa0
[ 7169.133477]  [<ffffffff814d1329>] ? do_device_not_available+0x19/0x20
[ 7169.133485]  [<ffffffff814d7b1d>] system_call_fastpath+0x1a/0x1f
[ 7169.133489] ---[ end trace e84bd97b472af615 ]---
[ 7169.133503] BUG: unable to handle kernel NULL pointer dereference  
at           (null)
[ 7169.133508] IP: [<ffffffffa02f9f83>] write_extent_buffer+0xd3/0x150  
[btrfs]
[ 7169.133530] PGD 10a51e067 PUD 123d60067 PMD 0
[ 7169.133537] Oops: 0000 [#1] PREEMPT SMP
[ 7169.133543] Modules linked in: fuse ip6table_filter ip6_tables  
ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat  
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT  
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables  
bridge stp llc w83627ehf hwmon_vid nls_cp437 vfat fat ext4 crc16 jbd2  
mbcache acpi_cpufreq mperf kvm_amd kvm ghash_clmulni_intel aesni_intel  
sp5100_tco aes_x86_64 snd_hda_codec_hdmi xts lrw gf128mul fglrx(PO)  
ablk_helper cryptd snd_hda_codec_realtek psmouse i2c_piix4 processor  
serio_raw pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_pcm  
snd_page_alloc snd_timer snd soundcore i2c_core amd_iommu_v2 r8169 mii  
joydev edac_core evdev edac_mce_amd button k10temp microcode fam15h_power  
btrfs libcrc32c zlib_deflate sd_mod ata_generic pata_acpi
[ 7169.133625]  hid_generic usbhid hid crc32c_intel ahci pata_atiixp  
libahci ehci_pci ohci_hcd ehci_hcd xhci_hcd libata scsi_mod usbcore  
usb_common
[ 7169.133641] CPU 2
[ 7169.133646] Pid: 19609, comm: java Tainted: P        W  O 3.8.0-2-ARCH  
#1 To Be Filled By O.E.M. To Be Filled By O.E.M./970 Pro3
[ 7169.133650] RIP: 0010:[<ffffffffa02f9f83>]  [<ffffffffa02f9f83>]  
write_extent_buffer+0xd3/0x150 [btrfs]
[ 7169.133673] RSP: 0018:ffff880123ded938  EFLAGS: 00010202
[ 7169.133676] RAX: 0000000000000000 RBX: ffff880123ded9b0 RCX:  
0000000000000008
[ 7169.133680] RDX: 0000000000001008 RSI: ffff880123ded9b0 RDI:  
0000000000001000
[ 7169.133683] RBP: ffff880123ded978 R08: 000000000000000a R09:  
000000000000043e
[ 7169.133686] R10: 0000000000001000 R11: 000000000000043d R12:  
0000000000000008
[ 7169.133689] R13: ffff88011411cac0 R14: 0000000000000000 R15:  
0000000000000008
[ 7169.133693] FS:  00007f200c798700(0000) GS:ffff88023ed00000(0000)  
knlGS:00000000f7776700
[ 7169.133697] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 7169.133700] CR2: 0000000000000000 CR3: 000000010a51b000 CR4:  
00000000000407e0
[ 7169.133703] DR0: 0000000000000000 DR1: 0000000000000000 DR2:  
0000000000000000
[ 7169.133707] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:  
0000000000000400
[ 7169.133710] Process java (pid: 19609, threadinfo ffff880123dec000, task  
ffff8801fb8d0860)
[ 7169.133713] Stack:
[ 7169.133715]  0000000000001000 0000000000001000 ffff880123ded978  
ffff880123dedab0
[ 7169.133722]  ffff88011411cac0 0000000000001000 000000000000002d  
0000000000000fd3
[ 7169.133728]  ffff880123ded9e8 ffffffffa02efc80 ffff880123ded9e8  
0000000000001000
[ 7169.133735] Call Trace:
[ 7169.133761]  [<ffffffffa02efc80>] btrfs_set_token_64+0xf0/0x100 [btrfs]
[ 7169.133786]  [<ffffffffa031225b>] btrfs_log_changed_extents+0x3ab/0x670  
[btrfs]
[ 7169.133812]  [<ffffffffa031291a>] btrfs_log_inode+0x3fa/0x690 [btrfs]
[ 7169.133818]  [<ffffffff81130946>] ? pagevec_lookup_tag+0x26/0x40
[ 7169.133844]  [<ffffffffa0313ffc>] btrfs_log_inode_parent+0x17c/0x450  
[btrfs]
[ 7169.133868]  [<ffffffffa0314317>] btrfs_log_dentry_safe+0x47/0x70  
[btrfs]
[ 7169.133893]  [<ffffffffa02ea47e>] btrfs_sync_file+0x19e/0x260 [btrfs]
[ 7169.133901]  [<ffffffff811bc6cd>] generic_write_sync+0x4d/0x60
[ 7169.133926]  [<ffffffffa02ebd59>] btrfs_file_aio_write+0x3e9/0x5d0  
[btrfs]
[ 7169.133932]  [<ffffffff811bea80>] ? __wait_on_buffer+0x30/0x30
[ 7169.133938]  [<ffffffff814ccc1c>] ? out_of_line_wait_on_bit+0x7c/0x90
[ 7169.133946]  [<ffffffff8118c7c7>] do_sync_write+0xa7/0xe0
[ 7169.133954]  [<ffffffff8118ce98>] vfs_write+0xa8/0x180
[ 7169.133960]  [<ffffffff8118d1e2>] sys_write+0x52/0xa0
[ 7169.133966]  [<ffffffff814d1329>] ? do_device_not_available+0x19/0x20
[ 7169.133973]  [<ffffffff814d7b1d>] system_call_fastpath+0x1a/0x1f
[ 7169.133976] Code: e0 0c 48 01 d0 4c 89 c2 4a 8d 3c 30 45 31 f6 e8 f4 46  
f8 e0 4c 8b 45 c8 4c 01 c3 4d 29 c7 74 38 49 8b 85 50 01 00 00 4a 8b 04 20  
<48> 8b 30 83 e6 08 75 95 be af 12 00 00 48 c7 c7 86 6e 34 a0 48
[ 7169.134036] RIP  [<ffffffffa02f9f83>] write_extent_buffer+0xd3/0x150  
[btrfs]
[ 7169.134058]  RSP <ffff880123ded938>
[ 7169.134061] CR2: 0000000000000000
[ 7169.134065] ---[ end trace e84bd97b472af616 ]---


Daniel Kozak
