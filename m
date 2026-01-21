Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5F242188D
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 11:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768994038; cv=none; b=L/ErEai7NEuLGXjcBlLAtf79FX+W4xj6jn/vQNwqadxh6ghT9Z2pxHpf7UxAGGq2iZQYHYtTc2iZZF3TvGam0ipzOHVgludxXepFoEG9Lhekc4D4EHmNh41mV1208KUGsfHkPgPR/g8KYQ5MUCfCiBOmlxbLNODuYBlF5yAzm3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768994038; c=relaxed/simple;
	bh=hhrh2/EKzT+s23gGWrY8ZGQzL7fRbjCjvh7MHR/Gejs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQVn/HDnLIDL0ajibo07sGSEj4vFysusssfIqZIG8v26lVW4tbnZJyWSQ0i/pe/vO0A+xvyi1xziUwxkYvcIvnasEyPPaT+gNYzWtjb134k4RrDaDy/2E0EcRekrQUWF2wiLlyobJHf99n87VI/qNcVmCnn6DQaF4cUVselAjVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7ge5HLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7ge5HLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF17C19422
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 11:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768994038;
	bh=hhrh2/EKzT+s23gGWrY8ZGQzL7fRbjCjvh7MHR/Gejs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=i7ge5HLMIT5M3kHMuRS9xOt0FHmMwLcY2lb2/iTQC8I7/qO8wfx1rEySgkUJ0stm+
	 wZF0MZpPhAWXDS+TUuv352mUHabXmsQLKgTniWEJvqmHzyT+35LZpAU15YbYHdB+eS
	 srJw2Hpmyg5PjPGc0TJW13391ntlUJeRVg02xEmf2cNzlzN9voOonQYozHTyDDwH9E
	 xcofMfI2kCMHC1aiQ+vjnKm41b7uP0+M1HIWg8XFnAjj1HqmK83y6WUwixfHbk5Gpc
	 +vo0Z7swJM9AH8QQP/euzpRaWnzLXMeP/JsTQn8XmBBeO0Qfq9VDyoT5wtgnaiVb06
	 zDtMLRH9k6DzQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/19] btrfs: qgroup: return correct error when deleting qgroup relation item
Date: Wed, 21 Jan 2026 11:13:35 +0000
Message-ID: <e1a2942dd9f7392a33b90a2771584ceb843a4eac.1768993725.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1768993725.git.fdmanana@suse.com>
References: <cover.1768993725.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we fail to delete the second qgroup relation item, we end up returning
success or -ENOENT in case the first item does not exist, instead of
returning the error from the second item deletion.

Fixes: 73798c465b66 ("btrfs: qgroup: Try our best to delete qgroup relations")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 14d393a5853d..c03bb96d3a34 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1640,8 +1640,10 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	if (ret < 0 && ret != -ENOENT)
 		goto out;
 	ret2 = del_qgroup_relation_item(trans, dst, src);
-	if (ret2 < 0 && ret2 != -ENOENT)
+	if (ret2 < 0 && ret2 != -ENOENT) {
+		ret = ret2;
 		goto out;
+	}
 
 	/* At least one deletion succeeded, return 0 */
 	if (!ret || !ret2)
-- 
2.47.2

