Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBC929A9C3
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 19:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778614517; cv=none; b=ruAzBiYbOc1vixn3xgluAbgxYftcSjH2hc87VZNz3Vkp3Y9zda1p1jdWExOGaYNn9w6Mp5iLnePjRZuczEdr92p76cpPNfarj+5+WVFfPTXhwzH1sPFVXwUFm9Kdq1xR+IKjmYUyzkiEquukABl6uTeU+XiOQ2RP23EaymKPIvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778614517; c=relaxed/simple;
	bh=miDUb5oOZIi6f8DMBj5K5LskREK3gPcT6tquQo8g8fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/b22gDrkw5GgW+WPaRD9V/T1ZIooCk1XGrF0jZQspHeCt76ORbpjVw6g4Y0Q8QnepGTAyXKM36NoLBTMLZucgg4FRVIvqQe7KJeNJFSsvey8CRVtbymwSd3Vg3/OaGEdQat489QFF8IDv30FDe/rjGY6yS1ImRI7lZSmOZTHk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=VtitDuFC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ohYLiivB; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="VtitDuFC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ohYLiivB"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 0DCEDEC00C7;
	Tue, 12 May 2026 15:35:14 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Tue, 12 May 2026 15:35:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1778614514; x=
	1778700914; bh=CEtt40xuz/8Gfw2Sahw0Geqs8lBJa8BB8VFAr1Epsog=; b=V
	titDuFCjhw6JaQWuLn8V4/WsJqlRsR/BuHAUYk+AumWnsHs5DR7diB3bpmzqxEBB
	qCfveJnvROQ9c4ZSKYwpXKnk10HuA2h+3m1CWGQTXk4oVXCwE3Cmeq97hRgFNzBt
	uOisKwtkZ/0MiD5uukj5Uo5LyQxey285//mlOGVQkDqaMNOZd7L9FL0+zHgcqkIb
	jDSvOJRS2O79nYAd1ohw7uVPfgUTJyN87T/CJIujluH/o1toe8ta2QvUll5B7oWf
	cNhkY3tNt0ewWI85zH9G+8Rf+lSLl6Tim01Murdyv8dDB8BGBLi3KT0n8pRBgsyf
	5K+h55ZrOy30KaIir69Sw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1778614514; x=1778700914; bh=C
	Ett40xuz/8Gfw2Sahw0Geqs8lBJa8BB8VFAr1Epsog=; b=ohYLiivB/L2pSzLBs
	idz0murH19e4rQC00ZcGCTy1bPU0QM0WYDwSQoCiXUyqLwYUZJw2DziFTPWR3UDq
	HdrC/fi9fepVxyV6phxCx58C6/zTQ0YCMUzQwvaa5yMYzoFEDeOj4frsGoF9a7A5
	gEXCqJ88vkEI+XG9ZQLa3gElVXEyncPNAkuAGNzZdcLHTgqfjFql1cqpLvVo54aK
	RM7YNRI6uPpLqa7orc7/edgmgO9x8CUzbJ72NsV/zgKKZSPKtwz/iRSnuM3b72uN
	/RqnrAkXQjyjwIA03gywo7LWL7TkZykzXaYJButfrUvrZEQA5f7zKN95rNp4MAK9
	sMLxQ==
X-ME-Sender: <xms:8YADakldQ5A6M-jcC-KEx06zX4bk7WzlAGVgijxEqyegD4XwGpQx8g>
    <xme:8YADarRFnPGuQs9p0PG8ACgu8-gJyqwImlvxE-qCnfT6_yC-Pw8J1TV8LFaK0Z6vr
    g1PCUyIW1BBf_32B55vAGJu4PCuMS_B-l8hIhITd8BxvRh93QDOtA>
X-ME-Received: <xmr:8YADagBul9StUJTK5I69LGsy8JXVlImqZ8XwhrY3qGaN-fwNVN_8HAC3oblcLE3linQdYGzaPICWaQ2Hk0jzUMo28mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvddvieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhephfevkeffkeffheeffffhuefggffhhedugfetudetud
    etueefveeijeefvdduudegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomhdprhgtphhtthhopehmrghrtgesmhgv
    rhhlihhnshdrohhrgh
X-ME-Proxy: <xmx:8YADaqRZGOLGyxYdD2IDnO5E2fxM3LVNdUs96nzntulesXl0_0qLyA>
    <xmx:8YADamr-eGoZ2E00Yv_Wc-8CKG2-S1xJ1BPoMlwfbLp-UDOHUC3EfA>
    <xmx:8YADakwQYYpNsM29FasHyEdVNLJ7a_YM5SyM1z9kwfi1R4Ahk7xrCA>
    <xmx:8YADajJC23uRZufdEfsO4BAncC_wzr1bHDXUusRxmDrz3-Sdq4h85g>
    <xmx:8oADal2sJRYllsK2vwIKbmvnDH501VkTvHauYTAPWG_bL7-RRpmk8SKd>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 May 2026 15:35:13 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: marc@merlins.org
Subject: [PATCH 1/4] btrfs: check for subvolume before deleting squota qgroup
Date: Tue, 12 May 2026 12:34:53 -0700
Message-ID: <d12157822cca439765bc48779dab2143e4ef685f.1778613519.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778613519.git.boris@bur.io>
References: <cover.1778613519.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The invariant that we want to maintain with subvolume qgroups is that
the qgroup can only be deleted if there is no root. With squotas, we
thought that it was sufficient to just check the usage, because we
assumed that deleting a subvolume will drive it's qgroups usage to 0,
and thus 0 usage implies no subvolume.

However, this is false, for two reasons:
- A subvol whose extents are all from before squotas was enabled.
- A subvol that was created in this transaction and for which we have
  not yet run any delayed refs.

In both cases, deleting the qgroup breaks the desired invariant and we
are left with a subvolume with no qgroup but squotas are enabled.

Fix this by unifying the deletion check logic between full qgroups and
squotas. Squotas do all the same checks *and* the additional usage == 0
check, which is the one extra rule peculiar to squotas.

Link: https://lore.kernel.org/linux-btrfs/adnBhWfJQ1n3hZC8@merlins.org/
Fixes: a8df35619948 ("btrfs: forbid deleting live subvol qgroup")
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/qgroup.c | 51 ++++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 0511b6dc72b0..5cd2e0ceb1d8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1715,32 +1715,25 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 	return ret;
 }
 
-static bool can_delete_parent_qgroup(struct btrfs_qgroup *qgroup)
-
+static bool can_delete_parent_qgroup(struct btrfs_fs_info *fs_info,
+				     struct btrfs_qgroup *qgroup)
 {
 	ASSERT(btrfs_qgroup_level(qgroup->qgroupid));
+	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
+		squota_check_parent_usage(fs_info, qgroup);
 	return list_empty(&qgroup->members);
 }
 
 /*
- * Return true if we can delete the squota qgroup and false otherwise.
- *
- * Rules for whether we can delete:
- *
- * A subvolume qgroup can be removed iff the subvolume is fully deleted, which
- * is iff there is 0 usage in the qgroup.
- *
- * A higher level qgroup can be removed iff it has no members.
- * Note: We audit its usage to warn on inconsitencies without blocking deletion.
+ * Because a shared extent can outlive its owning subvolume, we cannot delete a
+ * subvol squota qgroup until all of the extents it owns are gone, even if the
+ * subvolume itself has been deleted.
  */
-static bool can_delete_squota_qgroup(struct btrfs_fs_info *fs_info, struct btrfs_qgroup *qgroup)
+static bool can_delete_squota_subvol_qgroup(struct btrfs_fs_info *fs_info,
+					    struct btrfs_qgroup *qgroup)
 {
 	ASSERT(btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE);
-
-	if (btrfs_qgroup_level(qgroup->qgroupid) > 0) {
-		squota_check_parent_usage(fs_info, qgroup);
-		return can_delete_parent_qgroup(qgroup);
-	}
+	ASSERT(btrfs_qgroup_level(qgroup->qgroupid) == 0);
 
 	return !(qgroup->rfer || qgroup->excl || qgroup->rfer_cmpr || qgroup->excl_cmpr);
 }
@@ -1754,14 +1747,11 @@ static int can_delete_qgroup(struct btrfs_fs_info *fs_info, struct btrfs_qgroup
 {
 	struct btrfs_key key;
 	BTRFS_PATH_AUTO_FREE(path);
-
-	/* Since squotas cannot be inconsistent, they have special rules for deletion. */
-	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
-		return can_delete_squota_qgroup(fs_info, qgroup);
+	int ret;
 
 	/* For higher level qgroup, we can only delete it if it has no child. */
 	if (btrfs_qgroup_level(qgroup->qgroupid))
-		return can_delete_parent_qgroup(qgroup);
+		return can_delete_parent_qgroup(fs_info, qgroup);
 
 	/*
 	 * For level-0 qgroups, we can only delete it if it has no subvolume
@@ -1777,10 +1767,21 @@ static int can_delete_qgroup(struct btrfs_fs_info *fs_info, struct btrfs_qgroup
 		return -ENOMEM;
 
 	/*
-	 * The @ret from btrfs_find_root() exactly matches our definition for
-	 * the return value, thus can be returned directly.
+	 * Any subvol qgroup, regardless of mode, cannot be deleted if the
+	 * subvol still exists.
+	 */
+	ret = btrfs_find_root(fs_info->tree_root, &key, path, NULL, NULL);
+	/*
+	 * btrfs_find_root returns <0 on error, 0 if found, and >0 if not,
+	 * so the "found" and "error" cases match our desired return values.
 	 */
-	return btrfs_find_root(fs_info->tree_root, &key, path, NULL, NULL);
+	if (ret <= 0)
+		return ret;
+
+	/* Squotas require additional checks, even if the subvol is deleted. */
+	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
+		return can_delete_squota_subvol_qgroup(fs_info, qgroup);
+	return 1;
 }
 
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
-- 
2.54.0

