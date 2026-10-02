Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6470C3E51D4
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790967355; cv=none; b=pWaOe0zv8ZaRbe+5dsPlqPROemz8YtS5ViToF5SjXBV/vlGCmKSMaAttOENCG4QfmRa/wg1TwQcbjlbtAWC2U+6ZpoZ8xW/yJ0CwTN2HwBucYaKTGZAoGpIzIKFhtChok8IvXb2UwMGGX92fbzv+3HTiZ0uEJn9FxhQ4E5TPMBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790967355; c=relaxed/simple;
	bh=44zqMSUZYdkjeBHk/dtrAo5lOhef5/9ijIhRX6T4gjQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIpfnyoOnIPxWksFFxJevFcRfGvaUVMOe0IWXMTYYIyqd9r9Mmq6xxJMO03hRvouMashEwz9cCubhkZ5TyqATjNI4JfqeMhJUyyJVJ+swHaccgG4ecrf/svpgp8wfEuGzV3PDjmYpLKeiSUnlh7sh7r7HLLtjhTSCoR9xk9SPJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTG1gKhZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTG1gKhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F811F00893
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790967354;
	bh=Md3odJpwoUx4AU8Xg5h6vhL5pL1WFU6mVy/51tS2goU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=JTG1gKhZajPnvcrtU/a8kWF/ZEl28Rp2/Qk/RlN1DZ9DvK+QQYdyUKqAgXWmP+ZF0
	 SC40hkpsdSpBVNPGGuTRWKQKP+cE7VejnDM3OsfMKzQMW1Dnoloc+jRmF/w2yphb6t
	 A4TzsPoVnEru5BYsQc815d429QhgO04qR6TVUg57xzyNCb1KEAn6qlwHZ6JaE9Rv55
	 OACCf32tM406vIJtmeqHsbVOd8d4hA4V74FI+jjE1WLNDn5g4BoZMZgeP3VIQAo13h
	 I6wcSv2lvHxa2MawdiS7s7j9CiZQPjokck0CcANWsbQS9SqPVG/X0gcJIT7T2D48Tb
	 3uPC4od2DbOCA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: qgroup: abort transaction on failure to add qgroup relation
Date: Fri,  2 Oct 2026 19:55:43 +0100
Message-ID: <3035da7f5be049e54d539c1bb1ee11f3f15ed878.1790967259.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1790967259.git.fdmanana@suse.com>
References: <cover.1790967259.git.fdmanana@suse.com>
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

