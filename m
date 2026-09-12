Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3709488D82
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Sep 2026 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236818; cv=none; b=V21dCyTAAYLBPK31cvVGLqfHiusq/gn+1Sg9rAWt9la+RjdJjPbklvfTopYr9xhpUyGs5EaZegopwe/s3F8ucwq7/B2RpioW81D64TH3chbDSOiGUz0BGa62KucYNW7V3KsYPOtcbQzV3RMFxUBZtrrjxcPsTI/JijVPuM8xzQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236818; c=relaxed/simple;
	bh=fQn3Z0hKGJ3o2B1dtJdFFUljkikjBruExK/3lLO8bMc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mWRANWXWuiKc2e6smMgmyuFEZqreJ4CQQ1oQR1eNNDRpedMvT9cZ4ikIG+Wi5yAYL8l5tJ5OcjpJiB7ElwCYv6eG9qdJVfEgaHd90i4RqJ1sBDviqhUiRmY8+ZojWUtzQDwNhjlfIFBrmQeObG0g4jCUb/NNeWCyt7YzIy8VI4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YcR3vHnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcR3vHnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D061D1F00893;
	Sat, 12 Sep 2026 18:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789236815;
	bh=5zPpMGkIXUaxPUfEze6dQG+Im5tgwqKHkVHy3AwL5L0=;
	h=From:To:Cc:Subject:Date;
	b=YcR3vHnURwFayMTD+WgHsVEOstiC3756a4brb0tlNn5DbfQSBqHyAV/VzBviXGyd2
	 150fqEXa6p0jeHWYtJRtcq3Yxj1wZlu0H7XQAQV780qzeXhdxTT/uhUxggBlazQv4B
	 d9OPkb1sKQRWQKKBz68lyIoXCLR0Gm/WpdxeXgUrCKnEXE89wuV2JC98UAX4EyhJzO
	 VxZTHeZ6opvCFMpkdXTpy7gtD+EZKrNqnZ9Pud9wmb5NmoSTsLFNH7Y4JtSK94ZYCu
	 Kbzg6QhfUf6tsxQqg6P7oFpsoC+ZKXq25E/3JZy97i5r2SQNZFPsnX+fZ/MUeiT2I3
	 2ukOCQLJHTJgA==
From: Anand Jain <asj@kernel.org>
To: linux-btrfs@vger.kernel.org,
	dave.hansen@intel.com
Cc: dwmw2@infradead.org,
	thiago.macieira@intel.com,
	dsterba@suse.cz
Subject: [PATCH] btrfs: derive f_fsid with dev_t only when temp_fsid is active
Date: Sun, 13 Sep 2026 02:06:28 +0800
Message-ID: <16069a6fc651168bfcd2394d6e57ce63a50231ed.1789235482.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit c2a74ed0494c ("btrfs: derive f_fsid from on-disk fsid and dev_t")
mixed dev_t into f_fsid for all single-device setups to avoid f_fsid
collisions with cloned filesystems.

However, doing this unconditionally breaks backward compatibility.
statfs(2) f_fsid changes after a kernel upgrade, and also can shift
across reboots or dev re-attaches as dev_t values change.

Fix this by only mixing dev_t when temp_fsid is active.
This means for non-temp_fsid setups or the original mount, we use the
old method of deriving fsid based on the UUID.

So in the case of a cloned Btrfs filesystem, we won't be able to
maintain the same fsid across mount recycle if the mount order
changes.

Fixes: c2a74ed0494c ("btrfs: derive f_fsid from on-disk fsid and dev_t")
Reported-by: Dave Hansen <dave.hansen@intel.com>
Closes: https://lore.kernel.org/linux-btrfs/be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com
Signed-off-by: Anand Jain <asj@kernel.org>
---
 Dave (Hansen), I wonder if you could verify whether this fixes the issue
 on your end. I have run some limited test cases from fstests as of now,
 and they passed.

 fs/btrfs/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 464129b1b0d4..ddb620ac241b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1836,8 +1836,12 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root) >> 32;
 	f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);
 
-	/* Hash dev_t to avoid f_fsid collision with cloned filesystems. */
-	if (fs_info->fs_devices->total_devices == 1) {
+	/*
+	 * Hash dev_t to avoid f_fsid collisions with cloned filesystems.
+	 * Only do this when a clone is present so the original filesystem
+	 * (mounted first) maintains backward-compatible f_fsid behavior.
+	 */
+	if (fs_info->fs_devices->temp_fsid) {
 		__kernel_fsid_t dev_fsid =
 			u64_to_fsid(huge_encode_dev(fs_info->fs_devices->latest_dev->bdev->bd_dev));
 
-- 
2.43.0

