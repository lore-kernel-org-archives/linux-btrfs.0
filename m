From: cwillu <cwillu@cwillu.com>
Subject: WARN/BUG on sudden USB device disconnect
Date: Wed, 22 Feb 2012 05:44:54 -0600
Message-ID: <CAE5mzvieVmaZz0yYZRB+OZfYHtLGYtWovbC0UZs_k4m=nwkj9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[740684.492052] usb 1-2: new high-speed USB device number 60 using ehci_hcd
[740684.626091] scsi48 : usb-storage 1-2:1.0
[740685.072051] usb 4-2: new full-speed USB device number 78 using uhci_hcd
[740685.140058] hub 4-0:1.0: unable to enumerate USB device on port 2
[740685.380047] usb 1-4: new high-speed USB device number 61 using ehci_hcd
[740685.632585] scsi 48:0:0:0: Direct-Access     OCZ-SOLI D3
         PQ: 0 ANSI: 2 CCS
[740685.633145] sd 48:0:0:0: Attached scsi generic sg6 type 0
[740685.633814] sd 48:0:0:0: [sdf] 117231408 512-byte logical blocks:
(60.0 GB/55.8 GiB)
[740685.634578] sd 48:0:0:0: [sdf] Write Protect is off
[740685.634582] sd 48:0:0:0: [sdf] Mode Sense: 28 00 00 00
[740685.635957] sd 48:0:0:0: [sdf] No Caching mode page present
[740685.635961] sd 48:0:0:0: [sdf] Assuming drive cache: write through
[740685.638563] sd 48:0:0:0: [sdf] No Caching mode page present
[740685.638568] sd 48:0:0:0: [sdf] Assuming drive cache: write through
[740685.641024]  sdf: sdf1 sdf2
[740685.643699] sd 48:0:0:0: [sdf] No Caching mode page present
[740685.643705] sd 48:0:0:0: [sdf] Assuming drive cache: write through
[740685.643709] sd 48:0:0:0: [sdf] Attached SCSI disk
[740685.912018] usb 1-4: device not accepting address 61, error -71
[740686.024028] usb 1-4: new high-speed USB device number 62 using ehci_hcd
[740686.552021] usb 1-4: device not accepting address 62, error -71
[740686.664032] usb 1-4: new high-speed USB device number 63 using ehci_hcd
[740687.080026] usb 1-4: device not accepting address 63, error -71
[740687.192040] usb 1-4: new high-speed USB device number 64 using ehci_hcd
[740687.228444] usb 1-4: device descriptor read/8, error -71
[740687.362316] usb 1-4: device descriptor read/8, error -71
[740687.464051] hub 1-0:1.0: unable to enumerate USB device on port 4
[740687.856045] usb 4-2: new full-speed USB device number 79 using uhci_hcd
[740687.924057] hub 4-0:1.0: unable to enumerate USB device on port 2

[740688.202114] device fsid b2eb2c37-01f6-4e77-b20d-5ca60bffb3cd devid
1 transid 440 /dev/sdf2
[740688.202661] btrfs: disk space caching is enabled
[740688.264483] EXT4-fs (sdf1): mounted filesystem with ordered data
mode. Opts: (null)

[740688.404038] usb 4-2: new full-speed USB device number 80 using uhci_hcd
[740688.472080] hub 4-0:1.0: unable to enumerate USB device on port 2
[740688.712033] usb 1-4: new high-speed USB device number 66 using ehci_hcd
[740689.240021] usb 1-4: device not accepting address 66, error -71
[740689.352044] usb 1-4: new high-speed USB device number 67 using ehci_hcd
[740689.420324] hub 1-0:1.0: unable to enumerate USB device on port 4
[740689.684035] usb 4-2: new full-speed USB device number 81 using uhci_hcd
[740689.848047] usb 4-2: not running at top speed; connect to a high speed hub
[740689.868076] usb 4-2: string descriptor 0 read error: -84
[740689.873068] usb 4-2: can't set config #1, error -84

[740705.534109] usb 1-2: USB disconnect, device number 60
[740705.549258] ------------[ cut here ]------------
[740705.549291] WARNING: at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:4921
__btrfs_free_extent+0x610/0x700 [btrfs]()
[740705.549294] Hardware name: System Product Name
[740705.549295] Modules linked in: xts gf128mul ufs qnx4 hfsplus hfs
minix ntfs vfat msdos fat jfs xfs reiserfs ext2 binfmt_misc ppdev
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables
x_tables bridge stp snd_hda_codec_realtek snd_hda_intel aes_x86_64
snd_hda_codec dm_crypt lp mac_hid asus_atk0110 snd_hwdep snd_pcm
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device snd soundcore parport snd_page_alloc raid10 raid456
async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq
async_tx raid1 raid0 multipath linear btrfs zlib_deflate libcrc32c
radeon ttm drm_kms_helper drm firewire_ohci firewire_core i2c_algo_bit
crc_itu_t r8169 pata_jmicron usb_storage
[740705.549345] Pid: 9544, comm: umount Tainted: G        W
3.3.0-030300rc3-generic #201202082335
[740705.549348] Call Trace:
[740705.549356]  [<ffffffff810518bf>] warn_slowpath_common+0x7f/0xc0
[740705.549360]  [<ffffffff8105191a>] warn_slowpath_null+0x1a/0x20
[740705.549373]  [<ffffffffa01be470>] __btrfs_free_extent+0x610/0x700 [btrfs]
[740705.549386]  [<ffffffffa01be6ba>] run_delayed_tree_ref+0x15a/0x160 [btrfs]
[740705.549390]  [<ffffffff8165f54e>] ? _raw_spin_lock+0xe/0x20
[740705.549403]  [<ffffffffa01be8ba>] run_one_delayed_ref+0x9a/0xc0 [btrfs]
[740705.549416]  [<ffffffffa01be9ae>] run_clustered_refs+0xce/0x2d0 [btrfs]
[740705.549429]  [<ffffffffa01b6cc4>] ? do_chunk_alloc+0x1c4/0x3b0 [btrfs]
[740705.549442]  [<ffffffffa01bed37>] btrfs_run_delayed_refs+0x187/0x3f0 [btrfs]
[740705.549454]  [<ffffffffa01ac7ca>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[740705.549469]  [<ffffffffa0219526>] ?
btrfs_run_delayed_items+0xa6/0x120 [btrfs]
[740705.549484]  [<ffffffffa01ce70a>]
btrfs_commit_transaction+0x3ba/0x900 [btrfs]
[740705.549498]  [<ffffffffa01cdc7c>] ? wait_current_trans+0x10c/0x120 [btrfs]
[740705.549512]  [<ffffffffa01cee0c>] ? join_transaction+0xdc/0x2d0 [btrfs]
[740705.549516]  [<ffffffff81075930>] ? wake_up_bit+0x40/0x40
[740705.549528]  [<ffffffffa01a9240>] btrfs_sync_fs+0x70/0xd0 [btrfs]
[740705.549533]  [<ffffffff811af803>] __sync_filesystem+0x63/0x90
[740705.549537]  [<ffffffff811af91b>] sync_filesystem+0x4b/0x70
[740705.549541]  [<ffffffff81183a7b>] generic_shutdown_super+0x3b/0xf0
[740705.549545]  [<ffffffff81183bc6>] kill_anon_super+0x16/0x30
[740705.549556]  [<ffffffffa01aa5da>] btrfs_kill_super+0x1a/0x90 [btrfs]
[740705.549560]  [<ffffffff8118410d>] deactivate_locked_super+0x3d/0x90
[740705.549563]  [<ffffffff81184c5a>] deactivate_super+0x4a/0x70
[740705.549566]  [<ffffffff8119fe8a>] mntput_no_expire+0x11a/0x190
[740705.549570]  [<ffffffff811a08f2>] sys_umount+0x72/0xe0
[740705.549573]  [<ffffffff81667c29>] system_call_fastpath+0x16/0x1b
[740705.549576] ---[ end trace e9d382c323a01f35 ]---
[740705.549578] btrfs unable to find ref byte nr 1149063168 parent 0
root 5  owner 0 offset 0
[740705.549588] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[740705.568483] IP: [<ffffffffa01efade>]
map_private_extent_buffer+0xe/0x160 [btrfs]
[740705.568483] PGD 221343067 PUD 12665a067 PMD 0
[740705.568483] Oops: 0000 [#1] SMP
[740705.568483] CPU 0
[740705.568483] Modules linked in: xts gf128mul ufs qnx4 hfsplus hfs
minix ntfs vfat msdos fat jfs xfs reiserfs ext2 binfmt_misc ppdev
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables
x_tables bridge stp snd_hda_codec_realtek snd_hda_intel aes_x86_64
snd_hda_codec dm_crypt lp mac_hid asus_atk0110 snd_hwdep snd_pcm
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device snd soundcore parport snd_page_alloc raid10 raid456
async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq
async_tx raid1 raid0 multipath linear btrfs zlib_deflate libcrc32c
radeon ttm drm_kms_helper drm firewire_ohci firewire_core i2c_algo_bit
crc_itu_t r8169 pata_jmicron usb_storage
[740705.568483]
[740705.568483] Pid: 9544, comm: umount Tainted: G        W
3.3.0-030300rc3-generic #201202082335 System manufacturer System
Product Name/P5Q3
[740705.568483] RIP: 0010:[<ffffffffa01efade>]  [<ffffffffa01efade>]
map_private_extent_buffer+0xe/0x160 [btrfs]
[740705.568483] RSP: 0000:ffff8801ccb07988  EFLAGS: 00010296
[740705.568483] RAX: 0000000000000064 RBX: 0000000000000065 RCX:
ffff8801ccb079c8
[740705.568483] RDX: 0000000000000004 RSI: 000000000000007a RDI:
0000000000000000
[740705.568483] RBP: ffff8801ccb079a8 R08: ffff8801ccb079c0 R09:
ffff8801ccb079b8
[740705.568483] R10: 0000000000000000 R11: 000000000000000e R12:
000000000000007a
[740705.568483] R13: 0000000000000000 R14: 00000000fffffffb R15:
0000000000000000
[740705.568483] FS:  00007f4f51ae9740(0000) GS:ffff88023fc00000(0000)
knlGS:0000000000000000
[740705.568483] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[740705.568483] CR2: 0000000000000000 CR3: 00000001c68ba000 CR4:
00000000000006f0
[740705.568483] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[740705.568483] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[740705.568483] Process umount (pid: 9544, threadinfo
ffff8801ccb06000, task ffff880233c60000)
[740705.568483] Stack:
[740705.568483]  00000000fffffffb 0000000000000000 ffff8801ccb079f8
0000000000000065
[740705.568483]  ffff8801ccb079f8 ffffffffa01e14fc ffff8801ccb079c8
ffff880231ebd1b0
[740705.568483]  0000000000000005 00000000447d5000 0000000000000000
ffff880231ebd1b0
[740705.568483] Call Trace:
[740705.568483]  [<ffffffffa01e14fc>] btrfs_item_size+0x3c/0x80 [btrfs]
[740705.568483]  [<ffffffffa01be0b7>] __btrfs_free_extent+0x257/0x700 [btrfs]
[740705.568483]  [<ffffffffa01be6ba>] run_delayed_tree_ref+0x15a/0x160 [btrfs]
[740705.568483]  [<ffffffff8165f54e>] ? _raw_spin_lock+0xe/0x20
[740705.568483]  [<ffffffffa01be8ba>] run_one_delayed_ref+0x9a/0xc0 [btrfs]
[740705.568483]  [<ffffffffa01be9ae>] run_clustered_refs+0xce/0x2d0 [btrfs]
[740705.568483]  [<ffffffffa01b6cc4>] ? do_chunk_alloc+0x1c4/0x3b0 [btrfs]
[740705.568483]  [<ffffffffa01bed37>] btrfs_run_delayed_refs+0x187/0x3f0 [btrfs]
[740705.568483]  [<ffffffffa01ac7ca>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[740705.568483]  [<ffffffffa0219526>] ?
btrfs_run_delayed_items+0xa6/0x120 [btrfs]
[740705.568483]  [<ffffffffa01ce70a>]
btrfs_commit_transaction+0x3ba/0x900 [btrfs]
[740705.568483]  [<ffffffffa01cdc7c>] ? wait_current_trans+0x10c/0x120 [btrfs]
[740705.568483]  [<ffffffffa01cee0c>] ? join_transaction+0xdc/0x2d0 [btrfs]
[740705.568483]  [<ffffffff81075930>] ? wake_up_bit+0x40/0x40
[740705.568483]  [<ffffffffa01a9240>] btrfs_sync_fs+0x70/0xd0 [btrfs]
[740705.568483]  [<ffffffff811af803>] __sync_filesystem+0x63/0x90
[740705.568483]  [<ffffffff811af91b>] sync_filesystem+0x4b/0x70
[740705.568483]  [<ffffffff81183a7b>] generic_shutdown_super+0x3b/0xf0
[740705.568483]  [<ffffffff81183bc6>] kill_anon_super+0x16/0x30
[740705.568483]  [<ffffffffa01aa5da>] btrfs_kill_super+0x1a/0x90 [btrfs]
[740705.568483]  [<ffffffff8118410d>] deactivate_locked_super+0x3d/0x90
[740705.568483]  [<ffffffff81184c5a>] deactivate_super+0x4a/0x70
[740705.568483]  [<ffffffff8119fe8a>] mntput_no_expire+0x11a/0x190
[740705.568483]  [<ffffffff811a08f2>] sys_umount+0x72/0xe0
[740705.568483]  [<ffffffff81667c29>] system_call_fastpath+0x16/0x1b
[740705.568483] Code: 80 8f 22 a0 e8 44 1e e6 e0 48 8b 03 e9 e4 fc ff
ff 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 48 83 ec 18 66
66 66 66 90 <48> 8b 1f 81 e3 ff 0f 00 00 48 8d 04 1e 4c 8d 54 10 ff 49
89 c3
[740705.568483] RIP  [<ffffffffa01efade>]
map_private_extent_buffer+0xe/0x160 [btrfs]
[740705.568483]  RSP <ffff8801ccb07988>
[740705.568483] CR2: 0000000000000000
[740706.960268] Buffer I/O error on device sdf1, logical block 32769
[740706.988241] lost page write due to I/O error on sdf1
[740707.071488] ---[ end trace e9d382c323a01f36 ]---
[740707.076044] JBD2: I/O error detected when updating journal
superblock for sdf1-8.
