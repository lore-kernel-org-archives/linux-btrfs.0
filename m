Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A98489879
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 17:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791046812; cv=none; b=p4Gxd/k3qYfUPiTtK+GsCNMeprWaYcW6iRFnFIZBvSzgJUASefB6B8cFtbBgNWMGgCpEco586dQN61yxAe5t+nw4lJAB4BafgqGjNo7rku0hC+N/4GAUYJt5NL4YrUSw30e3Oc4Dvl4KDjwowUFNz+blLkmgy3T5MVEA+fox0tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791046812; c=relaxed/simple;
	bh=3K0CV8gZ1jREEbEe4ipq4199SUNbfDDN1TYja+Pwf8w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIuYXw0naqMl4haycmgoAsMEiv8+ysDnvBVcVBky0uPI0qRXXEchyckTGeyGIVH07duB9LVHwhl2NIrE/qNcG2mdx7CKunkmCaAdDqnjLL23bjH+AmHaxZGgX8F+JcW4QWS5BwdqcTO7GrVqzuAXg7NsE9654eh0Wwd9JaUyxww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyvK3QSK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyvK3QSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508D11F0089D
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791046810;
	bh=X8lgp6Fs2dXFqpV+7rgWCkyLbWwwASCFqO70F82FGXY=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=oyvK3QSKKD+BIxyETZgRydmofaurwWAvkf2GgdjQvtXR3+4H0A/3fZ4GwJnfdh+zj
	 E9pJp2qLEpeBTaAToXdYWwamQvmt5wtmy4RduGww4U5Pkn8nZqSMWa8px3R/MU4Mdh
	 f7YxcyyV3ikNZ/2VFIDFKqK1H5NLbQvsn/9HlVtOqPcC/PTlPdY7xPiMXtABBNi89+
	 CRq3WQH7JCKdOx8wgKfU7hKU2LFMVCwWDHVIOHvKqdICF9znHowo5u+ApGjP+maPdF
	 oZwIDQEh89Ny933QMnMXKgHOyHO38G5dKdh5YzDm8As4H2xKROAaaeysNdYP1hKh+n
	 qkd6Y0wMUTSJA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/6] btrfs: qgroup: abort transaction on failure to add qgroup relation
Date: Sat,  3 Oct 2026 18:00:01 +0100
Message-ID: <769194a2d0434e1f77f0e648ac5b993ef503eed7.1791046651.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1791046651.git.fdmanana@suse.com>
References: <cover.1791046651.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When adding a qgroup relation, if we fail to add the relation item from
"dst" to "src", we attempt to delete the relation item from "src" to "dst"
that we added just before, however we ignore the deletion result and if we
failed to delete we leave an inconsistency in the quota root. So check the
result of the deletion and if it fails, abort the transaction to avoid
persisting an inconsistent state.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 798f21608de5..4b6c82a24bc5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1616,7 +1616,11 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans, u64 src, u64 dst
 
 	ret = add_qgroup_relation_item(trans, dst, src);
 	if (ret) {
-		del_qgroup_relation_item(trans, src, dst);
+		int ret2;
+
+		ret2 = del_qgroup_relation_item(trans, src, dst);
+		if (ret2 < 0)
+			btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
 
-- 
2.47.2

