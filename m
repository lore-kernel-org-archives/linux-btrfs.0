From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] btrfs: fix write_dev_supers
Date: Tue, 09 Jun 2009 10:46:55 +0900
Message-ID: <6.0.0.20.2.20090608181508.05e4b708@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I got following BUG trace.
This is violation of BUG_ON(!buffer_locked(bh)) check on submit_bh() function.
In write_dev_supers(), if wait parameter is set and buffer_uptodate() check
is negative,  submit_bh() is executed and hit above BUG_ON.
So I fixed this issue.
Thanks.


Jun  9 00:41:32 dl580 kernel: ------------[ cut here ]------------
Jun  9 00:41:32 dl580 kernel: kernel BUG at fs/buffer.c:2933!
Jun  9 00:41:32 dl580 kernel: invalid opcode: 0000 [#1] SMP
Jun  9 00:41:32 dl580 kernel: last sysfs file: /sys/devices/system/cpu/cpu7/cache/index1/sha
red_cpu_map
Jun  9 00:41:32 dl580 kernel: CPU 3
Jun  9 00:41:32 dl580 kernel: Modules linked in: btrfs zlib_deflate ext4 jbd2 crc16 sg qla2x
xx scsi_transport_fc autofs4 i2c_dev i2c_core sunrpc ipv6 serio_raw
tg3 libphy ata_piix libata shpchp rtc_cmos rtc_core rtc_lib cciss sd_mod scsi_mod ext3 jbd [
last unloaded: scsi_transport_fc]
Jun  9 00:41:32 dl580 kernel: Pid: 5207, comm: umount Tainted: G        W  2.6.30-rc6 #1 Pro
Liant DL580 G3
Jun  9 00:41:32 dl580 kernel: RIP: 0010:[<ffffffff802c458b>]  [<ffffffff802c458b>] submit_bh
+0x1a/0x105
Jun  9 00:41:32 dl580 kernel: RSP: 0018:ffff8801f46e5bf8  EFLAGS: 00010246
Jun  9 00:41:32 dl580 kernel: RAX: 0000000000000028 RBX: ffff88018a7ea420 RCX: 0000000000000
000
Jun  9 00:41:32 dl580 kernel: RDX: ffff88018a7ea420 RSI: ffff88018a7ea420 RDI: 0000000000000
419
Jun  9 00:41:32 dl580 kernel: RBP: ffff8801f46e5c18 R08: ffffffff802c533d R09: 0000000000000
000
Jun  9 00:41:32 dl580 kernel: R10: 0000000000000001 R11: 0000000000000088 R12: ffff88021d448
248
Jun  9 00:41:32 dl580 kernel: R13: 0000000000000419 R14: ffff8802191dacbb R15: 0000000000000
000
Jun  9 00:41:32 dl580 kernel: FS:  00007fd64fef3760(0000) GS:ffff880028150000(0000) knlGS:00
00000000000000
Jun  9 00:41:32 dl580 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun  9 00:41:32 dl580 kernel: CR2: 000000000044ef40 CR3: 0000000104287000 CR4: 0000000000000
6e0
Jun  9 00:41:32 dl580 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000
000
Jun  9 00:41:32 dl580 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000
400
Jun  9 00:41:32 dl580 kernel: Process umount (pid: 5207, threadinfo ffff8801f46e4000, task f
fff8801e1168000)
Jun  9 00:41:32 dl580 kernel: Stack:
Jun  9 00:41:32 dl580 kernel:  0000000000000003 ffff88018a7ea420 ffff88021d448248 0000000000
000003
Jun  9 00:41:32 dl580 kernel:  ffff8801f46e5c68 ffffffffa02d9979 0000000000000000 0000000100
000001
Jun  9 00:41:32 dl580 kernel:  0000000100000000 ffff88021d448248 0000000000000000 ffff880219
1dacbb
Jun  9 00:41:32 dl580 kernel: Call Trace:
Jun  9 00:41:33 dl580 kernel:  [<ffffffffa02d9979>] write_dev_supers+0x1eb/0x258 [btrfs]
Jun  9 00:41:33 dl580 kernel:  [<ffffffffa02d9b6d>] write_all_supers+0x187/0x1c8 [btrfs]
Jun  9 00:41:33 dl580 kernel:  [<ffffffffa02d9bbc>] write_ctree_super+0xe/0x10 [btrfs]
Jun  9 00:41:33 dl580 kernel:  [<ffffffffa02de39f>] btrfs_commit_transaction+0x6bb/0x841 [bt
rfs]
Jun  9 00:41:33 dl580 kernel:  [<ffffffff80246914>] ? autoremove_wake_function+0x0/0x38
Jun  9 00:41:33 dl580 kernel:  [<ffffffffa02c14ed>] btrfs_sync_fs+0x67/0x72 [btrfs]
Jun  9 00:41:33 dl580 kernel:  [<ffffffff802e6e3a>] quota_sync_sb+0x42/0xf3
Jun  9 00:41:33 dl580 kernel:  [<ffffffff802e6f14>] sync_dquots+0x29/0x138
Jun  9 00:41:33 dl580 kernel:  [<ffffffff802a8c29>] __fsync_super+0x1e/0x7b
Jun  9 00:41:33 dl580 kernel:  [<ffffffff802a8c97>] fsync_super+0x11/0x22
Jun  9 00:41:33 dl580 kernel:  [<ffffffff802a8ea9>] generic_shutdown_super+0x26/0xe2
Jun  9 00:41:33 dl580 kernel:  [<ffffffff802a8fb6>] kill_anon_super+0x17/0x3b
Jun  9 00:41:33 dl580 kernel:  [<ffffffff802a92e8>] deactivate_super+0x62/0x77
Jun  9 00:41:33 dl580 kernel:  [<ffffffff802bb7ae>] mntput_no_expire+0xec/0x12c
Jun  9 00:41:33 dl580 kernel:  [<ffffffff802bbcff>] sys_umount+0x2c5/0x31c
Jun  9 00:41:33 dl580 kernel:  [<ffffffff8020aeeb>] system_call_fastpath+0x16/0x
Jun  9 00:41:33 dl580 kernel: Code: e0 eb ec 44 89 e8 48 83 c4 18 5b 41 5c 41 5d 5d c3 55 48
 89 e5 41 55 41 54 53 48 83 ec 08 41 89 fd 48 89 f3 48 8b 06 a8 04 75 04 <0f> 0b eb fe a8 20
 75 04 0f 0b eb fe 48 83 7e 38 00 75 04 0f 0b
Jun  9 00:41:33 dl580 kernel: RIP  [<ffffffff802c458b>] submit_bh+0x1a/0x105
Jun  9 00:41:33 dl580 kernel:  RSP <ffff8801f46e5bf8>
Jun  9 00:41:33 dl580 kernel: ---[ end trace 4eaa2a86a8e2da24 ]--- 



Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

--- linux-2.6.30-rc8.org/fs/btrfs/disk-io.c	2009-06-04 16:26:25.000000000 +0900
+++ linux-2.6.30-rc8.btrfs/fs/btrfs/disk-io.c	2009-06-08 18:42:46.000000000 +0900
@@ -2045,6 +2045,9 @@ static int write_dev_supers(struct btrfs
 			if (buffer_uptodate(bh)) {
 				brelse(bh);
 				continue;
+			} else {
+				get_bh(bh);
+				lock_buffer(bh);
 			}
 		} else {
 			btrfs_set_super_bytenr(sb, bytenr);

