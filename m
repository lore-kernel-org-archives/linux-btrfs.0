Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35811 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbbBLJ3R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 04:29:17 -0500
Date: Thu, 12 Feb 2015 17:29:09 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix scheduler warning when syncing log
Message-ID: <20150212092908.GF2416@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1423653159-20812-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423653159-20812-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 11, 2015 at 11:12:39AM +0000, Filipe Manana wrote:
> We try to lock a mutex while the current task state is not TASK_RUNNING,
> which results in the following warning when CONFIG_DEBUG_LOCK_ALLOC=y:
> 
> [30736.772501] ------------[ cut here ]------------
> [30736.774545] WARNING: CPU: 9 PID: 19972 at kernel/sched/core.c:7300 __might_sleep+0x8b/0xa8()
> [30736.783453] do not call blocking ops when !TASK_RUNNING; state=2 set at [<ffffffff8107499b>] prepare_to_wait+0x43/0x89
> [30736.786261] Modules linked in: dm_flakey dm_mod crc32c_generic btrfs xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc loop parport_pc psmouse parport pcspkr microcode serio_raw evdev processor thermal_sys i2c_piix4 i2c_core button ext4 crc16 jbd2 mbcache sg sr_mod cdrom sd_mod ata_generic virtio_scsi floppy ata_piix libata virtio_pci virtio_ring e1000 virtio scsi_mod
> [30736.794323] CPU: 9 PID: 19972 Comm: fsstress Not tainted 3.19.0-rc7-btrfs-next-5+ #1
> [30736.795821] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
> [30736.798788]  0000000000000009 ffff88042743fbd8 ffffffff814248ed ffff88043d32f2d8
> [30736.800504]  ffff88042743fc28 ffff88042743fc18 ffffffff81045338 0000000000000001
> [30736.802131]  ffffffff81064514 ffffffff817c52d1 000000000000026d 0000000000000000
> [30736.803676] Call Trace:
> [30736.804256]  [<ffffffff814248ed>] dump_stack+0x4c/0x65
> [30736.805245]  [<ffffffff81045338>] warn_slowpath_common+0xa1/0xbb
> [30736.806360]  [<ffffffff81064514>] ? __might_sleep+0x8b/0xa8
> [30736.807391]  [<ffffffff81045398>] warn_slowpath_fmt+0x46/0x48
> [30736.808511]  [<ffffffff8107499b>] ? prepare_to_wait+0x43/0x89
> [30736.809620]  [<ffffffff8107499b>] ? prepare_to_wait+0x43/0x89
> [30736.810691]  [<ffffffff81064514>] __might_sleep+0x8b/0xa8
> [30736.811703]  [<ffffffff81426eaf>] mutex_lock_nested+0x2f/0x3a0
> [30736.812889]  [<ffffffff8107bfa1>] ? trace_hardirqs_on_caller+0x18f/0x1ab
> [30736.814138]  [<ffffffff8107bfca>] ? trace_hardirqs_on+0xd/0xf
> [30736.819878]  [<ffffffffa038cfff>] wait_for_writer.isra.12+0x91/0xaa [btrfs]
> [30736.821260]  [<ffffffff810748bd>] ? signal_pending_state+0x31/0x31
> [30736.822410]  [<ffffffffa0391f0a>] btrfs_sync_log+0x160/0x947 [btrfs]
> [30736.823574]  [<ffffffff8107bfa1>] ? trace_hardirqs_on_caller+0x18f/0x1ab
> [30736.824847]  [<ffffffff8107bfca>] ? trace_hardirqs_on+0xd/0xf
> [30736.825972]  [<ffffffffa036e555>] btrfs_sync_file+0x2b0/0x319 [btrfs]
> [30736.827684]  [<ffffffff8117901a>] vfs_fsync_range+0x21/0x23
> [30736.828932]  [<ffffffff81179038>] vfs_fsync+0x1c/0x1e
> [30736.829917]  [<ffffffff8117928b>] do_fsync+0x34/0x4e
> [30736.830862]  [<ffffffff811794b3>] SyS_fsync+0x10/0x14
> [30736.831819]  [<ffffffff8142a512>] system_call_fastpath+0x12/0x17
> [30736.832982] ---[ end trace c0b57df60d32ae5c ]---
> 
> Fix this my acquiring the mutex after calling finish_wait(), which sets the
> task's state to TASK_RUNNING.

Good catch.
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/tree-log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index a266587..ea0431d 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2448,8 +2448,8 @@ static void wait_for_writer(struct btrfs_trans_handle *trans,
>  		mutex_unlock(&root->log_mutex);
>  		if (atomic_read(&root->log_writers))
>  			schedule();
> -		mutex_lock(&root->log_mutex);
>  		finish_wait(&root->log_writer_wait, &wait);
> +		mutex_lock(&root->log_mutex);
>  	}
>  }
>  
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
