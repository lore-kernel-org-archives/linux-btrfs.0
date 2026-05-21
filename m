Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D1A2D1911
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 15:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779376061; cv=none; b=rfT4NkhV+pG6aOJNH+SygTb2kQ+RoYkoZ+cuYJgPEN1odwxNO9LGAcxe6MziQW9TVcWDoeqpiyr5XzhQgSXPFfN/0/AYOlgwR4FhDdae0ECg/4K8Tfa8/tQ97JXs9zNgBwn2v2bNGPAeQnSMyP/zcHHiAABOROGbREYw9wAN1uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779376061; c=relaxed/simple;
	bh=Zc8DxNO+Az91apBTObmhhWIRVhQOZ3Iq0xtZ3EtmRbQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abmyC/DCb/nJ0671bjDXDJi8ewtMORkGGfvNSQLxxS3socWw8beQdJHXRj2La/80LnVzdQD+OsQHc/7MeFeRM6eoEszchFCfe4K+QbY6wAcxpsedtajy2PQkY7X9t6V2kqpRHCpXks+b28pKSqeOTopeQUCH8jWSV75HW+7zoB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYevrqmg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYevrqmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D463E1F000E9
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 15:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779376059;
	bh=NIafIPImGmxCWg7ZxMJ+UtdZCpkbEXrj/za9pmvOU8k=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=eYevrqmgBso/AFiJwElKP9VRaFdJc7Gio5rsZYYKwjX7yiB4gJRgDj7koVbrovZtc
	 wklAWPnmJXEjYYuVkHbFCXgkq0DSuAoOmFanJaQ2IAL3/v8wzOZpcJmV4s70h9Ywoc
	 fl0PMAzhgFGMLq6nGqjBPU8Gp2DPdGuGe0lxKTJVuCfPaBLObO4mtgTwo/YC4TtUgY
	 vhSWfDtJkQKaYQ5CznA45m9M6oHAGY+da12s/iPp2c0bfQ+kkFm9trz8zYkehtsMVp
	 hRBMeQ1zzZvk6ZkRyFGcO6zruDlB360we43ifDtS8v4PXGH/1hcEKK4Qv1AouMIwyQ
	 If4dMQsJtRL5A==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix invalid pointer dereference in __btrfs_run_delayed_refs()
Date: Thu, 21 May 2026 16:07:36 +0100
Message-ID: <f81a69124ba44ff062f13e6287be7f0f5cf56072.1779375954.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <f33f040f3ced4b3813dba4ddb0b5377ab5aeac29.1779374308.git.fdmanana@suse.com>
References: <f33f040f3ced4b3813dba4ddb0b5377ab5aeac29.1779374308.git.fdmanana@suse.com>
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

Fix this by ensuring that 'locked_ref' is set to NULL when
btrfs_select_ref_head() returns ERR_PTR(-EAGAIN) and incrementing 'count'
as well, to prevent infinite looping. We do this by doing a goto to the
bottom of the loop that already sets 'locked_ref' to NULL and does a
cond_resched(), with an increment to 'count' right before the goto.
These measures were in place before the refactoring in commit 0110a4c43451
("btrfs: refactor __btrfs_run_delayed_refs loop") but were unintentionally
lost afterwards.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/ag8ARRwykv8bpJ87@stanley.mountain/
Fixes: 0110a4c43451 ("btrfs: refactor __btrfs_run_delayed_refs loop")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Use a goto approach to jump to the bottom of the loop, that already
    sets locked_ref to NULL and does a cond_resched() too.

 fs/btrfs/extent-tree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ecc1acb1e340..6030cdbdb742 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2108,7 +2108,8 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			locked_ref = btrfs_select_ref_head(fs_info, delayed_refs);
 			if (IS_ERR_OR_NULL(locked_ref)) {
 				if (PTR_ERR(locked_ref) == -EAGAIN) {
-					continue;
+					count++;
+					goto again;
 				} else {
 					break;
 				}
@@ -2156,7 +2157,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		 * Either success case or btrfs_run_delayed_refs_for_head
 		 * returned -EAGAIN, meaning we need to select another head
 		 */
-
+again:
 		locked_ref = NULL;
 		cond_resched();
 	} while ((min_bytes != U64_MAX && bytes_processed < min_bytes) ||
-- 
2.47.2

