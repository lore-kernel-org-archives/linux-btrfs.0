Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDC03ACF12
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2026 12:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768911961; cv=none; b=IO0NjSAf3/iwBMB/np451GdrGAk6241MwSSZQcfMtp4yQYFai2mu5LKmhOUg6qTDf7VkhdeEO1NlLmFGo3+9SY3vywstxZBlQQG57fh3yWq9w8fmH8W7amsx02EiClzW/bHKI+Oi2joF333f4r63Ycxw9FjkuN2SqKM/8xMdBCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768911961; c=relaxed/simple;
	bh=3SHmHMkfzjn4E8PkSTW+SAnghoahYJgD4pDjBcToR5A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pREKhvYKwoy6/SKDHTXqLd9U2EL/CyhofL51D4i0wfKuwzXT/4O1SiLWnLDnc9eaZ9WslBuWIeFJA3/s/CR+nQ5byfJAOhXnxZ4p+Yr3YchgC0YHtP6LJTAViBtGJSuPIsGydULOU2NTVMCTTCXiuFzifAHU6CZWRGlQu9aReE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sp7r88ew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sp7r88ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F99AC19422
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2026 12:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768911961;
	bh=3SHmHMkfzjn4E8PkSTW+SAnghoahYJgD4pDjBcToR5A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sp7r88ewKWQQ/pzY1xTqL8Atpgm3EAq7LlwFpKCZginbbZB2ozkANTGiNZrmt7HTj
	 Nqm8hVkZDqQ09xr1jyUdl61eApPZbgxP3TYwecsRQjG91dMn73NsN/P8Lv+6CFJGW9
	 FTOLqDVGRA2fArE2VWfH8XuZW8KrxoV3kWbkz4Q+RkIVq2ut8BMiOpVb7heIIDCExH
	 Svo6sOqpOokJFm0X8398fh9Fa6Afa1Fb9qP6THD6wqHJi8WB8GEuuCNuAw/96vgFyp
	 xlMeVRxVgIj47OBUjWAWeIV7fpdu7skj7j9IIpN8BKVz38BlddKfJnDuaDEuhq6oxR
	 nUviOZHDuVRMw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: assert block group is locked in btrfs_use_block_group_size_class()
Date: Tue, 20 Jan 2026 12:25:54 +0000
Message-ID: <529715e8be7197b1a2e0b3940c2af811503f1521.1768911827.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1768911827.git.fdmanana@suse.com>
References: <cover.1768911827.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

It's supposed to be called with the block group locked, in order to read
and set its size_class member, so assert it's locked.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 82c488a4b54c..2efeb5daf45c 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4749,6 +4749,7 @@ int btrfs_use_block_group_size_class(struct btrfs_block_group *bg,
 				     enum btrfs_block_group_size_class size_class,
 				     bool force_wrong_size_class)
 {
+	lockdep_assert_held(bg->lock);
 	ASSERT(size_class != BTRFS_BG_SZ_NONE);
 
 	/* The new allocation is in the right size class, do nothing */
-- 
2.47.2

