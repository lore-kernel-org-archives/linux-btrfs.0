From: Jan Engelhardt <jengelh@medozas.de>
Subject: Bug at extent-tree.c:3190
Date: Tue, 3 Mar 2009 04:09:38 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903030406580.2311@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,



The following oops was obtained by doing some copying; it's tainted-P by 
nvidia but maybe it still gives some hints.
The testcase is basically

$ rsync -HPSav a/ b/

where by a/ is a collection of kernel trees, and b/ is a fresh btrfs.

$ ls -l a/
drwxr-xr-x 19 jengelh users 4096 Jan 10 07:32 linux17
drwxr-xr-x 19 jengelh users 4096 Jan 10 07:34 linux18
drwxr-xr-x 19 jengelh users 4096 Jan 10 07:34 linux19
drwxr-xr-x 19 jengelh users 4096 Jan 10 07:34 linux20
drwxr-xr-x 19 jengelh users 4096 Jan 10 07:35 linux21
drwxr-xr-x 19 jengelh users 4096 Jan 10 07:35 linux22
drwxr-xr-x 19 jengelh users 4096 Jan 10 07:35 linux23
drwxr-xr-x 20 jengelh users 4096 Jan 10 07:35 linux24
drwxr-xr-x 21 jengelh users 4096 Jan 10 07:36 linux25
drwxr-xr-x 21 jengelh users 4096 Jan 10 07:36 linux26
drwxr-xr-x 22 jengelh users 4096 Jan 10 07:37 linux27
drwxr-xr-x 22 jengelh users 4096 Jan 10 07:37 linux28



btrfs searching for 98304 bytes, num_bytes 98304, loop 2, allowed_alloc 1
btrfs searching for 49152 bytes, num_bytes 49152, loop 2, allowed_alloc 1
btrfs searching for 24576 bytes, num_bytes 24576, loop 2, allowed_alloc 1
btrfs searching for 12288 bytes, num_bytes 12288, loop 2, allowed_alloc 1
btrfs searching for 45056 bytes, num_bytes 45056, loop 2, allowed_alloc 1
btrfs searching for 20480 bytes, num_bytes 20480, loop 2, allowed_alloc 1
btrfs searching for 8192 bytes, num_bytes 8192, loop 2, allowed_alloc 1
btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 1
btrfs allocation failed flags 1, wanted 4096
space_info has 0 free, is full
block group 12582912 has 8388608 bytes, 8388608 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 244056064 has 429457408 bytes, 429457408 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 673513472 has 429457408 bytes, 429457408 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 1102970880 has 429457408 bytes, 429457408 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 1747124224 has 429457408 bytes, 429457408 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 2176581632 has 429457408 bytes, 429457408 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 2606039040 has 429457408 bytes, 429457408 used 0 pinned 0 reserved
0 blocks of free space at or bigger than bytes is
block group 3250192384 has 392298496 bytes, 392208384 used 0 pinned 90112 reserved
0 blocks of free space at or bigger than bytes is
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:3190!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:0d.0/modalias
Modules linked in: btrfs zlib_deflate crc32c libcrc32c snd_cs46xx af_packet snd_pcm_oss snd_mixer_oss nfs lockd nfs_acl auth_rpcgss sunrpc ip6t_REJECT ip6table_filter ip6_tables ipv6 xt_quota2 xt_dscp xt_connmark xt_CONNMARK iptable_mangle xt_MASQUERADE xt_mark iptable_nat nf_nat xt_DELUDE xt_TARPIT ipt_REJECT xt_CHAOS compat_xtables xt_condition xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_multiport xt_conntrack nf_conntrack iptable_filter iptable_raw ip_tables x_tables fuse sha256_generic cbc dm_crypt nls_iso8859_1 nls_cp437 vfat fat loop aes_i586 aes_generic dm_mod gameport snd_rawmidi snd_seq_device snd_ac97_codec ac97_bus nvidia(P) snd_pcm ppdev snd_timer processor snd thermal_sys rtc_cmos rtc_core sis_agp soundcore hwmon 8139too sis900 rtc_lib sr_mod i2c_core agpgart pci_hotplug pcs
 pkr parport mii snd_page_alloc cdrom sg usbhid hid ehci_hcd ohci_hcd usbcore sd_mod crc_t10dif xfs exportfs pata_sis libata scsi_mod [last unloaded: vmnet]

Pid: 8223, comm: pdflush Tainted: P           (2.6.29-rc6-jen75-rt #1) L7S7A2
EIP: 0060:[<f10938ea>] EFLAGS: 00010246 CPU: 0
EIP is at __btrfs_reserve_extent+0x266/0x277 [btrfs]
EAX: eefdce90 EBX: d87739c0 ECX: d8773a24 EDX: eefdce90
ESI: c88b7000 EDI: c09b2000 EBP: c2085b94 ESP: c2085b5c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 preempt:00000001
Process pdflush (pid: 8223, ti=c2084000 task=eefdce90 task.ti=c2084000)
Stack:
 f10c8b88 00000001 00000000 00001000 00000000 00000000 00000000 00001000
 d0409350 00000001 00000000 c2085c5b ffffffff c88b7000 c2085bdc f1093930
 00001000 00000000 00001000 00000000 00000000 00000000 d91c0000 00000000
Call Trace:
 [<f1093930>] ? btrfs_reserve_extent+0x35/0x58 [btrfs]
 [<f10a541a>] ? cow_file_range+0x1fa/0x3b5 [btrfs]
 [<f10a5cdf>] ? cow_file_range_async+0x53/0x2be [btrfs]
 [<f10b5f2b>] ? test_range_bit+0x120/0x12a [btrfs]
 [<f10b92bc>] ? find_lock_delalloc_range+0x153/0x1ba [btrfs]
 [<f10a5f9a>] ? run_delalloc_range+0x50/0x5b [btrfs]
 [<f10b9bd8>] ? __extent_writepage+0x232/0x8c9 [btrfs]
 [<c0219c19>] ? radix_tree_gang_lookup_tag_slot+0x76/0x95
 [<c0172373>] ? find_get_pages_tag+0xa6/0xd8
 [<c01272b1>] ? wake_up_process+0x11/0x13
 [<f10b6fc0>] ? extent_write_cache_pages+0x106/0x1ee [btrfs]
 [<f10a3911>] ? btrfs_writepages+0x0/0x1f [btrfs]
 [<f10b70d9>] ? extent_writepages+0x31/0x53 [btrfs]
 [<f10b99a6>] ? __extent_writepage+0x0/0x8c9 [btrfs]
 [<f10b5721>] ? flush_write_bio+0x0/0x26 [btrfs]
 [<f10a3a3b>] ? btrfs_get_extent+0x0/0x853 [btrfs]
 [<f10a392b>] ? btrfs_writepages+0x1a/0x1f [btrfs]
 [<c017814c>] ? do_writepages+0x23/0x34
 [<c01ae0c2>] ? __sync_single_inode+0x57/0x1fe
 [<c01ae38a>] ? __writeback_single_inode+0x121/0x129
 [<f109ce96>] ? btrfs_congested_fn+0x21/0x61 [btrfs]
 [<c01ae76d>] ? generic_sync_sb_inodes+0x247/0x3b8
 [<c01aea6f>] ? writeback_inodes+0x6e/0xb5
 [<c0178779>] ? background_writeout+0x79/0xa5
 [<c0178f82>] ? __pdflush+0xe5/0x181
 [<c017901e>] ? pdflush+0x0/0x42
 [<c0179057>] ? pdflush+0x39/0x42
 [<c0178700>] ? background_writeout+0x0/0xa5
 [<c013c9f7>] ? kthread+0x3b/0x61
 [<c013c9bc>] ? kthread+0x0/0x61
 [<c0103ff7>] ? kernel_thread_helper+0x7/0x10
Code: 43 38 39 c2 75 dd 31 db ff 75 0c ff 75 08 ff 75 f0 ff 75 ec 68 88 8b 0c f1 e8 80 59 29 cf 8b 55 08 89 d8 8b 4d 0c e8 b8 fc ff ff <0f> 0b 83 c4 14 eb fe 8d 65 f4 31 c0 5b 5e 5f 5d c3 55 89 e5 57 
EIP: [<f10938ea>] __btrfs_reserve_extent+0x266/0x277 [btrfs] SS:ESP 0068:c2085b5c
---[ end trace 486dcf52905c5ff8 ]---
