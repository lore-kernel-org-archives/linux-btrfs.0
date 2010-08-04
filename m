From: wks1986 <wks1986@gmail.com>
Subject: A reproducible crush of mounting a subvolume
Date: Wed, 4 Aug 2010 16:39:20 +0800
Message-ID: <AANLkTim9GbEJ-9MNJ=tnprfszJfN=d=3juZqaYZd-b0x@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello

I did the following commands and resulted in a segmentation fault.

[root@localhost ~]# mkfs.btrfs /dev/sda6

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sda6
	nodesize 4096 leafsize 4096 sectorsize 4096 size 46.93GB
Btrfs Btrfs v0.19
[root@localhost ~]# mount /dev/sda6 /mnt/btra
[root@localhost ~]# cd /mnt/btra
[root@localhost btra]# touch {1..10}
[root@localhost btra]# btrfs subvolume snapshot . snap
Create a snapshot of '.' in './snap'
[root@localhost btra]# cd snap
[root@localhost snap]# echo "snapshot" >> 1
[root@localhost snap]# cd ..
[root@localhost btra]# mkdir dir
[root@localhost btra]# cd dir
[root@localhost dir]# btrfs subvolume snapshot .. snap
Create a snapshot of '..' in './snap'
[root@localhost dir]# cd ../..
[root@localhost mnt]# umount btra
[root@localhost mnt]# mount -o subvol=dir/snap /dev/sda6 btra
Segmentation fault


And dmesg shows:

e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
fuse init (API version 7.14)
Btrfs loaded
device fsid bf4b2dc4dca2c8f8-a523f8dd8f6aa4ad devid 1 transid 7 /dev/sda6
device fsid bf4b2dc4dca2c8f8-a523f8dd8f6aa4ad devid 1 transid 12 /dev/sda6
BUG: Dentry ffff8800aac528f8{i=100,n=/} still in use (1) [unmount of btrfs sda6]
------------[ cut here ]------------
kernel BUG at fs/dcache.c:675!
invalid opcode: 0000 [#1] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/dev
CPU 1
Modules linked in: btrfs zlib_deflate libcrc32c fuse sunrpc
cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT
nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 uinput
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep ppdev
dell_wmi parport_pc e1000e snd_seq parport snd_seq_device wmi snd_pcm
snd_timer snd soundcore snd_page_alloc serio_raw i2c_i801 iTCO_wdt
iTCO_vendor_support dcdbas microcode pata_acpi ata_generic radeon ttm
drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded:
scsi_wait_scan]

Pid: 2465, comm: mount Not tainted 2.6.35-0.47.rc5.git2.fc14.x86_64 #1
0V4W66/OptiPlex 780
RIP: 0010:[<ffffffff8113a58c>]  [<ffffffff8113a58c>]
shrink_dcache_for_umount_subtree+0x133/0x210
RSP: 0018:ffff8800a9d3dc88  EFLAGS: 00010296
RAX: 0000000000000057 RBX: ffff8800aac528f8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff81eee894 RDI: 0000000000000246
RBP: ffff8800a9d3dcb8 R08: 000000000000ba70 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800aac528f8
R13: 0000000000000000 R14: ffff8800aac52998 R15: ffff8801234432c0
FS:  00007effe69db7e0(0000) GS:ffff880002e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000fd1198 CR3: 00000000aa06e000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 2465, threadinfo ffff8800a9d3c000, task ffff8800abaea450)
Stack:
 ffff8800c2e32e28 ffff8800aad7cfd8 ffff8800c2e32968 ffff8800aac528f8
<0> 00000000fffffff3 fffffffffffffff3 ffff8800a9d3dcd8 ffffffff8113b1fd
<0> ffff8800c2e32968 ffffffffa034db10 ffff8800a9d3dcf8 ffffffff8112af26
Call Trace:
 [<ffffffff8113b1fd>] shrink_dcache_for_umount+0x40/0x51
 [<ffffffff8112af26>] generic_shutdown_super+0x1f/0xe1
 [<ffffffff8112b03d>] kill_anon_super+0x16/0x54
 [<ffffffff8112b604>] deactivate_locked_super+0x26/0x46
 [<ffffffffa02fdaeb>] btrfs_get_sb+0x360/0x3ec [btrfs]
 [<ffffffff81111378>] ? alloc_pages_current+0xb2/0xc2
 [<ffffffff8112b85a>] vfs_kern_mount+0xad/0x1a0
 [<ffffffff8112b9b5>] do_kern_mount+0x4d/0xef
 [<ffffffff81141cbc>] do_mount+0x732/0x78f
 [<ffffffff81141f4e>] sys_mount+0x88/0xc2
 [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
Code: 00 00 48 8b 40 28 4c 8b 08 48 8b 43 50 48 85 c0 74 04 48 8b 50
40 48 89 34 24 48 c7 c7 26 90 7a 81 48 89 de 31 c0 e8 c0 b6 35 00 <0f>
0b 4c 8b 63 68 4c 39 e3 74 0a 4c 89 e7 e8 5f f0 ff ff eb 03
RIP  [<ffffffff8113a58c>] shrink_dcache_for_umount_subtree+0x133/0x210
 RSP <ffff8800a9d3dc88>
---[ end trace 0be5fe6dc2c0d3ad ]---


This problem is reproducible on 2.6.33.6-147.fc13.x86_64 and
2.6.35-0.47.rc5.git2.fc14.x86_64 provided by the Fedora distribution.
It is also reproducible on another machine with the 2.6.35-rc6+ kernel
from the "mainline" git repository of kernel.org.
It can be produced with the same procedure as shown above.


Kunshan Wang
