Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95972868B5;
	Thu, 25 Jun 2026 19:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782415232; cv=none; b=bnIHXKKZy6intdUB8UyE9BINsCrATfwXwyQn1rMnv1TE1UcQJBPoWgfh0hmNo2DCLbPgboUDW49K6w2z3F6kujxmWpKJiAvjvgIw6cwXLjomXrJF9mRhWHIhQMrtG6eFRL9eC4XDRcExxjNvTUz19nwjDWPAnVpTlgG2MpDto2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782415232; c=relaxed/simple;
	bh=MXodRKSPdBFaJoiA6TINsElb3Su+tvkQniI7FCv7Dok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N0B9aWxHSEv/lzb9FPlxqWVoD686QsgtfJoBQTSR5+dAAanTPGO4JVX/i3WFFG9AT4XzEIkBsm2IFzUK15ngyyeHad9xPQGo2RIWqWb7/VGLGk9H09MDw8DIGQ/2Tij6ap3oA7MXpyTGcV55GCBr8HXteyjZc4+eM4JF80LLKQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C42QyEof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C42QyEof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976D51F000E9;
	Thu, 25 Jun 2026 19:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782415231;
	bh=qR27asvEKm1vPNzZyHCkEpLqSujppN25EiK6rTbRrEo=;
	h=From:To:Cc:Subject:Date;
	b=C42QyEof/2r0v7MjyWa5bJM/m7KeP7B6VH49Lb444zE6eOyB29V1vl6eMQpxmeh69
	 9cIZTv8dgBcuX+SIBQD2HFWwSNrLJZaGREg+4v9C9JccihL2eLOnlgovPZa+crBdSk
	 BcvHdaJch3640hTAw6/L/DjI7rpmT0pyrzBRAQJv/kuXdMyR6UYoYfcAakPCCBqC2l
	 297guO4ki1lsL7yxbtcDcHFx5YXUy+WBJoW5rTJtXrxyRIPbhjweu0BKQnm4FmSV10
	 X3O4c2ROB5hJU7/ugIVZg68i4rWqZMBPXWtTrEjf5AdndcuLvZN0SwLkI3k7WIFKEI
	 UN8uGUabM161w==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: skip tests that fail when autodefrag is enabled
Date: Thu, 25 Jun 2026 20:20:26 +0100
Message-ID: <f0dedcfbe5d78d950325b293cfbb9d4fbab49a55.1782406920.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

A couple tests, btrfs/004 and btrfs/308, fail if we pass "-o autodefrag"
in MOUNT_OPTIONS, due to changes in extent layouts. So make sure the
tests are skipped if autodefrag is enabled.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 common/btrfs    | 7 +++++++
 tests/btrfs/004 | 3 +++
 tests/btrfs/308 | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/common/btrfs b/common/btrfs
index 30288f07..a75fbf1c 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -141,6 +141,13 @@ _require_btrfs_no_nodatasum()
 	fi
 }
 
+_require_btrfs_no_autodefrag()
+{
+	if _normalize_mount_options "$MOUNT_OPTIONS" | grep -q "autodefrag"; then
+		_notrun "This test requires autodefrag to be disabled"
+	fi
+}
+
 _require_btrfs_free_space_tree()
 {
 	_scratch_mkfs > /dev/null 2>&1
diff --git a/tests/btrfs/004 b/tests/btrfs/004
index 06eedde2..1c8b06f5 100755
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -30,6 +30,9 @@ _require_no_large_scratch_dev
 _require_btrfs_command inspect-internal logical-resolve
 _require_btrfs_command inspect-internal inode-resolve
 _require_command "$FILEFRAG_PROG" filefrag
+# Autodefrag will randomly change the extent layout so filefrag can give us
+# different results from what we expect.
+_require_btrfs_no_autodefrag
 
 FILEFRAG_FILTER='
 	if (/blocks? of (\d+) bytes/) {
diff --git a/tests/btrfs/308 b/tests/btrfs/308
index 3c8d410a..c4ccaa0f 100755
--- a/tests/btrfs/308
+++ b/tests/btrfs/308
@@ -22,6 +22,8 @@ _require_btrfs_fs_feature "free_space_tree"
 _require_btrfs_free_space_tree
 _require_btrfs_no_compress
 _require_btrfs_no_nodatacow
+# We test for a specific stripe layout and autodefrag will change it.
+_require_btrfs_no_autodefrag
 
 test $(_get_page_size) -eq 4096 || _notrun "this tests requires 4k pagesize"
 
-- 
2.47.2

