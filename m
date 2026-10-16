Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34AB549392
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 17:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792170570; cv=none; b=HslHCHIu/Vxn2+pB2GN3Aw60k4Jaca9J154EDOtNJaNTE1weurN/klgmWcvOzcP5VgWJaI7sk+6bxrG7427hEoK6S6wEJdO85oSoEKbtupRHiqy9VRPOuYfmsH17S4MiSeK1Laa2bhVWv6v0dkDjqHsbzWO18UPd8JJlw8G3QwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792170570; c=relaxed/simple;
	bh=vnlJ0J8kXX7eL+SWkQ9rkLq8biqiYiko8zwVk12ILlY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkdHucGPg7hCTZiklngkPXA4eOYPIA8xsNg4J4OVj19hTxsE3EnT+/W3J2dm35kvmXO5nkGNPAcrK1ValCpke37d81Zhq7hmPKfNvObjrqoZVEUyZyctz7a6xpWpxGuCxAn5CJr9UWvlSJV+GdcpglNyeDWUdxAjUQCRpblPYf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMQpIHFe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMQpIHFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571991F000C6
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 17:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792170569;
	bh=rff7l97sE9y1HivWGDHUpUJux+tgl2/9VU0WxHzpt7Q=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=mMQpIHFekuI9EAK9nomr7E6jFS8dZhIp61ilyAMwzyvXntgL34QR9GCEb6utZpL7x
	 BMye56QXDU9jGGLsKtTRBC3i5tTTLYKBWaqp0fRmKdnzZ5wEALlEG1fMSNd5pcAn+N
	 KXCm9xPFbHjtU2PYgWmGnZOTYWADYH/Pzy7ylBNvc03LkHiSp9gT114vV2lVfdX1Rj
	 5gzJsNfRmvFZSIHSdMqH7y12SRuTaWtzu/uBlxVAvGK58LArTkcOZXdsBJi+Ge9ksq
	 uFidY7xKjmA2b1j8ViizmRCYHItS43eGWhk02sonrYt3IygSn4t/pNfIDcIM0xJSaa
	 chF1tG0+sWKZw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: scrub: fix race leading to use-after-free in the scrub progress ioctl
Date: Fri, 16 Oct 2026 18:09:25 +0100
Message-ID: <1c760438fbab8c2d2bfe31a9c9dfd3d7c6637949.1792170434.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1792170434.git.fdmanana@suse.com>
References: <cover.1792170434.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If the scrub progress ioctl is called when replace is about to finish, we
have a race that can result in a use-after-free of the scrub context:

1) A scrub is finishing and is at btrfs_scrub_dev();

2) A concurrent task called the scrub progress ioctl and is in
   btrfs_scrub_progress(), where it takes the device_list_mutex and grabs
   the device. Then it starts using the device's scrub context (for a
   memcpy operation);

3) While the scrub progress ioctl task is running, the scrub task sets
   the device's scrub_ctx to NULL (acquiring fs_info->scrub_lock) and
   then calls scrub_put_ctx() against the scrub context, dropping the
   last reference and freeing the memory - while the scrub progress ioctl
   task is still using it, resulting in a use-after-free.

Fix this by changing btrfs_scrub_progress() to take fs_info->scrub_lock
before using the scrub context.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/scrub.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0eb30625439b..389ebb5f7d61 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3293,10 +3293,13 @@ int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(fs_info->fs_devices, &args);
-	if (dev)
+	if (dev) {
+		mutex_lock(&fs_info->scrub_lock);
 		sctx = dev->scrub_ctx;
-	if (sctx)
-		memcpy(progress, &sctx->stat, sizeof(*progress));
+		if (sctx)
+			memcpy(progress, &sctx->stat, sizeof(*progress));
+		mutex_unlock(&fs_info->scrub_lock);
+	}
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	return dev ? (sctx ? 0 : -ENOTCONN) : -ENODEV;
-- 
2.53.0

