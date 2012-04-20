From: Remco Hosman <remco@hosman.xs4all.nl>
Subject: kernel bug in 3.4.0-rc3 after disconnecting/reconnecting drives
Date: Fri, 20 Apr 2012 20:41:10 +0200
Message-ID: <4F91ADC6.6040706@hosman.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I managed to brake my test filesystem after several times disconnecting 
1 disk, reconnecting it, disconnecting all disks at the same time 
(unplugging the USB enclosure they are in) and things like that.
when i try to mount, i get this error in dmesg:

[   46.645732] btrfs: use zlib compression
[   46.645765] btrfs: disk space caching is enabled
[   46.772220] parent transid verify failed on 2506608713728 wanted 
31547 found 14280
[   46.772270] failed mirror was 0
[   46.773025] parent transid verify failed on 2506608713728 wanted 
31547 found 14280
[   46.773060] failed mirror was 0
[   46.785667] ------------[ cut here ]------------
[   46.785695] kernel BUG at fs/btrfs/extent_io.c:1890!
[   46.785719] invalid opcode: 0000 [#1] PREEMPT SMP
[   46.785756] CPU 0
[   46.785768] Modules linked in: btrfs zlib_deflate crc32c libcrc32c 
nouveau video mxm_wmi wmi drm_kms_helper ttm drm nvidiafb vgastate skge 
forcedeth powernow_k8 serio_raw pcspkr mperf microcode evdev ns558 
gameport i2c_nforce2 i2c_core thermal button processor fan usbhid hid 
sd_mod pata_amd usb_storage pata_acpi sata_sil ata_generic ohci_hcd 
sata_sil24 sata_nv libata scsi_mod ehci_hcd usbcore usb_common
[   46.786186]
[   46.786204] Pid: 648, comm: mount Not tainted 3.4.0-rc3-RH #1 System 
manufacturer System name/A8N-SLI DELUXE
[   46.786266] RIP: 0010:[<ffffffffa042a86f>]  [<ffffffffa042a86f>] 
repair_io_failure+0x17f/0x1c0 [btrfs]
[   46.786368] RSP: 0018:ffff8800b8fab9f8  EFLAGS: 00010246
[   46.786395] RAX: ffff8800b8faba28 RBX: 000002479d85a000 RCX: 
000002479d85a000
[   46.786428] RDX: 0000000000001000 RSI: 000002479d85a000 RDI: 
ffff8800b9dc4108
[   46.786461] RBP: ffff8800b8faba68 R08: ffffea0002e7c380 R09: 
0000000000000000
[   46.786493] R10: 0000000000000000 R11: 0000000000000001 R12: 
0000000000001000
[   46.786525] R13: ffffea0002e7c380 R14: ffff8800b9dc4108 R15: 
0000000000000000
[   46.786558] FS:  00007f66a1134740(0000) GS:ffff8800bfc00000(0000) 
knlGS:0000000000000000
[   46.786598] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   46.786626] CR2: 00007f9487dbb000 CR3: 00000000b9f01000 CR4: 
00000000000007f0
[   46.786659] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   46.786691] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   46.786724] Process mount (pid: 648, threadinfo ffff8800b8faa000, 
task ffff8800b8b9bf80)
[   46.786762] Stack:
[   46.786779]  ffff8800b8fab9f8 000002479d85a000 0000000000000000 
0000000000000000
[   46.786840]  0000000000000000 00000000783f0000 ffff8800b8faba28 
ffff8800b8faba28
[   46.786899]  0000000000000000 000002479d85a000 0000000000000000 
ffff8800b9dc4108
[   46.786957] Call Trace:
[   46.787001]  [<ffffffffa042b212>] repair_eb_io_failure+0x82/0xb0 [btrfs]
[   46.787053]  [<ffffffffa0401252>] 
btree_read_extent_buffer_pages.constprop.111+0x102/0x130 [btrfs]
[   46.787117]  [<ffffffffa0401a3a>] read_tree_block+0x3a/0x50 [btrfs]
[   46.787168]  [<ffffffffa04054f2>] open_ctree+0x12c2/0x1ad0 [btrfs]
[   46.787206]  [<ffffffff812a30ba>] ? disk_name+0xba/0xc0
[   46.787248]  [<ffffffffa03e2846>] btrfs_mount+0x5b6/0x6a0 [btrfs]
[   46.787283]  [<ffffffff8114dfe0>] ? alloc_pages_current+0xb0/0x120
[   46.787317]  [<ffffffff81172193>] mount_fs+0x43/0x1b0
[   46.787347]  [<ffffffff8118c310>] vfs_kern_mount+0x70/0x100
[   46.787378]  [<ffffffff8118c834>] do_kern_mount+0x54/0x110
[   46.787410]  [<ffffffff8118e11a>] do_mount+0x26a/0x850
[   46.787442]  [<ffffffff81110c3e>] ? __get_free_pages+0xe/0x50
[   46.787473]  [<ffffffff8118dd1a>] ? copy_mount_options+0x3a/0x180
[   46.787505]  [<ffffffff8118e83d>] sys_mount+0x8d/0xe0
[   46.787535]  [<ffffffff814b9929>] system_call_fastpath+0x16/0x1b
[   46.787564] Code: 82 d7 e0 b8 fb ff ff ff 48 8b 5d d8 4c 8b 65 e0 4c 
8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 66 0f 1f 44 00 00 b8 fb ff ff ff 
eb dd <0f> 0b 0f 0b 49 8b 45 08 49 8b 8f 88 00 00 00 4d 89 f0 48 8b 55
[   46.787993] RIP  [<ffffffffa042a86f>] repair_io_failure+0x17f/0x1c0 
[btrfs]
[   46.788053]  RSP <ffff8800b8fab9f8>
[   46.788111] ---[ end trace c2c3c0f7ca538d25 ]---

Then i tried btrfsck (current git pull from 
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git )

it did output a LOT of data (i have the output, 8.3 meg, 370k in xz 
format, 544k in bzip2).
to give a few 'highlights', it started with a lot of things like this:
parent transid verify failed on 2506608713728 wanted 31547 found 14280
parent transid verify failed on 2506608713728 wanted 31547 found 14280
--- then some:
bad block 2506607267840
leaf parent key incorrect 2506608812032
bad block 2506608812032
--- some like this:
parent transid verify failed on 2506600460288 wanted 31542 found 14288
Ignoring transid failure
parent transid verify failed on 2506605555712 wanted 31545 found 14280
--- then some:
ref mismatch on [2506472095744 4096] extent item 1, found 0
Backref 2506472095744 root 2 not referenced back 0x2c6cdc0
Incorrect global backref count on 2506472095744 found 1 wanted 0
backpointer mismatch on [2506472095744 4096]
owner ref check failed [2506472095744 4096]
-- and:
ackref 2506995310592 parent 2524764864512 not referenced back 0x89971b0
Incorrect global backref count on 2506995310592 found 1 wanted 0
backpointer mismatch on [2506995310592 4096]
owner ref check failed [2506995310592 4096]
ref mismatch on [2506995359744 4096] extent item 1, found 0
--- and ended with:
checking root refs
found 2341466357760 bytes used err is 0
total csum bytes: 2243015812
total tree bytes: 3809906688
total fs tree bytes: 766795776
btree space waste bytes: 626726388
file data blocks allocated: 2295997747200
  referenced 2316898037760
Btrfs Btrfs v0.19

Kernel version is 3.4.0-rc3.

output from `btrfs file show` :
Label: none  uuid: 24779492-902d-4ba5-8807-ed18e86033cf
     Total devices 6 FS bytes used 2.13TB
     devid    9 size 465.76GB used 4.00GB path /dev/sdg
     devid    2 size 1.36TB used 1.16TB path /dev/sdc
     devid    7 size 465.76GB used 380.76GB path /dev/sdf
     devid    5 size 1.36TB used 1.16TB path /dev/sdd
     devid    6 size 465.76GB used 380.76GB path /dev/sde
     devid    8 size 2.73TB used 2.52TB path /dev/sda

So:
1) how can i help locating this issue?

2) should i keep the filesystem or format and start over to reproduce 
the error?

3) anything else i can try to fix the filesystem? not that i need the 
data, it would be just to test if recovery would be possible.

Remco
