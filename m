Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040933D811E
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779374502; cv=none; b=cybYLSUACqo4iuy4ZrS5rrMjwEIrrngZ0363miBT/65mElxyj11ipI5baYeRlGwqG1/6rqe7etVWPkDPRFfXW32bO6WjBG7gpJtLdtoV8ZW3whEF9XRE540uBTp6TXspac3IQSbqIDk7JohUixX+F4uGtC1fTbk1lEPDgpVeSCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779374502; c=relaxed/simple;
	bh=Lc8ZCEdXxDn94KSPNA9WEt4/dSG3lRjqeqFC30PAEpU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=eAPURe/EmJ5fCHwr/FR+9WNMgLXSgGyzG9rk3UcL1Zu4aLNyhP3jZWCfhcfNXq/9UK7t3NXOV1r4NNGByfsNZUo7lKO3pgPN1tUy7nkh+Q3puBhXjTjHo2pWtV17CM7ITXRj+kGUSswkuysNGNq2bTroWtkxdX4+2OJiE2BoIQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/yEfye2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/yEfye2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227671F000E9
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374500;
	bh=aPhQUa/G0KZjjgQvL2QHl+Pqju+hco967jaNaAoKDGk=;
	h=From:To:Subject:Date;
	b=k/yEfye27HlrQFULIsbSYQLY7S0apgAvPdZ+FFYtPCLYHSQrXWabmrlxl38SSVrAG
	 oUpAmUPa4O794HDYNcBBaOcsAKxDjgV5Gcrafk740TVBenmjqiTGX14R9xxWNpRLKY
	 3fFFGxlLsERwLq2BQJAz7ofqSJ3aa+cayGPXMSNWcU2g+t0l0EjNooTHJr8Wc58nFY
	 1xT+MVob2jFg9hvT5R6HpoxGTFY/uhMyI6WRaq8eu6pT/4buYLBBiROUDEhn4XgpX9
	 M7KHEOfvBYpxiksjc1ZojBESbPkmZ5OdWjzAYTllU9Xd+wQ8+kP5j2Fz0/2ZBzFdZH
	 3Pk+xwQ+aaTVg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix invalid pointer dereference in __btrfs_run_delayed_refs()
Date: Thu, 21 May 2026 15:41:35 +0100
Message-ID: <f33f040f3ced4b3813dba4ddb0b5377ab5aeac29.1779374308.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

In the beginning of the loop, we try to obtain a locked delayed ref head,
if 'locked_ref' is currently NULL, by calling btrfs_select_ref_head(),
which can return an error pointer. If the error pointer is -EAGAIN we do
a continue and go back to the beginning of the loop, which will not try
again to call btrfs_select_ref_head() since 'locked_ref' is no longer
NULL but it's ERR_PTR(-EAGAIN), and then we do:

   spin_lock(&locked_ref->lock);

against a ERR_PTR(-EAGAIN) value, generating an invalid pointer
dereference.

Fix this by setting 'locked_ref' to NULL in case btrfs_select_ref_head()
returned ERR_PTR(-EAGAIN) and incrementing 'count' as well, to prevent
infinite looping - these measures were in place before the refactoring
in commit 0110a4c43451 ("btrfs: refactor __btrfs_run_delayed_refs loop")
but were unintentionally lost afterwards.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/ag8ARRwykv8bpJ87@stanley.mountain/
Fixes: 0110a4c43451 ("btrfs: refactor __btrfs_run_delayed_refs loop")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ecc1acb1e340..ab4d2e93f385 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2108,6 +2108,8 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			locked_ref = btrfs_select_ref_head(fs_info, delayed_refs);
 			if (IS_ERR_OR_NULL(locked_ref)) {
 				if (PTR_ERR(locked_ref) == -EAGAIN) {
+					locked_ref = NULL;
+					count++;
 					continue;
 				} else {
 					break;
-- 
2.47.2

