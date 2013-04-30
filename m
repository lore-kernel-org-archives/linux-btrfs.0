Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:40889 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646Ab3D3DWB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 23:22:01 -0400
Received: by mail-ie0-f172.google.com with SMTP id c12so98546ieb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Apr 2013 20:22:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <517F386B.8050308@q5comm.com>
References: <517F386B.8050308@q5comm.com>
Date: Mon, 29 Apr 2013 21:22:01 -0600
Message-ID: <CAE5mzvj55=5Ocy-KTcdVCC4_hmN5Br66PS-irOmLikgga-FqCw@mail.gmail.com>
Subject: Re: Panic while running defrag
From: cwillu <cwillu@cwillu.com>
To: Stephen Weinberg <stephen@q5comm.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 29, 2013 at 9:20 PM, Stephen Weinberg <stephen@q5comm.com> wrote:
> I ran into a panic while running find -xdev | xargs brtfs fi defrag '{}'. I
> don't remember the exact command because the history was not saved. I also
> started and stopped it a few times however.
>
> The kernel logs were on a different filesystem. Here is the
> kern.log:http://fpaste.org/9383/36729191/

Apr 28 15:24:05 hotel kernel: [614592.785065] ------------[ cut here
]------------
Apr 28 15:24:05 hotel kernel: [614592.785146] WARNING: at
/build/buildd-linux_3.8.5-1~experimental.1-amd64-_t_ZfP/linux-3.8.5/fs/btrfs/locking.c:46
btrfs_set_lock_blocking_rw+0x6f/0xe7 [btrfs]()
Apr 28 15:24:05 hotel kernel: [614592.785152] Hardware name:
BK169AAR-ABA HPE-210f
Apr 28 15:24:05 hotel kernel: [614592.785157] Modules linked in:
nls_utf8 nls_cp437 vfat fat cbc ecb parport_pc ppdev lp parport bnep
rfcomm bluetooth binfmt_misc nfsd auth_rpcgss nfs_acl nfs lockd
dns_resolver fscache sunrpc loop ecryptfs arc4 snd_hda_codec_hdmi
snd_hda_codec_realtek ath9k ath9k_common ath9k_hw ath mac80211
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm acpi_cpufreq
snd_page_alloc radeon mperf ttm snd_seq cfg80211 kvm_amd kvm
sp5100_tco snd_seq_device snd_timer rfkill drm_kms_helper drm snd
edac_mce_amd edac_core k10temp i2c_piix4 i2c_algo_bit soundcore
microcode i2c_core button processor psmouse evdev serio_raw
thermal_sys pcspkr ext4 crc16 jbd2 mbcache btrfs zlib_deflate crc32c
libcrc32c hid_generic usbhid hid usb_storage sg sr_mod cdrom sd_mod
crc_t10dif firewire_ohci firewire_core crc_itu_t ehci_pci ohci_hcd
ehci_hcd ahci libahci libata usbcore r8169 mii scsi_mod usb_common
Apr 28 15:24:05 hotel kernel: [614592.785279] Pid: 24757, comm: btrfs
Not tainted 3.8-trunk-amd64 #1 Debian 3.8.5-1~experimental.1
Apr 28 15:24:05 hotel kernel: [614592.785284] Call Trace:
Apr 28 15:24:05 hotel kernel: [614592.785299]  [<ffffffff8103ce60>] ?
warn_slowpath_common+0x76/0x8a
Apr 28 15:24:05 hotel kernel: [614592.785350]  [<ffffffffa01b4a0c>] ?
btrfs_set_lock_blocking_rw+0x6f/0xe7 [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.785386]  [<ffffffffa0172a03>] ?
btrfs_realloc_node+0xef/0x380 [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.785434]  [<ffffffffa019d766>] ?
btrfs_defrag_leaves+0x242/0x304 [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.785479]  [<ffffffffa018e863>] ?
btrfs_defrag_root+0x4f/0x9e [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.785526]  [<ffffffffa01b263f>] ?
btrfs_ioctl_defrag+0xb2/0x194 [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.785574]  [<ffffffffa01b32a7>] ?
btrfs_ioctl+0x771/0x175a [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.785584]  [<ffffffff810e2660>] ?
handle_mm_fault+0x1eb/0x239
Apr 28 15:24:05 hotel kernel: [614592.785594]  [<ffffffff81384fde>] ?
__do_page_fault+0x2d7/0x375
Apr 28 15:24:05 hotel kernel: [614592.785605]  [<ffffffff81117aaa>] ?
vfs_ioctl+0x1e/0x31
Apr 28 15:24:05 hotel kernel: [614592.785613]  [<ffffffff811182e2>] ?
do_vfs_ioctl+0x3ee/0x430
Apr 28 15:24:05 hotel kernel: [614592.785624]  [<ffffffff810fb5e4>] ?
kmem_cache_free+0x44/0x80
Apr 28 15:24:05 hotel kernel: [614592.785632]  [<ffffffff81118371>] ?
sys_ioctl+0x4d/0x7c
Apr 28 15:24:05 hotel kernel: [614592.785642]  [<ffffffff813871e9>] ?
system_call_fastpath+0x16/0x1b
Apr 28 15:24:05 hotel kernel: [614592.785648] ---[ end trace
2150df5c163b6833 ]---
Apr 28 15:24:05 hotel kernel: [614592.785693] ------------[ cut here
]------------
Apr 28 15:24:05 hotel kernel: [614592.785813] kernel BUG at
/build/buildd-linux_3.8.5-1~experimental.1-amd64-_t_ZfP/linux-3.8.5/fs/btrfs/locking.c:265!
Apr 28 15:24:05 hotel kernel: [614592.786054] invalid opcode: 0000 [#1] SMP
Apr 28 15:24:05 hotel kernel: [614592.786158] Modules linked in:
nls_utf8 nls_cp437 vfat fat cbc ecb parport_pc ppdev lp parport bnep
rfcomm bluetooth binfmt_misc nfsd auth_rpcgss nfs_acl nfs lockd
dns_resolver fscache sunrpc loop ecryptfs arc4 snd_hda_codec_hdmi
snd_hda_codec_realtek ath9k ath9k_common ath9k_hw ath mac80211
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm acpi_cpufreq
snd_page_alloc radeon mperf ttm snd_seq cfg80211 kvm_amd kvm
sp5100_tco snd_seq_device snd_timer rfkill drm_kms_helper drm snd
edac_mce_amd edac_core k10temp i2c_piix4 i2c_algo_bit soundcore
microcode i2c_core button processor psmouse evdev serio_raw
thermal_sys pcspkr ext4 crc16 jbd2 mbcache btrfs zlib_deflate crc32c
libcrc32c hid_generic usbhid hid usb_storage sg sr_mod cdrom sd_mod
crc_t10dif firewire_ohci firewire_core crc_itu_t ehci_pci ohci_hcd
ehci_hcd ahci libahci libata usbcore r8169 mii scsi_mod usb_common
Apr 28 15:24:05 hotel kernel: [614592.788282] CPU 2
Apr 28 15:24:05 hotel kernel: [614592.788337] Pid: 24757, comm: btrfs
Tainted: G        W    3.8-trunk-amd64 #1 Debian
3.8.5-1~experimental.1 HP-Pavilion BK169AAR-ABA HPE-210f/ALOE
Apr 28 15:24:05 hotel kernel: [614592.788634] RIP:
0010:[<ffffffffa01b47b0>]  [<ffffffffa01b47b0>]
btrfs_assert_tree_locked+0x7/0xa [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.788899] RSP:
0018:ffff88021b017c20  EFLAGS: 00010246
Apr 28 15:24:05 hotel kernel: [614592.789023] RAX: 0000000000000000
RBX: ffff88003396f310 RCX: 0000000005ad05ad
Apr 28 15:24:05 hotel kernel: [614592.789186] RDX: 000000000000fa56
RSI: 0000000000000046 RDI: ffff88003396f310
Apr 28 15:24:05 hotel kernel: [614592.789349] RBP: 0000000000000000
R08: 0000000000000002 R09: 0000000000000000
Apr 28 15:24:05 hotel kernel: [614592.789511] R10: 0000000000000000
R11: 0000000000001a00 R12: 0000000000000001
Apr 28 15:24:05 hotel kernel: [614592.789674] R13: 0000000000000000
R14: 0000000000000000 R15: ffff8802263d4800
Apr 28 15:24:05 hotel kernel: [614592.789838] FS:
00007f8c21ad1760(0000) GS:ffff88022fc80000(0000)
knlGS:00000000ef3fcb70
Apr 28 15:24:05 hotel kernel: [614592.790022] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Apr 28 15:24:05 hotel kernel: [614592.790155] CR2: 0000000001239f08
CR3: 0000000135ab3000 CR4: 00000000000007e0
Apr 28 15:24:05 hotel kernel: [614592.790318] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Apr 28 15:24:05 hotel kernel: [614592.790481] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 28 15:24:05 hotel kernel: [614592.790644] Process btrfs (pid:
24757, threadinfo ffff88021b016000, task ffff8800510dc180)
Apr 28 15:24:05 hotel kernel: [614592.790830] Stack:
Apr 28 15:24:05 hotel kernel: [614592.790879]  ffffffffa01b4a1d
0000000000000000 0000000000000000 ffff88003396f310
Apr 28 15:24:05 hotel kernel: [614592.791065]  ffffffffa0172a03
6c000000000000d4 0000000000000000 ffff880100000000
Apr 28 15:24:05 hotel kernel: [614592.791250]  0000003d00001000
00000000000533ba ffff88021b017d27 ffff8801855b6630
Apr 28 15:24:05 hotel kernel: [614592.791435] Call Trace:
Apr 28 15:24:05 hotel kernel: [614592.791542]  [<ffffffffa01b4a1d>] ?
btrfs_set_lock_blocking_rw+0x80/0xe7 [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.791742]  [<ffffffffa0172a03>] ?
btrfs_realloc_node+0xef/0x380 [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.791940]  [<ffffffffa019d766>] ?
btrfs_defrag_leaves+0x242/0x304 [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.792140]  [<ffffffffa018e863>] ?
btrfs_defrag_root+0x4f/0x9e [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.792335]  [<ffffffffa01b263f>] ?
btrfs_ioctl_defrag+0xb2/0x194 [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.792534]  [<ffffffffa01b32a7>] ?
btrfs_ioctl+0x771/0x175a [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.792684]  [<ffffffff810e2660>] ?
handle_mm_fault+0x1eb/0x239
Apr 28 15:24:05 hotel kernel: [614592.792825]  [<ffffffff81384fde>] ?
__do_page_fault+0x2d7/0x375
Apr 28 15:24:05 hotel kernel: [614592.792966]  [<ffffffff81117aaa>] ?
vfs_ioctl+0x1e/0x31
Apr 28 15:24:05 hotel kernel: [614592.793091]  [<ffffffff811182e2>] ?
do_vfs_ioctl+0x3ee/0x430
Apr 28 15:24:05 hotel kernel: [614592.793226]  [<ffffffff810fb5e4>] ?
kmem_cache_free+0x44/0x80
Apr 28 15:24:05 hotel kernel: [614592.793362]  [<ffffffff81118371>] ?
sys_ioctl+0x4d/0x7c
Apr 28 15:24:05 hotel kernel: [614592.793489]  [<ffffffff813871e9>] ?
system_call_fastpath+0x16/0x1b
Apr 28 15:24:05 hotel kernel: [614592.793630] Code: fb ff ff 65 48 8b
04 25 80 c7 00 00 8b 80 04 02 00 00 89 43 60 48 83 c4 48 5b 5d 41 5c
41 5d 41 5e 41 5f c3 8b 47 64 85 c0 75 02 <0f> 0b c3 55 53 48 89 fb 41
52 8b 6f 6c 83 fd 01 7e 02 0f 0b e8
Apr 28 15:24:05 hotel kernel: [614592.794347] RIP
[<ffffffffa01b47b0>] btrfs_assert_tree_locked+0x7/0xa [btrfs]
Apr 28 15:24:05 hotel kernel: [614592.794559]  RSP <ffff88021b017c20>
Apr 28 15:24:05 hotel kernel: [614592.845730] ---[ end trace
2150df5c163b6834 ]---

for the sake of archives (although I didn't grab the previous messages
from the paste).
