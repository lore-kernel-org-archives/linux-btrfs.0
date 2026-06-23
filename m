Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F3837B03E
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 22:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782254211; cv=none; b=ADNwRvgJT4/TOIvc4sH9C7WX2ARA4iytlt2s2dlqIm8zCADHVmUfe2g7E+x/QbzjTrirIScadH2YWEZLxIrg1zkMpP26ZWoDx0isJvJ5YjjMFhzpTUK1V4JOL2kbWdYL0TSbPZ1WLwtuf3MrcboQ9tW2vTO74IaZHkmy1hb8drA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782254211; c=relaxed/simple;
	bh=klLSxTLu/4MxKGD4ODmHJs3iICkhs6s7RArJFzPi9yE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeQ4sAL7OJ9+I0ngrAnmTYBBoRb1HdOwt9Vr5j6OCqFuq/VEeJw3le1boQBuhPUQbRhP53QhQryzN/e9C1JWPM7z6T35eSHSIM2Kc2HzVxmh/NQMUMTBszONQuKBFar/IlQb/cIe4a+xoxilQFl+FKFHEBk5DdZCXKfOylInHtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Ib5CHRie; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jjUW8u30; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Ib5CHRie";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jjUW8u30"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id 7B91FEC032B;
	Tue, 23 Jun 2026 18:36:49 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Tue, 23 Jun 2026 18:36:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1782254209; x=
	1782340609; bh=Cy7qpivFe0ZyWn0TcUfiH2Z6AWKKFgqAO+mX7qxVIUg=; b=I
	b5CHRie8Lp1P3QquycHNiew7Hk8qO47Pe+lixJ8k/xUxjcq4tSEaUp6V0Yk36ko9
	sAfURY5E+bYc3p+t4hjhc6QqMibJ56yvaHLdY/PEVUbXAliH2UkW27EWOolI8LBL
	PoWaEGsgJ82EHzBiXk2z0aIxokAHdIX7rXD81dmV269754D36XK1Yuh1iGn/u398
	cq5TvWxMAtoKjua60usFYvWf0xDFviLSWxYnqQfA3uSlpxm5rpuFZlwXds06IdKk
	hh+vjZLSVp/W/L+GPSnmu8nKXde52MBNwW+c4w7ATZezEvFNpRcdBplNg2XSRFID
	Ih2+C+wlqa76zOwt/SnUQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1782254209; x=1782340609; bh=Cy7qpivFe0ZyWn0TcUfiH2Z6AWKK
	FgqAO+mX7qxVIUg=; b=jjUW8u30DLNFRhRvLUmTOjrHOImxOB+nPxbAUGEKQhSv
	K+n6XuLeejEnME3gsetv8nLrJ+uilQsmSLi4WWaMvdxz9mdhKNcDcf1D8nF64Zjs
	4xf6H8aoUKdFxi7IwrwIuZbwIkIQBWe2paRWsRhFmzZ2rFrhHAh6cu6VmfsMg6Dj
	8p82iFO3Z9vqw41AkJKYtRCkMiz4JN+V3sgM0TccXmA6u872fFuRMYaLd93+inJ5
	YXCdvyCyPxJl8dbcZTnNxGurRI5G/hCKnKJTuq+ZslVSr+DPnexn4MQN4HAiDcYP
	0KvJHBge8Fp3IVqVAMXvVkZb0g1q7tF7LwPy17AT2Q==
X-ME-Sender: <xms:gQo7alGh7nQ6EQCL5X-_f90o1_VHHBmLx7FsxlnpsOS9Q3eSvj2cig>
    <xme:gQo7agUVyfsGZsWJM_OtDvj6ajiTxHji4cpi62Yf3DGxt8_3kglU2fIe3IJh3RTmH
    3rXfLhDHz42l4OprSJBonshKfY4kR52AbEJZdmI4kqeVEeoKA3Or4ZG>
X-ME-Received: <xmr:gQo7akxnZchHHoq-RnDrk4TqJSwoWXHW5ItkunGicDzRE43BeULij7xUyvtDccc3e7CkdBA1OYGYNWeiH6cng2vfVI8>
X-ME-Proxy-Cause: dmFkZTG0eSrOaR2/NvW7kOIp6rm2GZD/7MomAFlj8zI4Q6RIHxMgHaQBlid7+eke8OAClh
    3cRciZF4Nzuc9lCg5PeAmS8oBtzDzfmmjL/GBRATujaehT7KSz3pi7OMw/SGzoqiRm8kWF
    DbskeNjKEK2RY+pL59jcwdN9d+f3kZLrnkJWn/pPToXsyu9VJrM/WsG0pSKrTCr1fDu7lZ
    0ZRZ6MczXAPM6DuTtMt8J6zet0k73qu2emXdXVhp7JeDi1UkncliQxQf0Zcywr8nUPEcAX
    LTbVNsuPjbdbi8wazA+POR6Qo4rBUb6zkTl7jjXvfCYGmbfuU5RT2MfoaXCGOj91lO7PhZ
    eu1cn8q6gjBnqWQNIRjMQAOBOe837jPV8D3yY377QY9b2s4lpc3ivvEUwYXx4s9GfMe0MH
    04y2n+S/ywN8RmT8gz6lV4zjZIRCrKflIXyLnKWblzHndVUk/hSg5D0Xv653vDEL49DIke
    kkeP2Bz+8TDVHjpUppj6yIThIOT7Z33vR195HLik3TV8R+JFQkf9A9EBBHywXWZ+nylB9Y
    Yb0LuP1NSVK0IeWvTqFiYd0gS8YGhxNqHs7uas/kkN1qIkoWM1NMwEEmODu4Y5BjeHzLG8
    MSHrKog+n0ufdk8L28vuh2TcioQ/JelSUfFN0uDMvy+pgAAmFWZ2CwIPtWtg
X-ME-Proxy: <xmx:gQo7amOM5bddiaYDGu5Q0l-9eYFibbWYxanrQhSrr5tAPl1VLZDXkg>
    <xmx:gQo7at416LduHp3WjIXQaV33bQRYtIlkJagROV8aSSpmy6RHthz7ZQ>
    <xmx:gQo7avNOhLhzJNix0PhavxvnHYXxetSyVkiUBDd4T2-a6-nrcBtVbQ>
    <xmx:gQo7ajmi3Mw4_N6Ukn20SsSW4tjiWl2LRoFb2hjpsiNPC-L050i8nw>
    <xmx:gQo7airF1PsflhazaoBAk5SYT8Z8wK3tHuIR69qO0KS7T4-_Qx75Upix>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Jun 2026 18:36:49 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 1/5] btrfs: factor init_extent_buffer from __alloc_extent_buffer
Date: Tue, 23 Jun 2026 15:35:36 -0700
Message-ID: <420436ec8cb5db154adfd65cfd5fb350b380a4ec.1782249000.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782249000.git.boris@bur.io>
References: <cover.1782249000.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for preallocating extent_buffer data, factor eb
initialization away from specifically allocating it. This allows us to
allocate the eb, bfs, folios, etc. together in the main search_slot code
paths, but still share initialization code with the dummy/test/clone
allocation paths.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent_io.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0edd532174fa..fa4cc8bcd1af 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3054,12 +3054,9 @@ void btrfs_uninhibit_all_eb_writeback(struct btrfs_trans_handle *trans)
 	xa_destroy(&trans->writeback_inhibited_ebs);
 }
 
-static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
-						   u64 start)
+static void init_extent_buffer(struct btrfs_fs_info *fs_info,
+			       struct extent_buffer *eb, u64 start)
 {
-	struct extent_buffer *eb = NULL;
-
-	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS|__GFP_NOFAIL);
 	eb->start = start;
 	eb->len = fs_info->nodesize;
 	eb->fs_info = fs_info;
@@ -3072,7 +3069,15 @@ static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info
 	refcount_set(&eb->refs, 1);
 
 	ASSERT(eb->len <= BTRFS_MAX_METADATA_BLOCKSIZE);
+}
+
+static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
+						   u64 start)
+{
+	struct extent_buffer *eb;
 
+	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
+	init_extent_buffer(fs_info, eb, start);
 	return eb;
 }
 
@@ -3476,9 +3481,8 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	if (eb)
 		return eb;
 
-	eb = __alloc_extent_buffer(fs_info, start);
-	if (!eb)
-		return ERR_PTR(-ENOMEM);
+	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
+	init_extent_buffer(fs_info, eb, start);
 
 	/*
 	 * The reloc trees are just snapshots, so we need them to appear to be
-- 
2.54.0

