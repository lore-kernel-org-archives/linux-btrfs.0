Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06F23624C3
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 11:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784027896; cv=none; b=uG2KtUQZ1B1X8GiLIATw/GX7JhFr7HWbBSYEPJD+cjXFAPma1ArPyZUESdFLSwkybhxobvXK2+p5vU9VuDDAvVYLoR7z+RTRLVDLM9c7kvrTfRRpsU3Kastu61UDRBW0xvE5eufA1c+JbQPOQoT8ssP2FxULueYc5LdSi/TrleU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784027896; c=relaxed/simple;
	bh=HIFJkg0hc4ctNnmci7lDGgug1FA94gVhs89FS+NjEzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CJfWJfK+O2RGSc0QPJkoHiESdIFsEWVV9COscKebnSTmshm/BzuNcFF0dH7ug66oClokBk0rTnayQDc6kw136gqQsyf3QFFoG1Tlwj3LFSD2qWAVQQzuKiuvi1G2VUWlB019mK6tMgVfRYlftxFd1+30JLd+GoNsT/j8eovx1xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=a0Il0N98; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=a0Il0N98; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="a0Il0N98";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="a0Il0N98"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CC18377DF9;
	Tue, 14 Jul 2026 11:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784027892; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BrDXvG6T86QIn7KZnP5ci/YdbHi2pQwuJgDfi6MfYYo=;
	b=a0Il0N98Wr2SqsGczPZAwUkiloHRxAazUxU6/4OMdx8klsY4Rjn4E1TeieoILjT+WMttJe
	QPQMoJowu7/20XaCc+L8OEsmezazV7fin2Ssrc1Xon0+YEQQcAUBIGih7K+fGt0D2kOabH
	R4E1VnbOXtxiERs1Yxf01T0nPZi/Z48=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784027892; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BrDXvG6T86QIn7KZnP5ci/YdbHi2pQwuJgDfi6MfYYo=;
	b=a0Il0N98Wr2SqsGczPZAwUkiloHRxAazUxU6/4OMdx8klsY4Rjn4E1TeieoILjT+WMttJe
	QPQMoJowu7/20XaCc+L8OEsmezazV7fin2Ssrc1Xon0+YEQQcAUBIGih7K+fGt0D2kOabH
	R4E1VnbOXtxiERs1Yxf01T0nPZi/Z48=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C0505779AE;
	Tue, 14 Jul 2026 11:18:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mCB9H/MaVmqoWQAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 14 Jul 2026 11:18:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH v2] btrfs: fix a lockdep caused by path resolution during device scan
Date: Tue, 14 Jul 2026 20:47:49 +0930
Message-ID: <49654338e775adb4b40124ea5a3abeb0dc6fdb42.1784027853.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

[BUG]
There is a lockdep report related to device scan:

======================================================
WARNING: possible circular locking dependency detected
7.2.0-20260712.rc2.git0.e3321fa3034d.300.fc44.s390x+debug #1 Not tainted
------------------------------------------------------
(udev-worker)/1653 is trying to acquire lock:
0000006919232220 (&type->i_mutex_dir_key#2){++++}-{3:3}, at: lookup_slow+0x3e/0x70
but task is already holding lock:
00000069238564d8 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: device_list_add.constprop.0+0x148/0xc60
which lock already depends on the new lock.
the existing dependency chain (in reverse order) is:
-> #5 (&fs_devs->device_list_mutex){+.+.}-{3:3}:
       lock_acquire+0x150/0x3f0
       __mutex_lock+0xba/0xdc0
       mutex_lock_nested+0x32/0x40
       write_all_supers+0x7a/0x670
       btrfs_sync_log+0xae6/0xdd0
       btrfs_sync_file+0x4fa/0x7a0
       __s390x_sys_fsync+0x52/0xa0
       __do_syscall+0x172/0x750
       system_call+0x72/0x90
-> #4 (&fs_info->tree_log_mutex){+.+.}-{3:3}:
       lock_acquire+0x150/0x3f0
       __mutex_lock+0xba/0xdc0
       mutex_lock_nested+0x32/0x40
       btrfs_sync_log+0xaba/0xdd0
       btrfs_sync_file+0x4fa/0x7a0
       __s390x_sys_fsync+0x52/0xa0
       __do_syscall+0x172/0x750
       system_call+0x72/0x90
-> #3 (btrfs_trans_num_extwriters){.+.+}-{0:0}:
       lock_acquire+0x150/0x3f0
       join_transaction+0x108/0x680
       start_transaction+0x21a/0x660
       btrfs_join_transaction+0x32/0x40
       btrfs_dirty_inode+0x52/0xf0
       touch_atime+0x90/0xc0
       filemap_read+0x446/0x450
       vfs_read+0x208/0x370
       ksys_read+0x88/0x120
       __do_syscall+0x172/0x750
       system_call+0x72/0x90
-> #2 (btrfs_trans_num_writers){.+.+}-{0:0}:
       reacquire_held_locks+0x14c/0x240
       __lock_release.isra.0+0xd8/0x380
       lock_release+0xf6/0x270
       percpu_up_read+0x28/0xf0
       __btrfs_end_transaction+0x178/0x1f0
       btrfs_dirty_inode+0x82/0xf0
       touch_atime+0x90/0xc0
       btrfs_file_mmap_prepare+0x8c/0xa0
       __mmap_region+0x214/0x780
       mmap_region+0x108/0x160
       do_mmap+0x402/0x5a0
       vm_mmap_pgoff+0x156/0x230
       ksys_mmap_pgoff+0x17e/0x220
       __s390x_sys_old_mmap+0xa8/0x140
       __do_syscall+0x172/0x750
       system_call+0x72/0x90
-> #1 (&mm->mmap_lock){++++}-{3:3}:
       lock_acquire+0x150/0x3f0
       __might_fault+0x7a/0xa0
       filldir64+0x11c/0x210
       offset_readdir+0x92/0x200
       iterate_dir+0xcc/0x2d0
       __do_sys_getdents64+0x7a/0x130
       __do_syscall+0x172/0x750
       system_call+0x72/0x90
-> #0 (&type->i_mutex_dir_key#2){++++}-{3:3}:
       check_prev_add+0x160/0xf40
       __lock_acquire+0x12aa/0x15a0
       lock_acquire+0x150/0x3f0
       down_read+0x5a/0x280
       lookup_slow+0x3e/0x70
       path_lookupat+0x1f0/0x370
       filename_lookup+0xce/0x1f0
       kern_path+0x48/0x70
       is_same_device+0x146/0x300
       device_list_add.constprop.0+0x1be/0xc60
       btrfs_scan_one_device+0x13a/0x2f0
       btrfs_control_ioctl+0x110/0x1e0
       __s390x_sys_ioctl+0xfa/0x130
       __do_syscall+0x172/0x750
       system_call+0x72/0x90
other info that might help us debug this:
Chain exists of:
  &type->i_mutex_dir_key#2 --> &fs_info->tree_log_mutex --> &fs_devs->device_list_mutex
 Possible unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(&fs_devs->device_list_mutex);
                               lock(&fs_info->tree_log_mutex);
                               lock(&fs_devs->device_list_mutex);
  rlock(&type->i_mutex_dir_key#2);
 *** DEADLOCK ***
2 locks held by (udev-worker)/1653:
 #0: 0000016c727051c8 (uuid_mutex){+.+.}-{3:3}, at: btrfs_control_ioctl+0x102/0x1e0
 #1: 00000069238564d8 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: device_list_add.constprop.0+0x148/0xc60
stack backtrace:
CPU: 2 UID: 0 PID: 1653 Comm: (udev-worker) Not tainted 7.2.0-20260712.rc2.git0.e3321fa3034d.300.fc44.s390x+debug #1 PREEMPT
Hardware name: IBM 3931 A01 701 (LPAR)
Call Trace:
 [<0000016c70680e3e>] dump_stack_lvl+0xae/0x108
 [<0000016c7078aa44>] print_circular_bug+0x1a4/0x230
 [<0000016c7078ac5c>] check_noncircular+0x18c/0x1b0
 [<0000016c7078c030>] check_prev_add+0x160/0xf40
 [<0000016c7078fbaa>] __lock_acquire+0x12aa/0x15a0
 [<0000016c7078fff0>] lock_acquire+0x150/0x3f0
 [<0000016c7180e2fa>] down_read+0x5a/0x280
 [<0000016c70b88dde>] lookup_slow+0x3e/0x70
 [<0000016c70b8f5d0>] path_lookupat+0x1f0/0x370
 [<0000016c70b900ae>] filename_lookup+0xce/0x1f0
 [<0000016c70b90218>] kern_path+0x48/0x70
 [<0000016c70f5b4a6>] is_same_device+0x146/0x300
 [<0000016c70f67cfe>] device_list_add.constprop.0+0x1be/0xc60
 [<0000016c70f688da>] btrfs_scan_one_device+0x13a/0x2f0
 [<0000016c70ed9cb0>] btrfs_control_ioctl+0x110/0x1e0
 [<0000016c70b97d0a>] __s390x_sys_ioctl+0xfa/0x130
 [<0000016c718004d2>] __do_syscall+0x172/0x750
 [<0000016c718155d2>] system_call+0x72/0x90

[CAUSE]
Btrfs device scan will call is_same_device() with device_list_mutex
held. But is_same_device() will call kern_path() which will do path
resolution and lock the inode.

So device scan has the following lock sequence:

 mutex_lock(device_list_mutex) from device_list_add()
   |
   v
 inode_lock_shared() from lookup_slow() during kern_path().

Meanwhile another thread is fsyncing, which has the following
lock sequence:

 inode_lock() from btrfs_inode_lock() inside btrfs_direct_write()
   |
   v
 mutex_lock(tree_log_mutex() from btrfs_sync_log(), which is further
 triggered from
 iomap_dio_complete()->generic_write_sync()->btrfs_sync_file().
   |
   v
 mutex_lock(device_list_mutex) from write_all_supers() inside
 btrfs_sync_log().

So the device scan has a reversed lock sequence, compared to the fsync
one, this means we can have the following deadlock:

          Device scan                   |           Fsync
----------------------------------------+--------------------------------
 device_list_mutex locked               |
                                        |   inode locked
					|   try to lock device_list_mutex
 try to lock inode                      |

[FIX]
Instead of a full path lookup, use dev_t to determine if two device
paths are pointing to the same block device.

Inside kernel dev_t is going to uniquely determine a block device, and
the device path lookup is already done by lookup_bdev(), which is done
without device_list_mutex held, thus no reversed locking sequence.

Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/linux-btrfs/5a9d9847-4ae6-43c4-afdc-6e5fa51d6117@linux.ibm.com/
Fixes: 2e8b6bc0ab41 ("btrfs: avoid unnecessary device path update for the same device")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
- Update the [CAUSE] to make it more clear why we have inode locked
---
 fs/btrfs/volumes.c | 37 +------------------------------------
 1 file changed, 1 insertion(+), 36 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2d132c827913..3d1063bc73f8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -740,41 +740,6 @@ const u8 *btrfs_sb_fsid_ptr(const struct btrfs_super_block *sb)
 	return has_metadata_uuid ? sb->metadata_uuid : sb->fsid;
 }
 
-static bool is_same_device(struct btrfs_device *device, const char *new_path)
-{
-	struct path old = { .mnt = NULL, .dentry = NULL };
-	struct path new = { .mnt = NULL, .dentry = NULL };
-	char AUTO_KFREE(old_path);
-	bool is_same = false;
-	int ret;
-
-	if (!device->name)
-		goto out;
-
-	old_path = kzalloc(PATH_MAX, GFP_NOFS);
-	if (!old_path)
-		goto out;
-
-	rcu_read_lock();
-	ret = strscpy(old_path, rcu_dereference(device->name), PATH_MAX);
-	rcu_read_unlock();
-	if (ret < 0)
-		goto out;
-
-	ret = kern_path(old_path, LOOKUP_FOLLOW, &old);
-	if (ret)
-		goto out;
-	ret = kern_path(new_path, LOOKUP_FOLLOW, &new);
-	if (ret)
-		goto out;
-	if (path_equal(&old, &new))
-		is_same = true;
-out:
-	path_put(&old);
-	path_put(&new);
-	return is_same;
-}
-
 /*
  * Add new device to list of registered devices
  *
@@ -895,7 +860,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 				MAJOR(path_devt), MINOR(path_devt),
 				current->comm, task_pid_nr(current));
 
-	} else if (!device->name || !is_same_device(device, path)) {
+	} else if (!device->name || device->devt != path_devt) {
 		const char *old_name;
 
 		/*
-- 
2.54.0

