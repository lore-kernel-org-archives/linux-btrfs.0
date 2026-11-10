Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794342311;
	b=lLQFu9ejBcLHZRk8ufDlu4o4z/qxaFOjirk/E2C2BqIfwGSCVJHQ5VegAbzPPzPUOGBh
	 aVm97oa9qqQnVrP9Nwor3yG4LXYxPXuyMNBK3XccrYU4bezzJBl/IFzTWan73FHfTRvJ9
	 J780bdHVPjSMM7sPlNd1QQL5xM9Gk1Ro9b2Hp2JhA/41iMz8rnuEUGQfIE1Cln9n9PaSQ
	 kSvsOWSe5BroiyEmT1cPwVe4KHW1Lrvh1UgHJFaYZZH/Lt+1SIdyBu//3ZC4EWTrj3wW9
	 rsv7yJ9ACBR1AlBiETpiAFdIX4FYiBhV5sssRXNSL95WgIo46golmQ7VwXvmlZCuE9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794342311;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yMQnDnQIhmIhs+yCvQU1fIznjg/UIgqqLii56nHdusI=;
	b=CnMzAJur3162lcQclR3TtYvUg2NZ82KGF14eJDCvaojcB2tyEBVnj+/QxsxZex08T9Jx
	 NUEvP0r3JG4GpdyONV0gkKUvpamM+V1mf/TbHrEJPL7SkrnscqlbO920xGKNu/mSumuuf
	 Jnh1ffGpFfFkN7uBqMgbNimzZsV+DQzAYZaQf7BRCijCmeZDJQnjjwH45Ive4feZPkyQ1
	 cQg3RB5Hwmb5WN3aKJOgHlAs4fTSavCtDTPPCl/+60gkGybBfZRdcdYQ7RtGktHEu3bRc
	 E8dlBagHkLPnZ0a1QXCBNdnqSfLFyCDTGg6ZLw1RbfItbLc/8WUFLx1EhQh5DuUgDOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GZe5YWQh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855D7606A326
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 20:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GZe5YWQh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E0D1F008A2
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 20:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342311;
	bh=yMQnDnQIhmIhs+yCvQU1fIznjg/UIgqqLii56nHdusI=;
	h=From:To:Subject:Date;
	b=GZe5YWQh0kI/nwXisev9M2SsXRFn2pDwtyCC1sngRmmpIJ1vWcwDHQINL1had1CkD
	 Yx9BYIRn5VMGWJSUOX9+Hiay+xkpT3z8CT34L7e8Gxf08i4wZuyHzYulVn+g4ihvWw
	 sstn2T9ffHie2ol9HgwrDUvjuujwkqfEDihjqoTPpGSU4DjcnxtfHl4DiwPhMi7G59
	 0X4X7cmQpQfTaocXpINyT+awqDB5zBKGwcMdkBL+77k+twHc/v/BtkHZM8zuI/0530
	 icDio3ks+Oxu4fb/uU+l5ZE1WV/XLiIw874CFRHGP22G2FRuuOFhR77vAphPyujrUN
	 xLjZJdfA4BCzA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix race between getting device stats and removing device
Date: Tue, 10 Nov 2026 20:25:08 +0000
Message-ID: <ad13663d72d23c941b0655ed7b7b46fd7541293d.1794342214.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When getting device stats we lock the device list mutex, get the device,
unlock it and then use the device - but after we unlock the device we can
have a concurrent device remove operation free the device while we are
still using it in the device stats task, resulting in a use-after-free on
the device:

  CPU 0 (BTRFS_IOC_GET_DEV_STATS)     CPU 1 (btrfs_rm_device)
  -------------------------------     -----------------------
  btrfs_get_dev_stats()
    mutex_lock(&device_list_mutex);
    dev = btrfs_find_device(...);
    mutex_unlock(&device_list_mutex);
                                       mutex_lock(&device_list_mutex);
                                       list_del_rcu(&device->dev_list);
                                       mutex_unlock(&device_list_mutex);
                                       synchronize_rcu();
                                       btrfs_free_device(device); // kfree
    if (!dev->dev_stats_valid) // UAF
    btrfs_dev_stat_read_and_reset() // UAF
    btrfs_dev_stat_set() // UAF
    btrfs_dev_stat_read() // UAF

Fix this by holding the device list mutex while accessing the device in
btrfs_get_dev_stats(), which is safe since btrfs_rm_device() deletes the
device from the list while holding that mutex.

Link: https://sashiko.dev/#/bug/linux-1ac8d72d-3ab5-4feb-b957-c4862ba1d15b
Fixes: c11d2c236cc2 ("Btrfs: add ioctl to get and reset the device stats")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3d4ef6725de0..9e37aee00824 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8658,15 +8658,20 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 	mutex_lock(&fs_devices->device_list_mutex);
 	args.devid = stats->devid;
 	dev = btrfs_find_device(fs_info->fs_devices, &args);
-	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (!dev) {
+		mutex_unlock(&fs_devices->device_list_mutex);
 		btrfs_warn(fs_info, "get dev_stats failed, device not found");
 		return -ENODEV;
-	} else if (!dev->dev_stats_valid) {
+	}
+
+	if (!dev->dev_stats_valid) {
+		mutex_unlock(&fs_devices->device_list_mutex);
 		btrfs_warn(fs_info, "get dev_stats failed, not yet valid");
 		return -ENODEV;
-	} else if (stats->flags & BTRFS_DEV_STATS_RESET) {
+	}
+
+	if (stats->flags & BTRFS_DEV_STATS_RESET) {
 		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++) {
 			if (stats->nr_items > i)
 				stats->values[i] =
@@ -8681,6 +8686,9 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 			if (stats->nr_items > i)
 				stats->values[i] = btrfs_dev_stat_read(dev, i);
 	}
+
+	mutex_unlock(&fs_devices->device_list_mutex);
+
 	if (stats->nr_items > BTRFS_DEV_STAT_VALUES_MAX)
 		stats->nr_items = BTRFS_DEV_STAT_VALUES_MAX;
 	return 0;
-- 
2.53.0

