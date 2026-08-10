Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946293DE429;
	Mon, 10 Aug 2026 12:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786364209; cv=none; b=oleTPfIqSXXer8ipJ5zomxBlAknlsM3DPjZFk7PhZYD9sJsUBzrZjFkStmpzbAtXo+9gU3NgP3PJGF7zrT45C3CnRUejtHy0uyMGau5pgfJ7DgsiJT413MpAi7gSb1BOCFNxWWynCLc1+UmK/LcgkMF/K0p+8jTOsmZr0uHKoMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786364209; c=relaxed/simple;
	bh=tw07c6N8YCZFL4onkxEfcYD23aIfAUhpfjKUlURCDGk=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=pEr7GN7gCV6UPTy77KvHEfkJ3qKYhO7oXxsfqN05y4mpZ60WaRuczKon9Zpm6N5hyY9vF4jNzkfn6gSrpyAR60w+E646KrzBg9Y3UrTMftYYYPYurM3/SDgn+IM4L0FW1Jf2q2QwtB3RqP0klWX2lTrKb47kJqKZ5KvbwK2IFy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=es/TjkVQ; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="es/TjkVQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786364202; bh=yLaybZU9ylAPnml7mAP1vbKI3x1oqHTp2jyqfhtnmHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=es/TjkVQBe4V9CRYikE+YOHZSbeklGpfY5TUwgwrmblsGz5g0tDv7cGWYu/GUQqkz
	 HnsHWMmUG8NB7nYkTzll+AB+j2t1dkoqRUAFMIKFW+qE9yQqA2QxrufGuNAkNY2mb0
	 81+uhj7chtNGuYIUZlIVmv+Wmolm12eo1jOHiwVo=
Received: from ikun-VMware-Virtual-Platform.localdomain ([2409:8a20:b30:4fb4:bdd2:8b42:d496:7e16])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 41134061; Mon, 10 Aug 2026 20:16:17 +0800
X-QQ-mid: xmsmtpt1786364198tcxcxlpn8
Message-ID: <tencent_2CAC9EC521986E5B101231D3543B3C348A08@qq.com>
X-QQ-XMAILINFO: NhUkPfKlCtQwGMbHwguqLYQPNQyubRMLH8hN6SI5BbXO8duoxCSMUhPMLiWAqL
	 Sd1p1FZmu7s0IjIGjM9s0gX+KUeLGnUQdSjk9sPN8ME/GeZAQM/w2piZPfe3OL/bt+offgor+lJM
	 CzLxmJKcVVBDjfgYg71/PGoi65QSzyDeQiyrpwidL4R0YAVgspw200qPXf+gwFj83Iq2IH8HTJg0
	 BkNOtquwG1t1+pJ+c54homaPw3254QukVpNj6+rvdF6s7tlZoGg0g4jzSfmSX4lalJseL+I37HgE
	 U1Bbdyy1iKzbbDe50G6KNgWf+iUN7NhCHUk7o7Jn19SPkn8QcvyHSR5S68JSWw4Hq1cFZOyZwpW6
	 SY9mHHAySsjeXbChU0Qk5mbPHw1BkPTLe74gUa+psIxxk3H3+yxT5uuwYfiWX0fA9uWvb3btws+W
	 5zwJQeiNdAQxs1PZqiV/rUiU3ITiNfvfZb6qgd8n90CBB1vwEySsd9XCgDGKgVPrrMotVCf+CbaX
	 eHVFIlI1Avp8Ci/X8smBxr4THZJNCtqICK3G7T++6V7bWO+9pQxzQuBUgFHtJbfmtuyH5ghGk8IP
	 fO+CtiRLFPt6O3vc5G7+gGpfge3Ye/ytPYHU2zl/+m2Wf2hIrFdVPpVlzgFwWT5/pK93qbKvEd9s
	 MohL5Uo+UQZwVKUXnMBtTYMWitITQHzb0fpD19rm0yJtIsmXtJRtQw25E1aj9YI2J8Qee40VjpAR
	 /ImHxdzN58q3mKcQXPJS8OKBKiDVUo6rQaMx1ScUahbBieDIgozZzB03V1We4F8SEuVKb1Tjlvki
	 kL23+GFVWHnG02E5g8aOKcxN13s0NJkJ3qzeu/XYZowuT+KjTtEPbauJTpEiLEG+NGyZ2EspgSXd
	 eQ8IyLQtZ1qf6WUHXRP7iBvYx/Nve/LCtchbpMBtKGxK7ctp/lDENyjTbh7Um2ABSJeICcghFX5C
	 YAunHUKta8WXDcCw+wcuIxuRoLR7uS5utHv5sNJtUWgL4PzsFht2zMJi23nT8aZbVJSxDaIXLCKZ
	 AljQylc0Yg297WlXygvQ4Slj9TsGTSxFHvF4Tx+5h5RZ80VknSzLPLDXEmaas5cotyKSMkNLCos/
	 X9xIbDUnNDqtilL5wrifu3UEFsqpdAdbMP7Ck6ODlPsi/L7LLC4BHd3b+VVQ==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH v3 3/3] btrfs: roll back sprout setup after device add failure
Date: Mon, 10 Aug 2026 20:16:06 +0800
X-OQ-MSGID: <774f18f7d59aef27ce5bc9218d8225342a74dc25.1786363229.git.3497809730@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1786363229.git.3497809730@qq.com>
References: <cover.1786363229.git.3497809730@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_init_new_device() calls btrfs_setup_sprout() before creating the first writable chunks for a seed filesystem. That moves the seed devices out of fs_info->fs_devices, clears the seeding state and installs a new fsid for the sprout filesystem.

If a later step fails, the error path removes the new device but leaves fs_info->fs_devices in the partially initialized sprout state. The mounted filesystem can then be left with no open devices after the failed device add.

Add the inverse of btrfs_setup_sprout() and use it from the error path so the mounted seed filesystem is restored before the temporary seed_devices copy is released.

Fixes: 2b82032c34ec ("Btrfs: Seed device support")

Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/volumes.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f3f77c89c..6a22cab3d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2699,6 +2699,42 @@ static void btrfs_setup_sprout(struct btrfs_fs_info *fs_info,
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
@@ -3005,6 +3041,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 				    orig_super_total_bytes);
 	btrfs_set_super_num_devices(fs_info->super_copy,
 				    orig_super_num_devices);
+	if (seeding_dev)
+		btrfs_rollback_sprout(fs_info, seed_devices);
 	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 error_trans:
-- 
2.53.0

