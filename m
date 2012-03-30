From: Jan Engelhardt <jengelh@medozas.de>
Subject: btrfs bugs on statfs on ro device
Date: Fri, 30 Mar 2012 17:13:25 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1203301709510.16756@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Attempting to run `df` on a read-only btrfs crashes the kernel:

  # losetup -r -o $[313344*512] /dev/loop4 wholedisk.img
  # mount -o ro /dev/loop4 /mnt

device fsid 4ba1fa38-d62b-4940-9825-7e6cceb7fcc8 devid 1 transid 4333 /dev/loop4

  # df

kernel BUG at [openSUSE 12.1 Rescue CD kernel] /home/abuild/rpmbuild/BUILD/kernel-default-3.1.0/linux-3.1/fs/btrfs/super.c:984!
 968:   static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 969:   {
 ...
 983:   nr_devices = fs_info->fs_devices->rw_devices;
>984:   BUG_ON(!nr_devices);


invalid opcode: 0000 [#1] SMP 
CPU 0 
Modules linked in: btrfs zlib_deflate nls_utf8 usb_storage arc4 ecb mperf fan thermal nfs nfs_acl lockd fscache auth_rpcgss sunrpc nls_iso8859_1 nls_cp437 af_packet usbhid st ohci_hcd sg sr_mod parport_pc parport ac cdrom ssb mptsas processor ehci_hcd mptscsih mmc_core button e1000 thermal_sys mptbase vboxguest usbcore pcmcia scsi_transport_sas pcmcia_core edd squashfs loop

Pid: 2333, comm: df Not tainted 3.1.0-1.2-default #1 innotek GmbH VirtualBox
RIP: 0010:[<ffffffffa0300e98>]  [<ffffffffa0300e98>] btrfs_calc_avail_data_space+0x278/0x280 [btrfs]
RSP: 0018:ffff880013b7fd98  EFLAGS: 00010246
RAX: ffff8800139ac000 RBX: ffff880013b7ff00 RCX: 000000000000000c
RDX: 000000009123683e RSI: ffff880013b7fe38 RDI: 0000000000000000
RBP: ffff880013b24800 R08: 0000000000000003 R09: ffff88000a536e78
R10: 0000000000000003 R11: ffff8800034e8001 R12: ffff880013b16480
R13: ffff880013b24800 R14: 000000000004e340 R15: 000000000000000c
FS:  00007f0640f99700(0000) GS:ffff880015600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0640a3c75a CR3: 000000000448d000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process df (pid: 2333, threadinfo ffff880013b7e000, task ffff88001396e1c0)
Stack:
 0000000000000001 0000000000000292 0000000000000000 ffffffff81158c1c
 ffff8800139ac000 ffff880013b7fe38 ffff880013b7fed8 ffffffffa03184f1
 0000000000000001 ffff880013b7ff00 ffff8800139ac000 ffff880005bb1a40
Call Trace:
 [<ffffffffa0300fc9>] btrfs_statfs+0x129/0x1d0 [btrfs]
 [<ffffffff81176aa8>] statfs_by_dentry+0x98/0x140
 [<ffffffff81176b71>] vfs_statfs+0x21/0x60
 [<ffffffff81176be0>] user_statfs+0x30/0x50
 [<ffffffff81176c62>] sys_statfs+0x12/0x30
 [<ffffffff81543e12>] system_call_fastpath+0x16/0x1b
 [<00007f0640abbd07>] 0x7f0640abbd06
Code: c4 48 5b 5d 41 5c 41 5d 41 5e 41 5f c3 45 31 c0 48 c7 c1 40 e0 2f a0 ba 20 00 00 00 31 f6 48 89 df 45 31 ed e8 fa c1 fa e0 eb 81 <0f> 0b 66 0f 1f 44 00 00 41 57 41 56 45 31 f6 41 55 41 54 49 89 
RIP  [<ffffffffa0300e98>] btrfs_calc_avail_data_space+0x278/0x280 [btrfs]
 RSP <ffff880013b7fd98>
---[ end trace 0f0a04393e646822 ]---

