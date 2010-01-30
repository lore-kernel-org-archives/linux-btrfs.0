From: Troy Ablan <tablan@gmail.com>
Subject: panic during rebalance, and now upon mount
Date: Fri, 29 Jan 2010 23:05:45 -0700
Message-ID: <4B63CC39.1020505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

During a very lengthy btrfs-vol -b (3.5 days in), btrfs BUGged out. 
Upon rebooting and trying to mount that fs, the exact same bug (with the
exact same call trace) happens.  I moved up to 2.6.33-rc6 from
gentoo-maintained 2.6.32-r2 to see what would happen, and it appears to
panic at the equivalent line of the same source file as before.

Let me know if I can do anything to assist.  I won't do anything to the
disks for the next few days in case some forensics will be useful.

[  154.899692] device label bk0 devid 14 transid 111134 /dev/mapper/btrn
[  154.958264] btrfs: use compression
[  202.394048] ------------[ cut here ]------------
[  202.394136] kernel BUG at fs/btrfs/extent-tree.c:5377!
[  202.394220] invalid opcode: 0000 [#1] SMP
[  202.394372] last sysfs file:
/sys/devices/virtual/block/md1/md/metadata_version
[  202.394500] CPU 5
[  202.394655] Pid: 5838, comm: btrfs-relocate- Tainted: G        W 
2.6.33-rc6 #1 P55M-GD45 (MS-7588) /MS-7588
[  202.394787] RIP: 0010:[<ffffffff8129e5ad>]  [<ffffffff8129e5ad>]
walk_up_proc+0x37d/0x3c0
[  202.394955] RSP: 0018:ffff880139729ca0  EFLAGS: 00010282
[  202.395039] RAX: 0000000000000218 RBX: ffff88013c460300 RCX:
ffff880139728000
[  202.395127] RDX: ffff880000000000 RSI: fffffffffffffff8 RDI:
ffff880138ac08e0
[  202.395214] RBP: ffff880139729d00 R08: 0000000000000008 R09:
0000000000000001
[  202.395301] R10: 0000000000000001 R11: 0000000000000001 R12:
ffff880138ab8880
[  202.395389] R13: 0000000000000000 R14: ffff88013f72f880 R15:
ffff88013b646800
[  202.395476] FS:  0000000000000000(0000) GS:ffff880028340000(0000)
knlGS:0000000000000000
[  202.395606] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  202.395691] CR2: 0000000000425f40 CR3: 00000000018d3000 CR4:
00000000000006e0
[  202.395778] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  202.395865] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  202.395953] Process btrfs-relocate- (pid: 5838, threadinfo
ffff880139728000, task ffff88013f0e28f0)
[  202.396083] Stack:
[  202.396162]  ffff880139729cf0 0000000000000002 ffff88013f72f880
0000000000000206
[  202.397142] <0> ffff880139729d30 ffff880138ac08e0 0000000000000000
0000000000000000
[  202.397444] <0> ffff88013c460300 ffff88013f72f880 0000000000000000
ffff880139728000
[  202.397856] Call Trace:
[  202.397937]  [<ffffffff8129e72f>] walk_up_tree+0x13f/0x1c0
[  202.398023]  [<ffffffff8129f99c>] btrfs_drop_snapshot+0x21c/0x600
[  202.398110]  [<ffffffff812a9dd0>] ? __btrfs_end_transaction+0x100/0x170
[  202.398198]  [<ffffffff812e7d7d>] merge_func+0x7d/0xc0
[  202.398284]  [<ffffffff812d25aa>] worker_loop+0x17a/0x540
[  202.398379]  [<ffffffff812d2430>] ? worker_loop+0x0/0x540
[  202.398487]  [<ffffffff812d2430>] ? worker_loop+0x0/0x540
[  202.398611]  [<ffffffff81095936>] kthread+0x96/0xa0
[  202.398697]  [<ffffffff81034bd4>] kernel_thread_helper+0x4/0x10
[  202.398784]  [<ffffffff816ac869>] ? restore_args+0x0/0x30
[  202.398869]  [<ffffffff810958a0>] ? kthread+0x0/0xa0
[  202.398953]  [<ffffffff81034bd0>] ? kernel_thread_helper+0x0/0x10
[  202.399039] Code: 6d db b6 6d 48 c1 f8 03 48 0f af c2 48 ba 00 00 00
00 00 88 ff ff 48 c1 e0 0c 48 8b 44 10 58 ff 49 1c 48 39 c6 0f 84 ab fd
ff ff <0f> 0b eb fe 0f 1f 80 00 00 00 00 47 8b 4c ae 60 45 85 c9 0f 85
[  202.401551] RIP  [<ffffffff8129e5ad>] walk_up_proc+0x37d/0x3c0
[  202.401671]  RSP <ffff880139729ca0>
[  202.401796] ---[ end trace 4c085bcc2bd215f6 ]---

-- 
Troy

