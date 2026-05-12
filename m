Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801CC3655CE
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 19:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778614518; cv=none; b=FMRVzQPFxcxR/5MJPhvApZ2mFZlUsRbYo5iizs9x75pGCmFBnzogNDzrbYYjSLSTPcubEQbvzif4wlhBW0nh0OCLDEHPMnOvxO4o5xvHgpS93zyksZzEOL6S8cIS2h81DY+8PWt6gNe3r8KD3kOpRFygF/OZw9H8CULA7Crqayc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778614518; c=relaxed/simple;
	bh=M4fLaEtP/dpPpbKzHC6Amfo4XqbH02QzSjVxCOKeahQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zhf3mfziWQSnLNQVGi0nWOFog6EoJnidakPlqSyr3oYtgmf63+uA0Wc/qhnKl0mmmdF9k1YGD1vYgJul3wIPSVT29pRQ4QK3FqYq0CXJqIt2+dzNnDigscE2vdrWUNwmY7+bmVpll4qBDKybGSxAO/8OaukNiCCjbD3jBpVIl4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=bgPA+h4m; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Ukh5X8o6; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="bgPA+h4m";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ukh5X8o6"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id CE6DCEC0202;
	Tue, 12 May 2026 15:35:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 12 May 2026 15:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1778614515; x=
	1778700915; bh=K8CQed5TdtVT9TJluF+mMZORXudVzrtTdxB9VpmpYG4=; b=b
	gPA+h4mLdqt/u7XPU+pJn0aCgGZU4SCGWxd45bCuMc0DXIg/txkxkVqNiJ4cHOM1
	v/ORbPdlJrkikjHr/c9xmb93muYiJPNIlU+5Q7jLgCpB2pAHjfIRFuMzyhelLWvB
	734QSJfKzWbHIZYVXgt7vRwQSaPMiDrj//+535DRZvyhgYuWosENv7tBJj6fugmU
	zGHMeLpUSfBGqtWBLRAZ0bUVt0SNcYa7DT7GV4XKl/hLU7k4gTI2yxPGZQj9JaMa
	jp2/n4sZK0+BqTsib5CrHY6zBjlQL6HLaHst4Fn0+KYDvbsT9lTYqJrS3dm1XP9/
	mBG5UkRTVX4VRUxdI46kQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1778614515; x=1778700915; bh=K
	8CQed5TdtVT9TJluF+mMZORXudVzrtTdxB9VpmpYG4=; b=Ukh5X8o6vWtC8z1SY
	sn6vVMBuMLIukhv7OL6lehCsH0rnsoeI7VBe5tHzSQl8R3wV39Dgn6qwIvPGEynz
	eG9vXvG6JTHhpmzx8s+PEGPwd0rEqaHceTx0jeVF8ov1dZ18fa+Oon9eGB6kRmXc
	9+qeQs+e3Npi/C7wiAjyDuvxcdEM/RQy94jO1NqezmDuMFpcQTspxzQ9KTtcvYDE
	QKeScWKBqva5cBvabb2LEPEgEhK0tmcM0w8qu2SbzoDLIuLzyV3vxfUX/rMyanuJ
	aXu0ytMT5E379Q285NQzIw/ReIkMpOmFSe9dfkT0gO9VP5fglcFXNQhMvNimVymn
	KIzbw==
X-ME-Sender: <xms:84ADalmOOuqyyeYhqy9NmS8_AaRcX_GJ-krl00w_nTlG22dZuHCexA>
    <xme:84ADaoSJsHCk69l1fuetS21-fe2EE97eSa3KlueoM-Qu3YhI_0UOJHf51YX2ZK7Yn
    wucO--rh5qrX-HPQUbUD7VlvNw1b6pWW28VUEYSPGFVxEjQ3Nb81UA>
X-ME-Received: <xmr:84ADapAt5QgQugmP_CJL6ObTQT6sAESNboi5PWVlj_R7I75YK5JzT1D__L9lwIWMwH4tyHbxLqQsTAaHlQ6MDYbBdO4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvddvieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepgeduteffveeileetueejheevveeugfdttddvgfeije
    fhjeetjeduffehkeelkeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeefpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdr
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtoh
    hmpdhrtghpthhtohepmhgrrhgtsehmvghrlhhinhhsrdhorhhg
X-ME-Proxy: <xmx:84ADavRJDnr0E1JVMCpw7esXBpg3Rf6AYeQWxD_kkSMcl12M_JPzDg>
    <xmx:84ADanow2P2F_3-6vm2PdRjdM25uWcM8EcEOyuRz7nAJKtCp9WF6Hg>
    <xmx:84ADahzBo9eBGepirqsXRVRqsjoDnEngtwhrI1s1T4M71J4q9-WOiQ>
    <xmx:84ADasJq26t8EPtij3MjSdAMJkh8XXeGWrqKY4ZXPEfEVdOh9Wos0A>
    <xmx:84ADai2s6h84iuVk9J2O0lil6oeEkaJp8kwrEJrt5IJTEhS5rlsczwXS>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 May 2026 15:35:15 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: marc@merlins.org
Subject: [PATCH 2/4] btrfs: fix squota accounting during enable generation
Date: Tue, 12 May 2026 12:34:54 -0700
Message-ID: <0a1692dd1626e01ab4863e9ca32597bc11794786.1778613519.git.boris@bur.io>
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

The first transaction that enables squotas is special and a bit tricky.
We have to set BTRFS_FS_QUOTA_ENABLED after the transaction to avoid a
deadlock, so any delayed refs that run before we set the bit are not
squota accounted. For data this is fine, we don't get an owner_ref, so
there is no real harm, it's as if the extent predated squotas. However
for metadata, the tree block will have gen == enable_gen so when we free
it later, we will decrement the squota accounting, which can result in
an underflow. Before it is freed, btrfs check shows errors, as we have
mismatched usage between the node generations/owners and the squota
values.

There are two angles to this fix:
1. For extents that come in delayed_refs that run during the
   enable_gen transaction, we must actually set enable_gen to the *next*
   transaction. That is the first transaction that we can really
   properly account in any way.
2. For extents that come in between the end of our transaction handle
   and the time we set the BTRFS_FS_QUOTA_ENABLED bit, we need an
   additional bit, BTRFS_FS_SQUOTA_ENABLING which only affects recording
   squota deltas, so we do pick up those extents. Otherwise, we would
   miss them, even for enable_gen + 1.

Fixes: bd7c1ea3a302 ("btrfs: qgroup: check generation when recording simple quota delta")
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/fs.h     |  1 +
 fs/btrfs/qgroup.c | 31 +++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index f821aa762613..1725611a3450 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -145,6 +145,7 @@ enum {
 	BTRFS_FS_LOG_RECOVERING,
 	BTRFS_FS_OPEN,
 	BTRFS_FS_QUOTA_ENABLED,
+	BTRFS_FS_SQUOTA_ENABLING,
 	BTRFS_FS_UPDATE_UUID_TREE_GEN,
 	BTRFS_FS_CREATING_FREE_SPACE_TREE,
 	BTRFS_FS_BTREE_ERR,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5cd2e0ceb1d8..96746ca19e17 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1107,7 +1107,13 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	if (simple) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE;
 		btrfs_set_fs_incompat(fs_info, SIMPLE_QUOTA);
-		btrfs_set_qgroup_status_enable_gen(leaf, ptr, trans->transid);
+		/*
+		 * Set the enable generation to the next transaction, as we cannot
+		 * ensure that extents written during this transaction will see any
+		 * state we have set here. So we should treat all extents of the
+		 * transaction as coming in before squotas was enabled.
+		 */
+		btrfs_set_qgroup_status_enable_gen(leaf, ptr, trans->transid + 1);
 	} else {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 	}
@@ -1210,7 +1216,15 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 		goto out_free_path;
 	}
 
-	fs_info->qgroup_enable_gen = trans->transid;
+	/*
+	 * Set fs_info->qgroup_enable_gen and BTRFS_FS_SQUOTA_ENABLING
+	 * under the transaction handle. We want to ensure that all extents in
+	 * the next transaction definitely see them.
+	 */
+	if (simple) {
+		fs_info->qgroup_enable_gen = trans->transid + 1;
+		set_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags);
+	}
 
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	/*
@@ -1224,9 +1238,15 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	 */
 	ret = btrfs_commit_transaction(trans);
 	trans = NULL;
+
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
-	if (ret)
+	if (ret) {
+		if (simple) {
+			clear_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags);
+			fs_info->qgroup_enable_gen = 0;
+		}
 		goto out_free_path;
+	}
 
 	/*
 	 * Set quota enabled flag after committing the transaction, to avoid
@@ -1236,6 +1256,8 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	spin_lock(&fs_info->qgroup_lock);
 	fs_info->quota_root = quota_root;
 	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
+	if (simple)
+		clear_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags);
 	spin_unlock(&fs_info->qgroup_lock);
 
 	/* Skip rescan for simple qgroups. */
@@ -4923,7 +4945,8 @@ int btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
 	u64 num_bytes = delta->num_bytes;
 	const int sign = (delta->is_inc ? 1 : -1);
 
-	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_SIMPLE)
+	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_SIMPLE &&
+	    !test_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags))
 		return 0;
 
 	if (!btrfs_is_fstree(root))
-- 
2.54.0

