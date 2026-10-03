Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7099C486403
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 17:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791046810; cv=none; b=HN32GiOyxbKiXAXRwtENCIssgP6jKXy9okI+L2H9chl042yvxb7N2CFj3QygWWZHwB0z3LB5cLdxWmLJ7bIHdZ88c7XiaDgm3UNCnfqfHMB9tEXdQT34/Rqm7tgEONW3XOo/9fUTuicPhW7420u7vbf+FJAAJfWCVMoWRL72h60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791046810; c=relaxed/simple;
	bh=IdtY5z3cJqW4tE2pP+rIE9Srb6bY2wlgffU9ZMSVmYU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQT7Bvj//gQ34oP2E+etiDK9VWIDShoDc7BUjq5CJzuFVPVk0dRldDfXNLW50MzetjJdedtzohGBa4KuCslSzyvvoY90haCx1kM3YryTKbGtmazNDNypoFdFpWQ+4mMmNZQHr9OYeUb+stMKrxF+tpMyldEf5xSqZYR1GMcr0oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhn9LK/0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhn9LK/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B76D1F0089B
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791046809;
	bh=JShpOR3epcRkJtMaqk68hIjVeng3fq9oOL2UllM0iSI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=lhn9LK/05KfFplup21tQuieR3WGa9wIW8PDgw4F55v1WnBDx3zLUUHsuZanbpwAoz
	 2moz4M7SPd/+vu7wYxbxRbeRYDGClnBCPthUxI9q8dCYH0jhtfvki43+pzeOZcD3yE
	 HhGcXu9Y2NnXXdwiw8NKxs47kwrBD0FnCoUi6T0ydPotU0qnH1VPkF392fmrV1eQwj
	 UTZ+KAg4n46GRvXL4ny/vwT/ohRCXAC4vqY4J4chvYM/3hyycgkZ6l/XGCxxCATyGf
	 24bt67FOuNDoD/VX/ph9xtF9hGOigIt3+IEHy91+apM6XeRlR3sOMkN3ElH/kExaZ9
	 MZRQQD0QioUrQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/6] btrfs: some qgroup fixes and cleanups
Date: Sat,  3 Oct 2026 17:59:59 +0100
Message-ID: <cover.1791046651.git.fdmanana@suse.com>
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

Fix a few a bugs related to qgroups and some cleanups.

V2: Updated a comment in patch 1/6.
    Added reviewed-by tags to reviewed patches.

Filipe Manana (6):
  btrfs: qgroup: fix swapped blocks existence check when tracing after COW
  btrfs: qgroup: abort transaction on failure to add qgroup relation
  btrfs: qgroup: fix leak of qgroups in rb tree after failure to enable quotas
  btrfs: qgroup: merge error labels in btrfs_quota_enable()
  btrfs: abort transaction on qgroup failures in create_pending_snapshot()
  btrfs: qgroup: fix off-by-one max level check in qgroup_trace_new_subtree_blocks()

 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/qgroup.c      | 55 ++++++++++++++++++++++++------------------
 fs/btrfs/transaction.c | 15 +++++++++---
 3 files changed, 43 insertions(+), 29 deletions(-)

-- 
2.47.2

