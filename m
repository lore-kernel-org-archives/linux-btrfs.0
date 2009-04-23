From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: fix throttle_on_drops deadlock with user
 transactions
Date: Thu, 23 Apr 2009 15:48:17 -0400
Message-ID: <1240516097.28015.20.camel@think.oraclecorp.com>
References: <1239640812-13453-1-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1239640812-13453-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-04-13 at 09:40 -0700, Sage Weil wrote:
> Starting in b7ec40d7845bffca8bb3af2ea3f192d6257bbe21, drop_dirty_roots()
> tries to avoid generating delayed refs in a transaction that is currently
> closing (and trying to flush dirty refs out) by waiting for it to close.
> However, if a transaction is held open by a user space TRANS_START ioctl,
> that will deadlock against throttle_on_drops().
>
> The underlying problem is that by the time we are ready to wait in
> wait_transaction_pre_flush(), drop_dirty_roots() has already signaled its
> intent to drop in fs_info->throttles, and the process calling
> throttle_on_drops() will block.  If the throttling process is part of a
> user transaction, the transaction will never close and we deadlock.
> 

Thanks for this patch,

I think that even if non-userland ioctl code doesn't deadlock it can
wait too long for throttle_on_drops in this case.

Would something like the patch below also work?:

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2869b33..01b1436 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -687,7 +687,13 @@ static noinline int wait_transaction_pre_flush(struct btrfs_fs_info *info)
 		prepare_to_wait(&info->transaction_wait, &wait,
 				TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&info->trans_mutex);
+
+		atomic_dec(&info->throttles);
+		wake_up(&info->transaction_throttle);
+
 		schedule();
+
+		atomic_inc(&info->throttles);
 		mutex_lock(&info->trans_mutex);
 		finish_wait(&info->transaction_wait, &wait);
 	}



