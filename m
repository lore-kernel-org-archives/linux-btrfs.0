Return-Path: <SRS0=b0aI=NP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48564C32789
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 13:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93EAD204FD
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 13:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93EAD204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cs.uni-bonn.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbeKDWgp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 4 Nov 2018 17:36:45 -0500
Received: from smtp8.iai.uni-bonn.de ([131.220.63.194]:58848 "EHLO
        smtp8.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbeKDWgp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Nov 2018 17:36:45 -0500
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Nov 2018 17:36:34 EST
X-IAI-Env-From: <ochmann@cs.uni-bonn.de> : [127.0.0.1]
Received: from smtp8.iai.uni-bonn.de (smtp8.iai.uni-bonn.de [127.0.0.1])
        by smtp8.iai.uni-bonn.de (Postfix) with ESMTP id BF820E9DE
        for <linux-btrfs@vger.kernel.org>; Sun,  4 Nov 2018 14:15:55 +0100 (MET)
        (envelope-from ochmann@cs.uni-bonn.de)
        (envelope-to linux-btrfs@vger.kernel.org) (1)
X-IAI-Env-From: <ochmann@cs.uni-bonn.de> : [91.10.4.29]
Received: from [192.168.0.1] (p5B0A041D.dip0.t-ipconnect.de [91.10.4.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: ochmann@auth.iai.uni-bonn.de)
        by smtp8.iai.uni-bonn.de (Postfix) with ESMTPSA id 9B0C7E9DD
        for <linux-btrfs@vger.kernel.org>; Sun,  4 Nov 2018 14:15:55 +0100 (MET)
        (envelope-from ochmann@cs.uni-bonn.de)
        (envelope-to linux-btrfs@vger.kernel.org) (1)
        (internal use: ta=1, tu=1, te=1, am=P, au=ochmann)
X-IAI-Auth: EIfZyeJJC1xjhMe3L/y1r6PAtimYlerxUfY0R2bxrRCGYV2pqozjHDA+B5d4Jxs1yz6ZuhI2dU+k5skRD5skzpSb/fGsNuCh3r5Pul7o/ZCO5Dl/2aP4HQAAAAAAAAAA@auth.iai.uni-bonn.de
To:     linux-btrfs@vger.kernel.org
From:   Sebastian Ochmann <ochmann@cs.uni-bonn.de>
Subject: Filesystem mounts fine but hangs on access
Message-ID: <f0e1900a-b242-06e0-b68f-0ddc146eca56@cs.uni-bonn.de>
Date:   Sun, 4 Nov 2018 14:15:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I have a btrfs filesystem on a single encrypted (LUKS) 10 TB drive which 
stopped working correctly. The drive is used as a backup drive with zstd 
compression to which I regularly rsync and make daily snapshots. After I 
routinely removed a bunch of snapshots (about 20), I noticed later that 
the machine would hang when trying to unmount the filesystem. The 
current state is that I'm able to mount the filesystem without errors 
and I can view (ls) files in the root level, but trying to view contents 
of directories contained therein hangs just like when trying to unmount 
the filesystem. I have not yet tried to run check, repair, etc. Do you 
have any advice what I should try next?

A notable hardware change I did a few days before the problem is a 
switch from an Intel Xeon platform to AMD Threadripper. However, I 
haven't seen problems with the rest of the btrfs filesystems (in 
particular, a RAID-1 consisting of three HDDs), which I also migrated to 
the new platform, yet. I just want to mention it in case there are known 
issues in that direction.

Kernel 4.18.16 (Arch Linux)
btrfs-progs 4.17.1

Kernel log after trying to "ls" a directory contained in the 
filesystem's root directory:

[   79.279349] BTRFS info (device dm-5): use zstd compression, level 0
[   79.279351] BTRFS info (device dm-5): disk space caching is enabled
[   79.279352] BTRFS info (device dm-5): has skinny extents
[  135.202344] kauditd_printk_skb: 2 callbacks suppressed
[  135.202347] audit: type=1130 audit(1541335770.667:45): pid=1 uid=0 
auid=4294967295 ses=4294967295 msg='unit=polkit comm="systemd" 
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[  135.364850] audit: type=1130 audit(1541335770.831:46): pid=1 uid=0 
auid=4294967295 ses=4294967295 msg='unit=udisks2 comm="systemd" 
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[  135.589255] audit: type=1130 audit(1541335771.054:47): pid=1 uid=0 
auid=4294967295 ses=4294967295 msg='unit=rtkit-daemon comm="systemd" 
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[  368.266653] INFO: task kworker/u256:1:728 blocked for more than 120 
seconds.
[  368.266657]       Tainted: P           OE     4.18.16-arch1-1-ARCH #1
[  368.266658] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  368.266660] kworker/u256:1  D    0   728      2 0x80000080
[  368.266680] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[  368.266681] Call Trace:
[  368.266687]  ? __schedule+0x29b/0x8b0
[  368.266690]  ? preempt_count_add+0x68/0xa0
[  368.266692]  schedule+0x32/0x90
[  368.266707]  btrfs_tree_read_lock+0x7d/0x110 [btrfs]
[  368.266710]  ? wait_woken+0x80/0x80
[  368.266719]  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
[  368.266729]  btrfs_search_slot+0xf6/0xa00 [btrfs]
[  368.266732]  ? _raw_spin_unlock+0x16/0x30
[  368.266734]  ? inode_insert5+0x105/0x1a0
[  368.266746]  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
[  368.266749]  ? kmem_cache_alloc+0x179/0x1d0
[  368.266762]  btrfs_iget+0x113/0x690 [btrfs]
[  368.266764]  ? _raw_spin_unlock+0x16/0x30
[  368.266778]  __lookup_free_space_inode+0xd8/0x150 [btrfs]
[  368.266792]  lookup_free_space_inode+0x63/0xc0 [btrfs]
[  368.266806]  load_free_space_cache+0x6e/0x190 [btrfs]
[  368.266808]  ? kmem_cache_alloc_trace+0x181/0x1d0
[  368.266817]  ? cache_block_group+0x73/0x3e0 [btrfs]
[  368.266827]  cache_block_group+0x1c1/0x3e0 [btrfs]
[  368.266829]  ? wait_woken+0x80/0x80
[  368.266839]  find_free_extent+0x872/0x10e0 [btrfs]
[  368.266851]  btrfs_reserve_extent+0x9b/0x180 [btrfs]
[  368.266862]  btrfs_alloc_tree_block+0x1b3/0x4d0 [btrfs]
[  368.266872]  __btrfs_cow_block+0x11d/0x500 [btrfs]
[  368.266882]  btrfs_cow_block+0xdc/0x1a0 [btrfs]
[  368.266891]  btrfs_search_slot+0x282/0xa00 [btrfs]
[  368.266893]  ? _raw_spin_unlock+0x16/0x30
[  368.266903]  btrfs_insert_empty_items+0x67/0xc0 [btrfs]
[  368.266913]  __btrfs_run_delayed_refs+0x8ef/0x10a0 [btrfs]
[  368.266915]  ? preempt_count_add+0x68/0xa0
[  368.266926]  btrfs_run_delayed_refs+0x72/0x180 [btrfs]
[  368.266937]  delayed_ref_async_start+0x81/0x90 [btrfs]
[  368.266950]  normal_work_helper+0xbd/0x350 [btrfs]
[  368.266953]  process_one_work+0x1eb/0x3c0
[  368.266955]  worker_thread+0x2d/0x3d0
[  368.266956]  ? process_one_work+0x3c0/0x3c0
[  368.266958]  kthread+0x112/0x130
[  368.266960]  ? kthread_flush_work_fn+0x10/0x10
[  368.266961]  ret_from_fork+0x22/0x40
[  368.266978] INFO: task btrfs-cleaner:1196 blocked for more than 120 
seconds.
[  368.266980]       Tainted: P           OE     4.18.16-arch1-1-ARCH #1
[  368.266981] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  368.266982] btrfs-cleaner   D    0  1196      2 0x80000080
[  368.266983] Call Trace:
[  368.266985]  ? __schedule+0x29b/0x8b0
[  368.266987]  schedule+0x32/0x90
[  368.266997]  cache_block_group+0x148/0x3e0 [btrfs]
[  368.266998]  ? wait_woken+0x80/0x80
[  368.267009]  find_free_extent+0x872/0x10e0 [btrfs]
[  368.267020]  btrfs_reserve_extent+0x9b/0x180 [btrfs]
[  368.267031]  btrfs_alloc_tree_block+0x1b3/0x4d0 [btrfs]
[  368.267040]  ? leaf_space_used+0xdc/0x100 [btrfs]
[  368.267049]  __btrfs_cow_block+0x11d/0x500 [btrfs]
[  368.267059]  btrfs_cow_block+0xdc/0x1a0 [btrfs]
[  368.267069]  btrfs_search_slot+0x282/0xa00 [btrfs]
[  368.267080]  btrfs_remove_block_group+0x2f7/0x910 [btrfs]
[  368.267094]  btrfs_remove_chunk+0x530/0x750 [btrfs]
[  368.267105]  btrfs_delete_unused_bgs+0x285/0x410 [btrfs]
[  368.267117]  ? btrfs_destroy_pinned_extent+0xd0/0xd0 [btrfs]
[  368.267127]  cleaner_kthread+0x144/0x160 [btrfs]
[  368.267129]  kthread+0x112/0x130
[  368.267131]  ? kthread_flush_work_fn+0x10/0x10
[  368.267133]  ret_from_fork+0x22/0x40
[  368.267135] INFO: task btrfs-transacti:1197 blocked for more than 120 
seconds.
[  368.267136]       Tainted: P           OE     4.18.16-arch1-1-ARCH #1
[  368.267137] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  368.267138] btrfs-transacti D    0  1197      2 0x80000080
[  368.267139] Call Trace:
[  368.267141]  ? __schedule+0x29b/0x8b0
[  368.267142]  ? preempt_count_add+0x68/0xa0
[  368.267144]  schedule+0x32/0x90
[  368.267156]  btrfs_tree_lock+0x113/0x1f0 [btrfs]
[  368.267158]  ? wait_woken+0x80/0x80
[  368.267167]  btrfs_search_slot+0x7b4/0xa00 [btrfs]
[  368.267178]  btrfs_insert_empty_items+0x67/0xc0 [btrfs]
[  368.267188]  __btrfs_run_delayed_refs+0x8ef/0x10a0 [btrfs]
[  368.267190]  ? _raw_spin_unlock_irq+0x1d/0x30
[  368.267201]  btrfs_run_delayed_refs+0x72/0x180 [btrfs]
[  368.267212]  btrfs_commit_transaction+0x40/0x8a0 [btrfs]
[  368.267224]  ? start_transaction+0x9c/0x3f0 [btrfs]
[  368.267236]  transaction_kthread+0x13f/0x170 [btrfs]
[  368.267247]  ? btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[  368.267248]  kthread+0x112/0x130
[  368.267250]  ? kthread_flush_work_fn+0x10/0x10
[  368.267252]  ret_from_fork+0x22/0x40
[  368.267254] INFO: task pool:1229 blocked for more than 120 seconds.
[  368.267255]       Tainted: P           OE     4.18.16-arch1-1-ARCH #1
[  368.267256] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  368.267257] pool            D    0  1229   1077 0x00000080
[  368.267259] Call Trace:
[  368.267260]  ? __schedule+0x29b/0x8b0
[  368.267270]  ? get_alloc_profile+0xb2/0x180 [btrfs]
[  368.267271]  schedule+0x32/0x90
[  368.267273]  schedule_timeout+0x311/0x4a0
[  368.267275]  ? _raw_spin_unlock_irqrestore+0x20/0x40
[  368.267276]  ? try_to_wake_up+0x231/0x480
[  368.267278]  wait_for_common+0x15f/0x190
[  368.267280]  ? wake_up_q+0x70/0x70
[  368.267290]  btrfs_async_run_delayed_refs+0x10d/0x130 [btrfs]
[  368.267301]  __btrfs_end_transaction+0x1b9/0x2d0 [btrfs]
[  368.267313]  btrfs_dirty_inode+0x6a/0xd0 [btrfs]
[  368.267315]  touch_atime+0xc0/0xe0
[  368.267318]  iterate_dir+0xd7/0x180
[  368.267319]  ksys_getdents64+0x9c/0x130
[  368.267321]  ? filldir+0x130/0x130
[  368.267323]  __x64_sys_getdents64+0x16/0x20
[  368.267325]  do_syscall_64+0x5b/0x170
[  368.267327]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  368.267328] RIP: 0033:0x7f990cba5c5b
[  368.267328] Code: Bad RIP value.
[  368.267333] RSP: 002b:00007f9906579a38 EFLAGS: 00000246 ORIG_RAX: 
00000000000000d9
[  368.267335] RAX: ffffffffffffffda RBX: 00007f98fc002cd0 RCX: 
00007f990cba5c5b
[  368.267335] RDX: 0000000000008000 RSI: 00007f98fc002d00 RDI: 
0000000000000019
[  368.267336] RBP: 00007f98fc002d00 R08: 0000000000000003 R09: 
00007f98fc000160
[  368.267337] R10: 00007f98fc0008d0 R11: 0000000000000246 R12: 
ffffffffffffff80
[  368.267337] R13: 000000000000000d R14: 0000000000000000 R15: 
000055ed59b1ca20
[  368.267343] INFO: task ls:1326 blocked for more than 120 seconds.
[  368.267345]       Tainted: P           OE     4.18.16-arch1-1-ARCH #1
[  368.267346] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  368.267347] ls              D    0  1326   1321 0x00000080
[  368.267348] Call Trace:
[  368.267350]  ? __schedule+0x29b/0x8b0
[  368.267352]  schedule+0x32/0x90
[  368.267353]  rwsem_down_write_failed+0x15d/0x240
[  368.267355]  ? filldir+0x130/0x130
[  368.267357]  call_rwsem_down_write_failed+0x13/0x20
[  368.267359]  down_write+0x20/0x30
[  368.267373]  btrfs_readdir_get_delayed_items+0x4a/0x100 [btrfs]
[  368.267385]  btrfs_real_readdir+0x143/0x4a0 [btrfs]
[  368.267387]  ? dput.part.4+0xa4/0x130
[  368.267389]  iterate_dir+0x13c/0x180
[  368.267390]  ksys_getdents64+0x9c/0x130
[  368.267392]  ? filldir+0x130/0x130
[  368.267393]  __x64_sys_getdents64+0x16/0x20
[  368.267395]  do_syscall_64+0x5b/0x170
[  368.267397]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  368.267398] RIP: 0033:0x7f3fbdc06c5b
[  368.267398] Code: Bad RIP value.
[  368.267400] RSP: 002b:00007fff85f83c98 EFLAGS: 00000246 ORIG_RAX: 
00000000000000d9
[  368.267401] RAX: ffffffffffffffda RBX: 0000558df0bec3d0 RCX: 
00007f3fbdc06c5b
[  368.267402] RDX: 0000000000008000 RSI: 0000558df0bec400 RDI: 
0000000000000003
[  368.267402] RBP: 0000558df0bec400 R08: 0000000000000003 R09: 
0000000000000078
[  368.267403] R10: 0000558df0be6010 R11: 0000000000000246 R12: 
ffffffffffffff80
[  368.267404] R13: 0000000000000000 R14: 0000558df0bec3b0 R15: 
0000558def5dd8c1
[  368.267406] INFO: task ls:1335 blocked for more than 120 seconds.
[  368.267407]       Tainted: P           OE     4.18.16-arch1-1-ARCH #1
[  368.267408] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  368.267409] ls              D    0  1335   1328 0x00000080
[  368.267410] Call Trace:
[  368.267412]  ? __schedule+0x29b/0x8b0
[  368.267413]  ? preempt_count_add+0x68/0xa0
[  368.267415]  schedule+0x32/0x90
[  368.267428]  btrfs_tree_read_lock+0x7d/0x110 [btrfs]
[  368.267429]  ? wait_woken+0x80/0x80
[  368.267438]  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
[  368.267448]  btrfs_search_slot+0xf6/0xa00 [btrfs]
[  368.267449]  ? preempt_count_add+0x68/0xa0
[  368.267462]  ? release_extent_buffer+0x90/0xa0 [btrfs]
[  368.267474]  btrfs_lookup_dentry+0x163/0x4b0 [btrfs]
[  368.267487]  btrfs_lookup+0xe/0x30 [btrfs]
[  368.267489]  __lookup_slow+0x97/0x160
[  368.267491]  lookup_slow+0x35/0x50
[  368.267493]  walk_component+0x1bd/0x2d0
[  368.267494]  path_lookupat.isra.11+0x75/0x200
[  368.267496]  ? preempt_count_add+0x68/0xa0
[  368.267497]  filename_lookup.part.19+0xa0/0x170
[  368.267500]  ? __check_object_size+0xfb/0x180
[  368.267502]  ? strncpy_from_user+0x4a/0x160
[  368.267504]  vfs_statx+0x73/0xe0
[  368.267506]  ? __audit_syscall_exit+0x22a/0x290
[  368.267508]  __se_sys_newlstat+0x3e/0x70
[  368.267510]  ? syscall_trace_enter+0x1d3/0x2d0
[  368.267511]  ? ksys_getdents64+0x9c/0x130
[  368.267512]  ? filldir+0x130/0x130
[  368.267514]  do_syscall_64+0x5b/0x170
[  368.267515]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  368.267516] RIP: 0033:0x7f2ec50ace49
[  368.267517] Code: Bad RIP value.
[  368.267519] RSP: 002b:00007ffd762d1828 EFLAGS: 00000246 ORIG_RAX: 
0000000000000006
[  368.267520] RAX: ffffffffffffffda RBX: 0000558149726510 RCX: 
00007f2ec50ace49
[  368.267520] RDX: 0000558149726528 RSI: 0000558149726528 RDI: 
00007ffd762d1830
[  368.267521] RBP: 00007ffd762d1bf0 R08: 0000000000000000 R09: 
000055814972b449
[  368.267522] R10: 0000000000000000 R11: 0000000000000246 R12: 
00007ffd762d1830
[  368.267522] R13: 0000000000000000 R14: 0000000000000003 R15: 
0000558149726528
