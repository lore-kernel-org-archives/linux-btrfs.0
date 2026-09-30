Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD87A4052AA;
	Wed, 30 Sep 2026 13:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776117; cv=none; b=DgUR/yabBDQCkXcbnvZ6IKtiGdz7q0zkedgBIu4veb91rGlE08p1cffjFxlAR5njw1Ygd5lPgQINQWFzCPle1HBP7LWhCyr5lhmbmWmX3MK5fJjmLOv7Z72gK7USir/E8ofnI+hkvyIWFfuoJiO3/sCI1so2UZgS2ODBf27mEVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776117; c=relaxed/simple;
	bh=pkB6/5hZzgcXQKjgmrM9Sz7wKnMX+bQryKgQj1q8vng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YG3npRm0+J5v5D7Cj1PuiDj9FL9UYUX8JtgvCqTKhm0h8Wi+i0bVpR60622FEXoHg85/a4tRaV+JjwbcNwIMWVWT7eXF2SV/oEdSGf6AAJCJ6k4gZTxFJrrrlz8P0oTx8bU6ypOA9s25CQXx7h+QrqdZydPl7dB6QVdtx+trTf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Uem5XHpZ; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Uem5XHpZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Q0
	gZLMEc4C0n9kzdgUlgW8sbkQMWmg6TPJ5uQSubmeM=; b=Uem5XHpZdEsSW5QUrl
	2+JodKEEFJozxaeFKMa3sIShxIQtnrtyGgPmvx51YY9smRk0V269FZz98diauGBh
	fJ9qehgMAZhNMr5ZnwqfHMnzaKF0hIdbdhtxNJbnYd3vs6Y/vzScSaE3YaXHa/QX
	Ct8BMlSLkv76SWSmgk3Ctzp1Q=
Received: from colol4bi5.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAnRq4aE71qvX4iCA--.2823S2;
	Wed, 30 Sep 2026 21:48:11 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Binbin Deng <18983559317@163.com>
Subject: [PATCH v2] btrfs: wait for a grace period before freeing a new device
Date: Wed, 30 Sep 2026 21:48:08 +0800
Message-ID: <20260930134808.399544-1-18983559317@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAnRq4aE71qvX4iCA--.2823S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAF4kGw13KF45ZrW5ZF4fKrg_yoW5Xw1fpr
	9Igas8JFyUJr1kCr4Ik3y29r1rX39Y9a9akrn3Gr4I9a4fA34Yvr92k34Duas8CrW8JFy8
	Za4DJwn8JwsFyw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zR_sqAUUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC-BvUuGq9ExuJEwAA3O

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
index 85ea9c5d4536..ec89dc3dc4cd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3174,6 +3174,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 error_free_zone:
 	btrfs_destroy_dev_zone_info(device);
 error_free_device:
+	synchronize_rcu();
 	btrfs_free_device(device);
 error:
 	btrfs_release_device_allow_freeze(bdev_file);
-- 
2.43.0

