Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD11367F59
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2026 03:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786592530; cv=none; b=gTTzQrziu7g0MvKOQU0/jMuHsfK5XzUPOlSGQ9hS8RjczBfEwUdZFm7bumSxvBcYjyOdFUBUBXFOi6jhrSuqIAzq9M122tcLrIhG1OuVBCHR3EzlVEpWAsDc6upn2S5i+eRB8bV3x9EABV8E9W1QTbeaW+8abCjWJTj5oiNy5Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786592530; c=relaxed/simple;
	bh=rkICQp9vai9NhJqSMqAdid4nZbPtr66Y+KDEbBSYtZg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hViMFQ39IOs4ns8tqfn0XxlFleW5mCOlyNP7e91v0g4TLEaPtGqelAqt96T/S9PoXRNLKJu0E1k7V8ufNW/gIzuSprN4UCwYYv96S/2MQkrq4mrPNJQIOSspz34kUkRetbteX55iodXrfOFtValcqOHjgorMZkIoP794W8Y7j24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YxmHBfsB; arc=none smtp.client-ip=95.215.58.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YxmHBfsB"
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rkICQp9vai9NhJqSMqAdid4nZbPtr66Y+KDEbBSYtZg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786592526; v=1; x=1787197326;
 b=YxmHBfsBBzatETFnBGtKsb4oKaGEkqMbbFuA4+EClox6UKi3sjUthhjwTD0wvK+Q5FL22QjU
 MqBJhlGBlWYPXoRNgBUeCwRTxpK+cRl46/V924oAWwyMaQ31duY5PH/A070rphm7bI+c1umiwsP
 HuzDQtzID6V0qKlKnmrF8YJo=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: from ctao-book.. (111.162.215.50)
	by smtp.migadu.com with ESMTPS id 013549756ecb3f54;
	Thu, 13 Aug 2026 03:41:56 +0000
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: clm@fb.com,
	dsterba@suse.com
Cc: josef@toxicpanda.com,
	brauner@kernel.org,
	sforshee@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH] btrfs: use mount idmap for defrag permission check
Date: Thu, 13 Aug 2026 11:41:46 +0800
Message-ID: <20260813034146.1207640-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

btrfs_ioctl_defrag() checks MAY_WRITE with nop_mnt_idmap, which skips
the mount idmap.  On an idmapped mount the owner comparison then uses
the caller's fsuid against the raw on-disk uid, dropping the mapping.
Every other permission/owner check in btrfs ioctl uses
file_mnt_idmap(file) (e.g. :1152, :1310, :1946); this one missed it.

Switch to file_mnt_idmap(file).  It equals nop_mnt_idmap on a normal
mount, and the check stays behind !capable(CAP_SYS_ADMIN), so only
unprivileged callers on idmapped btrfs change.  The RO-fd note in the
comment above is about the file descriptor, not this inode check, and
is unaffected.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
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

