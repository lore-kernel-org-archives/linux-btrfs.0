Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B953A9871;
	Sat, 22 Aug 2026 14:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787409865; cv=none; b=OBHQDoCWqdzuMEXZv1m7AkuaegVE1k30hK/Ob5BhQUSDF+EOWxM9JSI3QMJgampZa+IPI0LghZULXQw/RkNbMT/Un4QVrvBWaWp+F8ISaSSGUCTKoaS/omz5iEiXTte6i4fBAMpwqAJaeNW6nBkoG7vn4zwCRV5txRO6hgNTM9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787409865; c=relaxed/simple;
	bh=BxLYWRy3/Q2ABjND7TcdSXTnzv3SdSgv/uu22EyunEE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=mU3qbBRYu5ghz83Bl/KGtF3Q5U4ozJsK8evablNTrPqJ/wlEJYCF5NJ057cRpY9VRs3WwrSnahPloBUFCvvOwxS/n2WchJmPwzK8shwT8DSFgmp4UHsAiyBzO5g9bf5WAwhUNYvUG4+CfyEkrNC4EYuYCaubsW7qbaB3G2snPh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kWvaO3E7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kWvaO3E7"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCBE3C2BCF6;
	Sat, 22 Aug 2026 14:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787409864;
	bh=BxLYWRy3/Q2ABjND7TcdSXTnzv3SdSgv/uu22EyunEE=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=kWvaO3E7VGi7rXKRvN9KifCLFbEMkHZipx8sX4lmmmFOpajAuB8BdUBQkRoBmatDs
	 lJSTWoBpag7Db+hRW/TTxuV2GUjHamvH3qgCgDH9YnIBW85OorjoqTGk83lbW6wItu
	 JzGLRLoVpMHErICRwOqhTq3cqrdAeFhNOIcfYiAsjrAwGqQxmKWBlMQDthSCCxwHyw
	 JMouyuQ9VvIkVZLl/AOT+AVdQfAeXTzfxtFly1OFXrexOalch8NdGoxpBcR1/mffnF
	 TPLyvfGgr8ZGrsDADSBdOLwTc8FOlao/j94gIMtT0ZhIvdgAv730i42hHPFQLBizpj
	 jBPZWXL8cfLPQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6336C5B572;
	Sat, 22 Aug 2026 14:44:24 +0000 (UTC)
From: FAN YE via B4 Relay <devnull+fy15309206903.gmail.com@kernel.org>
Date: Sat, 22 Aug 2026 14:44:24 +0000
Subject: [PATCH] btrfs: dev-replace: fix missing barrier before waking bio
 counter waiters
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260822-btrfs-dev-replace-bio-counter-barrier-v1-1-e718ae7d25e5@gmail.com>
X-B4-Tracking: v=1; b=H4sIAMe1iWoC/yXNQQrCMBBG4auUWTuQxqrFq4iLJP2rI5KUSVqE0
 rub6vJtvrdShgoyXZuVFItkSbFGe2goPF18gGWoTdbYs+mtZV90zDxgYcX0dgHsJXFIcyxQ9k4
 rp9w5a+CPp7a/OKrWpBjl8/vc7v/Os38hlB2nbfsCHhFJZokAAAA=
X-Change-ID: 20260822-btrfs-dev-replace-bio-counter-barrier-4a20eb35187a
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787409863; l=2519;
 i=fy15309206903@gmail.com; s=tbnet3; h=from:subject:message-id;
 bh=MZdHDlm2NoubleaR5CcL9kU8Zazoy0BZ4w/oT8hYfK4=;
 b=TYHwrSYqdvBqnyDqX8JTn+QTV8E8AUhK13T1o30O7XM/D5iMY5bgWiWkRW/gme8KV8Tgs/oBj
 XNps9AtG5l+AK42Jou2+EsVFzhuI0vYWcdj/u575/CbyDfgCrN5JgbT
X-Developer-Key: i=fy15309206903@gmail.com; a=ed25519;
 pk=6QsQIrI/kruYWIJyCH9ntPMXsHCqF5JtK/DCMtOCzdc=
X-Endpoint-Received: by B4 Relay for fy15309206903@gmail.com/tbnet3 with
 auth_id=929
X-Original-From: FAN YE <fy15309206903@gmail.com>
Reply-To: fy15309206903@gmail.com

From: FAN YE <fy15309206903@gmail.com>

btrfs_bio_counter_sub() gates the wakeup on cond_wake_up_nomb(), whose
bare waitqueue_active() requires a full barrier from the preceding code.
percpu_counter_sub() does not provide one, its fast path is a plain
per-cpu update, so the waitqueue_active() load can be hoisted over the
counter update.  btrfs_rm_dev_replace_blocked() waits for
percpu_counter_sum() to reach zero and can then be left sleeping by the
very decrement that reaches it.  It stays asleep until some unrelated
later decrement wakes it, with BTRFS_FS_STATE_DEV_REPLACING set the whole
time, so every bio submitter on the filesystem blocks as well.
Use cond_wake_up(), which has the barrier.

Fixes: 4245215d6a8d ("Btrfs, raid56: fix use-after-free problem in the final device replace procedure on raid56")
Assisted-by: Claude:claude-opus-5
Signed-off-by: FAN YE <fy15309206903@gmail.com>
---
Two independent checks.  A litmus test of the same shape: herd7 with the LKMM
allows the interleaving and forbids it with smp_mb(); built with klitmus7 it
hits 349326 times in 64000000 iterations on x86_64, 0 times with the barrier.
With that interleaving staged in the dev-replace path in a VM (the last
in-flight bio released while the finishing waiter is queueing), the wakeup is
lost in 3/3 runs and the filesystem stalls for 24.5s until an unrelated
decrement arrives, 0/3 with this patch.  Gating the barrier on
BTRFS_FS_STATE_DEV_REPLACING to keep it off the common path does not work:
that test_bit() is unordered as well, and hoisting it over the decrement drops
the wakeup in 3/3 runs.  Compile-tested (W=1, x86_64 defconfig +
CONFIG_BTRFS_FS=y).
---
 fs/btrfs/dev-replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index dc0834f920c3..b2791480e263 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -1353,7 +1353,7 @@ bool __pure btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace)
 void btrfs_bio_counter_sub(struct btrfs_fs_info *fs_info, s64 amount)
 {
 	percpu_counter_sub(&fs_info->dev_replace.bio_counter, amount);
-	cond_wake_up_nomb(&fs_info->dev_replace.replace_wait);
+	cond_wake_up(&fs_info->dev_replace.replace_wait);
 }
 
 void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)

---
base-commit: 26260251022fbc2f248a3d747a9b2b961b18d2d8
change-id: 20260822-btrfs-dev-replace-bio-counter-barrier-4a20eb35187a

Best regards,
--  
FAN YE <fy15309206903@gmail.com>


