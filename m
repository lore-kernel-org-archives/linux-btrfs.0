From: Maciej Sujkowski <maciej.sujkowski@gmail.com>
Subject: btrfs bug
Date: Tue, 17 May 2011 00:43:36 +0200
Message-ID: <BANLkTim7QB-EK7NFosk-Yu_s5Q1q_WpXNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi All

I've been using btrfs for some time already however recently the
filesystem got corrupted somehow.
Currently when I try to mount the filesystem the following error
message is displayed and after few seconds system freezes completely:

[  250.620511] ------------[ cut here ]------------
[  250.620525] kernel BUG at
/home/kernel-ppa/COD/linux/fs/btrfs/extent-tree.c:1418!
[  250.620532] invalid opcode: 0000 [#1] SMP
[  250.620540] last sysfs file: /sys/devices/virtual/bdi/btrfs-2/uevent
[  250.620545] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat
binfmt_misc vboxnetadp vboxnetflt vboxdrv nfsd lockd nfs_acl
auth_rpcgss sunrpc kvm_amd kvm snd_hda_codec_hdmi snd_hda_codec_analog
arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq p54usb p54common snd_timer
snd_seq_device crc_ccitt mac80211 nv_tco snd ppdev soundcore cfg80211
snd_page_alloc parport_pc psmouse lp asus_atk0110 serio_raw
i2c_nforce2 k8temp parport usb_storage usbhid hid uas pata_amd
forcedeth sata_nv dmfe raid10 raid456 async_raid6_recov async_pq
raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath
linear btrfs zlib_deflate libcrc32c
[  250.620648]
[  250.620654] Pid: 2402, comm: mount Not tainted 2.6.39-999-generic
#201105161320 System manufacturer System Product Name/M2NPV-VM
[  250.620668] EIP: 0060:[<f80fffbd>] EFLAGS: 00010202 CPU: 0
[  250.620716] EIP is at lookup_inline_extent_backref+0x46d/0x490 [btrfs]
[  250.620723] EAX: 00000001 EBX: 00000001 ECX: f376e000 EDX: 00000002
[  250.620729] ESI: f6b7d030 EDI: f376e000 EBP: f1e33a30 ESP: f1e339c4
[  250.620736]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  250.620743] Process mount (pid: 2402, ti=f1e32000 task=f1cc8ca0
task.ti=f1e32000)
[  250.620749] Stack:
[  250.620752]  f376e000 ffffffff 00000001 00000000 f72dc098 f72dc07c
f1017e18 f376e000
[  250.620766]  f1e12000 078f3fff 00000000 f1017e28 078f3fff 00000000
00000000 ffffffff
[  250.620779]  f813491a 000000b0 00000000 00001001 0004a060 a8000000
00001000 00000000
[  250.620793] Call Trace:
[  250.620855]  [<f813491a>] ? set_extent_dirty+0x4a/0x60 [btrfs]
[  250.620904]  [<f8100359>] lookup_extent_backref+0x89/0x150 [btrfs]
[  250.620952]  [<f81032f1>] __btrfs_free_extent+0xc1/0x700 [btrfs]
[  250.621002]  [<f8103b23>] run_delayed_tree_ref+0x1f3/0x200 [btrfs]
[  250.621050]  [<f8103d94>] run_one_delayed_ref+0x54/0xf0 [btrfs]
[  250.621098]  [<f8103ecc>] run_clustered_refs+0x9c/0x1e0 [btrfs]
[  250.621147]  [<f81040ba>] btrfs_run_delayed_refs+0xaa/0x1d0 [btrfs]
[  250.621200]  [<f8111aa9>] btrfs_should_end_transaction+0x69/0x70 [btrfs]
[  250.621248]  [<f81043b3>] btrfs_drop_snapshot+0x1d3/0x540 [btrfs]
[  250.621307]  [<f8158789>] merge_reloc_roots+0xa9/0x120 [btrfs]
[  250.621367]  [<f815a8cd>] btrfs_recover_relocation+0x32d/0x3c0 [btrfs]
[  250.621421]  [<f8110bf8>] open_ctree+0x12f8/0x1460 [btrfs]
[  250.621471]  [<f810d410>] ? btree_writepage+0x110/0x110 [btrfs]
[  250.621493]  [<c1150001>] ? get_source+0x51/0x80
[  250.621505]  [<c12846ed>] ? snprintf+0x1d/0x20
[  250.621545]  [<f80ed72c>] btrfs_fill_super+0x5c/0x110 [btrfs]
[  250.621553]  [<c1281dc9>] ? strlcpy+0x39/0x50
[  250.621596]  [<f80f0fe3>] btrfs_mount+0x2e3/0x360 [btrfs]
[  250.621620]  [<c113082e>] mount_fs+0x3e/0x170
[  250.621641]  [<c114768c>] vfs_kern_mount+0x4c/0x90
[  250.621656]  [<c114833e>] do_kern_mount+0x3e/0x80
[  250.621663]  [<c1149765>] do_new_mount+0x55/0x80
[  250.621670]  [<c1149a38>] do_mount+0x188/0x1a0
[  250.621678]  [<c1149abd>] sys_mount+0x6d/0xa0
[  250.621689]  [<c152fe5f>] sysenter_do_call+0x12/0x28
[  250.621694] Code: 87 1f ff ff ff 39 c6 8d b4 26 00 00 00 00 0f 82
09 fe ff ff e9 0b ff ff ff bb f5 ff ff ff e9 7a fe ff ff 0f 0b eb fe
0f 0b eb fe <0f> 0b eb fe 31 db e9 58 fe ff ff ba b0 05 00 00 b8 50 fd
15 f8
[  250.621765] EIP: [<f80fffbd>]
lookup_inline_extent_backref+0x46d/0x490 [btrfs] SS:ESP 0068:f1e339c4
[  250.621811] ---[ end trace 107ba8e4b5f4d7fb ]---

Let me know if you need any additional information.

Regards
Maciek
