Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5042E349B19;
	Tue, 16 Jun 2026 11:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781610100; cv=none; b=nuY8pTLoeuduCrwMpmFdYFXG/VycgAQeFCNisLPXLBWHSwgEiKbTZvQDlyr4Vp7h1HV1rn9A8nVhpkzBzGQWaSjov2Oj7j/g5tHpvLtHTgRyORD/mhWJosW8oI+IYoOLulYudyy4hY2WxOUgnM6CIkVHm+TLxPBkdUcFvBeuCQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781610100; c=relaxed/simple;
	bh=3vRfIyec62f3M+zfEVCJeZphM2p9rHf/SaEWlqOY44Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JJYHTNwlLvD2fIJjemvjxcWhp2WlD7G/hrGh3VNUISbsg0So4Xk7WZF/UOQh/UM/YXgmdIFiA9XogKTiis5pzz0Y5vrnOY3gjqDoLcsg0/APwUSdtM4hVdrHphHVl9zmqtCoZX1uED0U1WMh+IqSrgWROlt0nhlv64blXeydiu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YqTYhudj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YqTYhudj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437C51F00A3A;
	Tue, 16 Jun 2026 11:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781610099;
	bh=KM3Kke69ukTN2VkMsgVt8pYKjbmcxkAs+tWe3xmstlo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YqTYhudjNDnkl/9NIadhmw3h92qy5W3Y6C5Dlf7dgnR2ZctnlBNYSF56DjkD1naqm
	 XLnZHQW2aEzuQfi93BS9FJ9DSB/YJz7cHczrIkqRFnOCEaP8XWepQlNgqua3eFCc0c
	 DhkBQfgWpF+6nWw0CwTKJIxNmH4bvlUZVUEZ4guinsQVE/5+F+Eg6lplKyJo2vwgpw
	 eS7ChxMovz2k0VU86onrTBLaAvNQ82P3OgiMWcd9uMw6gXCj4t7qil38qQginiGIz/
	 0CbZItyNJW0v2ty0ELIa/NzKOU9vbE7L2KFM4mbB4YA4o6SfTsGpFdKD7gjDzyW06n
	 2JixqBrl2crhA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 13:41:10 +0200
Subject: [PATCH 1/7] btrfs: wait for an RCU grace period before freeing a
 device on add error
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-btrfs-preexisting-fixes-v1-1-c4abe2f6d4f0@kernel.org>
References: <20260616-work-btrfs-preexisting-fixes-v1-0-c4abe2f6d4f0@kernel.org>
In-Reply-To: <20260616-work-btrfs-preexisting-fixes-v1-0-c4abe2f6d4f0@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naota@elisp.net>, 
 linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>, 
 Stefan Behrens <sbehrens@giantdisaster.de>, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2309; i=brauner@kernel.org;
 h=from:subject:message-id; bh=3vRfIyec62f3M+zfEVCJeZphM2p9rHf/SaEWlqOY44Q=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZmmXpXP2/XHoC+xELHkHN/MayTAeVL5tfPOB2fftp8
 dLZK2taOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZybgvDP41jr/2K7935YbXg
 mdFy5f3frQN+Hplz8UVUWNiRWt0p15wY/oobL5K/zOp2nOOuYuTU7IKF17KSLjwTuPjuYdfrqg1
 P1nEBAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

btrfs_init_new_device() publishes the new device on the RCU-protected
fs_devices->devices list with list_add_rcu() before it adds the device
item, finishes a sprout and commits the transaction.  If a later step
fails, the error_sysfs unwind removes the device with list_del_rcu() and
then frees it via btrfs_free_device(), which kfree()s the device
synchronously:

	list_del_rcu(&device->dev_list);
	...
	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
	...
	btrfs_free_device(device);		/* kfree(device) */

There is no grace period between the list_del_rcu() and the kfree(), so
a reader walking fs_devices->devices under rcu_read_lock() alone can
dereference the freed device.  Such readers exist and are reachable from
unprivileged context, e.g. btrfs_ioctl_fs_info() (reads device->devid)
and btrfs_calc_avail_data_space() (reads device->dev_state and
total_bytes).  The window is hit on the common, non-seeding
"btrfs device add" path when btrfs_add_dev_item() fails (e.g. -ENOMEM,
-EIO, -ENOSPC) and jumps to error_sysfs.

Every other device removal path waits for a grace period between the
list_del_rcu() and btrfs_free_device() -- btrfs_rm_device(),
btrfs_destroy_dev_replace_tgtdev() and the source device removal in
btrfs_dev_replace_finishing() all call synchronize_rcu() first.  Only
this error path is missing it.

Add the synchronize_rcu() after device_list_mutex is dropped and before
the device is freed, matching the other paths.

Fixes: 39379faaad79 ("btrfs: revert fs_devices state on error of btrfs_init_new_device")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6eab4cc73ce4..9c4cd8bdda05 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3086,6 +3086,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_update_per_profile_avail(fs_info);
 	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	/* Pair the list_del_rcu() above with a grace period before the free. */
+	synchronize_rcu();
 error_trans:
 	if (trans)
 		btrfs_end_transaction(trans);

-- 
2.47.3

