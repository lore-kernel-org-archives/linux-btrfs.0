Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD41D34D38B;
	Wed, 14 Oct 2026 02:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791945482; cv=none; b=CPsYH2k50AcMzqkNTmiyypwCkFmLphQDXrKegGN2/JFdNrx/5l7/Ic7myKMh0/xOAKuJMwzWfvwQdl998AkBKWTPsq5U6OunkkO9vy7jmfUlGE9+w2kIksMPu/JxDUqY/2Q3QmOAPWg6g50lJESoyBweVf688lGEol0LYhIyPXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791945482; c=relaxed/simple;
	bh=scJ+EWsWMxUow6/2SUGfnwaqxnKcMze8D+4kJaJJdmc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Deakz0kmWqx8jBRUwUYqPkFAF2Wk8W2Tn8kozzIGTRKGOvNugsL1cA20JFLHfhzdq6gWECM1mInktSfzEIzst+KpRtOKR5M2uecbYKLuLwPDf11Xso36tfJNkMf93gXHXp4GHufl1YMvIMFUsUMGFqgYn6TwICxu+Moi+zYIW8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZvF+1RLz; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZvF+1RLz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=I0
	w+qZkGD3asKEmiLpBeCWvDurwKWMq+2vM6Ay/ZnHU=; b=ZvF+1RLzH+dlgPXviw
	sjDvUcER0GwG71Ir+DQztMb+G3s6DfbNddHBivONf1voBLrVvTAB70LfuMWVXXwy
	/zZ+FZMazTFEwQpNU5oKDgEZnu1K2drBf7le0qbsVudS1uVWFFKqYEZXW3WzDV5x
	Aem58wsYHhx4h+iYbAaTG616s=
Received: from colol4bi5.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3PxPv6s5qhGmrEQ--.895S2;
	Wed, 14 Oct 2026 10:37:36 +0800 (CST)
From: Binbin Deng <18983559317@163.com>
To: dsterba@suse.com,
	mason@kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Binbin Deng <18983559317@163.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Daniel Vacek <neelx@suse.com>
Subject: [PATCH v3] btrfs: wait for a grace period before freeing a new device
Date: Wed, 14 Oct 2026 10:37:33 +0800
Message-ID: <20261014023733.266854-1-18983559317@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3PxPv6s5qhGmrEQ--.895S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAF4kGw13KF45ZrW5ZF4fKrg_yoW5Aw15pr
	9Iga45JFWDJr1kAr4xCw429r1rX39Y9ayayrn7Kr4I9a4fJ34Yvry0k34UuasxCrWrJFyU
	Za4jywn8Ja1jyw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U3u4UUUUUU=
X-CM-SenderInfo: jprymmytvvmjmrxbiqqrwthudrp/xtbC4BBFKWrO6vDNDwAA3g

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
from the list and before it is freed.Place the synchronize_rcu() after
dropping the mutexes and before the `error_trans` label.

Fixes: 1f78160ce1b1 ("Btrfs: using rcu lock in the reader side of devices list")
Signed-off-by: Binbin Deng <18983559317@163.com>
Reviewed-by: Qu Wenruo<quwenruo.btrfs@gmx.com>
Reviewed-by: Daniel Vacek<neelx@suse.com>
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

