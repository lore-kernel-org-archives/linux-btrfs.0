Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046B3331222
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782415226; cv=none; b=Snx8YTpaz5H3e4rvmmzJUALAvBaKPDb8Xdq+fe3SPDPS52DLrk2S5SoGZSCbAMyHezStEfZ6e1c0d9o3YIgXt7aAb8B2xT91RTshyX6kTdT2uwvyMPnkuz69ci65kyif0es38Q2fwBCdLzy3iVHIZ1UT96oPoHWSP/8tbOaG+Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782415226; c=relaxed/simple;
	bh=p7tSJ3j0FcvQGuG8X6kL/NAUZTMZB/sTHavR7kZt8P0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FF1JDsERdJKo5Mp0la+UjvEg3MBFai3aZQKkSW6DJu30HyjPJLf6dpLnuzdSTaaF2DUQ9XFVfttz+2KFv3/FqT2n5EWrA66YRn0mzbRfIDHAQtP3cxwpSfJdR3y9KL8nAfN+4n2VuoOLsYF4y/CEYwdKgXY5TsOQF4iJqmw8YaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K98Y16R/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K98Y16R/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639FC1F000E9
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782415224;
	bh=5BULuP7v2Ae7Ux3QxusW4tnkgWZUJCnS6cETzijtMQg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=K98Y16R/q0uzyA0rciJ5pA9sMu/nIzBrHDY5u1yFPSZg9/1AdVsFtu3WQww28LJ7B
	 niwVogpTQwO8eIRPHwlNbZhFIB/CTWdDEUKXRDpIHW2D3DNBI2EFwD6TYKMT61hKG1
	 l0FSuOcRbe8SQvswe+ubcyfdNwBciO1nECS11htmudhyIJr/V1JYZ3VnegDYs/LiHR
	 RPhgTTQMtugsPiqGuhFOzAWaAcVdZ5H6a+QYA4PEzpvnhw//14qTqKfz9WhcTHJ6C0
	 JJS31e4bzv4rCt/L1Cn1r8eyXyPly6dtby4fcho/R6LyMqL2IaCEy5a/TFK+w9O/Ga
	 rXCbYpooMUEyA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs: defrag: use simple list_del() in defrag_collect_targets()
Date: Thu, 25 Jun 2026 20:20:15 +0100
Message-ID: <ef417c92283d2b96cdc44c7bba0ac2d47c4f324b.1782321584.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1782321584.git.fdmanana@suse.com>
References: <cover.1782321584.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When freeing the entries from the list there is no need to initialize
the list member in an entry, since we are immediately freeing it. So use
simple list_del() instead of list_del_init().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/defrag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index e454b59d6477..7b3f779775a0 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -1093,7 +1093,7 @@ static int defrag_collect_targets(struct btrfs_inode *inode,
 		struct defrag_target_range *tmp;
 
 		list_for_each_entry_safe(entry, tmp, target_list, list) {
-			list_del_init(&entry->list);
+			list_del(&entry->list);
 			kfree(entry);
 		}
 	}
-- 
2.47.2

