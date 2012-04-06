From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: kernel BUG at extent-tree.c:3162 (get_restripe_target)
Date: Fri, 6 Apr 2012 10:33:04 -0500
Message-ID: <CAKcLGm8SgQchrk1fVg0FZ9uqr1v+cLzoWt1jk7vsJdZVfA72pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm consistently hitting the BUG_ON in the new get_restripe_target
function that was added by "[PATCH 4/8] Btrfs: add
get_restripe_target() helper" when trying to initially mount a btrfs
partition.

Lines fs/btrfs/extent-tree.c:3161-3162:

	BUG_ON(!mutex_is_locked(&fs_info->volume_mutex) &&
	       !spin_is_locked(&fs_info->balance_lock));

The kernel is a 3.3.1 kernel merged with the for-linus branch (for the
3.4_rc kernel) of Chris Mason's git repo.

If I boot with an older 3.2.10 kernel (which was merged with the
3.3_rc for-linus branch), the partition mounts without error, and
btrfsck reports no errors.

The partition seems to behave normally under use on the 3.2.10 kernel.

This computer has gone through a few hard reboots recently.  I'm not
sure if the hard reboots have left some inconsistencies, but if so,
they are not showing up on the 3.2.10 kernel.

[   66.233463] device fsid 43129e18-c745-476c-ba48-c6bea0d71e56 devid
1 transid 151 /dev/sdc1
[   66.235090] btrfs: force lzo compression
[   66.235097] btrfs: enabling auto defrag
[   66.235099] btrfs: disk space caching is enabled
[   66.310693] ------------[ cut here ]------------
[   66.310802] kernel BUG at fs/btrfs/extent-tree.c:3162!
[   66.310905] invalid opcode: 0000 [#1]
[   66.311042] Modules linked in:
[   66.311178]
[   66.311274] Pid: 2993, comm: mount Not tainted 3.3.1-git-local+ #1
  /MS-6570
[   66.311549] EIP: 0060:[<c12db3f6>] EFLAGS: 00010246 CPU: 0
[   66.311573] EIP is at get_restripe_target+0x86/0x90
[   66.311573] EAX: 00000001 EBX: 00000001 ECX: 00000000 EDX: 00000001
[   66.311573] ESI: 00010000 EDI: f6227780 EBP: f4d9dc80 ESP: f4d9dc7c
[   66.311573]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[   66.311573] Process mount (pid: 2993, ti=f4d9c000 task=f5f5e180
task.ti=f4d9c000)
[   66.311573] Stack:
[   66.311573]  00000001 f4d9dca4 c12e1693 00000000 00000000 00000001
00000000 f6379000
[   66.311573]  f31d0000 f61b5400 f4d9dcb0 c12e1797 00000001 f4d9dd38
c12e8a3a f31d0000
[   66.311573]  00000000 00000000 00000000 f4d9dd28 f31d0000 f61b5400
00000033 f61b5510
[   66.311573] Call Trace:
[   66.311573]  [<c12e1693>] btrfs_reduce_alloc_profile+0x43/0xe0
[   66.311573]  [<c12e1797>] get_alloc_profile+0x67/0x70
[   66.311573]  [<c12e8a3a>] btrfs_read_block_groups+0x4fa/0x650
[   66.311573]  [<c12f40d0>] open_ctree+0x10e0/0x18b0
[   66.311573]  [<c12d2271>] btrfs_mount+0x501/0x8e0
[   66.311573]  [<c10a5055>] ? free_pages_prepare+0xc5/0x120
[   66.311573]  [<c10a6815>] ? __free_pages+0x25/0x30
[   66.311573]  [<c10a684f>] ? free_pages+0x2f/0x40
[   66.311573]  [<c10d67d5>] mount_fs+0x35/0x180
[   66.311573]  [<c10b540e>] ? kstrdup+0x3e/0x50
[   66.311573]  [<c10eab4b>] vfs_kern_mount+0x4b/0xb0
[   66.311573]  [<c10ead09>] do_kern_mount+0x39/0xd0
[   66.311573]  [<c10ec48a>] do_mount+0x58a/0x670
[   66.311573]  [<c10a6066>] ? __get_free_pages+0x26/0x30
[   66.311573]  [<c10ebde9>] ? copy_mount_options+0x39/0x110
[   66.311573]  [<c10ec5f6>] sys_mount+0x66/0xa0
[   66.311573]  [<c1789293>] sysenter_do_call+0x12/0x22
[   66.311573] Code: b6 00 00 00 00 31 c0 31 d2 83 e3 04 74 cc f6 81
cd 00 00 00 01 74 c3 8b 99 c4 00 00 00 8b 91 c8 00 00 00 89 d8 83 c8
04 5b 5d c3 <0f> 0b 90 8d b4 26 00 00 00 00 55 8d 88 f0 fe ff ff 89 e5
53 8b
[   66.311573] EIP: [<c12db3f6>] get_restripe_target+0x86/0x90 SS:ESP
0068:f4d9dc7c
[   66.318545] ---[ end trace 0c923804dee2b085 ]---
