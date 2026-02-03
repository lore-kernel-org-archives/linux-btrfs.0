Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788933B95E0
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 15:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770133166; cv=none; b=gQkeRm4xCYlfNf9SqXPeqIqO+ZR2jklYJzbTiGglVsZfuYPZiTuMRnH/ukDeFTbUu9xMfpMX2UckbdFwUDszw25W+HoeORNllVTy5awO0JUT4KuZFEFMJCYctGvRezllA7AC8890gXElM0znh/aCIb8ohf2YwwsnSCl6wfz2Y60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770133166; c=relaxed/simple;
	bh=12pqNVoMM+srT+qEcRzAflRXjvR44BAPpXtTm3rbtIk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abzbEN27uTJM95+c2iftoEg6OTbJv0y6V47hRX0XbTpB9NMaU4anxXg0mS/8I6E1gjMxDXTNxq4fDf03kiSjpdmiHWK+zy9L5U8PU+Zp1k65U6tIBcXSrWuamIoAqTWzQSchHOs6jTWKmHHZzsJ9rbCdCu26JgzBRWIOQ33s7NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B4RVKXg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B4RVKXg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B79C19421
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 15:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770133166;
	bh=12pqNVoMM+srT+qEcRzAflRXjvR44BAPpXtTm3rbtIk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=B4RVKXg6nAB3L8zG9jlmNzGMcplr3sg93aw6pHkIiO9TmxKPQid/mHzDe1Z8b2fL9
	 DFrw0TgYUpXcnxXkAIralvLY9dLEMQ0pgpOenhMt56vtZxJ8de3pdFq7NWZtiLy6Dm
	 LFK2FEYPjObM99CPDI8qJrAli0S3NVs0/DFZLVZGns+J3A1vA9oLIjVD4Ks+ov7HgC
	 PyFq58NgMEe3Xput12iYJGLMxLVvDkrZPRrHAeUkRAi1uCOWQE3IuhFlzi8CVs95Sz
	 eIRYi6+XKA1yWfZC8trU9m6HH5L3Tr3Io2bvGzbsWCFNynXxxhByUmfTAADoBRBakx
	 JTZKC1Jf2q8hw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: remove duplicate system chunk array max size overflow check
Date: Tue,  3 Feb 2026 15:39:20 +0000
Message-ID: <6c43557e420916124d3da3fa212c505a71919eb8.1770133086.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1770133086.git.fdmanana@suse.com>
References: <cover.1770133086.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We check it twice, once in validate_sys_chunk_array() and then again in
its caller, btrfs_validate_super(), right after it calls
validate_sys_chunk_array(). So remove the duplicated check from
btrfs_validate_super().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 20c405a4789d..540ec255b7a4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2534,12 +2534,6 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 	 * Obvious sys_chunk_array corruptions, it must hold at least one key
 	 * and one chunk
 	 */
-	if (btrfs_super_sys_array_size(sb) > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
-		btrfs_err(fs_info, "system chunk array too big %u > %u",
-			  btrfs_super_sys_array_size(sb),
-			  BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
-		ret = -EINVAL;
-	}
 	if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
 			+ sizeof(struct btrfs_chunk)) {
 		btrfs_err(fs_info, "system chunk array too small %u < %zu",
-- 
2.47.2

