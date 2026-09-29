Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216B051C078;
	Tue, 29 Sep 2026 12:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790683864; cv=none; b=CSc9YwMpVO9Xeo1v4B/TGPnaAS8rwtGlaXU4jI4fe8fSTQKEjn3ZFWSqIyD4qUDtc5wXYZQAVMXWet1JY4FwW+vDASU8XeK8ijbwfchEl8rkdEcqvd9lt5yuB9xT3kxp/42Ql6aoUZr4UNnt8/Y6nXABODqhvLUgXYyk4njtLq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790683864; c=relaxed/simple;
	bh=bmBBlXJUGQ7njJjiDQqU6/nJ0qeXLnyewGYp077riLA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kZkdCiIduhnpSbqT45ccmWZvrnBypEx/lVBUMM7NIVlVzOeMUInYKk6++vj4dfJx6vVzmz6he4Oya5wielbcC3ytUUtlBgNAc0qLSV+MkMbHQ+Gc2lEkCsmV+QLN4Pu+myCeu71o0rABZS+gA4YWL/SMs6HPRe86z8dzWovNCfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LzVoXtE5; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LzVoXtE5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ok
	7gh8hzf9xWkM6boOicySDPEGNZXm3WdCWyqq9eqXo=; b=LzVoXtE5Ev44qK8W8H
	ShnByZ7NdJ8oTniqjDao1+zR0tyDGai08KadgdURSxHd4uXpMDJyaQDfwdc2jOdm
	4YC5V9hvBULi4LXZ5o2DeHWI8XPSzIvzwz7wOrc4T8yCFmOqtTTh9A0/3d4ZKTPv
	Ih8YvH1RAy5AbG500U9sIyrA8=
Received: from colol4bi5.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wCnSbCtqrtqG8FJBg--.40995S2;
	Tue, 29 Sep 2026 20:10:22 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: chris.mason@oracle.com,
	dave@jikos.cz,
	jbacik@fusionio.com,
	patchwork-bot@kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Binbin Deng <18983559317@163.com>
Subject: [PATCH v1] btrfs: wait for a grace period before freeing a new device
Date: Tue, 29 Sep 2026 20:10:18 +0800
Message-ID: <20260929121018.136850-1-18983559317@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCnSbCtqrtqG8FJBg--.40995S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAF4kGw13KF45ZrW5ZF4fKrg_yoW5WryUpr
	9Iga45JFyDJr1kAr4xCw4I9r1rX39Y9a9Ikrn3Kr4I9a4fA34Yvryvk34UuasxCrWrJFyU
	Za4DJwn8Jw4jyw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U3u4UUUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC-A9fQ2q7qq+IIAAA3T

KASAN reports a slab-use-after-free in btrfs_statfs() walking
fs_devices->devices. btrfs_init_new_device() publishes the new device
with list_add_rcu() and can fail afterwards, for example with -ENOSPC
in init_first_rw_device() when a user with CAP_SYS_ADMIN adds a device
that is too small to a seeding filesystem mounted read-only. The error
path removes the entry with list_del_rcu() and frees the object in
btrfs_free_device() without waiting for a grace period, while
btrfs_calc_avail_data_space() and btrfs_ioctl_fs_info() keep reading
the device list under rcu_read_lock().

BUG: KASAN: slab-use-after-free in btrfs_statfs+0x11af/0x14a0
Read of size 8 at addr ffff8880096be858 by task poc/252
Call Trace:
 <TASK>
 dump_stack_lvl+0x53/0x70
 print_report+0xd0/0x630
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 ? filename_lookup+0x1a9/0x540
 ? btrfs_statfs+0x11af/0x14a0
 kasan_report+0xce/0x100
 ? btrfs_statfs+0x11af/0x14a0
 btrfs_statfs+0x11af/0x14a0
 statfs_by_dentry+0x117/0x1e0
 user_statfs+0xac/0x130
 ? __pfx_user_statfs+0x10/0x10
 __do_sys_statfs+0x80/0xe0
 ? __pfx___do_sys_statfs+0x10/0x10
 do_syscall_64+0xf9/0x540
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Allocated by task 256:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0x8f/0xa0
 __kmalloc_cache_noprof+0x158/0x370
 btrfs_alloc_device+0xad/0x3e0
 btrfs_init_new_device+0x3e8/0x36e0
 btrfs_ioctl+0x150d/0x6c20
 __x64_sys_ioctl+0x134/0x1c0
 do_syscall_64+0xf9/0x540
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 256:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x60
 __kasan_slab_free+0x43/0x70
 kfree+0x121/0x380
 btrfs_init_new_device+0x4a0/0x36e0
 btrfs_ioctl+0x150d/0x6c20
 __x64_sys_ioctl+0x134/0x1c0
 do_syscall_64+0xf9/0x540
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fix by waiting for an RCU grace period after the device is removed
from the list and before it is freed.

Fixes: 1f78160ce1b1 ("Btrfs: using rcu lock in the reader side of devices list")
Signed-off-by: Binbin Deng <18983559317@163.com>
---
 fs/btrfs/volumes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 85ea9c5d4536..2693dacd1da7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3168,6 +3168,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_update_per_profile_avail(fs_info);
 	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	synchronize_rcu();
 error_trans:
 	if (trans)
 		btrfs_end_transaction(trans);
-- 
2.43.0

