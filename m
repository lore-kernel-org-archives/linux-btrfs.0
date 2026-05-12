Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505273655EB
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 19:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778614519; cv=none; b=DDuieb4r6Lhz6IiVpkHNWL6spnEI7tz4+XADWbkkGezO5C+VcTQnlNZGs4wO0xcEJMlaXQPefeG/tBKvy2sqmCVDhKTRPE+2UonVQEBu4Nlrgjr2whoEKAzKC80nE6c/VWq1eyIj5mQBRpIgEEXmwUmK5OFwPT0jIfKVxatWScQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778614519; c=relaxed/simple;
	bh=4QeGUBm79IDeUkCNfqwdhT+4vhLLYMih4tvBPr8zCi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cE5gwK1u86XiLpbHb8NFbcAIYX83ksg03F9tCPKACRpm+GVb2QCh7esOJ4aYxqSv05l94KHinvDFlh/2tfW2Zl9WiqW6n7IKVlT0YA2r1vNoPk72c13EEWVnJCDocM/kLCy4fhYWh/cpGFnVtC8oEBEBJjGLCgZ6LtYDI8WRNE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=RBAylA2Z; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ICPo58DQ; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="RBAylA2Z";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ICPo58DQ"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id A2D33EC00B3;
	Tue, 12 May 2026 15:35:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 12 May 2026 15:35:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1778614517; x=
	1778700917; bh=Xl2YEVrHzRnGb13MfZG57F4Ru8pfLTNi3kfjDGHKhD8=; b=R
	BAylA2Z90ncmuoV1A+JBWypGQFIaLdr67kruDedQh5zRIDpQ/Quv+cVgN38EpyxG
	F2AOQ8O40gRsujvaP4bfJZHnkMXD+bTEmSDUKoXR0sYVrVgdIGMDUwr3IsxhYlUH
	5iRMrjDZU6siCxpui+HRXvWx6Oe59OsKU8+pXJbVlUYJruANxmJo7e/59FHYyAoQ
	O44w9DM9PpuSd+5Qsr5vjMMgL8730yprV1KOF2EjAbUEvTk23tweroTlVzcgKyre
	Ok8904JvNF3pF8ukDLtevhvpldrUFGbUAhS5R0112YkFY8N/U1tRNApTtNBt10Bu
	VbJzfwfnXJgOj3k1mvWdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1778614517; x=1778700917; bh=X
	l2YEVrHzRnGb13MfZG57F4Ru8pfLTNi3kfjDGHKhD8=; b=ICPo58DQQxQ5DDbot
	6yPG7Y8tZAA2dEbgScRmXS4KxRbaxg+F7IJrQhpTLKoP3LlaMNgdKWt/La0cuxkT
	h9cuQyH9msOBF+fEtl5qE2Ku8Zbco3gKIBYrcRreWPwNOFJMaBjScXGEe/FeCJEc
	XwzdqItDtDBf5zmsvmV6p/f7wQZOEXPzYdtVvyFP45qT3XQ89JG0sL4asoJBD8Vy
	pRE+FfDge+Gt1Lvz7c0V28NBaWs08xWi7uTcgdo3jJfM4atjFPPL4CCS7MMFlWG/
	SY+V7ZycJ6CkLobAAUXmp8UaiZdy3L0jkaN7oOgUmc43Co/KiSrBvg9O2w38h7Sx
	ARDmg==
X-ME-Sender: <xms:9YADaogDe7y6xaBBnxQcjsH_9E9cai2F4rVW7pU904qzVdZCz9g4pw>
    <xme:9YADakS5aiuHQqgE64HXEKnAxLbIiCu-eBwwB0f71Fz_HF1FQ0Su3MOKreVBcWM3i
    fbOsRj3KpPaElNB5JyGAsehYRMr014_MqcI6So43R5Dh-kcklhmDLU>
X-ME-Received: <xmr:9YADaph9XgqUQ3Q1pBqaey5tVhG2UsebavhMzFEWPIJyLBvs8Qy59G_fVGBSFAJio1Jw1X7Z8M-bMI4aAyM06cRt2jM>
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
X-ME-Proxy: <xmx:9YADak6Fk1GIjEogecmTr9RR71pYRcBT8fkzShdq2ukk2P8_drxhRA>
    <xmx:9YADamBXDdj5ble3eLRVNUgmYAQeFOvIj-StwVXmK64ZptCo-yFKaA>
    <xmx:9YADarZ9gTSOfCX8oDFQB8eCGXPpgSV4dDr44FLcjwP1pfDyuxm60g>
    <xmx:9YADahbLCs3SkIy5g9f74EZSDgEzadNzvX_KdRUtrzMZRGDcj7w4cw>
    <xmx:9YADagDKROfkaAPvWrOd6CyqYO48fqrWp63nusk6ICZp0B60hHzVwW8S>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 May 2026 15:35:17 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: marc@merlins.org
Subject: [PATCH 3/4] btrfs: clamp to avoid squota underflow
Date: Tue, 12 May 2026 12:34:55 -0700
Message-ID: <de66dfbdf8abcaba1b16b1779f8718f1583c8f5b.1778613519.git.boris@bur.io>
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

Simple quota accounting can undercount metadata tree block allocations
in certain scenarios. When an undercounted subvolume is deleted and its
tree blocks freed, the free deltas decrement rfer/excl past zero,
wrapping the u64 to a value near U64_MAX.

Once wrapped, can_delete_squota_qgroup() sees non-zero rfer and refuses
to delete the qgroup. The qgroup becomes permanently orphaned in the
quota tree, since there is no subvolume left to generate frees that
would bring the counter back to zero.

While we ultimately want to fix any mis-accounting at the source, it is
also helpful and worthwhile to mitigate the damage by clamping rfer and
excl to zero on underflow rather than allowing the u64 to wrap. This at
least allows us to clean up the messed up qgroups on subvol deletion.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/qgroup.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 96746ca19e17..a93d49015fc7 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4968,8 +4968,19 @@ int btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
 	list_for_each_entry(qg, &qgroup_list, iterator) {
 		struct btrfs_qgroup_list *glist;
 
-		qg->excl += num_bytes * sign;
-		qg->rfer += num_bytes * sign;
+		ASSERT(qg->excl == qg->rfer);
+		if (sign < 0 && qg->excl < num_bytes) {
+			btrfs_warn(fs_info,
+				   "squota underflow qg %hu/%llu excl %llu num_bytes %llu",
+				   btrfs_qgroup_level(qg->qgroupid),
+				   btrfs_qgroup_subvolid(qg->qgroupid),
+				   qg->excl, num_bytes);
+			qg->excl = 0;
+			qg->rfer = 0;
+		} else {
+			qg->excl += num_bytes * sign;
+			qg->rfer += num_bytes * sign;
+		}
 		qgroup_dirty(fs_info, qg);
 
 		list_for_each_entry(glist, &qg->groups, next_group)
-- 
2.54.0

