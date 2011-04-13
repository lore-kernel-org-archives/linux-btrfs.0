From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] Btrfs: do not release delalloc space until after we end
 the transaction
Date: Thu, 14 Apr 2011 00:08:28 +0200
Message-ID: <4DA61EDC.50907@gmx.net>
References: <1302720847-32284-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302720847-32284-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 13.04.2011 20:54, Josef Bacik wrote:
> There have been many sporadic reports of the following panic
>
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/extent-tree.c:5498!
> invalid opcode: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
> CPU 7
> Modules linked in: btrfs zlib_deflate libcrc32c netconsole configfs ipt_MASQUERADE iptable_nat nf_nat bridge stp llc sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 dm_multipath kvm uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd hp_wmi i5400_edac sparse_keymap iTCO_wdt rfkill edac_core tg3 shpchp iTCO_vendor_support soundcore wmi floppy snd_page_alloc pcspkr i5k_amb [last unloaded: btrfs]
>
> Pid: 28504, comm: btrfs-endio-wri Tainted: G        W   2.6.39-rc2+ #35 Hewlett-Packard HP xw6600 Workstation/0A9Ch
> RIP: 0010:[<ffffffffa044ec34>]  [<ffffffffa044ec34>] alloc_reserved_file_extent+0x9a/0x1e5 [btrfs]
> RSP: 0018:ffff88000b4319f0  EFLAGS: 00010286
> RAX: 00000000ffffffe4 RBX: ffff880009fdc438 RCX: ffff880020c216d0
> RDX: ffff88000b4318c0 RSI: 00000000000000d5 RDI: 0000000000000000
> RBP: ffff88000b431a70 R08: 00000000ffffffe4 R09: ffff880020c216d0
> R10: 0000000000000001 R11: ffff88000b431b10 R12: ffff88000b431b10
> R13: 00000000000000b2 R14: 0000000000000000 R15: ffff88002225f2f8
> FS:  0000000000000000(0000) GS:ffff88003e400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000003738ca6940 CR3: 000000002a39a000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process btrfs-endio-wri (pid: 28504, threadinfo ffff88000b430000, task ffff880032278000)
> Stack:
>   0000000000000001 ffff88002a920000 ffff88000000001d 000000000000038d
>   0000000000000000 0000000000000005 ffff88003aa38000 ffffffff81481012
>   ffff88000c3bb480 ffff8800241d01c8 ffff88000b431a60 ffff880031a040a8
> Call Trace:
>   [<ffffffff81481012>] ? sub_preempt_count+0x97/0xaa
>   [<ffffffffa044f92e>] run_clustered_refs+0x61b/0x700 [btrfs]
>   [<ffffffff81480f89>] ? sub_preempt_count+0xe/0xaa
>   [<ffffffffa0446ee9>] ? spin_lock+0xe/0x10 [btrfs]
>   [<ffffffffa044fae4>] btrfs_run_delayed_refs+0xd1/0x1ab [btrfs]
>   [<ffffffff8147dc1c>] ? _raw_spin_unlock+0x4a/0x57
>   [<ffffffffa045af1b>] __btrfs_end_transaction+0x89/0x1ed [btrfs]
>   [<ffffffffa045b0c2>] btrfs_end_transaction+0x15/0x17 [btrfs]
>   [<ffffffffa0466932>] btrfs_finish_ordered_io+0x29c/0x2bf [btrfs]
>   [<ffffffffa04669d6>] btrfs_writepage_end_io_hook+0x81/0x8d [btrfs]
>   [<ffffffffa0477fd5>] end_bio_extent_writepage+0xae/0x159 [btrfs]
>   [<ffffffff811457e3>] bio_endio+0x2d/0x2f
>   [<ffffffffa0456c44>] end_workqueue_fn+0x111/0x120 [btrfs]
>   [<ffffffffa0480a0e>] worker_loop+0x192/0x4d1 [btrfs]
>   [<ffffffffa048087c>] ? btrfs_queue_worker+0x22c/0x22c [btrfs]
>   [<ffffffff81068a69>] kthread+0xa0/0xa8
>   [<ffffffff8107a847>] ? trace_hardirqs_on_caller+0x111/0x135
>   [<ffffffff81485364>] kernel_thread_helper+0x4/0x10
>   [<ffffffff8147e398>] ? retint_restore_args+0x13/0x13
>   [<ffffffff810689c9>] ? __init_kthread_worker+0x5b/0x5b
>   [<ffffffff81485360>] ? gs_change+0x13/0x13
> Code: 44 8b 45 90 0f 84 58 01 00 00 80 88 88 00 00 00 08 41 83 c0 18 4c 89 e1 48 8b 72 20 4c 89 ff 48 89 c2 e8 1f b4 ff ff 85 c0 74 04<0f>  0b eb fe 48 8b 03 48 89 45 c8 8b 73 40 48 89 c7 e8 bc 98 ff
> RIP  [<ffffffffa044ec34>] alloc_reserved_file_extent+0x9a/0x1e5 [btrfs]
>   RSP<ffff88000b4319f0>
> ---[ end trace 81d1c68cb00af83e ]---
>
> This is because we have been releasing the delalloc bytes before ending the
> transaction.  However the way we make allocations, any updates to the
> extent_tree are delayed and then run when the transaction runs, so we still have
> plenty of space that we need to use.  So instead release the delalloc bytes
> _after_ we end the transaction so that we don't get this false ENOSPC.  Thanks,
>
> Signed-off-by: Josef Bacik<josef@redhat.com>
> ---
>   fs/btrfs/inode.c |    8 ++++++--
>   1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ade00e7..b1e5b11 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1783,9 +1783,13 @@ out:
>   		if (trans)
>   			btrfs_end_transaction_nolock(trans, root);
>   	} else {
> -		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
>   		if (trans)
>   			btrfs_end_transaction(trans, root);
> +		/*
> +		 * Release after the transaction ends so it covers the delayed
> +		 * ref updates
> +		 */
> +		btrfs_delalloc_release_metadata(inode, ordered_extent->len);

I think calling end_transaction doesn't guarantee you that all delayed
refs have run, only if end_transaction leads to commit transaction.
Another problem I see is that commit_transaction just uses the block_rsv
of whatever trans happened to call commit, even if the trans->block_rsv
have been set to a different block_rsv than trans_block_rsv or
delalloc_block_rsv. In other words, the relayed_refs are run from a non-
deterministic block_rsv.
But it's late, I'll think more about it tomorrow.

-Arne

>   	}
>
>   	/* once for us */
> @@ -5897,8 +5901,8 @@ out_unlock:
>   			     ordered->file_offset + ordered->len - 1,
>   			&cached_state, GFP_NOFS);
>   out:
> -	btrfs_delalloc_release_metadata(inode, ordered->len);
>   	btrfs_end_transaction(trans, root);
> +	btrfs_delalloc_release_metadata(inode, ordered->len);
>   	ordered_offset = ordered->file_offset + ordered->len;
>   	btrfs_put_ordered_extent(ordered);
>   	btrfs_put_ordered_extent(ordered);

