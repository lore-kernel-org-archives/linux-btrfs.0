From: dont <dontbeeeevil@gmail.com>
Subject: BUG: scheduling while atomic: mount/1608/0x00000002
Date: Mon, 13 Jun 2011 14:08:21 -0400
Message-ID: <20110613180821.GA8196@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

Background story to the current problem.
I first started with 3 drives and set up btrfs with builtin raid0.
Initially I started out with 3 drives.
Distro is Gentoo and I was using distcc. Then I started noticing that
gcc would hang during compiling. Eventually I tracked down the problem
to distcc. Disabling distcc would fix gcc getting stuck. Then I began
investigating in the distcc folder what was going on in there. If I
recall correct du would get stuck on distcc folder. Because disabling i=
t
distcc was enough I left it alone and forget.

Until I got a new drive that I wanted to add to the raid0. I am not to
sure which of the two but re-balancing would either get stuck or
segfault. So I thought it had something to do with that damn distcc
folder. Then manually I began deleting one by one folders and files in
the distcc directory. Many times rm, ls and du would get stuck because =
I
didn't know which folder and file were causing it. After many tries and
reboots (due to hanged processes) in the end I removed EVERYTHING in
distcc except for the folder and that single file.

=46rom then on, at around kernel 2.6.38, certain operations resulted in
kernel panics, which in turn required cold power cycle. I guess that
made things worse.

By the way I was using many features of btrfs, subvolumes, some
subvolumes with compression enabled, etc.

Damn single file!

This is my most recent attempts at mounting read only since I read that
in certain cases is possible to mount a btrfs system.

Booting Gentoo in qemu with safe drive options like this for the btrfs =
disks:

-drive file=3D/dev/sdX,cache=3Dnone,if=3Dvirtio

Linux kernel 3.0.0-rc1

Btrfs v0.19-35-g1b444cd-dirty

Steps to reproduce current kernel bug.

1. Loglevel set to 9:

	echo 9 > /proc/sysrq-trigger

2. Load module:
=09
	modprobe -v btrfs
	insmod /lib/modules/3.0.0-rc1/kernel/lib/libcrc32c.ko=20
	insmod /lib/modules/3.0.0-rc1/kernel/lib/lzo/lzo_compress.ko=20
	insmod
	/lib/modules/3.0.0-rc1/kernel/lib/zlib_deflate/zlib_deflate.ko=20
	insmod /lib/modules/3.0.0-rc1/kernel/fs/btrfs/btrfs.ko

3. Scan for drives:

	btrfs device scan
	  252.491295] Btrfs loaded
	  [  268.978445] device fsid 48487393f515c9b8-be3d620d5899c184
	  devid 4 transid 906477 /dev/vdd
	  [  268.981717] device fsid 48487393f515c9b8-be3d620d5899c184
	  devid 3 transid 906477 /dev/vdb
	  [  268.984638] device fsid 48487393f515c9b8-be3d620d5899c184
	  devid 5 transid 906477 /dev/vde
	  [  268.987513] device fsid 48487393f515c9b8-be3d620d5899c184
	  devid 2 transid 906475 /dev/vdc
	  [  320.198357] device fsid 48487393f515c9b8-be3d620d5899c184
	  devid 3 transid 906477 /dev/vdb

4. fstab entry:

	cat /etc/fstab
	/dev/vdb        /mnt/btrfs      btrfs   noauto,ro,atime 0 1

5. Mount read only:

	mount -v -o ro -t btrfs /dev/vdb /mnt/btrfs/
	Segmentation fault

6. dmesg output:

[  236.556931] Loglevel set to 9
[  252.491295] Btrfs loaded
[  268.978445] device fsid 48487393f515c9b8-be3d620d5899c184 devid 4
transid 906477 /dev/vdd
[  268.981717] device fsid 48487393f515c9b8-be3d620d5899c184 devid 3
transid 906477 /dev/vdb
[  268.984638] device fsid 48487393f515c9b8-be3d620d5899c184 devid 5
transid 906477 /dev/vde
[  268.987513] device fsid 48487393f515c9b8-be3d620d5899c184 devid 2
transid 906475 /dev/vdc
[  320.198357] device fsid 48487393f515c9b8-be3d620d5899c184 devid 3
transid 906477 /dev/vdb
[  320.251194] parent transid verify failed on 4517304938496 wanted
906477 found 852489
[  320.252957] BUG: scheduling while atomic: mount/1608/0x00000002
[  320.254318] Modules linked in: btrfs zlib_deflate lzo_compress crc32=
c
libcrc32c usbhid hid uhci_hcd ehci_hcd usbcore
[  320.256779] Pid: 1608, comm: mount Tainted: G        W   3.0.0-rc1 #=
8
[  320.258216] Call Trace:
[  320.258774]  [<ffffffff81031331>] __schedule_bug+0x61/0x70
[  320.259856]  [<ffffffff8149c41e>] schedule+0x85e/0x900
[  320.260973]  [<ffffffff810a8450>] ? __lock_page+0x70/0x70
[  320.262189]  [<ffffffff8149c51b>] io_schedule+0x5b/0x80
[  320.263316]  [<ffffffff810a8459>] sleep_on_page+0x9/0x10
[  320.264469]  [<ffffffff8149cdd7>] __wait_on_bit+0x57/0x80
[  320.265646]  [<ffffffff810a85fe>] wait_on_page_bit+0x6e/0x80
[  320.266880]  [<ffffffff8105cd20>] ?
autoremove_wake_function+0x40/0x40
[  320.268276]  [<ffffffffa00d5d7c>] ? submit_one_bio+0x7c/0xa0 [btrfs]
[  320.269690]  [<ffffffffa00db1a2>]
read_extent_buffer_pages+0x422/0x4d0 [btrfs]
[  320.271339]  [<ffffffffa00af0e0>] ? run_one_async_free+0x10/0x10
[btrfs]
[  320.272859]  [<ffffffffa00b0799>]
btree_read_extent_buffer_pages.clone.65+0x89/0xc0 [btrfs]
[  320.274745]  [<ffffffffa00b1b8c>] read_tree_block+0x3c/0x60 [btrfs]
[  320.276136]  [<ffffffffa00962fb>]
read_block_for_search.clone.37+0x1eb/0x410 [btrfs]
[  320.277842]  [<ffffffffa00e9c55>] ? btrfs_tree_lock+0x65/0xe0 [btrfs=
]
[  320.279282]  [<ffffffffa00995c3>] btrfs_search_slot+0x313/0xa30
[btrfs]
[  320.280737]  [<ffffffff810a85fe>] ? wait_on_page_bit+0x6e/0x80
[  320.282011]  [<ffffffffa00aa84f>] btrfs_find_last_root+0x5f/0x150
[btrfs]
[  320.283551]  [<ffffffffa00b247c>] find_and_setup_root+0x5c/0x120
[btrfs]
[  320.284932]  [<ffffffffa00b4f42>] open_ctree+0x1002/0x17b0 [btrfs]
[  320.286346]  [<ffffffff81272259>] ? vsnprintf+0x1f9/0x5d0
[  320.287613]  [<ffffffff812695ab>] ? ida_get_new_above+0x15b/0x1d0
[  320.288925]  [<ffffffff8114ee92>] ? disk_name+0xb2/0xc0
[  320.290122]  [<ffffffffa008f6cf>] btrfs_mount+0x3ff/0x5b0 [btrfs]
[  320.291487]  [<ffffffff810f5f62>] mount_fs+0x42/0x1b0
[  320.292603]  [<ffffffff8110e9b6>] ? alloc_vfsmnt+0xb6/0x1b0
[  320.293752]  [<ffffffff8110eb40>] vfs_kern_mount+0x50/0xb0
[  320.294875]  [<ffffffff8110fbbf>] do_kern_mount+0x4f/0x100
[  320.296092]  [<ffffffff8111166a>] do_mount+0x4fa/0x7d0
[  320.297212]  [<ffffffff810c0af3>] ? strndup_user+0x53/0x70
[  320.298440]  [<ffffffff81111cf3>] sys_mount+0x93/0xe0
[  320.299587]  [<ffffffff8149f252>] system_call_fastpath+0x16/0x1b
[  320.301943] parent transid verify failed on 4517304938496 wanted
906477 found 852489
[  320.303759] parent transid verify failed on 4517304938496 wanted
906477 found 852489
[  320.305664] ------------[ cut here ]------------
[  320.306540] kernel BUG at fs/btrfs/disk-io.c:1106!
[  320.306540] invalid opcode: 0000 [#1] PREEMPT SMP=20
[  320.306540] CPU 0=20
[  320.306540] Modules linked in: btrfs zlib_deflate lzo_compress crc32=
c
libcrc32c usbhid hid uhci_hcd ehci_hcd usbcore
[  320.306540]=20
[  320.306540] Pid: 1608, comm: mount Tainted: G        W   3.0.0-rc1 #=
8
Bochs Bochs
[  320.306540] RIP: 0010:[<ffffffffa00b252f>]  [<ffffffffa00b252f>]
find_and_setup_root+0x10f/0x120 [btrfs]
[  320.306540] RSP: 0018:ffff88003a0c5b78  EFLAGS: 00010282
[  320.306540] RAX: 00000000fffffffe RBX: ffff88003a29e000 RCX:
0000000000000100
[  320.306540] RDX: 00000000fffffffb RSI: 0000000000018b90 RDI:
ffffea0000ccd650
[  320.306540] RBP: ffff88003a0c5ba8 R08: ffffffffa00925d5 R09:
0000000000000000
[  320.306540] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff88003a29c800
[  320.306540] R13: 0000000000000002 R14: ffff88003a2d0000 R15:
ffff880039e17000
[  320.306540] FS:  00007f3b19270740(0000) GS:ffff88003fc00000(0000)
knlGS:0000000000000000
[  320.306540] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  320.306540] CR2: 00000000014a1018 CR3: 000000003a478000 CR4:
00000000000006b0
[  320.306540] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  320.306540] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  320.306540] Process mount (pid: 1608, threadinfo ffff88003a0c4000,
task ffff88003a397680)
[  320.306540] Stack:
[  320.306540]  0000000000000002 ffff880039e17000 ffff88003a0c5ba8
ffff88003a410000
[  320.306540]  ffff88003a29e000 ffff880039e17800 ffff88003a0c5cd8
ffffffffa00b4f42
[  320.306540]  0000000000000003 ffffffff81272259 ffff880000000000
0000100000000000
[  320.306540] Call Trace:
[  320.306540]  [<ffffffffa00b4f42>] open_ctree+0x1002/0x17b0 [btrfs]
[  320.306540]  [<ffffffff81272259>] ? vsnprintf+0x1f9/0x5d0
[  320.306540]  [<ffffffff812695ab>] ? ida_get_new_above+0x15b/0x1d0
[  320.306540]  [<ffffffff8114ee92>] ? disk_name+0xb2/0xc0
[  320.306540]  [<ffffffffa008f6cf>] btrfs_mount+0x3ff/0x5b0 [btrfs]
[  320.306540]  [<ffffffff810f5f62>] mount_fs+0x42/0x1b0
[  320.306540]  [<ffffffff8110e9b6>] ? alloc_vfsmnt+0xb6/0x1b0
[  320.306540]  [<ffffffff8110eb40>] vfs_kern_mount+0x50/0xb0
[  320.306540]  [<ffffffff8110fbbf>] do_kern_mount+0x4f/0x100
[  320.306540]  [<ffffffff8111166a>] do_mount+0x4fa/0x7d0
[  320.306540]  [<ffffffff810c0af3>] ? strndup_user+0x53/0x70
[  320.306540]  [<ffffffff81111cf3>] sys_mount+0x93/0xe0
[  320.306540]  [<ffffffff8149f252>] system_call_fastpath+0x16/0x1b
[  320.306540] Code: 00 00 00 00 41 8b 94 24 00 03 00 00 eb a7 66 0f 1f
44 00 00 49 8b 3c 24 e8 7f 82 02 00 b8 fb ff ff ff e9 5d ff ff ff 31 ff
eb ed <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5=20
[  320.306540] RIP  [<ffffffffa00b252f>] find_and_setup_root+0x10f/0x12=
0
[btrfs]
[  320.306540]  RSP <ffff88003a0c5b78>
[  320.364923] ---[ end trace 508a31f69047c113 ]---
[  907.168103] flush-254:0 used greatest stack depth: 2888 bytes left

7. Second attempt results in mount getting stuck:

	mount -v -o ro -t btrfs /dev/vdb /mnt/btrfs/

8. dmesg output for the above command is just one line:

	[17645.438073] device fsid 48487393f515c9b8-be3d620d5899c184
	devid 3 transid 906477 /dev/vdb

9. Output of ps:
=09
	ps aux | grep mount
	root      1656  0.0  0.0   8248   628 pts/1    D+   13:59   0:00
	mount -v -o ro -t btrfs /dev/vdb /mnt/btrfs/

10. proc info of the stuck mount process:

	cat /proc/1656/stack

	[<ffffffff81273c43>] call_rwsem_down_write_failed+0x13/0x20
	[<ffffffff810f5330>] sget+0x2e0/0x430
	[<ffffffffa008f4cd>] btrfs_mount+0x1fd/0x5b0 [btrfs]
	[<ffffffff810f5f62>] mount_fs+0x42/0x1b0
	[<ffffffff8110eb40>] vfs_kern_mount+0x50/0xb0
	[<ffffffff8110fbbf>] do_kern_mount+0x4f/0x100
	[<ffffffff8111166a>] do_mount+0x4fa/0x7d0
	[<ffffffff81111cf3>] sys_mount+0x93/0xe0
	[<ffffffff8149f252>] system_call_fastpath+0x16/0x1b
	[<ffffffffffffffff>] 0xffffffffffffffff

The damn SINGLE file!!

=E2=98=B9

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
