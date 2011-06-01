From: "Fajar A. Nugraha" <list@fajar.net>
Subject: btrfs error after using kernel 3.0-rc1
Date: Wed, 1 Jun 2011 13:06:29 +0700
Message-ID: <BANLkTimGPgn9CERxCNQPqJLTiRkFUc03OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While using btrfs as root on kernel 3.0-rc1, there was some errors (I
wasn't able to capture the error) that forced me to do hard reset.

Now during startup system drops to busybox shell because it's unable
to mount root partition.
Is there a way to recover the data, as at least grub2 was still happy
enough to load kernel and initrd (both of which located on the same
btrfs partition)?

This is what dmesg says

[    4.536798] device label SSD-ROOT devid 1 transid 38245 /dev/sda2
[    9.552086] device label SSD-ROOT devid 1 transid 38245
/dev/disk/by-label/SSD-ROOT
[    9.554563] btrfs: disk space caching is enabled
[    9.564301] parent transid verify failed on 44040192 wanted 38240 found 32526
[    9.564535] parent transid verify failed on 44040192 wanted 38240 found 32526
[    9.564778] parent transid verify failed on 44040192 wanted 38240 found 32526
[    9.575679] parent transid verify failed on 44052480 wanted 38240 found 31547
[    9.575904] parent transid verify failed on 44052480 wanted 38240 found 31547
[    9.576176] parent transid verify failed on 44052480 wanted 38240 found 31547
[    9.586121] parent transid verify failed on 44064768 wanted 38240 found 34145
[    9.586319] parent transid verify failed on 44064768 wanted 38240 found 34145
[    9.586515] parent transid verify failed on 44064768 wanted 38240 found 34145
[    9.587027] parent transid verify failed on 44068864 wanted 38240 found 34476
[    9.589732] Btrfs detected SSD devices, enabling SSD mode
[    9.592923] block group 29360128 has an wrong amount of free space
[    9.592959] btrfs: failed to load free space cache for block group 29360128
[    9.601802] ------------[ cut here ]------------
[    9.601835] kernel BUG at fs/btrfs/inode.c:4582!
[    9.601867] invalid opcode: 0000 [#1] SMP
[    9.601896] Modules linked in: nbd btrfs zlib_deflate libcrc32c
i915 drm_kms_helper drm tg3 i2c_algo_bit video ahci libahci
[    9.601983]
[    9.601996] Pid: 319, comm: exe Not tainted 3.0.0-rc1 #2
Hewlett-Packard HP Compaq 2210b/0ABC
[    9.602054] EIP: 0060:[<f89dae88>] EFLAGS: 00010282 CPU: 0
[    9.602104] EIP is at btrfs_add_link+0x1b8/0x240 [btrfs]
[    9.602140] EAX: ffffffef EBX: f4baeb44 ECX: 0000007d EDX: 0000007c
[    9.602176] ESI: 000000b5 EDI: f4052b44 EBP: f46bbba0 ESP: f46bbb40
[    9.602212]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    9.602245] Process exe (pid: 319, ti=f46ba000 task=f7052610
task.ti=f46ba000)
[    9.602288] Stack:
[    9.602303]  0000000a f4baeb44 f46bbb83 00000001 000000b5 00000000
f89f58af f46bbba0
[    9.602359]  f89e4910 f46bbb90 00000982 00000000 f4018000 f4563800
f4baea20 f4052b44
[    9.602415]  7e000001 000002ee 01000000 00000000 00000000 f4444df0
f482f2a0 00000000
[    9.602471] Call Trace:
[    9.602499]  [<f89f58af>] ? unmap_extent_buffer+0xf/0x20 [btrfs]
[    9.602551]  [<f89e4910>] ? btrfs_inode_ref_index+0xe0/0xf0 [btrfs]
[    9.602598]  [<f8a058e9>] add_inode_ref+0x2d9/0x380 [btrfs]
[    9.602642]  [<f8a07216>] replay_one_buffer+0x226/0x2f0 [btrfs]
[    9.602687]  [<f8a04859>] walk_down_log_tree+0x1d9/0x370 [btrfs]
[    9.602737]  [<f8a04a91>] walk_log_tree+0xa1/0x1c0 [btrfs]
[    9.602778]  [<c127712a>] ? radix_tree_lookup+0xa/0x10
[    9.602823]  [<f8a08ec4>] btrfs_recover_log_trees+0x1e4/0x2b0 [btrfs]
[    9.602872]  [<f8a06ff0>] ? replay_one_extent+0x6b0/0x6b0 [btrfs]
[    9.602918]  [<f89cc311>] open_ctree+0x1261/0x15e0 [btrfs]
[    9.602957]  [<c1279389>] ? strlcpy+0x39/0x50
[    9.604434]  [<f89ab692>] btrfs_mount+0x4a2/0x5d0 [btrfs]
[    9.605678]  [<c12741ce>] ? ida_get_new_above+0x11e/0x1a0
[    9.605678]  [<c11296aa>] mount_fs+0x3a/0x180
[    9.605678]  [<c10f877f>] ? __alloc_percpu+0xf/0x20
[    9.605678]  [<c113fd8b>] vfs_kern_mount+0x4b/0xa0
[    9.605678]  [<c11402fe>] do_kern_mount+0x3e/0xe0
[    9.605678]  [<c1141ae6>] do_mount+0x596/0x6c0
[    9.605678]  [<c11414a8>] ? copy_mount_options+0xa8/0x110
[    9.605678]  [<c1141f5b>] sys_mount+0x6b/0xa0
[    9.605678]  [<c1524e1f>] sysenter_do_call+0x12/0x28
[    9.605678] Code: 24 14 8b 45 d0 89 7c 24 08 89 54 24 0c 8b 55 d4
89 0c 24 8b 4d 08 e8 d8 ab fe ff 85 c0 0f 84 e4 fe ff ff 83 c4 54 5b
5e 5f 5d c3 <0f> 0b 8b 55 dc 8d 7d e3 b9 11 00 00 00 8b b2 dc fe ff ff
8b 55
[    9.605678] EIP: [<f89dae88>] btrfs_add_link+0x1b8/0x240 [btrfs]
SS:ESP 0068:f46bbb40
[    9.622016] ---[ end trace d5d085f53c746e86 ]---


-- 
Fajar
