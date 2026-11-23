Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795433252;
	b=bek/KAYO2Z3nhH5aLPv3npfI8CSvRe265dpU0enQmIzTpUyDVg3cieSvl0sTFOIh6G1Y
	 LaWrPyvcZFKkRbhYkYvHAFn2OmCF3SyaXIFP+NONHGsBEYD3vhY2QHa4AI982Jz/SBQ3G
	 tyijoymLclDqu4YXjdPvMF5WJQ++bLtVw0Tg63GJNqNmhNmL/FX+j954yBizViCTJziof
	 KWhO9cZDeKPULZh02yuNj/ZiMCfzsOLwwbqzNFeljHlrLo0UOqOwVeKmGixbRTIAnCf8O
	 IvZkwAR1G1gT+NJIikwVPArZmGil2ER5oUHv8VUgS17FgqiFMeLMF15o+gUsgLpnYaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795433252;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8IYI5o2wbzUhFqmVk/yvmDi6knN9j9n+B46dU/tmzcM=;
	b=VfbH7S3P8UCwGSIVBskfXOrTCV1n496xZ6hZGOT52xm5jiu2G+UOz/yhiCb46B3Tgxdl
	 2ijS5fA4XxQf7VcblTyu23A4erxx/jmFXM4b25obJvEgk9IPVKu/uBmK+DcWHKdggV+Mh
	 xErNSDg6AcA31kLbC5azhBZ6vTjgZfqR/gApfNHAhEYzK3/GlYC0REmHWOcpIp7ls7AKc
	 VNeI8h22mh6qENYvMtDKT0BleWZJNTG9kyxQES5FxP8SFv/2dgeKqI40v5sjUVe01LNRq
	 DXqCCkVpHED136zeYBegzYtGkVhEpCRZjlKpfheEvpGQUqfJqVKioB40qzyQmAZ9D+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HyEgY9Pm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BDD606A332
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HyEgY9Pm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88861F000D0
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795433252;
	bh=8IYI5o2wbzUhFqmVk/yvmDi6knN9j9n+B46dU/tmzcM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=HyEgY9PmnmTFki/8Ml6MFTN5DnuE3jcc73HG+1234PEMBPw+1oIl17tOwUxC3aKw+
	 Rr3Xlhc0MvUjS5j2lt6zOZfNPe4t0zOxslYx+ZDMLgSDpUzrHTFylEzUvvOSdPalPT
	 fM8AiJCnxdewvjcznRMy03kXaQd+JSZAojFgGeN0a0GGaTKXO2PhDwN/2/3/9CEco4
	 4Bsxv0VFmZycAAJwvrVgihpmaDn9B1geqps8noSjZgscpvhX9/GF9cwPnpkqjNSQee
	 5nm3eVmV1MmX9dd4QZ6W6HTBQZdEFu8UEeO9WfWfhVXWXtqdblG4YDB8GdELI0PT9A
	 8gnpDJoLqOLXQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: use boolean type for struct btrfs_device::dev_stats_valid
Date: Mon, 23 Nov 2026 11:27:26 +0000
Message-ID: <7136675a4b21eac49672c79036dbe183b5b8fb8b.1795433118.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1795433118.git.fdmanana@suse.com>
References: <cover.1795433118.git.fdmanana@suse.com>
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

The field is used as a boolean, so change its type from int to bool for
better readability.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 fs/btrfs/volumes.c     | 6 +++---
 fs/btrfs/volumes.h     | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 9fc0c15a5343..bcc8f5713fd9 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -311,7 +311,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	set_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state);
 	/* Check the comment in btrfs_init_new_device() for the reason. */
 	atomic_inc(&device->dev_stats_ccnt);
-	device->dev_stats_valid = 1;
+	device->dev_stats_valid = true;
 	device->fs_devices = fs_devices;
 
 	ret = btrfs_get_dev_zone_info(device, false);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bfc1b85f4b03..c2b4f128bf6c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3065,7 +3065,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	 * created at the next transaction commit.
 	 */
 	atomic_inc(&device->dev_stats_ccnt);
-	device->dev_stats_valid = 1;
+	device->dev_stats_valid = true;
 
 	if (seeding_dev) {
 		/* GFP_KERNEL allocation must not be under device_list_mutex */
@@ -8440,7 +8440,7 @@ static int btrfs_device_init_dev_stats(struct btrfs_device *device,
 	if (ret) {
 		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++)
 			btrfs_dev_stat_set(device, i, 0);
-		device->dev_stats_valid = 1;
+		device->dev_stats_valid = true;
 		btrfs_release_path(path);
 		return ret < 0 ? ret : 0;
 	}
@@ -8458,7 +8458,7 @@ static int btrfs_device_init_dev_stats(struct btrfs_device *device,
 			btrfs_dev_stat_set(device, i, 0);
 	}
 
-	device->dev_stats_valid = 1;
+	device->dev_stats_valid = true;
 	btrfs_dev_stat_print_on_load(device);
 	btrfs_release_path(path);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 891bc2432870..3ccb0e0a271e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -191,7 +191,7 @@ struct btrfs_device {
 
 	/* disk I/O failure stats. For detailed description refer to
 	 * enum btrfs_dev_stat_values in ioctl.h */
-	int dev_stats_valid;
+	bool dev_stats_valid;
 
 	/* Counter to record the change of device stats */
 	atomic_t dev_stats_ccnt;
-- 
2.53.0

