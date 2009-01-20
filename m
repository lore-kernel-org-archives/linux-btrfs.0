From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Tue, 20 Jan 2009 18:34:55 +0100
Message-ID: <20090120173455.GC21339@alice>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed> <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090120125944.GC10158@disturbed>
List-ID: <linux-btrfs.vger.kernel.org>

* Dave Chinner (david@fromorbit.com) wrote:
> On Tue, Jan 20, 2009 at 11:15:03AM +0100, Eric Sesterhenn wrote:
> > * Dave Chinner (david@fromorbit.com) wrote:
> > > On Tue, Jan 20, 2009 at 07:31:50AM +0100, Eric Sesterhenn wrote:
> > > > * Pavel Machek (pavel@suse.cz) wrote:
> > > > > Does ext2/3 and vfat survive that kind of attacks? Those are 'in
> > > > > production' and should survive it...
> > > > 
> > > > I regularly (once or twice a week) test 100 corrupted images of 
> > > > vfat, udf, msdos, swap, iso9660, ext2, ext3, ext4, minix, bfs, befs,
> > > > hfs, hfs+, qnx4, affs and cramfs on each of my two test machines.
> > > 
> > > Any reason you are not testing XFS in that set?
> > 
> > So far the responses from xfs folks have been disappointing, if you are
> > interested in bugreports i can send you some.
> 
> Sure I am.  It would be good if you could start testing XFS along
> with all the other filesystems and report anything you find.

Ok, i wont report stuff with only xfs-internal backtraces from
xfs_error_report() or are they interesting to you?

This occurs during mount, box is dead afterwards
Image can be found here :
http://www.cccmz.de/~snakebyte/xfs.11.img.bz2
I see this every ~10 images, which makes further testing hard :)

[  235.250167] ------------[ cut here ]------------
[  235.250354] kernel BUG at mm/vmalloc.c:164!
[  235.250478] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  235.250869] last sysfs file: /sys/block/ram9/range
[  235.250998] Modules linked in:
[  235.251037] 
[  235.251037] Pid: 5352, comm: mount Not tainted
(2.6.29-rc2-00021-gd84d31c #216) System Name
[  235.251037] EIP: 0060:[<c0182af1>] EFLAGS: 00010246 CPU: 0
[  235.251037] EIP is at vmap_page_range+0x19/0x112
[  235.251037] EAX: d1000000 EBX: d1000000 ECX: 00000163 EDX: d1000000
[  235.251037] ESI: 00000003 EDI: d1000000 EBP: cbbd2c08 ESP: cbbd2be8
[  235.251037]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  235.251037] Process mount (pid: 5352, ti=cbbd2000 task=cbb85b00
task.ti=cbbd2000)
[  235.251037] Stack:
[  235.251037]  00000246 cbb85b00 00000163 c01414cf cbbd2c0c d1000000
00000003 cba0f810
[  235.251037]  cbbd2c40 c018367c c848e280 00100000 00000000 c848e280
00000000 00000014
[  235.251037]  d1000000 cba0f944 00000000 c848e160 00000000 c848e160
cbbd2c54 c03b2e1e
[  235.251037] Call Trace:
[  235.251037]  [<c01414cf>] ? trace_hardirqs_on+0xb/0xd
[  235.251037]  [<c018367c>] ? vm_map_ram+0x36e/0x38a
[  235.251037]  [<c03b2e1e>] ? _xfs_buf_map_pages+0x42/0x6d
[  235.251037]  [<c03b3773>] ? xfs_buf_get_noaddr+0xbc/0x11f
[  235.251037]  [<c03a2406>] ? xlog_get_bp+0x5a/0x5d
[  235.251037]  [<c03a28fa>] ? xlog_find_verify_log_record+0x26/0x208
[  235.251037]  [<c03a3521>] ? xlog_find_zeroed+0x1d6/0x214
[  235.251037]  [<c03a3584>] ? xlog_find_head+0x25/0x358
[  235.251037]  [<c011ca1f>] ? __enqueue_entity+0xa1/0xa9
[  235.251037]  [<c0107084>] ? native_sched_clock+0x41/0x68
[  235.251037]  [<c03a38d2>] ? xlog_find_tail+0x1b/0x3fa
[  235.251037]  [<c01412b5>] ? mark_held_locks+0x43/0x5a
[  235.251037]  [<c07b06a8>] ? _spin_unlock_irqrestore+0x3b/0x5d
[  235.251037]  [<c07b06b4>] ? _spin_unlock_irqrestore+0x47/0x5d
[  235.251037]  [<c01209c6>] ? try_to_wake_up+0x12f/0x13a
[  235.251037]  [<c03a5654>] ? xlog_recover+0x19/0x81
[  235.251037]  [<c03aaac3>] ? xfs_trans_ail_init+0x4b/0x64
[  235.251037]  [<c039f97d>] ? xfs_log_mount+0xef/0x13d
[  235.251037]  [<c03a7152>] ? xfs_mountfs+0x30d/0x5b8
[  235.251037]  [<c0506101>] ? __debug_object_init+0x28b/0x293
[  235.251037]  [<c012b3b5>] ? init_timer+0x1c/0x1f
[  235.251037]  [<c03a7aa1>] ? xfs_mru_cache_create+0x114/0x14e
[  235.251037]  [<c03ba205>] ? xfs_fs_fill_super+0x196/0x2e5
[  235.251037]  [<c01919c5>] ? get_sb_bdev+0xf1/0x13f
[  235.251037]  [<c0178896>] ? kstrdup+0x2f/0x51
[  235.251037]  [<c03b881b>] ? xfs_fs_get_sb+0x18/0x1a
[  235.251037]  [<c03ba06f>] ? xfs_fs_fill_super+0x0/0x2e5
[  235.251037]  [<c019159c>] ? vfs_kern_mount+0x40/0x7b
[  235.251037]  [<c0191625>] ? do_kern_mount+0x37/0xbf
[  235.251037]  [<c01a2cb0>] ? do_mount+0x5cc/0x609
[  235.251037]  [<c07b087b>] ? lock_kernel+0x19/0x8c
[  235.251037]  [<c01a2d43>] ? sys_mount+0x56/0xa0
[  235.251037]  [<c01a2d56>] ? sys_mount+0x69/0xa0
[  235.251037]  [<c0102ea1>] ? sysenter_do_call+0x12/0x31
[  235.251037] Code: 0f 0b eb fe ba 01 00 00 00 89 c8 e8 02 ff ff ff 5d
c3 55 89 e5 57 56 53 83 ec 14 0f 1f 44 00 00 39 d0 89 c3 89 d7 89 4d e8
72 04 <0f> 0b eb fe c1 e8 16 8d 34 85 00 00 00 00 03 35 84 91 a3 c0 8d 
[  235.251037] EIP: [<c0182af1>] vmap_page_range+0x19/0x112 SS:ESP
0068:cbbd2be8
[  235.269534] ---[ end trace 2d923bf9b290e3d9 ]---
[  235.274695] BUG: unable to handle kernel NULL pointer dereference at
0000000f
[  235.275005] IP: [<c0136592>] enqueue_hrtimer+0x2d/0x85
[  235.275041] *pde = 00000000 
[  235.275041] Oops: 0000 [#2] PREEMPT DEBUG_PAGEALLOC
[  235.275041] last sysfs file: /sys/block/ram9/range
[  235.275041] Modules linked in:
[  235.275041] 
[  235.275041] Pid: 5356, comm: syslogd Tainted: G      D
(2.6.29-rc2-00021-gd84d31c #216) System Name
[  235.275041] EIP: 0060:[<c0136592>] EFLAGS: 00010086 CPU: 0
[  235.275041] EIP is at enqueue_hrtimer+0x2d/0x85
[  235.275041] EAX: cba3cb00 EBX: cbbbad24 ECX: ffffffff EDX: 0000003a
[  235.275041] ESI: cba3cb04 EDI: c0a42d84 EBP: c8429f0c ESP: c8429efc
[  235.275041]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  235.275041] Process syslogd (pid: 5356, ti=c8429000 task=cbb14e00
task.ti=c8429000)
[  235.275041] Stack:
[  235.275041]  00000000 00000000 00000000 cbbbad24 c8429f2c c0136a47
c0a42d84 00000096
[  235.275041]  00000000 cbb14e00 7e11d600 00000003 c8429f3c c0136b2a
00000000 00000001
[  235.275041]  c8429f80 c0126d3e 00000001 00000000 00000000 cbbbacc0
bfbc59dc c8429f7c
[  235.275041] Call Trace:
[  235.275041]  [<c0136a47>] ? hrtimer_start_range_ns+0xc2/0x193
[  235.275041]  [<c0136b2a>] ? hrtimer_start+0x12/0x14
[  235.275041]  [<c0126d3e>] ? do_setitimer+0x131/0x2d4
[  235.275041]  [<c0126f93>] ? alarm_setitimer+0x3a/0x59
[  235.275041]  [<c012b5b1>] ? sys_alarm+0x10/0x12
[  235.275041]  [<c0102ea1>] ? sysenter_do_call+0x12/0x31
[  235.275041] Code: e5 57 56 53 83 ec 04 0f 1f 44 00 00 89 d7 89 c3 8d
72 08 ba c0 2d a4 c0 e8 a1 f5 3c 00 31 c0 c7 45 f0 01 00 00 00 eb 23 8b
53 10 <3b> 51 10 8b 43 0c 7f 0c 7c 05 3b 41 0c 73 05 8d 71 08 eb 0a 8d 
[  235.275041] EIP: [<c0136592>] enqueue_hrtimer+0x2d/0x85 SS:ESP
0068:c8429efc
[  235.275041] ---[ end trace 2d923bf9b290e3da ]---
[  235.275041] note: syslogd[5356] exited with preempt_count 2


Different trace from the same issue:

[  329.292534] ------------[ cut here ]------------
[  329.292721] kernel BUG at mm/vmalloc.c:164!
[  329.292849] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  329.293037] last sysfs file: /sys/block/ram9/range
[  329.293037] Modules linked in:
[  329.293037] 
[  329.293037] Pid: 5860, comm: mount Tainted: G        W
(2.6.29-rc2-00021-gd84d31c #216) System Name
[  329.293037] EIP: 0060:[<c0182af1>] EFLAGS: 00010246 CPU: 0
[  329.293037] EIP is at vmap_page_range+0x19/0x112
[  329.293037] EAX: d1800000 EBX: d1800000 ECX: 00000163 EDX: d1800000
[  329.293037] ESI: 00000005 EDI: d1800000 EBP: cacacc08 ESP: cacacbe8
[  329.293037]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  329.293037] Process mount (pid: 5860, ti=cacac000 task=caf71a00
task.ti=cacac000)
[  329.293037] Stack:
[  329.293037]  00000246 caf71a00 00000163 c01414cf cacacc0c d1800000
00000005 cae795e0
[  329.293037]  cacacc40 c018367c c280e120 00100000 00000000 c280e120
00000000 00000014
[  329.293037]  d1800000 cae79714 00000000 c280e000 00000000 c280e000
cacacc54 c03b2e1e
[  329.293037] Call Trace:
[  329.293037]  [<c01414cf>] ? trace_hardirqs_on+0xb/0xd
[  329.293037]  [<c018367c>] ? vm_map_ram+0x36e/0x38a
[  329.293037]  [<c03b2e1e>] ? _xfs_buf_map_pages+0x42/0x6d
[  329.293037]  [<c03b3773>] ? xfs_buf_get_noaddr+0xbc/0x11f
[  329.293037]  [<c03a2406>] ? xlog_get_bp+0x5a/0x5d
[  329.293037]  [<c03a28fa>] ? xlog_find_verify_log_record+0x26/0x208
[  329.293037]  [<c03a3521>] ? xlog_find_zeroed+0x1d6/0x214
[  329.293037]  [<c03a3584>] ? xlog_find_head+0x25/0x358
[  329.293037]  [<c011ca1f>] ? __enqueue_entity+0xa1/0xa9
[  329.293037]  [<c03a38d2>] ? xlog_find_tail+0x1b/0x3fa
[  329.293037]  [<c01414cf>] ? trace_hardirqs_on+0xb/0xd
[  329.293037]  [<c07b06a8>] ? _spin_unlock_irqrestore+0x3b/0x5d
[  329.293037]  [<c07b06b4>] ? _spin_unlock_irqrestore+0x47/0x5d
[  329.293037]  [<c01209c6>] ? try_to_wake_up+0x12f/0x13a
[  329.293037]  [<c03a5654>] ? xlog_recover+0x19/0x81
[  329.293037]  [<c03aaac3>] ? xfs_trans_ail_init+0x4b/0x64
[  329.293037]  [<c039f97d>] ? xfs_log_mount+0xef/0x13d
[  329.293037]  [<c03a7152>] ? xfs_mountfs+0x30d/0x5b8
[  329.293037]  [<c0506101>] ? __debug_object_init+0x28b/0x293
[  329.293037]  [<c012b3b5>] ? init_timer+0x1c/0x1f
[  329.293037]  [<c03a7aa1>] ? xfs_mru_cache_create+0x114/0x14e
[  329.293037]  [<c03ba205>] ? xfs_fs_fill_super+0x196/0x2e5
[  329.293037]  [<c01919c5>] ? get_sb_bdev+0xf1/0x13f
[  329.293037]  [<c0178896>] ? kstrdup+0x2f/0x51
[  329.293037]  [<c03b881b>] ? xfs_fs_get_sb+0x18/0x1a
[  329.293037]  [<c03ba06f>] ? xfs_fs_fill_super+0x0/0x2e5
[  329.293037]  [<c019159c>] ? vfs_kern_mount+0x40/0x7b
[  329.293037]  [<c0191625>] ? do_kern_mount+0x37/0xbf
[  329.293037]  [<c01a2cb0>] ? do_mount+0x5cc/0x609
[  329.293037]  [<c07b087b>] ? lock_kernel+0x19/0x8c
[  329.293037]  [<c01a2d43>] ? sys_mount+0x56/0xa0
[  329.293037]  [<c01a2d56>] ? sys_mount+0x69/0xa0
[  329.293037]  [<c0102ea1>] ? sysenter_do_call+0x12/0x31
[  329.293037] Code: 0f 0b eb fe ba 01 00 00 00 89 c8 e8 02 ff ff ff 5d
c3 55 89 e5 57 56 53 83 ec 14 0f 1f 44 00 00 39 d0 89 c3 89 d7 89 4d e8
72 04 <0f> 0b eb fe c1 e8 16 8d 34 85 00 00 00 00 03 35 84 91 a3 c0 8d 
[  329.293037] EIP: [<c0182af1>] vmap_page_range+0x19/0x112 SS:ESP
0068:cacacbe8
[  329.310688] ---[ end trace a7919e7f17c0a727 ]---

Greetings, Eric


