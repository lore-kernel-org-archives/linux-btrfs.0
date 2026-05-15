Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37AE4EA389
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864433; cv=none; b=i31byFdokecqB0Tn1tfRXHwKVWDx4IbjGPBbIS1WvAzHBxflbxarAGn23G0djG1WW/zInLaIUBkXLz76k4IWmiYh1qmELx+/2aRtDxj+5PaprIQP5XcE25cOkmvnbn4DUxgFd4wL3Nz/Trzrbq9SQbESIk3nryICxl5XlMfs63E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864433; c=relaxed/simple;
	bh=p5uUJ1iyNt7GwsXovFY+MbeI16DBKYI7Hpz61n0uWYc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVii2XSb+XmuhLMNbqSXMr+pSdrNeoEONHYnhYtSmaZyZUIStjofgS7LMFDn34XIyVHh31L+8Nu35A759INE8/o3v2GNFgSml7WXB3GV9L2oxVuICkxLcYjkTURzM89NYqR35RUvO4T5gwvC3JB1GcK+kMBQcsDMn9+a70HuOQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dK0lT6jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dK0lT6jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04660C2BCC7
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864433;
	bh=p5uUJ1iyNt7GwsXovFY+MbeI16DBKYI7Hpz61n0uWYc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dK0lT6jwaP/F/bhwUjoAvtbP1zd7vnH88/STC5MSo4DdoSQ1lXRIog3dKUtESYwAF
	 LJWY1iNMHEc3nHptc1jKAWs50fXwfCtdG6zU/eQuhsRArMDKPdn/SfFI70wTi+NarL
	 Jz6TY205yWbg1etwjNQV8WtDSpVK3CpIWK8aQ+Z0bcgJeSnRDa/4oPR/MObW2uvU4b
	 qGq6snCO76wuq7s+Bi7KFbUWReXZkL27xiyWMtBVwm9vWMucBQngXmuQ41GCE5PhBK
	 767rhXHrkYqKdBz1FY/r6c8dzAycWULm2JLX1UsU7kA/7j9ssmU+eTKcu5AT1F30og
	 4ffYynuTTQwXg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/28] btrfs: remove call to transaction commit trace in btrfs_cleanup_transaction()
Date: Fri, 15 May 2026 18:00:01 +0100
Message-ID: <a3a736e4af384573fb7e4051d0d389af6f5a67a5.1778776706.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1778776706.git.fdmanana@suse.com>
References: <cover.1778776706.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We are not committing a transaction there, plus in subsequent patches we
want to change the argument for the trace event to be a transaction handle
instead of fs_info and in this context we don't have a transaction handle
(struct btrfs_trans_handle, only a struct btrfs_transaction). So remove the
call to the trace point.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62ef5ba69d37..e6ed52f5cd6d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4946,7 +4946,6 @@ static int btrfs_cleanup_transaction(struct btrfs_fs_info *fs_info)
 		spin_unlock(&fs_info->trans_lock);
 
 		btrfs_put_transaction(t);
-		trace_btrfs_transaction_commit(fs_info);
 		spin_lock(&fs_info->trans_lock);
 	}
 	spin_unlock(&fs_info->trans_lock);
-- 
2.47.2

