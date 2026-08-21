Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AA42F25F3;
	Fri, 21 Aug 2026 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787334610; cv=none; b=IDxUhkV4pHWIKKEBMkoGDT0Ps7LvZUTHiRnBDErbFYxwBNyTUM3YzWQwtTfeKeb3LBJtsPRz03VfymN0PeWEc0h653Z0VbOiQVuY5+gYD0jifQ0ihzmXQ3+z08dcdfMa7XRm73BCQ9NRfZomtQZmr+cawxUwQpYOkb19jZMKV38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787334610; c=relaxed/simple;
	bh=qBRAP/zPKkWC5geneX3MxsfJLoCV68O96ybSe6WpbPc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=lsc5WkCJP2KWVYe6F4UL4Wio+rh4g79yU//ksCuW+dXpBSOZjro7EDr99y+C5gadbcxMXhJRB78sLnpPeIF+l8w9bKuRHjhGkGqgQceqgJFVMewqh/s19uc67AD+qSkrU/DAnqg96jrC6M35VW9N73bwnF2Xcf2qRTPxJCfFpAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4N5c+7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4N5c+7e"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88D0FC2BCF4;
	Fri, 21 Aug 2026 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787334609;
	bh=qBRAP/zPKkWC5geneX3MxsfJLoCV68O96ybSe6WpbPc=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=U4N5c+7efnyReKSb8y1O0ykmCDLIcqf0jw+5e7TdCb6O6Y77g6+WhyrsdBJlB/GFq
	 AOiFACr8AUa9JfrN9EnIUs0f8LkOBUxXUsM1VAM+pLyVOZ68kkSLhJYZXiWPZQ3OVO
	 BNpq3L569UQNMmfazeVzdgJRnFRG4B/hL413neL2QwO2cM7MtT8h8pTLx2Zay/dotV
	 l0PQ6sf1MsI2tQK5VDVw7rw1a4fv7XXBpd0T45PtNAXSNW2PMLkwjw/c08gEWM0G6W
	 gJsGsHl3Nu/e9G0kJySvK74o1Hdjq2QIWCwF61mZhAGik0s39MXuACSEs7Wj2DIkNB
	 JC4LGRmwWYm7g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60275C5DF7D;
	Fri, 21 Aug 2026 17:50:09 +0000 (UTC)
From: FAN YE via B4 Relay <devnull+fy15309206903.gmail.com@kernel.org>
Date: Fri, 21 Aug 2026 17:50:09 +0000
Subject: [PATCH] btrfs: zstd: fix lost wakeup when waiting for a workspace
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-btrfs-zstd-lost-wakeup-v1-1-84f358d4ea67@gmail.com>
X-B4-Tracking: v=1; b=H4sIANCPiGoC/yXMQQ6CMBBG4auQWTNJaaJpvIphQelfGTRAOgWNh
 Ltbdfkt3ttJkQRKl2qnhE1U5qmgqSvqh266gSUUkzX2bJxt2OcUld+aAz9mzfzs7lgXNt4AziG
 cbKQSLwlRXr/xtf1bVz+iz98bHccHfodvq3oAAAA=
X-Change-ID: 20260821-btrfs-zstd-lost-wakeup-0b0ee88ed52f
To: Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>, 
 Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787334608; l=2450;
 i=fy15309206903@gmail.com; s=tbnet3; h=from:subject:message-id;
 bh=xjp6D6qYqD4sH3kdwjEXE5HNqQTOU/ZER6nYWo6V4fQ=;
 b=oTTEQiFrnwMvoXn6fNy305piYFD2kAgBKEWI3a4LR68vmuRFhjQ3gPNrWLMMFB9ruLR1wrtcj
 ocnfgNU0kM1DLvZJQR3U4RfhCOpo5fw/Qa3rc1mt5LtUDt8uwhljYhs
X-Developer-Key: i=fy15309206903@gmail.com; a=ed25519;
 pk=6QsQIrI/kruYWIJyCH9ntPMXsHCqF5JtK/DCMtOCzdc=
X-Endpoint-Received: by B4 Relay for fy15309206903@gmail.com/tbnet3 with
 auth_id=929
X-Original-From: FAN YE <fy15309206903@gmail.com>
Reply-To: fy15309206903@gmail.com

From: FAN YE <fy15309206903@gmail.com>

A writer can sleep forever in zstd_get_workspace() even though a workspace
is free.  When zstd_alloc_workspace() fails, the task is queued on
zwsm->wait and schedules unconditionally, never re-testing the pool.
zstd_put_workspace() publishes the workspace and then calls cond_wake_up(),
which only wakes when a sleeper is already visible, so a workspace returned
between the failed allocation and prepare_to_wait() wakes nobody.  The
window is wide: zstd_alloc_workspace() goes through kvmalloc() and may
enter reclaim.

Only a max level workspace triggers the wakeup and one is deliberately kept
allocated as the fallback every waiter waits for, so once its wakeup is
lost the writer stays in TASK_UNINTERRUPTIBLE until some other task happens
to return one.  Re-check the pool after prepare_to_wait() has published the
waiter, and use the workspace if one turned up.

Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
Assisted-by: Claude:claude-opus-5
Signed-off-by: FAN YE <fy15309206903@gmail.com>
---
Reproduced under QEMU/TCG: CONFIG_FAULT_INJECTION_STACKTRACE_FILTER forces
zstd_alloc_workspace() to fail exactly once and widens the pre-wait window
to 400ms while six concurrent zstd:15 writers race it. Unpatched, a
btrfs-delalloc kworker hangs in zstd_get_workspace()'s schedule() (hung_task
warning, >120s); the identical race against the patched code does not hang.
Compile-tested (W=1, x86_64 defconfig + CONFIG_BTRFS_FS=y).
---
 fs/btrfs/zstd.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 86919293fd54..cb15cbd737c4 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -307,8 +307,17 @@ struct list_head *zstd_get_workspace(struct btrfs_fs_info *fs_info, int level)
 		DEFINE_WAIT(wait);
 
 		prepare_to_wait(&zwsm->wait, &wait, TASK_UNINTERRUPTIBLE);
-		schedule();
+		/*
+		 * Re-check after being queued: zstd_put_workspace() only
+		 * wakes a queue that already has a sleeper, so a workspace
+		 * returned since the failed allocation woke nobody.
+		 */
+		ws = zstd_find_workspace(fs_info, level);
+		if (!ws)
+			schedule();
 		finish_wait(&zwsm->wait, &wait);
+		if (ws)
+			return ws;
 
 		goto again;
 	}

---
base-commit: 531ed942bb0df04f6747983fecdedce76a22d07f
change-id: 20260821-btrfs-zstd-lost-wakeup-0b0ee88ed52f

Best regards,
--  
FAN YE <fy15309206903@gmail.com>


