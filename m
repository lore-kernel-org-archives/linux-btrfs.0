Received: from out203-205-221-149.mail.qq.com (out203-205-221-149.mail.qq.com [203.205.221.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C769F1E1A3D;
	Sat,  8 Aug 2026 04:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786164253; cv=none; b=WdqZPQwKjrzPGXBf73Qlh210LlawMY8lmyhgttM0MwzAv2ljXeTSyBTnHaohaGYr7Xn7gnz3sz9l2oTNLgVkLeQIYPNPuXr3aY/kU/ucCxArJJ6w/ctOvpFMcnodqq7wj4B0lFpx9yxln2zPa87g/NnBQgvkZ3cq+fc9t3Lmxlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786164253; c=relaxed/simple;
	bh=jFl8XJsVDdMQHDyuVPjaX+/qCaBuS0ue1SYCtMPQ+Cw=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=Jli7XUUmZo1OypQ97NsbJBaDioqYmW3Ti8J2I0kWUvWTPpY+jKJSmH/2yQJ/YZ6gW6oBaOERA/hM4fENg42ITCTm596iP8tsCM4buZnbIuebHkQfXDOvWhy7V+5lnz6TJMA2Qx+k4UDHGDRJqF0geFPgA63VGG1vLZ+4fgvBDwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=ku6jKdPL; arc=none smtp.client-ip=203.205.221.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="ku6jKdPL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786164241; bh=ZmHFewMgeX76StQPtlmfEmSgnDw4wFqcYI5PbI/0JIs=;
	h=From:To:Cc:Subject:Date;
	b=ku6jKdPLUJ2IXQjdjjEMz4MOPVlWNcCOcXV4z3RJdy5BSIKrvWUZmdNMa9sK+28CD
	 gg/fZMMX0HPyqTQuPZXK19mkcoqGYugrC4lZ51QRnz7pmJ9MAMEo6LNoOvpcguQYeD
	 Jr4I8CWHvypJhhti3DxG8LxpxmSy23AZIJkbRRCE=
Received: from ikun-VMware-Virtual-Platform.localdomain ([223.65.85.186])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id AACBCCCB; Sat, 08 Aug 2026 12:42:44 +0800
X-QQ-mid: xmsmtpt1786164164tj8ii49qi
Message-ID: <tencent_CB14173C19427EDC26219662D6A984787209@qq.com>
X-QQ-XMAILINFO: MjIJoT1b4qeJpoMKfCk04+pC94bUXazVPHe+ZQuu+2pLiG6gnlS0z1Or/IustE
	 cvYe6EUSw9s0wdAAhjTp37peELLhc2vHLECyb28wU2A4xiqNmZDibzIuxtZKC5GGyz4HKaViVlqo
	 LzXUf9rRFqQ+TxPp1EJtiHCv+HT8hoX6jyzNQclCj3qG+odVsYq5s2zD4fTJEcoDiDwXz7+xyYQW
	 WjW6aHyuLvDdCq2GW7eZwEtKbpruJRMyhRJj5wI/6r0SJhOIMNWqMyxKDepG+RxiaO2VImpcEaV/
	 TNryC63TrAcDHgLpCIj0TfNDUMUzPFhxFLIw47KyT+UtJRmcYG2KMNi2rck6O065OEq9R735mkZ+
	 yuhcRfq01gTlbPDlmqLlcIrD5rYvDXAnHgSSViX3g7uR8Nnf0v4orEp1J94JjTNznvAA/B2caVeo
	 vLdMbySGUPtOaKC+LF+XJaNlxXK5FDPHuBVlnoq/AgdrYZpQp0ZdZO2YFYeNmjK5KS4W3UojpKDX
	 KSNQU7ks9US/GJO+dND/RKYQ/c+L0GuNcpoUqbnSpZsabfDisVni9qx3Q/I/6veElwtmF0vcFq+4
	 /xjFAfkmyKphY7MYBitw10uPWObzVb66fegzmWivoghhg8Ziyp8T3uusKPaDyyR5X8r7fByD6LTK
	 +9TwKvhaxMovBEp5F8Gv1TGO0LInZDzayf8vncXxeJ9sWAS1VBpXaCx85m+BHnwMO7tI2qGra/T2
	 zhNXO5RK6T5if58yIexlHPNT4EUHSp95ijTdYAE7cnqQyxS3qq33iKmmltxqugOb2eXjuYnvc4uC
	 fX8pVzdxzuyom0gJvRB4qtK7fbgLdAZS+wPFNbgBoDuJ6lBYXAmDmuFOAzsBbY6zTFm+epPA6+g3
	 Wt9XeyUG30zOAtHpM1pbGWPVx97If/nXWQAveDNcMbG5aEPx6ORCPlZhZVxWuNiXgZPBsPb+ANhS
	 jZTlGmuIaOJeCp6kexgleDPufX67JbBmaBN4sWy+slHa8VtsQkGEtyh0MOfpqf4UI1VvBUwUbwmF
	 WMti5kAEeP5qyWJ9vA
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Guanghui Yang <3497809730@qq.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH] btrfs: free unlinked replace target on initialization failure
Date: Sat,  8 Aug 2026 12:42:39 +0800
X-OQ-MSGID: <20260808044239.134800-1-3497809730@qq.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_init_dev_replace_tgtdev() allocates the replacement target before
looking up its dev_t and initializing its zoned device information. If
either lookup_bdev() or btrfs_get_dev_zone_info() fails, the device has
not been linked into fs_devices->devices yet, but the error path only
drops the block device file reference.

Free the allocated device on this error path to release its name,
allocation state, zone info, and the device itself.

Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/dev-replace.c | 4 ++++
 fs/btrfs/volumes.c     | 2 +-
 fs/btrfs/volumes.h     | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 318ddb790..3c17481c9 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -240,6 +240,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	struct block_device *bdev;
 	u64 devid = BTRFS_DEV_REPLACE_DEVID;
 	int ret = 0;
+	bool device_allocated = false;
 
 	*device_out = NULL;
 	if (srcdev->fs_devices->seeding) {
@@ -287,6 +288,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 		ret = PTR_ERR(device);
 		goto error;
 	}
+	device_allocated = true;
 
 	ret = lookup_bdev(device_path, &device->devt);
 	if (ret)
@@ -327,6 +329,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	return 0;
 
 error:
+	if (device_allocated)
+		btrfs_free_device(device);
 	bdev_fput(bdev_file);
 	return ret;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a8e27db8e..c479f268a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -402,7 +402,7 @@ static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
 	return fs_devs;
 }
 
-static void btrfs_free_device(struct btrfs_device *device)
+void btrfs_free_device(struct btrfs_device *device)
 {
 	WARN_ON(!list_empty(&device->post_commit_list));
 	/*
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index eaf23c0dc..ecab3ce3c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -795,6 +795,7 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans);
 void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_device *srcdev);
 void btrfs_rm_dev_replace_free_srcdev(struct btrfs_device *srcdev);
 void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev);
+void btrfs_free_device(struct btrfs_device *device);
 unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 				    u64 logical);
 u64 btrfs_calc_stripe_length(const struct btrfs_chunk_map *map);
-- 
2.53.0

