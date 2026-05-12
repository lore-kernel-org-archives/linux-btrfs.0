Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9DD2D7380
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 06:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778568846; cv=none; b=HC0dK6L0r3dFQOXLnp1eBVkXWS1gLFrVQYnxCk9EMy0AZ6B1OuufcYdggTZ3TTTiT0lp7M2hDR8GARCcyl7Mq95c7TAR5G8fThZSbAgRJAUseAkJrGHIVpTrIngGuQF6DjWLAnkYP7wf2E2lrzgXcmuTL/30iUe2Pwky+OLYE8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778568846; c=relaxed/simple;
	bh=Jc1m1IUDArX2QoWk/HBwHBGJDb68YqUn7z8oraVziZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M5TDO/NuQGXb7u9macqgnMGBxQEsu4vbpTGxrBvp0JaKZzNXq/vcje5N7xRqIcAAnV9WY9TVa6rwkvLJ3B+9Wtb7t89JOC9SiOiwgz8qVxWLL7k8y2Cii/sqxqi9G238CfL7jg2LYuIQr/sbVBAGTfWqxZ/x7LOEQqnZUtTV5w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N//g0yFd; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N//g0yFd"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-83537a80ab6so3226107b3a.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 23:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778568835; x=1779173635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5XIipxrPOhLVSzfAlyOUeheag6i9nRgqSLEtBqDcE9Y=;
        b=N//g0yFd21D+5B4TqDrhBdPRCQQJyvWz2NGZvB3urdf/zJJw7OZcpdP+/2DNZu61EE
         kcwL6jolX5DOYmKf0L7SCRO6AU4k60757RawBZh6E+Osx6EMD4jfgtVn+fssvgfRbxuk
         QbsdnHuIl+h5mws0NmP+IdyG1A6LbRYdteSzPh82K6Fhk5FaCWm0JI3g4nlhr+4dDV9b
         cHnrODL9XiirzYjmfZhPpDlmaRmJ20G0pYcKAeitfhu4XkdNqeQ3AOmPb5ndg8ZXnQcB
         7mnN51Mj5rHS1kuMgbfZH1vNEi/xiZt8SFxWhoU30ON9V6h43MrAknbg7u7J6jT1ZkAp
         u0yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778568835; x=1779173635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5XIipxrPOhLVSzfAlyOUeheag6i9nRgqSLEtBqDcE9Y=;
        b=lKw42pRumYVL3vdW0fcnX/bYTzvK6hIH/fxa7jzLSfAfxaWiRS/2S1TcRR7C1PhD0h
         3xTDgD38YIJHHJr9awWUEWcrFHdWSIYccMZVy5kTkFWAx6BwVJntxKJpPSYLtiKiKqlK
         L9SZGzq6arz1/XUG6xuUOsB+ezMrAubO97ZGLTLUTpRbmtPQLdR3Epl6STMJDUQb/EcX
         iOLj5ArFvsx2gNsGXxRDTMXjKsTLNwoMVomeSVe50t64QDPw7l7ueCM3wYb1mcYMOH1J
         369SEUzhcF6H8PUZ4gmAaCWCvyyoyejUBUQ+Lf98u2LN3T9ghjD4Ulb+gKPOkqLgN6Qa
         Zebw==
X-Gm-Message-State: AOJu0YwN2gFBmhH37jz6tmBZC1jiA0FVMQVQG/ck5Gzls9RagE5eTysS
	8ibk9fg0ccKh1/8M7oPaE58haePOfYUESGDSwNw7q9mMrgVVNXj0SrKz
X-Gm-Gg: Acq92OG7RkscG9xe4vU8qn6XEaE2tYFH2RTIIsb5QoXlWp1rq8xGJWdRrhpjrfdZVAz
	4Okt9QO6wqHnU4l9v+rrQff+RTfPJsO/dB5MC/Xgxpjy6xEE4Z0VwStoif9hPJhe4xV9KYnSor8
	F8qreMb1SwUcBUotcg1K32PqeYtgT+FYn/AAMtBOIMNNYexep9f20Ft/RttR66VXv4fcY8mE41H
	ofmWUVO762CfiptpxWgfAM+WLaxAaF48PU1ezgZNkj3rexdJVraDuZX5VsZXzmkNh9zUTXPGOeA
	qRVCIX/5/wZ9jWIJiw6LJXM1wuMn0X/ClKVSazB75dOyTvwxUQeHCT8ELt/pmWwlbIjJN3eJxME
	gx6nldMaWCrH/rwZhRlrNm35jeAAqYjAOojfPt+23/sLN3dEoH5ETNOvxLXpXo9zwlQM4oBjbqK
	vfX3nPat21WoNdzfW1Z7JYw49bzs6c+0yIeP0DWSTSus/2SFaqGiF+6MaCBQd47UIwlg==
X-Received: by 2002:aa7:9313:0:b0:835:45bf:9660 with SMTP id d2e1a72fcca58-83e3b7b64f6mr12587821b3a.42.1778568834754;
        Mon, 11 May 2026 23:53:54 -0700 (PDT)
Received: from gmail.com ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8396563f111sm21995232b3a.4.2026.05.11.23.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 23:53:54 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] btrfs: lock balance status ioctls against shutdown
Date: Tue, 12 May 2026 14:53:41 +0800
Message-ID: <20260512065342.537219-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A KASAN slab-use-after-free was reported while querying balance
progress:

BUG: KASAN: slab-use-after-free in owner_on_cpu include/linux/sched.h:2282 [inline]
BUG: KASAN: slab-use-after-free in mutex_can_spin_on_owner+0x1cf/0x1f0 kernel/locking/mutex.c:397
Read of size 4 at addr ffff888012700034 by task syz.0.130/433

Call Trace:
 ...
 owner_on_cpu include/linux/sched.h:2282 [inline]
 mutex_can_spin_on_owner+0x1cf/0x1f0 kernel/locking/mutex.c:397
 mutex_optimistic_spin kernel/locking/mutex.c:440 [inline]
 __mutex_lock_common kernel/locking/mutex.c:602 [inline]
 __mutex_lock+0x2e8/0x1d80 kernel/locking/mutex.c:760
 mutex_lock_nested+0x1b/0x30 kernel/locking/mutex.c:812
 btrfs_ioctl_balance_progress fs/btrfs/ioctl.c:3620 [inline]
 btrfs_ioctl+0x3f20/0x5b90 fs/btrfs/ioctl.c:5317
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
 ...

Allocated by task 291:
 ...
 slab_post_alloc_hook mm/slub.c:4978 [inline]
 slab_alloc_node mm/slub.c:5288 [inline]
 kmem_cache_alloc_node_noprof+0x1f9/0x7c0 mm/slub.c:5340
 alloc_task_struct_node kernel/fork.c:184 [inline]
 dup_task_struct kernel/fork.c:873 [inline]
 copy_process+0x3d3/0x6e30 kernel/fork.c:2012
 kernel_clone+0xe7/0x880 kernel/fork.c:2609
 __do_sys_clone+0xf5/0x150 kernel/fork.c:2750
 __se_sys_clone kernel/fork.c:2734 [inline]
 __x64_sys_clone+0xc3/0x160 kernel/fork.c:2734
 ...

Freed by task 24:
 ...
 slab_free_hook mm/slub.c:2543 [inline]
 slab_free mm/slub.c:6642 [inline]
 kmem_cache_free+0x384/0x7a0 mm/slub.c:6752
 free_task_struct kernel/fork.c:189 [inline]
 free_task+0x106/0x160 kernel/fork.c:512
 __put_task_struct+0x209/0x3b0 kernel/fork.c:748
 __put_task_struct_rcu_cb+0x1e/0x30 kernel/fork.c:756
 rcu_do_batch+0x397/0xe40 kernel/rcu/tree.c:2605
 rcu_core+0x669/0xa10 kernel/rcu/tree.c:2861
 rcu_core_si+0xe/0x20 kernel/rcu/tree.c:2878
 handle_softirqs+0x1d6/0x840 kernel/softirq.c:622
 run_ksoftirqd kernel/softirq.c:1063 [inline]
 run_ksoftirqd+0x3e/0x80 kernel/softirq.c:1055
 smpboot_thread_fn+0x3a7/0x950 kernel/smpboot.c:160
 kthread+0x3f0/0x850 kernel/kthread.c:463
 ret_from_fork+0x50f/0x610 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Last potentially related work creation:
 ...
 __call_rcu_common+0xcc/0x11b0 kernel/rcu/tree.c:3123
 call_rcu+0x15/0x30 kernel/rcu/tree.c:3243
 put_task_struct include/linux/sched/task.h:159 [inline]
 put_task_struct include/linux/sched/task.h:128 [inline]
 delayed_put_task_struct+0xbb/0x220 kernel/exit.c:231
 rcu_do_batch+0x397/0xe40 kernel/rcu/tree.c:2605
 rcu_core+0x669/0xa10 kernel/rcu/tree.c:2861
 rcu_core_si+0xe/0x20 kernel/rcu/tree.c:2878
 handle_softirqs+0x1d6/0x840 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x1b0/0x200 kernel/softirq.c:723
 irq_exit_rcu+0xe/0x20 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
 sysvec_apic_timer_interrupt+0x91/0xd0 arch/x86/kernel/apic/apic.c:1052
 asm_sysvec_apic_timer_interrupt+0x1b/0x20 arch/x86/include/asm/idtentry.h:569

Second to last potentially related work creation:
 ...
 __call_rcu_common+0xcc/0x11b0 kernel/rcu/tree.c:3123
 call_rcu+0x15/0x30 kernel/rcu/tree.c:3243
 put_task_struct_rcu_user kernel/exit.c:237 [inline]
 put_task_struct_rcu_user+0x61/0xd0 kernel/exit.c:234
 release_task+0x108a/0x1ba0 kernel/exit.c:308
 wait_task_zombie kernel/exit.c:1269 [inline]
 wait_consider_task+0x1501/0x39e0 kernel/exit.c:1496
 do_wait_thread kernel/exit.c:1559 [inline]
 __do_wait+0x1fb/0x810 kernel/exit.c:1677
 do_wait+0x1da/0x4b0 kernel/exit.c:1711
 kernel_wait4+0x14e/0x270 kernel/exit.c:1870
 __do_sys_wait4+0x14e/0x160 kernel/exit.c:1898
 __se_sys_wait4 kernel/exit.c:1894 [inline]
 __x64_sys_wait4+0x9b/0x110 kernel/exit.c:1894
 x64_sys_call+0x16f0/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:62
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

The buggy address belongs to the object at ffff888012700000
 which belongs to the cache task_struct of size 13320
The buggy address is located 52 bytes inside of
 freed 13320-byte region [ffff888012700000, ffff888012703408)

[CAUSE]
BTRFS_IOC_BALANCE_PROGRESS and BTRFS_IOC_BALANCE_CTL only take fs_info
and then touch fs_info->balance_mutex and balance state directly. They
do not pin the superblock against shutdown and they do not reject a
dying superblock before taking balance_mutex.

During unmount, btrfs_put_super() runs close_ctree(), which pauses
balance and tears down filesystem state, and btrfs_kill_super() later
frees fs_info. If a balance status/control ioctl races with that
teardown, it can enter mutex locking on a stale balance_mutex. The
optimistic mutex spin path only tolerates speculative owner reads while
the mutex object itself remains valid, so a stale mutex can surface as
the observed task_struct UAF in owner_on_cpu().

[FIX]
Take s_umount in read mode around BALANCE_CTL and BALANCE_PROGRESS, and
bail out once the superblock is already dying. This gives the read-only
balance status ioctls a shutdown barrier without changing their
semantics to require a writable mount.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a39460bf68a7..a13fe50f2441 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3469,19 +3469,43 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	return ret;
 }
 
+static int btrfs_ioctl_lock_live_super(struct btrfs_fs_info *fs_info)
+{
+	struct super_block *sb = fs_info->sb;
+
+	down_read(&sb->s_umount);
+	if (!(sb->s_flags & SB_BORN) || (sb->s_flags & SB_DYING) || !sb->s_root) {
+		up_read(&sb->s_umount);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static long btrfs_ioctl_balance_ctl(struct btrfs_fs_info *fs_info, int cmd)
 {
+	int ret;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	ret = btrfs_ioctl_lock_live_super(fs_info);
+	if (ret)
+		return ret;
+
 	switch (cmd) {
 	case BTRFS_BALANCE_CTL_PAUSE:
-		return btrfs_pause_balance(fs_info);
+		ret = btrfs_pause_balance(fs_info);
+		break;
 	case BTRFS_BALANCE_CTL_CANCEL:
-		return btrfs_cancel_balance(fs_info);
+		ret = btrfs_cancel_balance(fs_info);
+		break;
+	default:
+		ret = -EINVAL;
 	}
 
-	return -EINVAL;
+	up_read(&fs_info->sb->s_umount);
+	return ret;
 }
 
 static long btrfs_ioctl_balance_progress(struct btrfs_fs_info *fs_info,
@@ -3493,6 +3517,10 @@ static long btrfs_ioctl_balance_progress(struct btrfs_fs_info *fs_info,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	ret = btrfs_ioctl_lock_live_super(fs_info);
+	if (ret)
+		return ret;
+
 	mutex_lock(&fs_info->balance_mutex);
 	if (!fs_info->balance_ctl) {
 		ret = -ENOTCONN;
@@ -3511,6 +3539,7 @@ static long btrfs_ioctl_balance_progress(struct btrfs_fs_info *fs_info,
 		ret = -EFAULT;
 out:
 	mutex_unlock(&fs_info->balance_mutex);
+	up_read(&fs_info->sb->s_umount);
 	return ret;
 }
 
-- 
2.43.0
