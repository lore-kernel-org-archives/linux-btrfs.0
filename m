From: Jonas Bonn <jonas@southpole.se>
Subject: BUG with seed device
Date: Fri, 20 Aug 2010 22:40:05 +0200
Message-ID: <1282336805.4607.19.camel@satguru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

It seems that seed devices are slightly broken in Linux 2.6.35.  I have
been seeing issues with the read-only nature of the seed-device not
being respected: the seed device is written to and corrupted.  I don't
have a concrete test case for that yet because I am seeing other issues
with seeding as well.  The following test case consistently hits a BUG
on my Ubuntu (Maverick) kernel.

dd if=/dev/zero of=seed.img bs=1024 count=1 seek=$(((1<<20)-1))
dd if=/dev/zero of=sprout.img bs=1024 count=1 seek=$(((1<<20)-1))
mkfs.btrfs seed.img 
btrfstune -S 1 seed.img 
mkdir t
mount -oloop seed.img t
losetup /dev/loop2 sprout.img 
btrfs device add /dev/loop2 t/


[137828.202897] btrfs: relocating block group 136708096 flags 34
[137828.241111] btrfs: found 1 extents
[137828.277645] btrfs: relocating block group 20971520 flags 34
[137828.304284] btrfs: relocating block group 0 flags 2
[137828.313228] parent transid verify failed on 131072 wanted 22 found 3
[137828.335278] btrfs: found 1 extents
[137828.363139] ------------[ cut here ]------------
[137828.363145] kernel BUG
at /build/buildd/linux-2.6.35/fs/btrfs/volumes.c:1781!
[137828.363148] invalid opcode: 0000 [#3] SMP 
[137828.363152] last sysfs
file: /sys/devices/virtual/block/loop2/queue/rotational
[137828.363154] CPU 1 
[137828.363156] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
kvm_intel kvm binfmt_misc lp snd_hda_codec_idt snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
snd_seq_midi_event bridge i915 snd_seq stp snd_timer snd_seq_device
drm_kms_helper ppdev snd drm joydev parport_pc psmouse soundcore parport
i2c_algo_bit serio_raw video snd_page_alloc output intel_agp usbhid hid
raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov
raid6_pq async_tx firewire_ohci raid1 firewire_core usb_storage
crc_itu_t raid0 e1000e multipath pata_marvell linear
[137828.363200] 
[137828.363203] Pid: 22658, comm: btrfs Tainted: G      D W
2.6.35-15-generic #21-Ubuntu DG965OT/        
[137828.363206] RIP: 0010:[<ffffffffa032c4dc>]  [<ffffffffa032c4dc>]
btrfs_relocate_chunk+0x38c/0x3b0 [btrfs]
[137828.363223] RSP: 0018:ffff880046f6fca8  EFLAGS: 00010282
[137828.363226] RAX: 00000000fffffffe RBX: ffff8800cf27c300 RCX:
ffff88008c83fcf0
[137828.363228] RDX: 0000000000000000 RSI: ffffea0001ebcdc8 RDI:
0000000000000206
[137828.363231] RBP: ffff880046f6fd58 R08: 0000000000000000 R09:
0000000000000000
[137828.363233] R10: 0000000000000001 R11: ffff8800b6deadd8 R12:
ffff8800c57df180
[137828.363235] R13: ffff88003d2ae000 R14: 0000000000000020 R15:
0000000000000000
[137828.363238] FS:  00007f5b30c12740(0000) GS:ffff880001e80000(0000)
knlGS:0000000000000000
[137828.363241] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[137828.363243] CR2: 0000000001d39088 CR3: 0000000046e48000 CR4:
00000000000006e0
[137828.363246] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[137828.363248] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[137828.363251] Process btrfs (pid: 22658, threadinfo ffff880046f6e000,
task ffff8800196ec4a0)
[137828.363253] Stack:
[137828.363254]  ffff8800b90e4140 ffff8800b14d87e0 0000000000000eec
0000000000000000
[137828.363259] <0> 0000000000000f04 ffff880046f6fda8 ffff8800b90e40e8
ffff8800b90e40f0
[137828.363263] <0> ffff8800c41082c0 0000000000000100 ffff88003d2ac800
0000000000000000
[137828.363268] Call Trace:
[137828.363280]  [<ffffffffa032c643>] btrfs_relocate_sys_chunks
+0x143/0x1e0 [btrfs]
[137828.363290]  [<ffffffffa0330722>] btrfs_init_new_device+0x402/0x520
[btrfs]
[137828.363300]  [<ffffffffa033568b>] btrfs_ioctl+0x49b/0x4c0 [btrfs]
[137828.363306]  [<ffffffff811615ad>] vfs_ioctl+0x3d/0xd0
[137828.363309]  [<ffffffff81161e81>] do_vfs_ioctl+0x81/0x340
[137828.363315]  [<ffffffff8158c8ae>] ? do_page_fault+0x15e/0x350
[137828.363318]  [<ffffffff811621c1>] sys_ioctl+0x81/0xa0
[137828.363323]  [<ffffffff8100a0f2>] system_call_fastpath+0x16/0x1b
[137828.363325] Code: 00 48 81 c7 00 1c 00 00 e8 72 ae 25 e1 4c 89 ee 4c
89 e7 e8 97 aa fd ff e9 d2 fc ff ff 66 90 0f 0b eb fe 0f 1f 40 00 0f 0b
eb fe <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 
[137828.363360] RIP  [<ffffffffa032c4dc>] btrfs_relocate_chunk
+0x38c/0x3b0 [btrfs]
[137828.363370]  RSP <ffff880046f6fca8>
[137828.363374] ---[ end trace a7919e7f17c0a729 ]---


Regards,
Jonas 

