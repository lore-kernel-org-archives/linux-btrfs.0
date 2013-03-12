Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab3CLRDQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:03:16 -0400
Date: Tue, 12 Mar 2013 18:03:12 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, sbehrens@giantdisaster.de
Subject: Scrub and raid10 (3.9-rc2+) transid verify failed
Message-ID: <20130312170312.GO7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while testing the userspace scrub updates, I've found lots of parent
transid verify failures (see below) that are likely unrelated to the
userspace patches.

The filesystem was freshly created with raid10/raid10 profiles on 4x10G
partitions (sda5...8) and there was

fs_mark -D 5000 -S0 -n 100000 -s 0 -L 200 -d /mnt/a1/scratch/0
(16x -d ...)

running when I started scrub on /dev/sda5, ran status a few times and
then ran scrub cancel.

Cancel hung

Name:   btrfs   State:  D (disk sleep)  Pid:    24214
[<ffffffffa008f625>] btrfs_scrub_cancel+0xc5/0x130 [btrfs]
[<ffffffffa006ab40>] btrfs_ioctl+0x13b0/0x1d90 [btrfs]
[<ffffffff81172ee6>] do_vfs_ioctl+0x96/0x560
[<ffffffff81173407>] sys_ioctl+0x57/0x90
[<ffffffff819698d9>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

(gdb) l *(btrfs_scrub_cancel+0xc5)
0x8f625 is in btrfs_scrub_cancel (fs/btrfs/scrub.c:2983).
2978            }
2979
2980            atomic_inc(&fs_info->scrub_cancel_req);
2981            while (atomic_read(&fs_info->scrubs_running)) {
2982                    mutex_unlock(&fs_info->scrub_lock);
2983                    wait_event(fs_info->scrub_pause_wait,
2984                               atomic_read(&fs_info->scrubs_running) == 0);
2985                    mutex_lock(&fs_info->scrub_lock);
2986            }
2987            atomic_dec(&fs_info->scrub_cancel_req);

(after a few minutes 'scrub cancel' command exited)

kernel is 3.9-rc2 + chris/for-linus + btrfs-next/master


dmesg:

[22651.740479] parent transid verify failed on 360325120 wanted 14 found 9
[22651.763917] parent transid verify failed on 360325120 wanted 14 found 9
[22663.892497] parent transid verify failed on 368312320 wanted 14 found 9
[22663.909983] parent transid verify failed on 368312320 wanted 14 found 9
[22676.771015] parent transid verify failed on 359682048 wanted 14 found 9
[22676.797895] parent transid verify failed on 359682048 wanted 14 found 9
[22680.280612] parent transid verify failed on 624599040 wanted 14 found 6
[22680.319727] parent transid verify failed on 624599040 wanted 14 found 6
[22680.513037] parent transid verify failed on 624951296 wanted 14 found 6
[22680.527875] parent transid verify failed on 624951296 wanted 14 found 6
[22680.654069] parent transid verify failed on 629182464 wanted 14 found 6
[22680.705581] parent transid verify failed on 629182464 wanted 14 found 6
[22681.441779] parent transid verify failed on 649891840 wanted 14 found 6
[22681.654749] parent transid verify failed on 649891840 wanted 14 found 6
[22684.855123] parent transid verify failed on 633077760 wanted 14 found 6
[22684.881774] parent transid verify failed on 633077760 wanted 14 found 6
[22704.856186] parent transid verify failed on 879251456 wanted 15 found 6
[22704.896118] parent transid verify failed on 879251456 wanted 15 found 6
[22711.964493] parent transid verify failed on 941903872 wanted 15 found 6
[22712.008494] parent transid verify failed on 941903872 wanted 15 found 6
[22716.047185] parent transid verify failed on 941899776 wanted 15 found 6
[22716.091829] parent transid verify failed on 941899776 wanted 15 found 6
[22724.248717] parent transid verify failed on 1057517568 wanted 15 found 11
[22724.304736] parent transid verify failed on 1057517568 wanted 15 found 11
[22727.218745] parent transid verify failed on 1119625216 wanted 15 found 11
[22727.252761] parent transid verify failed on 1119625216 wanted 15 found 11
[22727.258277] parent transid verify failed on 1057624064 wanted 15 found 11
[22727.266859] parent transid verify failed on 1057624064 wanted 15 found 11
[22728.819564] ------------[ cut here ]------------
[22728.825159] WARNING: at fs/btrfs/disk-io.c:478 btree_csum_one_bio+0x101/0x130 [btrfs]()
[22728.834055] Hardware name: Santa Rosa platform
[22728.834059] Modules linked in: dm_crypt loop btrfs
[22728.834062] Pid: 23959, comm: btrfs-worker-1 Not tainted 3.9.0-rc2-default+ #273
[22728.834063] Call Trace:
[22728.834072]  [<ffffffff8104ec8f>] warn_slowpath_common+0x7f/0xc0
[22728.834074]  [<ffffffff8104ecea>] warn_slowpath_null+0x1a/0x20
[22728.834095]  [<ffffffffa002c801>] btree_csum_one_bio+0x101/0x130 [btrfs]
[22728.834110]  [<ffffffffa002c841>] __btree_submit_bio_start+0x11/0x20 [btrfs]
[22728.834122]  [<ffffffffa002ae4e>] run_one_async_start+0x2e/0x40 [btrfs]
[22728.834136]  [<ffffffffa0063d0c>] worker_loop+0xcc/0x5c0 [btrfs]
[22728.834151]  [<ffffffffa0063c40>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
[22728.834155]  [<ffffffff810767ae>] kthread+0xde/0xf0
[22728.834159]  [<ffffffff810818b6>] ? finish_task_switch+0x46/0xf0
[22728.834162]  [<ffffffff810766d0>] ? flush_kthread_worker+0x1e0/0x1e0
[22728.834166]  [<ffffffff8196982c>] ret_from_fork+0x7c/0xb0
[22728.834168]  [<ffffffff810766d0>] ? flush_kthread_worker+0x1e0/0x1e0
[22728.834170] ---[ end trace 04fdcd2de130fbe2 ]---
[22729.351331] parent transid verify failed on 1181786112 wanted 16 found 11
[22729.447539] parent transid verify failed on 1181786112 wanted 16 found 11
[22729.464364] parent transid verify failed on 1181806592 wanted 16 found 11
[22729.597473] parent transid verify failed on 1181806592 wanted 16 found 11
[22730.767507] ------------[ cut here ]------------
[22730.773005] WARNING: at fs/btrfs/disk-io.c:478 btree_csum_one_bio+0x101/0x130 [btrfs]()
[22730.781860] Hardware name: Santa Rosa platform
[22730.787262] Modules linked in: dm_crypt loop btrfs
[22730.793039] Pid: 23959, comm: btrfs-worker-1 Tainted: G        W    3.9.0-rc2-default+ #273
[22730.802296] Call Trace:
[22730.805701]  [<ffffffff8104ec8f>] warn_slowpath_common+0x7f/0xc0
[22730.812666]  [<ffffffff8104ecea>] warn_slowpath_null+0x1a/0x20
[22730.819475]  [<ffffffffa002c801>] btree_csum_one_bio+0x101/0x130 [btrfs]
[22730.827173]  [<ffffffffa002c841>] __btree_submit_bio_start+0x11/0x20 [btrfs]
[22730.835268]  [<ffffffffa002ae4e>] run_one_async_start+0x2e/0x40 [btrfs]
[22730.842971]  [<ffffffffa0063d0c>] worker_loop+0xcc/0x5c0 [btrfs]
[22730.850129]  [<ffffffffa0063c40>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
[22730.858058]  [<ffffffff810767ae>] kthread+0xde/0xf0
[22730.864119]  [<ffffffff810818b6>] ? finish_task_switch+0x46/0xf0
[22730.871197]  [<ffffffff810766d0>] ? flush_kthread_worker+0x1e0/0x1e0
[22730.878750]  [<ffffffff8196982c>] ret_from_fork+0x7c/0xb0
[22730.885284]  [<ffffffff810766d0>] ? flush_kthread_worker+0x1e0/0x1e0
[22730.892850] ---[ end trace 04fdcd2de130fbe3 ]---
[22730.898783] ------------[ cut here ]------------
[22730.904610] WARNING: at fs/btrfs/disk-io.c:478 btree_csum_one_bio+0x101/0x130 [btrfs]()
[22730.913856] Hardware name: Santa Rosa platform
[22730.919508] Modules linked in: dm_crypt loop btrfs
[22730.925680] Pid: 23959, comm: btrfs-worker-1 Tainted: G        W    3.9.0-rc2-default+ #273
[22730.935273] Call Trace:
[22730.939022]  [<ffffffff8104ec8f>] warn_slowpath_common+0x7f/0xc0
[22730.946262]  [<ffffffff8104ecea>] warn_slowpath_null+0x1a/0x20
[22730.953321]  [<ffffffffa002c801>] btree_csum_one_bio+0x101/0x130 [btrfs]
[22730.961387]  [<ffffffffa002c841>] __btree_submit_bio_start+0x11/0x20 [btrfs]
[22730.969698]  [<ffffffffa002ae4e>] run_one_async_start+0x2e/0x40 [btrfs]
[22730.977631]  [<ffffffffa0063d0c>] worker_loop+0xcc/0x5c0 [btrfs]
[22730.984865]  [<ffffffffa0063c40>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
[22730.993049]  [<ffffffff810767ae>] kthread+0xde/0xf0
[22730.999141]  [<ffffffff810818b6>] ? finish_task_switch+0x46/0xf0
[22731.006545]  [<ffffffff810766d0>] ? flush_kthread_worker+0x1e0/0x1e0
[22731.014302]  [<ffffffff8196982c>] ret_from_fork+0x7c/0xb0
[22731.021168]  [<ffffffff810766d0>] ? flush_kthread_worker+0x1e0/0x1e0
[22731.028981] ---[ end trace 04fdcd2de130fbe4 ]---
[22737.956345] parent transid verify failed on 1241690112 wanted 16 found 11
[22737.982335] parent transid verify failed on 1241690112 wanted 16 found 11
[22737.990395] ------------[ cut here ]------------
[22737.996339] WARNING: at fs/btrfs/super.c:255 __btrfs_abort_transaction+0xc1/0xd0 [btrfs]()
[22737.996340] Hardware name: Santa Rosa platform
[22737.996341] btrfs: Transaction aborted
[22737.996345] Modules linked in: dm_crypt loop btrfs
[22737.996348] Pid: 24580, comm: fs_mark Tainted: G        W    3.9.0-rc2-default+ #273
[22737.996349] Call Trace:
[22737.996358]  [<ffffffff8104ec8f>] warn_slowpath_common+0x7f/0xc0
[22737.996361]  [<ffffffff8104ed86>] warn_slowpath_fmt+0x46/0x50
[22737.996370]  [<ffffffffa00080a1>] __btrfs_abort_transaction+0xc1/0xd0 [btrfs]
[22737.996380]  [<ffffffffa001a7e5>] __btrfs_free_extent+0x1e5/0x9e0 [btrfs]
[22737.996396]  [<ffffffffa007d034>] ? btrfs_merge_delayed_refs+0x224/0x3f0 [btrfs]
[22737.996410]  [<ffffffffa007cc25>] ? btrfs_delayed_ref_lock+0x45/0x230 [btrfs]
[22737.996414]  [<ffffffff813abede>] ? do_raw_spin_unlock+0x5e/0xb0
[22737.996425]  [<ffffffffa001f478>] run_clustered_refs+0x628/0xe20 [btrfs]
[22737.996435]  [<ffffffffa0023813>] ? btrfs_run_delayed_refs+0xd3/0x5b0 [btrfs]
[22737.996446]  [<ffffffffa0023828>] btrfs_run_delayed_refs+0xe8/0x5b0 [btrfs]
[22737.996450]  [<ffffffff8196038b>] ? _raw_spin_unlock+0x2b/0x50
[22737.996464]  [<ffffffffa001dabf>] ? btrfs_block_rsv_release+0x4f/0x60 [btrfs]
[22737.996473]  [<ffffffffa001db7e>] ? btrfs_trans_release_metadata+0x6e/0xf0 [btrfs]
[22737.996486]  [<ffffffffa00353d7>] __btrfs_end_transaction+0xf7/0x340 [btrfs]
[22737.996498]  [<ffffffffa0035670>] btrfs_end_transaction+0x10/0x20 [btrfs]
[22737.996511]  [<ffffffffa00453b5>] btrfs_create+0x75/0x220 [btrfs]
[22737.996515]  [<ffffffff8116f709>] vfs_create+0x89/0xc0
[22737.996518]  [<ffffffff8116ff83>] do_last+0x843/0xce0
[22737.996520]  [<ffffffff8116cc0f>] ? link_path_walk+0x8f/0x920
[22737.996523]  [<ffffffff811704db>] path_openat+0xbb/0x490
[22737.996526]  [<ffffffff8117e631>] ? __alloc_fd+0x31/0x130
[22737.996528]  [<ffffffff81170c69>] do_filp_open+0x49/0xa0
[22737.996531]  [<ffffffff8196038b>] ? _raw_spin_unlock+0x2b/0x50
[22737.996533]  [<ffffffff8117e6d7>] ? __alloc_fd+0xd7/0x130
[22737.996537]  [<ffffffff811609d8>] do_sys_open+0x108/0x1f0
[22737.996539]  [<ffffffff81160ae1>] sys_open+0x21/0x30
[22737.996543]  [<ffffffff819698d9>] system_call_fastpath+0x16/0x1b
[22737.996544] ---[ end trace 04fdcd2de130fbe5 ]---
[22737.996547] BTRFS error (device sda8) in __btrfs_free_extent:5488: IO failure
[22737.996548] btrfs is forced readonly
[22737.996551] btrfs: run_one_delayed_ref returned -5
[22737.996555] BTRFS error (device sda8) in btrfs_run_delayed_refs:2656: IO failure
[22743.056678] ------------[ cut here ]------------
[22743.062749] WARNING: at fs/btrfs/disk-io.c:478 btree_csum_one_bio+0x101/0x130 [btrfs]()
[22743.072072] Hardware name: Santa Rosa platform
[22743.072078] Modules linked in: dm_crypt loop btrfs
[22743.072081] Pid: 23959, comm: btrfs-worker-1 Tainted: G        W    3.9.0-rc2-default+ #273
[22743.072083] Call Trace:
[22743.072092]  [<ffffffff8104ec8f>] warn_slowpath_common+0x7f/0xc0
[22743.072095]  [<ffffffff8104ecea>] warn_slowpath_null+0x1a/0x20
[22743.072115]  [<ffffffffa002c801>] btree_csum_one_bio+0x101/0x130 [btrfs]
[22743.072130]  [<ffffffffa002c841>] __btree_submit_bio_start+0x11/0x20 [btrfs]
[22743.072141]  [<ffffffffa002ae4e>] run_one_async_start+0x2e/0x40 [btrfs]
[22743.072155]  [<ffffffffa0063d0c>] worker_loop+0xcc/0x5c0 [btrfs]
[22743.072170]  [<ffffffffa0063c40>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
[22743.072174]  [<ffffffff810767ae>] kthread+0xde/0xf0
[22743.072178]  [<ffffffff810818b6>] ? finish_task_switch+0x46/0xf0
[22743.072181]  [<ffffffff810766d0>] ? flush_kthread_worker+0x1e0/0x1e0
[22743.072185]  [<ffffffff8196982c>] ret_from_fork+0x7c/0xb0
[22743.072187]  [<ffffffff810766d0>] ? flush_kthread_worker+0x1e0/0x1e0


fs_mark log:
FSUse%        Count         Size    Files/sec     App Overhead
    10      1800000            0       5591.2        285491598
    Error in creat: Input/output error
    Error in creat: Input/output error
    Error in creat: Input/output error
    Error in creat: Input/output error
    Error in creat: Input/output error
    Error in creat: Input/output error
    Error in creat: Input/output error
    Error in creat: Input/output error
    Error in creat: Input/output error
    Error in creat: Input/output error
    Error in creat: Input/output error
    Error in creat: Input/output error
    Error in creat: Read-only file system
    Error in creat: Read-only file system
    Error in creat: Read-only file system
    Error in creat: Read-only file system
    Error in creat: Read-only file system
    Error in creat: Read-only file system

