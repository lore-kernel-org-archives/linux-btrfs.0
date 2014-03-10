Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41679 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaCJW2U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 18:28:20 -0400
Date: Mon, 10 Mar 2014 22:28:01 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: send/receive locking
Message-ID: <20140310222801.GA6151@carfax.org.uk>
References: <20140308215350.GE6318@carfax.org.uk>
 <usnory0eq5h626p5eaeeh4ki.1394315749442@email.android.com>
 <20140308220027.GF6318@carfax.org.uk>
 <gm5l2kqc332h7w6arx688tf2.1394316159256@email.android.com>
 <20140308221652.GG6318@carfax.org.uk>
 <20140309164321.GI6318@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
In-Reply-To: <20140309164321.GI6318@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 09, 2014 at 04:43:21PM +0000, Hugo Mills wrote:
> On Sat, Mar 08, 2014 at 10:16:52PM +0000, Hugo Mills wrote:
> > On Sat, Mar 08, 2014 at 10:02:39PM +0000, Josef Bacik wrote:
> > > Don't do it on a fs you care about, cow is broken with that branch so it will corrupt your fs.  So actually just find Wang's patch that sets skip locking for send and do that.  Thanks,
> > 
> >    Aah, that's good to know. It's not an FS I care about massively
> > much, but it'd be a pain to recreate all the setup. I think I'll go
> > cherry picking tomorrow morning. :)
> 
>    OK, I'm running with btrfs-next, plus a cherry picked
> 
>     Btrfs: skip locking when searching commit root

   As requested on IRC, here's a second SysRq-w trace for
cross-reference. This is from running the same kernel as the previous
trace.

   I now have a new kernel and debug symbols built, and will do
another run with that one overnight.

   Hugo.

[14613.213188] BTRFS: device label flambeaux devid 1 transid 9852 /dev/mapper/flambeaux
[14613.217943] BTRFS info (device dm-0): disk space caching is enabled
[15029.515638] BTRFS: device label flambeaux devid 1 transid 9855 /dev/mapper/flambeaux
[15029.520703] BTRFS info (device dm-0): disk space caching is enabled
[15149.171735] BTRFS: device label flambeaux devid 1 transid 9858 /dev/mapper/flambeaux
[15149.176503] BTRFS info (device dm-0): disk space caching is enabled
[15265.202886] BTRFS: device label flambeaux devid 1 transid 9861 /dev/mapper/flambeaux
[15265.207321] BTRFS info (device dm-0): disk space caching is enabled
[15420.329775] bio: create slab <bio-2> at 2
[15420.715749] bio: create slab <bio-2> at 2
[15420.900726] BTRFS: device label flambeaux devid 1 transid 9862 /dev/dm-0
[15420.918482] BTRFS: device label flambeaux devid 1 transid 9862 /dev/mapper/flambeaux
[15420.922463] BTRFS info (device dm-0): disk space caching is enabled
[15420.943656] BTRFS: device label flambeaux devid 1 transid 9862 /dev/dm-0
[36421.678552] bio: create slab <bio-2> at 2
[36422.403670] bio: create slab <bio-2> at 2
[36422.594050] BTRFS: device label flambeaux devid 1 transid 9865 /dev/dm-0
[36422.608127] BTRFS: device label flambeaux devid 1 transid 9865 /dev/dm-0
[36422.614405] BTRFS: device label flambeaux devid 1 transid 9865 /dev/mapper/flambeaux
[36422.617686] BTRFS info (device dm-0): disk space caching is enabled
[104819.255050] bio: create slab <bio-2> at 2
[104819.706538] bio: create slab <bio-2> at 2
[104819.890243] BTRFS: device label flambeaux devid 1 transid 9868 /dev/dm-0
[104819.922908] BTRFS: device label flambeaux devid 1 transid 9868 /dev/mapper/flambeaux
[104819.926393] BTRFS info (device dm-0): disk space caching is enabled
[104819.947248] BTRFS: device label flambeaux devid 1 transid 9868 /dev/dm-0
[104822.093454] BTRFS: device label amelia devid 4 transid 240759 /dev/sdd2
[104852.026978] bio: create slab <bio-2> at 2
[104852.481069] bio: create slab <bio-2> at 2
[104852.667219] BTRFS: device label flambeaux devid 1 transid 9869 /dev/dm-0
[104852.684925] BTRFS: device label flambeaux devid 1 transid 9869 /dev/dm-0
[104852.687485] BTRFS: device label flambeaux devid 1 transid 9869 /dev/mapper/flambeaux
[104852.691499] BTRFS info (device dm-0): disk space caching is enabled
[104854.786045] BTRFS: device label amelia devid 4 transid 240760 /dev/sdd2
[111687.082328] SysRq : Show Blocked State
[111687.082427]   task                        PC stack   pid father
[111687.082441] btrfs-transacti D ffff88003dc92640     0   224      2 0x00000000
[111687.082453]  ffff88003ac46d00 0000000000000046 0000000000012640 ffff88003ac46d00
[111687.082461]  ffff88003ad75fd8 ffff88003c093d50 ffff88003b19d000 ffff88003a7ee000
[111687.082469]  ffff88003a4dc508 ffff88003a4dc4b0 0000000000000000 0000000000000000
[111687.082477] Call Trace:
[111687.082496]  [<ffffffff81158404>] ? btrfs_commit_transaction+0x306/0x808
[111687.082507]  [<ffffffff8105ebdc>] ? finish_wait+0x60/0x60
[111687.082516]  [<ffffffff81154c82>] ? transaction_kthread+0xd5/0x185
[111687.082524]  [<ffffffff81154bad>] ? btrfs_cleanup_transaction+0x3e3/0x3e3
[111687.082534]  [<ffffffff8104cede>] ? kthread+0x9e/0xa6
[111687.082543]  [<ffffffff81050000>] ? blocking_notifier_chain_cond_register+0x13/0x40
[111687.082551]  [<ffffffff8104ce40>] ? __kthread_parkme+0x55/0x55
[111687.082561]  [<ffffffff813a6ebc>] ? ret_from_fork+0x7c/0xb0
[111687.082569]  [<ffffffff8104ce40>] ? __kthread_parkme+0x55/0x55
[111687.082577] syslog-ng       D ffff88003dc92640     0  1995   1994 0x00000000
[111687.082587]  ffff88003b2fdf60 0000000000000086 0000000000012640 ffff88003b2fdf60
[111687.082594]  ffff880038d1dfd8 ffff88003c093d50 ffff88003a4dc4b0 ffff88003b3441e8
[111687.082601]  0000000000000000 0000000000000000 ffff88003b344000 ffff88003a7ff320
[111687.082609] Call Trace:
[111687.082618]  [<ffffffff81157a0c>] ? wait_current_trans.isra.19+0xad/0xd1
[111687.082626]  [<ffffffff8105ebdc>] ? finish_wait+0x60/0x60
[111687.082634]  [<ffffffff81158bf2>] ? start_transaction+0x2ec/0x4c5
[111687.082643]  [<ffffffff8114e66a>] ? btrfs_lookup_xattr+0x68/0x97
[111687.082653]  [<ffffffff8115cf27>] ? btrfs_dirty_inode+0x25/0xa1
[111687.082661]  [<ffffffff81160a4f>] ? btrfs_setattr+0x230/0x267
[111687.082670]  [<ffffffff810f39b8>] ? notify_change+0x20c/0x2ef
[111687.082679]  [<ffffffff810dec32>] ? chown_common.isra.16+0xc9/0x12e
[111687.082687]  [<ffffffff810e26a4>] ? __sb_start_write+0x8e/0xbb
[111687.082697]  [<ffffffff810df6ef>] ? SyS_fchown+0x47/0x6d
[111687.082705]  [<ffffffff813a6f66>] ? system_call_fastpath+0x1a/0x1f
[111687.082712] mosquitto       D ffff88003dc92640     0  2093      1 0x00000000
[111687.082720]  ffff88003a882210 0000000000000082 0000000000012640 ffff88003a882210
[111687.082727]  ffff8800380cbfd8 ffff88003c093d50 ffff88003a4dc4b0 ffff88003b3441e8
[111687.082733]  0000000000000000 0000000000000000 ffff88003b344000 ffff88003a7ff3c0
[111687.082740] Call Trace:
[111687.082749]  [<ffffffff81157a0c>] ? wait_current_trans.isra.19+0xad/0xd1
[111687.082756]  [<ffffffff8105ebdc>] ? finish_wait+0x60/0x60
[111687.082764]  [<ffffffff81158d1a>] ? start_transaction+0x414/0x4c5
[111687.082773]  [<ffffffff8113abef>] ? btrfs_release_path+0x38/0x53
[111687.082782]  [<ffffffff81162897>] ? btrfs_create+0x35/0x1c2
[111687.082790]  [<ffffffff810e986e>] ? vfs_create+0x46/0x6c
[111687.082798]  [<ffffffff810ea425>] ? do_last.isra.58+0x544/0x95e
[111687.082805]  [<ffffffff810eaa5b>] ? path_openat+0x21c/0x488
[111687.082813]  [<ffffffff810ebbdc>] ? do_filp_open+0x35/0x7a
[111687.082822]  [<ffffffff810f4555>] ? __alloc_fd+0x56/0xda
[111687.082830]  [<ffffffff810df880>] ? do_sys_open+0x65/0xe9
[111687.082839]  [<ffffffff813a6f66>] ? system_call_fastpath+0x1a/0x1f
[111687.082844] ntpd            D ffff88003dc92640     0  2176      1 0x00000004
[111687.082852]  ffff88003b4da210 0000000000000082 0000000000012640 ffff88003b4da210
[111687.082858]  ffff88003814bfd8 ffff88003c093d50 ffff88003a4dc4b0 ffff88003b3441e8
[111687.082865]  0000000000000000 0000000000000000 ffff88003b344000 ffff88003a7fff00
[111687.082872] Call Trace:
[111687.082880]  [<ffffffff81157a0c>] ? wait_current_trans.isra.19+0xad/0xd1
[111687.082888]  [<ffffffff8105ebdc>] ? finish_wait+0x60/0x60
[111687.082895]  [<ffffffff81158d1a>] ? start_transaction+0x414/0x4c5
[111687.082904]  [<ffffffff8113abef>] ? btrfs_release_path+0x38/0x53
[111687.082912]  [<ffffffff81162897>] ? btrfs_create+0x35/0x1c2
[111687.082920]  [<ffffffff810e986e>] ? vfs_create+0x46/0x6c
[111687.082927]  [<ffffffff810ea425>] ? do_last.isra.58+0x544/0x95e
[111687.082935]  [<ffffffff810eaa5b>] ? path_openat+0x21c/0x488
[111687.082943]  [<ffffffff81041bfd>] ? __set_current_blocked+0x2c/0x41
[111687.082950]  [<ffffffff810ebbdc>] ? do_filp_open+0x35/0x7a
[111687.082960]  [<ffffffff810ca6d0>] ? vma_rb_erase+0x15d/0x18b
[111687.082967]  [<ffffffff810f4555>] ? __alloc_fd+0x56/0xda
[111687.082975]  [<ffffffff810df880>] ? do_sys_open+0x65/0xe9
[111687.082984]  [<ffffffff813a6f66>] ? system_call_fastpath+0x1a/0x1f
[111687.082991] postgres        D ffff88003dc12640     0  2250   2245 0x00000000
[111687.082998]  ffff88003b2fb680 0000000000000082 0000000000012640 ffff88003b2fb680
[111687.083005]  ffff880034533fd8 ffffffff81811430 ffff88003a4d64e8 ffff880034533dc8
[111687.083012]  ffff88003a4d64ec ffff88003b2fb680 ffff88003a4d64f0 00000000ffffffff
[111687.083018] Call Trace:
[111687.083027]  [<ffffffff813a4747>] ? schedule_preempt_disabled+0x5/0x6
[111687.083035]  [<ffffffff813a56aa>] ? __mutex_lock_slowpath+0x146/0x1a4
[111687.083043]  [<ffffffff813a5716>] ? mutex_lock+0xe/0x1d
[111687.083050]  [<ffffffff811661dc>] ? btrfs_file_aio_write+0x79/0x47b
[111687.083058]  [<ffffffff810c573e>] ? tlb_flush_mmu+0x4e/0x64
[111687.083066]  [<ffffffff810ca3ce>] ? unmap_region+0xb5/0xc4
[111687.083074]  [<ffffffff810dfb6d>] ? do_sync_write+0x56/0x76
[111687.083083]  [<ffffffff810e0157>] ? vfs_write+0x9f/0x102
[111687.083091]  [<ffffffff810e0868>] ? SyS_write+0x41/0x74
[111687.083100]  [<ffffffff813a6f66>] ? system_call_fastpath+0x1a/0x1f
[111687.083105] postgres        D ffff88003dc92640     0  2251   2245 0x00000000
[111687.083112]  ffff88003b2ff3d0 0000000000000086 0000000000012640 ffff88003b2ff3d0
[111687.083119]  ffff88003455bfd8 ffff88003c093d50 ffff88003a4dc4b0 ffff88003b3441e8
[111687.083125]  0000000000000000 0000000000000000 ffff88003b344000 ffff88003a7ff500
[111687.083132] Call Trace:
[111687.083140]  [<ffffffff81157a0c>] ? wait_current_trans.isra.19+0xad/0xd1
[111687.083148]  [<ffffffff8105ebdc>] ? finish_wait+0x60/0x60
[111687.083155]  [<ffffffff81158d1a>] ? start_transaction+0x414/0x4c5
[111687.083164]  [<ffffffff8113abef>] ? btrfs_release_path+0x38/0x53
[111687.083173]  [<ffffffff81162897>] ? btrfs_create+0x35/0x1c2
[111687.083180]  [<ffffffff810e986e>] ? vfs_create+0x46/0x6c
[111687.083187]  [<ffffffff810ea425>] ? do_last.isra.58+0x544/0x95e
[111687.083195]  [<ffffffff810eaa5b>] ? path_openat+0x21c/0x488
[111687.083203]  [<ffffffff810e67b2>] ? pipe_read+0x31e/0x383
[111687.083211]  [<ffffffff810ebbdc>] ? do_filp_open+0x35/0x7a
[111687.083219]  [<ffffffff810f4555>] ? __alloc_fd+0x56/0xda
[111687.083227]  [<ffffffff810df880>] ? do_sys_open+0x65/0xe9
[111687.083235]  [<ffffffff813a6f66>] ? system_call_fastpath+0x1a/0x1f
[111687.083257] btrfs-endio-wri D ffff88003dc92640     0 23813      2 0x00000000
[111687.083265]  ffff88003bb1d1c0 0000000000000046 0000000000012640 ffff88003bb1d1c0
[111687.083271]  ffff88001a9e3fd8 ffff88003c093d50 ffff88003a4dc4b0 ffff88003b3441e8
[111687.083278]  0000000000000000 0000000000000000 ffff88003b344000 ffff88003a7ffc80
[111687.083285] Call Trace:
[111687.083293]  [<ffffffff81157a0c>] ? wait_current_trans.isra.19+0xad/0xd1
[111687.083301]  [<ffffffff8105ebdc>] ? finish_wait+0x60/0x60
[111687.083309]  [<ffffffff81158bf2>] ? start_transaction+0x2ec/0x4c5
[111687.083318]  [<ffffffff8115f0a1>] ? btrfs_finish_ordered_io+0x19b/0x3c2
[111687.083327]  [<ffffffff8103d700>] ? ftrace_raw_output_itimer_state+0x3d/0x60
[111687.083336]  [<ffffffff8117ba9d>] ? worker_loop+0x149/0x4a7
[111687.083343]  [<ffffffff813a4338>] ? __schedule+0x352/0x4f0
[111687.083351]  [<ffffffff8117b954>] ? btrfs_queue_worker+0x269/0x269
[111687.083359]  [<ffffffff8104cede>] ? kthread+0x9e/0xa6
[111687.083368]  [<ffffffff81050000>] ? blocking_notifier_chain_cond_register+0x13/0x40
[111687.083376]  [<ffffffff8104ce40>] ? __kthread_parkme+0x55/0x55
[111687.083384]  [<ffffffff813a6ebc>] ? ret_from_fork+0x7c/0xb0
[111687.083392]  [<ffffffff8104ce40>] ? __kthread_parkme+0x55/0x55
[111687.083399] carfax-backup   D ffff880031cdafb0     0  6718   6365 0x00000000
[111687.083406]  ffff880031cdafb0 0000000000000086 0000000000012640 ffff880031cdafb0
[111687.083413]  ffff88002e363fd8 ffff88003c1d9b40 ffff88003a6acbc8 ffff88002bf82f70
[111687.083420]  ffff88003a6acbe4 0000000000041000 ffff88002e363c90 0000000000042fff
[111687.083426] Call Trace:
[111687.083436]  [<ffffffff8116e069>] ? lock_extent_bits+0x108/0x180
[111687.083444]  [<ffffffff8105ebdc>] ? finish_wait+0x60/0x60
[111687.083452]  [<ffffffff81164bc4>] ? lock_and_cleanup_extent_if_need+0x66/0x191
[111687.083460]  [<ffffffff81165f44>] ? __btrfs_buffered_write+0x21d/0x43c
[111687.083468]  [<ffffffff8116651a>] ? btrfs_file_aio_write+0x3b7/0x47b
[111687.083476]  [<ffffffff810eb952>] ? user_path_at_empty+0x60/0x87
[111687.083485]  [<ffffffff8108af43>] ? from_kgid_munged+0x9/0x14
[111687.083494]  [<ffffffff810dfb6d>] ? do_sync_write+0x56/0x76
[111687.083502]  [<ffffffff810e0157>] ? vfs_write+0x9f/0x102
[111687.083511]  [<ffffffff810e0868>] ? SyS_write+0x41/0x74
[111687.083519]  [<ffffffff813a6f66>] ? system_call_fastpath+0x1a/0x1f
[111687.083531] kworker/u8:2    D ffff88003dc92640     0  6983      2 0x00000000
[111687.083544] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
[111687.083550]  ffff880000469b40 0000000000000046 0000000000012640 ffff880000469b40
[111687.083556]  ffff880024087fd8 ffff88003c093d50 ffff88003a4dc4b0 ffff88003b3441e8
[111687.083563]  0000000000000000 0000000000000000 ffff88003b344000 ffff88003a7ff820
[111687.083570] Call Trace:
[111687.083579]  [<ffffffff81157a0c>] ? wait_current_trans.isra.19+0xad/0xd1
[111687.083586]  [<ffffffff8105ebdc>] ? finish_wait+0x60/0x60
[111687.083594]  [<ffffffff81158bf2>] ? start_transaction+0x2ec/0x4c5
[111687.083603]  [<ffffffff8115d361>] ? cow_file_range_inline+0xe9/0x281
[111687.083611]  [<ffffffff810dbf07>] ? kmem_cache_free+0x32/0xb9
[111687.083620]  [<ffffffff8116d73e>] ? __set_extent_bit+0x3c3/0x3ff
[111687.083629]  [<ffffffff8115d5c7>] ? cow_file_range+0xce/0x37d
[111687.083639]  [<ffffffff81105e60>] ? __bio_add_page.part.14+0x130/0x1b5
[111687.083648]  [<ffffffff8115dfe8>] ? run_delalloc_range+0x9a/0x2c7
[111687.083656]  [<ffffffff8116cfd3>] ? free_extent_state+0x12/0x21
[111687.083666]  [<ffffffff8116ffb3>] ? __extent_writepage+0x1cc/0x5f4
[111687.083674]  [<ffffffff81055320>] ? check_preempt_curr+0x27/0x62
[111687.083681]  [<ffffffff8105536a>] ? ttwu_do_wakeup+0xf/0xb0
[111687.083691]  [<ffffffff810ad5bf>] ? find_get_pages_tag+0xe3/0x11c
[111687.083701]  [<ffffffff8117059f>] ? extent_write_cache_pages.isra.24.constprop.44+0x1c4/0x25a
[111687.083711]  [<ffffffff8116c4d0>] ? submit_one_bio+0xac/0xbf
[111687.083720]  [<ffffffff81001564>] ? __switch_to+0x13f/0x3bc
[111687.083729]  [<ffffffff811708c8>] ? extent_writepages+0x49/0x60
[111687.083736]  [<ffffffff813a4338>] ? __schedule+0x352/0x4f0
[111687.083744]  [<ffffffff8115bcdf>] ? btrfs_submit_direct+0x3f5/0x3f5
[111687.083753]  [<ffffffff810fd953>] ? __writeback_single_inode+0x4b/0x1c2
[111687.083762]  [<ffffffff810fe1b9>] ? writeback_sb_inodes+0x1d3/0x314
[111687.083771]  [<ffffffff810fe365>] ? __writeback_inodes_wb+0x6b/0xa1
[111687.083779]  [<ffffffff810fe4ac>] ? wb_writeback+0x111/0x273
[111687.083787]  [<ffffffff810b413c>] ? bdi_dirty_limit+0x27/0x84
[111687.083796]  [<ffffffff810fea9c>] ? bdi_writeback_workfn+0x1ab/0x316
[111687.083804]  [<ffffffff81048729>] ? process_one_work+0x179/0x28c
[111687.083812]  [<ffffffff81048be7>] ? worker_thread+0x139/0x1de
[111687.083819]  [<ffffffff81048aae>] ? rescuer_thread+0x24f/0x24f
[111687.083826]  [<ffffffff8104cede>] ? kthread+0x9e/0xa6
[111687.083835]  [<ffffffff81050000>] ? blocking_notifier_chain_cond_register+0x13/0x40
[111687.083843]  [<ffffffff8104ce40>] ? __kthread_parkme+0x55/0x55
[111687.083851]  [<ffffffff813a6ebc>] ? ret_from_fork+0x7c/0xb0
[111687.083860]  [<ffffffff8104ce40>] ? __kthread_parkme+0x55/0x55
[111687.083865] postgres        D ffff88003dc92640     0  8011   2245 0x00000000
[111687.083872]  ffff88003b2f8000 0000000000000082 0000000000012640 ffff88003b2f8000
[111687.083879]  ffff880002399fd8 ffff88003c093d50 ffff88003dc92640 ffff88003b2f8000
[111687.083886]  ffff880002399c40 0000000000000002 0000000000000000 ffffffff810acdc1
[111687.083893] Call Trace:
[111687.083901]  [<ffffffff810acdc1>] ? wait_on_page_read+0x32/0x32
[111687.083908]  [<ffffffff813a46ba>] ? io_schedule+0x54/0x69
[111687.083916]  [<ffffffff810acdc6>] ? sleep_on_page+0x5/0x8
[111687.083923]  [<ffffffff813a496c>] ? __wait_on_bit_lock+0x3c/0x7f
[111687.083931]  [<ffffffff810ace6b>] ? __lock_page+0x64/0x66
[111687.083939]  [<ffffffff8105ec06>] ? autoremove_wake_function+0x2a/0x2a
[111687.083947]  [<ffffffff810ad615>] ? lock_page+0x9/0x18
[111687.083954]  [<ffffffff810ad668>] ? find_lock_page+0x29/0x49
[111687.083963]  [<ffffffff810ad9c4>] ? find_or_create_page+0x28/0x85
[111687.083970]  [<ffffffff81165652>] ? prepare_pages.isra.18+0x7d/0x120
[111687.083978]  [<ffffffff81165f16>] ? __btrfs_buffered_write+0x1ef/0x43c
[111687.083987]  [<ffffffff8116651a>] ? btrfs_file_aio_write+0x3b7/0x47b
[111687.083994]  [<ffffffff810c573e>] ? tlb_flush_mmu+0x4e/0x64
[111687.084003]  [<ffffffff8102a6e9>] ? __do_page_fault+0x2b9/0x335
[111687.084012]  [<ffffffff810dfb6d>] ? do_sync_write+0x56/0x76
[111687.084021]  [<ffffffff810e0157>] ? vfs_write+0x9f/0x102
[111687.084029]  [<ffffffff810e0868>] ? SyS_write+0x41/0x74
[111687.084037]  [<ffffffff813a6f66>] ? system_call_fastpath+0x1a/0x1f
[111687.084043] mutt_dotlock    D ffff88003dc12640     0  8013   8012 0x00000000
[111687.084050]  ffff8800223cb680 0000000000000086 0000000000012640 ffff8800223cb680
[111687.084057]  ffff88000493dfd8 ffffffff81811430 ffff88003a4dc4b0 ffff88003b3441e8
[111687.084064]  0000000000000000 0000000000000000 ffff88003b344000 ffff88003a79ef00
[111687.084070] Call Trace:
[111687.084079]  [<ffffffff81157a0c>] ? wait_current_trans.isra.19+0xad/0xd1
[111687.084087]  [<ffffffff8105ebdc>] ? finish_wait+0x60/0x60
[111687.084094]  [<ffffffff81158d1a>] ? start_transaction+0x414/0x4c5
[111687.084104]  [<ffffffff8113c653>] ? generic_bin_search.constprop.34+0xf1/0x129
[111687.084113]  [<ffffffff81162897>] ? btrfs_create+0x35/0x1c2
[111687.084120]  [<ffffffff810e986e>] ? vfs_create+0x46/0x6c
[111687.084127]  [<ffffffff810ea425>] ? do_last.isra.58+0x544/0x95e
[111687.084135]  [<ffffffff810eaa5b>] ? path_openat+0x21c/0x488
[111687.084144]  [<ffffffff810ef151>] ? __d_rehash+0x19/0x4c
[111687.084151]  [<ffffffff810ebbdc>] ? do_filp_open+0x35/0x7a
[111687.084159]  [<ffffffff810f4555>] ? __alloc_fd+0x56/0xda
[111687.084167]  [<ffffffff810df880>] ? do_sys_open+0x65/0xe9
[111687.084176]  [<ffffffff813a6f66>] ? system_call_fastpath+0x1a/0x1f
[111687.084181] cron            D ffff88003dc12640     0  8014   2422 0x00000000
[111687.084188]  ffff88003b2fed00 0000000000000086 0000000000012640 ffff88003b2fed00
[111687.084195]  ffff880018d23fd8 ffffffff81811430 ffff88003a4dc4b0 ffff88003b3441e8
[111687.084202]  0000000000000000 0000000000000000 ffff88003b344000 ffff88003a79eaa0
[111687.084208] Call Trace:
[111687.084217]  [<ffffffff81157a0c>] ? wait_current_trans.isra.19+0xad/0xd1
[111687.084224]  [<ffffffff8105ebdc>] ? finish_wait+0x60/0x60
[111687.084232]  [<ffffffff81158d1a>] ? start_transaction+0x414/0x4c5
[111687.084241]  [<ffffffff8113abef>] ? btrfs_release_path+0x38/0x53
[111687.084249]  [<ffffffff81162897>] ? btrfs_create+0x35/0x1c2
[111687.084257]  [<ffffffff810e986e>] ? vfs_create+0x46/0x6c
[111687.084264]  [<ffffffff810ea425>] ? do_last.isra.58+0x544/0x95e
[111687.084272]  [<ffffffff810eaa5b>] ? path_openat+0x21c/0x488
[111687.084279]  [<ffffffff810c7df5>] ? handle_mm_fault+0x1f9/0x6da
[111687.084287]  [<ffffffff810ebbdc>] ? do_filp_open+0x35/0x7a
[111687.084295]  [<ffffffff810f4555>] ? __alloc_fd+0x56/0xda
[111687.084303]  [<ffffffff810df880>] ? do_sys_open+0x65/0xe9
[111687.084312]  [<ffffffff813a6f66>] ? system_call_fastpath+0x1a/0x1f
[111687.084317] cron            D ffff88003dc12640     0  8071   2422 0x00000000
[111687.084324]  ffff88003ac44420 0000000000000082 0000000000012640 ffff88003ac44420
[111687.084331]  ffff880005a35fd8 ffffffff81811430 ffff88003bfbfbf8 ffff880005a35d28
[111687.084338]  ffff88003bfbfbfc ffff88003ac44420 ffff88003bfbfc00 00000000ffffffff
[111687.084345] Call Trace:
[111687.084353]  [<ffffffff813a4747>] ? schedule_preempt_disabled+0x5/0x6
[111687.084361]  [<ffffffff813a56aa>] ? __mutex_lock_slowpath+0x146/0x1a4
[111687.084368]  [<ffffffff813a5716>] ? mutex_lock+0xe/0x1d
[111687.084375]  [<ffffffff810ea03f>] ? do_last.isra.58+0x15e/0x95e
[111687.084383]  [<ffffffff810eaa5b>] ? path_openat+0x21c/0x488
[111687.084390]  [<ffffffff810c7df5>] ? handle_mm_fault+0x1f9/0x6da
[111687.084398]  [<ffffffff810ebbdc>] ? do_filp_open+0x35/0x7a
[111687.084407]  [<ffffffff810f4555>] ? __alloc_fd+0x56/0xda
[111687.084415]  [<ffffffff810df880>] ? do_sys_open+0x65/0xe9
[111687.084424]  [<ffffffff813a6f66>] ? system_call_fastpath+0x1a/0x1f
[111687.084431] Sched Debug Version: v0.11, 3.13.0-00189-g56a5aaf-dirty #6
[111687.084439] ktime                                   : 111682644.677766
[111687.084445] sched_clk                               : 111687084.428515
[111687.084450] cpu_clk                                 : 111687084.428648
[111687.084455] jiffies                                 : 4306105560
[111687.084459] sched_clock_stable                      : 1
[111687.084462] 
[111687.084466] sysctl_sched
[111687.084471]   .sysctl_sched_latency                    : 12.000000
[111687.084476]   .sysctl_sched_min_granularity            : 1.500000
[111687.084481]   .sysctl_sched_wakeup_granularity         : 2.000000
[111687.084485]   .sysctl_sched_child_runs_first           : 0
[111687.084489]   .sysctl_sched_features                   : 11899
[111687.084495]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[111687.084498] 
[111687.084503] cpu#0, 1297.893 MHz
[111687.084507]   .nr_running                    : 2
[111687.084512]   .load                          : 2048
[111687.084516]   .nr_switches                   : 16915764
[111687.084520]   .nr_load_updates               : 2618312
[111687.084524]   .nr_uninterruptible            : 23576
[111687.084529]   .next_balance                  : 4306.105501
[111687.084533]   .curr->pid                     : 8029
[111687.084538]   .clock                         : 111687082.076429
[111687.084542]   .cpu_load[0]                   : 0
[111687.084546]   .cpu_load[1]                   : 0
[111687.084550]   .cpu_load[2]                   : 0
[111687.084554]   .cpu_load[3]                   : 0
[111687.084558]   .cpu_load[4]                   : 0
[111687.084564] 
[111687.084564] cfs_rq[0]:/autogroup-76
[111687.084571]   .exec_clock                    : 0.000000
[111687.084577]   .MIN_vruntime                  : 0.000001
[111687.084582]   .min_vruntime                  : 19306.798558
[111687.084587]   .max_vruntime                  : 0.000001
[111687.084591]   .spread                        : 0.000000
[111687.084597]   .spread0                       : -1406281.471418
[111687.084601]   .nr_spread_over                : 0
[111687.084606]   .nr_running                    : 1
[111687.084610]   .load                          : 1024
[111687.084614]   .runnable_load_avg             : 0
[111687.084618]   .blocked_load_avg              : 0
[111687.084622]   .tg_load_contrib               : 0
[111687.084626]   .tg_runnable_contrib           : 0
[111687.084630]   .tg_load_avg                   : 0
[111687.084634]   .tg->runnable_avg              : 0
[111687.084640]   .se->exec_start                : 111687082.076429
[111687.084645]   .se->vruntime                  : 1425584.231527
[111687.084650]   .se->sum_exec_runtime          : 19482.934096
[111687.084655]   .se->load.weight               : 1024
[111687.084659]   .se->avg.runnable_avg_sum      : 0
[111687.084663]   .se->avg.runnable_avg_period   : 47110
[111687.084667]   .se->avg.load_avg_contrib      : 0
[111687.084672]   .se->avg.decay_count           : 0
[111687.084677] 
[111687.084677] cfs_rq[0]:/autogroup-32
[111687.084684]   .exec_clock                    : 0.000000
[111687.084689]   .MIN_vruntime                  : 0.000001
[111687.084694]   .min_vruntime                  : 39788.898281
[111687.084698]   .max_vruntime                  : 0.000001
[111687.084703]   .spread                        : 0.000000
[111687.084708]   .spread0                       : -1385799.371695
[111687.084712]   .nr_spread_over                : 0
[111687.084716]   .nr_running                    : 0
[111687.084720]   .load                          : 0
[111687.084724]   .runnable_load_avg             : 0
[111687.084728]   .blocked_load_avg              : 0
[111687.084732]   .tg_load_contrib               : 0
[111687.084736]   .tg_runnable_contrib           : 0
[111687.084741]   .tg_load_avg                   : 0
[111687.084745]   .tg->runnable_avg              : 0
[111687.084750]   .se->exec_start                : 111687003.265398
[111687.084755]   .se->vruntime                  : 1425588.269976
[111687.084760]   .se->sum_exec_runtime          : 52487.091255
[111687.084764]   .se->load.weight               : 2
[111687.084768]   .se->avg.runnable_avg_sum      : 9
[111687.084773]   .se->avg.runnable_avg_period   : 47151
[111687.084777]   .se->avg.load_avg_contrib      : 0
[111687.084781]   .se->avg.decay_count           : 106513027
[111687.084786] 
[111687.084786] cfs_rq[0]:/
[111687.084793]   .exec_clock                    : 0.000000
[111687.084798]   .MIN_vruntime                  : 1425582.269976
[111687.084803]   .min_vruntime                  : 1425588.269976
[111687.084808]   .max_vruntime                  : 1425582.269976
[111687.084812]   .spread                        : 0.000000
[111687.084817]   .spread0                       : 0.000000
[111687.084821]   .nr_spread_over                : 0
[111687.084825]   .nr_running                    : 2
[111687.084829]   .load                          : 2048
[111687.084833]   .runnable_load_avg             : 0
[111687.084837]   .blocked_load_avg              : 0
[111687.084841]   .tg_load_contrib               : 0
[111687.084845]   .tg_runnable_contrib           : 2
[111687.084849]   .tg_load_avg                   : 0
[111687.084854]   .tg->runnable_avg              : 10
[111687.084858]   .avg->runnable_avg_sum         : 122
[111687.084862]   .avg->runnable_avg_period      : 47403
[111687.084867] 
[111687.084867] rt_rq[0]:
[111687.084872]   .rt_nr_running                 : 0
[111687.084876]   .rt_throttled                  : 0
[111687.084881]   .rt_time                       : 0.000000
[111687.084886]   .rt_runtime                    : 950.000000
[111687.084893] 
[111687.084893] runnable tasks:
[111687.084893]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[111687.084893] ----------------------------------------------------------------------------------------------------------
[111687.084903]             init     1      1296.862754     22719   120               0               0               0.000000               0.000000               0.000000 /autogroup-2
[111687.084919]      ksoftirqd/0     3   1425571.863737    192653   120               0               0               0.000000               0.000000               0.000000 /
[111687.084933]     kworker/0:0H     5       256.529404         3   100               0               0               0.000000               0.000000               0.000000 /
[111687.084946]        rcu_sched     7   1425582.319138    439623   120               0               0               0.000000               0.000000               0.000000 /
[111687.084959]      migration/0     9         0.000000     13652     0               0               0               0.000000               0.000000               0.000000 /
[111687.084971]        kdevtmpfs    15   1119962.560586       173   120               0               0               0.000000               0.000000               0.000000 /
[111687.084984]            netns    16       262.524108         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.084996]        writeback    17       262.529217         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.085009]       devfreq_wq    23       791.136003         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.085021]       khungtaskd    27   1425221.795289       932   120               0               0               0.000000               0.000000               0.000000 /
[111687.085034]        scsi_eh_0    48       903.719125        17   120               0               0               0.000000               0.000000               0.000000 /
[111687.085047]        scsi_eh_1    49       897.791182        18   120               0               0               0.000000               0.000000               0.000000 /
[111687.085059]        scsi_eh_2    50       897.785919        18   120               0               0               0.000000               0.000000               0.000000 /
[111687.085071]        scsi_eh_3    51       903.748406        20   120               0               0               0.000000               0.000000               0.000000 /
[111687.085084]           bioset    60       925.381221         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.085096]  btrfs-genwork-1   207   1425211.098083      1332   120               0               0               0.000000               0.000000               0.000000 /
[111687.085109]    btrfs-fixup-1   210   1425223.161511       984   120               0               0               0.000000               0.000000               0.000000 /
[111687.085122]    btrfs-cache-1   219   1425223.183779       998   120               0               0               0.000000               0.000000               0.000000 /
[111687.085134]  btrfs-flush_del   221   1425229.231609      5201   120               0               0               0.000000               0.000000               0.000000 /
[111687.085147]    btrfs-cleaner   223   1416058.997293     10250   120               0               0               0.000000               0.000000               0.000000 /
[111687.085159]            udevd   378       772.214379       569   120               0               0               0.000000               0.000000               0.000000 /autogroup-4
[111687.085173]      edac-poller   489      2677.694949         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.085186]          rpcbind  1690       167.304490      3822   120               0               0               0.000000               0.000000               0.000000 /autogroup-5
[111687.085199]        rpc.statd  1718        13.242367         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-6
[111687.085212]           rpciod  1723      6264.804884         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.085225]         rpc.gssd  1739         0.089455         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-8
[111687.085239]            named  2076         3.006953         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-15
[111687.085252]            named  2082     10122.498241     70731   120               0               0               0.000000               0.000000               0.000000 /autogroup-15
[111687.085266]            inetd  2155         0.911649         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-17
[111687.085279]          krb5kdc  2195        94.667089      1990   120               0               0               0.000000               0.000000               0.000000 /autogroup-19
[111687.085293]         postgres  2245      6949.516127      4045   120               0               0               0.000000               0.000000               0.000000 /autogroup-21
[111687.085307]         postgres  2247        33.163002       373   120               0               0               0.000000               0.000000               0.000000 /autogroup-23
[111687.085320]         postgres  2248       899.817081     22452   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
[111687.085334]         postgres  2250      1800.081068     20777   120               0               0               0.000000               0.000000               0.000000 /autogroup-26
[111687.085347]          apache2  2303     39782.711062    111709   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085361]          apache2  2310       126.886684         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085374]          apache2  2311       126.867561         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085387]          apache2  2312       132.886257         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085400]          apache2  2313       132.875815         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085413]          apache2  2314       132.875693         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085426]          apache2  2315       132.894180         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085439]          apache2  2317       132.949154         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085452]          apache2  2319       132.997783         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085465]          apache2  2321       133.049228         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085478]          apache2  2323       133.093223         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085491]          apache2  2325       133.143419         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085504]          apache2  2327       133.191952         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085517]          apache2  2329       133.234689         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085530]          apache2  2331       133.283717         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085543]          apache2  2333       133.335861         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085556]          apache2  2335       133.375538         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085569]          apache2  2342       134.337740         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085582]          apache2  2344       133.875717         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085595]          apache2  2346       133.764188         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085608]          apache2  2348       133.741640         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085621]          apache2  2350       133.728917         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085634]          apache2  2352       133.531329         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085647]          apache2  2353       133.535273         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085660]          apache2  2355     39788.898281   1114738   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085673]          apache2  2307       122.849120        73   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085687]          apache2  2330       128.779507         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085701]          apache2  2343       133.840685         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085714]          apache2  2345       133.723956         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085727]          apache2  2347       133.744236         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085740]          apache2  2349       133.736222         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085753]          apache2  2351       133.534242         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085766]          apache2  2354       133.529426         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085779]          apache2  2356       133.529394         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085792]          apache2  2357       133.529660         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085805]          apache2  2358       133.529361         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085818]          apache2  2359       133.530160         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085831]          apache2  2360       133.533665         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.085845]          kadmind  2475        62.052283      1873   120               0               0               0.000000               0.000000               0.000000 /autogroup-35
[111687.085858]     avahi-daemon  2479         0.966223         4   120               0               0               0.000000               0.000000               0.000000 /autogroup-34
[111687.085872]            nfsd4  2585      9747.469163         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.085885]            lockd  2589      9753.498182         2   120               0               0               0.000000               0.000000               0.000000 /
[111687.085898]             nfsd  2600   1425278.450673        34   120               0               0               0.000000               0.000000               0.000000 /
[111687.085911]    apt-cacher-ng 23734     26021.510330     33616   120               0               0               0.000000               0.000000               0.000000 /autogroup-38
[111687.085925]    apt-cacher-ng 23735     26025.775064      9738   120               0               0               0.000000               0.000000               0.000000 /autogroup-38
[111687.085938]       rpc.mountd  2704         0.548005         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-40
[111687.085952]            getty  3054         0.343556       126   120               0               0               0.000000               0.000000               0.000000 /autogroup-45
[111687.085965]            getty  3056         0.736470        63   120               0               0               0.000000               0.000000               0.000000 /autogroup-47
[111687.085979]             sshd  4854        35.700992        30   120               0               0               0.000000               0.000000               0.000000 /autogroup-52
[111687.085992]             sshd  4862        95.412813      4304   120               0               0               0.000000               0.000000               0.000000 /autogroup-52
[111687.086005]             bash  4865       428.437126       156   120               0               0               0.000000               0.000000               0.000000 /autogroup-53
[111687.086019]               su  4955       471.824541         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-53
[111687.086032]             bash  4964    335591.057713      2348   120               0               0               0.000000               0.000000               0.000000 /autogroup-53
[111687.086046]             sshd  5006        32.152152        17   120               0               0               0.000000               0.000000               0.000000 /autogroup-54
[111687.086059]             sshd  5014       128.417749      4878   120               0               0               0.000000               0.000000               0.000000 /autogroup-54
[111687.086073]             bash  5017       446.458803       154   120               0               0               0.000000               0.000000               0.000000 /autogroup-55
[111687.086086]             sshd  5203        28.615789        45   120               0               0               0.000000               0.000000               0.000000 /autogroup-63
[111687.086100]             bash  5214      3151.392304       248   120               0               0               0.000000               0.000000               0.000000 /autogroup-64
[111687.086114]             sshd  5343        46.296097        29   120               0               0               0.000000               0.000000               0.000000 /autogroup-75
[111687.086127]             bash  5354     19044.348904      1235   120               0               0               0.000000               0.000000               0.000000 /autogroup-76
[111687.086140]             mutt  6708     10930.252771     12816   120               0               0               0.000000               0.000000               0.000000 /autogroup-64
[111687.086154]               su  6900       495.999647        19   120               0               0               0.000000               0.000000               0.000000 /autogroup-55
[111687.086167]             bash  6909      1318.068343       260   120               0               0               0.000000               0.000000               0.000000 /autogroup-55
[111687.086180]             tail  8466      1355.501545      1398   120               0               0               0.000000               0.000000               0.000000 /autogroup-55
[111687.086194]  btrfs-delayed-m  9692   1425576.521728      1196   120               0               0               0.000000               0.000000               0.000000 /
[111687.086207]             sshd 30170        42.607579        38   120               0               0               0.000000               0.000000               0.000000 /autogroup-1403
[111687.086221]             sshd 30179        50.158711       561   120               0               0               0.000000               0.000000               0.000000 /autogroup-1403
[111687.086235]   btrfs-worker-3  6128   1425229.655283      1770   120               0               0               0.000000               0.000000               0.000000 /
[111687.086249]         kdmflush  6734   1119974.621329         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.086261]           bioset  6735   1119978.612779         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.086273]       kcryptd_io  6736   1119982.601457         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.086286]          kcryptd  6737   1119986.595644         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.086298]           bioset  6738   1119990.583874         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.086310]   btrfs-worker-1  6745   1425211.090613      6117   120               0               0               0.000000               0.000000               0.000000 /
[111687.086323]  btrfs-delalloc-  6748   1425202.251492       104   120               0               0               0.000000               0.000000               0.000000 /
[111687.086336]    btrfs-fixup-1  6749   1425202.250784       101   120               0               0               0.000000               0.000000               0.000000 /
[111687.086348]    btrfs-endio-1  6750   1425202.251809       100   120               0               0               0.000000               0.000000               0.000000 /
[111687.086361]  btrfs-freespace  6756   1425211.089326       376   120               0               0               0.000000               0.000000               0.000000 /
[111687.086374]  btrfs-delayed-m  6757   1425233.871251      2267   120               0               0               0.000000               0.000000               0.000000 /
[111687.086386]    btrfs-cache-1  6758   1425202.251344       103   120               0               0               0.000000               0.000000               0.000000 /
[111687.086399]  btrfs-readahead  6759   1425202.297607        83   120               0               0               0.000000               0.000000               0.000000 /
[111687.086411]  btrfs-flush_del  6760   1425221.029890       135   120               0               0               0.000000               0.000000               0.000000 /
[111687.086423]  btrfs-qgroup-re  6761   1425202.267649       104   120               0               0               0.000000               0.000000               0.000000 /
[111687.086436]          python3  6779      1996.172122        42   120               0               0               0.000000               0.000000               0.000000 /autogroup-1871
[111687.086451]              ssh  6785    118603.802447    504921   120               0               0               0.000000               0.000000               0.000000 /autogroup-1876
[111687.086465]          python3  6787      2218.316569        40   120               0               0               0.000000               0.000000               0.000000 /autogroup-1871
[111687.086479]     kworker/u9:0  6846   1425573.308146    334027   100               0               0               0.000000               0.000000               0.000000 /
[111687.086492]     kworker/u8:1  6896   1425581.961121      3810   120               0               0               0.000000               0.000000               0.000000 /
[111687.086504]     kworker/u9:1  6899   1420811.378253    172157   100               0               0               0.000000               0.000000               0.000000 /
[111687.086516]      kworker/0:0  6901   1425582.269976     26415   120               0               0               0.000000               0.000000               0.000000 /
[111687.086529]     kworker/u8:0  6999   1424795.813917      2797   120               0               0               0.000000               0.000000               0.000000 /
[111687.086542]      kworker/0:2  7008   1423001.844114       426   120               0               0               0.000000               0.000000               0.000000 /
[111687.086554]               sh  8012     10932.036968         2   120               0               0               0.000000               0.000000               0.000000 /autogroup-64
[111687.086568]     mutt_dotlock  8013     10933.323866         2   120               0               0               0.000000               0.000000               0.000000 /autogroup-64
[111687.086581]             cron  8014       896.991244         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-33
[111687.086594]               su  8018     19094.386205        20   120               0               0               0.000000               0.000000               0.000000 /autogroup-76
[111687.086608] R           bash  8029     19306.798558       144   120               0               0               0.000000               0.000000               0.000000 /autogroup-76
[111687.086620]             cron  8071       903.431321         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-33
[111687.086633] 
[111687.086638] cpu#1, 1297.893 MHz
[111687.086643]   .nr_running                    : 0
[111687.086647]   .load                          : 0
[111687.086651]   .nr_switches                   : 18360584
[111687.086656]   .nr_load_updates               : 2784053
[111687.086660]   .nr_uninterruptible            : -23563
[111687.086665]   .next_balance                  : 4306.105561
[111687.086669]   .curr->pid                     : 0
[111687.086674]   .clock                         : 111687082.018466
[111687.086678]   .cpu_load[0]                   : 0
[111687.086682]   .cpu_load[1]                   : 0
[111687.086686]   .cpu_load[2]                   : 0
[111687.086690]   .cpu_load[3]                   : 0
[111687.086694]   .cpu_load[4]                   : 0
[111687.086700] 
[111687.086700] cfs_rq[1]:/autogroup-75
[111687.086706]   .exec_clock                    : 0.000000
[111687.086711]   .MIN_vruntime                  : 0.000001
[111687.086716]   .min_vruntime                  : 315.671560
[111687.086721]   .max_vruntime                  : 0.000001
[111687.086725]   .spread                        : 0.000000
[111687.086730]   .spread0                       : -1425272.598416
[111687.086734]   .nr_spread_over                : 0
[111687.086738]   .nr_running                    : 0
[111687.086742]   .load                          : 0
[111687.086747]   .runnable_load_avg             : 0
[111687.086751]   .blocked_load_avg              : 0
[111687.086755]   .tg_load_contrib               : 0
[111687.086759]   .tg_runnable_contrib           : 0
[111687.086763]   .tg_load_avg                   : 0
[111687.086767]   .tg->runnable_avg              : 0
[111687.086773]   .se->exec_start                : 111687081.995141
[111687.086777]   .se->vruntime                  : 1470736.343594
[111687.086782]   .se->sum_exec_runtime          : 305.236937
[111687.086787]   .se->load.weight               : 2
[111687.086791]   .se->avg.runnable_avg_sum      : 125
[111687.086795]   .se->avg.runnable_avg_period   : 47935
[111687.086800]   .se->avg.load_avg_contrib      : 0
[111687.086804]   .se->avg.decay_count           : 106513102
[111687.086809] 
[111687.086809] cfs_rq[1]:/autogroup-1870
[111687.086816]   .exec_clock                    : 0.000000
[111687.086821]   .MIN_vruntime                  : 0.000001
[111687.086826]   .min_vruntime                  : 1582.891691
[111687.086830]   .max_vruntime                  : 0.000001
[111687.086835]   .spread                        : 0.000000
[111687.086840]   .spread0                       : -1424005.378285
[111687.086844]   .nr_spread_over                : 0
[111687.086848]   .nr_running                    : 0
[111687.086853]   .load                          : 0
[111687.086857]   .runnable_load_avg             : 0
[111687.086861]   .blocked_load_avg              : 0
[111687.086865]   .tg_load_contrib               : 0
[111687.086869]   .tg_runnable_contrib           : 4
[111687.086873]   .tg_load_avg                   : 0
[111687.086877]   .tg->runnable_avg              : 4
[111687.086883]   .se->exec_start                : 111687076.809681
[111687.086888]   .se->vruntime                  : 1470741.000918
[111687.086893]   .se->sum_exec_runtime          : 1578.185103
[111687.086897]   .se->load.weight               : 2
[111687.086901]   .se->avg.runnable_avg_sum      : 195
[111687.086906]   .se->avg.runnable_avg_period   : 47493
[111687.086910]   .se->avg.load_avg_contrib      : 0
[111687.086914]   .se->avg.decay_count           : 106513097
[111687.086919] 
[111687.086919] cfs_rq[1]:/autogroup-32
[111687.086926]   .exec_clock                    : 0.000000
[111687.086930]   .MIN_vruntime                  : 0.000001
[111687.086935]   .min_vruntime                  : 49491.793832
[111687.086940]   .max_vruntime                  : 0.000001
[111687.086944]   .spread                        : 0.000000
[111687.086949]   .spread0                       : -1376096.476144
[111687.086954]   .nr_spread_over                : 0
[111687.086958]   .nr_running                    : 0
[111687.086962]   .load                          : 0
[111687.086966]   .runnable_load_avg             : 0
[111687.086970]   .blocked_load_avg              : 0
[111687.086974]   .tg_load_contrib               : 0
[111687.086978]   .tg_runnable_contrib           : 0
[111687.086982]   .tg_load_avg                   : 0
[111687.086986]   .tg->runnable_avg              : 0
[111687.086991]   .se->exec_start                : 111687003.237296
[111687.086996]   .se->vruntime                  : 1470739.572224
[111687.087001]   .se->sum_exec_runtime          : 54762.123868
[111687.087005]   .se->load.weight               : 2
[111687.087010]   .se->avg.runnable_avg_sum      : 10
[111687.087014]   .se->avg.runnable_avg_period   : 47524
[111687.087018]   .se->avg.load_avg_contrib      : 0
[111687.087023]   .se->avg.decay_count           : 106513027
[111687.087027] 
[111687.087027] cfs_rq[1]:/
[111687.087033]   .exec_clock                    : 0.000000
[111687.087038]   .MIN_vruntime                  : 0.000001
[111687.087043]   .min_vruntime                  : 1470741.000918
[111687.087048]   .max_vruntime                  : 0.000001
[111687.087052]   .spread                        : 0.000000
[111687.087057]   .spread0                       : 45152.730942
[111687.087061]   .nr_spread_over                : 0
[111687.087065]   .nr_running                    : 0
[111687.087069]   .load                          : 0
[111687.087074]   .runnable_load_avg             : 0
[111687.087078]   .blocked_load_avg              : 0
[111687.087082]   .tg_load_contrib               : 0
[111687.087086]   .tg_runnable_contrib           : 8
[111687.087090]   .tg_load_avg                   : 0
[111687.087094]   .tg->runnable_avg              : 10
[111687.087098]   .avg->runnable_avg_sum         : 401
[111687.087103]   .avg->runnable_avg_period      : 47511
[111687.087107] 
[111687.087107] rt_rq[1]:
[111687.087112]   .rt_nr_running                 : 0
[111687.087116]   .rt_throttled                  : 0
[111687.087121]   .rt_time                       : 0.000000
[111687.087126]   .rt_runtime                    : 950.000000
[111687.087132] 
[111687.087132] runnable tasks:
[111687.087132]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[111687.087132] ----------------------------------------------------------------------------------------------------------
[111687.087143]         kthreadd     2   1463123.043387       924   120               0               0               0.000000               0.000000               0.000000 /
[111687.087157]           rcu_bh     8   1468759.098070        23   120               0               0               0.000000               0.000000               0.000000 /
[111687.087170]      migration/1    10         0.000000     13726     0               0               0               0.000000               0.000000               0.000000 /
[111687.087182]      ksoftirqd/1    11   1470588.170686    334191   120               0               0               0.000000               0.000000               0.000000 /
[111687.087194]     kworker/1:0H    13         3.434556         4   100               0               0               0.000000               0.000000               0.000000 /
[111687.087206]          khelper    14         4.969285         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.087219]      kintegrityd    18        15.480282         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.087231]           bioset    19        21.491961         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.087243]          kblockd    21        27.504069         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.087256]            khubd    22      1199.047301       113   120               0               0               0.000000               0.000000               0.000000 /
[111687.087269]          kswapd0    28   1467720.143251    227607   120               0               0               0.000000               0.000000               0.000000 /
[111687.087281]             ksmd    29       174.485143         2   125               0               0               0.000000               0.000000               0.000000 /
[111687.087293]    fsnotify_mark    30   1173026.623136        31   120               0               0               0.000000               0.000000               0.000000 /
[111687.087305]           crypto    31       180.939545         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.087317]         pencrypt    38       211.314784         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.087330]         pdecrypt    39       217.333457         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.087342]          deferwq    61       306.808896         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.087355]   btrfs-submit-1   208   1470526.737257     21369   120               0               0               0.000000               0.000000               0.000000 /
[111687.087367]  btrfs-delalloc-   209   1470520.960880      1002   120               0               0               0.000000               0.000000               0.000000 /
[111687.087380]  btrfs-endio-met   212   1470724.984741      9820   120               0               0               0.000000               0.000000               0.000000 /
[111687.087392]      btrfs-rmw-1   213   1470520.969024       980   120               0               0               0.000000               0.000000               0.000000 /
[111687.087405]  btrfs-endio-rai   214   1470521.014866      1009   120               0               0               0.000000               0.000000               0.000000 /
[111687.087417]  btrfs-endio-met   215   1470520.960882      1009   120               0               0               0.000000               0.000000               0.000000 /
[111687.087430]  btrfs-freespace   217   1470509.836385      9003   120               0               0               0.000000               0.000000               0.000000 /
[111687.087443]  btrfs-readahead   220   1470520.963549      1003   120               0               0               0.000000               0.000000               0.000000 /
[111687.087456]  btrfs-qgroup-re   222   1470520.966462      1004   120               0               0               0.000000               0.000000               0.000000 /
[111687.087469]  btrfs-transacti   224   1465040.022545     90564   120               0               0               0.000000               0.000000               0.000000 /
[111687.087482]        scsi_eh_4   493      2045.920555         2   120               0               0               0.000000               0.000000               0.000000 /
[111687.087495]      usb-storage   494   1468310.710565   1031798   120               0               0               0.000000               0.000000               0.000000 /
[111687.087508]  kvm-irqfd-clean   512      2275.124722         3   100               0               0               0.000000               0.000000               0.000000 /
[111687.087521]           nfsiod  1727      6433.121424         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.087533]       rpc.idmapd  1735         0.422149         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-7
[111687.087547]        syslog-ng  1994         6.062742         3   120               0               0               0.000000               0.000000               0.000000 /autogroup-11
[111687.087561]        syslog-ng  1995       591.710073      5909   120               0               0               0.000000               0.000000               0.000000 /autogroup-12
[111687.087575]            acpid  2029         0.117387         2   120               0               0               0.000000               0.000000               0.000000 /autogroup-13
[111687.087588]              atd  2068         1.152685        32   120               0               0               0.000000               0.000000               0.000000 /autogroup-14
[111687.087602]            named  2079      8012.064665     52647   120               0               0               0.000000               0.000000               0.000000 /autogroup-15
[111687.087616]            named  2080      8012.319426     52640   120               0               0               0.000000               0.000000               0.000000 /autogroup-15
[111687.087629]            named  2081      8005.605658     11854   120               0               0               0.000000               0.000000               0.000000 /autogroup-15
[111687.087643]        mosquitto  2093     20898.207506   1079108   120               0               0               0.000000               0.000000               0.000000 /autogroup-16
[111687.087656]             ntpd  2176      4479.373308    115940   120               0               0               0.000000               0.000000               0.000000 /autogroup-18
[111687.087670]      dbus-daemon  2213         0.858032        12   120               0               0               0.000000               0.000000               0.000000 /autogroup-20
[111687.087684]         postgres  2249       209.177551     22353   120               0               0               0.000000               0.000000               0.000000 /autogroup-27
[111687.087699]         postgres  2251      3223.357619      7869   120               0               0               0.000000               0.000000               0.000000 /autogroup-25
[111687.087712]          apache2  2306       110.314012        70   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087728]          apache2  2337       123.167267         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087741]          apache2  2339       117.397234         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087755]          apache2  2316       118.725957         2   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087769]          apache2  2318       117.447615         6   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087783]          apache2  2320       118.677570         2   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087796]          apache2  2322       118.586077         2   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087809]          apache2  2324       118.595195         3   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087822]          apache2  2326       118.488200         3   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087835]          apache2  2328       114.598501         3   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087849]          apache2  2332       118.723989         2   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087862]          apache2  2334       114.711802         2   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087876]          apache2  2336       114.651316         2   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087889]          apache2  2338       118.719173         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087902]          apache2  2340       118.749580         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087915]          apache2  2341       118.796725         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087929]          apache2  2361     49491.793832   1114708   120               0               0               0.000000               0.000000               0.000000 /autogroup-32
[111687.087943]             cron  2422      1100.383926      1929   120               0               0               0.000000               0.000000               0.000000 /autogroup-33
[111687.087956]     avahi-daemon  2478      1112.025290     11177   120               0               0               0.000000               0.000000               0.000000 /autogroup-34
[111687.087970]             sshd  2485         2.488331        29   120               0               0               0.000000               0.000000               0.000000 /autogroup-36
[111687.087984]  nfsd4_callbacks  2586      9812.495450         2   100               0               0               0.000000               0.000000               0.000000 /
[111687.087996]             nfsd  2596   1470548.108591        34   120               0               0               0.000000               0.000000               0.000000 /
[111687.088009]             nfsd  2597   1470548.108453        34   120               0               0               0.000000               0.000000               0.000000 /
[111687.088022]             nfsd  2598   1470548.108786        34   120               0               0               0.000000               0.000000               0.000000 /
[111687.088034]             nfsd  2599   1470548.108658        34   120               0               0               0.000000               0.000000               0.000000 /
[111687.088047]             nfsd  2601   1470548.128113        34   120               0               0               0.000000               0.000000               0.000000 /
[111687.088060]             nfsd  2602   1470548.110195        34   120               0               0               0.000000               0.000000               0.000000 /
[111687.088072]             nfsd  2603   1470548.108369        34   120               0               0               0.000000               0.000000               0.000000 /
[111687.088085]      rpc.svcgssd  2640        12.397936         7   120               0               0               0.000000               0.000000               0.000000 /autogroup-37
[111687.088099]    apt-cacher-ng  2660     16498.787015        16   120               0               0               0.000000               0.000000               0.000000 /autogroup-38
[111687.088113]            exim4  2936       868.310810       127   120               0               0               0.000000               0.000000               0.000000 /autogroup-41
[111687.088128]            getty  3051         0.826585       124   120               0               0               0.000000               0.000000               0.000000 /autogroup-42
[111687.088142]            getty  3052         0.818461       129   120               0               0               0.000000               0.000000               0.000000 /autogroup-43
[111687.088156]            getty  3053         2.062473       127   120               0               0               0.000000               0.000000               0.000000 /autogroup-44
[111687.088170]            getty  3055         1.900641       128   120               0               0               0.000000               0.000000               0.000000 /autogroup-46
[111687.088185]             sudo  4947       398.020265        51   120               0               0               0.000000               0.000000               0.000000 /autogroup-53
[111687.088200]             sshd  5211       663.823815      5219   120               0               0               0.000000               0.000000               0.000000 /autogroup-63
[111687.088214]             sshd  5351       315.671560      2178   120               0               0               0.000000               0.000000               0.000000 /autogroup-75
[111687.088228]  btrfs-endio-wri 23813   1465101.293150      2185   120               0               0               0.000000               0.000000               0.000000 /
[111687.088241]             bash 30182       540.952181       103   120               0               0               0.000000               0.000000               0.000000 /autogroup-1404
[111687.088255]             tmux  6361    452234.691994         7   120               0               0               0.000000               0.000000               0.000000 /autogroup-53
[111687.088269]             tmux  6364      1582.891691     21089   120               0               0               0.000000               0.000000               0.000000 /autogroup-1870
[111687.088283]             bash  6365      1486.629505       383   120               0               0               0.000000               0.000000               0.000000 /autogroup-1871
[111687.088296]    carfax-backup  6718     52321.615966    280808   120               0               0               0.000000               0.000000               0.000000 /autogroup-1871
[111687.088311]  btrfs-genwork-1  6746   1470548.131011        93   120               0               0               0.000000               0.000000               0.000000 /
[111687.088323]   btrfs-submit-1  6747   1470509.890602     35473   120               0               0               0.000000               0.000000               0.000000 /
[111687.088337]  btrfs-endio-met  6751   1470506.315610       489   120               0               0               0.000000               0.000000               0.000000 /
[111687.088349]      btrfs-rmw-1  6752   1470501.885718        79   120               0               0               0.000000               0.000000               0.000000 /
[111687.088362]  btrfs-endio-rai  6753   1470501.932541       101   120               0               0               0.000000               0.000000               0.000000 /
[111687.088375]  btrfs-endio-met  6754   1470501.912432       103   120               0               0               0.000000               0.000000               0.000000 /
[111687.088389]    btrfs-cleaner  6762   1470729.918748       335   120               0               0               0.000000               0.000000               0.000000 /
[111687.088402]  btrfs-transacti  6763   1470729.950093      4662   120               0               0               0.000000               0.000000               0.000000 /
[111687.088415]          sshpass  6764      1729.050543         6   120               0               0               0.000000               0.000000               0.000000 /autogroup-1871
[111687.088429]              ssh  6765    122063.699027    465386   120               0               0               0.000000               0.000000               0.000000 /autogroup-1874
[111687.088443]            btrfs  6780     52324.281534    984848   120               0               0               0.000000               0.000000               0.000000 /autogroup-1871
[111687.088456]            btrfs  6781     52321.129711    132173   120               0               0               0.000000               0.000000               0.000000 /autogroup-1871
[111687.088470]          sshpass  6783      2218.346496         5   120               0               0               0.000000               0.000000               0.000000 /autogroup-1871
[111687.088484]            btrfs  6788     52327.745643    226230   120               0               0               0.000000               0.000000               0.000000 /autogroup-1871
[111687.088498]    btrfs-endio-2  6869   1470724.752666    583773   120               0               0               0.000000               0.000000               0.000000 /
[111687.088511]      kworker/1:1  6889   1470735.069746     30405   120               0               0               0.000000               0.000000               0.000000 /
[111687.088525]  btrfs-endio-wri  6910   1470728.870267       560   120               0               0               0.000000               0.000000               0.000000 /
[111687.088537]     kworker/u8:2  6983   1468168.563703       376   120               0               0               0.000000               0.000000               0.000000 /
[111687.088550]      kworker/1:2  7001   1468066.800362        64   120               0               0               0.000000               0.000000               0.000000 /
[111687.088563]         postgres  8011        95.710109      1002   120               0               0               0.000000               0.000000               0.000000 /autogroup-1937
[111687.088577] 


-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- My doctor tells me that I have a malformed public-duty gland, ---  
                and a natural deficiency in moral fibre.                 

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUx48cVheFHXiqx3kAQK++A/+LFWCuxaW1DnzBeUUyNw8XN9k82UN7unt
nfW2/mwPvkmw9ci1g/GVWGfe8pCJe1VeZPeH6yyA3WFKwqSW8oorH0umBFflcpDa
l2aNm0ZhoWbZ2sH7iqgmPlEq9H0kCdn6gRYEeyeLVzuYDlv+7keFisTVRCM0UM5N
ui2aH8l1UrunCSV3i8RD6qXiBwbOEbpSWAJRr0Dbk72Tz4n+QoDgzF6ymXCDZwSG
dXSoa07UPlLSkgJUxcQascLOv3H5lwLzAEQPLgkQtzXC6xB6uiM0G4CA1qIU4YRH
P/MMWZPEvOG+RCZ063/ur7WvqvSLmSA/ziPdOtIb5U4f5CKFQyFm+8TYL7MtD2oN
I0h/yM2hoqvIg9y+gjjiwfVOVVkwdupgrb0QqGtxtHdlaLtDLVqlBeuzNG/ma9pT
oVHlrxgVl5NOeV2nY1gx21QxFTIPvFBa2lmmguYJT25pmP4nmc2/eSb/qHpSAI+A
/MiPlS5zrWu7Po1Efafv7f5ss+1GoyyIX3BDe5bT8rTb4LmLR2kNXb9HpRQYzvvh
omWym1ALukgYdwPI23DeebYd7pR5ZlN31jXYmQ7VQ+q5L6A2P7kJGB5OOhCnvP45
z4jzLw6SEFPel1da1UXN1dcJwk5CeWiY16k4B7gxdY3vrlGz10yNczGovzS1cpQt
bYna4SlZONM=
=3LFC
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
