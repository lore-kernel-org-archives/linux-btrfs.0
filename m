Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CB4494A1A
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013649; cv=none; b=ihKg6gaYajoVPLJy8XtmF5UOPVQ2Aqi0QRUh/2bpfapPsL6lFl2LMfL3HiMrPXDSsnEflYxbc5hzl0PAabXlfiCGR5+FRe1EKernhG9mVfg8wENqzIt57+hn4qEs9QlV3gpyoQnTQ7u5TRnZBkjaSm1SVDJt3T5Pbjb03b7ANTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013649; c=relaxed/simple;
	bh=jlM/LtmLtEhWHmA65Ilb5nHba8h71F1ezGFEpDo1Cps=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VOvdO+4LdGC483PD/zGV5Bjm87OzbVjRAaKrXstQPy9RxGAXn4HSllowF/75rFMUhx4MDPhEcbbTt+4AVKqxw/8rRjwLHgcEsWp8Mr3VISqQdtTYWxkK8SFVAUse2x445CJdrAAnkgDO6QnpHaY2Fm0KIi2+HtuUNKW5mfQ7Wm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MkKh9MfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MkKh9MfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280F0C4CEF1
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 16:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769013648;
	bh=jlM/LtmLtEhWHmA65Ilb5nHba8h71F1ezGFEpDo1Cps=;
	h=From:To:Subject:Date:From;
	b=MkKh9MfP6fZdo+xMBGPZAqRGAw6XthbB8ZJ6hY4fvY9qqmzD+dr02QhbIecQcWJYy
	 xrKBQQoJSm4C7RTFnpu0yo38i7jm0UKvTJ9H3v75TR2jnoTZXn8i/uqqyXfegq+DYM
	 yFTsmqbFIdKVKCWO9eRb7STpprrvQY70bg5Y0DPsNX2aVIpwxcRh0oHPuQeL3rd5eT
	 HOqnwP64/U0gSnWo8qqSRzDHCei8gk0cSMphmfdmZMP7otxQgeoOn1A34FR4HWA4q5
	 30ia7Ieo/Fd/IJRvk3Zge45h0VpIA5YqPt60vT3I0lrQTvWkX0x4XyxibYwi99YQ8V
	 5axbR6Au2ACMw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: unfold transaction aborts in btrfs_finish_one_ordered()
Date: Wed, 21 Jan 2026 16:40:45 +0000
Message-ID: <f528a186fae32bf12b9d2a61efa77a1cad66e55a.1769013565.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We have a single transaction abort that can be caused either by a failure
from a call to btrfs_mark_extent_written(), if we are dealling with a
write to a prealloc extent, or otherwise from a call to
insert_ordered_extent_file_extent(). So when the transaction abort happens
we can know for sure which case failed. Unfold the aborts so that it's
clear in case of a failure.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 09a7e074ecb9..10609b8199a0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3253,19 +3253,21 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 						logical_len);
 		btrfs_zoned_release_data_reloc_bg(fs_info, ordered_extent->disk_bytenr,
 						  ordered_extent->disk_num_bytes);
+		if (unlikely(ret < 0)) {
+			btrfs_abort_transaction(trans, ret);
+			goto out;
+		}
 	} else {
 		BUG_ON(root == fs_info->tree_root);
 		ret = insert_ordered_extent_file_extent(trans, ordered_extent);
-		if (!ret) {
-			clear_reserved_extent = false;
-			btrfs_release_delalloc_bytes(fs_info,
-						ordered_extent->disk_bytenr,
-						ordered_extent->disk_num_bytes);
+		if (unlikely(ret < 0)) {
+			btrfs_abort_transaction(trans, ret);
+			goto out;
 		}
-	}
-	if (unlikely(ret < 0)) {
-		btrfs_abort_transaction(trans, ret);
-		goto out;
+		clear_reserved_extent = false;
+		btrfs_release_delalloc_bytes(fs_info,
+					     ordered_extent->disk_bytenr,
+					     ordered_extent->disk_num_bytes);
 	}
 
 	ret = btrfs_unpin_extent_cache(inode, ordered_extent->file_offset,
-- 
2.47.2

