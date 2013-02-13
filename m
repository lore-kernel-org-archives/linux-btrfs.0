Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f169.google.com ([209.85.210.169]:59184 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3BMJKK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 04:10:10 -0500
Received: by mail-ia0-f169.google.com with SMTP id j5so1026127iaf.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 01:10:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <511B5386.8030309@gmx.net>
References: <CAGEjNMfpTD3wMsagrFYinuJj0ieT8+g66uVz_hFpgp=1j4hYFQ@mail.gmail.com>
	<CAGEjNMc6PNKL8PY-S6FxhTV15N=jt7upVhFaCCY4jbeKpsaQOA@mail.gmail.com>
	<511B5386.8030309@gmx.net>
Date: Wed, 13 Feb 2013 14:40:09 +0530
Message-ID: <CAGEjNMcSUoTF6_QQkr_-21zK2SXn7m__-mkNKz-aNyy8zWyyqA@mail.gmail.com>
Subject: Re: Heavy memory leak when using quota groups
From: shyam btrfs <shyam.btrfs@gmail.com>
To: Arne Jansen <sensille@gmx.net>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Arne,

I realize my first mail that had logs as attachment didnt show up. I
uploaded the logs at
https://docs.google.com/file/d/0B1JpdTsfQ1vgVTkwRHJjcHplZlk/edit?usp=sharing

This has the debug-tree when btrfs cannot mount (i.e. after the
crash). Also there are meminfo/slabinfo that I kept collecting before
& during the test.

I will try now to stop the test in the middle & unmount to see if I
can reclaim the memory (will mail you shortly). BTW, I am trying this
on a 2GB RAM VM & to start with I have ~1.2GB RAM free. So I dont know
if its just trying to keep asking for more memory. I didnt see things
strange in slabinfo, but perhaps you may see it. In several runs I hit
out-of-memory killer trying to kill processes, in this trace btrfs
itself suffered with allocation.

--Shyam

On Wed, Feb 13, 2013 at 2:19 PM, Arne Jansen <sensille@gmx.net> wrote:
> On 12.02.2013 08:31, shyam btrfs wrote:
>> Also immediately after this problem, its impossible to mount the
>> filesystem. it consistently fails with
>
> no luck here either. I tried a sync-heavy workload and crashed it
> in the middle. mount took a while but succeeded.
> Maybe your debug tree contains enough information to figure out what's
> going on.
>
> -Arne
>
>>
>> [ 2092.254428] BUG: unable to handle kernel NULL pointer dereference
>> at 00000000000003c4
>> [ 2092.255945] IP: [<ffffffffa033d0be>]
>> btrfs_search_old_slot+0x63e/0x940 [btrfs]
>> [ 2092.257340] PGD 23d42067 PUD 3a93a067 PMD 0
>> [ 2092.257982] Oops: 0000 [#1] SMP
>> [ 2092.257982] Modules linked in: raid1 xt_multiport xt_tcpudp
>> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter
>> ip_tables x_tables iscsi_tcp libiscsi_tcp libiscsi
>> scsi_transport_iscsi xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp
>> esp4 ah4 8021q garp stp llc bonding btrfs(OF) deflate zlib_deflate ctr
>> twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common
>> camellia_generic camellia_x86_64 serpent_sse2_x86_64 glue_helper lrw
>> serpent_generic xts gf128mul blowfish_generic blowfish_x86_64
>> blowfish_common ablk_helper cryptd cast5_generic cast_common
>> des_generic xcbc rmd160 crypto_null af_key xfrm_algo scst_vdisk(OF)
>> iscsi_scst(OF) scst(OF) libcrc32c microcode nfsv4 psmouse nfsd(OF)
>> virtio_balloon nfs_acl serio_raw auth_rpcgss nfs fscache lockd sunrpc
>> lp parport floppy ixgbevf
>> [ 2092.257982] CPU 0
>> [ 2092.257982] Pid: 27156, comm: mount Tainted: GF          O
>> 3.8.0-030800rc5-generic #201301251535 Bochs Bochs
>> [ 2092.257982] RIP: 0010:[<ffffffffa033d0be>]  [<ffffffffa033d0be>]
>> btrfs_search_old_slot+0x63e/0x940 [btrfs]
>> [ 2092.257982] RSP: 0018:ffff88003752f598  EFLAGS: 00010206
>> [ 2092.257982] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff880017826560
>> [ 2092.257982] RDX: 0f83e0f83e0f83e1 RSI: 0000000000000066 RDI: ffff8800374bda00
>> [ 2092.257982] RBP: ffff88003752f628 R08: ffff880019dfc000 R09: ffff88003752f508
>> [ 2092.257982] R10: 000000000000000c R11: 0000000000000000 R12: ffff880018d60800
>> [ 2092.257982] R13: ffff88001c3bd900 R14: ffff88001c3ce158 R15: ffff880000000000
>> [ 2092.257982] FS:  00007fdc62688800(0000) GS:ffff88003fc00000(0000)
>> knlGS:0000000000000000
>> [ 2092.257982] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [ 2092.257982] CR2: 00000000000003c4 CR3: 000000003a91a000 CR4: 00000000000006f0
>> [ 2092.257982] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [ 2092.257982] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [ 2092.257982] Process mount (pid: 27156, threadinfo ffff88003752e000,
>> task ffff880018ea5d00)
>> [ 2092.257982] Stack:
>> [ 2092.257982]  ffff88003752f5c8 ffff88003d554480 ffff880017826560
>> ffff880019dfc000
>> [ 2092.257982]  0000000018d60800 0000000000000000 0000000000000000
>> ffff880018729498
>> [ 2092.257982]  00000000000000dc 0000000000000001 ffff88001c3ce158
>> 000000001c3bd900
>> [ 2092.257982] Call Trace:
>> [ 2092.257982]  [<ffffffffa03b23f3>] __resolve_indirect_refs+0x173/0x620 [btrfs]
>> [ 2092.257982]  [<ffffffffa037aa17>] ? free_extent_buffer+0x37/0x90 [btrfs]
>> [ 2092.257982]  [<ffffffffa03b316a>] find_parent_nodes+0x7da/0xf90 [btrfs]
>> [ 2092.257982]  [<ffffffffa03b39b9>] btrfs_find_all_roots+0x99/0x100 [btrfs]
>> [ 2092.257982]  [<ffffffff81183beb>] ? kfree+0x3b/0x150
>> [ 2092.257982]  [<ffffffffa03b691b>] btrfs_qgroup_account_ref+0xfb/0x550 [btrfs]
>> [ 2092.257982]  [<ffffffffa0346088>] ?
>> btrfs_delayed_refs_qgroup_accounting+0x58/0x100 [btrfs]
>> [ 2092.257982]  [<ffffffff81183cc4>] ? kfree+0x114/0x150
>> [ 2092.257982]  [<ffffffffa03460d3>]
>> btrfs_delayed_refs_qgroup_accounting+0xa3/0x100 [btrfs]
>> [ 2092.257982]  [<ffffffffa034d269>] btrfs_run_delayed_refs+0x49/0x2f0 [btrfs]
>> [ 2092.257982]  [<ffffffffa0373f43>] ?
>> btrfs_run_ordered_operations+0x2b3/0x2e0 [btrfs]
>> [ 2092.257982]  [<ffffffffa035ce25>] btrfs_commit_transaction+0x85/0xad0 [btrfs]
>> [ 2092.257982]  [<ffffffffa033c5de>] ? btrfs_search_slot+0x2fe/0x7a0 [btrfs]
>> [ 2092.257982]  [<ffffffff8107fc70>] ? add_wait_queue+0x60/0x60
>> [ 2092.257982]  [<ffffffff81183d42>] ? kmem_cache_free+0x42/0x160
>> [ 2092.257982]  [<ffffffffa03754c1>] ?
>> release_extent_buffer.isra.26+0x81/0xf0 [btrfs]
>> [ 2092.257982]  [<ffffffffa0396aa5>] btrfs_recover_log_trees+0x335/0x3b0 [btrfs]
>> [ 2092.257982]  [<ffffffffa03953d0>] ?
>> fixup_inode_link_counts+0x150/0x150 [btrfs]
>> [ 2092.257982]  [<ffffffffa035ae96>] open_ctree+0x1646/0x1d70 [btrfs]
>> [ 2092.257982]  [<ffffffffa0333bbb>] btrfs_mount+0x57b/0x670 [btrfs]
>> [ 2092.257982]  [<ffffffff8119e543>] mount_fs+0x43/0x1b0
>> [ 2092.257982]  [<ffffffff811b92e6>] vfs_kern_mount+0x76/0x120
>> [ 2092.257982]  [<ffffffff811ba761>] do_new_mount+0xb1/0x1e0
>> [ 2092.257982]  [<ffffffff811bbf76>] do_mount+0x1b6/0x1f0
>> [ 2092.257982]  [<ffffffff811bc040>] sys_mount+0x90/0xe0
>> [ 2092.257982]  [<ffffffff816f45dd>] system_call_fastpath+0x1a/0x1f
>> [ 2092.257982] Code: 00 48 03 10 48 89 d0 48 ba 00 00 00 00 00 88 ff
>> ff 48 c1 f8 06 48 c1 e0 0c 8b 74 10 60 49 8b 40 40 48 ba e1 83 0f 3e
>> f8 e0 83 0f <8b> 80 c4 03 00 00 48 83 e8 65 48 f7 e2 48 d1 ea 48 39 d6
>> 0f 87
>> [ 2092.257982] RIP  [<ffffffffa033d0be>]
>> btrfs_search_old_slot+0x63e/0x940 [btrfs]
>> [ 2092.257982]  RSP <ffff88003752f598>
>> [ 2092.257982] CR2: 00000000000003c4
>> [ 2092.340821] ---[ end trace 25df2cb40c31fa55 ]---
>>
>> I presume this is because of the partial failure before the crash, but
>> I was expecting btrfs to recover. Can you pls check?
>>
>> Thanks
>>
>> --Shyam
>>
>> On Tue, Feb 12, 2013 at 12:55 PM, shyam btrfs <shyam.btrfs@gmail.com> wrote:
>>> Hi Arne, Jan,
>>>
>>> I am using btrfs directly from Linux 3.8rc5 (commit
>>> 949db153b6466c6f7cad5a427ecea94985927311). I am trying to use qgroups
>>> functionality & with a basic random-write workload, it constantly
>>> keeps leaking memory & within few minutes of IO, there is either
>>> out-of-memory killer trying to kill some tasks or there are
>>> page-allocation failures that btrfs or other kernel module
>>> experiences.
>>>
>>> This issue is consistently reproducible & to do that this is what I do:
>>> # mkfs.btrfs on a blockdevice
>>> # mount with "rw,noatime,nodatasum,nodatacow,nospace_cache"  options
>>> # btrfs quota enable /mntpoint
>>> # btrfs qgroup create 100 /mntpoint
>>> # I setup a subvolume under the mountpoint & fallocate a file of fixed size.
>>> # Perform 4K write random IO with 4 worker threads with the
>>> application opening with O_SYNC flag (i.e. there is a fsync() after
>>> each write). To do this I am exposing the fallocate'd file as a SCST
>>> iSCSI target lun & doing IO's, but I presume this can be easily
>>> reproduced with any other IO generator.
>>>
>>> I confirmed that if I dont do quota enable/qgroup create, I don't run
>>> into this issue. So there is somewhere a memory leak with quota-group.
>>>
>>> Below is one stack trace where qgroup accounting code runs into
>>> allocation failure.
>>>
>>> [ 5123.800178] btrfs-endio-wri: page allocation failure: order:0, mode:0x20
>>> [ 5123.800188] Pid: 27508, comm: btrfs-endio-wri Tainted: GF
>>> O 3.8.0-030800rc5-generic #201301251535
>>> [ 5123.800190] Call Trace:
>>> [ 5123.800204]  [<ffffffff8113a656>] warn_alloc_failed+0xf6/0x150
>>> [ 5123.800208]  [<ffffffff8113e28e>] __alloc_pages_nodemask+0x76e/0x9b0
>>> [ 5123.800213]  [<ffffffff81182945>] ? new_slab+0x125/0x1a0
>>> [ 5123.800216]  [<ffffffff81185c2c>] ? kmem_cache_alloc+0x11c/0x140
>>> [ 5123.800221]  [<ffffffff8117a66a>] alloc_pages_current+0xba/0x170
>>> [ 5123.800239]  [<ffffffffa055f794>] btrfs_clone_extent_buffer+0x64/0xe0 [btrfs]
>>> [ 5123.800245]  [<ffffffffa051fb33>] btrfs_search_old_slot+0xb3/0x940 [btrfs]
>>> [ 5123.800252]  [<ffffffff810f78f7>] ? call_rcu_sched+0x17/0x20
>>> [ 5123.800263]  [<ffffffffa055849e>] ?
>>> release_extent_buffer.isra.26+0x5e/0xf0 [btrfs]
>>> [ 5123.800273]  [<ffffffffa055da17>] ? free_extent_buffer+0x37/0x90 [btrfs]
>>> [ 5123.800280]  [<ffffffffa0522d5d>] btrfs_next_old_leaf+0xed/0x450 [btrfs]
>>> [ 5123.800290]  [<ffffffffa05955b4>] __resolve_indirect_refs+0x334/0x620 [btrfs]
>>> [ 5123.800301]  [<ffffffffa059616a>] find_parent_nodes+0x7da/0xf90 [btrfs]
>>> [ 5123.800311]  [<ffffffffa05969b9>] btrfs_find_all_roots+0x99/0x100 [btrfs]
>>> [ 5123.800313]  [<ffffffff81183beb>] ? kfree+0x3b/0x150
>>> [ 5123.800323]  [<ffffffffa059991b>] btrfs_qgroup_account_ref+0xfb/0x550 [btrfs]
>>> [ 5123.800325]  [<ffffffff81183beb>] ? kfree+0x3b/0x150
>>> [ 5123.800332]  [<ffffffffa05290d3>]
>>> btrfs_delayed_refs_qgroup_accounting+0xa3/0x100 [btrfs]
>>> [ 5123.800341]  [<ffffffffa0540941>] __btrfs_end_transaction+0x81/0x410 [btrfs]
>>> [ 5123.800349]  [<ffffffffa052b646>] ?
>>> btrfs_delalloc_release_metadata+0x106/0x180 [btrfs]
>>> [ 5123.800358]  [<ffffffffa0540d20>] btrfs_end_transaction+0x10/0x20 [btrfs]
>>> [ 5123.800367]  [<ffffffffa054965d>] btrfs_finish_ordered_io+0x10d/0x3d0 [btrfs]
>>> [ 5123.800374]  [<ffffffff8106a3a0>] ? cascade+0xa0/0xa0
>>> [ 5123.800384]  [<ffffffffa0549935>] finish_ordered_fn+0x15/0x20 [btrfs]
>>> [ 5123.800394]  [<ffffffffa056ac2f>] worker_loop+0x16f/0x5d0 [btrfs]
>>> [ 5123.800401]  [<ffffffff810888a8>] ? __wake_up_common+0x58/0x90
>>> [ 5123.800411]  [<ffffffffa056aac0>] ? btrfs_queue_worker+0x310/0x310 [btrfs]
>>> [ 5123.800415]  [<ffffffff8107f080>] kthread+0xc0/0xd0
>>> [ 5123.800417]  [<ffffffff8107efc0>] ? flush_kthread_worker+0xb0/0xb0
>>> [ 5123.800423]  [<ffffffff816f452c>] ret_from_fork+0x7c/0xb0
>>> [ 5123.800425]  [<ffffffff8107efc0>] ? flush_kthread_worker+0xb0/0xb0
>>>
>>> I have attached meminfo/slabinfo that I peridically captured before
>>> running the test & while the test was going through. Also attached are
>>> sysrq outputs + debug-tree output after the problem happened.
>>>
>>> Can you pls check whats happening with quota-groups? Thanks.
>>>
>>> --Shyam
>>>
>>>
>>> Immediately after the allocation failure, there is this panic
>>> [ 5123.811593] ------------[ cut here ]------------
>>> [ 5123.813996] Kernel BUG at ffffffffa055f7f7 [verbose debug info unavailable]
>>> [ 5123.815286] invalid opcode: 0000 [#1] SMP
>>> [ 5123.816131] Modules linked in: btrfs(OF) raid1 xt_multiport
>>> xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
>>> iptable_filter ip_tables x_tables iscsi_tcp libiscsi_tcp libiscsi
>>> scsi_transport_iscsi xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp
>>> esp4 ah4 8021q garp stp llc bonding deflate zlib_deflate ctr
>>> twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common
>>> camellia_generic camellia_x86_64 serpent_sse2_x86_64 glue_helper lrw
>>> serpent_generic xts gf128mul blowfish_generic blowfish_x86_64
>>> blowfish_common ablk_helper cryptd cast5_generic cast_common
>>> des_generic xcbc rmd160 crypto_null af_key xfrm_algo scst_vdisk(OF)
>>> iscsi_scst(OF) scst(OF) libcrc32c microcode psmouse nfsv4
>>> virtio_balloon serio_raw nfsd(OF) nfs_acl auth_rpcgss nfs fscache
>>> lockd sunrpc lp parport ixgbevf floppy [last unloaded: btrfs]
>>> [ 5123.831906] CPU 0
>>> [ 5123.832291] Pid: 27508, comm: btrfs-endio-wri Tainted: GF
>>> O 3.8.0-030800rc5-generic #201301251535 Bochs Bochs
>>> [ 5123.834339] RIP: 0010:[<ffffffffa055f7f7>]  [<ffffffffa055f7f7>]
>>> btrfs_clone_extent_buffer+0xc7/0xe0 [btrfs]
>>> [ 5123.836223] RSP: 0018:ffff880018ceb858  EFLAGS: 00010246
>>> [ 5123.837229] RAX: 0000000000000000 RBX: ffff880000fee408 RCX: ffffffff81e2f4c0
>>> [ 5123.838549] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000246
>>> [ 5123.839869] RBP: ffff880018ceb888 R08: 000000000000000a R09: 0000000000000000
>>> [ 5123.841234] R10: 0000000000000000 R11: 00000000000002e7 R12: ffff8800079dc408
>>> [ 5123.842558] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
>>> [ 5123.843879] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000)
>>> knlGS:0000000000000000
>>> [ 5123.845414] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> [ 5123.846482] CR2: 0000000000df0c68 CR3: 0000000025189000 CR4: 00000000000006f0
>>> [ 5123.847806] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [ 5123.849171] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> [ 5123.850509] Process btrfs-endio-wri (pid: 27508, threadinfo
>>> ffff880018cea000, task ffff88003b915d00)
>>> [ 5123.852221] Stack:
>>> [ 5123.852615]  ffff880018ceb888 ffff880023223800 ffff88003b7b2680
>>> ffff880017ee06c0
>>> [ 5123.854093]  ffff8800079dc408 ffff88003b7b2680 ffff880018ceb928
>>> ffffffffa051fb33
>>> [ 5123.855563]  ffff880018ceb8a8 ffffffff810f78f7 ffff880018ceb8d8
>>> ffffffffa055849e
>>> [ 5123.857069] Call Trace:
>>> [ 5123.857554]  [<ffffffffa051fb33>] btrfs_search_old_slot+0xb3/0x940 [btrfs]
>>> [ 5123.858842]  [<ffffffff810f78f7>] ? call_rcu_sched+0x17/0x20
>>> [ 5123.859911]  [<ffffffffa055849e>] ?
>>> release_extent_buffer.isra.26+0x5e/0xf0 [btrfs]
>>> [ 5123.861388]  [<ffffffffa055da17>] ? free_extent_buffer+0x37/0x90 [btrfs]
>>> [ 5123.862646]  [<ffffffffa0522d5d>] btrfs_next_old_leaf+0xed/0x450 [btrfs]
>>> [ 5123.863910]  [<ffffffffa05955b4>] __resolve_indirect_refs+0x334/0x620 [btrfs]
>>> [ 5123.865299]  [<ffffffffa059616a>] find_parent_nodes+0x7da/0xf90 [btrfs]
>>> [ 5123.866542]  [<ffffffffa05969b9>] btrfs_find_all_roots+0x99/0x100 [btrfs]
>>> [ 5123.867807]  [<ffffffff81183beb>] ? kfree+0x3b/0x150
>>> [ 5123.868792]  [<ffffffffa059991b>] btrfs_qgroup_account_ref+0xfb/0x550 [btrfs]
>>> [ 5123.870121]  [<ffffffff81183beb>] ? kfree+0x3b/0x150
>>> [ 5123.871058]  [<ffffffffa05290d3>]
>>> btrfs_delayed_refs_qgroup_accounting+0xa3/0x100 [btrfs]
>>> [ 5123.873030]  [<ffffffffa0540941>] __btrfs_end_transaction+0x81/0x410 [btrfs]
>>> [ 5123.874370]  [<ffffffffa052b646>] ?
>>> btrfs_delalloc_release_metadata+0x106/0x180 [btrfs]
>>> [ 5123.875874]  [<ffffffffa0540d20>] btrfs_end_transaction+0x10/0x20 [btrfs]
>>> [ 5123.877200]  [<ffffffffa054965d>] btrfs_finish_ordered_io+0x10d/0x3d0 [btrfs]
>>> [ 5123.878484]  [<ffffffff8106a3a0>] ? cascade+0xa0/0xa0
>>> [ 5123.879405]  [<ffffffffa0549935>] finish_ordered_fn+0x15/0x20 [btrfs]
>>> [ 5123.880602]  [<ffffffffa056ac2f>] worker_loop+0x16f/0x5d0 [btrfs]
>>> [ 5123.881713]  [<ffffffff810888a8>] ? __wake_up_common+0x58/0x90
>>> [ 5123.882771]  [<ffffffffa056aac0>] ? btrfs_queue_worker+0x310/0x310 [btrfs]
>>> [ 5123.883995]  [<ffffffff8107f080>] kthread+0xc0/0xd0
>>> [ 5123.884913]  [<ffffffff8107efc0>] ? flush_kthread_worker+0xb0/0xb0
>>> [ 5123.886018]  [<ffffffff816f452c>] ret_from_fork+0x7c/0xb0
>>> [ 5123.886986]  [<ffffffff8107efc0>] ? flush_kthread_worker+0xb0/0xb0
>>> [ 5123.888108] Code: 31 c9 31 d2 4c 89 e6 48 89 df e8 25 fe ff ff 3e
>>> 80 4b 20 01 3e 80 4b 21 02 48 83 c4 08 48 89 d8 5b 41 5c 41 5d 41 5e
>>> 41 5f 5d c3 <0f> 0b be e8 0f 00 00 48 c7 c7 10 f3 5a a0 e8 e6 a1 af e0
>>> eb a2
>>> [ 5123.893000] RIP  [<ffffffffa055f7f7>]
>>> btrfs_clone_extent_buffer+0xc7/0xe0 [btrfs]
>>> [ 5123.894379]  RSP <ffff880018ceb858>
>>> [ 5123.906866] ---[ end trace b96bd164e48cd6de ]---
>>> [ 5123.911681] Kernel panic - not syncing: Fatal exception
>>> [ 5123.932069]
>>> [ 5123.933520] SysRq : Show Memory
>>> [ 5123.934156] Mem-Info:
>>> [ 5123.934607] Node 0 DMA per-cpu:
>>> [ 5123.935240] CPU    0: hi:    0, btch:   1 usd:   0
>>> [ 5123.936021] Node 0 DMA32 per-cpu:
>>> [ 5123.936021] CPU    0: hi:  186, btch:  31 usd: 167
>>> [ 5123.936021] active_anon:24384 inactive_anon:89 isolated_anon:0
>>> [ 5123.936021]  active_file:30846 inactive_file:30865 isolated_file:0
>>> [ 5123.936021]  unevictable:4053 dirty:553 writeback:0 unstable:0
>>> [ 5123.936021]  free:17219 slab_reclaimable:8648 slab_unreclaimable:4167
>>> [ 5123.936021]  mapped:10630 shmem:148 pagetables:1921 bounce:0
>>> [ 5123.936021]  free_cma:0
>>> [ 5123.936021] Node 0 DMA free:4268kB min:680kB low:848kB high:1020kB
>>> active_anon:8kB inactive_anon:0kB active_file:1152kB
>>> inactive_file:1228kB unevictable:0kB isolated(anon):0kB
>>> isolated(file):0kB present:15636kB managed:15892kB mlocked:0kB
>>> dirty:8kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:260kB
>>> slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB
>>> bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
>>> all_unreclaimable? no
>>> [ 5123.936021] lowmem_reserve[]: 0 992 992 992
>>> [ 5123.936021] Node 0 DMA32 free:64608kB min:44372kB low:55464kB
>>> high:66556kB active_anon:97528kB inactive_anon:356kB
>>> active_file:122232kB inactive_file:122232kB unevictable:16212kB
>>> isolated(anon):0kB isolated(file):0kB present:1016052kB
>>> managed:991296kB mlocked:16212kB dirty:2204kB writeback:0kB
>>> mapped:42520kB shmem:592kB slab_reclaimable:34332kB
>>> slab_unreclaimable:16668kB kernel_stack:2704kB pagetables:7684kB
>>> unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
>>> pages_scanned:14 all_unreclaimable? no
>>> [ 5123.936021] lowmem_reserve[]: 0 0 0 0
>>> [ 5123.936021] Node 0 DMA: 1*4kB (E) 5*8kB (UE) 2*16kB (UE) 5*32kB
>>> (UE) 13*64kB (UE) 9*128kB (UE) 0*256kB 0*512kB 0*1024kB 1*2048kB (R)
>>> 0*4096kB = 4268kB
>>> [ 5123.936021] Node 0 DMA32: 4194*4kB (UEM) 1927*8kB (UEM) 245*16kB
>>> (UEM) 139*32kB (UEM) 74*64kB (UEM) 41*128kB (UEM) 25*256kB (UM)
>>> 5*512kB (M) 1*1024kB (M) 0*2048kB 1*4096kB (R) = 64624kB
>>> [ 5123.936021] 62932 total pagecache pages
>>> [ 5123.936021] 0 pages in swap cache
>>> [ 5123.936021] Swap cache stats: add 0, delete 0, find 0/0
>>> [ 5123.936021] Free swap  = 0kB
>>> [ 5123.936021] Total swap = 0kB
>>> [ 5123.936021] 262125 pages RAM
>>> [ 5123.936021] 7460 pages reserved
>>> [ 5123.936021] 340761 pages shared
>>> [ 5123.936021] 193374 pages non-shared
>>> [ 5123.978133]
>
