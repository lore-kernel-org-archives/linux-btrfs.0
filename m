Received: from out203-205-221-149.mail.qq.com (out203-205-221-149.mail.qq.com [203.205.221.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649B739D6F2;
	Mon, 10 Aug 2026 10:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786359599; cv=none; b=l1l9EL2LllDxJis3NEsMZf6JSVTY7IV4RtXa2UEW5BNp05XncfkFPoWSYpV2FS2pLM6tDEFf6UmW509HP2q+rSLYssS6Rf1q4sTKE/bqGzhzJeOQkqaJNduUMJYpJBcReQ1nEx6xTbWVn1zVuMkK+H6xhEafrVLQyjIopLiEX3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786359599; c=relaxed/simple;
	bh=AZNWv3TSZjRSzaoQ7qx/MQvzhiBD+aDZdkIYvC5edPg=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=g4W9F8m+DixiZi9CraDkzJq0Q4lBmWBjVkN45Q9CR8koFXCy4Zk5+gw5FeHxSvvzlok6xImEcAtYJfNexXs9HLMyId/bd07cYBviroEy/3AJEIwtM34Q4SoLpds+WRw5G+pjyeFHzZgsAWIizU338CABWh1VJRJ7Fgzr0sFZqT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=mXdaxS0S; arc=none smtp.client-ip=203.205.221.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="mXdaxS0S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786359594; bh=faL+lsVB1+sQd/eekkK2ReNMBfVu3w4YNGhZlYHomKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXdaxS0SoiI+b7mbrrJnUFI0i46d55kTLCbVnkUunIYZAu+OJQu8nltWIRs5elDqD
	 dVaGd2yC3P5w2nqrycf3Do8ljjcEDCkIEb0ZpsUu877bePFVdo6YYcGTJGR6G0c9au
	 CJnnCI+eceLCQ9x0kWxmuYJTSyfKVu9MvIaWPWpI=
Received: from ikun-VMware-Virtual-Platform.localdomain ([223.65.85.45])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id EE8AE615; Mon, 10 Aug 2026 18:59:40 +0800
X-QQ-mid: xmsmtpt1786359592t5disjvv0
Message-ID: <tencent_BA4513CFC51013B77208BD18052A219E6807@qq.com>
X-QQ-XMAILINFO: MVrhzCz4YLrftFAPIaYXda4fveiI0bQmYwRzi3Z7rjcsqmELxmJ5IuX9+jsQUC
	 d/yaYwZonNfb0/EFirWNtIUQCp4dsZ9/UFZz2iQqdifp3LXMxWfzcZtH0t0+ids0VB8L0CdVYCoL
	 3MTOGTIM82MCqdi+C3tZTJUnJuOM6N4k5oD1VK1QxbzPLI6T5UJU/icpqHIna2HgAE6bqwDr2M3M
	 t+H26xEWYKEkea9pbruAZ/k7LiqkCvn7oR6klJg4T+ugsTw2ueWiay+xOZbTFqb0qfsqsTZQ8ISX
	 PI2PMio7YKDkV0iHjKbd/iKrdM42XQJ/yw4WzlS2DXcAPmuUUccWS6/9L+pc9bLvcoaEC8TLEG/H
	 OGXwGHKCL4gvx/HScBSfg9qKrSamZ0vctlnL9XMwnLo7MaDrYfBnHckW9X/tcSaaSE7qe/gPqWV8
	 5HHNARO4mWK2TworZhrG9um+cQhvyCM39KJWWHgCnQ2rHTK2+FVY9z5OVKUti/3J7Fjgnoos05k5
	 mitDxGUknsc+84Pm8W9qp5nt5vM05ZOa/6lgUz2cWdJQaU9k1zUG7fh9KhNBGhGF80NctPODi6fa
	 cvCNx56ZxuSPKHwE5AWalcP4wfTSan9LpAzWkKNhxlPDH/UgR9DouJDZaDl2XkRLsTElktWplUOX
	 PnNP2hBADrmp23K6/Djb6/ae6VUfUOHMqy7DqqOP3HIAAXuKONMykSoj8c33QfMhJnvV5GRx6Edi
	 GzcUitNo3j09X6NWxvR1MzTm9jBsW0OdmYeJLa5TJbMMicTJQqKx+0dSw2d+fFNEVGvmrPJTI+Ef
	 cgV2cXqAm9O1RQrkWbG7rdGCynz604T15QCf/dxCssYjB/ScM47Gk038drQSzC3YB0wqK/sXSYkM
	 QEBfIEbHh1nC0cSWRlUNn7tMAbbpWWGxOIjnobD99et4j0FMz3JC2Sn+e//c1wv105I81JzqxLS7
	 VIiq+Rk4BcsoUp6DHyttxhnbyqFAvC/BbXXjO654YhLhTarhtss1g+0ZZuOQXPOTc5OlwedJV6Av
	 cIgwoHdWE9l1VAjNw26Dxvd4McCOE=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: Guanghui Yang <3497809730@qq.com>,
	clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: roll back sprout setup after device add failure
Date: Mon, 10 Aug 2026 18:59:16 +0800
X-OQ-MSGID: <774f18f7d59aef27ce5bc9218d8225342a74dc25.1786358930.git.3497809730@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1786358930.git.3497809730@qq.com>
References: <cover.1786358930.git.3497809730@qq.com>
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
fs_info->fs_devices in the partially initialized sprout state. The
mounted filesystem can then be left with no open devices after the failed
device add.

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

