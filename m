From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Date: Thu, 8 Mar 2012 13:10:45 +0100
Message-ID: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this shown up today. I had to do a hard reboot as graceful hanged on sync().

------------[ cut here ]------------
kernel BUG at fs/btrfs/delayed-inode.c:1466!
invalid opcode: 0000 [#1] SMP
CPU 10
Modules linked in: btrfs zlib_deflate lzo_compress ipmi_devintf
autofs4 be2iscsi iscsi_boot_sysfs ib_iser rdma_cm ib_cm iw_cm ib_sa
ib_mad ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxgb3i libcxgbi iw_cxgb3
ib_core cxgb3 libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror
dm_region_hash dm_log dm_multipath video battery acpi_pad acpi_ipmi ac
parport usbhid evdev acpi_power_meter radeon ttm drm_kms_helper drm
hwmon backlight i2c_algo_bit ipmi_si bnx2x ipmi_msghandler i2c_core
hpwdt hpilo psmouse mdio uhci_hcd ehci_hcd

Pid: 1488, comm: mips-wrs-linux- Tainted: G        W    3.2.7 #2 HP
ProLiant BL460c G6
RIP: 0010:[<ffffffffa03559f9>]  [<ffffffffa03559f9>]
btrfs_delete_delayed_dir_index+0xe9/0x157 [btrfs]
RSP: 0018:ffff8805d5b43ba8  EFLAGS: 00010286
RAX: 00000000ffffffe4 RBX: ffff8805f0a57c00 RCX: 0000000002b06e0a
RDX: 00000000ffffffe4 RSI: 0000000000018000 RDI: ffff880bee4c8150
RBP: 00000000fffffff4 R08: ffffea002fd582c0 R09: 0000001a00000000
R10: 0000000000000001 R11: ffff880bf58c7800 R12: ffff8801059cf0e0
R13: ffff8801059cf128 R14: ffff8805d5b43bb8 R15: ffff880bf58c7800
FS:  0000000000000000(0000) GS:ffff880c1fca0000(0063) knlGS:00000000f77566c0
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 000000000807b3b9 CR3: 0000000953a76000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mips-wrs-linux- (pid: 1488, threadinfo ffff8805d5b42000, task
ffff8805b4acec00)
Stack:
 0000000000000085 ffff880bf0984870 000000000033bef7 0000000000008560
 0000000000000000 00000000000007bf ffff880bf0984870 00000000000009d9
 0000000000000000 ffff880bf560b1b0 ffff8805c29a5e88 000000000033bef7
Call Trace:
 [<ffffffffa03210e5>] ? __btrfs_unlink_inode+0x172/0x25e [btrfs]
 [<ffffffffa032158c>] ? btrfs_rename+0x38b/0x55b [btrfs]
 [<ffffffff81124e8c>] ? vfs_rename+0x202/0x382
 [<ffffffff81127312>] ? sys_renameat+0x169/0x1e5
 [<ffffffff81051164>] ? do_page_fault+0x39b/0x3af
 [<ffffffff8112c35e>] ? dput+0x3f/0x126
 [<ffffffff8111ee28>] ? vfs_fstatat+0x57/0x60
 [<ffffffff81057176>] ? sys32_lstat64+0x20/0x29
 [<ffffffff810a72f2>] ? audit_syscall_entry+0x176/0x1a1
 [<ffffffff813e6c30>] ? sysenter_dispatch+0x7/0x2e
Code: 4c 89 ef e8 ad d6 08 e1 eb 74 fc 48 8d 78 18 4c 89 f6 48 89 c2
a5 a5 a5 a5 a4 4c 89 fe 48 8b 7c 24 08 e8 58 e9 ff ff 85 c0 74 04 <0f>
0b eb fe 4c 89 ef e8 5c d6 08 e1 ba 02 00 00 00 48 89 de 4c
RIP  [<ffffffffa03559f9>] btrfs_delete_delayed_dir_index+0xe9/0x157 [btrfs]
 RSP <ffff8805d5b43ba8>
---[ end trace cc1045e0105e2505 ]---

-Jacek
