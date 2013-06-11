Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:51462 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3FKPtO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 11:49:14 -0400
Received: from cpe-67-240-79-210.nycap.res.rr.com ([67.240.79.210] helo=[192.168.5.80])
	by mail.mystoragebox.com with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <markm-lists@intellasoft.net>)
	id 1UmQEJ-0003FK-7b
	for linux-btrfs@vger.kernel.org; Tue, 11 Jun 2013 11:11:27 -0400
Message-ID: <51B73E1D.9080902@intellasoft.net>
Date: Tue, 11 Jun 2013 11:11:25 -0400
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: BUG
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With this array I have to mount -o degraded, even though all devices are 
present.

Linux cartman 3.9.0 #1 SMP PREEMPT Fri May 3 22:02:21 EDT 2013 x86_64 
GNU/Linux
btrfs-tools 
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git * 
master 7854c8b


When I try and mount without degraded, I get this:
btrfs: failed to read chunk tree on sdh
btrfs: open_ctree failed


Mounting -o degraded, I get this:

cartman {~} root# btrfs filesystem show
Label: none  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
         Total devices 2 FS bytes used 7.01GB
         devid    1 size 9.31GB used 8.35GB path /dev/sdg6
         devid    3 size 9.31GB used 8.34GB path /dev/sdc6

Label: none  uuid: b142f575-df1c-4a57-8846-a43b979e2e09
         Total devices 8 FS bytes used 1.79TB
         devid    4 size 149.05GB used 7.00GB path /dev/sdh
         devid    6 size 920.34GB used 495.00GB path /dev/sdg7
         devid    8 size 1.36TB used 1.21TB path /dev/sdf
         devid    2 size 465.76GB used 303.00GB path /dev/sde
         devid    3 size 149.05GB used 6.00GB path /dev/sdd
         devid    5 size 920.34GB used 745.03GB path /dev/sdc7
         devid    9 size 465.76GB used 303.00GB path /dev/sdb
         devid    7 size 1.36TB used 1.21TB path /dev/sda

Btrfs v0.20-rc1-253-g7854c8b

Tried to fix up /dev/sdh...

cartman {~} root# btrfs device delete /dev/sdh /storage

btrfs: bdev /dev/sda errs: wr 0, rd 0, flush 0, corrupt 4733368, gen 0
btrfs: relocating block group 4787944816640 flags 17
btrfs: free space inode generation (0) did not match free space cache 
generation (19517)
btrfs: free space inode generation (0) did not match free space cache 
generation (19519)
btrfs: free space inode generation (0) did not match free space cache 
generation (19519)
btrfs: free space inode generation (0) did not match free space cache 
generation (8540)
btrfs: free space inode generation (0) did not match free space cache 
generation (9080)
btrfs: free space inode generation (0) did not match free space cache 
generation (9143)
btrfs: free space inode generation (0) did not match free space cache 
generation (28604)
btrfs: free space inode generation (0) did not match free space cache 
generation (28604)
btrfs: free space inode generation (0) did not match free space cache 
generation (30096)
btrfs: free space inode generation (0) did not match free space cache 
generation (28551)
btrfs: free space inode generation (0) did not match free space cache 
generation (30191)
btrfs: free space inode generation (0) did not match free space cache 
generation (28613)
btrfs: free space inode generation (0) did not match free space cache 
generation (30191)
btrfs: free space inode generation (0) did not match free space cache 
generation (30191)
btrfs: free space inode generation (0) did not match free space cache 
generation (19382)
btrfs: free space inode generation (0) did not match free space cache 
generation (28867)
btrfs: free space inode generation (0) did not match free space cache 
generation (28623)
btrfs: free space inode generation (0) did not match free space cache 
generation (28623)
btrfs: free space inode generation (0) did not match free space cache 
generation (19382)
btrfs: free space inode generation (0) did not match free space cache 
generation (19387)
btrfs: free space inode generation (0) did not match free space cache 
generation (19387)
btrfs: free space inode generation (0) did not match free space cache 
generation (19387)
btrfs: free space inode generation (0) did not match free space cache 
generation (19387)
btrfs: free space inode generation (0) did not match free space cache 
generation (19387)
Jun 10 05:20:21 localhost kernel: btrfs: found 31 extents
Jun 10 05:20:30 localhost kernel: btrfs: found 31 extents
Jun 10 05:20:30 localhost kernel: btrfs: relocating block group 
4784723591168 flags 17
Jun 10 05:21:00 localhost kernel: btrfs: found 33 extents
Jun 10 05:21:11 localhost kernel: btrfs: found 33 extents
Jun 10 05:21:11 localhost kernel: btrfs: relocating block group 
4781502365696 flags 17
Jun 10 05:21:40 localhost kernel: btrfs: found 29 extents
Jun 10 05:21:49 localhost kernel: btrfs: found 29 extents
Jun 10 05:21:49 localhost kernel: btrfs: relocating block group 
4778281140224 flags 17
Jun 10 05:22:19 localhost kernel: btrfs: found 65 extents
Jun 10 05:22:32 localhost kernel: btrfs: found 65 extents
Jun 10 05:22:33 localhost kernel: btrfs: relocating block group 
4775059914752 flags 17
Jun 10 05:23:04 localhost kernel: btrfs: found 20 extents
Jun 10 05:23:11 localhost kernel: btrfs: found 20 extents
Jun 10 05:23:13 localhost kernel: btrfs: relocating block group 
4771838689280 flags 17
Jun 10 05:23:41 localhost kernel: btrfs: found 27 extents
Jun 10 05:23:48 localhost kernel: btrfs: found 27 extents
Jun 10 05:23:49 localhost kernel: btrfs: relocating block group 
4768617463808 flags 17
Jun 10 05:24:17 localhost kernel: btrfs: found 14 extents
Jun 10 05:24:24 localhost kernel: btrfs: found 14 extents
Jun 10 05:24:57 localhost kernel: BUG: unable to handle kernel NULL 
pointer dereference at 0000000000000090
Jun 10 05:24:57 localhost kernel: IP: [<ffffffff81131ef0>] 
bio_phys_segments+0x20/0x20
Jun 10 05:24:57 localhost kernel: PGD 74285067 PUD 73ca5067 PMD 0
Jun 10 05:24:57 localhost kernel: Oops: 0000 [#1] PREEMPT SMP
Jun 10 05:24:57 localhost kernel: Modules linked in:
Jun 10 05:24:57 localhost kernel: CPU 0
Jun 10 05:24:57 localhost kernel: Pid: 16027, comm: btrfs-transacti Not 
tainted 3.9.0 #1 Gigabyte Technology Co., Ltd. GA-MA74GM-S2/GA-MA74GM-S2
Jun 10 05:24:57 localhost kernel: RIP: 0010:[<ffffffff81131ef0>] 
[<ffffffff81131ef0>] bio_phys_segments+0x20/0x20
Jun 10 05:24:57 localhost kernel: RSP: 0018:ffff8800546c3820  EFLAGS: 
00010246
Jun 10 05:24:57 localhost kernel: RAX: 0000000000000000 RBX: 
ffff8800546c3ab0 RCX: 000000011a262f30
Jun 10 05:24:57 localhost kernel: RDX: 0000000000000100 RSI: 
ffff88004f5b6660 RDI: 0000000000000000
Jun 10 05:24:57 localhost kernel: RBP: 0000000000001000 R08: 
0000000000001000 R09: 0000000000000000
Jun 10 05:24:57 localhost kernel: R10: 0000000000000000 R11: 
0000000000000014 R12: 0000000000000000
Jun 10 05:24:57 localhost kernel: R13: ffff88004f5b6660 R14: 
0000000000000000 R15: 000000011a262f30
Jun 10 05:24:57 localhost kernel: FS:  00007fa95eb7e7a0(0000) 
GS:ffff880077a00000(0000) knlGS:0000000000000000
Jun 10 05:24:57 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Jun 10 05:24:57 localhost kernel: CR2: 0000000000000090 CR3: 
00000000745c5000 CR4: 00000000000007f0
Jun 10 05:24:57 localhost kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Jun 10 05:24:57 localhost kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Jun 10 05:24:57 localhost kernel: Process btrfs-transacti (pid: 16027, 
threadinfo ffff8800546c2000, task ffff8800752dbf20)
Jun 10 05:24:57 localhost kernel: Stack:
Jun 10 05:24:57 localhost kernel: ffffffff8129f64c 0000000000000000 
ffffea000122fcc0 0000000000000000
Jun 10 05:24:57 localhost kernel: 0000000000000000 ffffffff8129f360 
0000000000000411 ffffffff8125efe7
Jun 10 05:24:57 localhost kernel: ffff88004f5b6660 0000000000001000 
0000000000000000 000002344c5e6000
Jun 10 05:24:57 localhost kernel: Call Trace:
Jun 10 05:24:57 localhost kernel: [<ffffffff8129f64c>] ? 
submit_extent_page.isra.47+0x1cc/0x250
Jun 10 05:24:57 localhost kernel: [<ffffffff8129f360>] ? 
end_extent_writepage+0x70/0x70
Jun 10 05:24:57 localhost kernel: [<ffffffff8125efe7>] ? comp_keys+0x27/0x30
Jun 10 05:24:57 localhost kernel: [<ffffffff812a0385>] ? 
__extent_writepage+0x585/0x720
Jun 10 05:24:57 localhost kernel: [<ffffffff8129f360>] ? 
end_extent_writepage+0x70/0x70
Jun 10 05:24:57 localhost kernel: [<ffffffff812a0728>] ? 
extent_write_cache_pages.isra.39.constprop.52+0x208/0x370
Jun 10 05:24:57 localhost kernel: [<ffffffff812a0acb>] ? 
extent_writepages+0x4b/0x70
Jun 10 05:24:57 localhost kernel: [<ffffffff81287b10>] ? 
btrfs_fiemap+0x80/0x80
Jun 10 05:24:57 localhost kernel: [<ffffffff810c8a69>] ? 
__filemap_fdatawrite_range+0x49/0x50
Jun 10 05:24:57 localhost kernel: [<ffffffff8129b47f>] ? 
btrfs_wait_ordered_range+0x3f/0x100
Jun 10 05:24:57 localhost kernel: [<ffffffff812c0592>] ? 
__btrfs_write_out_cache+0x7b2/0x9d0
Jun 10 05:24:57 localhost kernel: [<ffffffff8127d90d>] ? 
btrfs_buffer_uptodate+0x6d/0x80
Jun 10 05:24:57 localhost kernel: [<ffffffff812c0847>] ? 
btrfs_write_out_cache+0x97/0xf0
Jun 10 05:24:57 localhost kernel: [<ffffffff812a1f20>] ? 
set_extent_buffer_dirty+0x60/0xa0
Jun 10 05:24:57 localhost kernel: [<ffffffff812730ca>] ? 
btrfs_write_dirty_block_groups+0x54a/0x640
Jun 10 05:24:57 localhost kernel: [<ffffffff812e5ffe>] ? 
btrfs_run_dev_replace+0x5e/0x350
Jun 10 05:24:57 localhost kernel: [<ffffffff8128108a>] ? 
commit_cowonly_roots+0x18a/0x280
Jun 10 05:24:57 localhost kernel: [<ffffffff81282dbd>] ? 
btrfs_commit_transaction+0x49d/0x9d0
Jun 10 05:24:57 localhost kernel: [<ffffffff8107dd70>] ? 
abort_exclusive_wait+0xb0/0xb0
Jun 10 05:24:57 localhost kernel: [<ffffffff8128397b>] ? 
start_transaction+0x9b/0x430
Jun 10 05:24:57 localhost kernel: [<ffffffff8127aac5>] ? 
transaction_kthread+0x195/0x210
Jun 10 05:24:57 localhost kernel: [<ffffffff8127a930>] ? 
btrfs_alloc_root+0x30/0x30
Jun 10 05:24:57 localhost kernel: [<ffffffff8107d423>] ? kthread+0xb3/0xc0
Jun 10 05:24:57 localhost kernel: [<ffffffff81080000>] ? 
hrtimer_forward+0xa0/0xc0
Jun 10 05:24:57 localhost kernel: [<ffffffff8107d370>] ? 
kthread_freezable_should_stop+0x60/0x60
Jun 10 05:24:57 localhost kernel: [<ffffffff81769cac>] ? 
ret_from_fork+0x7c/0xb0
Jun 10 05:24:57 localhost kernel: [<ffffffff8107d370>] ? 
kthread_freezable_should_stop+0x60/0x60
Jun 10 05:24:57 localhost kernel: Code: 31 c0 e8 f5 ea 62 00 eb ae 90 90 
f6 46 18 08 53 48 89 f3 74 05 8b 43 2c 5b c3 e8 1c f2 1d 00 eb f4 66 2e 
0f 1f 84 00 00                    00 00 00 <48> 8b 87 90 00 00 00 b9 00 
01 00 00 48 8b 90 60 02 00 00 0f b7
Jun 10 05:24:57 localhost kernel: RIP  [<ffffffff81131ef0>] 
bio_phys_segments+0x20/0x20
Jun 10 05:24:57 localhost kernel: RSP <ffff8800546c3820>
Jun 10 05:24:57 localhost kernel: CR2: 0000000000000090
Jun 10 05:24:57 localhost kernel: ---[ end trace 22bc28adecc95827 ]---

