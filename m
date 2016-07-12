Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35398 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055AbcGLMUZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 08:20:25 -0400
Received: by mail-wm0-f45.google.com with SMTP id f65so98327670wmi.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2016 05:20:23 -0700 (PDT)
From: Nikolay Borisov <kernel@kyup.com>
To: jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, operations@siteground.com,
        Nikolay Borisov <kernel@kyup.com>
Subject: [PATCH] btrfs: Add ratelimiting to printing facility
Date: Tue, 12 Jul 2016 15:20:12 +0300
Message-Id: <1468326012-15910-1-git-send-email-kernel@kyup.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently the btrfs printk infrastructure doesn't implement any
kind of ratelimiting. Recently I came accross a case where due to
FS corruption an excessive amount of printk caused the softlockup
detector to trigger and reset the server. This patch aims to avoid
two types of issue: 
 * I want to avoid different levels of messages interefere with the
 ratelimiting of oneanother so as to avoid a situation where a 
 flood of INFO messages causes the ratelimit to trigger, 
 potentially leading to supression of more important messages. 

 * Avoid a flood of any type of messages rendering the machine 
 unusable

---
So recently I got the softlockup to trigger due to excessive btrfs 
printing: 

[3211212.563757] NMI watchdog: BUG: soft lockup - CPU#5 stuck for 22s! [btrfs-transacti:6033]
[3211212.563782] Modules linked in: [omitted]
[3211212.563783] BTRFS info (device loop1): no csum found for inode 450 start 2746998784
[3211212.563785] CPU: 5 PID: 6033 Comm: btrfs-transacti Tainted: P W O 4.4.9-clouder1 #20
[3211212.563786] Hardware name: Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DRD-7LN4F, BIOS 3.0a 12/05/2013
[3211212.563787] task: ffff88046d0d8000 ti: ffff8802bcaa8000 task.ti: ffff8802bcaa8000
[3211212.563792] RIP: 0010:[<ffffffff810a1475>] [<ffffffff810a1475>] console_unlock+0x305/0x4b0
[3211212.563793] RSP: 0018:ffff8802bcaab7b8 EFLAGS: 00000282
[3211212.563794] RAX: 0000000000000000 RBX: ffffffff82027e18 RCX: 0000000000000000
[3211212.563795] RDX: ffff8802bcaab6d8 RSI: 0000000000000004 RDI: ffffffff8204f0c8
[3211212.563795] RBP: ffff8802bcaab7f8 R08: 0000000000000000 R09: ffff8800000b8460
[3211212.563796] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000020
[3211212.563797] R13: 0000000000000282 R14: 0000000000000048 R15: 0000000000000001
[3211212.563798] FS: 0000000000000000(0000) GS:ffff88047fca0000(0000) knlGS:0000000000000000
[3211212.563799] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[3211212.563799] CR2: ffffffffff600400 CR3: 000000046afd6000 CR4: 00000000001406e0
[3211212.563800] Stack:
[3211212.563802] 0000000000000000 06ffffff00000000 ffff8802bcaab7e8 00000000ffffffff
[3211212.563804] 0000000000000006 0000000000000000 0000000000000024 0000000000000246
[3211212.563805] ffff8802bcaab878 ffffffff810a1f00 ffffffff81e341a2 ffffffff00000024
[3211212.563806] Call Trace:
[3211212.563809] [<ffffffff810a1f00>] vprintk_emit+0x230/0x490
[3211212.563836] [<ffffffffa07a655d>] ? __btrfs_free_extent+0x24d/0xd80 [btrfs]
[3211212.563838] [<ffffffff810a217f>] vprintk_default+0x1f/0x30
[3211212.563841] [<ffffffff8112d753>] printk+0x46/0x48
[3211212.563853] [<ffffffffa07a655d>] ? __btrfs_free_extent+0x24d/0xd80 [btrfs]
[3211212.563857] [<ffffffff810549d3>] warn_slowpath_common+0x43/0xe0
[3211212.563859] [<ffffffff81054b26>] warn_slowpath_fmt+0x46/0x50
[3211212.563870] [<ffffffffa07a655d>] __btrfs_free_extent+0x24d/0xd80 [btrfs]
[3211212.563874] [<ffffffff81185024>] ? kmem_cache_free+0x214/0x230
[3211212.563890] [<ffffffffa080e730>] ? btrfs_delayed_ref_lock+0x40/0x1f0 [btrfs]
[3211212.563902] [<ffffffffa07a7f2e>] __btrfs_run_delayed_refs+0xe9e/0x12f0 [btrfs]
[3211212.563904] [<ffffffff81185024>] ? kmem_cache_free+0x214/0x230
[3211212.563908] [<ffffffff8107c584>] ? finish_task_switch+0xa4/0x240
[3211212.563911] [<ffffffff8108d026>] ? put_prev_task_fair+0x26/0x40
[3211212.563913] [<ffffffff8163e694>] ? __schedule+0x394/0xac0
[3211212.563917] [<ffffffff8103bcce>] ? physflat_send_IPI_mask+0xe/0x10
[3211212.563928] [<ffffffffa07a840e>] btrfs_run_delayed_refs+0x8e/0x2e0 [btrfs]
[3211212.563930] [<ffffffff8107adb2>] ? __might_sleep+0x52/0x90
[3211212.563932] [<ffffffff8118713b>] ? kmem_cache_alloc+0x11b/0x200
[3211212.563947] [<ffffffffa07bcd51>] btrfs_commit_transaction+0x51/0xb70 [btrfs]
[3211212.563960] [<ffffffffa07bdccd>] ? start_transaction+0x9d/0x4e0 [btrfs]
[3211212.563963] [<ffffffff810b2320>] ? lock_timer_base+0x80/0x80
[3211212.563965] [<ffffffff8107adb2>] ? __might_sleep+0x52/0x90
[3211212.563978] [<ffffffffa07b7063>] transaction_kthread+0x233/0x280 [btrfs]
[3211212.563991] [<ffffffffa07b6e30>] ? close_ctree+0x370/0x370 [btrfs]
[3211212.564002] [<ffffffffa07b6e30>] ? close_ctree+0x370/0x370 [btrfs]
[3211212.564004] [<ffffffff81074557>] kthread+0xd7/0xf0
[3211212.564007] [<ffffffff8107d51e>] ? schedule_tail+0x1e/0xd0
[3211212.564009] [<ffffffff81074480>] ? kthread_freezable_should_stop+0x80/0x80
[3211212.564011] [<ffffffff8164322f>] ret_from_fork+0x3f/0x70
[3211212.564013] [<ffffffff81074480>] ? kthread_freezable_should_stop+0x80/0x80
[3211212.564030] Code: 89 15 b8 32 d9 00 48 8b 05 89 32 d9 00 c7 05 ab 32 d9 00 00 00 00 00 48 89 05 98 32 d9 00 e9 d1

The message was: 

[3211212.563115] BTRFS info (device loop1): no csum found for inode 450 start 2746953728
[3211212.563173] BTRFS info (device loop1): no csum found for inode 450 start 2746957824
[3211212.563231] BTRFS info (device loop1): no csum found for inode 450 start 2746961920
[3211212.563289] BTRFS info (device loop1): no csum found for inode 450 start 2746966016
[3211212.563347] BTRFS info (device loop1): no csum found for inode 450 start 2746970112
[3211212.563407] BTRFS info (device loop1): no csum found for inode 450 start 2746974208

 fs/btrfs/super.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fe609b81dd1b..85b0a4517e30 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -188,6 +188,25 @@ static const char * const logtypes[] = {
 	"debug",
 };
 
+static struct ratelimit_state printk_limits[] = {
+	RATELIMIT_STATE_INIT(printk_limits[0], DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST),
+	RATELIMIT_STATE_INIT(printk_limits[1], DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST),
+	RATELIMIT_STATE_INIT(printk_limits[2], DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST),
+	RATELIMIT_STATE_INIT(printk_limits[3], DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST),
+	RATELIMIT_STATE_INIT(printk_limits[4], DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST),
+	RATELIMIT_STATE_INIT(printk_limits[5], DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST),
+	RATELIMIT_STATE_INIT(printk_limits[6], DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST),
+	RATELIMIT_STATE_INIT(printk_limits[7], DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST),
+};
+
 void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
 	struct super_block *sb = fs_info->sb;
@@ -196,6 +215,7 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	va_list args;
 	const char *type = logtypes[4];
 	int kern_level;
+	struct ratelimit_state *ratelimit;
 
 	va_start(args, fmt);
 
@@ -206,13 +226,18 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 		lvl[size] = '\0';
 		fmt += size;
 		type = logtypes[kern_level - '0'];
-	} else
+		ratelimit = &printk_limits[kern_level - '0'];
+	} else {
 		*lvl = '\0';
+		/* Default to debug output */
+		ratelimit = &printk_limits[7];
+	}
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%sBTRFS %s (device %s): %pV\n", lvl, type, sb->s_id, &vaf);
+	if (__ratelimit(ratelimit))
+		printk("%sBTRFS %s (device %s): %pV\n", lvl, type, sb->s_id, &vaf);
 
 	va_end(args);
 }
-- 
2.5.0

