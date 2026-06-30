Received: from mail-yx1-f67.google.com (mail-yx1-f67.google.com [74.125.224.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD4D367F4D
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 19:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782849491; cv=none; b=Brr/FBJdioEL+c9u4oTysl98BiNLclT1Rgrp9+JwkzqAW5pRrM884zLB6qBW8bSRAg8E7/PDJIEksHz2tDx+rRxlL4PNlSk3/TPZBCsdK3z2xr1Fc6a0pXErC7Md4G4ITdcfaU/XTz19urPWPg7di1cUPyN1Tfie7Qh8Wp/e5JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782849491; c=relaxed/simple;
	bh=Cqf+fYgaW5FZ/wbNzA1vTJdiF/p7IWUp/b76k+UJ0IM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G/KK7BCykOcy/snUfHOHOPdj443PRbWqnxskMtsxAf+7NTkgs4HfAa0KbQKNndGfaXLcxC5gr0HskA/17X+Rwqk6pfy1FwClKMniUvY6njlv2Y85qAuNBaZfL90WYb0yH7XNiFljZRlvoE2Xa/hKVkCW/lXGl7nQTKWIqIgcbk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mSpPyFoV; arc=none smtp.client-ip=74.125.224.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSpPyFoV"
Received: by mail-yx1-f67.google.com with SMTP id 956f58d0204a3-664eb8cb631so2336659d50.3
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 12:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782849489; x=1783454289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Iij4IQddMHH7Jghh1X3cKV/SlufmHXvI7snr2dEsADo=;
        b=mSpPyFoV/ztdm3+j+JZYK5z+P/17CvG4Zzd4dM4lJQyitv8ofjImlWgLJpFgxO1eRR
         aq03wbgc38/TXNy2flXGRx9VPV2XFUDl8eX/PBosGLFtm4iQYxHy4kXqtfrEJF0YRkKj
         xC3/qI2low81E0Zns/nJR9URoNRssV0c3ib01GnFAsRfQcK22QRh3fZF5niqq6Rqam2B
         N1/ZwjlWiBFlWYdSgiejdl8wZvWkGPgSqYqZbCdgXrSSHdbRAo3RuHPDVaSdGHLughUb
         Sp5sGCCHz9kT/7k6axR/ftVret7T8xj4FoxhKNcAa3w2dKBQdxAyeWwOKlqevZAox0/H
         PdbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782849489; x=1783454289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iij4IQddMHH7Jghh1X3cKV/SlufmHXvI7snr2dEsADo=;
        b=Ur/a8areZJlF1knwhngyWkmErLJCD0Cy2reuq1zi4hOLpl1xJaW01oSJoLNodz+cVG
         fiN5sbFxqowbKGothNdSNv/bBYHD6sRXjj5ab5CcP+zggldAleTPGocYOl4f6cWtpL6v
         sf+O9gEJcapbyZqEnfZx9JpmXUgw+qpX8Ni+DU72k6b6qGMfOqsc471ohk0qKPtJe6w7
         BpIk4On01bNGoOijH9tD50ymcOo9LI6swvQHwyX2OL5LH3fbsiDEQDjk3HlBY+TNjJs/
         OQDmo7AilafSf9Tu2HFGyzMq8rDlwGvNYjGDE0Uc84y2dCg59LxJjDqGW3dtSEmYXsuf
         2yrQ==
X-Gm-Message-State: AOJu0YwOOEozTiMBDc3QHPs7R8Cd8jBnWVt01oUNcKj4OexLBdbfsz33
	y0NLdNabAtMzLoB58FMcL9AxLH4Rcvn9z4AUsCYpR2BCVv9gzcUV3jvOgcwMcUNM
X-Gm-Gg: AfdE7cmaEpRAkrxbsFJm5LC/jyhPQEjOhKsaNc8Q9aP5TweZUBvHq+DnFhHe8dp4W1k
	QRe7/WsmHc6iWfia+UOTorkrw4wj6Kb3+5Q4QS0Bm3+7DlbxISz8yJrazZD7OXYZpr7PsaQPk0M
	fgMOvAWefrq5PtYeUdSIl/K62K4jdlvl2d0JXpQLycd4HSSyJcnu0SGhdiBXNtUcV5cEUSMIWST
	nD6p9kWfAYu01YZ1yeF3a/iHiyEQzchzqt8nUgPM5EqjqEXYy3QESDHs5pD+FEggaNPidIXC3p6
	1vIz1AEi+CTIXRvL/zIGo91Ba01qDPvhushqbuNXq1+5KuVu9TQhT2XgEdAluTvRkd+HM/a42pj
	+IxuSlb7R5bylxSOpHUJJ4a2fLfFcW4zyi4ugsT0FTS+K/OGNcnAsQXwqr/W6seDseBBj70rlnd
	QWL2eJer9QPsiT7YLd
X-Received: by 2002:a53:cc03:0:b0:664:f523:30d4 with SMTP id 956f58d0204a3-664f98cb391mr3795605d50.50.1782849489412;
        Tue, 30 Jun 2026 12:58:09 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:8::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-665014bbd31sm1315397d50.10.2026.06.30.12.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 12:58:09 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Jeff Layton <jlayton@kernel.org>,
	Boris Burkov <boris@bur.io>
Subject: [PATCH] btrfs: don't propagate EXTENT_FLAG_LOGGING to split extent maps
Date: Tue, 30 Jun 2026 12:58:05 -0700
Message-ID: <77d71e99f792c80c4841b33ed07530543dca897a.1782849374.git.loemra.dev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When btrfs_drop_extent_map_range() splits an extent map, the new split
maps inherit the original map's flags through a local 'flags' variable.
Commit f86f7a75e2fb ("btrfs: use the flags of an extent map to identify
the compression type") changed the EXTENT_FLAG_LOGGING clearing to
operate on em->flags instead of that local 'flags' copy, so a split of
an extent map that is currently being logged wrongly inherits
EXTENT_FLAG_LOGGING.

The flag is then never cleared on the split, and when it is freed while
still on the inode's modified_extents list (for example by the extent
map shrinker) it trips the WARN_ON(!list_empty(&em->list)) in
btrfs_free_extent_map() and leads to a use-after-free.

Clear EXTENT_FLAG_LOGGING from the local 'flags' copy used for the
splits and only clear EXTENT_FLAG_PINNED from em->flags, restoring the
behaviour prior to f86f7a75e2fb.

Fixes: f86f7a75e2fb ("btrfs: use the flags of an extent map to identify the compression type")
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Boris Burkov <boris@bur.io>
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
---
 fs/btrfs/extent_map.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index fce9c5cc0122..6ad7b39ae358 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -866,13 +866,13 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 			goto next;
 		}
 
-		flags = em->flags;
 		/*
 		 * In case we split the extent map, we want to preserve the
 		 * EXTENT_FLAG_LOGGING flag on our extent map, but we don't want
 		 * it on the new extent maps.
 		 */
-		em->flags &= ~(EXTENT_FLAG_PINNED | EXTENT_FLAG_LOGGING);
+		flags = em->flags & ~EXTENT_FLAG_LOGGING;
+		em->flags &= ~EXTENT_FLAG_PINNED;
 		modified = !list_empty(&em->list);
 
 		/*
-- 
2.53.0-Meta

