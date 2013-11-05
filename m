Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44331 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3KEBeE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 20:34:04 -0500
Received: by mail-pd0-f182.google.com with SMTP id q10so7522119pdj.27
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 17:34:04 -0800 (PST)
Received: from majianpeng ([218.242.10.182])
        by mx.google.com with ESMTPSA id hz10sm30930089pbc.36.2013.11.04.17.34.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 04 Nov 2013 17:34:03 -0800 (PST)
Date: Tue, 5 Nov 2013 09:34:01 +0800
From: majianpeng <majianpeng@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [BUG]:bad unlock balance detected!
Mime-Version: 1.0
Message-ID: <201311050933582618320@gmail.com>
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On the mainline linux tree, the head of git is :be408cd3e1fef73e9408b196a7.

[ 2372.462131] 
[ 2372.462147] =====================================
[ 2372.462171] [ BUG: bad unlock balance detected! ]
[ 2372.462191] 3.12.0+ #32 Tainted: G        W   
[ 2372.462209] -------------------------------------
[ 2372.462228] ceph-osd/14048 is trying to release lock (sb_internal) at:
[ 2372.462275] [<ffffffffa022cb10>] btrfs_commit_transaction_async+0x1b0/0x2a0 [btrfs]
[ 2372.462305] but there are no more locks to release!
[ 2372.462324] 
[ 2372.462324] other info that might help us debug this:
[ 2372.462349] no locks held by ceph-osd/14048.
[ 2372.462367] 
[ 2372.462367] stack backtrace:
[ 2372.462386] CPU: 2 PID: 14048 Comm: ceph-osd Tainted: G        W    3.12.0+ #32
[ 2372.462414] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080015  11/09/2011
[ 2372.462455]  ffffffffa022cb10 ffff88007490fd28 ffffffff816f094a ffff8800378aa320
[ 2372.462491]  ffff88007490fd50 ffffffff810adf4c ffff8800378aa320 ffff88009af97650
[ 2372.462526]  ffffffffa022cb10 ffff88007490fd88 ffffffff810b01ee ffff8800898c0000
[ 2372.462562] Call Trace:
[ 2372.462584]  [<ffffffffa022cb10>] ? btrfs_commit_transaction_async+0x1b0/0x2a0 [btrfs]
[ 2372.462619]  [<ffffffff816f094a>] dump_stack+0x45/0x56
[ 2372.462642]  [<ffffffff810adf4c>] print_unlock_imbalance_bug+0xec/0x100
[ 2372.462677]  [<ffffffffa022cb10>] ? btrfs_commit_transaction_async+0x1b0/0x2a0 [btrfs]
[ 2372.462710]  [<ffffffff810b01ee>] lock_release+0x18e/0x210
[ 2372.462742]  [<ffffffffa022cb36>] btrfs_commit_transaction_async+0x1d6/0x2a0 [btrfs]
[ 2372.462783]  [<ffffffffa025a7ce>] btrfs_ioctl_start_sync+0x3e/0xc0 [btrfs]
[ 2372.462822]  [<ffffffffa025f1d3>] btrfs_ioctl+0x4c3/0x1f70 [btrfs]
[ 2372.462849]  [<ffffffff812c0321>] ? avc_has_perm+0x121/0x1b0
[ 2372.462873]  [<ffffffff812c0224>] ? avc_has_perm+0x24/0x1b0
[ 2372.462897]  [<ffffffff8107ecc8>] ? sched_clock_cpu+0xa8/0x100
[ 2372.462922]  [<ffffffff8117b145>] do_vfs_ioctl+0x2e5/0x4e0
[ 2372.462946]  [<ffffffff812c19e6>] ? file_has_perm+0x86/0xa0
[ 2372.462969]  [<ffffffff8117b3c1>] SyS_ioctl+0x81/0xa0
[ 2372.462991]  [<ffffffff817045a4>] tracesys+0xdd/0xe2
[ 2709.388375] btrfs: device fsid 983de968-d6a9-4ca9-bd27-2be472d15b9b devid 1 transid 26 /dev/sdb
[ 2709.394532] btrfs: disk space caching is enabled
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
