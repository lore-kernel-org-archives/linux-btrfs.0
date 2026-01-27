Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582212D94A4;
	Tue, 27 Jan 2026 15:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769526259; cv=none; b=cba/gQdG2EcIHjM5H8t9ev6hLQsO2gjEJMGIl2AimCpLat3eQvXTtP9yzjRLZoAwAarZTe6rwFFHmOsKZM0N4mV0OtoXJ0mo+fBWPQVv2KVH6xsbUn5VdeiZK9rmynCb+i4blcjAxwZBMU9KdXqN492Zc/L/NZtIfmoqASM+uaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769526259; c=relaxed/simple;
	bh=tN9D9eVRQLvEq9i5nmcF3AlLKPzgCYmZe0YdK/6lHOM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f8DjJqZJAtBUUNAwjx2W14X1DpW1wKanAujIKHu65na259wroWuGLr6T/tYDxGvMoTYqdZ3zdQck7ldUXsIEySTNmxNukgS2N41FJ2X19hc/ny8IdJKF0XQUb6ndrhD60h+R+tsHJGEQnYAddz2EJ39+OoY1i0vrS7GczdzQ3Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SPvxw1Kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SPvxw1Kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2599CC116C6;
	Tue, 27 Jan 2026 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769526258;
	bh=tN9D9eVRQLvEq9i5nmcF3AlLKPzgCYmZe0YdK/6lHOM=;
	h=From:To:Cc:Subject:Date:From;
	b=SPvxw1Kf0AN3Ikb3l6TUNSQ06J5WZDJuhmEKjKgcoOvd/5Erq+Irtekdik+haxt+/
	 83E+OTrHZcCds1IWWSTZyMgr4f6GqBIP8zyMfmHzfS00JcflyDCN7Prcj0XDkHnR0j
	 PHxIEBVouRoYYoL30bO47jiMcjMP+MWaMat/eofNQpZ5xQ89Lgcx0wn5q23FHzD0cE
	 pREJ38kvxwgh+cDlO9Tb2+97JW8mcyJaU0fEHQO6QfFPY4wBSaHQEvxx1Q1tRZ6p+8
	 +1ttiRS6QD3kXIRpCtLRDpuFb2/slxUth1jn99WrNU7Fh696J3AA4CghcXjRkoANOM
	 WCCs0Of7vSflw==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] generic: add missing kernel commit IDs to tests 784 and 785
Date: Tue, 27 Jan 2026 15:01:52 +0000
Message-ID: <ac7a142858d625cb5921568918b1b9615a650f25.1769525657.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The respective kernel patches are already in Linus' tree (landed in
v6.19-rc2), so update the tests to include the commit IDs.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/784 | 2 +-
 tests/generic/785 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/784 b/tests/generic/784
index 5d972cce..f7fb6272 100755
--- a/tests/generic/784
+++ b/tests/generic/784
@@ -25,7 +25,7 @@ _cleanup()
 _require_scratch
 _require_dm_target flakey
 
-[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
+[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit 266273eaf4d9 \
 	"btrfs: don't log conflicting inode if it's a dir moved in the current transaction"
 
 _scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
diff --git a/tests/generic/785 b/tests/generic/785
index d918de4f..6c3a1c36 100755
--- a/tests/generic/785
+++ b/tests/generic/785
@@ -27,7 +27,7 @@ _require_scratch
 _require_dm_target flakey
 _require_fssum
 
-[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
+[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit 5630f7557de6 \
 	"btrfs: do not skip logging new dentries when logging a new name"
 
 _scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
-- 
2.47.2

