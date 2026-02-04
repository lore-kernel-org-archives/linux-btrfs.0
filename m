Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD82421F0B
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Feb 2026 15:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770220339; cv=none; b=U7YDuZ/GbeNmoaEc44ODqgBNkFOd6jKpb9onjzxkIjZMn93VrzrZq26F5Y6+flD9y5vGbUVIuKOe+z8VDmuPgqxmov2EqpqRdEs53K+1ChHHbehGaePHHSTe5nKL0QxB5ZhZuPgXnIUj/FE4ovohDe4xUNhqu1roD1jBfbmsSHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770220339; c=relaxed/simple;
	bh=u6rH/MA9GyvKxn+7d4Wd+vJMHeFFCuklJ2zoIwBHlH8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gs7kvpXrhzlPzHXIU+lY3Ms2nN5z4XiCE18jE8IvC3jJvZCI/DN/Jw2lHn1Kg0WlMp5Ymfy5SjCWHrTreAQFOb0uk8d//2T1Onb70P9ViBixcl+7qE5CauopGYmddkDJghiuWf0sJSzCZ7ck3EHjE8nb/1oFCDjCKBk6WCDYvKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QDmu7+VZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QDmu7+VZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4D3C19423
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Feb 2026 15:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770220339;
	bh=u6rH/MA9GyvKxn+7d4Wd+vJMHeFFCuklJ2zoIwBHlH8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QDmu7+VZHUYHUJkLi5mWY3qcFoFRXaGJJG+X+rFbDKMAjqmurD3686WvqdBSH7owJ
	 72VLF/jGoB0Ya7TBH67k0IbcQ/XLzneiXna0r/d712gyaqeQWZeaSeXGPKCbLrw5hN
	 Fn8/cmeuFnakmoMYohH/gOaJcNk36N1+uogpk1YArHBycAgqUSFTHLrmYs3Vm9j48k
	 fIc8OjKx4Wcp6UGjuXArHyGJi4h8AQSQbCA6w2zBCl55UpVVor2a9jhR/ieW4CY4MO
	 sG+aXnKQyimvns1Ee6HzY1SJ7ut4IpEfplskp/Av4er8uNUlFGMB8wFqGB7FVR/1kv
	 CAszgBu/TySNg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/7] btrfs: set written super flag once in write_all_supers()
Date: Wed,  4 Feb 2026 15:52:04 +0000
Message-ID: <ec91c8271e892894ae2d4918beff1e31cc3d6dce.1770212626.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1770212626.git.fdmanana@suse.com>
References: <cover.1770212626.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

In case we have multiple devices, there is no point in setting the written
flag in the super block on every iteration over the device list. Just do
it once before the loop.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cf4ab067be72..e95c699a0bae 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4023,7 +4023,6 @@ int write_all_supers(struct btrfs_trans_handle *trans)
 	int do_barriers;
 	int max_errors;
 	int total_errors = 0;
-	u64 flags;
 
 	do_barriers = !btrfs_test_opt(fs_info, NOBARRIER);
 
@@ -4053,6 +4052,8 @@ int write_all_supers(struct btrfs_trans_handle *trans)
 		}
 	}
 
+	btrfs_set_super_flags(sb, btrfs_super_flags(sb) | BTRFS_HEADER_FLAG_WRITTEN);
+
 	list_for_each_entry(dev, head, dev_list) {
 		if (unlikely(!dev->bdev)) {
 			total_errors++;
@@ -4076,9 +4077,6 @@ int write_all_supers(struct btrfs_trans_handle *trans)
 		memcpy(dev_item->fsid, dev->fs_devices->metadata_uuid,
 		       BTRFS_FSID_SIZE);
 
-		flags = btrfs_super_flags(sb);
-		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
-
 		ret = btrfs_validate_write_super(fs_info, sb);
 		if (unlikely(ret < 0)) {
 			mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-- 
2.47.2

