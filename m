From: "Gong, Zhipeng" <zhipeng.gong@intel.com>
Subject: kernel oops when btrfs-vol remove a device
Date: Mon, 16 Nov 2009 14:55:28 +0800
Message-ID: <E88DD564E9DC5446A76B2B47C3BCCA150221D42044@pdsmsx503.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The kernel oops can be reproduced with these steps steadily:
=A0=A0=A0=A0=A0=A0=A0=A0 dd if=3D/dev/zero of=3Dimg0 bs=3D1k count=3D26=
2144
=A0=A0=A0=A0=A0=A0=A0=A0 dd if=3D/dev/zero of=3Dimg1 bs=3D1k count=3D26=
2144
=A0=A0=A0=A0=A0=A0=A0=A0 losetup /dev/loop0 img0=20
=A0=A0=A0=A0=A0=A0=A0=A0 losetup /dev/loop1 img1=20
=A0=A0=A0=A0=A0=A0=A0=A0 mkfs.btrfs -m raid0 /dev/loop0 /dev/loop1
=A0=A0=A0=A0=A0=A0=A0=A0 mkdir btrfs=20
=A0=A0=A0=A0=A0=A0=A0=A0 mount -t btrfs /dev/loop0 btrfs
=A0=A0=A0=A0=A0=A0=A0=A0 #create some files on btrfs
=A0=A0=A0=A0=A0=A0=A0=A0 btrfs-vol -r /dev/loop1 btrfs

Regards
Zhipeng
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
[=A0 519.625326] btrfs allocation failed flags 2, wanted 4096
[=A0 519.625334] space_info has 4128768 free, is not full
[=A0 519.625342] space_info total=3D4194304, pinned=3D0, delalloc=3D0, =
may_use=3D0, used=3D0, root=3D0, super=3D65536, reserved=3D0
[=A0 519.625350] block group 0 has 4194304 bytes, 0 used 0 pinned 0 res=
erved
[=A0 519.625357] entry offset 4096, bytes 61440, bitmap no
[=A0 519.625364] entry offset 131072, bytes 4063232, bitmap no
[=A0 519.625370] block group has cluster?: no
[=A0 519.625374] 2 blocks of free space at or bigger than bytes is
[=A0 519.625395] ------------[ cut here ]------------
[=A0 519.625401] kernel BUG at fs/btrfs/volumes.c:2389!
[=A0 519.625407] invalid opcode: 0000 [#1] PREEMPT SMP=20
[=A0 519.625417] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/=
PNP0A08:00/device:28/PNP0C0A:00/power_supply/BAT1/charge_full
[=A0 519.625424] Modules linked in: uvcvideo battery joydev
[=A0 519.625436]=20
[=A0 519.625444] Pid: 1079, comm: btrfs-vol Not tainted (2.6.32.rc5-72.=
2.moblin2-netbook #1) Inspiron 910
[=A0 519.625451] EIP: 0060:[<c11450e7>] EFLAGS: 00010286 CPU: 1
[=A0 519.625464] EIP is at __finish_chunk_alloc+0x77/0x202
[=A0 519.625470] EAX: ffffffe4 EBX: deed8500 ECX: 00000000 EDX: 0000002=
c
[=A0 519.625476] ESI: 04000000 EDI: 00000000 EBP: dc995c54 ESP: dc995bf=
8
[=A0 519.625483]=A0 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[=A0 519.625491] Process btrfs-vol (pid: 1079, ti=3Ddc994000 task=3Def9=
092d0 task.ti=3Ddc994000)
[=A0 519.625496] Stack:
[=A0 519.625500]=A0 00000000 00000000 e5de4800 00000001 e2c5aea4 e5d990=
00 00000000 e5c7c56c
[=A0 519.625517] <0> e5de4800 00000050 ef9823c0 04000000 00000000 cf372=
0e4 07c00000 00000000
[=A0 519.625535] <0> 00000000 00000000 f6914dc8 f6914dc8 e5de4800 e2c5a=
ea4 0000000a dc995c98
[=A0 519.625554] Call Trace:
[=A0 519.625565]=A0 [<c1146ea7>] ? btrfs_alloc_chunk+0x6f/0x81
[=A0 519.625576]=A0 [<c1118250>] ? do_chunk_alloc+0x1d5/0x228
[=A0 519.625587]=A0 [<c111f036>] ? btrfs_prepare_block_group_relocation=
+0x103/0x12b
[=A0 519.625598]=A0 [<c1159059>] ? btrfs_relocate_block_group+0x11e/0x3=
57
[=A0 519.625607]=A0 [<c114564b>] ? btrfs_relocate_chunk+0x57/0x432
[=A0 519.625618]=A0 [<c113d4c5>] ? map_private_extent_buffer+0xe7/0x109
[=A0 519.625628]=A0 [<c1135adf>] ? btrfs_dev_extent_chunk_offset+0x5c/0=
xa9
[=A0 519.625638]=A0 [<c113d190>] ? unmap_extent_buffer+0xc/0xe
[=A0 519.625646]=A0 [<c1135b20>] ? btrfs_dev_extent_chunk_offset+0x9d/0=
xa9
[=A0 519.625655]=A0 [<c1145c0e>] ? btrfs_shrink_device+0x1e8/0x2f3
[=A0 519.625666]=A0 [<c114626a>] ? btrfs_rm_device+0x1fe/0x44e
[=A0 519.625677]=A0 [<c108a9c3>] ? memdup_user+0x2c/0x43
[=A0 519.625685]=A0 [<c114a48a>] ? btrfs_ioctl+0x73c/0x8aa
[=A0 519.625695]=A0 [<c107b9a2>] ? filemap_fault+0xc9/0x34d
[=A0 519.625704]=A0 [<c107b4b0>] ? unlock_page+0x3e/0x41
[=A0 519.625713]=A0 [<c1149d4e>] ? btrfs_ioctl+0x0/0x8aa
[=A0 519.625723]=A0 [<c10ad7f2>] ? vfs_ioctl+0x18/0x71
[=A0 519.625731]=A0 [<c10addc0>] ? do_vfs_ioctl+0x4d6/0x514
[=A0 519.625741]=A0 [<c10a186c>] ? fd_install+0x44/0x4a
[=A0 519.625750]=A0 [<c10ade2c>] ? sys_ioctl+0x2e/0x48
[=A0 519.625760]=A0 [<c10029a1>] ? syscall_call+0x7/0xb
[=A0 519.625765] Code: 2f e9 a8 01 00 00 6b c1 0c 8b 75 18 8b 7d 1c 8b =
54 03 20 01 72 74 11 7a 78 8b 45 b4 89 4d a4 e8 6d fe ff ff 8b 4d a4 85=
 c0 74 04 <0f> 0b eb fe 41 3b 4b 18 7c d1 8b 45 cc 89 da 31 c9 83 c0 30=
 eb=20
[=A0 519.625868] EIP: [<c11450e7>] __finish_chunk_alloc+0x77/0x202 SS:E=
SP 0068:dc995bf8
[=A0 519.625881] ---[ end trace b163863f8b1f1b85 ]---

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
