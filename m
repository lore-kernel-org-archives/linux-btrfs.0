From: Tore Anderson <tore.anderson@redpill-linpro.com>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 06 Aug 2009 20:49:39 +0200
Message-ID: <4A7B25C3.4020206@redpill-linpro.com>
References: <4A7A7F9F.1080809@redpill-linpro.com> <4A7A9A04.5010006@redpill-linpro.com> <20090806135436.GD3655@dhcp231-156.rdu.redhat.com> <4A7AE579.1050403@redpill-linpro.com> <20090806142750.GE3655@dhcp231-156.rdu.redhat.com> <4A7B15DD.2010101@redpill-linpro.com> <20090806180432.GG3655@dhcp231-156.rdu.redhat.com> <4A7B1D6D.6090402@redpill-linpro.com> <20090806183712.GH3655@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo-lkml@carfax.org.uk>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090806183712.GH3655@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

* Josef Bacik

> Ok good news is, btrfs-vol -b will fix your problem.  Somehow most of
> your disk has been allocated to use metadata.  So did you have a
> whole bunch of stuff on this disk and then delete it all?  Because
> that would put you in that situation.  If you have not then there is
> likely a bug in the metadata ratio stuff that needs to be fixed.

As far as I know there hasn't been a lot of stuff on the file system,
I'm afraid.  The file system was created by the Fedora 11 installer,
and it has just been used as the system drive (I've got /home on NFS).

btrfs-vol -b / (from btrfs-progs-0.19) made my system crash and burn.
I've was able to get output from dmesg before my SSH sessions started
hanging - maybe you can make anything out of it?  Anyway, right now I
have no more remote access to the box so any further debugging will
have to wait until tomorrow morning.

btrfs relocating chunk 129952120832
btrfs relocating block group 129952120832 flags 1
btrfs allocation failed flags 1, wanted 4096
space_info has 4096 free, is full
space_info total=16647192576, pinned=0, delalloc=57856000, may_use=1691648, used=16645496832
block group 12582912 has 8388608 bytes, 8384512 used 0 pinned 4096 reserved
0 blocks of free space at or bigger than bytes is
block group 1103101952 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 3250585600 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 4324327424 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 5398069248 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 6471811072 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 7545552896 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 30094131200 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 31167873024 has 1073741824 bytes, 1072078848 used 0 pinned 1662976 reserved
0 blocks of free space at or bigger than bytes is
block group 32241614848 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
0 blocks of free space at or bigger than bytes is
block group 40831549440 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 46200258560 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 47274000384 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserve
0 blocks of free space at or bigger than bytes is
block group 49421484032 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 58011418624 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
0 blocks of free space at or bigger than bytes is
block group 128878379008 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 129952120832 has 532676608 bytes, 532672512 used 0 pinned 0 reserved
entry offset 130484793344, bytes 4096
1 blocks of free space at or bigger than bytes is
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:2905!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/sched_mc_power_savings
Modules linked in: nls_utf8 cifs nfs lockd nfs_acl auth_rpcgss ipt_MASQUERADE iptable_nat nf_nat rfcomm sco bridge stp llc bnep l2cap sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq dm_multipath kvm_intel kvm uinput snd_hda_codec_realtek snd_hda_intel firewire_ohci ppdev snd_hda_codec firewire_core i2c_i801 snd_hwdep snd_pcm snd_timer crc_itu_t btusb snd soundcore snd_page_alloc usb_storage parport_pc floppy parport bluetooth sky2 asus_atk0110 hwmon iTCO_wdt iTCO_vendor_support serio_raw pata_jmicron ata_generic pata_acpi btrfs zlib_deflate libcrc32c nouveau drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]  

Pid: 30, comm: pdflush Not tainted (2.6.29.6-213.fc11.i686.PAE #1) P5K-VM
EIP: 0060:[<f8a0d543>] EFLAGS: 00010257 CPU: 1
EIP is at __btrfs_reserve_extent+0x339/0x347 [btrfs]
EAX: f5c8aadc EBX: f5c8aa50 ECX: 00000000 EDX: 00000001
ESI: f5c8aadc EDI: f58c786c EBP: f5c03bfc ESP: f5c03ba4
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process pdflush (pid: 30, ti=f5c02000 task=f5c08000 task.ti=f5c02000)
Stack:
 fffff000 00000000 00000000 f5c03ccb ffffffff ffffffff c1c00000 0000000d
 c3296380 00000024 00000000 00000000 00001000 00000000 00000000 f4d09690
 f5c8aad0 00001000 00000000 0019b000 f5c03ccb f5c03c50 f5c03c48 f8a0d70e
Call Trace:
 [<f8a0d70e>] ? btrfs_reserve_extent+0x40/0x64 [btrfs]
 [<f8a1e0fe>] ? cow_file_range+0x258/0x41b [btrfs]
 [<f8a1ea16>] ? run_delalloc_range+0xb0/0x31f [btrfs]
 [<f8a32c19>] ? __extent_writepage+0x1f6/0x7bd [btrfs]
 [<c0564dfb>] ? __lookup_tag+0x89/0xe3
 [<c0564ec4>] ? radix_tree_gang_lookup_tag_slot+0x6f/0x8e
 [<f8a3352a>] ? extent_write_cache_pages.clone.0+0x10c/0x1ec [btrfs]
 [<f8a33714>] ? extent_writepages+0x3f/0x53 [btrfs]
 [<f8a1c869>] ? btrfs_get_extent+0x0/0x927 [btrfs]
 [<f8a1c735>] ? btrfs_writepages+0x20/0x25 [btrfs]
 [<c0484bb8>] ? do_writepages+0x25/0x39
 [<c04be369>] ? __writeback_single_inode+0x140/0x241
 [<c0667944>] ? dm_any_congested+0x32/0x3d
 [<f8a15c3b>] ? btrfs_congested_fn+0x38/0x66 [btrfs]
 [<c04be7c7>] ? generic_sync_sb_inodes+0x1d9/0x2f6
 [<c04bea8d>] ? writeback_inodes+0x82/0xca
 [<c0485288>] ? background_writeout+0x7b/0xa7
 [<c04859be>] ? pdflush+0x130/0x1dc
 [<c048520d>] ? background_writeout+0x0/0xa7
 [<c048588e>] ? pdflush+0x0/0x1dc  
 [<c04468bc>] ? kthread+0x41/0x65  
 [<c044687b>] ? kthread+0x0/0x65   
 [<c0409dbf>] ? kernel_thread_helper+0x7/0x10
Code: e8 ef 3e a1 c7 90 8b 9b 80 00 00 00 83 c3 80 8b 83 80 00 00 00 0f 18 00 90 8d 83 80 00 00 00 39 45 e8 75 99 89 f0 e8 0c c9 a3 c7 <0f> 0b eb fe 8d 65 f4 31 c0 5b 5e 5f 5d c3 55 89 e5 57 56 53 83
EIP: [<f8a0d543>] __btrfs_reserve_extent+0x339/0x347 [btrfs] SS:ESP 0068:f5c03ba4
---[ end trace 209348013c0e69ac ]---
btrfs allocation failed flags 1, wanted 4096
space_info has 4096 free, is full  
space_info total=16647192576, pinned=0, delalloc=132501504, may_use=1691648, used=16645500928
block group 12582912 has 8388608 bytes, 8388608 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 1103101952 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 3250585600 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 4324327424 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 5398069248 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 6471811072 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 7545552896 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 30094131200 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 31167873024 has 1073741824 bytes, 1072078848 used 0 pinned 1662976 reserved
0 blocks of free space at or bigger than bytes is
block group 32241614848 has 1073741824 bytes, 1073721344 used 0 pinned 20480 reserved
0 blocks of free space at or bigger than bytes is
block group 40831549440 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 46200258560 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 47274000384 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 49421484032 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 58011418624 has 1073741824 bytes, 1073737728 used 0 pinned 4096 reserved
0 blocks of free space at or bigger than bytes is
block group 128878379008 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 129952120832 has 532676608 bytes, 532672512 used 0 pinned 0 reserved
entry offset 130484793344, bytes 4096
1 blocks of free space at or bigger than bytes is
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:2905!
invalid opcode: 0000 [#2] SMP
last sysfs file: /sys/devices/system/cpu/sched_mc_power_savings
Modules linked in: nls_utf8 cifs nfs lockd nfs_acl auth_rpcgss ipt_MASQUERADE iptable_nat nf_nat rfcomm sco bridge stp llc bnep l2cap sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq dm_multipath kvm_intel kvm uinput snd_hda_codec_realtek snd_hda_intel firewire_ohci ppdev snd_hda_codec firewire_core i2c_i801 snd_hwdep snd_pcm snd_timer crc_itu_t btusb snd soundcore snd_page_alloc usb_storage parport_pc floppy parport bluetooth sky2 asus_atk0110 hwmon iTCO_wdt iTCO_vendor_support serio_raw pata_jmicron ata_generic pata_acpi btrfs zlib_deflate libcrc32c nouveau drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]  

Pid: 2656, comm: btrfs-vol Tainted: G      D    (2.6.29.6-213.fc11.i686.PAE #1) P5K-VM
EIP: 0060:[<f8a0d543>] EFLAGS: 00210257 CPU: 1
EIP is at __btrfs_reserve_extent+0x339/0x347 [btrfs]
EAX: f5c8aadc EBX: f5c8aa50 ECX: 00000000 EDX: 00000001
ESI: f5c8aadc EDI: f58c786c EBP: f09cb7e4 ESP: f09cb78c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process btrfs-vol (pid: 2656, ti=f09ca000 task=f0995860 task.ti=f09ca000)
Stack:
 fffff000 00000000 00000000 f09cb8b3 ffffffff ffffffff 00000000 00000000
 00000000 00000024 00000000 00000000 00001000 00000000 00000000 f4d096f0
 f5c8aad0 00001000 00000000 000aa000 f09cb8b3 f09cb838 f09cb830 f8a0d70e
Call Trace:
 [<f8a0d70e>] ? btrfs_reserve_extent+0x40/0x64 [btrfs]
 [<f8a1e0fe>] ? cow_file_range+0x258/0x41b [btrfs]
 [<f8a1ea16>] ? run_delalloc_range+0xb0/0x31f [btrfs]
 [<f8a32c19>] ? __extent_writepage+0x1f6/0x7bd [btrfs]
 [<c0564dc7>] ? __lookup_tag+0x55/0xe3
 [<c0564ec4>] ? radix_tree_gang_lookup_tag_slot+0x6f/0x8e
 [<f8a3352a>] ? extent_write_cache_pages.clone.0+0x10c/0x1ec [btrfs]
 [<c0716989>] ? _spin_lock_irq+0x21/0x25
 [<c043dac2>] ? run_timer_softirq+0x1ae/0x1c0
 [<f8a33714>] ? extent_writepages+0x3f/0x53 [btrfs]
 [<f8a1c869>] ? btrfs_get_extent+0x0/0x927 [btrfs]
 [<f8a1c735>] ? btrfs_writepages+0x20/0x25 [btrfs]
 [<c0484bb8>] ? do_writepages+0x25/0x39
 [<c04be369>] ? __writeback_single_inode+0x140/0x241
 [<c056459d>] ? prop_fraction_single+0x35/0x55
 [<c04be7c7>] ? generic_sync_sb_inodes+0x1d9/0x2f6
 [<c04bea8d>] ? writeback_inodes+0x82/0xca
 [<c0485464>] ? balance_dirty_pages_ratelimited_nr+0x137/0x23a
 [<f8a0ad09>] ? relocate_inode_pages+0x2fa/0x305 [btrfs]
 [<f8a0ae69>] ? relocate_data_extent+0x155/0x173 [btrfs]
 [<f8a165cf>] ? btrfs_read_fs_root_no_name+0x77/0x100 [btrfs]
 [<f8a0fb0e>] ? relocate_one_extent+0x181/0x371 [btrfs]
 [<f8a18e57>] ? btrfs_end_transaction+0xf/0x11 [btrfs]
 [<f8a0a26f>] ? __alloc_chunk_for_shrink+0x10d/0x125 [btrfs]
 [<f8a0ff52>] ? btrfs_relocate_block_group+0x254/0x3dc [btrfs]
 [<f8a36105>] ? btrfs_relocate_chunk+0x53/0x419 [btrfs]
 [<f8a2e89e>] ? map_private_extent_buffer+0x96/0xb8 [btrfs]
 [<f8a2e90f>] ? map_extent_buffer+0x4f/0x7f [btrfs]
 [<c0425a4b>] ? kunmap_atomic+0x6e/0x7c
 [<f8a2e32f>] ? unmap_extent_buffer+0x11/0x13 [btrfs]
 [<f8a274c1>] ? btrfs_dev_extent_chunk_offset+0xa2/0xae [btrfs]
 [<f8a366b3>] ? btrfs_shrink_device+0x1e8/0x29c [btrfs]
 [<f8a3692a>] ? btrfs_balance+0xec/0x243 [btrfs]
 [<c053947f>] ? avc_has_perm+0x41/0x4e
 [<f8a3a8e1>] ? btrfs_ioctl+0x72c/0x837 [btrfs]
 [<f8a3a1b5>] ? btrfs_ioctl+0x0/0x837 [btrfs]
 [<c04b2623>] ? vfs_ioctl+0x1d/0x76
 [<c04b2f16>] ? do_vfs_ioctl+0x480/0x4ba
 [<c053b04c>] ? selinux_file_ioctl+0x43/0x46
 [<c04b2f96>] ? sys_ioctl+0x46/0x66
 [<c040945f>] ? sysenter_do_call+0x12/0x34
Code: e8 ef 3e a1 c7 90 8b 9b 80 00 00 00 83 c3 80 8b 83 80 00 00 00 0f 18 00 90 8d 83 80 00 00 00 39 45 e8 75 99 89 f0 e8 0c c9 a3 c7 <0f> 0b eb fe 8d 65 f4 31 c0 5b 5e 5f 5d c3 55 89 e5 57 56 53 83
EIP: [<f8a0d543>] __btrfs_reserve_extent+0x339/0x347 [btrfs] SS:ESP 0068:f09cb78c
---[ end trace 209348013c0e69ad ]---

-- 
Tore Anderson
Redpill Linpro AS - http://www.redpill-linpro.com/
Tel: +47 21 54 41 27
