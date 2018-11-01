Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B31C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F37F205F4
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 16:45:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F37F205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbeKBBsr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 21:48:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:60256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725959AbeKBBsr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 21:48:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 797B1AE23;
        Thu,  1 Nov 2018 16:45:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0E6C3DAAFC; Thu,  1 Nov 2018 17:44:48 +0100 (CET)
Date:   Thu, 1 Nov 2018 17:44:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     dsterba@suse.cz, Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Message-ID: <20181101164447.GQ9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
References: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
 <20181101101532.GL9136@twin.jikos.cz>
 <2DCF4F92-0B05-420C-ADEB-3A7A69F6DB37@fb.com>
 <20181101150831.GM9136@twin.jikos.cz>
 <20181101152229.GN9136@twin.jikos.cz>
 <20181101152425.GB18005@vader>
 <20181101152948.GP9136@twin.jikos.cz>
 <20181101160056.GD18005@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101160056.GD18005@vader>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 09:00:56AM -0700, Omar Sandoval wrote:
> > That was an assumption for the demonstration purposes, the wording was
> > confusing sorry.
> 
> Oh, well in that case, that's exactly what kthread_park() is ;) Stop the
> thread and make wake_up a noop, and then we don't need to add special
> cases everywhere else.

The end result is equivalent and should be, I'm now weighing both
approaches. Explicit state tracking outside of the thread structures
seems more clear and in case we want to query the status, we can't after
kthread_stop is called. My current version below.

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 68ca41dbbef3..cc076ae45ced 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -715,6 +715,7 @@ struct btrfs_delayed_root;
 #define BTRFS_FS_BARRIER			1
 #define BTRFS_FS_CLOSING_START			2
 #define BTRFS_FS_CLOSING_DONE			3
+#define BTRFS_FS_CLOSING_SINGLE			19
 #define BTRFS_FS_LOG_RECOVERING			4
 #define BTRFS_FS_OPEN				5
 #define BTRFS_FS_QUOTA_ENABLED			6
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b0ab41da91d1..570096fb3f35 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1801,7 +1801,7 @@ static int transaction_kthread(void *arg)
 			btrfs_end_transaction(trans);
 		}
 sleep:
-		wake_up_process(fs_info->cleaner_kthread);
+		btrfs_wake_up_cleaner(fs_info);
 		mutex_unlock(&fs_info->transaction_kthread_mutex);
 
 		if (unlikely(test_bit(BTRFS_FS_STATE_ERROR,
@@ -3914,7 +3914,7 @@ int btrfs_commit_super(struct btrfs_fs_info *fs_info)
 	mutex_lock(&fs_info->cleaner_mutex);
 	btrfs_run_delayed_iputs(fs_info);
 	mutex_unlock(&fs_info->cleaner_mutex);
-	wake_up_process(fs_info->cleaner_kthread);
+	btrfs_wake_up_cleaner(fs_info);
 
 	/* wait until ongoing cleanup work done */
 	down_write(&fs_info->cleanup_work_sem);
@@ -3956,11 +3956,24 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 
 	cancel_work_sync(&fs_info->async_reclaim_work);
 
+	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state) ||
+	    test_bit(BTRFS_FS_STATE_TRANS_ABORTED, &fs_info->fs_state))
+		btrfs_error_commit_super(fs_info);
+
+	kthread_stop(fs_info->transaction_kthread);
+	kthread_stop(fs_info->cleaner_kthread);
+
+	/*
+	 * btrfs_delete_unused_bgs or btrfs_commit_super can still try to wake
+	 * up the threads but will become a no-op
+	 */
+	set_bit(BTRFS_FS_CLOSING_SINGLE, &fs_info->flags);
+
 	if (!sb_rdonly(fs_info->sb)) {
 		/*
-		 * If the cleaner thread is stopped and there are
-		 * block groups queued for removal, the deletion will be
-		 * skipped when we quit the cleaner thread.
+		 * The cleaner thread is now stopped and if there are block
+		 * groups queued for removal, we have to pick up the work here
+		 * so there are no delayed iputs triggered.
 		 */
 		btrfs_delete_unused_bgs(fs_info);
 
@@ -3969,13 +3982,6 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 			btrfs_err(fs_info, "commit super ret %d", ret);
 	}
 
-	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state) ||
-	    test_bit(BTRFS_FS_STATE_TRANS_ABORTED, &fs_info->fs_state))
-		btrfs_error_commit_super(fs_info);
-
-	kthread_stop(fs_info->transaction_kthread);
-	kthread_stop(fs_info->cleaner_kthread);
-
 	ASSERT(list_empty(&fs_info->delayed_iputs));
 	set_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a990a9045139..a5786b6e8d37 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5915,7 +5915,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 		 * namely it pokes the cleaner kthread that will start
 		 * processing uncleaned subvols.
 		 */
-		wake_up_process(fs_info->transaction_kthread);
+		btrfs_wake_up_transaction(fs_info);
 		return ret;
 	}
 	case BTRFS_IOC_START_SYNC:
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b362b45dd757..9e73e35b94ea 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1896,7 +1896,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		set_bit(BTRFS_FS_OPEN, &fs_info->flags);
 	}
 out:
-	wake_up_process(fs_info->transaction_kthread);
+	btrfs_wake_up_transaction(fs_info);
 	btrfs_remount_cleanup(fs_info, old_opts);
 	return 0;
 
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3717c864ba23..d00311dc76d2 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -154,7 +154,7 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	 * We don't want to do full transaction commit from inside sysfs
 	 */
 	btrfs_set_pending(fs_info, COMMIT);
-	wake_up_process(fs_info->transaction_kthread);
+	btrfs_wake_up_transaction(fs_info);
 
 	return count;
 }
@@ -427,7 +427,7 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	 * We don't want to do full transaction commit from inside sysfs
 	 */
 	btrfs_set_pending(fs_info, COMMIT);
-	wake_up_process(fs_info->transaction_kthread);
+	btrfs_wake_up_transaction(fs_info);
 
 	return len;
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d1eeef9ec5da..3ffed32c680e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -867,7 +867,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		if (throttle)
 			return btrfs_commit_transaction(trans);
 		else
-			wake_up_process(info->transaction_kthread);
+			btrfs_wake_up_transaction(info);
 	}
 
 	if (trans->type & __TRANS_FREEZABLE)
@@ -889,7 +889,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	if (trans->aborted ||
 	    test_bit(BTRFS_FS_STATE_ERROR, &info->fs_state)) {
-		wake_up_process(info->transaction_kthread);
+		btrfs_wake_up_transaction(info);
 		err = -EIO;
 	}
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 4cbb1b55387d..64a38c4af565 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -199,6 +199,25 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans);
 int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 				   int wait_for_unblock);
 
+static inline void btrfs_wake_up_cleaner(struct btrfs_fs_info *fs_info)
+{
+	if (!test_bit(BTRFS_FS_CLOSING_SINGLE, &fs_info->flags)) {
+		wake_up_process(fs_info->cleaner_kthread);
+	} else {
+		btrfs_debug(fs_info,
+			"attempt to wake up cleaner kthread during shutdown");
+	}
+}
+static inline void btrfs_wake_up_transaction(struct btrfs_fs_info *fs_info)
+{
+	if (!test_bit(BTRFS_FS_CLOSING_SINGLE, &fs_info->flags)) {
+		wake_up_process(fs_info->transaction_kthread);
+	} else {
+		btrfs_debug(fs_info,
+			"attempt to wake up transaction kthread during shutdown");
+	}
+}
+
 /*
  * Try to commit transaction asynchronously, so this is safe to call
  * even holding a spinlock.
@@ -210,7 +229,7 @@ static inline void btrfs_commit_transaction_locksafe(
 		struct btrfs_fs_info *fs_info)
 {
 	set_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags);
-	wake_up_process(fs_info->transaction_kthread);
+	btrfs_wake_up_transaction(fs_info);
 }
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans);
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans);
-- 
2.19.1

