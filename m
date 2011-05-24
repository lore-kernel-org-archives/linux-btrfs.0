From: Marco Neubauer <icetea1@gmx.net>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2271!
Date: Tue, 24 May 2011 20:55:47 +0200
Message-ID: <8E5549B7-EBD9-4D7C-87FA-4C49D1C453F8@gmx.net>
References: <383ECFA9-9E51-4CCD-BE24-21FD30813217@gmx.net> <4DC0170C.8000906@redhat.com> <63FD432D-9173-40E4-9A82-711C8C625B0E@gmx.net> <4DDAB207.6060500@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDAB207.6060500@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


Am 23.05.2011 um 21:14 schrieb Josef Bacik:

> On 05/22/2011 07:13 AM, Marco Neubauer wrote:
>> 
>> Am 03.05.2011 um 16:54 schrieb Josef Bacik:
>> 
>>> On 04/27/2011 02:52 PM, Marco Neubauer wrote:
>>>> Hi,
>>>> 
>>>> this is happening mostly every night. I can't reproduce it right now.
>>>> vanilla kernel 2.6.38.4
>>>> 
>>> 
>>> Can you update to a newer kernel, this should be fixed there.  Thanks,
>> 
>> It's happening again.
>> 
>> ------------[ cut here ]------------
> 
> Can you apply this patch and reproduce and send me the output so I can
> figure
> out whats going wrong?  Thanks,


May 24 03:10:01 mainframe cron[13013]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267
May 24 03:10:11 mainframe kernel: lookup of inode was from disk
May 24 03:10:11 mainframe kernel: found orphan item for 899452 on 267


<- cut -> A lot more messages. The entire file is 5.19 GB.


May 24 03:51:47 mainframe kernel: found orphan item for 899452 on 267
May 24 03:51:47 mainframe kernel: lookup of inode was from disk
May 24 03:51:47 mainframe kernel: found orphan item for 899452 on 267
May 24 03:51:47 mainframe kernel: lookup of inode was from disk
May 24 03:51:47 mainframe kernel: found orphan item for 909358 on 267
May 24 03:51:47 mainframe kernel: lookup of inode was from disk
May 24 03:51:47 mainframe kernel: 909358 is a bad inode
May 24 03:51:47 mainframe kernel: ------------[ cut here ]------------
May 24 03:51:47 mainframe kernel: kernel BUG at fs/btrfs/inode.c:2285!
May 24 03:51:47 mainframe kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
May 24 03:51:47 mainframe kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/block/sdc/sdc2/stat
May 24 03:51:47 mainframe kernel: CPU 0 
May 24 03:51:47 mainframe kernel: Modules linked in: w83627ehf hwmon_vid coretemp md4 cifs vboxnetadp vboxnetflt vboxdrv firewire_ohci firewire_core i915 asus_atk0110 hwmon drm_kms_helper video backlight
May 24 03:51:47 mainframe kernel: 
May 24 03:51:47 mainframe kernel: Pid: 13541, comm: updatedb Tainted: G        W   2.6.39 #2 System manufacturer System Product Name/V-P5G45
May 24 03:51:47 mainframe kernel: RIP: 0010:[<ffffffff8124b8e6>]  [<ffffffff8124b8e6>] btrfs_orphan_del+0xe6/0xf0
May 24 03:51:47 mainframe kernel: RSP: 0018:ffff88011be55ab8  EFLAGS: 00010282
May 24 03:51:47 mainframe kernel: RAX: 00000000fffffffe RBX: ffff880023fa8988 RCX: 000000000ab00490
May 24 03:51:47 mainframe kernel: RDX: 000000000ab0048c RSI: 00000000000199b0 RDI: ffffea0007a2c268
May 24 03:51:47 mainframe kernel: RBP: 0000000000000000 R08: ffffffff8127b558 R09: 0000000000000238
May 24 03:51:47 mainframe kernel: R10: 0000000000000042 R11: 0000000000000000 R12: ffff8800c352d740
May 24 03:51:47 mainframe kernel: R13: ffff88022b470000 R14: ffff88022b470330 R15: 0000000000000001
May 24 03:51:47 mainframe kernel: FS:  00007f86a60d3700(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
May 24 03:51:47 mainframe kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 24 03:51:47 mainframe kernel: CR2: 00007f38a80c1000 CR3: 000000011bf21000 CR4: 00000000000406f0
May 24 03:51:47 mainframe kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 24 03:51:47 mainframe kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 24 03:51:47 mainframe kernel: Process updatedb (pid: 13541, threadinfo ffff88011be54000, task ffff88020ef24d40)
May 24 03:51:47 mainframe kernel: Stack:
May 24 03:51:47 mainframe kernel: ffff880203811d60 ffff88022b470000 ffff88022e82ce10 0000000032f72582
May 24 03:51:47 mainframe kernel: 0000000000000000 ffff88011be55b58 ffff88011be55b18 ffffffff812511cd
May 24 03:51:47 mainframe kernel: ffff8800c352d740 ffff880023fa8988 ffff88022b470330 ffff88022b470338
May 24 03:51:47 mainframe kernel: Call Trace:
May 24 03:51:47 mainframe kernel: [<ffffffff812511cd>] ? btrfs_orphan_cleanup+0x3dd/0x450
May 24 03:51:47 mainframe kernel: [<ffffffff812509a3>] ? btrfs_iget+0x53/0x4a0
May 24 03:51:47 mainframe kernel: [<ffffffff81251658>] ? btrfs_lookup_dentry+0x418/0x490
May 24 03:51:47 mainframe kernel: [<ffffffff812516d9>] ? btrfs_lookup+0x9/0x20
May 24 03:51:47 mainframe kernel: [<ffffffff810f7e3c>] ? d_alloc_and_lookup+0x3c/0x90
May 24 03:51:47 mainframe kernel: [<ffffffff81102a6e>] ? d_lookup+0x2e/0x60
May 24 03:51:47 mainframe kernel: [<ffffffff810f98db>] ? do_lookup+0xcb/0x2b0
May 24 03:51:47 mainframe kernel: [<ffffffff810f9c0b>] ? path_init+0x14b/0x3d0
May 24 03:51:47 mainframe kernel: [<ffffffff810fbf74>] ? path_lookupat+0x154/0x750
May 24 03:51:47 mainframe kernel: [<ffffffff810f99f0>] ? do_lookup+0x1e0/0x2b0
May 24 03:51:47 mainframe kernel: [<ffffffff810fc59c>] ? do_path_lookup+0x2c/0xd0
May 24 03:51:47 mainframe kernel: [<ffffffff810f8776>] ? getname_flags+0x126/0x260
May 24 03:51:47 mainframe kernel: [<ffffffff810fd31c>] ? user_path_at+0x5c/0xc0
May 24 03:51:47 mainframe kernel: [<ffffffff810fc59c>] ? do_path_lookup+0x2c/0xd0
May 24 03:51:47 mainframe kernel: [<ffffffff810f1f50>] ? cp_new_stat+0xe0/0x100
May 24 03:51:47 mainframe kernel: [<ffffffff810f2053>] ? vfs_fstatat+0x43/0x80
May 24 03:51:47 mainframe kernel: [<ffffffff810f211f>] ? sys_newlstat+0x1f/0x50
May 24 03:51:47 mainframe kernel: [<ffffffff8169e4fb>] ? system_call_fastpath+0x16/0x1b
May 24 03:51:47 mainframe kernel: Code: 4c 8b 6c 24 20 4c 8b 74 24 28 4c 8b 7c 24 30 48 83 c4 38 c3 90 48 8b 93 a8 00 00 00 4c 89 ee 4c 89 e7 e8 fe fb 02 00 85 c0 74 b8 <0f> 0b eb fe 66 0f 1f 44 00 00 53 48 8d 86 38 03 00 00 48 89 f3 
May 24 03:51:47 mainframe kernel: RIP  [<ffffffff8124b8e6>] btrfs_orphan_del+0xe6/0xf0
May 24 03:51:47 mainframe kernel: RSP <ffff88011be55ab8>
May 24 03:51:47 mainframe kernel: ---[ end trace 3413969c6e2d3603 ]---



-marco



