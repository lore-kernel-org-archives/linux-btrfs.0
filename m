Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795112907;
	b=Fe+3rPA1SqzLOriNyGvXlC3F3hLDM+TN5KMX01sZkqOgz7OYapLDfqpdkzmCOBmDUfQc
	 iqkgyJkSQWLCfjY+pn9E2gQ22xIydAuxWFM60z25flgyhhT8NDIJxLlLk0pXzVtuCoEpR
	 BqU6j1Nw07+lVGwgPcYyYCgRlGxaVJKfsBG6RpY7cn7KnmBZ/e1RbuuYeoJQR7DRMGjW8
	 aqxXqAL+LEZPuMkRy9RBUqj6U/o4MTTgsLPimMJnrPy5b6Sx1HRL0xVmyl3IEVRzvIzDu
	 qMh9hhPHM27/pKkh490C28I2I3u51G1owXEbDgROpKJ4BQ42OT2FDbqsFp4kExM286A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795112907;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=tDOLs5qxL0reB4APUSWQU61Ux4Oz32Ec3PCujGsEsBM=;
	b=YsaWhnJGH/SNhoIPxeqxOXQkGe9m4lb/QJY+i8iyi2c1kyX6DDGg2Sb2xVs4geYZpX8f
	 dO+sO16eUHSngIojTgxLjtd+jSsMBP21Hwn8LbETMCZ2XVUleNXr4i9QrAzXvMHCf5xzQ
	 udSpW4fFjGVimR1GVqkgMPHZh3kdhYVpJZw/Cu3sxE2PWBlATRgjBoW/NycYciKnJDmWl
	 QR4MwZVmitjfPbxxv4vqlVK1auXaAhCqnBcX14efv2ONzWT/f38SHnXfJ+MjLKU9tfpSR
	 aabk3xrH67C7e2P2/Ocl2L+1A+pWpSSY7t2EZ9i/d6bx+VXcC1yntWsTxjT4g7IsPOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=em27CyY7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832D9606A324
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 18:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=em27CyY7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D459C1F000C4
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 18:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795112907;
	bh=tDOLs5qxL0reB4APUSWQU61Ux4Oz32Ec3PCujGsEsBM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=em27CyY7yH32W/lvs7XgEDzwKB/NeTDmMCVMXqgJ5tMkq4tfHvPrQxbZDE20bPUES
	 khgn4bF75XLZdMLt5PQvefcFdjUhKP0p2NfhBZ58vWi+7j9lEH2aFkdGsagpyjP9aB
	 pV+JDM34wO/0b4m7/rhqofe94BkywEZifgW/AD5lOu+pcNV1240ANr78ayDe25/7Hk
	 eeyuRPP3gh4vxpZUFoZRXgqdFrgbFMKbs7uzShbqEg9eUdj9InqTJY+Nf4YF8ToCHi
	 jLmLFngMxXIZmE7RpqeoBDirs8BwCuv+J2LX41p/OnjpzhW7WpRcfOOo+QB8E/xjAi
	 FxXjO+iLibm6Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: use AUTO_KFREE() in btrfs_control_ioctl()
Date: Thu, 19 Nov 2026 18:28:21 +0000
Message-ID: <0f2ad05e9f38ddb7de900b72d8c2e90fd478a50d.1795112801.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1795112801.git.fdmanana@suse.com>
References: <cover.1795112801.git.fdmanana@suse.com>
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

Use AUTO_KFREE() to slightly simplify the code and avoid the explicit
kfree(), remove one error label and return directly on error.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/super.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 90e45becb59b..2609d7783e8a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2240,7 +2240,7 @@ static int btrfs_control_open(struct inode *inode, struct file *file)
 static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
-	struct btrfs_ioctl_vol_args *vol = NULL;
+	struct btrfs_ioctl_vol_args AUTO_KFREE(vol);
 	struct btrfs_device *device = NULL;
 	dev_t devt = 0;
 	int ret = -ENOTTY;
@@ -2267,7 +2267,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 			return PTR_ERR(vol);
 		ret = btrfs_check_ioctl_vol_args_path(vol);
 		if (ret < 0)
-			goto out;
+			return ret;
 		break;
 	}
 
@@ -2314,8 +2314,6 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		break;
 	}
 
-out:
-	kfree(vol);
 	return ret;
 }
 
-- 
2.53.0

