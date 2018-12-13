Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_MIXED_ES,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CACBC65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 14:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 124892086D
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 14:11:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 124892086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbeLMOLi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:11:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:43668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728244AbeLMOLh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 09:11:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 18BEDAE83;
        Thu, 13 Dec 2018 14:11:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2BF4BDA7EE; Thu, 13 Dec 2018 15:11:12 +0100 (CET)
Date:   Thu, 13 Dec 2018 15:11:11 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/8][V2] Enospc cleanups and fixeS
Message-ID: <20181213141111.GC23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20181203152459.21630-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203152459.21630-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 03, 2018 at 10:24:51AM -0500, Josef Bacik wrote:
> v1->v2:
> - addressed comments from reviewers.
> - fixed a bug in patch 6 that was introduced because of changes to upstream.
> 
> -- Original message --
> 
> The delayed refs rsv patches exposed a bunch of issues in our enospc
> infrastructure that needed to be addressed.  These aren't really one coherent
> group, but they are all around flushing and reservations.
> may_commit_transaction() needed to be updated a little bit, and we needed to add
> a new state to force chunk allocation if things got dicey.  Also because we can
> end up needed to reserve a whole bunch of extra space for outstanding delayed
> refs we needed to add the ability to only ENOSPC tickets that were too big to
> satisfy, instead of failing all of the tickets.  There's also a fix in here for
> one of the corner cases where we didn't quite have enough space reserved for the
> delayed refs we were generating during evict().  Thanks,

One testbox reports an assertion failure on current for-next,
generic/224. I'm reporting it under this patchset as it's my best guess.
Same host running misc-next (with the delayed rsv patchset) was fine and
the run with for-next (including this patchset) fails. The assertion is

 5225 static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 5226                                     struct btrfs_space_info *space_info,
 5227                                     u64 orig_bytes,
 5228                                     enum btrfs_reserve_flush_enum flush,
 5229                                     bool system_chunk)
 5230 {
 5231         struct reserve_ticket ticket;
 5232         u64 used;
 5233         u64 reclaim_bytes = 0;
 5234         int ret = 0;
 5235
 5236         ASSERT(orig_bytes);
 ^^^^

I can't decipher from the register dump what's the value because the assertion
calls printk and RAX is most likely length of the string of the
resulting string:

RAX = 0x46 = 70
length("assertion failed: orig_bytes, file: fs/btrfs/extent-tree.c, line: 5236") = 70

There's assertion failure and a KASAN report below.

[36231.239898] run fstests generic/224 at 2018-12-12 18:36:17
[36232.066101] BTRFS: device fsid 0a848fb2-05d4-4f0c-9ad5-0414ef33b530 devid 1 transid 5 /dev/sdc1
[36232.101758] BTRFS info (device sdc1): disk space caching is enabled
[36232.108133] BTRFS info (device sdc1): has skinny extents
[36232.113581] BTRFS info (device sdc1): flagging fs with big metadata feature
[36232.149156] BTRFS info (device sdc1): checking UUID tree
[36574.735814] assertion failed: orig_bytes, file: fs/btrfs/extent-tree.c, line: 5236
[36574.815254] ------------[ cut here ]------------
[36574.819980] kernel BUG at fs/btrfs/ctree.h:3517!
[36574.826147] invalid opcode: 0000 [#1] PREEMPT SMP KASAN
[36574.831480] CPU: 7 PID: 4015 Comm: dd Tainted: G          I       4.20.0-rc6-1.gab9e909-default+ #179
[36574.840857] Hardware name: HP ProLiant DL380 G6, BIOS P62 10/01/2009
[36574.847489] RIP: 0010:assfail.constprop.79+0x18/0x1a [btrfs]
[36574.872226] RSP: 0018:ffff8883e88b77c0 EFLAGS: 00010286
[36574.877546] RAX: 0000000000000046 RBX: ffff8882acea0080 RCX: ffffffff9316c63e
[36574.884773] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff8884136e520c
[36574.891998] RBP: 0000000000000000 R08: ffffed10826dcd71 R09: ffffed10826dcd71
[36574.899220] R10: 0000000000000001 R11: ffffed10826dcd70 R12: ffff88840bd0d240
[36574.906444] R13: ffff88804d6e5700 R14: ffff88804d6e5700 R15: 0000000000000000
[36574.913670] FS:  00007f120abed540(0000) GS:ffff8884136c0000(0000) knlGS:0000000000000000
[36574.921919] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[36574.927755] CR2: 00007fa563830648 CR3: 00000003f17ba000 CR4: 00000000000006e0
[36574.934975] Call Trace:
[36574.937641]  reserve_metadata_bytes+0xb22/0x10c0 [btrfs]
[36574.943056]  ? _raw_spin_lock+0x81/0xd0
[36574.947107]  ? btrfs_async_reclaim_metadata_space+0x7b0/0x7b0 [btrfs]
[36574.953639]  ? _raw_spin_lock+0x81/0xd0
[36574.957580]  ? _raw_read_lock_irq+0x40/0x40
[36574.962009]  ? btrfs_calculate_inode_block_rsv_size+0xe2/0x110 [btrfs]
[36574.968813]  ? __btrfs_qgroup_reserve_meta+0x3b/0x1d0 [btrfs]
[36574.974764]  btrfs_delalloc_reserve_metadata+0x2a1/0x8c0 [btrfs]
[36574.980981]  btrfs_buffered_write.isra.22+0x309/0x970 [btrfs]
[36574.986930]  ? btrfs_dirty_pages+0x3c0/0x3c0 [btrfs]
[36574.991991]  ? __vfs_getxattr+0x5e/0x80
[36574.995922]  ? cap_inode_need_killpriv+0x2a/0x40
[36575.000644]  ? file_remove_privs+0xa4/0x1c0
[36575.004921]  ? timespec64_trunc+0x5c/0x90
[36575.009031]  ? current_time+0xa9/0x100
[36575.012882]  ? timespec64_trunc+0x90/0x90
[36575.016986]  ? _raw_spin_lock+0x81/0xd0
[36575.020920]  ? _raw_read_lock_irq+0x40/0x40
[36575.025199]  ? clear_user+0x25/0x60
[36575.030508]  btrfs_file_write_iter+0x5a8/0xac0 [btrfs]
[36575.035898]  ? btrfs_sync_file+0x600/0x600 [btrfs]
[36575.040787]  ? mem_cgroup_charge_statistics+0x1f2/0x3b0
[36575.046110]  __vfs_write+0x236/0x370
[36575.049791]  ? kernel_read+0xa0/0xa0
[36575.053548]  ? _raw_spin_unlock+0xe/0x30
[36575.057577]  ? fsnotify+0x5b5/0x5e0
[36575.061176]  ? __fsnotify_inode_delete+0x20/0x20
[36575.065903]  vfs_write+0xf7/0x280
[36575.069323]  ksys_write+0xa1/0x120
[36575.072823]  ? __ia32_sys_read+0x50/0x50
[36575.076840]  ? __do_page_fault+0x43e/0x640
[36575.081033]  do_syscall_64+0x67/0x140
[36575.084800]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[36575.089949] RIP: 0033:0x7f120a708bd4
[36575.112600] RSP: 002b:00007fffd5a79868 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[36575.120339] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f120a708bd4
[36575.127564] RDX: 0000000000001000 RSI: 000055db2166f000 RDI: 0000000000000001
[36575.134785] RBP: 0000000000001000 R08: 0000000000000000 R09: 0000000000000003
[36575.142009] R10: 000000000000089e R11: 0000000000000246 R12: 000055db2166f000
[36575.149234] R13: 0000000000000200 R14: 0000000000000000 R15: 000055db2166f000
[36575.216503] ---[ end trace ce4b42658141c05e ]---
[36575.221552] RIP: 0010:assfail.constprop.79+0x18/0x1a [btrfs]
[36575.246307] RSP: 0018:ffff8883e88b77c0 EFLAGS: 00010286
[36575.251629] RAX: 0000000000000046 RBX: ffff8882acea0080 RCX: ffffffff9316c63e
[36575.258855] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff8884136e520c
[36575.266084] RBP: 0000000000000000 R08: ffffed10826dcd71 R09: ffffed10826dcd71
[36575.273311] R10: 0000000000000001 R11: ffffed10826dcd70 R12: ffff88840bd0d240
[36575.280544] R13: ffff88804d6e5700 R14: ffff88804d6e5700 R15: 0000000000000000
[36575.287773] FS:  00007f120abed540(0000) GS:ffff8884137c0000(0000) knlGS:0000000000000000
[36575.296023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[36575.301863] CR2: 000055b7c2c84000 CR3: 00000003f17ba000 CR4: 00000000000006e0
[36669.772346] ==================================================================
[36669.779763] BUG: KASAN: use-after-free in rwsem_down_write_failed+0x136/0x670
[36669.787006] Read of size 4 at addr ffff8883eac420f8 by task dd/8321
[36669.794976] CPU: 10 PID: 8321 Comm: dd Tainted: G      D   I       4.20.0-rc6-1.gab9e909-default+ #179
[36669.804456] Hardware name: HP ProLiant DL380 G6, BIOS P62 10/01/2009
[36669.810918] Call Trace:
[36669.813483]  dump_stack+0x5b/0x8b
[36669.816915]  print_address_description+0x6a/0x250
[36669.821732]  kasan_report+0x260/0x380
[36669.825505]  ? rwsem_down_write_failed+0x136/0x670
[36669.830408]  rwsem_down_write_failed+0x136/0x670
[36669.835141]  ? save_stack+0x89/0xb0
[36669.838740]  ? rwsem_down_read_failed+0x2e0/0x2e0
[36669.843552]  ? do_syscall_64+0x67/0x140
[36669.847498]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[36669.852834]  ? __alloc_pages_nodemask+0x194/0x3b0
[36669.857652]  ? __alloc_pages_slowpath+0x1290/0x1290
[36669.862639]  ? restore_nameidata+0x7b/0xa0
[36669.866846]  ? do_filp_open+0x138/0x1d0
[36669.870792]  ? locks_remove_posix+0x84/0x240
[36669.875167]  ? vfs_lock_file+0x80/0x80
[36669.879029]  ? call_rwsem_down_write_failed+0x13/0x20
[36669.884192]  call_rwsem_down_write_failed+0x13/0x20
[36669.889341]  ? btrfs_file_llseek+0x93/0x420 [btrfs]
[36669.894331]  down_write+0x25/0x40
[36669.897909]  btrfs_file_llseek+0xa6/0x420 [btrfs]
[36669.902726]  ? dnotify_flush+0x2e/0x170
[36669.906673]  ? _raw_spin_lock+0x81/0xd0
[36669.910777]  ? btrfs_copy_from_user+0x150/0x150 [btrfs]
[36669.916114]  ? __fget_light+0xa6/0xe0
[36669.919886]  ksys_lseek+0x8e/0xc0
[36669.923309]  do_syscall_64+0x67/0x140
[36669.927083]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[36669.932245] RIP: 0033:0x7fe7829c3c6d
[36669.954936] RSP: 002b:00007ffc64c84578 EFLAGS: 00000206 ORIG_RAX: 0000000000000008
[36669.962685] RAX: ffffffffffffffda RBX: 0000559e48b97400 RCX: 00007fe7829c3c6d
[36669.969925] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000000
[36669.977170] RBP: 00007ffc64c8693b R08: 0000559e489934f0 R09: 0000000000000000
[36669.984411] R10: 000000000000047a R11: 0000000000000206 R12: 0000000000004000
[36669.991648] R13: 00007ffc64c86969 R14: 00007ffc64c847a8 R15: 0000000000080000
[36670.000502] Allocated by task 4235:
[36670.004104]  kasan_kmalloc+0xa0/0xd0
[36670.007785]  kmem_cache_alloc+0xaf/0x5a0
[36670.011977]  __alloc_extent_buffer+0x25/0x1f0 [btrfs]
[36670.017295]  alloc_extent_buffer+0x140/0x590 [btrfs]
[36670.022484]  btrfs_init_new_buffer+0x42/0x450 [btrfs]
[36670.027790]  btrfs_alloc_tree_block+0x307/0x5d0 [btrfs]
[36670.033270]  __btrfs_cow_block+0x2a0/0x940 [btrfs]
[36670.038310]  btrfs_cow_block+0x1eb/0x320 [btrfs]
[36670.043192]  btrfs_search_slot+0x90c/0x1110 [btrfs]
[36670.048327]  btrfs_lookup_file_extent+0x84/0xb0 [btrfs]
[36670.053808]  __btrfs_drop_extents+0x268/0x11f0 [btrfs]
[36670.059200]  insert_reserved_file_extent.constprop.65+0x10c/0x430 [btrfs]
[36670.066244]  btrfs_finish_ordered_io+0x884/0xbf0 [btrfs]
[36670.071821]  normal_work_helper+0xb7/0x520 [btrfs]
[36670.076721]  process_one_work+0x349/0x6b0
[36670.080842]  worker_thread+0x57/0x590
[36670.084610]  kthread+0x1a4/0x1d0
[36670.087947]  ret_from_fork+0x1f/0x30

[36670.093230] Freed by task 0:
[36670.096220]  __kasan_slab_free+0x105/0x150
[36670.100422]  kmem_cache_free+0x3c/0x140
[36670.104371]  rcu_process_callbacks+0x448/0x6d0
[36670.108929]  __do_softirq+0x105/0x3c7
[36670.114304] The buggy address belongs to the object at ffff8883eac42080
                which belongs to the cache btrfs_extent_buffer of size 280
[36670.127691] The buggy address is located 120 bytes inside of
                280-byte region [ffff8883eac42080, ffff8883eac42198)
[36670.139601] The buggy address belongs to the page:
[36670.144498] page:ffffea000fab1080 count:1 mapcount:0 mapping:ffff88805c5c26c0 index:0x0
[36670.152675] flags: 0xdffff000000200(slab)
[36670.156796] raw: 00dffff000000200 ffffea000f68a208 ffffea000fc5ae08 ffff88805c5c26c0
[36670.164714] raw: 0000000000000000 ffff8883eac42080 000000010000000b 0000000000000000
[36670.172644] page dumped because: kasan: bad access detected
[36670.179913] Memory state around the buggy address:
[36670.184808]  ffff8883eac41f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[36670.192206]  ffff8883eac42000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[36670.199604] >ffff8883eac42080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[36670.206997]                                                                 ^
[36670.214237]  ffff8883eac42100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[36670.221631]  ffff8883eac42180: fb fb fb fc fc fc fc fc fc fc fc fb fb fb fb fb
[36670.229021] ==================================================================
