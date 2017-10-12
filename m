Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:30070 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdJLRwQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 13:52:16 -0400
From: Bart Van Assche <Bart.VanAssche@wdc.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: fs_reclaim() deadlock complaint
Date: Thu, 12 Oct 2017 17:52:14 +0000
Message-ID: <1507830733.2448.47.camel@wdc.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Since I started testing kernel v4.14-rc1 I see a deadlock complaint appearing
in the kernel log during boot. Is this a known issue?

$ cat /etc/fstab
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/mapper/vg-root /               btrfs   defaults,subvol=@ 0       1
/dev/mapper/vg-boot /boot           ext4    defaults        0       2
/dev/mapper/vg-root /home           btrfs   defaults,subvol=@home 0       2
UUID=5217d83f-213e-4b42-b86e-20013325ba6c none	swap	sw	0	0

>From the system log:

systemd[1]: Started Session c5 of user root.
kernel: 
kernel: ============================================
kernel: WARNING: possible recursive locking detected
kernel: 4.14.0-rc3-dbg+ #11 Not tainted
kernel: --------------------------------------------
kernel: dpkg/10251 is trying to acquire lock:
kernel: (fs_reclaim){+.+.}, at: [<ffffffffbc1766c0>] fs_reclaim_acquire.part.85+0x0/0x30
kernel: 
kernel: but task is already holding lock:
kernel: (fs_reclaim){+.+.}, at: [<ffffffffbc1766c0>] fs_reclaim_acquire.part.85+0x0/0x30
kernel: 
kernel: other info that might help us debug this:
kernel: Possible unsafe locking scenario:
kernel: 
kernel:       CPU0
kernel:       ----
kernel:  lock(fs_reclaim);
kernel:  lock(fs_reclaim);
kernel: 
kernel: *** DEADLOCK ***
kernel: 
kernel: May be due to missing lock nesting notation
kernel: 
kernel: 2 locks held by dpkg/10251:
kernel: #0:  (&mm->mmap_sem){++++}, at: [<ffffffffbc04c50f>] __do_page_fault+0x11f/0x460
kernel: #1:  (fs_reclaim){+.+.}, at: [<ffffffffbc1766c0>] fs_reclaim_acquire.part.85+0x0/0x30
kernel: 
kernel: stack backtrace:
kernel: CPU: 1 PID: 10251 Comm: dpkg Not tainted 4.14.0-rc3-dbg+ #11
kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
kernel: Call Trace:
kernel: dump_stack+0x86/0xcf
kernel: __lock_acquire+0x720/0x1440
kernel: ? unwind_get_return_address+0x1a/0x30
kernel: ? __bfs+0x12e/0x210
kernel: lock_acquire+0xf5/0x200
kernel: ? lock_acquire+0xf5/0x200
kernel: ? pageset_set_high_and_batch+0x90/0x90
kernel: ? alloc_extent_state+0x1f/0x1a0 [btrfs]
kernel: fs_reclaim_acquire.part.85+0x24/0x30
kernel: ? pageset_set_high_and_batch+0x90/0x90
kernel: fs_reclaim_acquire+0x14/0x20
kernel: kmem_cache_alloc+0x2a/0x2c0
kernel: ? lock_acquire+0xf5/0x200
kernel: alloc_extent_state+0x1f/0x1a0 [btrfs]
kernel: __clear_extent_bit+0x26f/0x3f0 [btrfs]
kernel: ? test_range_bit+0xd1/0x100 [btrfs]
kernel: try_release_extent_mapping+0x192/0x1e0 [btrfs]
kernel: __btrfs_releasepage+0x2f/0x70 [btrfs]
kernel: ? page_get_anon_vma+0x170/0x170
kernel: btrfs_releasepage+0x3c/0x40 [btrfs]
kernel: try_to_release_page+0x4e/0x60
kernel: shrink_page_list+0xbc8/0x1010
kernel: ? trace_hardirqs_on_caller+0xf4/0x190
kernel: shrink_inactive_list+0x1a9/0x520
kernel: shrink_node_memcg.constprop.80+0x4ae/0x750
kernel: ? rcu_read_lock_sched_held+0x45/0x80
kernel: shrink_node+0x45/0x1a0
kernel: ? shrink_node+0x45/0x1a0
kernel: do_try_to_free_pages+0xd1/0x2c0
kernel: try_to_free_pages+0xed/0x330
kernel: ? pageset_set_high_and_batch+0x90/0x90
kernel: __alloc_pages_slowpath+0x454/0x1220
kernel: __alloc_pages_nodemask+0x273/0x300
kernel: mm_get_huge_zero_page+0x7f/0xf0
kernel: do_huge_pmd_anonymous_page+0x301/0x500
kernel: __handle_mm_fault+0xb42/0xd70
kernel: handle_mm_fault+0x8d/0x100
kernel: __do_page_fault+0x23f/0x460
kernel: ? trace_hardirqs_on_caller+0xf4/0x190
kernel: do_page_fault+0x2e/0x280
kernel: do_async_page_fault+0x14/0x60
kernel: async_page_fault+0x22/0x30
kernel: RIP: 0033:0x55704b9c5263
kernel: RSP: 002b:00007ffc8326c4a0 EFLAGS: 00010202
kernel: RAX: 000055704c390f10 RBX: 0000000000000000 RCX: 00007f8ec8985b00
kernel: RDX: 000055704c390f10 RSI: 000055704c390f40 RDI: 0000000000000000
kernel: RBP: 000055704b9d2350 R08: 00007f8ec8987760 R09: 0000000000000040
kernel: R10: 00007f8ec8985b58 R11: 0000000000000202 R12: 000055704b9ab410
kernel: R13: 00007ffc8326c5f0 R14: 0000000000000000 R15: 0000000000000000

Thanks,

Bart.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
