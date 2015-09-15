Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:54399
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbbIOTIf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 15:08:35 -0400
Subject: Re: [PATCH V2] Btrfs: keep dropped roots in cache until transaction
 commit
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
References: <1442326024-2536-1-git-send-email-jbacik@fb.com>
 <55F83E34.3090900@googlemail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <55F86CB1.5020503@googlemail.com>
Date: Tue, 15 Sep 2015 21:08:33 +0200
MIME-Version: 1.0
In-Reply-To: <55F83E34.3090900@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/15 17:50, Holger Hoffstätte wrote:
> This V2 does indeed seem to fix the issues I reported with snapshot
> deletion & concurrent sync. I've now created/filled/deleted countless
> snapshots while issuing sync(s) in parallel, and the problem that I
> saw fairly frequently with V1 no longer seems to occur here.

Well..I may have spoken too soon:

[20502.470227] ------------[ cut here ]------------
[20502.470247] WARNING: CPU: 0 PID: 27322 at fs/btrfs/transaction.c:66 btrfs_put_transaction+0xb7/0x100 [btrfs]()
[20502.470248] Modules linked in: btrfs nfsd auth_rpcgss oid_registry lockd grace sunrpc sch_fq_codel xor snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp raid6_pq crc32_pclmul i915 crc32c_intel aesni_intel snd_hda_intel aes_x86_64 intel_gtt glue_helper lrw snd_hda_controller i2c_algo_bit gf128mul ablk_helper drm_kms_helper snd_hda_codec cryptd usbhid snd_hda_core drm snd_pcm i2c_i801 snd_timer snd r8169 i2c_core soundcore mii video [last unloaded: btrfs]
[20502.470279] CPU: 0 PID: 27322 Comm: btrfs-transacti Not tainted 4.1.7 #1
[20502.470280] Hardware name: System manufacturer System Product Name/P8Z68-V LX, BIOS 4105 07/01/2013
[20502.470281]  ffffffffa0843635 ffff8800c096fd48 ffffffff8156eae1 0000000000000007
[20502.470282]  0000000000000000 ffff8800c096fd88 ffffffff8105098a 0000000000000296
[20502.470284]  ffff8802865a1d40 ffff8802865a1d40 ffff88014b5b5678 0000000000000000
[20502.470285] Call Trace:
[20502.470289]  [<ffffffff8156eae1>] dump_stack+0x45/0x57
[20502.470292]  [<ffffffff8105098a>] warn_slowpath_common+0x8a/0xc0
[20502.470293]  [<ffffffff81050a7a>] warn_slowpath_null+0x1a/0x20
[20502.470298]  [<ffffffffa07c1027>] btrfs_put_transaction+0xb7/0x100 [btrfs]
[20502.470303]  [<ffffffffa07c280d>] btrfs_commit_transaction+0xb3d/0xc10 [btrfs]
[20502.470308]  [<ffffffffa07bd305>] transaction_kthread+0x245/0x260 [btrfs]
[20502.470313]  [<ffffffffa07bd0c0>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[20502.470315]  [<ffffffff8106ddc9>] kthread+0xc9/0xe0
[20502.470317]  [<ffffffff8106dd00>] ? kthread_worker_fn+0x170/0x170
[20502.470319]  [<ffffffff81573f52>] ret_from_fork+0x42/0x70
[20502.470320]  [<ffffffff8106dd00>] ? kthread_worker_fn+0x170/0x170
[20502.470321] ---[ end trace 0556ec192b60907f ]---
[20532.457806] ------------[ cut here ]------------
[20532.457828] WARNING: CPU: 0 PID: 27322 at fs/btrfs/transaction.c:66 btrfs_put_transaction+0xb7/0x100 [btrfs]()
[20532.457829] Modules linked in: btrfs nfsd auth_rpcgss oid_registry lockd grace sunrpc sch_fq_codel xor snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp raid6_pq crc32_pclmul i915 crc32c_intel aesni_intel snd_hda_intel aes_x86_64 intel_gtt glue_helper lrw snd_hda_controller i2c_algo_bit gf128mul ablk_helper drm_kms_helper snd_hda_codec cryptd usbhid snd_hda_core drm snd_pcm i2c_i801 snd_timer snd r8169 i2c_core soundcore mii video [last unloaded: btrfs]
[20532.457872] CPU: 0 PID: 27322 Comm: btrfs-transacti Tainted: G        W       4.1.7 #1
[20532.457873] Hardware name: System manufacturer System Product Name/P8Z68-V LX, BIOS 4105 07/01/2013
[20532.457873]  ffffffffa0843635 ffff8800c096fd48 ffffffff8156eae1 0000000000000007
[20532.457875]  0000000000000000 ffff8800c096fd88 ffffffff8105098a 0000000000000296
[20532.457876]  ffff8802865a1d40 ffff8802865a1d40 ffff8801123dc678 0000000000000000
[20532.457878] Call Trace:
[20532.457882]  [<ffffffff8156eae1>] dump_stack+0x45/0x57
[20532.457884]  [<ffffffff8105098a>] warn_slowpath_common+0x8a/0xc0
[20532.457885]  [<ffffffff81050a7a>] warn_slowpath_null+0x1a/0x20
[20532.457890]  [<ffffffffa07c1027>] btrfs_put_transaction+0xb7/0x100 [btrfs]
[20532.457895]  [<ffffffffa07c280d>] btrfs_commit_transaction+0xb3d/0xc10 [btrfs]
[20532.457901]  [<ffffffffa07bd305>] transaction_kthread+0x245/0x260 [btrfs]
[20532.457905]  [<ffffffffa07bd0c0>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[20532.457907]  [<ffffffff8106ddc9>] kthread+0xc9/0xe0
[20532.457909]  [<ffffffff8106dd00>] ? kthread_worker_fn+0x170/0x170
[20532.457911]  [<ffffffff81573f52>] ret_from_fork+0x42/0x70
[20532.457912]  [<ffffffff8106dd00>] ? kthread_worker_fn+0x170/0x170
[20532.457913] ---[ end trace 0556ec192b609080 ]---

As expected pid 27322 is the [btrfs-transacti] thread. It now seems to happen
(just did twice in a row) when I delete a snapshot but *don't* sync, but instead
just let it smurf along all by itself.

This warning is from:

..
void btrfs_put_transaction(struct btrfs_transaction *transaction)
{
	WARN_ON(atomic_read(&transaction->use_count) == 0);
	if (atomic_dec_and_test(&transaction->use_count)) {
		BUG_ON(!list_empty(&transaction->list));
		WARN_ON(!RB_EMPTY_ROOT(&transaction->delayed_refs.href_root));
		if (transaction->delayed_refs.pending_csums)
..

Once this happens unmounting results in:

..blabla..
[21618.982176] BTRFS error (device sdc1): unable to find ref byte nr 628535836672 parent 0 root 1 owner 0 offset 0
[21618.982176] ------------[ cut here ]------------
[21618.982181] WARNING: CPU: 1 PID: 387 at fs/btrfs/extent-tree.c:6363 __btrfs_free_extent.isra.33+0x960/0xdf0 [btrfs]()
[21618.982181] BTRFS: Transaction aborted (error -2)
[21618.982182] Modules linked in: btrfs nfsd auth_rpcgss oid_registry lockd grace sunrpc sch_fq_codel xor snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp raid6_pq crc32_pclmul i915 crc32c_intel aesni_intel snd_hda_intel aes_x86_64 intel_gtt glue_helper lrw snd_hda_controller i2c_algo_bit gf128mul ablk_helper drm_kms_helper snd_hda_codec cryptd usbhid snd_hda_core drm snd_pcm i2c_i801 snd_timer snd r8169 i2c_core soundcore mii video [last unloaded: btrfs]
[21618.982196] CPU: 1 PID: 387 Comm: umount Tainted: G        W       4.1.7 #1
[21618.982196] Hardware name: System manufacturer System Product Name/P8Z68-V LX, BIOS 4105 07/01/2013
[21618.982197]  ffffffffa0842df0 ffff88014336b948 ffffffff8156eae1 0000000000000007
[21618.982198]  ffff88014336b998 ffff88014336b988 ffffffff8105098a ffffffffa0842d5a
[21618.982199]  00000000fffffffe 0000009257a7c000 0000000000000000 ffff8803c9350000
[21618.982201] Call Trace:
[21618.982202]  [<ffffffff8156eae1>] dump_stack+0x45/0x57
[21618.982203]  [<ffffffff8105098a>] warn_slowpath_common+0x8a/0xc0
[21618.982204]  [<ffffffff81050a06>] warn_slowpath_fmt+0x46/0x50
[21618.982208]  [<ffffffffa07a5330>] __btrfs_free_extent.isra.33+0x960/0xdf0 [btrfs]
[21618.982214]  [<ffffffffa080ce1d>] ? btrfs_delayed_ref_lock+0x3d/0x270 [btrfs]
[21618.982219]  [<ffffffffa07a9802>] __btrfs_run_delayed_refs+0x9c2/0x1110 [btrfs]
[21618.982224]  [<ffffffffa07acdb3>] btrfs_run_delayed_refs.part.38+0x73/0x280 [btrfs]
[21618.982228]  [<ffffffffa07b0dbe>] btrfs_start_dirty_block_groups+0x35e/0x410 [btrfs]
[21618.982234]  [<ffffffffa07c1e95>] btrfs_commit_transaction+0x1c5/0xc10 [btrfs]
[21618.982239]  [<ffffffffa07c2976>] ? start_transaction+0x96/0x510 [btrfs]
[21618.982244]  [<ffffffffa07bba23>] btrfs_commit_super+0x93/0xa0 [btrfs]
[21618.982248]  [<ffffffffa07bd5b4>] close_ctree+0x294/0x350 [btrfs]
[21618.982252]  [<ffffffffa0790dd9>] btrfs_put_super+0x19/0x20 [btrfs]
[21618.982253]  [<ffffffff8117535a>] generic_shutdown_super+0x6a/0xf0
[21618.982254]  [<ffffffff81175646>] kill_anon_super+0x16/0x30
[21618.982258]  [<ffffffffa07906e8>] btrfs_kill_super+0x18/0x110 [btrfs]
[21618.982259]  [<ffffffff811759f9>] deactivate_locked_super+0x49/0x80
[21618.982260]  [<ffffffff81175e6c>] deactivate_super+0x6c/0x80
[21618.982261]  [<ffffffff81192a53>] cleanup_mnt+0x43/0xa0
[21618.982263]  [<ffffffff81192b02>] __cleanup_mnt+0x12/0x20
[21618.982264]  [<ffffffff8106c387>] task_work_run+0xa7/0xe0
[21618.982265]  [<ffffffff81002b9d>] do_notify_resume+0x6d/0x70
[21618.982266]  [<ffffffff81573d42>] int_signal+0x12/0x17
[21618.982267] ---[ end trace 0556ec192b609086 ]---
[21618.982269] BTRFS: error (device sdc1) in __btrfs_free_extent:6363: errno=-2 No such entry
[21618.982800] BTRFS info (device sdc1): forced readonly
[21618.982802] BTRFS: error (device sdc1) in btrfs_run_delayed_refs:2863: errno=-2 No such entry
[21618.983332] BTRFS error (device sdc1): commit super ret -2
[21618.983407] BTRFS error (device sdc1): cleaner transaction attach returned -30

Sorry..

-h
