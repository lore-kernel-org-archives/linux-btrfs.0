Received: from out203-205-221-242.mail.qq.com (out203-205-221-242.mail.qq.com [203.205.221.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C131378D9F;
	Tue, 14 Jul 2026 06:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009545; cv=none; b=c6WJ7CKpYKHdq3KdoxvNnOqHDSfOTaVLOblkGVaXOKnQhgYh5iKxT/unM+4sfBFqZzjoa1yWgEy0vEJYAcBhw0gqZTe424k8XNQoTcASgV2nTKuDkzs9CFFTwoENLrEBGjyH9w0Wxyu+VxpTLx4WvZ8ZzHFjDrUDxw38Wg6QK/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009545; c=relaxed/simple;
	bh=bOL+DGRv6Tmm+qq8FTcYJxahUpgQ9J5L7QD9ZMJfPE0=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=FUpIPBrLIX+BdRxcuzcWXwxnjHQOMlHn6u0adXkAuDOxBdPR+To6x5S34kwHhcaRNKZaROiH657uphutWXg8tVje86FdvrfGAO3fOgpGtO1ckxx+Vw6X9kaFBYXvAbmTK9QK+DGl3d0wXOU34Gw1yilopuavgdekDnjpukC5sZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=GHwbvfQz; arc=none smtp.client-ip=203.205.221.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="GHwbvfQz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1784009540; bh=m6As1VkUh4P76vX8tnAyx5kzaz1bhMUKZasabh445ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHwbvfQz7jNeklnG5lpPC+LW/K4IWcQO0suuphEr3ekE+Jqh/bN2GVpsrnSj5wESH
	 qkFmZN+sur0xeYdp9Vr0RRBuwNC6H49MLSzSkOLZXi1Dkn4DifFtkY5riymcIIo4Yi
	 df9ezHpLEUDYxmIXyXgsV+ryCeWfwr1sfz8Wr8tM=
Received: from ikun ([221.176.157.250])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 2C6982AA; Tue, 14 Jul 2026 14:11:06 +0800
X-QQ-mid: xmsmtpt1784009470t4ukfuh5u
Message-ID: <tencent_3A451E4FED103C3756888298712A161E2607@qq.com>
X-QQ-XMAILINFO: NnYhxYSyuBnLbA4BLv9b3KQy5S78Zi8++xR/tnJCrmi+3/wOgilIjd7UfSp8I3
	 GJlUAwfsjJdBh5GpPhRHfURiLcVRUhUh9FwcmdnZQcEJGHle5tNJjrSJPkxvN9zRI18I7ulpkM2T
	 WLTm9VfwfUbbGkjLjuvQXYyNI8dr4I55cFkCzXQJ9Ng+GaYGIB8EdMsE4A2y899S/czbkLRDWE0T
	 CcOn2Swmhz/zvxEEJVJGomi4i4iS1aIchlkI53DD0LjGrb04yYrP+lXnWYonzhcUCQyRWqm5NaSj
	 oJI0OXcbadFPuxsAOxTX7RYva7PRv7R8BGB3++SDAZ0GYUcCHiWt5mIE/dov5fXqvZn2YpikPJfr
	 Lh0u5YDwfkSlnWswQimVaOOn2SLOXZOjqjFWKxPeRdM/dHbPbgCIxtKR+yfG8VuGsGpPlRNo4KGQ
	 fmUg0MCUkpLreCNJq1zoDKD1P8zpJbeI5JDCNqFnzCrSHNG1AMMzKvH19iFCy66d30DlXkJgEYlL
	 0uwIcyPcZgKT6QrOfkZNW/ovhuP82yTNyzT0UwA/dQyZGouRtp0PtfaZvfUxLypnerLi55J4nwXm
	 ma19gBJdsGGMlQ40/2pMtZFAEVn7l4VHLKFc6hvWPT0zW4+S3PNgqkv8Y12QFg+wBX33wcCrP0Or
	 KfAsd3V/wblyct6txWVqkqYIeBxDNWddtdeeF1RTx0yhwh/8+xWLpW9ThaenyObCkr+0xHtEa7Zp
	 lQkdL/hunERFUzct16RdXfy1umewgw1LQeOF3iS5o1FVtsf7b/zYRrFqm4bPkELlC6+kET+FRkzE
	 Rgrke0FfDycIv4gyGQwvSDVJ//Jc/tsOLWF+UfIDh6aG6/rN6iSYmB/TpaGYgvDtiQNph40UZhOt
	 l3dNyInzqNoSkk+YxRZp93Eb7EEmUW6KoRK7QNYSfDgtR+kfQJ5Nc+zaMQFrQiwnr6oTFKEZtkhL
	 RI1vOA7eXF3YRDhMcMv0660RazXxNi5wGwQkM9g4A01mHbEJtsEq4BJFPThdtNPn6lkYBG1ZaAlo
	 piMJA4sS17+oWeIMfa0jbjYLmpdPjYH8Visbmb70GCLYF56PPM9crr53wXsANdJLChalV9M2IfBH
	 MTd1hNk6ZOVWxddTk=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/3] btrfs: roll back sprout setup after device add failure
Date: Tue, 14 Jul 2026 14:10:37 +0800
X-OQ-MSGID: <20260714061037.1014-4-3497809730@qq.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260714061037.1014-1-3497809730@qq.com>
References: <20260714061037.1014-1-3497809730@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_init_new_device() calls btrfs_setup_sprout() before creating the
first writable chunks for a seed filesystem. That moves the seed devices
out of fs_info->fs_devices, clears the seeding state and installs a new
fsid for the sprout filesystem.

If a later step fails, the error path removes the new device but leaves
fs_info->fs_devices in the partially initialized sprout state. The mounted
filesystem can then be left with no open devices after the failed device
add.

Add the inverse of btrfs_setup_sprout() and use it from the error path so
the mounted seed filesystem is restored before the temporary seed_devices
copy is released.

Fixes: 2b82032c34ec ("Btrfs: Seed device support")
Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/volumes.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a14f186f5b07..9aba2762025b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2772,6 +2772,42 @@ static void btrfs_setup_sprout(struct btrfs_fs_info *fs_info,
 	btrfs_set_super_flags(disk_super, super_flags);
 }
 
+static void btrfs_rollback_sprout(struct btrfs_fs_info *fs_info,
+				  struct btrfs_fs_devices *seed_devices)
+{
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_super_block *disk_super = fs_info->super_copy;
+	struct btrfs_device *device;
+	u64 super_flags;
+
+	lockdep_assert_held(&uuid_mutex);
+	lockdep_assert_held(&fs_devices->device_list_mutex);
+
+	list_del_init(&seed_devices->seed_list);
+	list_splice_init_rcu(&seed_devices->devices, &fs_devices->devices,
+			     synchronize_rcu);
+	list_for_each_entry(device, &fs_devices->devices, dev_list)
+		device->fs_devices = fs_devices;
+
+	fs_devices->seeding = true;
+	fs_devices->num_devices = seed_devices->num_devices;
+	fs_devices->open_devices = seed_devices->open_devices;
+	fs_devices->missing_devices = seed_devices->missing_devices;
+	fs_devices->rotating = seed_devices->rotating;
+	fs_devices->latest_dev = seed_devices->latest_dev;
+
+	memcpy(fs_devices->fsid, seed_devices->fsid, BTRFS_FSID_SIZE);
+	memcpy(fs_devices->metadata_uuid, seed_devices->metadata_uuid,
+	       BTRFS_FSID_SIZE);
+	memcpy(disk_super->fsid, seed_devices->fsid, BTRFS_FSID_SIZE);
+
+	super_flags = btrfs_super_flags(disk_super) | BTRFS_SUPER_FLAG_SEEDING;
+	btrfs_set_super_flags(disk_super, super_flags);
+
+	seed_devices->opened = 0;
+	free_fs_devices(seed_devices);
+}
+
 /*
  * Store the expected generation for seed devices in device items.
  */
@@ -3088,6 +3124,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 				    orig_super_total_bytes);
 	btrfs_set_super_num_devices(fs_info->super_copy,
 				    orig_super_num_devices);
+	if (seeding_dev)
+		btrfs_rollback_sprout(fs_info, seed_devices);
 	btrfs_update_per_profile_avail(fs_info);
 	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-- 
2.52.0.windows.1

