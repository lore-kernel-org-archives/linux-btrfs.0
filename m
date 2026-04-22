Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F3D3DEFFB
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 12:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776861511; cv=none; b=htkhyRZ3nfEbrL9gYS/z0/bV0jQwYSwoa95Qv/AsNakr4rbGKYzA6ukXDIebQ5cBkwsazfEYcN6ZOPxa9DJfURbCzQRj303DxWI4vmhtpP8KaFncijuagfsHpbFtL/4fuCO5Gmldhq4lo+iaLsR0w+8l4iVLX/i3vikle8B63DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776861511; c=relaxed/simple;
	bh=SqqrXuOcwp0mDTE2JfSBNMwR1q/HYmy2wowxXZyT3DM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zu+BKNpkr7tMC3beLWCIot4p2aMENPvguCEkiBdRjoDLVwx6FyBGu8XiIHc7w4MVOudzdsqIVcm51wO+1udWd8GSaQTLNNDrHsxnT6NdnA8XvH/kQf0t+/Hi1p1UiNH0VnRBI5YlPtdnFMag4gzrUsu0D9LlW+WOff/FMjivQ0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pFgrQ3vB; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pFgrQ3vB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776861506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5GL3ANXEiw0DDYEN9415UA1/3jHHqCn9ChSD9FoLWd4=;
	b=pFgrQ3vBxSwvN/IUc/58FialO37NXcV7j+DS/Ao9SYM5c74RDTqlOeHICx28tPVI15oKxH
	Ctkw4VbqT0TMLX3l/XvXKjUU401H/+yj/ehYLxFOr5DP5glAGkUn7/YOxyisyhiDeI0APl
	kIGKOss7kaqmWsBv+x1PEzqReKVeh3Q=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: use QSTR() in __btrfs_ioctl_snap_create
Date: Wed, 22 Apr 2026 14:36:36 +0200
Message-ID: <20260422123633.100798-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=636; i=thorsten.blum@linux.dev; h=from:subject; bh=SqqrXuOcwp0mDTE2JfSBNMwR1q/HYmy2wowxXZyT3DM=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJkvDlxkD9hQ7F7Re5ft09uaixxftv9cuoYvMpovZ9maT xtXqPT6dpSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEzk5l+F+f92FuyA75Fg/n HUZ6CdGaxaWHurVW8HWGeP92Xnx75V2G/yH3tXNWi1z8IHiB9YELl+8voZAJWzgNOGbeW3yU0Tt HlwcA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Drop the length argument and use the simpler QSTR().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b2e447f5005c..4d9e62f3c668 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1114,7 +1114,7 @@ static noinline int __btrfs_ioctl_snap_create(struct file *file,
 				struct btrfs_qgroup_inherit *inherit)
 {
 	int ret;
-	struct qstr qname = QSTR_INIT(name, strlen(name));
+	struct qstr qname = QSTR(name);
 
 	if (!S_ISDIR(file_inode(file)->i_mode))
 		return -ENOTDIR;
