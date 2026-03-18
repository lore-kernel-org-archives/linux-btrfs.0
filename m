Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644703BED66
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 16:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773850685; cv=none; b=jCcvjvYWZYRacwtLwciH7ONIDvAxjTpmZe4GtY+lgEVfNr8O6Emf1xpr8/OjOOxSNKix+iC03vPy+oxej27VwEXxb9QUxfjATUYN+NItbK1MxT7hziHJeHIo/iCSMM9p93TyUs3Lvxdm29zYjFHNSHyWpcERBPRG3czc8d3xhck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773850685; c=relaxed/simple;
	bh=sR/cKwUHZEFuyKkm1T0m2FnEz+09iEGyO7uYEYjGWIo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=RA4iz/k8vW7gO1i6iNj1DgxK9C+U9QWIdC/UTLkYyxAASniyRKwJe3t8dp7MDirjBMvOO1dYHd5OuXuHmlQWKpHcvgwe0OnhCqiLFprAVz7F/lr9wSgZJe8vDLl9DJg3dRhXW7QX0Fxg0r3RzX3T7pdUaszhZ7D5yjScZKS2KNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oh3i9vj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oh3i9vj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE62C19421
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 16:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773850684;
	bh=sR/cKwUHZEFuyKkm1T0m2FnEz+09iEGyO7uYEYjGWIo=;
	h=From:To:Subject:Date:From;
	b=oh3i9vj5QNDSFBjCAQb54HY2fsU3Rr12e+/H76qAgquQ4WQmlXPq+XLWZSz+DqN2h
	 8B0pCyg5joE2vReqMWuNG21nwHA96FOqIRmyGftQPAZbuUQf/2FujVP4PIjBmR3haI
	 AgctWzhVrS0g6XObr1MR3yRsTU7JgBIK6/FHNfot5rTa/cSQvU/4t2Dh0oz+4ldlQW
	 xHLb7wXRTgXeoAHKZDRvRx6TiAChkAo1LMtf2tk0TUT0gP7VngcFY6uHOdxxgxAgTt
	 PPHkCzYQP97fHN868qDpfMA51ZML+JKtfNqMCLKFISJVv2SqN6cnZWSnqBKyPge2Xy
	 RFvWXtRd0McBg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix lost error when running device stats on multiple devices fs
Date: Wed, 18 Mar 2026 16:17:59 +0000
Message-ID: <9d308e7cc667be86e3a24bdd34f1cf24f02bfb5d.1773850534.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Whenever we get an error updating the device stats item for a device in
btrfs_run_dev_stats() we allow the loop to go to the next device, and if
updating the stats item for the next device succeeds, we end up losing
the error we had from the previous device.

Fix this by breaking out of the loop once we get an error and make sure
it's returned to the caller. Since we are in the transaction commit path
(and in the critical section actually), returning the error will result
in a transaction abort.

Fixes: 733f4fbbc108 ("Btrfs: read device stats on mount, write modified ones during commit")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8353ddbec243..33fa73668534 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8302,8 +8302,9 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans)
 		smp_rmb();
 
 		ret = update_dev_stat_item(trans, device);
-		if (!ret)
-			atomic_sub(stats_cnt, &device->dev_stats_ccnt);
+		if (ret)
+			break;
+		atomic_sub(stats_cnt, &device->dev_stats_ccnt);
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-- 
2.47.2

