Received: from mta0.migadu.com (out-65.mta0.migadu.com [91.218.175.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B4C453A45
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Oct 2026 07:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791532428; cv=none; b=ThWJNR9hZagVxiXFAucerxchgOKUdIzZZoonqo5w6lRQx9aOWmuUwd1Yafbwt/ehLfgBwdNZ0fox/+DHdt2u4jaqls67hrE2FeqSQdkoVPzili40lJYW76rSzXWaD6Cs+oZknwPXmi3h9jAwCk4lKJ8/hkF60VXD0sGXqs62U/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791532428; c=relaxed/simple;
	bh=HZ6Wuv+Vpadj5tKbRNWjPRR1mJvXXgABfE/UEOmItbI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pJs/79x59XNw1CC1KUdAhClaFZV2PjjL6EjRYR2mrty71v3VLSWTE/aHS52UCMONUIBgRnDFrIBt7z8gGSdF65Ip4hB7p7yJ05T8WQqV+K6lMkbsrLDgE0g9smb0DYX0TO8h8pff4x5+LIOwawb+qqUx6r1GLC/ybHPPqpKtVxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ogLvf0dV; arc=none smtp.client-ip=91.218.175.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ogLvf0dV"
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HZ6Wuv+Vpadj5tKbRNWjPRR1mJvXXgABfE/UEOmItbI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791532424; v=1; x=1792137224;
 b=ogLvf0dV9i+GtslzITBYdW+jM84tauyfDyaiD/x/qaXr8/YwBqRTWGec7+Zq9OlgJ1jcgOIs
 VUJ4TGV8kIxCh/tgjng3DbYBuhIx6VrlxKNb8gkfDTJU6xaDxBju4G4lXELtKRviTwzfob5eupp
 DwHINVXZqgo3kTQ1CloFDDuo=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a4d8209de247e626;
	Fri, 09 Oct 2026 07:53:43 +0000
X-Mizu-Trace-ID: a4d8209de247e626
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: mason@kernel.org,
	dsterba@suse.com,
	sforshee@kernel.org,
	wqu@suse.com,
	brauner@kernel.org
Cc: josef@toxicpanda.com,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v3] btrfs: allow idmapped DEFRAG ioctls
Date: Fri,  9 Oct 2026 15:53:25 +0800
Message-ID: <20261009075326.144319-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

btrfs_ioctl_defrag() checks MAY_WRITE against nop_mnt_idmap, so on an
idmapped mount the owner comparison uses the caller's fsuid against the
raw on-disk uid and the ioctl fails with -EPERM even for the file's
owner.  Pass the mount idmap down so defrag works on idmapped mounts.

The check, added in 616d374efa23 ("btrfs: allow defrag on a file opened
read-only that has rw permissions"), is not a privilege gate.  It only
tests whether the file could have been opened for writing, and a user
who owns the file on the idmapped mount can already open it O_RDWR,
write() to it or fallocate() it.  Defragmenting a regular file only
rearranges the caller's own extents; there is nothing it can rewrite
that the caller could not rewrite anyway.  Whole-subvolume defrag on a
directory keeps its capable(CAP_SYS_ADMIN) requirement, and the
!capable() guard around this check is left as is.

FIDEDUPERANGE already works this way for unprivileged callers:
may_dedupe_file() in fs/remap_range.c compares the inode owner through
file_mnt_idmap(file) and falls back to inode_permission() with the same
idmap, and dedupe can rewrite one file's extents from another file's
contents, which is a stronger operation than defrag.

On regular mounts file_mnt_idmap() is nop_mnt_idmap and nothing
changes.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Seth Forshee <sforshee@kernel.org>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v3:
- Rebase onto linux-next (next-20261008); no functional changes.
- Collect tags from review.

Changes in v2:
- Rewrite the commit message to explain why defrag is safe for idmapped
  users (Seth Forshee); the code is unchanged.

Link: https://lore.kernel.org/r/20260815132259.3935817-1-cui.tao@linux.dev/ # v2
Link: https://lore.kernel.org/r/20260813034146.1207640-1-cui.tao@linux.dev/ # v1
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f3e2afe221be..fe8c00eb38bc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2473,7 +2473,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 		 * running and allows defrag on files open in read-only mode.
 		 */
 		if (!capable(CAP_SYS_ADMIN) &&
-		    inode_permission(&nop_mnt_idmap, inode, MAY_WRITE)) {
+		    inode_permission(file_mnt_idmap(file), inode, MAY_WRITE)) {
 			ret = -EPERM;
 			goto out;
 		}
-- 
2.53.0

