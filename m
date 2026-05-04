Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2FA273D6D;
	Mon,  4 May 2026 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777911003; cv=none; b=IX2TSWq01hNzeEw/+ZuvWrWS5w8Rw7EcwMsDJvzd4TdH0cXi129UKBcg7p0aePhWT0VJ4NP/iu7NIE9MMVe0LTs5Qpi/tOF1roaOH0NTfvVXpNpBC0jhS2eOBejk4GQdSsfc63gM3BYM8Jajtba6WEuMQBx+jIB8vDhj2Wct9+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777911003; c=relaxed/simple;
	bh=pFViZUbSECeFrklIzjDeoJmMCgBEQRGxLhga3mht244=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XWugKvb13e5GBbtNUqwDMN+FGe1B6MEoXMpHvWqWP5DvkE+ZeCX9KI4fb6oq080Rhk2AM97FaoU+i8Z3TLDWhP72cKpz/fJnNZpzkjskP66vfZORtDssi3hz4uDKeFR8SEv8wPeYomin6tkuGcR6YHY57yw6e0+AdhzKdYVs9JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dolOvtHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dolOvtHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBB6C2BCB8;
	Mon,  4 May 2026 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777911003;
	bh=pFViZUbSECeFrklIzjDeoJmMCgBEQRGxLhga3mht244=;
	h=From:To:Cc:Subject:Date:From;
	b=dolOvtHKVo9VOd0AuchkmSrmE0ILaGRYvZ1P3IOXy9oLa48sx0tfnGWNd6LTppsM3
	 lkgsXoJarbleUtNNhrKbSf5HYJFXs/RisNTGGkwbyY58/25MLLWhXsyKAOKEo1N79H
	 DfHr1uhPALgGGhCr0L4o9+VuXG+6vR8Q/M8PJr9Bg/AI6u6LhUf2caXkwKskuhLkSK
	 h+ZoNUY1kmslH9UwqdXS0I9YBPoUWJi1xY9fvdiEvxtH921TA46oBO9HlI0gkl+ugp
	 0TYXy3j4qDGxiVQXWwUaW1wFrni9MZNutr6GTutJ08uh36VV36It/kv8e18rFNwpwQ
	 bX/DDf2G3TY/A==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: add commit IDs for kernel fixes already merged
Date: Mon,  4 May 2026 17:09:57 +0100
Message-ID: <db06887383a2a3d34801de9fb180241157177204.1777910956.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

A few fixes were merged into Linus' tree, so add their commit IDs in the
respective test cases.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/343   | 2 +-
 tests/btrfs/344   | 4 ++--
 tests/generic/792 | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/btrfs/343 b/tests/btrfs/343
index 53e6028b..fd38c010 100755
--- a/tests/btrfs/343
+++ b/tests/btrfs/343
@@ -13,7 +13,7 @@ _begin_fstest auto quick compress
 _require_scratch
 _require_btrfs_command inspect-internal dump-tree
 
-_fixed_by_kernel_commit xxxxxxxxxxxx \
+_fixed_by_kernel_commit 883adb6dcff0 \
 	"btrfs: fix the inline compressed extent check in inode_need_compress()"
 
 _scratch_mkfs >>$seqres.full 2>&1
diff --git a/tests/btrfs/344 b/tests/btrfs/344
index 932b20d4..6e5d38d6 100755
--- a/tests/btrfs/344
+++ b/tests/btrfs/344
@@ -13,8 +13,8 @@ _begin_fstest auto quick compress
 _require_scratch
 _require_btrfs_command inspect-internal dump-tree
 
-_fixed_by_kernel_commit xxxxxxxxxxxx \
-	"btrfs: do not mark inode incompressible after inline attempt failed"
+_fixed_by_kernel_commit 2e0e3716c7b6 \
+	"btrfs: do not mark inode incompressible after inline attempt fails"
 
 _scratch_mkfs >>$seqres.full 2>&1
 
diff --git a/tests/generic/792 b/tests/generic/792
index 892ca2d8..d1896728 100755
--- a/tests/generic/792
+++ b/tests/generic/792
@@ -25,7 +25,7 @@ _require_scratch
 _require_test_program unlink-fsync
 _require_dm_target flakey
 
-_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
+_fixed_by_fs_commit btrfs 999757231c49 \
 	"btrfs: fix missing last_unlink_trans update when removing a directory"
 
 _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
-- 
2.47.2

