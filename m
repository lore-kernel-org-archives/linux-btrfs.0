Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB913B637C
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 16:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790355248; cv=none; b=tosdJVWekhF+EZRaRFgu+6JFMoxf8kgBU8WEoM1e10+dPQzOpwLAV/jbwPPSmBN9F/O+sgyPOgTS4adt3Yi0ox17KLfs9ZuCmQi4mUAk8lQDyVPZb4NprI3JN/+wDcKb58D/qZuOscjS9tuefwfwfO8UT6RGg6Fd/p1DKmrMLFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790355248; c=relaxed/simple;
	bh=xuSyjf5sAlcDXVAeD6VYjb6ooKebpWRXAylTYYWQfGA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=cWWUJRQ2fVa1YIQ5/1GUdo/7gQSqM/laDMrO/I2m3TXTv9e4dPPXfeTGPx6126fLJi2xAnoQTFnB5CWGr5UZkB+GT8k8M1bCwMSJiTIZ5K5RVIj9xO1dMoGrWYjSbKom77Xui8Htwd1W7ePd6qPQ2V4tTA+/wNK0pJKnKX/J8zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gK+iQQS6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gK+iQQS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1451F000FF
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 16:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790355244;
	bh=2nlx2MOzscIp+1DHL0Z21SFKeOcH4pF7kmKsDXFrz1E=;
	h=From:To:Subject:Date;
	b=gK+iQQS6CbB//0yIVy5ynXAs8YZERUOLGs/i1JhN9K2VfijotenvNf/yTs+f6uj+p
	 1aBsBAuzSzvS/gtLaL9AG0PXfF2vkwGuJcn1FtZ09xLXLPY1mUqHYAfT9HDGTDIFAo
	 LDP44nku2ch9ERcskGKibiVtOo5HcQM7GFlPqv1BnZ0s2k9SCdTAak0Ks9GKW1a/Z6
	 5NAgmGKC/KIeBHzadF6Wy/wsoHAFx3tQfH7AGc4OLUa1KVBQfvVRNDEPl3ZintUsuv
	 D9zDc5wM0JJHNyi0BkYOz9Rp28aPis3jEBEz+lTQIRyL2ElEdXSi5VV9CAJxyAMzq4
	 L8jrHr/hEpFYQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix lost error return value in btrfs_listxattr()
Date: Fri, 25 Sep 2026 17:54:01 +0100
Message-ID: <3a22684fd6ee950fdd7bf1a6119e87366e9a1de8.1790355229.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we input buffer does not have enough space to store the current xattr,
we set 'iter_ret' to -ERANGE and then do "break", but that only exists the
while loop over the xattrs in the current btrfs_dir_item, and then we
continue the btrfs_for_each_slot() iteration, which overwrites the value
of 'iter_ret' causing us to lose the error return value and proceed as if
the buffer has enough space.

Fix this by returning -ERANGE directly (the path is automatically freed)
instead of breaking from the while loop.

Fixes: 184b3d190087 ("btrfs: use btrfs_for_each_slot in btrfs_listxattr")
Assisted-by: LLM (found the bug)
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/xattr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index e8762e12f3e1..cb001a211f55 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -329,10 +329,8 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 			if (!size)
 				goto next;
 
-			if (!buffer || (name_len + 1) > size_left) {
-			        iter_ret = -ERANGE;
-				break;
-			}
+			if (!buffer || (name_len + 1) > size_left)
+				return -ERANGE;
 
 			read_extent_buffer(leaf, buffer, name_ptr, name_len);
 			buffer[name_len] = '\0';
-- 
2.47.2

