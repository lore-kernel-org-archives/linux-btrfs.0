Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28BF4EA383
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864433; cv=none; b=ih7/9BH8XXs5roYbJiFBZFxozgJqKvqCHBLz9XVIS1OWqQgGdsJnpOF21ksdkWcnXn8JR5BN+k7+AXRhoPIK0bUzSshaK8slhvVD9evvStKN1DceisIMGmpxgpstECGzI3ppwRrcQ08y4/a14TXP8geOBjk/0g6xUR8l6YD5R8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864433; c=relaxed/simple;
	bh=yl0mw/HyAdLWlbn1RfJrANX5uOz6kJ74afWELYQAnnw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TARgjCuUVxjfdPyb1liqHluooqyMrFikTKmujk69NZqQHv+K/XJhrmh0hbWUmnim+WQrymcwS07rha8x7KyKZUFqOojGujrWTEwnuxX9KUGwAU0vZsQDRS0gxuBqnMgVRUUmNH7wH2D9hPYhTyGLMgjcijNJYAQtu9Leo2qVjF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t0QmYa/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t0QmYa/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1198AC2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864432;
	bh=yl0mw/HyAdLWlbn1RfJrANX5uOz6kJ74afWELYQAnnw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=t0QmYa/IgLnYKkYmTBMFe7ly8hvzdPnqXi8umOsxF/7vXmAZjKwkZL3Bb/osZ+WJq
	 ByzH6+MPQDZo1an2ajXwP4+wPXrc20cpf6vyFF4MjPOkRdA2cTmm7UnOjTkEXd4yHI
	 b865YHeSS+fm0Zm6dTZXM/u0AWrSVnoocd1DFGs+259lt5ifSZ4NpLy3w16n3DEAxi
	 Cdh1qg4X5SfO2499a8RMEAdDEJCGXJDhEik66+acieyY9jiRuF+Mog7hmDadcpI0qz
	 2A6KoqLBbWasIOkUWo8aHmPeX7me5RdiMTkclrV1SO4RE5X0qckUSlat0pXyDxlNg/
	 TKJQ90EAQnQdw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/28] btrfs: remove call to transaction commit trace in warn_about_uncommitted_trans()
Date: Fri, 15 May 2026 18:00:00 +0100
Message-ID: <3ee602f6990e604e616fdc7325b15d6ccee96f02.1778776706.git.fdmanana@suse.com>
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
index 982df3e31311..62ef5ba69d37 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4285,7 +4285,6 @@ static void warn_about_uncommitted_trans(struct btrfs_fs_info *fs_info)
 		list_del_init(&trans->list);
 
 		btrfs_put_transaction(trans);
-		trace_btrfs_transaction_commit(fs_info);
 	}
 	ASSERT(!found);
 }
-- 
2.47.2

