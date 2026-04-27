Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39CB309EE2
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 10:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285100; cv=none; b=C6MXXu1XvZEIiSRnG54U8nQck+RtXp8WcdunuIIgVxxQQGMUFNfA79Xv3quCzVOwPGBbwdBYiT+Mya1t1zIox1nWny4Hzuae2mO4yr/aOvPvH6xSJJKy3VXezyM09gSSjtoV1k/J5ybCXE83RlUEa2WsybK8Rvw8CmcgCeoTRAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285100; c=relaxed/simple;
	bh=5WbMMz2iGRGITtfYJ0GXlHJhhpQ4Go72Qhr9p5uyInU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCrpXQOts7cfG3lfWagOYh5ohwt9S0ugCl68KreUhH1KpXNbNm6nVrv+7i6Ai5JF0RUoZ+nfz7OxiTkaT6j5vns32Lq0/UMrdoJ21Wl0/sZbNpXMn+1kUsj42VcikIBYYV2ey4iKTJb6W/jtAsm4kFhoODAOmx+DrpcZMK+p5wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rzmRxTX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rzmRxTX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E738C2BCB6
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 10:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285100;
	bh=5WbMMz2iGRGITtfYJ0GXlHJhhpQ4Go72Qhr9p5uyInU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rzmRxTX1M/1BaQRrvM1K83sxNi5PObnpCI4hPOuV/mZWvwMUlPevKZxLoFRI+zjEv
	 SIsjS3A+a1ujNMnGFF1ZssfSf/7+1Gh+O7rJ3HiYZ89CLu52jHJI/rCsW1RxGsvZMk
	 sWMDn+S+sc0NhMD6xIpY17vvFZ6kTmi5AbzCWBm/Q6s/MaqPMuV4yLQYbMV4l5XI4d
	 JAXMZRSJyP6UggzUGQ2tQe8WddeumQD63M4a4OdilR06TORDsIRq2eP2DWCuJFkUsv
	 oFUUQ6VgXFeLjAKJrjKOH6NUjlia3csGuJvHuih+gxLVnGWfVLnVHh4TRPacehvThp
	 S+T1G+H53Bd+w==
From: Anand Jain <asj@kernel.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/2] btrfs: use on-disk uuid for s_uuid in temp_fsid mounts
Date: Mon, 27 Apr 2026 18:18:03 +0800
Message-ID: <b4b5637ca4137d71eba368e37c67abcf60df0cab.1777281686.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777281686.git.asj@kernel.org>
References: <cover.1777281686.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mounting a cloned filesystem with a temporary fsuuid (temp_fsid),
layered modules like overlayfs require a persistent identifier.

While internal in-memory fs_devices->fsid must remain unique to
the kernel module, let s_uuid carry the original on-disk UUID.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 fs/btrfs/disk-io.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2020351e715b..0771903f82ba 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3447,7 +3447,16 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	/* Update the values for the current filesystem. */
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
-	memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
+	/*
+	 * When temp_fsid is active, fs_devices->fsid is assigned a random UUID
+	 * at mount. This inconsistent UUID causes issues for layered filesystems
+	 * like OverlayFS. Since metadata_uuid may or may not be set, provide the
+	 * on-disk UUID directly from the super_copy.
+	 */
+	if (fs_info->fs_devices->temp_fsid)
+		memcpy(&sb->s_uuid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
+	else
+		memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
 
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(fs_info);
-- 
2.43.0

