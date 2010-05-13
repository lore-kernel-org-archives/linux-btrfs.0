From: Victor Roetman <victory747@gmail.com>
Subject: OOPS when subvol=xxx where xxx does not exist
Date: Thu, 13 May 2010 19:24:48 +0800
Message-ID: <4BEBE180.9080705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I am running 2.6.34-rc5, testing was done with a 4G thumb drive.

# mkfs.btrfs /dev/sdd1

WARNING! - Btrfs v0.19-16-g075587c IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdd1
	nodesize 4096 leafsize 4096 sectorsize 4096 size 3.73GB
Btrfs v0.19-16-g075587c

# mkdir one
# mkdir two
# mount /dev/sdd1 one
# mount /dev/sdd1 two -o subvol=xxx
mount: /dev/sdd1 is not a valid block device
# umount one
Killed
# demsg
....
[  180.007015] device fsid 2c4360d2eec872d5-d1b137fe6cf4b291 devid 1
transid 7 /dev/sdd1
[  201.104203] device fsid 2c4360d2eec872d5-d1b137fe6cf4b291 devid 1
transid 7 /dev/sdd1
[  238.350156] BUG: unable to handle kernel NULL pointer dereference at
00000000000002c0
[  238.350170] IP: [<ffffffff8112065b>] bio_get_nr_vecs+0xb/0x40
[  238.350190] PGD 7cb06067 PUD 7cbbe067 PMD 0
[  238.350198] Oops: 0000 [#1] SMP
[  238.350203] last sysfs file:
/sys/devices/pci0000:00/0000:00:02.2/usb1/1-3/speed
[  238.350210] CPU 0
[  238.350212] Modules linked in: usb_storage binfmt_misc vboxnetadp
vboxnetflt vboxdrv btrfs zlib_deflate crc32c libcrc32c snd_intel8x0
snd_ac97_codec fbcon tileblit font bitblit softcursor ac97_bus
snd_pcm_oss snd_mixer_oss snd_pcm nouveau snd_seq_dummy snd_seq_oss ttm
snd_seq_midi snd_rawmidi snd_seq_midi_event drm_kms_helper snd_seq
i2c_nforce2 drm i2c_algo_bit snd_timer snd_seq_device shpchp snd
soundcore k8temp amd64_edac_mod snd_page_alloc edac_core edac_mce_amd
usbhid hid sata_nv floppy forcedeth pata_amd
[  238.350270]
[  238.350277] Pid: 1836, comm: umount Not tainted 2.6.34-rc5-custom #5
'K8N'/K8N
[  238.350282] RIP: 0010:[<ffffffff8112065b>]  [<ffffffff8112065b>]
bio_get_nr_vecs+0xb/0x40
[  238.350291] RSP: 0018:ffff880037b3d948  EFLAGS: 00010246
[  238.350295] RAX: 0000000000000000 RBX: 0000000000001000 RCX:
000000000000e030
[  238.350300] RDX: ffffea0001c7c010 RSI: ffff88009f76cbb8 RDI:
ffff88009f527a80
[  238.350304] RBP: ffff880037b3d948 R08: 0000000000001000 R09:
0000000000000000
[  238.350309] R10: 0000000000000000 R11: ffff88009f78fc58 R12:
0000000000000100
[  238.350313] R13: ffff880037b3db38 R14: 0000000000000000 R15:
ffff88009f76cbb8
[  238.350318] FS:  00007ffed6c5e740(0000) GS:ffff880001c00000(0000)
knlGS:0000000000000000
[  238.350323] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  238.350327] CR2: 00000000000002c0 CR3: 000000007cb21000 CR4:
00000000000006f0
[  238.350332] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  238.350337] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  238.350342] Process umount (pid: 1836, threadinfo ffff880037b3c000,
task ffff88008a2f16d0)
[  238.350346] Stack:
[  238.350349]  ffff880037b3d9b8 ffffffffa0281863 0000000000000286
ffffea0001c7c010
[  238.350356] <0> 0000044137b3d9b8 0000100000000000 000000000000e030
ffffea0001c7c010
[  238.350363] <0> ffff880037b3d9b8 ffff88009f76cbb8 0000000001c06000
0000000000001000
[  238.350370] Call Trace:
[  238.350422]  [<ffffffffa0281863>] submit_extent_page+0x1f3/0x270 [btrfs]
[  238.350447]  [<ffffffffa028688b>] __extent_writepage+0x49b/0x6d0 [btrfs]
[  238.350470]  [<ffffffffa02832b0>] ?
end_bio_extent_writepage+0x0/0x180 [btrfs]
[  238.350489]  [<ffffffffa0252a5f>] ?
block_group_cache_tree_search+0x1f/0xb0 [btrfs]
[  238.350513]  [<ffffffffa0287030>] extent_write_full_page+0xa0/0xe0
[btrfs]
[  238.350534]  [<ffffffffa0260b10>] ? btree_get_extent+0x0/0x1b0 [btrfs]
[  238.350544]  [<ffffffff810ee41a>] ? mem_cgroup_add_lru_list+0x1a/0xa0
[  238.350564]  [<ffffffffa02615b1>] btree_writepage+0xa1/0x110 [btrfs]
[  238.350573]  [<ffffffff810b59c6>] write_one_page+0x86/0x120
[  238.350595]  [<ffffffffa0266998>]
btrfs_write_marked_extents+0xe8/0x160 [btrfs]
[  238.350618]  [<ffffffffa0266a39>]
btrfs_write_and_wait_marked_extents+0x29/0x60 [btrfs]
[  238.350640]  [<ffffffffa0266a96>]
btrfs_write_and_wait_transaction+0x26/0x50 [btrfs]
[  238.350662]  [<ffffffffa0266f51>]
btrfs_commit_transaction+0x491/0x6d0 [btrfs]
[  238.350672]  [<ffffffff8105eef0>] ? autoremove_wake_function+0x0/0x40
[  238.350694]  [<ffffffffa0267491>] ? start_transaction+0x121/0x180 [btrfs]
[  238.350712]  [<ffffffffa0247e12>] btrfs_sync_fs+0x42/0x80 [btrfs]
[  238.350721]  [<ffffffff81143e29>] vfs_quota_sync+0x199/0x300
[  238.350731]  [<ffffffff8111b224>] __sync_filesystem+0x34/0x80
[  238.350738]  [<ffffffff8111b453>] sync_filesystem+0x43/0x60
[  238.350746]  [<ffffffff810f89f2>] generic_shutdown_super+0x22/0x100
[  238.350752]  [<ffffffff810f8b31>] kill_anon_super+0x11/0x50
[  238.350758]  [<ffffffff810f9ac4>] deactivate_super+0x64/0x80
[  238.350764]  [<ffffffff811100ff>] mntput_no_expire+0x9f/0xf0
[  238.350770]  [<ffffffff811104b3>] sys_umount+0x73/0x3a0
[  238.350779]  [<ffffffff81002deb>] system_call_fastpath+0x16/0x1b
[  238.350783] Code: 0f b7 ff 55 48 8d 04 7f 48 89 e5 8b 04 c5 a0 9a a7
81 c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 87 90 00 00 00 55 48
89 e5 <48> 8b 88 c0 02 00 00 8b 81 34 04 00 00 0f b7 91 5a 04 00 00 c9
[  238.350827] RIP  [<ffffffff8112065b>] bio_get_nr_vecs+0xb/0x40
[  238.350834]  RSP <ffff880037b3d948>
[  238.350837] CR2: 00000000000002c0
[  238.350843] ---[ end trace 871e5e18f8f3f471 ]---
