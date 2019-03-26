Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7546EC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 15:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3001D20823
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 15:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731905AbfCZPaJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:30:09 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38154 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731491AbfCZPaJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 11:30:09 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 6250A27DD36; Tue, 26 Mar 2019 11:30:08 -0400 (EDT)
Date:   Tue, 26 Mar 2019 11:30:08 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: BUG: workqueue lockup - pool cpus=0-3 flags=0x4 nice=0 stuck for
 20915s! (on 4.20+)
Message-ID: <20190326153007.GJ16651@hungrycats.org>
References: <20190326025028.GG16651@hungrycats.org>
 <20190326043005.GH16651@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190326043005.GH16651@hungrycats.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 12:30:07AM -0400, Zygo Blaxell wrote:
> On Mon, Mar 25, 2019 at 10:50:28PM -0400, Zygo Blaxell wrote:
> > Running balance, rsync, and dedupe, [...]
> > 
> > Mount options are:  flushoncommit,space_cache=v2,compress=zstd.

[snip]

The 5.0.4 test machine locked up overnight.  Userspace has been
unresponsive for 6 continuous hours, and the kernel is spewing these:

	[57659.907080] BUG: workqueue lockup - pool cpus=0-3 flags=0x4 nice=0 stuck for 20915s!
	[57659.908242] Showing busy workqueues and worker pools:
	[57659.908978] workqueue events: flags=0x0
	[57659.909549]   pwq 6: cpus=3 node=0 flags=0x0 nice=0 active=1/256
	[57659.910418]     pending: cache_reap
	[57659.910934]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256
	[57659.911805]     pending: cache_reap
	[57659.912321]   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=2/256
	[57659.913189]     pending: psi_update_work, cache_reap
	[57659.913919]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=7/256
	[57659.914786]     in-flight: 5391:cgroup1_release_agent, 5390:cgroup1_release_agent, 5387:cgroup1_release_agent, 5442:cgroup1_release_agent, 5388:cgroup1_release_agent, 23068:cgroup1_release_agent, 11703:cgroup1_release_agent
	[57659.917587] workqueue events_unbound: flags=0x2
	[57659.918254]   pwq 8: cpus=0-3 flags=0x4 nice=0 active=12/512
	[57659.919074]     pending: flush_to_ldisc, flush_to_ldisc, flush_to_ldisc, flush_to_ldisc, call_usermodehelper_exec_work, call_usermodehelper_exec_work, call_usermodehelper_exec_work, call_usermodehelper_exec_work, call_usermodehelper_exec_work, call_usermodehelper_exec_work, call_usermodehelper_exec_work, flush_to_ldisc
	[57659.923001] workqueue events_power_efficient: flags=0x80
	[57659.923760]   pwq 6: cpus=3 node=0 flags=0x0 nice=0 active=1/256
	[57659.924608]     pending: sync_hw_clock
	[57659.925153]   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=2/256
	[57659.926006]     pending: neigh_periodic_work, check_lifetime
	[57659.926814] workqueue events_freezable_power_: flags=0x84
	[57659.927579]   pwq 6: cpus=3 node=0 flags=0x0 nice=0 active=1/256
	[57659.928433]     pending: disk_events_workfn
	[57659.929040] workqueue mm_percpu_wq: flags=0x8
	[57659.929662]   pwq 6: cpus=3 node=0 flags=0x0 nice=0 active=1/256
	[57659.930516]     pending: vmstat_update
	[57659.931059]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256
	[57659.931908]     pending: vmstat_update
	[57659.932448]   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=1/256
	[57659.933301]     pending: vmstat_update
	[57659.933845] workqueue writeback: flags=0x4e
	[57659.934444]   pwq 8: cpus=0-3 flags=0x4 nice=0 active=3/256
	[57659.935239]     in-flight: 22897:wb_workfn
	[57659.935827]     pending: wb_workfn, wb_workfn
	[57659.936453] workqueue kblockd: flags=0x18
	[57659.937030]   pwq 7: cpus=3 node=0 flags=0x0 nice=-20 active=2/256
	[57659.937903]     pending: blk_mq_timeout_work, blk_mq_timeout_work
	[57659.938770]   pwq 3: cpus=1 node=0 flags=0x0 nice=-20 active=2/256
	[57659.939639]     pending: blk_mq_timeout_work, blk_mq_timeout_work
	[57659.940508] workqueue ipv6_addrconf: flags=0x40008
	[57659.941196]   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=1/1
	[57659.942021]     pending: addrconf_verify_work [ipv6]
	[57659.942738] workqueue dm_bufio_cache: flags=0x8
	[57659.943389]   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=1/256
	[57659.944240]     pending: work_fn [dm_bufio]
	[57659.944845] workqueue dm-cache: flags=0x8
	[57659.945421]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256
	[57659.946271]     pending: do_waker [dm_cache]
	[57659.946887] workqueue kcopyd: flags=0x8
	[57659.947440]   pwq 6: cpus=3 node=0 flags=0x0 nice=0 active=1/256
	[57659.948291]     pending: do_work [dm_mod]
	[57659.948875] workqueue btrfs-delalloc: flags=0xe
	[57659.949521]   pwq 8: cpus=0-3 flags=0x4 nice=0 active=6/6
	[57659.950289]     pending: btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper
	[57659.952299]     delayed: btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper
	[57659.952320] , btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper, btrfs_delalloc_helper
	[57659.970678] workqueue btrfs-endio-meta: flags=0xe
	[57659.971355]   pwq 8: cpus=0-3 flags=0x4 nice=0 active=1/6
	[57659.972126]     pending: btrfs_endio_meta_helper
	[57659.972793] pool 0: cpus=0 node=0 flags=0x0 nice=0 hung=0s workers=9 idle: 5587 5389
	[57659.973893] pool 8: cpus=0-3 flags=0x4 nice=0 hung=20915s workers=17 idle: 32317 28343 27652 5842 2072 8322 26565 12095 13036 31394 23436 28378 9538 13699 946 3001
	[57668.083089] watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [crawl_259:4967]
	[57668.084148] Modules linked in: ppdev joydev crct10dif_pclmul crc32_pclmul dm_cache_smq crc32c_intel ghash_clmulni_intel dm_cache dm_persistent_data dm_bio_prison dm_bufio dm_mod rtc_cmos floppy parport_pc parport aesni_intel sr_mod cdrom aes_x86_64 crypto_simd cryptd glue_helper sg ide_pci_generic piix ide_core evbug evdev bochs_drm i2c_piix4 input_leds psmouse serio_raw snd_pcm snd_timer snd soundcore pcspkr qemu_fw_cfg ip_tables x_tables ipv6 crc_ccitt autofs4
	[57668.089852] irq event stamp: 2528136198
	[57668.090402] hardirqs last  enabled at (2528136197): [<ffffffffaad5f339>] _raw_spin_unlock_irq+0x29/0x40
	[57668.091721] hardirqs last disabled at (2528136198): [<ffffffffaad57955>] __schedule+0xd5/0xb60
	[57668.092934] softirqs last  enabled at (2528134802): [<ffffffffab0003a4>] __do_softirq+0x3a4/0x45f
	[57668.094178] softirqs last disabled at (2528134793): [<ffffffffaa0a3d24>] irq_exit+0xe4/0xf0
	[57668.095357] CPU: 1 PID: 4967 Comm: crawl_259 Tainted: G      D W    L    5.0.4-zb64-303ce93b05c9+ #1
	[57668.096635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
	[57668.097813] RIP: 0010:native_safe_halt+0x2/0x10
	[57668.098458] Code: 55 ff ff ff 7f c3 65 48 8b 04 25 00 6e 01 00 f0 80 48 02 20 48 8b 00 a8 08 74 8c eb c2 f3 c3 90 90 90 90 90 90 90 90 90 fb f4 <c3> 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 f4 c3 90 90 90 90 90 90
	[57668.100062] watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [crawl_259:4964]
	[57668.101072] RSP: 0018:ffffabb981517780 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
	[57668.102091] Modules linked in: ppdev joydev crct10dif_pclmul crc32_pclmul dm_cache_smq crc32c_intel ghash_clmulni_intel dm_cache dm_persistent_data dm_bio_prison dm_bufio dm_mod rtc_cmos floppy parport_pc parport aesni_intel sr_mod cdrom aes_x86_64 crypto_simd cryptd glue_helper sg ide_pci_generic piix ide_core evbug evdev bochs_drm i2c_piix4 input_leds psmouse serio_raw snd_pcm snd_timer snd soundcore pcspkr qemu_fw_cfg ip_tables x_tables ipv6 crc_ccitt autofs4
	[57668.103158] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000008
	[57668.103159] RDX: ffff93942b9d0000 RSI: 0000000000000000 RDI: ffffffffaa075ed1
	[57668.108770] irq event stamp: 2284123572
	[57668.109776] RBP: ffff93946dd796a4 R08: 0000000000000000 R09: 000000000000000c
	[57668.110769] hardirqs last  enabled at (2284123571): [<ffffffffaad5f339>] _raw_spin_unlock_irq+0x29/0x40
	[57668.111315] R10: ffffabb981517790 R11: ffff93946dd796b8 R12: 0000000000000246
	[57668.112308] hardirqs last disabled at (2284123572): [<ffffffffaad57955>] __schedule+0xd5/0xb60
	[57668.112309] softirqs last  enabled at (2284121412): [<ffffffffab0003a4>] __do_softirq+0x3a4/0x45f
	[57668.113626] R13: 0000000000000100 R14: 0000000000000000 R15: 0000000000080000
	[57668.113627] FS:  00007f51867fc700(0000) GS:ffff939476000000(0000) knlGS:0000000000000000
	[57668.114622] softirqs last disabled at (2284121403): [<ffffffffaa0a3d24>] irq_exit+0xe4/0xf0
	[57668.114623] CPU: 3 PID: 4964 Comm: crawl_259 Tainted: G      D W    L    5.0.4-zb64-303ce93b05c9+ #1
	[57668.115834] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[57668.117036] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
	[57668.118032] CR2: 00007f262a484300 CR3: 00000001ef54e001 CR4: 00000000001606e0
	[57668.118034] Call Trace:
	[57668.119254] RIP: 0010:queued_write_lock_slowpath+0x4c/0x80
	[57668.120427]  kvm_wait+0x86/0x90
	[57668.121695] Code: ba ff 00 00 00 f0 0f b1 13 85 c0 74 34 f0 81 03 00 01 00 00 b9 ff 00 00 00 be 00 01 00 00 8b 13 81 fa 00 01 00 00 74 0c f3 90 <8b> 13 81 fa 00 01 00 00 75 f4 89 f0 f0 0f b1 0b 3d 00 01 00 00 75
	[57668.122507]  __pv_queued_spin_lock_slowpath+0x256/0x290
	[57668.123663] RSP: 0018:ffffabb9814ffb58 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
	[57668.124672]  queued_read_lock_slowpath+0x6c/0x70
	[57668.125027] RAX: 0000000000000400 RBX: ffff93946dd796a0 RCX: 00000000000000ff
	[57668.125028] RDX: 0000000000000500 RSI: 0000000000000100 RDI: ffff93946dd796a0
	[57668.125809]  _raw_read_lock+0x55/0x70
	[57668.126254] RBP: ffff93946dd796a4 R08: ffffffffaa46954b R09: 0000000000000000
	[57668.126255] R10: ffffabb9814ffb10 R11: ffff93946dd796b8 R12: ffff93946dd796a0
	[57668.128883]  __tree_mod_log_search+0x28/0xa0
	[57668.129613] R13: ffff93946dd79640 R14: ffffabb98b26d000 R15: ffff93946dd78000
	[57668.129615] FS:  00007f5187fff700(0000) GS:ffff939476800000(0000) knlGS:0000000000000000
	[57668.130683]  __tree_mod_log_oldest_root.isra.1+0x47/0x70
	[57668.131332] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[57668.131334] CR2: 00007f419a9face0 CR3: 00000001ef54e004 CR4: 00000000001606e0
	[57668.132341]  btrfs_search_old_slot+0x7f/0x820
	[57668.133336] Call Trace:
	[57668.133865]  btrfs_next_old_leaf+0xfe/0x430
	[57668.134858]  do_raw_write_lock+0xa9/0xb0
	[57668.135866]  resolve_indirect_refs+0x4e4/0x960
	[57668.136464]  _raw_write_lock+0x52/0x70
	[57668.137501]  find_parent_nodes+0x41d/0x1210
	[57668.138595]  btrfs_get_tree_mod_seq+0x2b/0xb0
	[57668.139354]  ? btrfs_inode_flags_to_fsflags+0x80/0x80
	[57668.140293]  ? btrfs_inode_flags_to_fsflags+0x80/0x80
	[57668.141339]  iterate_extent_inodes+0x119/0x3c0
	[57668.141959]  iterate_extent_inodes+0xbd/0x3c0
	[57668.142320]  ? iterate_inodes_from_logical+0xa6/0xd0
	[57668.143197]  ? free_extent_buffer+0x46/0x90
	[57668.143773]  iterate_inodes_from_logical+0xa6/0xd0
	[57668.144406]  ? iterate_inodes_from_logical+0xa6/0xd0
	[57668.145051]  ? btrfs_inode_flags_to_fsflags+0x80/0x80
	[57668.145643]  iterate_inodes_from_logical+0xa6/0xd0
	[57668.146267]  btrfs_ioctl_logical_to_ino+0xe8/0x190
	[57668.146983]  ? btrfs_inode_flags_to_fsflags+0x80/0x80
	[57668.146985]  btrfs_ioctl_logical_to_ino+0xe8/0x190
	[57668.146987]  btrfs_ioctl+0xcf7/0x2cb0
	[57668.146990]  ? get_task_mm+0x1b/0x50
	[57668.146993]  ? lock_acquire+0xbc/0x1c0
	[57668.146997]  ? do_vfs_ioctl+0xa2/0x6f0
	[57668.146998]  ? btrfs_ioctl_get_supported_features+0x30/0x30
	[57668.146999]  do_vfs_ioctl+0xa2/0x6f0
	[57668.147001]  ? __fget+0x11f/0x210
	[57668.147003]  ksys_ioctl+0x70/0x80
	[57668.147005]  __x64_sys_ioctl+0x16/0x20
	[57668.147007]  do_syscall_64+0x60/0x190
	[57668.147010]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
	[57668.147012] RIP: 0033:0x7f518d7fd777
	[57668.147013] Code: 00 00 90 48 8b 05 19 a7 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e9 a6 0c 00 f7 d8 64 89 01 48
	[57668.147014] RSP: 002b:00007f5187ffc458 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
	[57668.147015] RAX: ffffffffffffffda RBX: 00007f5187ffc780 RCX: 00007f518d7fd777
	[57668.147016] RDX: 00007f5187ffc788 RSI: 00000000c038943b RDI: 0000000000000004
	[57668.147017] RBP: 0000000001000000 R08: 0000000000000000 R09: 00007f5187ffc960
	[57668.147018] R10: 000055ebc655ec60 R11: 0000000000000246 R12: 0000000000000004
	[57668.147018] R13: 00007f5187ffc788 R14: 00007f5187ffc668 R15: 00007f5187ffc890
	[57668.171643]  btrfs_ioctl+0xcf7/0x2cb0
	[57668.172170]  ? __lock_acquire+0x477/0x1b30
	[57668.172759]  ? do_vfs_ioctl+0xa2/0x6f0
	[57668.173296]  ? btrfs_ioctl_get_supported_features+0x30/0x30
	[57668.174086]  do_vfs_ioctl+0xa2/0x6f0
	[57668.174598]  ? __fget+0x11f/0x210
	[57668.175076]  ksys_ioctl+0x70/0x80
	[57668.175551]  __x64_sys_ioctl+0x16/0x20
	[57668.176089]  do_syscall_64+0x60/0x190
	[57668.176613]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
	[57668.177330] RIP: 0033:0x7f518d7fd777
	[57668.177846] Code: 00 00 90 48 8b 05 19 a7 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e9 a6 0c 00 f7 d8 64 89 01 48
	[57668.180448] RSP: 002b:00007f51867f9308 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
	[57668.181512] RAX: ffffffffffffffda RBX: 00007f51867f9630 RCX: 00007f518d7fd777
	[57668.182514] RDX: 00007f51867f9638 RSI: 00000000c038943b RDI: 0000000000000004
	[57668.183513] RBP: 0000000001000000 R08: 0000000000000000 R09: 00007f51867f9810
	[57668.184516] R10: 000055ebc655ec60 R11: 0000000000000246 R12: 0000000000000004
	[57668.185517] R13: 00007f51867f9638 R14: 00007f51867f9518 R15: 00007f51867f9740
	[57676.091103] watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [btrfs:24558]
	[57676.092121] Modules linked in: ppdev joydev crct10dif_pclmul crc32_pclmul dm_cache_smq crc32c_intel ghash_clmulni_intel dm_cache dm_persistent_data dm_bio_prison dm_bufio dm_mod rtc_cmos floppy parport_pc parport aesni_intel sr_mod cdrom aes_x86_64 crypto_simd cryptd glue_helper sg ide_pci_generic piix ide_core evbug evdev bochs_drm i2c_piix4 input_leds psmouse serio_raw snd_pcm snd_timer snd soundcore pcspkr qemu_fw_cfg ip_tables x_tables ipv6 crc_ccitt autofs4
	[57676.097700] irq event stamp: 1719174273
	[57676.098239] hardirqs last  enabled at (1719174273): [<ffffffffaa2bd47e>] kmem_cache_alloc+0x1fe/0x310
	[57676.099514] hardirqs last disabled at (1719174272): [<ffffffffaa2bd335>] kmem_cache_alloc+0xb5/0x310
	[57676.100797] softirqs last  enabled at (1719173992): [<ffffffffab0003a4>] __do_softirq+0x3a4/0x45f
	[57676.102037] softirqs last disabled at (1719173985): [<ffffffffaa0a3d24>] irq_exit+0xe4/0xf0
	[57676.103194] CPU: 2 PID: 24558 Comm: btrfs Tainted: G      D W    L    5.0.4-zb64-303ce93b05c9+ #1
	[57676.104428] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
	[57676.105596] RIP: 0010:native_safe_halt+0x2/0x10
	[57676.106241] Code: 55 ff ff ff 7f c3 65 48 8b 04 25 00 6e 01 00 f0 80 48 02 20 48 8b 00 a8 08 74 8c eb c2 f3 c3 90 90 90 90 90 90 90 90 90 fb f4 <c3> 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 f4 c3 90 90 90 90 90 90
	[57676.108824] RSP: 0018:ffffabb982067730 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
	[57676.109884] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000001
	[57676.110871] RDX: ffff93925de1c000 RSI: 0000000000000000 RDI: ffffffffaa075ed1
	[57676.111870] RBP: ffff9394766159d4 R08: 0000000000000000 R09: 0000000000000000
	[57676.113277] R10: ffffabb982067750 R11: ffff93946dd796b8 R12: 0000000000000246
	[57676.114283] R13: ffff9394766159d4 R14: 0000000000000001 R15: 00000000000c0000
	[57676.115285] FS:  00007fe387cef8c0(0000) GS:ffff939476400000(0000) knlGS:0000000000000000
	[57676.116418] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[57676.117228] CR2: 0000559ff5ab4270 CR3: 0000000136df4005 CR4: 00000000001606e0
	[57676.118236] Call Trace:
	[57676.118586]  kvm_wait+0x86/0x90
	[57676.119130]  __pv_queued_spin_lock_slowpath+0x1db/0x290
	[57676.119874]  ? tree_mod_log_insert_root.isra.2+0x10e/0x350
	[57676.120644]  queued_write_lock_slowpath+0x7a/0x80
	[57676.121315]  do_raw_write_lock+0xa9/0xb0
	[57676.121877]  _raw_write_lock+0x52/0x70
	[57676.122410]  tree_mod_log_insert_root.isra.2+0x10e/0x350
	[57676.123163]  __btrfs_cow_block+0x42a/0x580
	[57676.123748]  btrfs_cow_block+0xe9/0x220
	[57676.124298]  replace_path.isra.18+0x43f/0x7a0
	[57676.124928]  merge_reloc_root+0x289/0x540
	[57676.125500]  merge_reloc_roots+0xdc/0x270
	[57676.126077]  relocate_block_group+0x17c/0x600
	[57676.126693]  btrfs_relocate_block_group+0x15b/0x260
	[57676.127377]  btrfs_relocate_chunk+0x46/0xf0
	[57676.127972]  btrfs_balance+0xa60/0x12b0
	[57676.128520]  btrfs_ioctl_balance+0x1a2/0x360
	[57676.129128]  btrfs_ioctl+0x17b5/0x2cb0
	[57676.129664]  ? kvm_sched_clock_read+0x14/0x30
	[57676.130282]  ? __handle_mm_fault+0x105e/0x1800
	[57676.130915]  ? do_raw_spin_unlock+0x49/0xc0
	[57676.131506]  ? _raw_spin_unlock+0x24/0x30
	[57676.132078]  ? __handle_mm_fault+0x105e/0x1800
	[57676.132707]  ? do_vfs_ioctl+0xa2/0x6f0
	[57676.133238]  ? btrfs_ioctl_get_supported_features+0x30/0x30
	[57676.134023]  do_vfs_ioctl+0xa2/0x6f0
	[57676.134532]  ? __do_page_fault+0x324/0x550
	[57676.135115]  ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
	[57676.135853]  ksys_ioctl+0x70/0x80
	[57676.136323]  __x64_sys_ioctl+0x16/0x20
	[57676.136858]  do_syscall_64+0x60/0x190
	[57676.137376]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
	[57676.138087] RIP: 0033:0x7fe387de2777
	[57676.138596] Code: 00 00 90 48 8b 05 19 a7 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e9 a6 0c 00 f7 d8 64 89 01 48
	[57676.141179] RSP: 002b:00007ffefbf583f8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
	[57676.142233] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe387de2777
	[57676.143228] RDX: 00007ffefbf58408 RSI: 00000000c4009420 RDI: 0000000000000003
	[57676.144224] RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000078
	[57676.145209] R10: fffffffffffffa4a R11: 0000000000000202 R12: 00007ffefbf59be2
	[57676.146205] R13: 0000000000000000 R14: 0000557caad01052 R15: 0000000000000000

I previously observed a lockup on earlier 5.0.x kernel test runs, so at
least the lockup isn't new in 5.0.4, but it has now happened multiple
times on 5.0 and 4.20 kernels, and crossed the repeatability threshold
for me to report it.

Soft lockups in iterate_inodes_from_logical are nothing new--they've
been happening since 4.0, and they're probably worth a separate thread
because that function gets called from lots of places in btrfs and its
extremely variable performance (7 orders of magnitude between slowest
and fastest run time) impacts almost everything in btrfs.  Here's a soft
lockup from some random production machine on 4.14.103 from the other day:

	[19831.313928] watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [crawl_5:10732]
	[19831.314985] Modules linked in: crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc joydev ppdev aesni_intel aes_x86_64 sr_mod crypto_simd snd_pcm glue_helper cdrom cryptd snd_timer snd soundcore sg input_leds psmouse ide_pci_generic pcspkr piix bcache serio_raw parport_pc floppy rtc_cmos evbug ide_core bochs_drm parport i2c_piix4 qemu_fw_cfg evdev ip_tables x_tables ipv6 crc_ccitt autofs4
	[19831.320084] irq event stamp: 0
	[19831.320534] hardirqs last  enabled at (0): [<          (null)>]           (null)
	[19831.321600] hardirqs last disabled at (0): [<ffffffffae08c77b>] copy_process.part.6+0x4fb/0x1eb0
	[19831.322856] softirqs last  enabled at (0): [<ffffffffae08c77b>] copy_process.part.6+0x4fb/0x1eb0
	[19831.324111] softirqs last disabled at (0): [<          (null)>]           (null)
	[19831.325169] CPU: 2 PID: 10732 Comm: crawl_5 Tainted: G        W    L  4.14.103-zb64+ #1
	[19831.326311] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
	[19831.327497] task: ffff8d6266ee8000 task.stack: ffff9c4dc96bc000
	[19831.328347] RIP: 0010:iterate_extent_inodes+0x1f9/0x3a0
	[19831.329101] RSP: 0018:ffff9c4dc96bfc50 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
	[19831.330183] RAX: 0000000000000000 RBX: 0000000000000983 RCX: ffff9c4dcc151000
	[19831.331205] RDX: 00000000ca52d620 RSI: 00000000006da000 RDI: 0000000000040d0c
	[19831.332224] RBP: ffff9c4dc96bfd00 R08: 00000000001ffffb R09: 0000000000000001
	[19831.333248] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffafa0a1c2
	[19831.334266] R13: ffffffffae472be0 R14: ffff9c4dcc151000 R15: ffff8d627e0c1ec0
	[19831.335287] FS:  00007f8cb27fc700(0000) GS:ffff8d62b8c00000(0000) knlGS:0000000000000000
	[19831.336443] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[19831.337256] CR2: 00007ff65c4867f0 CR3: 0000000126eb8001 CR4: 00000000001606e0
	[19831.338396] Call Trace:
	[19831.338748]  ? iterate_inodes_from_logical+0x96/0xb0
	[19831.339460]  iterate_inodes_from_logical+0x96/0xb0
	[19831.340141]  ? extent_same_check_offsets+0x60/0x60
	[19831.340820]  btrfs_ioctl_logical_to_ino+0xe8/0x190
	[19831.341503]  btrfs_ioctl+0xc5d/0x26a0
	[19831.342028]  ? lock_acquire+0xbc/0x200
	[19831.342566]  ? __might_fault+0x3e/0x90
	[19831.343108]  ? lock_acquire+0xbc/0x200
	[19831.343646]  ? do_vfs_ioctl+0x92/0x6b0
	[19831.344190]  ? btrfs_ioctl_get_supported_features+0x30/0x30
	[19831.344980]  do_vfs_ioctl+0x92/0x6b0
	[19831.345499]  ? __fget+0x11f/0x210
	[19831.345979]  SyS_ioctl+0x74/0x80
	[19831.346446]  do_syscall_64+0x76/0x180
	[19831.346967]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[19831.347682] RIP: 0033:0x7f8cb9769017
	[19831.348196] RSP: 002b:00007f8cb27f9478 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
	[19831.349264] RAX: ffffffffffffffda RBX: 00007f8cb27f97a0 RCX: 00007f8cb9769017
	[19831.350270] RDX: 00007f8cb27f97a8 RSI: 00000000c038943b RDI: 0000000000000003
	[19831.351272] RBP: 0000000001000000 R08: 0000000000000000 R09: 00007f8cb27f9980
	[19831.352272] R10: 000055d0f3857c60 R11: 0000000000000246 R12: 0000000000000003
	[19831.353280] R13: 00007f8cb27f97a8 R14: 00007f8cb27f9688 R15: 00007f8cb27f98b0
	[19831.354283] Code: 6f f6 05 a4 f7 55 01 04 0f 85 e6 00 00 00 48 8b 18 48 8b 45 80 49 c7 c4 c2 a1 a0 af 4c 8b 78 08 4d 85 ff 75 21 eb c8 49 8b 77 08 <4c> 89 f1 48 89 da 49 8b 3f e8 d9 87 b5 00 85 c0 75 41 4d 8b 7f 

and here's another one from an earlier 4.20.13 test run:

	[309224.545560] watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [crawl_5:4548]
	[309224.545563] Modules linked in: dm_cache_smq dm_cache dm_persistent_data dm_bio_prison dm_bufio dm_mod crct10dif_pclmul joydev ppdev crc32_pclmul snd_pcm crc32c_intel ghash_clmulni_intel sr_mod snd_timer snd cdrom sg aesni_intel aes_x86_64 soundcore crypto_simd cryptd glue_helper input_leds psmouse ide_pci_generic serio_raw bochs_drm piix ide_core i2c_piix4 pcspkr rtc_cmos parport_pc parport floppy evbug evdev qemu_fw_cfg ip_tables x_tables ipv6 crc_ccitt autofs4
	[309224.545594] irq event stamp: 4232596770
	[309224.545599] hardirqs last  enabled at (4232596769): [<ffffffff9923fd3b>] get_page_from_freelist+0x2db/0x1950
	[309224.545603] hardirqs last disabled at (4232596770): [<ffffffff9900379f>] trace_hardirqs_off_thunk+0x1a/0x1c
	[309224.545606] softirqs last  enabled at (4211556454): [<ffffffff9a0003a4>] __do_softirq+0x3a4/0x45f
	[309224.545609] softirqs last disabled at (4210205079): [<ffffffff990a2cb4>] irq_exit+0xe4/0xf0
	[309224.545613] CPU: 3 PID: 4548 Comm: crawl_5 Tainted: G             L    4.20.13-zb64+ #1
	[309224.545614] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
	[309224.545619] RIP: 0010:map_private_extent_buffer+0x79/0xd0
	[309224.545622] Code: 81 e3 00 f0 ff ff ba 00 10 00 00 49 29 db 31 db 4d 89 18 4a 8b 84 e7 a0 01 00 00 48 2b 05 3f a7 25 01 48 c1 f8 06 48 c1 e0 0c <48> 03 05 40 a7 25 01 48 01 d8 48 89 01 31 c0 49 89 11 5b 5d 41 5c
	[309224.545624] RSP: 0018:ffffac3d0188f7b0 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
	[309224.545626] RAX: 0000000011fe0000 RBX: 0000000000000000 RCX: ffffac3d0188f7d8
	[309224.545628] RDX: 0000000000001000 RSI: 000000000000380d RDI: ffffa0fa24362500
	[309224.545630] RBP: 0000000000004000 R08: ffffac3d0188f7e0 R09: ffffac3d0188f7e8
	[309224.545632] R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000003
	[309224.545633] R13: 0000000000003815 R14: 000000000000380d R15: 00000000000023ef
	[309224.545636] FS:  00007fd5ec9a1700(0000) GS:ffffa0fb39800000(0000) knlGS:0000000000000000
	[309224.545637] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[309224.545639] CR2: 00007fd5eda84fed CR3: 0000000164086001 CR4: 00000000001606e0
	[309224.545643] Call Trace:
	[309224.545652]  btrfs_set_token_64+0x109/0x130
	[309224.545663]  __tree_mod_log_rewind+0xef/0x210
	[309224.545669]  btrfs_search_old_slot+0x494/0x830
	[309224.545683]  btrfs_next_old_leaf+0xfe/0x430
	[309224.545697]  resolve_indirect_refs+0x4e4/0x960
	[309224.545717]  find_parent_nodes+0x41d/0x1210
	[309224.545745]  ? extent_same_check_offsets+0x60/0x60
	[309224.545749]  iterate_extent_inodes+0x119/0x3c0
	[309224.545769]  ? iterate_inodes_from_logical+0xa6/0xd0
	[309224.545772]  iterate_inodes_from_logical+0xa6/0xd0
	[309224.545776]  ? extent_same_check_offsets+0x60/0x60
	[309224.545785]  btrfs_ioctl_logical_to_ino+0xe8/0x190
	[309224.545792]  btrfs_ioctl+0xcf7/0x2cb0
	[309224.545801]  ? __lock_acquire+0x477/0x1b30
	[309224.545820]  ? do_vfs_ioctl+0xa2/0x6f0
	[309224.545823]  ? btrfs_ioctl_get_supported_features+0x30/0x30
	[309224.545825]  do_vfs_ioctl+0xa2/0x6f0
	[309224.545832]  ? __fget+0x11f/0x210
	[309224.545840]  ksys_ioctl+0x70/0x80
	[309224.545846]  __x64_sys_ioctl+0x16/0x20
	[309224.545849]  do_syscall_64+0x60/0x190
	[309224.545854]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
	[309224.545857] RIP: 0033:0x7fd5eda85017
	[309224.545862] Code: Bad RIP value.
	[309224.545864] RSP: 002b:00007fd5ec99e478 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
	[309224.545866] RAX: ffffffffffffffda RBX: 00007fd5ec99e7a0 RCX: 00007fd5eda85017
	[309224.545868] RDX: 00007fd5ec99e7a8 RSI: 00000000c038943b RDI: 0000000000000004
	[309224.545870] RBP: 0000000001000000 R08: 0000000000000000 R09: 00007fd5ec99e980
	[309224.545871] R10: 000056334558ec60 R11: 0000000000000246 R12: 0000000000000004
	[309224.545873] R13: 00007fd5ec99e7a8 R14: 00007fd5ec99e688 R15: 00007fd5ec99e8b0

Normally on kernels up to 4.19, these lockups were hours to months apart,
and recovery takes a minute or less.  Userspace barely notices, apart
from the spike in commit latency and having a core stuck in the kernel
for a few seconds or minutes.

The difference on 4.20 and 5.0.x is that the soft lockups now cripple
the machine, and they don't go away without external intervention.
