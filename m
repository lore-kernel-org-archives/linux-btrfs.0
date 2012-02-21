From: Nuno Subtil <subtil@gmail.com>
Subject: Kernel bug on creating snapshot
Date: Mon, 20 Feb 2012 17:32:24 -0800
Message-ID: <CALdXDfdzR6HfnBuF5m24BpwB5WNQesKaK8yQk6sH4p2jn6naJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a system running 3.2.6 that creates and deletes a number of
snapshots on a daily basis. It seems to have run into a problem while
attempting to create a snapshot:

[431642.714979] ------------[ cut here ]------------
[431642.714997] kernel BUG at /home/apw/COD/linux/fs/btrfs/locking.c:21=
4!
[431642.715005] invalid opcode: 0000 [#1] SMP
[431642.715014] CPU 2
[431642.715018] Modules linked in: nfsd lockd nfs_acl auth_rpcgss
sunrpc ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs reiserfs
ext2 snd_hda_codec_realtek nouveau ttm drm_kms_helper drm
snd_hda_intel snd_hda_codec joydev mac_hid i2c_algo_bit video
i7core_edac snd_hwdep snd_pcm psmouse edac_core snd_timer mxm_wmi snd
soundcore snd_page_alloc asus_atk0110 wmi serio_raw softdog lp parport
usbhid hid firewire_ohci firewire_core crc_itu_t sky2 btrfs
zlib_deflate libcrc32c
[431642.715147]
[431642.715151] Pid: 813, comm: btrfs-cleaner Not tainted
3.2.6-030206-generic #201202131435 System manufacturer System Product
Name/P6X58D-E
[431642.715168] RIP: 0010:[<ffffffffa006a601>] =A0[<ffffffffa006a601>]
btrfs_tree_unlock+0x71/0xa0 [btrfs]
[431642.715196] RSP: 0018:ffff88022fb99ca0 =A0EFLAGS: 00010246
[431642.715203] RAX: 0000000000000000 RBX: ffff8801cb29dbe0 RCX:
ffff8801041d2180
[431642.715211] RDX: 0000000000000000 RSI: 0000000000000003 RDI:
ffff8801cb29dbe0
[431642.715220] RBP: ffff88022fb99cb0 R08: 0000000000000001 R09:
ffff88022fb99bd8
[431642.715228] R10: 0000000000000002 R11: ffff88019d5106c0 R12:
ffff8801041d2180
[431642.715235] R13: ffff8801cb29dbe0 R14: ffff88020984d7e0 R15:
ffff88022de5fc00
[431642.715244] FS: =A00000000000000000(0000) GS:ffff88023fc40000(0000)
knlGS:0000000000000000
[431642.715252] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
[431642.715259] CR2: 000000000061ce20 CR3: 0000000001c05000 CR4:
00000000000006e0
[431642.715267] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[431642.715275] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[431642.715283] Process btrfs-cleaner (pid: 813, threadinfo
ffff88022fb98000, task ffff880230c7c4a0)
[431642.715291] Stack:
[431642.715295] =A0ffff88022fb99cb0 000000000000001a ffff88022fb99cc0
ffffffffa002391b
[431642.715311] =A0ffff88022fb99d10 ffffffffa0028f4c 0000000200000002
ffff88019d5106c0
[431642.715325] =A0ffff88010a608388 ffff88020984d7e0 ffff88020984d7e0
0000000000000002
[431642.715340] Call Trace:
[431642.715357] =A0[<ffffffffa002391b>] btrfs_tree_unlock_rw+0x2b/0x50 =
[btrfs]
[431642.715376] =A0[<ffffffffa0028f4c>] walk_down_proc+0x1ac/0x240 [btr=
fs]
[431642.715395] =A0[<ffffffffa002904c>] walk_down_tree+0x6c/0x100 [btrf=
s]
[431642.715414] =A0[<ffffffffa002d771>] btrfs_drop_snapshot+0x2c1/0x590=
 [btrfs]
[431642.715435] =A0[<ffffffffa0039668>]
btrfs_clean_old_snapshots+0x118/0x160 [btrfs]
[431642.715456] =A0[<ffffffffa0034dd0>] cleaner_kthread+0x160/0x1a0 [bt=
rfs]
[431642.715476] =A0[<ffffffffa0034c70>] ? transaction_kthread+0x2a0/0x2=
a0 [btrfs]
[431642.715489] =A0[<ffffffff8108bba6>] kthread+0x96/0xa0
[431642.715498] =A0[<ffffffff81659bb4>] kernel_thread_helper+0x4/0x10
[431642.715957] =A0[<ffffffff8108bb10>] ? kthread_worker_fn+0x190/0x190
[431642.716417] =A0[<ffffffff81659bb0>] ? gs_change+0x13/0x13
[431642.716979] Code: 1f 00 8b 47 68 85 c0 75 3d f0 ff 4b 5c 48 8d 7b
70 31 c9 ba 01 00 00 00 be 03 00 00 00 e8 18 9b fe e0 48 83 c4 08 31
c0 5b c9 c3 <0f> 0b eb fe 0f 0b eb fe be cd 00 00 00 48 c7 c7 a0 15 09
a0 e8
[431642.718210] RIP =A0[<ffffffffa006a601>] btrfs_tree_unlock+0x71/0xa0=
 [btrfs]
[431642.718785] =A0RSP <ffff88022fb99ca0>
[431642.722212] ---[ end trace 08dfc5a54c97fa7a ]---

The filesystem is mounted with noatime,nodiratime,compress=3Dlzo,autode=
frag.

Has this been seen before? I'm wondering if the autodefrag option
could have anything to do with this, as the failure happened not too
long after I enabled that flag for this filesystem.

Thanks,
Nuno
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
