Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A312F5A2D;
	Sat, 22 Aug 2026 12:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787402714; cv=none; b=Dv/1Z6w+rL88l5YqGoRj4DeMGOBP3IFb+rBY8dfgB7agLe2ioc5vygBtYERx7xlqELsJvcJLXYEZSmmGjnzvMzHEwHeB0scPeGd1W8AeEgwW5zLlh/1YRSruhpjFSAO3adrnEB98M7PN/Pp6QZ56XzrbD0FeWMcXY6IZDmAWEFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787402714; c=relaxed/simple;
	bh=yzvRjsKxR90qxnWCa8PHtFhp1fCvLrSglV2J1yJyrZ4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Tb+eFrbd80y6iBkEn/ovAyXXcNZml7tcC3408nwDi174+XOcVvc2V+NPxMstn1Qjb0eEPqEQBopTdMEb8Y17HQKCjcQfzmEHeae6xF5au7H2Xjhq4qS9KEZAh4ay84vktZyxKQR7WnXZlqc5Huo4UwJ9/dco87LvuV6g54bKXBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WSxM5X/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSxM5X/h"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 925D9C2BCF6;
	Sat, 22 Aug 2026 12:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787402713;
	bh=yzvRjsKxR90qxnWCa8PHtFhp1fCvLrSglV2J1yJyrZ4=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=WSxM5X/hkVhHewgapI2+g3Fjd4sPR1n7FE6UTLs1ePnYUwAoFZO8+9iowtbCk3NPz
	 de1VXovXhejX0d3GUrM7qRxAFxycUJwt2VYsFqLDH3mUHAX1kjMyunDtomvBAf7XLK
	 RNLnjTIUglYaV1y12vH8eovPc8iW3DlreoQ4DX9gSt4wPDdS3e4gQpmeRQMEWrBsJB
	 a8iC6aB6nyeKNUyrYI6+dBNCcwpnkmxQR7RZiW4PZNRcKLTuwwegKQIO8gJTpmd6GA
	 9ugKyB8Nn8zlFAgFd9aRTjoTyRP9GDbk9pvnkM4esEDOKOYAbXxddSg9m5rZWmffSO
	 Dd2ADGH3Q2b5Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7756DC5DF8C;
	Sat, 22 Aug 2026 12:45:13 +0000 (UTC)
From: FAN YE via B4 Relay <devnull+fy15309206903.gmail.com@kernel.org>
Date: Sat, 22 Aug 2026 12:45:13 +0000
Subject: [PATCH] btrfs: zstd: keep the last max level workspace out of
 reclaim
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260822-btrfs-zstd-max-level-reclaim-v1-1-0eb13c127480@gmail.com>
X-B4-Tracking: v=1; b=H4sIANiZiWoC/yXMwQ6CMAwA0F8hPdsEZlD0VwyHbnRaM9C0kxAJ/
 +7U47u8FYxV2OBcraA8i8ljKmh2FYQbTVdGGYrB1e5Qd86hzxoN35YHHGnBxDMnVA6JZMSWfHu
 iYxO7PUMpnspRll9/6f+2l79zyN8Ttu0DoSZbzYAAAAA=
X-Change-ID: 20260822-btrfs-zstd-max-level-reclaim-5ab59a71f83e
To: David Sterba <dsterba@suse.com>, Nick Terrell <terrelln@fb.com>, 
 Chris Mason <clm@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787402712; l=4571;
 i=fy15309206903@gmail.com; s=tbnet3; h=from:subject:message-id;
 bh=OtLQ/8I9vVwdtLcOdjYllHgpwfHXTt1umssx95LsQ5I=;
 b=hvDFP+R94dxoHaf3IoWxwvL9AeZaYtUCWHx4GpEe2Xy6GP97zgTjY5NRkQzQV10amzSG4A8ka
 CRDy6eIl4MxAPti7K9F08ZdZYk0rz+UqvtmEh7lc2YVgiiKkP5z/z+w
X-Developer-Key: i=fy15309206903@gmail.com; a=ed25519;
 pk=6QsQIrI/kruYWIJyCH9ntPMXsHCqF5JtK/DCMtOCzdc=
X-Endpoint-Received: by B4 Relay for fy15309206903@gmail.com/tbnet3 with
 auth_id=929
X-Original-From: FAN YE <fy15309206903@gmail.com>
Reply-To: fy15309206903@gmail.com

From: FAN YE <fy15309206903@gmail.com>

zstd_put_workspace() makes the "hide this workspace from the reclaim timer"
decision only when the workspace is returned at its own level.
Decompression always asks for level 0, so a max level workspace borrowed by
a read skips the whole block and the test for being the last max level
workspace is never made: it goes back to idle_ws[] still linked on the lru.
A read borrowing one while a write holds the other is enough to leave every
max level workspace on the lru, where the reclaim timer can then free them
all and clear the level bit.

Once no max level workspace is left, zstd_put_workspace() never reaches
cond_wake_up() and a task sleeping in zstd_get_workspace() after a failed
allocation has no possible waker.  Make the decision on every put of a max
level workspace and unlink it from the lru when it is the last one;
list_del_init() in zstd_find_workspace() keeps the entry usable for that.
The test also no longer hides workspaces of other levels, which it did
whenever no max level workspace happened to be idle.

Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
Assisted-by: Claude:claude-opus-5
Signed-off-by: FAN YE <fy15309206903@gmail.com>
---
Reproduced under QEMU/TCG.  Both arms are the same kernel with the reclaim
interval shortened to 100ms and a module param picking the old or the new
zstd_put_workspace(); the workload is compress-force=zstd:15, three rounds
of four concurrent writers followed by drop_caches, four readers and two
writers.  "unprotected" counts puts of a max level workspace after which
nothing left in idle_ws[] is off the lru; "borrowed" counts a max level
workspace taken and returned by a lower level request, the path this patch
changes.

                    borrowed   unprotected   timer cleared the level bit
  current code       245/339       118/216                          1/0
  this patch         300/379           0/0                          0/0

borrowed is of the same order in both arms, so the zeroes are not "the code
was never reached".  The last column needs the reclaim timer to tick inside
the window, so it is a coincidence rather than the criterion.

Compile-tested (W=1, x86_64 defconfig + CONFIG_BTRFS_FS=y).  Independent of
and applies without my lost wakeup fix for zstd_get_workspace(),
20260821-btrfs-zstd-lost-wakeup-v1-1-84f358d4ea67@gmail.com.
---
 fs/btrfs/zstd.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 86919293fd54..8abc4e456f32 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -260,7 +260,7 @@ static struct list_head *zstd_find_workspace(struct btrfs_fs_info *fs_info, int
 			/* keep its place if it's a lower level using this */
 			workspace->req_level = level;
 			if (clip_level(level) == workspace->level)
-				list_del(&workspace->lru_list);
+				list_del_init(&workspace->lru_list);
 			if (list_empty(&zwsm->idle_ws[i]))
 				clear_bit(i, &zwsm->active_map);
 			spin_unlock_bh(&zwsm->lock);
@@ -335,18 +335,17 @@ void zstd_put_workspace(struct btrfs_fs_info *fs_info, struct list_head *ws)
 	ASSERT(zwsm);
 	spin_lock_bh(&zwsm->lock);
 
-	/* A node is only taken off the lru if we are the corresponding level */
-	if (clip_level(workspace->req_level) == workspace->level) {
-		/* Hide a max level workspace from reclaim */
-		if (list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
-			INIT_LIST_HEAD(&workspace->lru_list);
-		} else {
-			workspace->last_used = jiffies;
-			list_add(&workspace->lru_list, &zwsm->lru_list);
-			if (!timer_pending(&zwsm->timer))
-				mod_timer(&zwsm->timer,
-					  jiffies + ZSTD_BTRFS_RECLAIM_JIFFIES);
-		}
+	/* Forward progress depends on always keeping one max level workspace */
+	if (workspace->level == clip_level(ZSTD_BTRFS_MAX_LEVEL) &&
+	    list_empty(&zwsm->idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
+		list_del_init(&workspace->lru_list);
+	} else if (clip_level(workspace->req_level) == workspace->level) {
+		/* A node is only taken off the lru if we are the corresponding level */
+		workspace->last_used = jiffies;
+		list_add(&workspace->lru_list, &zwsm->lru_list);
+		if (!timer_pending(&zwsm->timer))
+			mod_timer(&zwsm->timer,
+				  jiffies + ZSTD_BTRFS_RECLAIM_JIFFIES);
 	}
 
 	set_bit(workspace->level, &zwsm->active_map);

---
base-commit: 26260251022fbc2f248a3d747a9b2b961b18d2d8
change-id: 20260822-btrfs-zstd-max-level-reclaim-5ab59a71f83e

Best regards,
--  
FAN YE <fy15309206903@gmail.com>


