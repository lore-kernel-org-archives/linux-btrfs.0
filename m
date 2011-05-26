From: Adrian Hunter <adrian.hunter@linux.intel.com>
Subject: Re: [PATCH] Btrfs: don't commit the transaction if we dont have enough
 pinned bytes V2
Date: Thu, 26 May 2011 11:57:46 +0300
Message-ID: <4DDE160A.9060803@linux.intel.com>
References: <1306343490-26057-1-git-send-email-josef@redhat.com> <1306351800-3694-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306351800-3694-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 25/05/11 22:30, Josef Bacik wrote:
> I noticed when running an enospc test that we would get stuck committing the
> transaction in check_data_space even though we truly didn't have enough space.
> So check to see if bytes_pinned is bigger than num_bytes, if it's not don't
> commit the transaction.  Thanks,
>
> Signed-off-by: Josef Bacik<josef@redhat.com>
> ---
> V1->V2: Make it so it actually compiles ;)
>   fs/btrfs/extent-tree.c |    7 +++++++
>   1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index c8c3184..b4f67e8 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3199,6 +3199,13 @@ alloc:
>   			}
>   			goto again;
>   		}
> +
> +		/*
> +		 * If we have less pinned bytes than we want to allocate then
> +		 * don't bother committing the transaction, it won't help us.
> +		 */
> +		if (data_sinfo->bytes_pinned<  bytes)
> +			committed = 1;
>   		spin_unlock(&data_sinfo->lock);
>
>   		/* commit the current transaction and try again */

I tried that patch on 2.6.39 with the following:

sudo modprobe brd rd_size=262144
sudo mkfs.btrfs /dev/ram0
sudo mkdir -p /mnt/test
sudo mount -t btrfs /dev/ram0 /mnt/test
sudo mkdir -p /mnt/test/test
sudo chown $USER /mnt/test/test
sudo chgrp $USER /mnt/test/test
sudo umount /mnt/test
i=0
while true; do
	sudo mount -t btrfs /dev/ram0 /mnt/test
	fsstress -c -r -d /mnt/test/test -p 3 -n 1000 -l 10
	sudo umount /mnt/test
	i=`expr $i \+ 1`
	echo $i
done


After 3 iterations it got really slow and then after some minutes it
still seems to lock up:

[ 2059.881182] SysRq : Show Blocked State
[ 2059.881188]   task                        PC stack   pid father
[ 2059.881226] btrfs-transacti D 0000000100046afc     0  2212      2 
0x00000080
[ 2059.881233]  ffff880181483d60 0000000000000046 0000000000000003 
ffff880100000000
[ 2059.881239]  0000000000013a80 0000000000013a80 0000000000013a80 
ffff880184dac530
[ 2059.881244]  0000000000013a80 ffff880181483fd8 0000000000013a80 
0000000000013a80
[ 2059.881249] Call Trace:
[ 2059.881273]  [<ffffffffa02e8780>] wait_for_commit.clone.14+0x90/0xd5 
[btrfs]
[ 2059.881280]  [<ffffffff810692ab>] ? wake_up_bit+0x2a/0x2a
[ 2059.881297]  [<ffffffffa02e95b4>] 
btrfs_commit_transaction+0x102/0x665 [btrfs]
[ 2059.881312]  [<ffffffffa02e8eae>] ? 
join_transaction.clone.21+0x180/0x18b [btrfs]
[ 2059.881316]  [<ffffffff810692ab>] ? wake_up_bit+0x2a/0x2a
[ 2059.881331]  [<ffffffffa02e402e>] transaction_kthread+0x17a/0x22f [btrfs]
[ 2059.881345]  [<ffffffffa02e3eb4>] ? btrfs_congested_fn+0x82/0x82 [btrfs]
[ 2059.881349]  [<ffffffff81068dce>] kthread+0x82/0x8a
[ 2059.881355]  [<ffffffff8147db64>] kernel_thread_helper+0x4/0x10
[ 2059.881359]  [<ffffffff81068d4c>] ? kthread_worker_fn+0x14b/0x14b
[ 2059.881364]  [<ffffffff8147db60>] ? gs_change+0x13/0x13
[ 2059.881366] flush-btrfs-5   D 00000001000f78a6     0  2219      2 
0x00000080
[ 2059.881371]  ffff8801828efb10 0000000000000046 0000000000000754 
ffff880100000000
[ 2059.881376]  0000000000013a80 0000000000013a80 0000000000013a80 
ffff8801a53fc530
[ 2059.881382]  0000000000013a80 ffff8801828effd8 0000000000013a80 
0000000000013a80
[ 2059.881386] Call Trace:
[ 2059.881391]  [<ffffffff814750a4>] schedule_timeout+0x36/0xe3
[ 2059.881396]  [<ffffffff8107b6c2>] ? arch_local_irq_save+0x18/0x1e
[ 2059.881400]  [<ffffffff814762bf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[ 2059.881404]  [<ffffffff8106953e>] ? prepare_to_wait+0x6c/0x79
[ 2059.881419]  [<ffffffffa02e9764>] 
btrfs_commit_transaction+0x2b2/0x665 [btrfs]
[ 2059.881423]  [<ffffffff810692ab>] ? wake_up_bit+0x2a/0x2a
[ 2059.881440]  [<ffffffffa02f2d76>] btrfs_write_inode+0x9b/0xa3 [btrfs]
[ 2059.881445]  [<ffffffff81138d78>] writeback_single_inode+0x125/0x1bf
[ 2059.881450]  [<ffffffff81139055>] writeback_sb_inodes+0xce/0x160
[ 2059.881454]  [<ffffffff81139d68>] wb_writeback+0x257/0x3a7
[ 2059.881459]  [<ffffffff81139f40>] wb_do_writeback+0x88/0x1a0
[ 2059.881464]  [<ffffffff8105b0a1>] ? run_timer_softirq+0x298/0x298
[ 2059.881468]  [<ffffffff8113a0e3>] bdi_writeback_thread+0x8b/0x20c
[ 2059.881473]  [<ffffffff8113a058>] ? wb_do_writeback+0x1a0/0x1a0
[ 2059.881476]  [<ffffffff81068dce>] kthread+0x82/0x8a
[ 2059.881481]  [<ffffffff8147db64>] kernel_thread_helper+0x4/0x10
[ 2059.881485]  [<ffffffff81068d4c>] ? kthread_worker_fn+0x14b/0x14b
[ 2059.881489]  [<ffffffff8147db60>] ? gs_change+0x13/0x13
[ 2059.881493] fsstress        D ffff8801a23f8000     0  2304      1 
0x00000084
[ 2059.881497]  ffff880189c93d48 0000000000000082 0000000000000000 
0000000000000400
[ 2059.881502]  0000000000013a80 0000000000013a80 0000000000013a80 
ffff88017bc59710
[ 2059.881507]  0000000000013a80 ffff880189c93fd8 0000000000013a80 
0000000000013a80
[ 2059.881512] Call Trace:
[ 2059.881517]  [<ffffffff8103dadf>] ? resched_task+0x48/0x72
[ 2059.881522]  [<ffffffff814750a4>] schedule_timeout+0x36/0xe3
[ 2059.881526]  [<ffffffff814762bf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[ 2059.881530]  [<ffffffff8103cc9e>] ? need_resched+0x23/0x2d
[ 2059.881534]  [<ffffffff81474e67>] wait_for_common+0xad/0x102
[ 2059.881539]  [<ffffffff81046df8>] ? try_to_wake_up+0x226/0x226
[ 2059.881543]  [<ffffffff81053dbc>] ? local_bh_enable_ip+0xe/0x10
[ 2059.881548]  [<ffffffff8113cf5c>] ? __sync_filesystem+0x7a/0x7a
[ 2059.881552]  [<ffffffff81474f74>] wait_for_completion+0x1d/0x1f
[ 2059.881556]  [<ffffffff81139717>] sync_inodes_sb+0x91/0x187
[ 2059.881561]  [<ffffffff8113cf5c>] ? __sync_filesystem+0x7a/0x7a
[ 2059.881565]  [<ffffffff8113cf29>] __sync_filesystem+0x47/0x7a
[ 2059.881569]  [<ffffffff8113cf72>] sync_one_sb+0x16/0x18
[ 2059.881574]  [<ffffffff8111d632>] iterate_supers+0x6d/0xc4
[ 2059.881578]  [<ffffffff8113cea7>] sync_filesystems+0x20/0x22
[ 2059.881582]  [<ffffffff8113cfe5>] sys_sync+0x21/0x33
[ 2059.881586]  [<ffffffff8147ca42>] system_call_fastpath+0x16/0x1b
[ 2059.881589] fsstress        D 0000000100045271     0  2306      1 
0x00000084
[ 2059.881594]  ffff88017feaf938 0000000000000086 ffffffff81a0b020 
0000000100045270
[ 2059.881599]  0000000000013a80 0000000000013a80 0000000000013a80 
ffff88017bc5ae20
[ 2059.881604]  0000000000013a80 ffff88017feaffd8 0000000000013a80 
0000000000013a80
[ 2059.881609] Call Trace:
[ 2059.881613]  [<ffffffff814750a4>] schedule_timeout+0x36/0xe3
[ 2059.881617]  [<ffffffff81476256>] ? _raw_spin_lock+0xe/0x10
[ 2059.881622]  [<ffffffff8103e624>] ? task_rq_lock+0x40/0x72
[ 2059.881626]  [<ffffffff814762bf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[ 2059.881630]  [<ffffffff8103cc9e>] ? need_resched+0x23/0x2d
[ 2059.881634]  [<ffffffff81474e67>] wait_for_common+0xad/0x102
[ 2059.881637]  [<ffffffff81046df8>] ? try_to_wake_up+0x226/0x226
[ 2059.881642]  [<ffffffff81053dbc>] ? local_bh_enable_ip+0xe/0x10
[ 2059.881646]  [<ffffffff81474f74>] wait_for_completion+0x1d/0x1f
[ 2059.881650]  [<ffffffff811395bd>] writeback_inodes_sb_nr+0x76/0x7d
[ 2059.881654]  [<ffffffff81139670>] 
writeback_inodes_sb_nr_if_idle+0x41/0x57
[ 2059.881666]  [<ffffffffa02d7fc7>] shrink_delalloc.clone.45+0xa2/0x144 
[btrfs]
[ 2059.881671]  [<ffffffff811ea828>] ? avc_has_perm_flags+0x6c/0x81
[ 2059.881682]  [<ffffffffa02d8162>] 
reserve_metadata_bytes.clone.46+0xf9/0x1b3 [btrfs]
[ 2059.881696]  [<ffffffffa02dac75>] btrfs_block_rsv_add+0x2c/0x4f [btrfs]
[ 2059.881700]  [<ffffffff8103ccb6>] ? should_resched+0xe/0x2e
[ 2059.881713]  [<ffffffffa02dae9e>] 
btrfs_trans_reserve_metadata+0x4f/0x74 [btrfs]
[ 2059.881728]  [<ffffffffa02e9ee9>] start_transaction+0x190/0x24f [btrfs]
[ 2059.881742]  [<ffffffffa02ea2cb>] btrfs_start_transaction+0x13/0x15 
[btrfs]
[ 2059.881758]  [<ffffffffa02f358f>] btrfs_rename+0x158/0x4ae [btrfs]
[ 2059.881763]  [<ffffffff81125b75>] vfs_rename+0x212/0x341
[ 2059.881767]  [<ffffffff81123b66>] ? __lookup_hash+0x95/0xa7
[ 2059.881771]  [<ffffffff8112786d>] sys_renameat+0x198/0x201
[ 2059.881776]  [<ffffffff810a9a62>] ? __call_rcu+0x124/0x12d
[ 2059.881781]  [<ffffffff8103cc9e>] ? need_resched+0x23/0x2d
[ 2059.881785]  [<ffffffff8111c545>] ? fput+0x1d6/0x1e5
[ 2059.881788]  [<ffffffff8112399e>] ? path_put+0x22/0x27
[ 2059.881792]  [<ffffffff810988fb>] ? audit_syscall_entry+0x11c/0x148
[ 2059.881796]  [<ffffffff811278f1>] sys_rename+0x1b/0x1e
[ 2059.881800]  [<ffffffff8147ca42>] system_call_fastpath+0x16/0x1b
[ 2059.881805] sync            D 00000001000f8268     0  2639   2627 
0x00000080
[ 2059.881810]  ffff88017e407d48 0000000000000086 0000000000000000 
0000000000000000
[ 2059.881814]  0000000000013a80 0000000000013a80 0000000000013a80 
ffff880189ce9710
[ 2059.881819]  0000000000013a80 ffff88017e407fd8 0000000000013a80 
0000000000013a80
[ 2059.881824] Call Trace:
[ 2059.881828]  [<ffffffff814750a4>] schedule_timeout+0x36/0xe3
[ 2059.881833]  [<ffffffff814762bf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[ 2059.881837]  [<ffffffff8103cc9e>] ? need_resched+0x23/0x2d
[ 2059.881841]  [<ffffffff81474e67>] wait_for_common+0xad/0x102
[ 2059.881844]  [<ffffffff81046df8>] ? try_to_wake_up+0x226/0x226
[ 2059.881849]  [<ffffffff81053dbc>] ? local_bh_enable_ip+0xe/0x10
[ 2059.881853]  [<ffffffff8113cf5c>] ? __sync_filesystem+0x7a/0x7a
[ 2059.881857]  [<ffffffff81474f74>] wait_for_completion+0x1d/0x1f
[ 2059.881861]  [<ffffffff811395bd>] writeback_inodes_sb_nr+0x76/0x7d
[ 2059.881865]  [<ffffffff811395e6>] writeback_inodes_sb+0x22/0x24
[ 2059.881869]  [<ffffffff8113cf33>] __sync_filesystem+0x51/0x7a
[ 2059.881874]  [<ffffffff8113cf72>] sync_one_sb+0x16/0x18
[ 2059.881877]  [<ffffffff8111d632>] iterate_supers+0x6d/0xc4
[ 2059.881882]  [<ffffffff8113cea7>] sync_filesystems+0x20/0x22
[ 2059.881886]  [<ffffffff8113cfdb>] sys_sync+0x17/0x33
[ 2059.881890]  [<ffffffff8147ca42>] system_call_fastpath+0x16/0x1b
