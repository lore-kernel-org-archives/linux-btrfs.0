Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh4.e.nsc.no ([193.213.121.75]:60624 "EHLO nmsh4.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbbL3TIR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 14:08:17 -0500
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <567FEEB6.3080701@online.no>
 <CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
 <56806F06.50309@online.no> <pan$c7935$46be3379$4afc60bd$677c85c5@cox.net>
 <568098B1.2040908@online.no>
 <CAJCQCtRGbKJ6RJ++1rUSuVByC_=mJq4afNV-3CCt_s4gCft92A@mail.gmail.com>
 <5681A4D5.4060203@online.no>
 <CAJCQCtSAm2i0QuXPK5xDWNXvcrg3uo_DU5WYOnOD8Fkgn+c4eQ@mail.gmail.com>
 <5681BDD0.1060407@online.no>
 <CAJCQCtQX6x4Fx_f_RyLmNS3q611Zb_Q+hw025--Fx-zmH1wRvw@mail.gmail.com>
 <5682EABB.8040408@online.no>
 <CAJCQCtSZHpdLhkbSMfJi0RmV9Sa1_h4ea8yJzJMc3CxoLGhK+A@mail.gmail.com>
 <5684231F.7040700@online.no>
From: Waxhead <waxhead@online.no>
Message-ID: <56842B97.5020502@online.no>
Date: Wed, 30 Dec 2015 20:08:07 +0100
MIME-Version: 1.0
In-Reply-To: <5684231F.7040700@online.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Waxhead wrote:
> Chris Murphy wrote:
>> Well all the generations on all devices are now the same, and so are
>> the chunk trees. I haven't looked at them in detail to see if there
>> are any discrepancies among them.
>>
>> If you don't care much for this file system, then you could try btrfs
>> check --repair, using btrfs-progs 4.3.1 or integration branch. I have
>> no idea where btrfsck repair is at with raid56.
>>
>> On the one hand, corruption should be fixed by scrub. But scrub fails
>> with a kernel trace. Maybe btrfs check --repair can fix the tree block
>> corruption since scrub can't, and then if that corruption is fixed,
>> possibly scrub will work.
>>
> I could not care less about this particular filesystem as I wrote in 
> the original post. It's just for having some fun with btrfs. What I 
> find troublesome is that corrupting one (or even two) drives in a 
> Raid6 config fails. Granted the filesystem "works" e.g. I can mount it 
> and access files, but I get a input/output error on a file on this 
> filesystem and btrfs only shows warning (not errors) on device sdg1 
> where the csum failed.
> A raid6 setup should work fine even if two missing disks (or in this 
> case chunks of data) is missing and even if I don't care about this 
> filesystem I care about btrfs getting stable ;) so if I can help I'll 
> keep this filesystem around for a little longer!
>
For your information I tried a balance on the filesystem - a new stack 
trace below (the system is still working).
Sorry for flooding the mailinglist with the stack trace - this is what I 
got from dmesg , hope it is of some use... / gets used... :)

[  243.603661] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.603664] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.603676]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.603687]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.603697]  00000078 eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.603699] Call Trace:
[  243.603716]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.603724]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.603763]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.603798]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.603806]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.603837]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.603877]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.603889]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.603930]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.603969]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.604003]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.604110]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.604152]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.604198]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.604242]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.604282]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.604326]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.604338]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.604345]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.604391]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.604430]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.604437]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.604443]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.604453]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.604460]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.604468]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.604476]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.604520]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.604527]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.604534]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.604542]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.604549]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.604557]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.604563] ---[ end trace eb3e6200cba2a564 ]---
[  243.604654] ------------[ cut here ]------------
[  243.604695] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.604813] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.604837]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.604847] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.604849] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.604862]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.604873]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.604885] Call Trace:
[  243.604898]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.604905]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.604943]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.604975]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.604982]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.605014]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.605053]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.605064]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.605105]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.605145]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.605179]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.605224]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.605270]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.605312]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.605353]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.605397]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.605439]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.605449]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.605456]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.605498]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.605537]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.605547]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.605553]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.605562]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.605569]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.605576]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.605584]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.605627]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.605634]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.605641]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.605650]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.605657]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.605664]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.605669] ---[ end trace eb3e6200cba2a565 ]---
[  243.605717] ------------[ cut here ]------------
[  243.605757] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.605866] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.605889]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.605897] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.605899] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.605911]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.605923]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.605937]  0000007a eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.605938] Call Trace:
[  243.605949]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.605956]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.605994]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.606030]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.606037]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.606069]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.606106]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.606117]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.606157]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.606200]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.606235]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.606276]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.606321]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.606368]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.606411]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.606450]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.606493]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.606504]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.606511]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.606556]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.606595]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.606602]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.606608]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.606617]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.606624]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.606632]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.606639]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.606682]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.606689]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.606696]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.606704]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.606710]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.606718]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.606722] ---[ end trace eb3e6200cba2a566 ]---
[  243.625448] ------------[ cut here ]------------
[  243.625496] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.625624] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.625654]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.625664] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.625666] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.625680]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.625692]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.625702]  0000001e eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.625704] Call Trace:
[  243.625720]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.625728]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.625767]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.625800]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.625809]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.625844]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.625885]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.625896]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.625936]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.625974]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.626012]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.626060]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.626102]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.626143]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.626188]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.626234]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.626274]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.626285]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.626291]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.626335]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.626380]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.626388]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.626395]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.626404]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.626410]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.626419]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.626428]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.626471]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.626479]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.626487]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.626494]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.626501]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.626509]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.626514] ---[ end trace eb3e6200cba2a567 ]---
[  243.643463] ------------[ cut here ]------------
[  243.643510] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.643638] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.643665]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.643674] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.643677] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.643691]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.643701]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.643716]  00000025 eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.643718] Call Trace:
[  243.643734]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.643743]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.643782]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.643818]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.643826]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.643858]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.643898]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.643910]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.643951]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.643990]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.644022]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.644098]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.644143]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.644184]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.644225]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.644269]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.644314]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.644324]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.644331]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.644371]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.644410]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.644419]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.644426]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.644435]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.644442]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.644450]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.644458]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.644502]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.644510]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.644517]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.644525]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.644532]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.644542]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.644547] ---[ end trace eb3e6200cba2a568 ]---
[  243.644698] ------------[ cut here ]------------
[  243.644739] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.644854] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.644878]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.644887] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.644890] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.644902]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.644913]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.644924]  00000038 eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.644925] Call Trace:
[  243.644937]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.644944]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.644978]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.645015]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.645023]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.645059]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.645099]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.645109]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.645149]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.645192]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.645228]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.645270]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.645313]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.645360]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.645404]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.645444]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.645487]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.645497]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.645504]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.645550]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.645589]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.645596]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.645602]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.645611]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.645617]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.645625]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.645633]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.645677]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.645684]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.645691]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.645699]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.645706]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.645714]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.645718] ---[ end trace eb3e6200cba2a569 ]---
[  243.647013] ------------[ cut here ]------------
[  243.647053] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.647164] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.647187]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.647195] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.647201] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.647214]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.647224]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.647235]  00000075 eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.647237] Call Trace:
[  243.647248]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.647255]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.647294]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.647327]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.647334]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.647365]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.647405]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.647416]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.647457]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.647496]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.647531]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.647576]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.647621]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.647664]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.647705]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.647748]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.647793]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.647803]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.647810]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.647850]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.647889]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.647898]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.647904]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.647913]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.647919]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.647928]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.647936]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.647980]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.647988]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.647995]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.648002]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.648043]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.648051]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.648057] ---[ end trace eb3e6200cba2a56a ]---
[  243.648139] ------------[ cut here ]------------
[  243.648181] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.648292] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.648315]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.648324] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.648326] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.648342]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.648353]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.648363]  00000078 eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.648365] Call Trace:
[  243.648376]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.648383]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.648421]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.648456]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.648463]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.648495]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.648534]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.648545]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.648586]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.648625]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.648659]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.648704]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.648749]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.648791]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.648832]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.648876]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.648921]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.648930]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.648937]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.648976]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.649016]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.649025]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.649031]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.649040]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.649046]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.649054]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.649062]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.649105]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.649112]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.649119]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.649128]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.649135]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.649142]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.649147] ---[ end trace eb3e6200cba2a56b ]---
[  243.649514] ------------[ cut here ]------------
[  243.649551] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.649661] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.649683]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.649691] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.649694] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.649708]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.649719]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.649729]  00000006 eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.649731] Call Trace:
[  243.649742]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.649749]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.649787]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.649821]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.649828]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.649859]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.649899]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.649910]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.649950]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.649992]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.650027]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.650072]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.650117]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.650159]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.650201]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.650244]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.650289]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.650299]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.650306]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.650345]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.650384]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.650393]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.650400]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.650409]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.650415]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.650423]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.650430]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.650474]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.650481]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.650488]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.650496]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.650503]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.650509]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.650514] ---[ end trace eb3e6200cba2a56c ]---
[  243.650681] ------------[ cut here ]------------
[  243.650721] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.650831] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.650855]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.650862] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.650865] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.650877]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.650888]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.650897]  00000009 eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.650899] Call Trace:
[  243.650909]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.650918]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.650955]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.650992]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.650999]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.651033]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.651070]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.651081]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.651121]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.651164]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.651199]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.651240]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.651284]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.651331]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.651374]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.651413]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.651457]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.651467]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.651474]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.651520]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.651558]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.651565]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.651571]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.651580]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.651587]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.651595]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.651603]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.651646]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.651653]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.651660]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.651667]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.651674]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.651682]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.651688] ---[ end trace eb3e6200cba2a56d ]---
[  243.662959] ------------[ cut here ]------------
[  243.663002] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.663129] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.663159]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.663169] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.663173] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.663186]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.663198]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.663208]  00000054 eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.663210] Call Trace:
[  243.663226]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.663234]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.663271]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.663304]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.663313]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.663348]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.663390]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.663401]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.663439]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.663477]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.663514]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.663563]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.663604]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.663644]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.663689]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.663735]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.663776]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.663787]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.663793]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.663837]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.663883]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.663890]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.663897]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.663908]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.663914]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.663923]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.663932]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.663975]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.663984]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.663991]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.663999]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.664005]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.664062]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.664068] ---[ end trace eb3e6200cba2a56e ]---
[  243.664145] ------------[ cut here ]------------
[  243.664184] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.664299] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.664323]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.664332] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.664334] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.664349]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.664360]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.664371]  00000055 eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.664372] Call Trace:
[  243.664384]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.664392]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.664430]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.664465]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.664472]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.664504]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.664544]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.664555]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.664596]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.664635]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.664668]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.664713]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.664759]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.664800]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.664841]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.664885]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.664930]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.664939]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.664946]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.664985]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.665023]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.665033]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.665039]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.665049]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.665055]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.665063]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.665071]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.665115]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.665123]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.665130]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.665138]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.665145]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.665152]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.665157] ---[ end trace eb3e6200cba2a56f ]---
[  243.665538] ------------[ cut here ]------------
[  243.665574] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.665687] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.665714]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.665721] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.665724] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.665736]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.665747]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.665757]  0000005f eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.665759] Call Trace:
[  243.665770]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.665777]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.665814]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.665849]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.665851] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.665857]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.665889]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.665927]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.665929] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.665937]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.665972]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.666010]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.666012] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.666043]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.666084]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.666123]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.666125] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.666162]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.666202]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.666243]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.666245] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.666281]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.666290]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.666296]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.666336]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.666338] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.666375]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.666381]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.666387]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.666397]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.666404]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.666411]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.666419]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.666457]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.666459] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.666465]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.666472]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.666479]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.666486]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.666494]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.666496] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.666499] ---[ end trace eb3e6200cba2a570 ]---
[  243.666551] ------------[ cut here ]------------
[  243.666588] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.666694] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.666718]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.666726] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.666729] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.666742]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.666752]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.666762]  00000060 eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.666764] Call Trace:
[  243.666778]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.666785]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.666825]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.666860]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.666868]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.666902]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.666942]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.666954]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.666993]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.667035]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.667072]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.667119]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.667161]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.667207]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.667253]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.667295]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.667336]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.667347]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.667355]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.667398]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.667440]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.667448]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.667455]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.667464]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.667471]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.667479]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.667487]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.667530]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.667537]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.667544]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.667552]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.667559]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.667567]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.667573] ---[ end trace eb3e6200cba2a571 ]---
[  243.667637] ------------[ cut here ]------------
[  243.667676] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.667712] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp
[  243.667713] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.667821]  pcspkr evdev psmouse serio_raw i2c_i801 uvcvideo 
videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev 
media lpc_ich mfd_core btusb btrtl btbcm btintel rng_core bluetooth 
ath5k ath snd_hda_codec_realtek snd_hda_codec_generic mac80211 jmb38x_ms 
snd_hda_intel i915 cfg80211 memstick snd_hda_codec rfkill snd_hda_core 
snd_hwdep drm_kms_helper snd_pcm snd_timer shpchp snd soundcore drm 
i2c_algo_bit wmi battery video ac button acpi_cpufreq processor sg loop 
autofs4 uas usb_storage ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor 
raid6_pq md_mod sd_mod ata_generic ata_piix libata scsi_mod uhci_hcd 
ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common mmc_core r8169 mii
[  243.667830] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.667832] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.667845]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.667856]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.667866]  00000061 eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.667868] Call Trace:
[  243.667881]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.667889]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.667930]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.667966]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.667974]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.668010]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.668093]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.668104]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.668143]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.668183]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.668219]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.668265]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.668308]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.668354]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.668400]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.668443]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.668486]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.668498]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.668505]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.668547]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.668591]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.668599]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.668605]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.668614]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.668620]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.668628]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.668636]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.668678]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.668685]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.668692]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.668702]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.668708]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.668716]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.668722] ---[ end trace eb3e6200cba2a572 ]---
[  243.668791] ------------[ cut here ]------------
[  243.668833] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.668879] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops
[  243.668880] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.668980]  videobuf2_core v4l2_common videodev media lpc_ich 
mfd_core btusb btrtl btbcm btintel rng_core bluetooth ath5k ath 
snd_hda_codec_realtek snd_hda_codec_generic mac80211 jmb38x_ms 
snd_hda_intel i915 cfg80211 memstick snd_hda_codec rfkill snd_hda_core 
snd_hwdep drm_kms_helper snd_pcm snd_timer shpchp snd soundcore drm 
i2c_algo_bit wmi battery video ac button acpi_cpufreq processor sg loop 
autofs4 uas usb_storage ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor 
raid6_pq md_mod sd_mod ata_generic ata_piix libata scsi_mod uhci_hcd 
ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common mmc_core r8169 mii
[  243.668989] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.668991] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.669003]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.669014]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.669024]  00000062 eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.669025] Call Trace:
[  243.669039]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.669047]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.669086]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.669123]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.669131]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.669166]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.669207]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.669218]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.669257]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.669298]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.669335]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.669381]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.669425]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.669471]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.669516]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.669560]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.669603]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.669614]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.669622]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.669666]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.669710]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.669717]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.669723]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.669732]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.669738]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.669746]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.669755]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.669797]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.669805]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.669812]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.669820]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.669827]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.669835]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.669841] ---[ end trace eb3e6200cba2a573 ]---
[  243.669892] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.670194] ------------[ cut here ]------------
[  243.670236] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.670355] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.670381]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.670391] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.670394] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.670407]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.670418]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.670429]  0000006b eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.670431] Call Trace:
[  243.670445]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.670454]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.670494]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.670528]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.670536]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.670572]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.670613]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.670623]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.670662]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.670702]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.670739]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.670783]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.670828]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.670871]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.670913]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.670916] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.670953]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.670991]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.671001]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.671008]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.671046]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.671086]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.671088] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.671094]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.671100]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.671109]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.671116]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.671124]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.671126] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.671132]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.671170]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.671177]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.671184]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.671193]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.671195] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.671200]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.671208]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.671213] ---[ end trace eb3e6200cba2a574 ]---
[  243.671230] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.671279] ------------[ cut here ]------------
[  243.671317] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.671432] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.671457]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.671466] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.671469] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.671482]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.671493]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.671505]  0000006c eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.671507] Call Trace:
[  243.671519]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.671527]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.671566]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.671602]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.671608]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.671643]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.671684]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.671696]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.671736]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.671778]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.671816]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.671861]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.671905]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.671950]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.671995]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.672026]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.672156]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.672168]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.672175]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.672220]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.672259]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.672266]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.672272]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.672281]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.672287]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.672295]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.672297] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.672304]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.672342]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.672349]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.672357]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.672366]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.672368] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.672373]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.672380]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.672387] ---[ end trace eb3e6200cba2a575 ]---
[  243.672403] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.672456] ------------[ cut here ]------------
[  243.672493] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.672610] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.672636]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.672646] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.672649] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.672662]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.672673]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.672684]  0000006d eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.672686] Call Trace:
[  243.672700]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.672708]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.672747]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.672783]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.672789]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.672823]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.672864]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.672876]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.672917]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.672960]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.672997]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.673043]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.673087]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.673131]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.673176]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.673220]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.673262]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.673273]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.673281]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.673324]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.673365]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.673373]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.673380]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.673389]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.673396]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.673403]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.673411]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.673455]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.673462]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.673469]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.673477]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.673483]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.673490]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.673497] ---[ end trace eb3e6200cba2a576 ]---
[  243.673513] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.673563] ------------[ cut here ]------------
[  243.673602] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.673718] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.673744]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.673754] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.673756] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.673770]  00000000 09f7a8eb eef57990 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.673781]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8b18 00000000
[  243.673792]  0000006e eef579a0 c1066962 00000009 00000000 eef57a6c 
f86350ff 00000000
[  243.673794] Call Trace:
[  243.673807]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.673815]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.673854]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.673890]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.673896]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.673931]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.673972]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.673983]  [<c12d4f2e>] ? __percpu_counter_add+0x8e/0xb0
[  243.674024]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.674065]  [<f86520cc>] ? btrfs_should_end_transaction+0x3c/0x60 
[btrfs]
[  243.674104]  [<f863b276>] ? btrfs_drop_snapshot+0x426/0x850 [btrfs]
[  243.674150]  [<f86ae67e>] ? merge_reloc_roots+0xee/0x260 [btrfs]
[  243.674193]  [<f86a9777>] ? remove_backref_node+0x67/0xe0 [btrfs]
[  243.674237]  [<f86aea7f>] ? relocate_block_group+0x28f/0x750 [btrfs]
[  243.674283]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.674326]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.674369]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.674380]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.674387]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.674431]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.674475]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.674482]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.674489]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.674497]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.674503]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.674511]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.674518]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.674520] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.674557]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.674564]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.674571]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.674578]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.674585]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.674593]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.674596] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  243.674599] ---[ end trace eb3e6200cba2a577 ]---
[  243.684117] ------------[ cut here ]------------
[  243.684172] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.684186] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.684538]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.684585] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.684593] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.684601]  00000000 09f7a8eb eef579d8 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.684620]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8bf8 00000000
[  243.684639]  000000aa eef579e8 c1066962 00000009 00000000 eef57ab4 
f86350ff 00000000
[  243.684657] Call Trace:
[  243.684676]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.684689]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.684731]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.684770]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.684782]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.684821]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.684865]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.684880]  [<c10cfeaa>] ? ktime_get+0x4a/0x120
[  243.684895]  [<c109d23b>] ? pick_next_task_fair+0x41b/0x4c0
[  243.684906]  [<c10cb0fb>] ? hrtimer_interrupt+0xbb/0x1a0
[  243.684947]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.684992]  [<f865271c>] ? btrfs_commit_transaction+0x4c/0xe70 [btrfs]
[  243.685035]  [<f86535bd>] ? start_transaction+0x7d/0x5b0 [btrfs]
[  243.685049]  [<c1532aa8>] ? preempt_schedule_common+0x18/0x30
[  243.685060]  [<c1532ae5>] ? _cond_resched+0x25/0x30
[  243.685109]  [<f86aeae2>] ? relocate_block_group+0x2f2/0x750 [btrfs]
[  243.685156]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.685205]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.685252]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.685273]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.685292]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.685339]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.685388]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.685405]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.685425]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.685442]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.685458]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.685478]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.685497]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.685547]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.685563]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.685580]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.685597]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.685613]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.685630]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.685644] ---[ end trace eb3e6200cba2a578 ]---
[  243.685702] ------------[ cut here ]------------
[  243.685747] WARNING: CPU: 0 PID: 1182 at 
/build/linux-P8Ifgy/linux-4.3.3/fs/btrfs/extent-tree.c:6410 
__btrfs_free_extent+0xbbf/0xec0 [btrfs]()
[  243.685762] Modules linked in: cpufreq_stats cpufreq_conservative 
cpufreq_userspace bnep cpufreq_powersave zram zsmalloc lz4_compress nfsd 
auth_rpcgss oid_registry nfs_acl lockd grace sunrpc joydev iTCO_wdt 
iTCO_vendor_support sparse_keymap arc4 acerhdf coretemp pcspkr evdev 
psmouse serio_raw i2c_i801 uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev media lpc_ich mfd_core btusb btrtl 
btbcm btintel rng_core bluetooth ath5k ath snd_hda_codec_realtek 
snd_hda_codec_generic mac80211 jmb38x_ms snd_hda_intel i915 cfg80211 
memstick snd_hda_codec rfkill snd_hda_core snd_hwdep drm_kms_helper 
snd_pcm snd_timer shpchp snd soundcore drm i2c_algo_bit wmi battery 
video ac button acpi_cpufreq processor sg loop autofs4 uas usb_storage 
ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor
[  243.685928]  raid6_pq md_mod sd_mod ata_generic ata_piix libata 
scsi_mod uhci_hcd ehci_pci ehci_hcd sdhci_pci usbcore sdhci usb_common 
mmc_core r8169 mii
[  243.685969] CPU: 0 PID: 1182 Comm: btrfs Tainted: G W       
4.3.0-1-686-pae #1 Debian 4.3.3-2
[  243.685976] Hardware name: Acer AOA150/        , BIOS v0.3310 10/06/2008
[  243.685983]  00000000 09f7a8eb eef579d8 c12ae3c5 00000000 c106685d 
c1614e20 00000000
[  243.686001]  0000049e f86df010 0000190a f86350ff 00000009 f86350ff 
f1dd8bf8 00000000
[  243.686019]  0000003d eef579e8 c1066962 00000009 00000000 eef57ab4 
f86350ff 00000000
[  243.686037] Call Trace:
[  243.686051]  [<c12ae3c5>] ? dump_stack+0x3e/0x59
[  243.686063]  [<c106685d>] ? warn_slowpath_common+0x8d/0xc0
[  243.686104]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.686143]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.686155]  [<c1066962>] ? warn_slowpath_null+0x22/0x30
[  243.686195]  [<f86350ff>] ? __btrfs_free_extent+0xbbf/0xec0 [btrfs]
[  243.686239]  [<f86394ae>] ? __btrfs_run_delayed_refs+0x96e/0x11a0 [btrfs]
[  243.686253]  [<c10cfeaa>] ? ktime_get+0x4a/0x120
[  243.686269]  [<c109d23b>] ? pick_next_task_fair+0x41b/0x4c0
[  243.686279]  [<c10cb0fb>] ? hrtimer_interrupt+0xbb/0x1a0
[  243.686321]  [<f863caed>] ? btrfs_run_delayed_refs+0x6d/0x250 [btrfs]
[  243.686365]  [<f865271c>] ? btrfs_commit_transaction+0x4c/0xe70 [btrfs]
[  243.686409]  [<f86535bd>] ? start_transaction+0x7d/0x5b0 [btrfs]
[  243.686420]  [<c1532aa8>] ? preempt_schedule_common+0x18/0x30
[  243.686439]  [<c1532ae5>] ? _cond_resched+0x25/0x30
[  243.686487]  [<f86aeae2>] ? relocate_block_group+0x2f2/0x750 [btrfs]
[  243.686535]  [<f86af118>] ? btrfs_relocate_block_group+0x1d8/0x2e0 
[btrfs]
[  243.686582]  [<f8681bcd>] ? btrfs_relocate_chunk.isra.29+0x3d/0xf0 
[btrfs]
[  243.686629]  [<f868357c>] ? btrfs_balance+0x97c/0x12e0 [btrfs]
[  243.686649]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.686668]  [<c1154c5d>] ? get_page_from_freelist+0x3dd/0x5c0
[  243.686714]  [<f8690c05>] ? btrfs_ioctl_balance+0x385/0x390 [btrfs]
[  243.686761]  [<f86931f3>] ? btrfs_ioctl+0x793/0x2c50 [btrfs]
[  243.686777]  [<c115505b>] ? __alloc_pages_nodemask+0x13b/0x850
[  243.686793]  [<c11b5349>] ? terminate_walk+0x69/0xc0
[  243.686809]  [<c1182edf>] ? anon_vma_prepare+0xdf/0x130
[  243.686828]  [<c118218c>] ? page_add_new_anon_rmap+0x6c/0x90
[  243.686848]  [<c1179823>] ? handle_mm_fault+0xa63/0x14f0
[  243.686864]  [<c12b45c3>] ? __rb_insert_augmented+0xf3/0x1c0
[  243.686911]  [<f8692a60>] ? update_ioctl_balance_args+0x1c0/0x1c0 [btrfs]
[  243.686928]  [<c11be382>] ? do_vfs_ioctl+0x2e2/0x500
[  243.686944]  [<c117e6f3>] ? do_brk+0x113/0x2b0
[  243.686964]  [<c1058900>] ? __do_page_fault+0x1a0/0x460
[  243.686981]  [<c11be608>] ? SyS_ioctl+0x68/0x80
[  243.686997]  [<c1536257>] ? sysenter_do_call+0x12/0x12
[  243.687011] ---[ end trace eb3e6200cba2a579 ]---
[  243.700346] systemd-journald[228]: /dev/kmsg buffer overrun, some 
messages lost.
[  247.003571] perf interrupt took too long (2531 > 2500), lowering 
kernel.perf_event_max_sample_rate to 50000

