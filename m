Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772DA3793D5
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 12:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780575264; cv=none; b=f+nVe+urUk7oEoYVX5FnfZRC+kyHXoJlMjXKmjki55K6gQlx/Xx6XJJaJiX0zcyAWdWyFdU+tPFk2qwu3LNRWIcRB48Wp0a1uUW/nf472T19EJSqrYwSAHj1iU2+3vZ6dX7A+ECPi0yDlqEmtHQLFtOq+exbnzJoNryOrmGeKlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780575264; c=relaxed/simple;
	bh=Bkx11sUNszdwIHhq4gBPkGpD8tN3++Eftz5dCfj0OOE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QFcNJr31JKzfHYCh1EOm+EK0HHZ98zXQsb6XzTXOzd579qCKonxRgAih7MRYCT9ukRyFhoBYABcm5XuypFpdVVouErBODaUeMHCuLwEckmdC3ecuEGoCy6xuzE/FhHkeOupEvFOqiCdxVvN7rVbtnydeJXAAvThSlgsQj86Vuvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1Qpxb+9; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1Qpxb+9"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36b95eb4bb4so394320a91.3
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2026 05:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780575263; x=1781180063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oyxRxCYOdMyc8Dc3ZoAGzmBA02Un7oBiGn+qmKX5HP8=;
        b=L1Qpxb+9sI+/c2lErmEQbMZAr6Gc3KvexxVD8sZfZe1QRshdASSV7SXL3aY8FzhNeL
         Ik8VwesFaB3F/9304OOkrofVKs5nBFDSybsRSz1EWUmcvrBt66yXHcjlGzwNACQkl1vR
         5b9iFQJCpqnMyEUmsYY4ucYgrZriuMY7Ky/UfQ6vgSr/ATICDPbQurqi7sBDuo4JnXu5
         yA6ndC6UgmXmsvCLQPVjN6JBMpN9OIp01+CWjcBtqUQFKf6vBEPu0Y4KZvrqa6FXFOEg
         Q5qraxlkiDpzUUkzS+OqKW/LnZenoLiAhGAoUwYwnrV3O4/Yf0GFlaV8MK0DJQLIdzf2
         4N4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780575263; x=1781180063;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oyxRxCYOdMyc8Dc3ZoAGzmBA02Un7oBiGn+qmKX5HP8=;
        b=jMF5D3e9ZM94TdztqtREC8PF15obYsmBfJKAvdkef+PrpsHJ83vWj194rQcGOAyyga
         yhyuF2DefFzjCwuCQ09pj04MAGUYWuzH0ONv5FK2gWciWgmH6n6CX3YwTDw8hZnlqHRN
         w8e0RcLXxitBi0qxT7rjPvaS7gtA0/1B072bRwiW+1x4X9gGDHpxpjYXhu9IDDnYmziG
         TxJL5ZTlBCislq3yHpfl9FY8xYSCTLLliQuiQ57fSzFbXGESygSlLnT5Kh0xyOo1T4Pt
         fNE05+mn37hlp8GZeIHCGp872DrGC7OoQOL2byGlKxtIZhAeVuOjaWXiHW4XOf0bVwDk
         SqqA==
X-Forwarded-Encrypted: i=1; AFNElJ99l+PHk8seGpYMdOcl8J/Fd2WVA2H+atdns6B0TMIpuYHgmA3DYc2Ynh8+QCJkYTVIFhilVobPHF8F6g==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxt5SQv3uPP5FIQFKqSJBdDtYJ7XPU++H1NSx531dMfqgSFuHp
	gfc9nQ8rLv6Z6CvoM/pVvF5qJbnL/EjsskqMfZvXV5M1045wRJo83JHK
X-Gm-Gg: Acq92OFZwTSm/VHyAW/rx9dRBDx5LCXUAMqPkW9NFMNclPVLeNAOJjjyuQ1X7YEpPh8
	amM0EDKPEXkIpYSrkBqVFCOoaKUwYFRUR0Gk7LgxeyPptXtvqvIK5UPKyIIEUngwJiRzUqtkkSi
	2GDS1Nq6sokIuhriWASfmr+ie3uIcFs9q3Yf4sJLFUN0R7SkO/HSdjIMix6FOtICPILjdithyiC
	tFIbaI2di1xqxsqWx59t0liegR0O0iNNmWEvM96O8jR8nsYv6BnNUriS+RIG54NPAN0h8YDdFZE
	BE111cHdfJ5nyeFabjmxcyrh1nBAKcy6FgXJtgal+u755XUK1vjWnqOjoMM5rrh66p8erTrFgCK
	PDgTzt3fv9CdUVcMG9jnt6Bq/MW1dH9ZiPdKb4vJrdXpr4bfmN116BKz/mL6jL9XjFpZqf5V5y4
	bbVf1CiB5lHYbqrSaz
X-Received: by 2002:a17:90a:b401:b0:36b:5b82:4834 with SMTP id 98e67ed59e1d1-36e30c213bfmr5045300a91.7.1780575262731;
        Thu, 04 Jun 2026 05:14:22 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6c675898sm3071384a91.6.2026.06.04.05.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 05:14:21 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] btrfs: fix zoned sub_group leak on space_info sysfs failure
Date: Thu,  4 Jun 2026 20:10:43 +0800
Message-ID: <20260604121043.1425201-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On zoned filesystems, create_space_info() creates a space_info sub_group
before registering the parent space_info in sysfs.

If the sub_group registration succeeds but the parent
btrfs_sysfs_add_space_info_type() call fails, the parent space_info is
released through its kobject release path, but the already published
sub_group is left behind. The sub_group also keeps its logical parent
pointer, which then points at freed memory.

Remember the created sub_group before registering the parent and remove it
when parent sysfs registration fails. Cache the sub_group pointer before
calling btrfs_sysfs_add_space_info_type(), as that helper may already have
put and released the parent on failure.

Fixes: f92ee31e031c7 ("btrfs: introduce btrfs_space_info sub-group")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 fs/btrfs/space-info.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index f0436eea1544..03659dfcb830 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -296,6 +296,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 {
 
 	struct btrfs_space_info *space_info;
+	struct btrfs_space_info *sub_group = NULL;
 	int ret = 0;
 
 	space_info = kzalloc_obj(*space_info, GFP_NOFS);
@@ -316,11 +317,15 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 
 		if (ret)
 			goto out_free;
+		sub_group = space_info->sub_group[0];
 	}
 
 	ret = btrfs_sysfs_add_space_info_type(space_info);
-	if (ret)
+	if (ret) {
+		if (sub_group)
+			btrfs_sysfs_remove_space_info(sub_group);
 		return ret;
+	}
 
 	list_add(&space_info->list, &info->space_info);
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
-- 
2.43.0

