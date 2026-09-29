Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB2A49620
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 00:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641704; cv=none; b=kD66LjBaVrWYXrp8tcsGbiVhr5oa4ZIMolAPhYi+n2A/Ho/af5hThN1nyfuDyXvnz4BoaD5oBDwQDAk1NtnbCUjOpCIquTBoZyp57W/AjvxEekWh9rhMrU+60IgTQo9JmIB2xCsQGMVgcxTW/FmO7CW6XQuszMhlkt1ZmERlu4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641704; c=relaxed/simple;
	bh=IVUvgINjICdCTj2eHNGN6UE91EA04gkcbryRkXZDc5I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUAnVzGTGpe2uX7iLzaoI1VlBN5MpPcK7Rt6kDZO9Ctnyde2oBMAvqUdyHUkDBlEzsTzEj8lluUMEnOQeNPCqllC/p0+ALBSrGFMlWIHuZhJ/y25onfeAVx80dVjyN5EStcQ+6SribRc2hY1jqZ6JUcAx7Sb0ATBmAVatkVLMao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=b/k56M1l; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=wnG9e7H8; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="b/k56M1l";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wnG9e7H8"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 81DEEEC0174;
	Mon, 28 Sep 2026 20:28:22 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 28 Sep 2026 20:28:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1790641702; x=
	1790728102; bh=37qC+qjz/xTh29tTGvKdBxySB/f0KRcdEeTXv4XJF98=; b=b
	/k56M1lYrZHlVVAa44XCJkldYluRnZRfsqGX+ktVm8VnXIVhmKdnKd+MmBf9w+ly
	B5NcJUvQFLCKbaG8FKpYnBtcHcrkKtcptMRLnA21Mn23rXUhQKiW89HvlQh+n3Gx
	Ow2J8hofZH0BUENCoQ5cF2dvHeal3mGoSGk9+F1JQBtKz3eJxa6opEpTZ/zWOyV7
	gZzlfB3fiwd1f88QxWD3qDFat0j3Mxy2El9YPj5XEbtSE/SH959/1GnSk9FoKMPw
	r23iO2FOLqd2UzNqnu7cK4duqgLg7RHi9Watxi4OGJYvQ0qovhL2EYhetG6MJxq9
	13ZdQDCT0nByyh9Oetaxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790641702; x=1790728102; bh=37qC+qjz/xTh29tTGvKdBxySB/f0
	KRcdEeTXv4XJF98=; b=wnG9e7H814Gi99Moe5fzVgcv8SqB0gWCa6R8I6tM9GlE
	ykSq0DNtuiu5s5REM8xLUA7FvDWEJRPOLpHFEUruxTMrZDQLtePTaA84ON5xVLN9
	+Cx43hHjCNGh4Lh/7ncn22mVhRNqD8Bh3W2Qr4qavVYzsLOzDq37Yp3+oHEWdvFI
	342qNnSlzBncpO2R2hOfbpU3+r6A4H5I2eNpieHZbd0URJ5S3XhOB6D/W4q/gesF
	/Xqa3aRYfN32Dw5vBelHkdfFOj+ikMHMCbhmu685H7cDT4aiAzkoRjIMFbpeu8qE
	vAFcfTYeX8uznRm6QUgAHE7G6shzSDBSb3FEF4JzDQ==
X-ME-Sender: <xms:Jga7aqwbk9cYE56ntNkuLsjln-54nVgGJ30jaueC2vPjkF7QqHc7uw>
    <xme:Jga7asTvondGOL5mEwBwnfseCS2nif4P4jX0SZsgl-ktmCAyNMwPHxAlgLYhRO5WE
    BK4N8KA-7J_XB_pVJAv33Xa8lWTrTvliNSVpf56xx39MFtD2SXAeTDK>
X-ME-Received: <xmr:Jga7ap8kw4jp5MoCSd6-yRdE2a3rT-8lOY9AB3fLnr3L6PwclYXncvo>
X-ME-Proxy-Cause: dmFkZTExuF93JGdXfiGgW7nhIqu51hI8C5kNPxAejyYwywaiQdYYJWeJi45RH2Q3gCPa55
    VjA+ay/YFd/3pyl8KBeEfpt9QEJvrAosJUDjL4V6R+2haUET5XnHu73J4Q5b45C4HB/iIz
    RNT2T1+2L2LIxqlgyrrQlkjjODfNAxhX0/mc/NasjTh10Z3dHNiS/LO8GoXPoTpyRa+/jQ
    eSwiMTT1t6iRITMpyX7CIBaOxBehrbpLtNmxtIblZXMQrQUB1/pzyoZXtqtaUj7R82UdMI
    6d9FjH8VfZhN/8J8o+38loyKAtAaePXcnHUstIw4xJhFl+boltZk+r8HvaJoa84gUlwKRh
    1iXM96WozZ+DwdxAjuRk27QNMfn2oTrfBrXumGRe/shLAzynpTHj13XFWrLJJ6YJW/I41d
    0vdybWDdH70CaLohKC1DChMnKmAhvDDedin91/Ov3CBs7NZ/CMLeO4lRNutMgc1zZgfBw6
    IqfLW6oaaHa5k5idhUNE98g6N0E+6WKFh4wrSiNPEcFgTQX6Hv0afw5GmRX9Jp5lO8oaob
    tYZgufrOC0yvZFtaR6hHxh1oyDeKbzTqWwq0qR3mOZrEWuceXXTGoCIXS9zteLdumdMI7+
    CHQAJYjiCF14aTrg3faOpy4slTia3eIKK06kFHO5vNplZpceufzkrZNECz1g
X-ME-Proxy: <xmx:Jga7arq6a1oH5zaWU2gFzNnhlS0v_X2rtlV9g6fkTwEjHMdb7Se9zw>
    <xmx:Jga7auka4KIOV8ak5RvtVyDITmWFdzW7gNXdKVQiqbdiDdQn-V7dDg>
    <xmx:Jga7aqK2_Ct46lcNWlmeVsnS0XmawEmL4IbuN6DAIGL4x86EKZphMQ>
    <xmx:Jga7arwBnHuz5IC7rS9SmXsBVCDtq1m9-cAmhL6aY-pOV1ksU6bvnA>
    <xmx:Jga7asxp8kNl6gUA0fLyw_KwIoRntH8iDRkr0BClmdCzq4Eip-qIO5T_>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 20:28:22 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 4/6] btrfs: factor the find_free_extent() block group skip into a helper
Date: Mon, 28 Sep 2026 17:28:05 -0700
Message-ID: <2fadeb4d674909534bd0ca44be25d6f3a97b7224.1790641462.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790641462.git.boris@bur.io>
References: <cover.1790641462.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

find_free_extent() is already quite unwieldy so I believe a well defined
"usability check" is a helpful thing to pull out into a named static
function just to break things down into easier to grok components.

No functional change.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent-tree.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c4f46d361b0b..01cab703ef3b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4321,6 +4321,18 @@ static int can_allocate_chunk(struct btrfs_fs_info *fs_info,
 	}
 }
 
+static bool find_free_extent_skip_block_group(struct btrfs_block_group *block_group,
+					      struct find_free_extent_ctl *ffe_ctl)
+{
+	if (likely(!block_group->ro && !(block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)))
+		return false;
+	if (ffe_ctl->for_treelog)
+		btrfs_clear_treelog_bg(block_group);
+	if (ffe_ctl->for_data_reloc)
+		btrfs_clear_data_reloc_bg(block_group);
+	return true;
+}
+
 /*
  * Return >0 means caller needs to re-search for free extent
  * Return 0 means we have the needed free extent.
@@ -4678,15 +4690,8 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		ffe_ctl->hinted = false;
 		ffe_ctl->search_start = block_group->start;
 check_block_group:
-		/* If the block group is read-only, we can skip it entirely. */
-		if (unlikely(block_group->ro ||
-			     (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED))) {
-			if (ffe_ctl->for_treelog)
-				btrfs_clear_treelog_bg(block_group);
-			if (ffe_ctl->for_data_reloc)
-				btrfs_clear_data_reloc_bg(block_group);
+		if (find_free_extent_skip_block_group(block_group, ffe_ctl))
 			continue;
-		}
 
 		btrfs_lock_block_group(block_group, ffe_ctl->delalloc);
 
-- 
2.55.0

