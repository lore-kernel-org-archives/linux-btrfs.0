From: "Niraj kumar" <niraj17@gmail.com>
Subject: Re: PROBLEM: oops on attempt to mount badly formed filesystem
Date: Sat, 6 Dec 2008 14:00:38 +0530
Message-ID: <b82a89170812060030u1b56b781yd8c202051186e4ba@mail.gmail.com>
References: <49395BFF.8070800@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Eric Whitney" <eric.whitney@hp.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49395BFF.8070800@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 5, 2008 at 10:21 PM, Eric Whitney <eric.whitney@hp.com> wrote:
> Chris:
>
> I can consistently generate oopses (null pointer dereferenced) when
> attempting to mount a badly formed multi-device filesystem using kernels
> built from the current btrfs-unstable.  "Badly formed" means that mkfs was

I can also confirm this oops, in a very simple setup (no raid ).

(Note - In example below, /dev/sdb5 doesn't exist).

[root@f10-vm1 ~]# /home/niraj/btrfs/bin/mkfs.btrfs /dev/sdb2 /dev/sdb5
error checking /dev/sdb5 mount status
[root@f10-vm1 ~]# echo $?
1
[root@f10-vm1 ~]# mount -t btrfs /dev/sdb2 /f2

This mount attempt results in this oops:

------------[ cut here ]------------
kernel BUG at fs/btrfs/disk-io.c:913!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/misc/btrfs-control/dev
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in: btrfs zlib_deflate libcrc32c fuse sco bridge stp
bnep l2cap bluetooth sunrpc ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 dm_multipath uinput pcspkr pcnet32 mii
ata_generic pata_acpi [last unloaded: microcode]

Pid: 2426, comm: mount Tainted: G        W  (2.6.28-rc5 #9) VirtualBox
EIP: 0060:[<e0986491>] EFLAGS: 00210202 CPU: 0
EIP is at find_and_setup_root+0x58/0xac [btrfs]
EAX: 00000001 EBX: debc1060 ECX: e0975983 EDX: c04969ed
ESI: debc1060 EDI: d8569060 EBP: de81ad9c ESP: de81ad8c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
Process mount (pid: 2426, ti=de81a000 task=def053c0 task.ti=de81a000)
Stack:
 00001000 d8569060 debc1060 df1f0000 de81add8 e0986567 fffffff7 ffffffff
 d8569060 df1f1a5c de81adfb d8569060 c06e5618 c06e5633 a03eb7e3 a03eb800
 00000000 df1f0000 df1f0038 de81adf0 e098675a de81adfb df1f1ce4 df1f1ce4
Call Trace:
 [<e0986567>] ? btrfs_read_fs_root_no_radix+0x55/0x1d4 [btrfs]
 [<c06e5618>] ? __mutex_unlock_slowpath+0xf2/0x105
 [<c06e5633>] ? mutex_unlock+0x8/0xa
 [<e098675a>] ? btrfs_read_fs_root_no_name+0x74/0xec [btrfs]
 [<e098132f>] ? btrfs_cleanup_reloc_trees+0xa9/0xc0 [btrfs]
 [<e0988e12>] ? open_ctree+0xc40/0xdb4 [btrfs]
 [<c052f65b>] ? strlcpy+0x17/0x48
 [<e0974871>] ? btrfs_get_sb+0x201/0x3ec [btrfs]
 [<c04800aa>] ? kstrdup+0x2a/0x4c
 [<c049c152>] ? vfs_kern_mount+0x81/0xf3
 [<c049c4aa>] ? do_kern_mount+0x32/0xb3
 [<c04ac7a8>] ? do_mount+0x5f2/0x62c
 [<c053441c>] ? _raw_spin_lock+0x53/0xdd
 [<c04ac846>] ? sys_mount+0x64/0x9b
 [<c0403b96>] ? syscall_call+0x7/0xb
Code: 57 ff b3 94 02 00 00 e8 84 fd ff ff 8b 55 08 8d 87 2b 01 00 00
8b 4d 0c 50 8d 47 64 50 89 d8 e8 19 d2 ff ff 83 c4 1c 85 c0 74 04 <0f>
0b eb fe 80 bf 2a 01 00 00 00 8b 9f dc 00 00 00 8b b7 e0 00
EIP: [<e0986491>] find_and_setup_root+0x58/0xac [btrfs] SS:ESP 0069:de81ad8c
---[ end trace 4eaa2a86a8e2da22 ]---
