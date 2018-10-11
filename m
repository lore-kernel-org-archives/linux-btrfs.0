Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22F1C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78D1120835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="NpO4SkJY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78D1120835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbeJLDXy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:54 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46784 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDXy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:54 -0400
Received: by mail-qt1-f194.google.com with SMTP id d8-v6so11324872qtk.13
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=2AifJsoYa8VVGHqyfqs2+9dIHUSfR9sXlFu5O/p8l7g=;
        b=NpO4SkJY2sWiUrIZ1cMlLbyuXAFs/M37Cym4C7JSnvPzxJ/7hsQHWoAjBQSJXx3kLM
         tDNkn/gmhzYl4W6u+y/fT1li6e83FUUMb2pgbXYNpCnz9Gfep7gKHCWSwf+2mYoEdMmF
         OplAgK+p1CPKrpWGB8MULJF3uoIMDAR3VSxMaBT3H55aB9O0ny4+MDv1yAYEDdZYmtGV
         he1p79/HvRoT4DN3EX+SMRB3q+OhPIQzkXoyMm9l0fw9pe1K7D/um3Y+Z2Vz7vDidyW+
         BdBhFcJO4XSw/Go7YfJOAeKahFmarRATn/CdgcK9vMxkUqh7eS56TCLT3Usm9WC13a3e
         90Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=2AifJsoYa8VVGHqyfqs2+9dIHUSfR9sXlFu5O/p8l7g=;
        b=jtLShts5BrqH2PqQXWAFSm8Ck7WcNzZOjT/o3h0AJnOlEiKu7Wa0d0ZKcZFOXEiHZL
         2nKMKcAzEvz0Zjg0xfwwsq4CDIQ3mtqtWlkqJrWkxyTTqOsG6RfugikpN415E16EODyI
         HgsuMjSbup6urOkrJHw3iS3Gx/dWr6W5AVJW/pr4gHtT6KNaqzupf8gpHjJCR/NpVTR4
         9FZZD+Qy7tyYHxLJ4dbocnT9z39lbw8rXRZ2ec1kowdIrDcgbdyFWMj6Rab+5D8x//zQ
         QAgrV1LelMVKD6Ked9w/QrEAEYtainbkjkS3lmvxUsyP+oAiXXsTMTukURcV7vQ8CzR+
         nDbQ==
X-Gm-Message-State: ABuFfojnTeWIcSogLdKYOhrGzCoDxlCgoZQymJnErn3FkrJcGemqGQQa
        muv33gq4+MzHcwLBHzZQ5uVGPd8zcnc=
X-Google-Smtp-Source: ACcGV61qKnpkEDoq48KFj6SAYa2bpCHAxXg6Y7QZXNOLZdW8kWg7rMkr1Mgyh5AKjujURlKbJEYp8A==
X-Received: by 2002:aed:2f82:: with SMTP id m2-v6mr2990853qtd.85.1539287708066;
        Thu, 11 Oct 2018 12:55:08 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l43-v6sm17609830qtc.80.2018.10.11.12.55.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:07 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 18/42] btrfs: move the dio_sem higher up the callchain
Date:   Thu, 11 Oct 2018 15:54:07 -0400
Message-Id: <20181011195431.3441-19-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We're getting a lockdep splat because we take the dio_sem under the
log_mutex.  What we really need is to protect fsync() from logging an
extent map for an extent we never waited on higher up, so just guard the
whole thing with dio_sem.

======================================================
WARNING: possible circular locking dependency detected
4.18.0-rc4-xfstests-00025-g5de5edbaf1d4 #411 Not tainted
------------------------------------------------------
aio-dio-invalid/30928 is trying to acquire lock:
0000000092621cfd (&mm->mmap_sem){++++}, at: get_user_pages_unlocked+0x5a/0x1e0

but task is already holding lock:
00000000cefe6b35 (&ei->dio_sem){++++}, at: btrfs_direct_IO+0x3be/0x400

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #5 (&ei->dio_sem){++++}:
       lock_acquire+0xbd/0x220
       down_write+0x51/0xb0
       btrfs_log_changed_extents+0x80/0xa40
       btrfs_log_inode+0xbaf/0x1000
       btrfs_log_inode_parent+0x26f/0xa80
       btrfs_log_dentry_safe+0x50/0x70
       btrfs_sync_file+0x357/0x540
       do_fsync+0x38/0x60
       __ia32_sys_fdatasync+0x12/0x20
       do_fast_syscall_32+0x9a/0x2f0
       entry_SYSENTER_compat+0x84/0x96

-> #4 (&ei->log_mutex){+.+.}:
       lock_acquire+0xbd/0x220
       __mutex_lock+0x86/0xa10
       btrfs_record_unlink_dir+0x2a/0xa0
       btrfs_unlink+0x5a/0xc0
       vfs_unlink+0xb1/0x1a0
       do_unlinkat+0x264/0x2b0
       do_fast_syscall_32+0x9a/0x2f0
       entry_SYSENTER_compat+0x84/0x96

-> #3 (sb_internal#2){.+.+}:
       lock_acquire+0xbd/0x220
       __sb_start_write+0x14d/0x230
       start_transaction+0x3e6/0x590
       btrfs_evict_inode+0x475/0x640
       evict+0xbf/0x1b0
       btrfs_run_delayed_iputs+0x6c/0x90
       cleaner_kthread+0x124/0x1a0
       kthread+0x106/0x140
       ret_from_fork+0x3a/0x50

-> #2 (&fs_info->cleaner_delayed_iput_mutex){+.+.}:
       lock_acquire+0xbd/0x220
       __mutex_lock+0x86/0xa10
       btrfs_alloc_data_chunk_ondemand+0x197/0x530
       btrfs_check_data_free_space+0x4c/0x90
       btrfs_delalloc_reserve_space+0x20/0x60
       btrfs_page_mkwrite+0x87/0x520
       do_page_mkwrite+0x31/0xa0
       __handle_mm_fault+0x799/0xb00
       handle_mm_fault+0x7c/0xe0
       __do_page_fault+0x1d3/0x4a0
       async_page_fault+0x1e/0x30

-> #1 (sb_pagefaults){.+.+}:
       lock_acquire+0xbd/0x220
       __sb_start_write+0x14d/0x230
       btrfs_page_mkwrite+0x6a/0x520
       do_page_mkwrite+0x31/0xa0
       __handle_mm_fault+0x799/0xb00
       handle_mm_fault+0x7c/0xe0
       __do_page_fault+0x1d3/0x4a0
       async_page_fault+0x1e/0x30

-> #0 (&mm->mmap_sem){++++}:
       __lock_acquire+0x42e/0x7a0
       lock_acquire+0xbd/0x220
       down_read+0x48/0xb0
       get_user_pages_unlocked+0x5a/0x1e0
       get_user_pages_fast+0xa4/0x150
       iov_iter_get_pages+0xc3/0x340
       do_direct_IO+0xf93/0x1d70
       __blockdev_direct_IO+0x32d/0x1c20
       btrfs_direct_IO+0x227/0x400
       generic_file_direct_write+0xcf/0x180
       btrfs_file_write_iter+0x308/0x58c
       aio_write+0xf8/0x1d0
       io_submit_one+0x3a9/0x620
       __ia32_compat_sys_io_submit+0xb2/0x270
       do_int80_syscall_32+0x5b/0x1a0
       entry_INT80_compat+0x88/0xa0

other info that might help us debug this:

Chain exists of:
  &mm->mmap_sem --> &ei->log_mutex --> &ei->dio_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ei->dio_sem);
                               lock(&ei->log_mutex);
                               lock(&ei->dio_sem);
  lock(&mm->mmap_sem);

 *** DEADLOCK ***

1 lock held by aio-dio-invalid/30928:
 #0: 00000000cefe6b35 (&ei->dio_sem){++++}, at: btrfs_direct_IO+0x3be/0x400

stack backtrace:
CPU: 0 PID: 30928 Comm: aio-dio-invalid Not tainted 4.18.0-rc4-xfstests-00025-g5de5edbaf1d4 #411
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
Call Trace:
 dump_stack+0x7c/0xbb
 print_circular_bug.isra.37+0x297/0x2a4
 check_prev_add.constprop.45+0x781/0x7a0
 ? __lock_acquire+0x42e/0x7a0
 validate_chain.isra.41+0x7f0/0xb00
 __lock_acquire+0x42e/0x7a0
 lock_acquire+0xbd/0x220
 ? get_user_pages_unlocked+0x5a/0x1e0
 down_read+0x48/0xb0
 ? get_user_pages_unlocked+0x5a/0x1e0
 get_user_pages_unlocked+0x5a/0x1e0
 get_user_pages_fast+0xa4/0x150
 iov_iter_get_pages+0xc3/0x340
 do_direct_IO+0xf93/0x1d70
 ? __alloc_workqueue_key+0x358/0x490
 ? __blockdev_direct_IO+0x14b/0x1c20
 __blockdev_direct_IO+0x32d/0x1c20
 ? btrfs_run_delalloc_work+0x40/0x40
 ? can_nocow_extent+0x490/0x490
 ? kvm_clock_read+0x1f/0x30
 ? can_nocow_extent+0x490/0x490
 ? btrfs_run_delalloc_work+0x40/0x40
 btrfs_direct_IO+0x227/0x400
 ? btrfs_run_delalloc_work+0x40/0x40
 generic_file_direct_write+0xcf/0x180
 btrfs_file_write_iter+0x308/0x58c
 aio_write+0xf8/0x1d0
 ? kvm_clock_read+0x1f/0x30
 ? __might_fault+0x3e/0x90
 io_submit_one+0x3a9/0x620
 ? io_submit_one+0xe5/0x620
 __ia32_compat_sys_io_submit+0xb2/0x270
 do_int80_syscall_32+0x5b/0x1a0
 entry_INT80_compat+0x88/0xa0

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c     | 12 ++++++++++++
 fs/btrfs/tree-log.c |  2 --
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 095f0bb86bb7..c07110edb9de 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2079,6 +2079,14 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 
 	inode_lock(inode);
+
+	/*
+	 * We take the dio_sem here because the tree log stuff can race with
+	 * lockless dio writes and get an extent map logged for an extent we
+	 * never waited on.  We need it this high up for lockdep reasons.
+	 */
+	down_write(&BTRFS_I(inode)->dio_sem);
+
 	atomic_inc(&root->log_batch);
 
 	/*
@@ -2087,6 +2095,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	ret = btrfs_wait_ordered_range(inode, start, len);
 	if (ret) {
+		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);
 		goto out;
 	}
@@ -2110,6 +2119,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		 * checked called fsync.
 		 */
 		ret = filemap_check_wb_err(inode->i_mapping, file->f_wb_err);
+		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);
 		goto out;
 	}
@@ -2128,6 +2138,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);
 		goto out;
 	}
@@ -2149,6 +2160,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * file again, but that will end up using the synchronization
 	 * inside btrfs_sync_log to keep things safe.
 	 */
+	up_write(&BTRFS_I(inode)->dio_sem);
 	inode_unlock(inode);
 
 	/*
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1650dc44a5e3..66b7e059b765 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4374,7 +4374,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 
 	INIT_LIST_HEAD(&extents);
 
-	down_write(&inode->dio_sem);
 	write_lock(&tree->lock);
 	test_gen = root->fs_info->last_trans_committed;
 	logged_start = start;
@@ -4440,7 +4439,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	}
 	WARN_ON(!list_empty(&extents));
 	write_unlock(&tree->lock);
-	up_write(&inode->dio_sem);
 
 	btrfs_release_path(path);
 	if (!ret)
-- 
2.14.3

