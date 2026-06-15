Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A4F3E5EF1;
	Mon, 15 Jun 2026 13:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529502; cv=none; b=GyPAUbWjMUvdUXkKKuGpuT7DjvngBOVMPqDQjcCyFtaiAf2S3BeVuZFEKr3tlPvpJx7YYF1JSZumpzvK53HtBkWTgu0hFIrbShE2Vk/KOV8z7qMAomfAh5MnS14C5UpRfgIlMgcORH8w4uOw4F4S3guIf9B1hnVnPK1HYYKFuXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529502; c=relaxed/simple;
	bh=/DrPb6bX2UuyLGwe4T7Av3UUK+9G9bPpfxlYExHjrcI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gmxPbxnjtHLIlm8l+DrA45ZdTvqC/P8Z9hD2g0XT6YjFIdkZROxPs8z+8mWDsErsDWX1VWE65nI2U1tuJ6847QabWghV8wGTgZ/tn4JwvBh1W9EQJ/dZ0sAOfkyG4q07c+eVXS3Vo0xmX1tCnUkbjj62XugX5E+6oc+p3tyz+TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CDpQAuY9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CDpQAuY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E7C1F00A3A;
	Mon, 15 Jun 2026 13:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529501;
	bh=Cn9vOUxJZ9a3ZjrwSO+tGKlFgoYwR1eCxr1/HB4GCgQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CDpQAuY9kpw/sfIhZH2YRRl+wmvygiRPx24oHJtjU7Ho888Ouo7aFONRIFJUoPunH
	 hiRMoh8JkRnM1AJc9ZLwCbE/cRh7BtUPc8z/nOrcniJmkmr0vXvj42tVS0Ch/F7kpN
	 jyLOZwBWUAI8U0YHqf17/yviUy+Hm+GWsQHEFPUNmu3hobfnqmRzUZiYVDAep77xF/
	 GlQV9fMuqbF7Ak4jz2MuwtXyu8aPYph1nMohPNCmJe6623A8eHWb3j7r5G4KkCuO18
	 d1DQHQpkETtlUezqTRifJgBzYScpqLSxTByVINe4tglNtnef251CjEHrpk4T/tx2qM
	 For9FzFLPI3MQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:18:04 +0200
Subject: [PATCH RFC 1/6] btrfs: destroy the target device when
 mark_block_group_to_copy() fails
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-super-freeze_deny_upstream-v1-1-a6c72b840e7d@kernel.org>
References: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
In-Reply-To: <20260615-work-super-freeze_deny_upstream-v1-0-a6c72b840e7d@kernel.org>
To: Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, 
 David Sterba <dsterba@suse.com>, Jan Kara <jack@suse.cz>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
 linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=1247; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/DrPb6bX2UuyLGwe4T7Av3UUK+9G9bPpfxlYExHjrcI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/56ekq9v8z/ps0jNqtr69i3LLty77Jn8uNKGQ9J7T
 a7cscx5HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABORiGdkeHPll/Zko68Llgv+
 XHHlloda1HYTrwtfkt6InNWWl3Lpfc3IsHQac9bUkxO/vNBsaGqcX8v6WP9+5MK1qz3U/sumlIa
 f4gEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

btrfs_dev_replace_start() opens the replacement target with
btrfs_init_dev_replace_tgtdev(), which adds it to the device list and opens
its block device.  Every error path after that point reaches the 'leave'
label to tear the target back down with btrfs_destroy_dev_replace_tgtdev() -
except the mark_block_group_to_copy() failure, which returns directly.  The
target is then leaked: it stays on the device list with its block device
held until the filesystem is unmounted.

Goto leave like the other post-open error paths so the target is destroyed.

Fixes: 78ce9fc269af ("btrfs: zoned: mark block groups to copy for device-replace")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/dev-replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 8f8fa14886de..0112aa6d7ab1 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -624,7 +624,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 
 	ret = mark_block_group_to_copy(fs_info, src_device);
 	if (ret)
-		return ret;
+		goto leave;
 
 	down_write(&dev_replace->rwsem);
 	dev_replace->replace_task = current;

-- 
2.47.3

