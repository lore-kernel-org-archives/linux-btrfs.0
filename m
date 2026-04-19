Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206C137CD2A
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 14:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776608799; cv=none; b=JCW/GlHofb5cf4u+Rv4C6ijLcvVNPRqaUDAJ7yWF9MledCH1pAdhU8U5fufu5dXgXEH2R4L74LTSrobvGmP622dd2Xlzx3oHyIUigGwJs17q2GYVoFfjQzyafOWI/HtMgy46AE20npcPm1yXedrmSjB6ULHEYSuzFuGI/Q6VAx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776608799; c=relaxed/simple;
	bh=8Hcg3fjVVav47paj7eQGHejRWNZI2nhETcx6+NywmmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZu7BfzDk6wCIqNsYrG3+EZ9ftexVzSrqkIONjhmep+akIgjCp7dSFM4YmDCFAeE0mT6AKtk89lQCkib1UZfze5sl534h5KAQYPVkFA8/YMvHofoDxsj/6ucYhbnsomWi1OweVN+Eo/Ap1KsBtaSVtOAh4/xA36EFt/jzeS4UGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DjlH38nC; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DjlH38nC"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so310624066b.2
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 07:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776608796; x=1777213596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9hmmiv4ynZsr7EZBLN7VCl2WNnYk6G1Flmw/228upGE=;
        b=DjlH38nCzuiTkuWEgDuyeOn4gxtlR/783DFXmSd442bj9tJt+vfCCqGU7vmNo6+2mq
         dxbmxQinGnivDAtN/U30MHDYQAZhW0fR6Rn+V8DsWauoDE3mSW9zE0I++59QFG/tGJMp
         cS+a9+jvuO9W1Ocm8oVmbVsub2zCOBT6cOsAyH3qJ9y8amkaH3hyvJWMGeVjJikSK6yS
         N2zH9kt+bpNikfreHeN+jILUf7jPZ14ub5L6rDAyT8QI6aaycx31WXCGBYToDZ0lK8N5
         mpxWRBtrNlpmBXjEPOM104RVg05CelBOqfkhwee1F8BVDqHq2r8HDyCr+2gsBxXUjKSq
         qvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776608796; x=1777213596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9hmmiv4ynZsr7EZBLN7VCl2WNnYk6G1Flmw/228upGE=;
        b=hEOs7HGGwSrES+D5/GqNWO82se8/nOOvUQzfry1Dxr1odzE+i0myGeDggImuZPZU7x
         SjXUTXa2799FS9W8PMgwkp4CcfMZaowLLARr3cxrz823kQik9WIr8IPVOvklDqpXKFu3
         DMvnex/9tZ8NiCWYAyeq3oVoX5gt7Eig798YqU1uNPIcZpd/JbQ+GxSC+NY+99FWLY9M
         Q9rJZ3d9sWGTeEM5gO3U97xD2DwrSh2Cl7mLo0Tz+9dmqW1HZDz73DV3cfqoIb2D03dx
         /nnCeljcVkuKkVO6zp1BKRHmgtmWOkUGHpuRYJ4aXZWc7fY71KEZlNp2BcQR6FEuX7mD
         f6GQ==
X-Gm-Message-State: AOJu0YwdZdO9zkcLNRJHF6GHqRtZ8X+Tf43qSNSMaaHGNadM7Iycshx0
	MKYRYr1lutLxNA5JCYoUaOrPYwDIy5IgzjxV+G0qgCsrWJDRiyPEOIgID284oQ==
X-Gm-Gg: AeBDiet+XRnV6wTdb1v+0QV+x1Ntx2tA/MiGmGkVqA1MC72gvDtFTKVw/MbvlO1DtmK
	tw8Aaxh6JPBx6NU2gdp5JFWy8NtGa9porkcw61NIAr5fc+i5jshcd6ez+xkq9oGnLBcUwYaloBT
	ww5MKkOhhFnFz14A3GgJ6QBGbnxZSmdKCR1EMnoxaxV5e4GyABZl04cJpAa6cM37OqWE/GIXB8f
	nJgGQ4WE++k7UxwJFHynCu3hjRiNrhsIlc70NdwXOROz18Y2TevhM7miNmPxp9NY1PEl3v3m++C
	xyhdYRRtBnI/hPDh36TpMxac2LJubFFSYmZc35VKsFoIB+DSaKTzc3GlPP7TWYumNl+y/66TrBC
	dlEdICdrb0dlsJzERoOAk7Kf3QaCJetRxLbl4x1SFOZbxQJT3s/0lcR9rlxWDpPago4DPLF/w09
	owHju4UMRdkiPAPF/tWhCdRt+A5gYt8kOzfsd4n6EtakS8Yj66zXg=
X-Received: by 2002:a17:906:f59c:b0:b98:2df5:9bf0 with SMTP id a640c23a62f3a-ba4196566d7mr412764966b.22.1776608796325;
        Sun, 19 Apr 2026 07:26:36 -0700 (PDT)
Received: from TE-laptop.internal ([2a01:799:3a1:9700:10f5:c193:4430:919e])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ba455046223sm258232666b.49.2026.04.19.07.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 07:26:35 -0700 (PDT)
From: Torstein Eide <torsteine@gmail.com>
X-Google-Original-From: Torstein Eide <torsteine+linux@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Torstein Eide <torsteine@gmail.com>
Subject: [PATCH 4/5] btrfs: hook scrub session tracking into btrfs_scrub_dev()
Date: Sun, 19 Apr 2026 16:26:16 +0200
Message-ID: <20260419142618.3147763-5-torsteine+linux@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260419142618.3147763-1-torsteine+linux@gmail.com>
References: <20260419142618.3147763-1-torsteine+linux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Torstein Eide <torsteine@gmail.com>

At the start of a scrub (excluding device replace runs):
  - zero all per-device scrub_session_values[] counters
  - set scrub_session_last_physical to the start offset
  - record scrub_session_t_start (wall-clock seconds)
  - set scrub_session_status to BTRFS_SCRUB_STATUS_RUNNING

At the end of a scrub, call btrfs_update_scrub_stats() which copies
the final btrfs_scrub_progress counters into the session and lifetime
arrays, stamps t_end, and sets the status to FINISHED or CANCELED
depending on the return value.

Device replace runs are excluded because their progress is tracked
separately and their statistics should not pollute the device's own
scrub history.

Signed-off-by: Torstein Eide <torsteine@gmail.com>
Assisted-by: Claude:claude-sonnet-4-6
---
 fs/btrfs/scrub.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 1ac609239cbe3..a3bf3276f5f44 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -6,6 +6,7 @@
 #include <linux/blkdev.h>
 #include <linux/ratelimit.h>
 #include <linux/sched/mm.h>
+#include <linux/timekeeping.h>
 #include "ctree.h"
 #include "discard.h"
 #include "volumes.h"
@@ -3152,6 +3153,18 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	dev->scrub_ctx = sctx;
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
+	if (!is_dev_replace) {
+		int i;
+
+		/* Reset session counters for this new scrub run */
+		for (i = 0; i < BTRFS_SCRUB_STAT_VALUES_MAX; i++)
+			atomic64_set(&dev->scrub_session_values[i], 0);
+		dev->scrub_session_last_physical = start;
+		dev->scrub_session_t_start = ktime_get_real_seconds();
+		dev->scrub_session_t_end = 0;
+		atomic_set(&dev->scrub_session_status, BTRFS_SCRUB_STATUS_RUNNING);
+	}
+
 	/*
 	 * checking @scrub_pause_req here, we can avoid
 	 * race between committing transaction and scrubbing.
@@ -3207,6 +3220,9 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	if (progress)
 		memcpy(progress, &sctx->stat, sizeof(*progress));
 
+	if (!is_dev_replace)
+		btrfs_update_scrub_stats(dev, &sctx->stat, ret);
+
 	if (!is_dev_replace)
 		btrfs_info(fs_info, "scrub: %s on devid %llu with status: %d",
 			ret ? "not finished" : "finished", devid, ret);
-- 
2.48.1

