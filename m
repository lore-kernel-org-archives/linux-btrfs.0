Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4673655DD
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917566; cv=none; b=Sx2mxtmXQRwrvpRywreU+SnzdR6iYGpJSoonH8X0ZekJ8kCyI6rkGVLQzNTU5FuHidrp/SSQfdUSDwi0dGqN69DSe8tf1DNirgmjPfHSCbz+GcRreLSk9VIbx2IfuYoTBacg3j951XIoV+G69SNEJ8l0DYV3BXsbFrAFiz4d6NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917566; c=relaxed/simple;
	bh=XQEX2Y2O4hMYmAZ5i09h7ZLJsIQJaJwVWKBCJ8WAfB4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZ3vuMZ0EIj6LpsTllacvjX5AK/OW9Qb5+2i5HH1TS13u5iXVHl4AnSfxHoSrl0pl8mcffl73fskYtGW2LwvzFuJAeT4lblxXFVpdsKi6gkVDUwUCaGFCz6IzlzG3LBE+/1RodmKaBgQ+GBBKGPHLkJ/hxuVeDPGCSwa4pMFG3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wp1QnCFt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wp1QnCFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82CC1F00899
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780917565;
	bh=ujNPcGT/aRqnKco0/0GLtpePxF0fdJ/3Y9ugM67RhWA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Wp1QnCFtAtOvILF5lW7z5q6H8f+fGsOjSFqh4fZf4R97qkWT8WmV61cjrJx8OKZCW
	 zayOGcuzBz4VERILtP+NPwpTdPq7bo8jtXBdV3eOO3tnJ1DcJhxyTamiat9KBLbkPl
	 NhkK1aF6VlYMXPgw+aHxKDNl2rpC85OYUgrZMgNga1ONizaWVYXEasjcXHj7BNeErd
	 RTrZxbc2OdiZtK/iA9XS3CZCGUa+juAhCA4jSuL5hYbzJL7BLdegUasVAUk4GdVhGe
	 3Uveyy3+9wno78G4k8c++fGntokemy+INxI2M0wXwg9m61S19DO61rI/6DJSCh9X9q
	 pknMJNaor8tkw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: don't over reserve metadata space for property in btrfs_fileattr_set()
Date: Mon,  8 Jun 2026 12:19:19 +0100
Message-ID: <545718c847f218e3b42dd63bd0bf9109daa7aa1b.1780916663.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1780916663.git.fdmanana@suse.com>
References: <cover.1780916663.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We are using 2 units for properties but we only set one property.
Fix this by using the correct amount: 1 unit.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d47d16394fc..4b49b7e08425 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -392,9 +392,9 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 
 	/*
 	 * 1 for inode item
-	 * 2 for properties
+	 * 1 for property
 	 */
-	trans = btrfs_start_transaction(root, 3);
+	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-- 
2.47.2

