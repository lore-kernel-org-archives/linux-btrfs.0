Received: from mta1.migadu.com (out-203.mta1.migadu.com [95.215.58.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3463C37BE9E
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2026 13:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786800201; cv=none; b=bg28R6iMXQMuFe5023TrcwdTv7w4XZShiJEqsbnPgiIDRVtFJfWTUum33TNKy+/URQJeFtSH2CTZjEEwvnI25MQy4MBCEuTNF4hvlI04qKW90gTTZN99nZ2xQxVvJ1CpZuvWSLmwgH8ENOd34RwLPNph3YmP6CiwE/Jcx5Z13Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786800201; c=relaxed/simple;
	bh=OglmZqwKgdSt2Rek1YoJNCPOn5vyK4uYTYh2MA6083Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QML/PZHJaiwLUaYraILNZMnHXbcX+C4dTwN2H/pvLUsbZrJ2bgVPYGmbQ2woWRRHo5oPN+7Cw2pSKkAZyYoqhlMjItB76bFm07I3XPsRPFoAT4hpQqb9dkbPuFbUloOoeBDBoK7RyFWrG4XJgP+Y9fLfQwhY3uwfKYhg44Y+CfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FCNqgm1s; arc=none smtp.client-ip=95.215.58.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FCNqgm1s"
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OglmZqwKgdSt2Rek1YoJNCPOn5vyK4uYTYh2MA6083Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786800194; v=1; x=1787404994;
 b=FCNqgm1sXHieSyLRgPcIMwJUs81+uj6bW9yWFuN5wiVZYz+dX+ZWSJF5uEn7Tpx1plesCi9y
 sd9zOXOPam0bA77/cMfNDM7hDE+qPt+WYQDajI+9AsLoNkE9pEJ8R9EgxB4+wQvqlUcio4yYLTV
 OgSjxKO5NztGoWAvZprzR22Q=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: from ctao-book.. (111.162.215.50)
	by smtp.migadu.com with ESMTPS id 6d4d7ca9e2396d50;
	Sat, 15 Aug 2026 13:23:14 +0000
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: clm@fb.com,
	dsterba@suse.com,
	sforshee@kernel.org,
	wqu@suse.com
Cc: josef@toxicpanda.com,
	brauner@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v2] btrfs: allow idmapped DEFRAG ioctls
Date: Sat, 15 Aug 2026 21:22:59 +0800
Message-ID: <20260815132259.3935817-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
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
---
v2: rewrite the commit message to explain why defrag is safe for
idmapped users (Seth Forshee); the code is unchanged.
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 72bc9d4f7708..607329dedd50 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2458,7 +2458,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 		 * running and allows defrag on files open in read-only mode.
 		 */
 		if (!capable(CAP_SYS_ADMIN) &&
-		    inode_permission(&nop_mnt_idmap, inode, MAY_WRITE)) {
+		    inode_permission(file_mnt_idmap(file), inode, MAY_WRITE)) {
 			ret = -EPERM;
 			goto out;
 		}
-- 
2.43.0

