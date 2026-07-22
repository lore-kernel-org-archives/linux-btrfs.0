Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316152C3268;
	Wed, 22 Jul 2026 12:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724563; cv=none; b=kHOz9lZDGQyvdbD3+BhCMYfeUmirESx6ikx0YZZKfiw4xqzDyaCohSvq6gMJEEOmWIvkeuhCZpH2Wx/CWIZc2Oxq3CzctlgM5A1xP9EnMlOZVAAlM+ivtb29b9WoDPAfL7aR55NRkzORnlcyeituBq7d/ZQsKPAIiGB8jgQRjIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724563; c=relaxed/simple;
	bh=R4lwR2krL8rDm05gOVEVLYSIGQhSIkV6zk93iZH1jAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=azuIDu+FgUpXBVLZLkP8s1JmLNcB4qaATZWQTc0xEj6QwG5in7/5rYbUILMGEUGFZWY2oGrl2WE8QvRiqUEAGu2aSmdEssUpam5aOZgRjC1KKz3fa3zeeYeRA/4fCm2r6kefz1AOkiWzZJUXsRrGmaj2EK0iz+8IjMFcolc4pQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=copHAS9J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="copHAS9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284381F000E9;
	Wed, 22 Jul 2026 12:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784724560;
	bh=D2YIgmQapfsI908fDaPOy3Pgzq8a+dr07ChrPz1kB34=;
	h=From:To:Cc:Subject:Date;
	b=copHAS9JP0tENLb0t3VGGw0V62xz7dfJRhxnoy1rlAbGyPK9uq5dJ9/T6tai9L6M8
	 GOxXY8C+y9TZBF1G4KUE49/kooDCuvg9zlIz9vSGAJPGz9yDqqJZdq+vtoJMd6q9Gh
	 mlB1ygHLZT0OCT2xaVfYTzqNTXh2N38DA/dzAaRnqRxhS6FaO5l984N9Vh50GcNRmV
	 9XkBlOp6rLE9fR/DmEqFlufiB1kILcdun8ydebPDwHjfC7NFp/RdIbGFBeZtC1skLq
	 D2q+yumGnUbHR1oL8dWO9mvc5lZH70m4GafmGm/pctIbRvSmo43sP9yrQgN/mcewfz
	 G17FNi67AZVzQ==
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: add missing commit IDs to kernel fixes of some tests
Date: Wed, 22 Jul 2026 13:49:14 +0100
Message-ID: <62602f730db0955ab0c486640f7ad3eee75bb2e1.1784724364.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Some kernel fixes were already merged into Linus' tree, so add their IDs
and in the case of btrfs/351, update the subject of the kernel fix, since
the original patch was dropped due to another fix.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/349 | 2 +-
 tests/btrfs/350 | 2 +-
 tests/btrfs/351 | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/btrfs/349 b/tests/btrfs/349
index c6632dda..48ac9212 100755
--- a/tests/btrfs/349
+++ b/tests/btrfs/349
@@ -18,7 +18,7 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_scratch_enable_simple_quota
 
-_fixed_by_kernel_commit XXXXXXXXXXXX \
+_fixed_by_kernel_commit 1e92637722ae \
 	"btrfs: check for subvolume before deleting squota qgroup"
 _fixed_by_kernel_commit 0c309d66dacd \
 	"btrfs: forbid creating subvol qgroups"
diff --git a/tests/btrfs/350 b/tests/btrfs/350
index 7cc04b63..44b40410 100755
--- a/tests/btrfs/350
+++ b/tests/btrfs/350
@@ -9,7 +9,7 @@
 . ./common/preamble
 _begin_fstest auto quick volume trim raid
 
-_fixed_by_kernel_commit XXXXXXXXXXXX \
+_fixed_by_kernel_commit 1b1937eb08f5 \
 	"btrfs: do not trim a device which is not writeable"
 
 _require_btrfs_forget_or_module_loadable
diff --git a/tests/btrfs/351 b/tests/btrfs/351
index e92ddf1b..7829d5da 100755
--- a/tests/btrfs/351
+++ b/tests/btrfs/351
@@ -10,8 +10,8 @@
 . ./common/preamble
 _begin_fstest auto quick
 
-_fixed_by_kernel_commit XXXXXXXXXXXX \
-	"Revert \"btrfs: add 32-bit compat ioctl for BTRFS_IOC_GET_SUBVOL_INFO\""
+_fixed_by_kernel_commit 75a41e3e51eb \
+	"btrfs: fix GET_SUBVOL_INFO after compat refactor"
 
 _require_test_program btrfs_ioctl
 _require_scratch
-- 
2.47.2

