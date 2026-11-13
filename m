Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794554393;
	b=sr8TvBB2bFwWD/6x8qiMdwJTg/X6lHqIryLt3rnW/FeZlFNWwXUVNM1fWRiFnoCLGDRb
	 VM4R2rzChTo9qtis8ijCZmS//IBQxxSLwxTdPTvLywchjolySx97qH1BqpL0rHt+H2YpV
	 jbYDsaF02aVt4ZGl9t7AtTD+QPlPfJQ0uK0LrKIA4M7N97PbidM2EUA83hpEcQ4BWAh+S
	 hlOaCK34SMLD1X0dMQXpVPWIOFWL+fp+qMwfSFumcBsgLltY3ocAHKwmoBTO9ncg2ZK/J
	 GwzFc9AUR+n9To75mQzNIfJNvgM75uAauGirre7f/5yOsjB49ONZYUGhnrI/asRPS4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794554393;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=NImTOund7I1UAbtUhNpwSFZMAy/nW2gw4woQxmofC1Y=;
	b=tJb2cTLsJVyEDh9OTOhlTifnuVIKcvoLsW+ftTMidUlnEfDjbmdDy/rboV6ZxciJ7YY9
	 GBsPDk4t1IrELZS6lA9qiM+LF/TxSOIi9llZtTHqMx1UhoDa53RO4h/Y+ZLtp8rsWQJbi
	 eutVpA0kPjJl8FeRoVUEPuFClYJBLW1eHl0rfnXSecQ8TlSRIDBWBfz9myW06OX+pKURL
	 V+QGe/qGal+iZaGOcgHAr4hjj9aobKh9mqyqCIuk/3vXv5QShPMbApkk3X/Es+Mg/9oWj
	 IZq/QIyTPINOXxUMJEzlif5RbEVrDY54bGcfenyBjXx2KDQBbUz7NVoAwuWIqi6xhqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8F8606A321
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 07:19:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D8F8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4fb73e868aaso1038990b6e.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 23:19:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794554392; x=1795159192;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NImTOund7I1UAbtUhNpwSFZMAy/nW2gw4woQxmofC1Y=;
        b=FKes/6NeLA27SB+MLksuBfHIHQ8yyzLnjQ7XuiqOpnQJpVtEk2EGxMiI0kzpNQJqqN
         FUTEZoF+ZZJxCTZV1lptJBfcWrFjija7hW6f8/fXPxxO8SB1HN8aeygjirkoX7iCKBF7
         /o3UwSULPlsX//LSD1aUeK4wsnJEoohQjZlX8TSvQumX7F18l6R7wNinb5OqAdVQ3rSb
         I+lcSXNZBmt43HtGSN8CJ4z+b/eLzWEriBVcqJKpcZpyoVF5sFselEGPdA/iHiQw7/ga
         ZxiioPu0C2qEqnL+7aOGydlfipT+Ksk96rU0q9DinInxlg2QeO/6h9N797rv3BJBA0j+
         TnoA==
X-Forwarded-Encrypted: i=1; AL+hErFSELq9WHShRh50ClrDGSsww5jMz+o+u5Pp8ToXeOAkMeYvmRuaGf+sC8sHMA1WiJiSzPZM/qzPeiXf4g==@vger.kernel.org
X-Gm-Message-State: APuU4Z93XaxYEzPpsU7GvUv3mac8UTS62yInn1+2/j5ydG+u2UHDHpaK
	cN46OwOAG79o3rVjGsmzRrHV+bej5IdkGPFi9wlComgUkZlJ26HNoSraE2KILrmaOCrCXbQM+8u
	BG+lCyOQpOTb4a4xyE9g3WdSa+PL0eSFfIBXtfk5yG0xrQl8uwtl5ygB3kUU=
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:13ce:b0:4f5:aa1c:d934 with SMTP id
 5614622812f47-56e64cf7e79mr1513625b6e.38.1794554392407; Thu, 12 Nov 2026
 23:19:52 -0800 (PST)
Date: Thu, 12 Nov 2026 23:19:52 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af6ba18.c3c214cc.692fa.00e5.GAE@google.com>
Subject: [syzbot] [btrfs?] [ntfs3?] memory leak in __pcs_replace_empty_main
From: syzbot <syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com>
To: almaz.alexandrovich@paragon-software.com, dsterba@suse.com, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ntfs3@lists.linux.dev, radu@rendec.net, syzkaller-bugs@googlegroups.com, 
	tglx@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8a65162514fb Merge tag 'driver-core-7.4-rc2' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=149c9409580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4361b1bb937ae1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=527fed49e5b988882c9a
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129c9409580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4cd10f0ff0b1/disk-8a651625.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/055634bde6e5/vmlinux-8a651625.xz
kernel image: https://storage.googleapis.com/syzbot-assets/523697a102d6/bzImage-8a651625.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/6cf790da15a7/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=17c154d9580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/9fee673d5c4a/mount_11.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1161e7a5580000)
mounted in repro #3: https://storage.googleapis.com/syzbot-assets/5f1986de5655/mount_13.gz

AI-generated root cause summary:
In SLUB's per-CPU sheaves (PCS) implementation (mm/slub.c), struct slab_sheaf
objects allocated via __alloc_empty_sheaf() are tracked as standard heap
allocations by kmemleak. When an rcu_free sheaf reaches capacity in
__kfree_rcu_sheaf(), it is detached from pcs->rcu_free and queued for deferred
cleanup via call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf). While queued, the
only pointer to the sheaf exists in RCU's segmented callback list
(rcu_data.cblist); if any earlier callback in the singly-linked list resides in
memory untracked or unscanned by kmemleak (such as struct slab allocated in
struct page, SLAB_NOLEAKTRACE objects, or already-freed objects), kmemleak
cannot traverse the chain. Because recycled sheaves retain their early-boot
allocation timestamps, kmemleak exceeds its scan age threshold and falsely
reports these in-flight sheaves as unreferenced memory leaks.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=527fed49e5b988882c9a

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88810005f600 (size 512):
  comm "swapper/0", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 79 f0 2b 81 88 ff ff 20 00 b4 81 ff ff ff ff  .y.+.... .......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 9e0404a6):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    __do_kmalloc_node mm/slub.c:5530 [inline]
    __kmalloc_flags_noprof+0x42c/0x570 mm/slub.c:5719
    _kmalloc_flags_noprof mm/slab.h:55 [inline]
    __alloc_empty_sheaf mm/slub.c:2854 [inline]
    alloc_empty_sheaf mm/slub.c:2874 [inline]
    __pcs_replace_empty_main+0x260/0x2e0 mm/slub.c:4806
    alloc_from_pcs mm/slub.c:4887 [inline]
    slab_alloc_node mm/slub.c:5021 [inline]
    __kmalloc_cache_noprof+0x370/0x3f0 mm/slub.c:5676
    _kmalloc_noprof include/linux/slab.h:991 [inline]
    _kzalloc_noprof include/linux/slab.h:1312 [inline]
    __irq_domain_alloc_fwnode+0x37/0x160 kernel/irq/irqdomain.c:97
    irq_domain_alloc_named_fwnode include/linux/irqdomain.h:271 [inline]
    arch_early_irq_init+0x1c/0x70 arch/x86/kernel/apic/vector.c:803
    start_kernel+0x9c5/0xc10 init/main.c:1150
    x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
    x86_64_start_kernel+0xce/0xd0 arch/x86/kernel/head64.c:291
    common_startup_64+0x13e/0x158

BUG: memory leak
unreferenced object 0xffff8881009c5000 (size 512):
  comm "kthreadd", pid 2, jiffies 4294937342
  hex dump (first 32 bytes):
    a0 5c 9b 2a 81 88 ff ff 20 00 b4 81 ff ff ff ff  .\.*.... .......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 3e15a3c6):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    __do_kmalloc_node mm/slub.c:5530 [inline]
    __kmalloc_flags_noprof+0x42c/0x570 mm/slub.c:5719
    _kmalloc_flags_noprof mm/slab.h:55 [inline]
    __alloc_empty_sheaf mm/slub.c:2854 [inline]
    alloc_empty_sheaf mm/slub.c:2874 [inline]
    __pcs_replace_empty_main+0x260/0x2e0 mm/slub.c:4806
    alloc_from_pcs mm/slub.c:4887 [inline]
    slab_alloc_node mm/slub.c:5021 [inline]
    __kmalloc_cache_node_noprof+0x381/0x410 mm/slub.c:5695
    _kmalloc_node_noprof include/linux/slab.h:1196 [inline]
    __get_vm_area_node+0xe9/0x1f0 mm/vmalloc.c:3270
    __vmalloc_node_range_noprof+0x1e1/0xd90 mm/vmalloc.c:4112
    __vmalloc_node_noprof+0x71/0x90 mm/vmalloc.c:4213
    alloc_thread_stack_node kernel/fork.c:359 [inline]
    dup_task_struct kernel/fork.c:931 [inline]
    copy_process+0x527/0x3060 kernel/fork.c:2150
    kernel_clone+0x101/0x710 kernel/fork.c:2798
    kernel_thread+0x80/0xb0 kernel/fork.c:2859
    create_kthread kernel/kthread.c:459 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:817
    ret_from_fork+0x219/0x490 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888102d99800 (size 512):
  comm "kworker/u8:3", pid 235, jiffies 4294937447
  hex dump (first 32 bytes):
    f0 6b 9d 2a 81 88 ff ff 20 00 b4 81 ff ff ff ff  .k.*.... .......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 282505aa):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    __do_kmalloc_node mm/slub.c:5530 [inline]
    __kmalloc_flags_noprof+0x42c/0x570 mm/slub.c:5719
    _kmalloc_flags_noprof mm/slab.h:55 [inline]
    __alloc_empty_sheaf mm/slub.c:2854 [inline]
    alloc_empty_sheaf mm/slub.c:2874 [inline]
    __pcs_replace_full_main+0xf7/0x330 mm/slub.c:6094
    free_to_pcs mm/slub.c:6147 [inline]
    slab_free mm/slub.c:6633 [inline]
    kfree+0x353/0x390 mm/slub.c:6923
    call_usermodehelper_freeinfo kernel/umh.c:43 [inline]
    umh_complete kernel/umh.c:57 [inline]
    call_usermodehelper_exec_async+0x1c7/0x1f0 kernel/umh.c:117
    ret_from_fork+0x219/0x490 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888101943a00 (size 512):
  comm "kdevtmpfs", pid 27, jiffies 4294937449
  hex dump (first 32 bytes):
    b0 c3 b7 0b 81 88 ff ff 20 00 b4 81 ff ff ff ff  ........ .......
    00 4a 04 00 81 88 ff ff 20 00 00 00 00 00 00 00  .J...... .......
  backtrace (crc 6be06b44):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    __do_kmalloc_node mm/slub.c:5530 [inline]
    __kmalloc_flags_noprof+0x42c/0x570 mm/slub.c:5719
    _kmalloc_flags_noprof mm/slab.h:55 [inline]
    __alloc_empty_sheaf mm/slub.c:2854 [inline]
    alloc_empty_sheaf mm/slub.c:2874 [inline]
    __kfree_rcu_sheaf+0x1aa/0x2d0 mm/slub.c:6282
    kfree_rcu_sheaf mm/slab_common.c:1689 [inline]
    kvfree_call_rcu+0x1ef/0x3a0 mm/slab_common.c:2044
    ma_free_rcu lib/maple_tree.c:173 [inline]
    ma_free_rcu+0x29/0x40 lib/maple_tree.c:170
    mas_topiary_node lib/maple_tree.c:1829 [inline]
    mas_topiary_node lib/maple_tree.c:1817 [inline]
    mas_topiary_replace+0xc49/0x1560 lib/maple_tree.c:1928
    mas_wmb_replace+0x3c/0x630 lib/maple_tree.c:2114
    mas_wr_split+0xcda/0x1650 lib/maple_tree.c:3502
    mas_wr_store_entry+0x520/0xf60 lib/maple_tree.c:3575
    mas_insert lib/maple_tree.c:3819 [inline]
    mas_alloc_cyclic+0x481/0xa30 lib/maple_tree.c:3862
    mtree_alloc_cyclic+0xc7/0x140 lib/maple_tree.c:5975
    simple_offset_add+0x5c/0xd0 fs/libfs.c:296
    shmem_mknod+0x1df/0x260 mm/shmem.c:4092
    vfs_mknod+0x229/0x460 fs/namei.c:5287
    handle_create drivers/base/devtmpfs.c:283 [inline]
    handle drivers/base/devtmpfs.c:435 [inline]
    devtmpfs_work_loop+0x292/0x64b drivers/base/devtmpfs.c:450
    devtmpfsd+0x3a/0x50 drivers/base/devtmpfs.c:492
    kthread+0x150/0x1a0 kernel/kthread.c:436

BUG: memory leak
unreferenced object 0xffff888102d98200 (size 512):
  comm "kworker/0:1", pid 11, jiffies 4294937453
  hex dump (first 32 bytes):
    f0 6b 99 2a 81 88 ff ff 20 00 b4 81 ff ff ff ff  .k.*.... .......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 946da91f):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    __do_kmalloc_node mm/slub.c:5530 [inline]
    __kmalloc_flags_noprof+0x42c/0x570 mm/slub.c:5719
    _kmalloc_flags_noprof mm/slab.h:55 [inline]
    __alloc_empty_sheaf mm/slub.c:2854 [inline]
    alloc_empty_sheaf mm/slub.c:2874 [inline]
    __pcs_replace_full_main+0xf7/0x330 mm/slub.c:6094
    free_to_pcs mm/slub.c:6147 [inline]
    slab_free mm/slub.c:6633 [inline]
    kfree+0x353/0x390 mm/slub.c:6923
    vfree mm/vmalloc.c:3549 [inline]
    vfree+0xa8/0x390 mm/vmalloc.c:3521
    delayed_vfree_work+0x29/0x40 mm/vmalloc.c:3451
    process_one_work+0x2b7/0x5c0 kernel/workqueue.c:3495
    process_scheduled_works kernel/workqueue.c:3578 [inline]
    worker_thread+0x255/0x4a0 kernel/workqueue.c:3659
    kthread+0x150/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x219/0x490 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff8881024bee00 (size 512):
  comm "softirq", pid 0, jiffies 4294937453
  hex dump (first 32 bytes):
    70 66 90 2a 81 88 ff ff 20 00 b4 81 ff ff ff ff  pf.*.... .......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 3d09b414):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    __do_kmalloc_node mm/slub.c:5530 [inline]
    __kmalloc_flags_noprof+0x42c/0x570 mm/slub.c:5719
    _kmalloc_flags_noprof mm/slab.h:55 [inline]
    __alloc_empty_sheaf mm/slub.c:2854 [inline]
    alloc_empty_sheaf mm/slub.c:2874 [inline]
    __pcs_replace_full_main+0xf7/0x330 mm/slub.c:6094
    free_to_pcs mm/slub.c:6147 [inline]
    slab_free mm/slub.c:6633 [inline]
    kfree+0x353/0x390 mm/slub.c:6923
    security_task_free+0x6e/0x130 security/security.c:2827
    __put_task_struct+0x9f/0x260 kernel/fork.c:792
    rcu_do_batch kernel/rcu/tree.c:2650 [inline]
    rcu_core+0x269/0x720 kernel/rcu/tree.c:2919
    handle_softirqs+0x114/0x330 kernel/softirq.c:669
    __do_softirq kernel/softirq.c:703 [inline]
    invoke_softirq kernel/softirq.c:542 [inline]
    __irq_exit_rcu+0xb5/0xf0 kernel/softirq.c:786
    instr_sysvec_irq_work arch/x86/kernel/irq_work.c:17 [inline]
    sysvec_irq_work+0x73/0x80 arch/x86/kernel/irq_work.c:17
    asm_sysvec_irq_work+0x1a/0x20 arch/x86/include/asm/idtentry.h:710

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF
** replaying previous printk message **


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
