From: Lee Trager <lt73@cs.drexel.edu>
Subject: Re: [DEBUG PATCH] for anybody who gets a panic due to ENOSPC
Date: Mon, 17 Nov 2008 20:58:34 -0500
Message-ID: <4922214A.5090904@cs.drexel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: jbacik@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I still get a kernel panic with both of your patches installed. When I
checked with df the file system is about 65% full. But even if it was
full it shouldn't cause a kernel panic.

Lee

Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234036] we were searching
for 24576 bytes, num_bytes 24576, loop 2, allowed alloc 1
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234040] we were searching
for 12288 bytes, num_bytes 12288, loop 2, allowed alloc 1
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234045] we were searching
for 4096 bytes, num_bytes 4096, loop 2, allowed alloc 1
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234080] allocation failed
flags 1, wanted 4096
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234098] space_info has
1580007424 free, is full
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234134] block group
12582912 has 8388608 bytes, 8380416 used 0 pinned 8192 reserved
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234172] 0 blocks of free
space at or bigger than bytes is
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234201] block group
424542208 has 790429696 bytes, 790429696 used 0 pinned 0 reserved
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234204] 0 blocks of free
space at or bigger than bytes is
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234206] block group
1214971904 has 790429696 bytes, 790421504 used 0 pinned 8192 reserved
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234227] 1 blocks of free
space at or bigger than bytes is
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234230] block group
2005401600 has 790429696 bytes, 0 used 0 pinned 0 reserved
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234233] 0 blocks of free
space at or bigger than bytes is
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234235] block group
2795831296 has 790429696 bytes, 851968 used 0 pinned 0 reserved
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234238] 0 blocks of free
space at or bigger than bytes is
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234240] block group
3586260992 has 790429696 bytes, 789479424 used 0 pinned 950272 reserved
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234243] 0 blocks of free
space at or bigger than bytes is
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234284] block group
4376690688 has 790429696 bytes, 786604032 used 0 pinned 3825664 reserved
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234287] 0 blocks of free
space at or bigger than bytes is
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234290] block group
5167120384 has 790429696 bytes, 788373504 used 0 pinned 2056192 reserved
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234292] 0 blocks of free
space at or bigger than bytes is
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234295] block group
5957550080 has 790429696 bytes, 789020672 used 0 pinned 1409024 reserved
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234297] 0 blocks of free
space at or bigger than bytes is
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234302] block group
6747979776 has 752943104 bytes, 721526784 used 0 pinned 31416320 reserved
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234305] 0 blocks of free
space at or bigger than bytes is
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234737] ------------[ cut
here ]------------
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234760] kernel BUG at
/home/ltrager/btrfs/btrfs-unstable-standalone/extent-tree.c:3088!
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234796] invalid opcode:
0000 [#1] SMP  
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.234861] Modules linked in:
btrfs zlib_deflate libcrc32c ipv6 af_packet bridge stp bnep rfcomm sco
l2cap bluetooth ppdev cpufreq_userspace cpufreq_stats cpufreq_powersave
cpufreq_ondemand freq_table cpufreq_conservative wmi video output sbs
sbshc pci_slot battery iptable_filter ip_tables x_tables lp evdev
psmouse serio_raw pcspkr snd_ens1371 gameport snd_ac97_codec ac97_bus
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi parport_pc snd_seq_midi_event parport snd_seq snd_timer
snd_seq_device snd soundcore i2c_piix4 snd_page_alloc container ac
button i2c_core shpchp pci_hotplug intel_agp agpgart btrfs mbcache
sr_mod cdrom sd_mod crc_t10dif pata_acpi sg ata_piix ehci_hcd uhci_hcd
pcnet32 mii ata_generic usbcore mptspi mptscsih mptbase
scsi_transport_spi libata scsi_mod dock thermal processor fan fbcon
tileblit font bitblit softcursor fuse
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235013]  
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235084] Pid: 6150, comm:
bonnie++ Not tainted (2.6.27-7-generic #1)
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235097] EIP:
0060:[<e0d427b2>] EFLAGS: 00010257 CPU: 0
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235365] EIP is at
__btrfs_reserve_extent+0x3c2/0x480 [btrfs]
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235383] EAX: de255464 EBX:
dd4b0300 ECX: ffffffff EDX: 00000001
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235393] ESI: dd4b032c EDI:
de255458 EBP: ddb03a78 ESP: ddb03a04
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235403]  DS: 007b ES: 007b
FS: 00d8 GS: 0033 SS: 0068
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235427] Process bonnie++
(pid: 6150, ti=ddb02000 task=de479920 task.ti=ddb02000)
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235445] Stack: e0d7fc80
92360000 00000001 2ce10000 00000000 2b01a000 00000000 00000000  
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235505]        00000000
01df6000 00000000 00000000 00000000 00000000 00000000 00000001  
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235515]        00000000
00000000 00000000 00000000 00001000 00000000 c8155000 dd076000  
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235527] Call Trace:
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235679]  [<e0d42af7>] ?
btrfs_reserve_extent+0x77/0xb0 [btrfs]
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235986]  [<e0d4fed7>] ?
cow_file_range+0x227/0x4d0 [btrfs]
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.235988]  [<e0d6984c>] ?
lock_extent+0x5c/0xd0 [btrfs]
Nov 17 21:16:50 Intrepid-btrfs kernel: [ 1201.236022]  [<e0d54a30>] ?
run_delalloc_range+0x390/0x400 [btrfs]
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236037]  [<e0d6ca05>] ?
__extent_writepage+0x4a5/0xb30 [btrfs]
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236051]  [<e0d6817d>] ?
map_private_extent_buffer+0x8d/0x120 [btrfs]
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c019339e>] ?
page_address+0xe/0xe0
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c019339e>] ?
page_address+0xe/0xe0
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c011fd28>] ?
kmap_atomic_prot+0x48/0x100
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c0250d2d>] ?
radix_tree_gang_lookup_tag_slot+0x9d/0xc0
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c018409d>] ?
find_get_pages_tag+0x3d/0x130
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c019d0ce>] ?
page_mkclean+0xe/0xb0
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c01917f6>] ?
__dec_zone_state+0x16/0x90
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<e0d693ad>] ?
extent_write_cache_pages+0x1ad/0x2f0 [btrfs]
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<e0d4f370>] ?
btrfs_writepages+0x0/0x30 [btrfs]
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<e0d69526>] ?
extent_writepages+0x36/0x60 [btrfs]
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<e0d6c560>] ?
__extent_writepage+0x0/0xb30 [btrfs]
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<e0d55230>] ?
btrfs_get_extent+0x0/0xad0 [btrfs]
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<e0d4f394>] ?
btrfs_writepages+0x24/0x30 [btrfs]
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c018c4a3>] ?
do_writepages+0x33/0x60
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c01d25dc>] ?
__sync_single_inode+0x5c/0x250
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c01d281a>] ?
__writeback_single_inode+0x4a/0x160
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c024febc>] ?
prop_fraction_single+0x3c/0x70
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c01d2ccc>] ?
generic_sync_sb_inodes+0x27c/0x3b0
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c01d306d>] ?
writeback_inodes+0x4d/0xe0
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c018bd18>] ?
balance_dirty_pages+0x238/0x340
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c018be84>] ?
balance_dirty_pages_ratelimited_nr+0x64/0x70
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<e0d5a51d>] ?
btrfs_file_write+0x3dd/0x6a0 [btrfs]
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c02353be>] ?
apparmor_file_permission+0x1e/0x40
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c01b1fad>] ?
rw_verify_area+0x4d/0xc0
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c01b1764>] ?
generic_file_llseek_unlocked+0x14/0xb0
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c01b24c0>] ?
vfs_write+0xa0/0x110
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<e0d5a140>] ?
btrfs_file_write+0x0/0x6a0 [btrfs]
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c01b2602>] ?
sys_write+0x42/0x70
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069]  [<c0103f7b>] ?
sysenter_do_call+0x12/0x2f
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069] 
=======================
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069] Code: 9c 63 df 8d
4b 44 89 c8 89 4d f0 e8 99 b1 63 df 8b 7b 38 8b 07 0f 18 00 90 83 c3 38
39 fb 89 5d ec 75 33 8b 45 f0 e8 5e 92 40 df <0f> 0b eb fe 66 90 8b 90
90 18 00 00 8b 88 78 18 00 00 8b b0 8c  
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236069] EIP: [<e0d427b2>]
__btrfs_reserve_extent+0x3c2/0x480 [btrfs] SS:ESP 0068:ddb03a04
Nov 17 21:16:51 Intrepid-btrfs kernel: [ 1201.236886] ---[ end trace
db9e9518b4387879 ]---
