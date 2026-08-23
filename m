Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2313385A1;
	Sun, 23 Aug 2026 09:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787477306; cv=none; b=DiwfdSr5ri0h8Y+EA8aETBHBkNTHPMNi4WdPZsumybRySN9OaFkhuD3Wh53HtsXQKj4RJhMf4014Xb1GCI87qGbV+LR5TWzhsGLLGzNA1my/o73MWFHuJKiWqsVQkZauPF/9zJyORzzvk7igCEWcwwwADyCmTsDAjd3oJJBGwSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787477306; c=relaxed/simple;
	bh=eBB0XbIGxS7zDrXsIOKH9+GaAZ0HKPKwnyAGBsLz8cE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=mCXcEQnHEm5X8GjLJgoFRP+wRZBMlMjHAfV6kfaKXQ6FGJ4qDrzzyLb58UYjVWOIkTX2n14XXDP+ng0A4Kro4yUjDgpjcSWvNd5XqAcX6DHVc5YC+IxsoZr3FY+1mofoMfmtvCjcOyOBXdhPMRbp34ImgBcIuHT68ABcMQ7eauM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uny8j8Z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uny8j8Z3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2FEADC2BCB8;
	Sun, 23 Aug 2026 09:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787477306;
	bh=eBB0XbIGxS7zDrXsIOKH9+GaAZ0HKPKwnyAGBsLz8cE=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=uny8j8Z37shodHbBMCqkPOoVcuymcrzFXiF5S4i9w1wv0cny42SWXkrau+mXwAsJZ
	 FLMXFInBNty+nYWEjLtD1t5C4b15jhZkZNOdJrzD6n/ny1sp8qNueeJ0VpNm5KoytU
	 FeCg6PV2WGsPeOUSIIn++0+5JnPkEwMM7CKiVDmQh52uxCF0AcB7FhqbylwPKg66NP
	 gud6Vfrf814AywVVweAX8pGFYnkgeG5/HqM9SUbTxmebyRWT6lnJo5TGrE47MzPKOV
	 0var0vVMS9BNHfgUHfQGs/s2BvXgBPSPqkFPKKrqNJzEMAYEiHx7+SwVGpun5rgdRM
	 Tz9zCmRk8Zt5w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077A3C5DF8C;
	Sun, 23 Aug 2026 09:28:26 +0000 (UTC)
From: FAN YE via B4 Relay <devnull+fy15309206903.gmail.com@kernel.org>
Date: Sun, 23 Aug 2026 09:28:25 +0000
Subject: [PATCH] btrfs: scrub: wake up cancel_dev waiters after clearing
 dev->scrub_ctx
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260823-btrfs-scrub-cancel-dev-wakeup-v1-1-374d618ab25f@gmail.com>
X-B4-Tracking: v=1; b=H4sIADi9imoC/yXMOw7CMAwA0KtUnrEUXFE+V0EdEteBAAqV3RSkq
 ncnwPiWt4CJJjE4NQuozMnSM1dsNw3w1eeLYBqqgRx17kAthkmjobGWgOwzywMHmfHl71JGjIH
 k2FK3jzsH9RhVYnr//nP/t5VwE56+KazrBzXfgIyBAAAA
X-Change-ID: 20260823-btrfs-scrub-cancel-dev-wakeup-fb2e93267f50
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787477305; l=2575;
 i=fy15309206903@gmail.com; s=tbnet3; h=from:subject:message-id;
 bh=xdBeUrOdCn8ylb7MLha5PMKpDHCyFGYa0B8rXagVhfI=;
 b=jLklhCiaNoRe3Z8PESXyLhw//+kfc6CWifs9QTWqXLIQs/D1boASK1id5bwbss+8S7pACduFW
 jfGTkVxSSs/CTZPF3HU7tgu0vAsQtG2kTqpVg4DhMv8heiEGZlFEprl
X-Developer-Key: i=fy15309206903@gmail.com; a=ed25519;
 pk=6QsQIrI/kruYWIJyCH9ntPMXsHCqF5JtK/DCMtOCzdc=
X-Endpoint-Received: by B4 Relay for fy15309206903@gmail.com/tbnet3 with
 auth_id=929
X-Original-From: FAN YE <fy15309206903@gmail.com>
Reply-To: fy15309206903@gmail.com

From: FAN YE <fy15309206903@gmail.com>

btrfs_scrub_cancel_dev() waits on fs_info->scrub_pause_wait for
dev->scrub_ctx to become NULL.  btrfs_scrub_dev() wakes that queue right
after dropping scrubs_running, several statements before it clears the
pointer, and never wakes it again.  The canceller is already queued by
then: it sets sctx->cancel_req before waiting, and the scrub only starts
finishing once should_cancel_scrub() observes that flag.  So the wakeup it
gets is the early one, its recheck still finds dev->scrub_ctx set, and it
goes back to sleep before the store it is waiting for.

Nothing wakes the queue after the store.  scrubs_running is already zero,
and btrfs_rm_device() reaches btrfs_scrub_cancel_dev() holding a
transaction handle, so the commit that would call btrfs_scrub_continue()
blocks behind the sleeping canceller.  Device removal, the transaction
kthread and any fsync() on the filesystem hang indefinitely.  Wake the
queue after the store as well.

Fixes: a2de733c78fa ("btrfs: scrub")
Assisted-by: Claude:claude-opus-5 sashiko
Signed-off-by: FAN YE <fy15309206903@gmail.com>
---
Reproduced on unmodified kernels in a VM: a scrub running on the device
btrfs_rm_device() removes.  Upstream hangs in all 7 attempts where the
canceller actually slept - 4 with transaction commits forced back to back,
3 at the default commit interval - and 0 of 16 with this patch.  ftrace
records no sched_wakeup at all for the blocked task after dev->scrub_ctx is
seen NULL, while btrfs-transacti and a plain BTRFS_IOC_SYNC block behind
it.  Attempts where the cancel returned -ENOTCONN, or returned 0 without
ever sleeping, are not counted either way.  Moving the existing wakeup
after the store instead of adding one also works (0 of 9) and is not
measurably cheaper; this keeps each wakeup next to the store it publishes.
Compile-tested (W=1, x86_64 defconfig + CONFIG_BTRFS_FS=y).
---
 fs/btrfs/scrub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f209e75f0ff5..43fee426fdab 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3177,6 +3177,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	mutex_lock(&fs_info->scrub_lock);
 	dev->scrub_ctx = NULL;
 	mutex_unlock(&fs_info->scrub_lock);
+	wake_up(&fs_info->scrub_pause_wait);
 
 	scrub_workers_put(fs_info);
 	scrub_put_ctx(sctx);

---
base-commit: 2709dd5ae32f0828f386327c76bba9f39f63a1c6
change-id: 20260823-btrfs-scrub-cancel-dev-wakeup-fb2e93267f50

Best regards,
--  
FAN YE <fy15309206903@gmail.com>


