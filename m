Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35463 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbaGSR77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jul 2014 13:59:59 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS hang with 3.16-rc5
Date: Sat, 19 Jul 2014 19:59:56 +0200
Message-ID: <3378728.FvZP3jOPGh@merkaba>
In-Reply-To: <53C922C6.1020406@fb.com>
References: <1502954.OtX3SzjMKZ@merkaba> <25104768.pskoHShbKc@merkaba> <53C922C6.1020406@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 18. Juli 2014, 09:36:06 schrieb Chris Mason:
> On 07/18/2014 03:51 AM, Martin Steigerwald wrote:
> > Am Dienstag, 15. Juli 2014, 09:21:40 schrieb Chris Mason:
> >> On 07/14/2014 05:58 PM, Martin Steigerwald wrote:
> >>> Am Montag, 14. Juli 2014, 16:12:22 schrieb Chris Mason:
> >>>> On 07/14/2014 11:10 AM, Martin Steigerwald wrote:
> >>>>> Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
> >>>>>> Hi!
> >>>>>> 
> >>>>>> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several
> >>>>>> days
> >>>>>> of
> >>>>>> usage, with 3-16-rc5 I had a hang again. Less than a hour since
> >>>>>> booting
> >>>>>> it.
> >>>>>> 
> >>>>>> Since the hang bug I and others had with 3.15 and upto 3.16-rc2
> >>>>>> usually
> >>>>>> didn´t happen that quickly after boot and since backtrace looks a bit
> >>>>>> different from what I have in memory, I post this in a new thread.
> >>>>>> See thread "Blocked tasks on 3.15.1" for a discussion of previous
> >>>>>> hang
> >>>>>> issues.
> >>>>> 
> >>>>> Probably good to add some basic information on the filesystem:
> >>>> Do you have compression enabled?  I wasn't able to nail down the 3.15.1
> >>>> hang before vacation attacked me, but I'm hoping to track it down
> >>>> today.
> >>> 
> >>> Yes. I have.
> >>> 
> >>> It just hung again while I was playing PlaneShift.
> >>> 
> >>> Back to 3.16-rc4 as rc5 seems to be broke here.
> >> 
> >> The btrfs hang you're hitting goes back to 3.15.  So 3.16-rc4 vs rc5
> >> shouldn't be a factor.  Are you hitting other problems with 3.16?
> > 
> > On this system it is a matter.
> > 
> > 3.16-rc5: Two hangs in one day
> > 
> > 3.16-rc4: No hang so far with three days uptime (well with hibernation
> > cycles in between)
> > 
> > So easy observation for me: 3.16-rc4 fine, 3.16-rc5 broke.
> 
> Can you please try this patch on rc5 and look for the printk:
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3668048..8ab56df 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8157,6 +8157,13 @@ void btrfs_destroy_inode(struct inode *inode)
>  		spin_unlock(&root->fs_info->ordered_root_lock);
>  	}
> 
> +	spin_lock(&root->fs_info->ordered_root_lock);
> +	if (!list_empty(&BTRFS_I(inode)->ordered_operations)) {
> +		list_del_init(&BTRFS_I(inode)->ordered_operations);
> +printk(KERN_CRIT "racing inode deletion with ordered
> operations!!!!!!!!!!!\n"); +	}
> +	spin_unlock(&root->fs_info->ordered_root_lock);
> +
>  	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
>  		     &BTRFS_I(inode)->runtime_flags)) {
>  		btrfs_info(root->fs_info, "inode %llu still on the orphan list",

Did so and again got a hang.

No racing inodes tough:

merkaba:/boot> zgrep -i "racing inode" /var/log/syslog*
merkaba:/boot#1>

Built kernel seems right:

martin@merkaba:[…]> LANG=C grep -ir "racing inode" fs/btrfs
fs/btrfs/inode.c:printk(KERN_CRIT "racing inode deletion with ordered operations!!!!!!!!!!!\n");
Binary file fs/btrfs/inode.o matches
Binary file fs/btrfs/btrfs.o matches
Binary file fs/btrfs/btrfs.ko matches

Backtrace doesn´t seem to contain any function related to inodes.


Back to rc4 again for now.


These hangs seemed to occur first at writing several hundred MiB onto a
high speed SDHC card… yet, they persisted long after the write was finished,
upto to a point where I had to reboot cause machine hung on trying to
switch between tty7 (X11) and tty1 (for diagnosis).



Jul 19 19:29:11 merkaba kernel: [12346.692457] mmc0: new high speed SDHC card at address 0001
Jul 19 19:29:11 merkaba kernel: [12346.744276] mmcblk0: mmc0:0001 00000 29.2 GiB 
Jul 19 19:29:11 merkaba kernel: [12346.769850]  mmcblk0: p1
Jul 19 19:29:20 merkaba kernel: [12355.796267] FAT-fs (mmcblk0p1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case se
nsitive!
Jul 19 19:29:20 merkaba kernel: [12355.805515] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
Jul 19 19:33:27 merkaba kernel: [12602.162818] INFO: task btrfs-transacti:715 blocked for more than 120 seconds.
Jul 19 19:33:27 merkaba kernel: [12602.162826]       Tainted: G           O  3.16.0-rc5-tp520-btrfs-delrace+ #5
Jul 19 19:33:27 merkaba kernel: [12602.162827] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 19 19:33:27 merkaba kernel: [12602.162828] btrfs-transacti D ffff8800cf90e780     0   715      2 0x00000000
Jul 19 19:33:27 merkaba kernel: [12602.162834]  ffff880401ddbc80 0000000000000002 ffff880407fc0000 ffff880401ddbfd8
Jul 19 19:33:27 merkaba kernel: [12602.162836]  ffff8800cf90e240 0000000000013080 ffff8800cf90e240 7fffffffffffffff
Jul 19 19:33:27 merkaba kernel: [12602.162839]  ffff8804018efd28 0000000000000002 ffffffff81470270 ffff8804018efd20
Jul 19 19:33:27 merkaba kernel: [12602.162842] Call Trace:
Jul 19 19:33:27 merkaba kernel: [12602.162856]  [<ffffffff81470270>] ? michael_mic.part.6+0x1e/0x1e
Jul 19 19:33:27 merkaba kernel: [12602.162860]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 19 19:33:27 merkaba kernel: [12602.162862]  [<ffffffff8147029f>] schedule_timeout+0x2f/0x114
Jul 19 19:33:27 merkaba kernel: [12602.162867]  [<ffffffff81062c4d>] ? get_parent_ip+0xd/0x3c
Jul 19 19:33:27 merkaba kernel: [12602.162868]  [<ffffffff81062cf7>] ? preempt_count_add+0x7b/0x8e
Jul 19 19:33:27 merkaba kernel: [12602.162871]  [<ffffffff8147149d>] __wait_for_common+0x11e/0x163
Jul 19 19:33:27 merkaba kernel: [12602.162873]  [<ffffffff8147149d>] ? __wait_for_common+0x11e/0x163
Jul 19 19:33:27 merkaba kernel: [12602.162876]  [<ffffffff810647e9>] ? wake_up_state+0xd/0xd
Jul 19 19:33:27 merkaba kernel: [12602.162879]  [<ffffffff81471501>] wait_for_completion+0x1f/0x21
Jul 19 19:33:27 merkaba kernel: [12602.162916]  [<ffffffffc0423c16>] btrfs_wait_and_free_delalloc_work+0x11/0x23 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.162933]  [<ffffffffc042bb55>] btrfs_run_ordered_operations+0x1ea/0x21a [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.162947]  [<ffffffffc0417392>] btrfs_commit_transaction+0x22/0x8df [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.162959]  [<ffffffffc0413fb6>] transaction_kthread+0x107/0x1b9 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.162970]  [<ffffffffc0413eaf>] ? btrfs_cleanup_transaction+0x43a/0x43a [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.162973]  [<ffffffff81058002>] kthread+0xb2/0xba
Jul 19 19:33:27 merkaba kernel: [12602.162976]  [<ffffffff81470000>] ? iommu_prepare_identity_map+0x1d/0x19d
Jul 19 19:33:27 merkaba kernel: [12602.162978]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 19 19:33:27 merkaba kernel: [12602.162980]  [<ffffffff81473bec>] ret_from_fork+0x7c/0xb0
Jul 19 19:33:27 merkaba kernel: [12602.162982]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 19 19:33:27 merkaba kernel: [12602.162999] INFO: task QThread:2996 blocked for more than 120 seconds.
Jul 19 19:33:27 merkaba kernel: [12602.163000]       Tainted: G           O  3.16.0-rc5-tp520-btrfs-delrace+ #5
Jul 19 19:33:27 merkaba kernel: [12602.163001] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 19 19:33:27 merkaba kernel: [12602.163002] QThread         D ffff8803f71a6780     0  2996      1 0x00000000
Jul 19 19:33:27 merkaba kernel: [12602.163005]  ffff8802df447c18 0000000000000002 ffff880407f649b0 ffff8802df447fd8
Jul 19 19:33:27 merkaba kernel: [12602.163007]  ffff8803f71a6240 0000000000013080 ffff8803f71a6240 ffff88041e293080
Jul 19 19:33:27 merkaba kernel: [12602.163009]  ffff88041e5d5268 ffff8802df447cb0 0000000000000002 ffffffff810daffc
Jul 19 19:33:27 merkaba kernel: [12602.163012] Call Trace:
Jul 19 19:33:27 merkaba kernel: [12602.163015]  [<ffffffff810daffc>] ? wait_on_page_read+0x37/0x37
Jul 19 19:33:27 merkaba kernel: [12602.163017]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 19 19:33:27 merkaba kernel: [12602.163019]  [<ffffffff81470df7>] io_schedule+0x57/0x76
Jul 19 19:33:27 merkaba kernel: [12602.163021]  [<ffffffff810db005>] sleep_on_page+0x9/0xd
Jul 19 19:33:27 merkaba kernel: [12602.163023]  [<ffffffff814711d7>] __wait_on_bit_lock+0x41/0x85
Jul 19 19:33:27 merkaba kernel: [12602.163025]  [<ffffffff810db0c2>] __lock_page+0x70/0x7c
Jul 19 19:33:27 merkaba kernel: [12602.163030]  [<ffffffff81070f79>] ? autoremove_wake_function+0x2f/0x2f
Jul 19 19:33:27 merkaba kernel: [12602.163045]  [<ffffffffc042c58f>] lock_page+0x1e/0x21 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163059]  [<ffffffffc042c58f>] ? lock_page+0x1e/0x21 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163073]  [<ffffffffc043086c>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163076]  [<ffffffff814716d9>] ? mutex_unlock+0x11/0x13
Jul 19 19:33:27 merkaba kernel: [12602.163089]  [<ffffffffc0425ebd>] ? btrfs_file_write_iter+0x322/0x412 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163091]  [<ffffffff81062c4d>] ? get_parent_ip+0xd/0x3c
Jul 19 19:33:27 merkaba kernel: [12602.163105]  [<ffffffffc0430d94>] extent_writepages+0x46/0x57 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163119]  [<ffffffffc041b25a>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163122]  [<ffffffff81075192>] ? cpuacct_account_field+0x55/0x5f
Jul 19 19:33:27 merkaba kernel: [12602.163134]  [<ffffffffc041960f>] btrfs_writepages+0x23/0x25 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163136]  [<ffffffff810e5381>] do_writepages+0x1b/0x24
Jul 19 19:33:27 merkaba kernel: [12602.163138]  [<ffffffff810dc6ad>] __filemap_fdatawrite_range+0x50/0x52
Jul 19 19:33:27 merkaba kernel: [12602.163140]  [<ffffffff810dc714>] filemap_fdatawrite_range+0xe/0x10
Jul 19 19:33:27 merkaba kernel: [12602.163154]  [<ffffffffc0424a26>] btrfs_sync_file+0x84/0x2bd [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163156]  [<ffffffff8120e159>] ? __this_cpu_preempt_check+0x13/0x15
Jul 19 19:33:27 merkaba kernel: [12602.163159]  [<ffffffff81155fab>] vfs_fsync_range+0x1c/0x1e
Jul 19 19:33:27 merkaba kernel: [12602.163161]  [<ffffffff81155fc4>] vfs_fsync+0x17/0x19
Jul 19 19:33:27 merkaba kernel: [12602.163164]  [<ffffffff811561eb>] do_fsync+0x2c/0x45
Jul 19 19:33:27 merkaba kernel: [12602.163166]  [<ffffffff811563d1>] SyS_fsync+0xb/0xf
Jul 19 19:33:27 merkaba kernel: [12602.163168]  [<ffffffff81473e8b>] tracesys+0xdd/0xe2
Jul 19 19:33:27 merkaba kernel: [12602.163193] INFO: task kworker/u8:6:3861 blocked for more than 120 seconds.
Jul 19 19:33:27 merkaba kernel: [12602.163194]       Tainted: G           O  3.16.0-rc5-tp520-btrfs-delrace+ #5
Jul 19 19:33:27 merkaba kernel: [12602.163196] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 19 19:33:27 merkaba kernel: [12602.163196] kworker/u8:6    D ffff880071cccef0     0  3861      2 0x00000000
Jul 19 19:33:27 merkaba kernel: [12602.163202] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-3)
Jul 19 19:33:27 merkaba kernel: [12602.163204]  ffff88029ad179b8 0000000000000002 ffff880407fc6240 ffff88029ad17fd8
Jul 19 19:33:27 merkaba kernel: [12602.163206]  ffff880071ccc9b0 0000000000013080 ffff880071ccc9b0 ffff88041e293080
Jul 19 19:33:27 merkaba kernel: [12602.163209]  ffff88041e5c0268 ffff88029ad17a50 0000000000000002 ffffffff810daffc
Jul 19 19:33:27 merkaba kernel: [12602.163211] Call Trace:
Jul 19 19:33:27 merkaba kernel: [12602.163213]  [<ffffffff810daffc>] ? wait_on_page_read+0x37/0x37
Jul 19 19:33:27 merkaba kernel: [12602.163216]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 19 19:33:27 merkaba kernel: [12602.163218]  [<ffffffff81470df7>] io_schedule+0x57/0x76
Jul 19 19:33:27 merkaba kernel: [12602.163219]  [<ffffffff810db005>] sleep_on_page+0x9/0xd
Jul 19 19:33:27 merkaba kernel: [12602.163222]  [<ffffffff814711d7>] __wait_on_bit_lock+0x41/0x85
Jul 19 19:33:27 merkaba kernel: [12602.163224]  [<ffffffff810db0c2>] __lock_page+0x70/0x7c
Jul 19 19:33:27 merkaba kernel: [12602.163226]  [<ffffffff81070f79>] ? autoremove_wake_function+0x2f/0x2f
Jul 19 19:33:27 merkaba kernel: [12602.163242]  [<ffffffffc042c58f>] lock_page+0x1e/0x21 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163255]  [<ffffffffc042c58f>] ? lock_page+0x1e/0x21 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163269]  [<ffffffffc043086c>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163284]  [<ffffffffc0430d94>] extent_writepages+0x46/0x57 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163296]  [<ffffffffc041b25a>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163298]  [<ffffffff81062cf4>] ? preempt_count_add+0x78/0x8e
Jul 19 19:33:27 merkaba kernel: [12602.163310]  [<ffffffffc041960f>] btrfs_writepages+0x23/0x25 [btrfs]
Jul 19 19:33:27 merkaba kernel: [12602.163312]  [<ffffffff810e5381>] do_writepages+0x1b/0x24
Jul 19 19:33:27 merkaba kernel: [12602.163315]  [<ffffffff81151d0d>] __writeback_single_inode+0x58/0x212
Jul 19 19:33:27 merkaba kernel: [12602.163317]  [<ffffffff81152c0f>] writeback_sb_inodes+0x1e9/0x32e
Jul 19 19:33:27 merkaba kernel: [12602.163319]  [<ffffffff81152dce>] __writeback_inodes_wb+0x7a/0xb0
Jul 19 19:33:27 merkaba kernel: [12602.163321]  [<ffffffff81152f1a>] wb_writeback+0x116/0x270
Jul 19 19:33:27 merkaba kernel: [12602.163323]  [<ffffffff811532c9>] bdi_writeback_workfn+0x171/0x313
Jul 19 19:33:27 merkaba kernel: [12602.163327]  [<ffffffff81052d7c>] process_one_work+0x16f/0x2b8
Jul 19 19:33:27 merkaba kernel: [12602.163329]  [<ffffffff81053626>] worker_thread+0x27b/0x32e
Jul 19 19:33:27 merkaba kernel: [12602.163332]  [<ffffffff810533ab>] ? cancel_delayed_work_sync+0x10/0x10
Jul 19 19:33:27 merkaba kernel: [12602.163334]  [<ffffffff81058002>] kthread+0xb2/0xba
Jul 19 19:33:27 merkaba kernel: [12602.163336]  [<ffffffff81470000>] ? iommu_prepare_identity_map+0x1d/0x19d
Jul 19 19:33:27 merkaba kernel: [12602.163338]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 19 19:33:27 merkaba kernel: [12602.163340]  [<ffffffff81473bec>] ret_from_fork+0x7c/0xb0
Jul 19 19:33:27 merkaba kernel: [12602.163342]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 19 19:33:27 merkaba kernel: [12602.163344] INFO: task kworker/u8:7:3987 blocked for more than 120 seconds.
Jul 19 19:33:27 merkaba kernel: [12602.163346]       Tainted: G           O  3.16.0-rc5-tp520-btrfs-delrace+ #5
Jul 19 19:33:27 merkaba kernel: [12602.163347] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 19 19:33:27 merkaba kernel: [12602.163348] kworker/u8:7    D ffff8803ce039dd0     0  3987      2 0x00000000


Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
