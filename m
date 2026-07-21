Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF5843F4C3
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 22:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673773; cv=none; b=S9BLS/e+n3yf4FhOujd508beOIsBeHX7eUFC7M61wYrZf3bOgqycLWAo7NOq3ayOY6FzNzklRUwmOLvZTYJwhdXixBifBW4bRx0VtXDF3Ph7dunkPoU/kWpQAKCJOS/mnBwtjg5mRXond0NDr4k949FzfjoW1RU+acfogBmkwNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673773; c=relaxed/simple;
	bh=y83VL+OO4zzC7k0PsJkmBOBZpUv2xpZsnCu3MmO2HqU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FefqWPBukNYEf4NmmZi00NJbueyr5yTurPqL/l0Z+0mRf7V1FlOLtuWN0kuY5emoi4m45iM99Iwjo7tf8vVJKwfmnJ7a08uyUhYKenhTrID/1bzv8/2PzEbWpf6EtMR2Y8QZsJmx4QF6k7H2whk3lv856vgW+dUDpPqt/FLSO/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=F9dkmA64; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KpZdnAHz; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="F9dkmA64";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KpZdnAHz"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id D9D171D00094;
	Tue, 21 Jul 2026 18:42:51 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 21 Jul 2026 18:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784673771; x=
	1784760171; bh=AN5NmaSxKjd3jTIuEf3g+ncTMxL1e10sXbBIh5Sv0MQ=; b=F
	9dkmA64YVJZmmymrUtCR/yq8OgML1pGNBfeyBjTTQgT3A6j677yOSBTOCmVwUjHo
	hty4Fm6JXLmA1eXSgOcqczx9F0dg6jq4iq2QnREV/WsgPoW3EoRVYkae3CZwinMb
	iWRw9UBEKJ9/o0dHMtvoCi+o4Gl2BVGnG9VSWhOJUvVVdj+cqR7VRpWg2OR3VWyD
	dvQFdlrngKnVH08ZMDllGAoA+n39oxIbg8+1oqmzgOpDTH883bKFPXw4QaIQn5QK
	LvezCsr5uKdzNw5HXkQKVIA761PqdynhnDP53Y8WfDSKtLP25QVekjDsQHLiMWOG
	vBirmEG4AO92OcAmPEY7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1784673771; x=1784760171; bh=AN5NmaSxKjd3jTIuEf3g+ncTMxL1
	e10sXbBIh5Sv0MQ=; b=KpZdnAHzTRaZ+7SCrDVRxYNn8UIT37M3NGazgdWntxjM
	Tu+8cKnmkyMEAVgD4A/yIra6wtmf5n3SMMyXyQtDPjD5IVGvy+mD/9wruE6RCONb
	jrfqOavkhMj1e4ply8AQypUN412onX5llcsXItGz0LqMjny6bXgvMwkghEB+ioq5
	5gYpP1fgy7zNSV6C7XCc4pZFD3tbnP51CcOBcuhIjDT2URmDnPlSZp37QAArK+/x
	RMkIQ9Aa9UE3ENYbEBI6zqKQCLg3j037daesX3iJaV997Ps+kBLJP7kLcRkw377/
	Bk+ugyWSy6UDE9ADeNH4LEVnMO9EMdFzBXLJmrpwvg==
X-ME-Sender: <xms:6_VfauPesqsu3OiaLjJD0XczyU98em2NoVs-D0OXTIdUOvEGVQ5ibA>
    <xme:6_Vfai94QPvfaewmDU9M30YiiNOaUorIG_sS_ew6xrlntRS0hnG9HfS6CWSRxwkTr
    MOZBCTPuJVndYmUAHh8rJeDD7up0QujhzN2pufx3zh6hZfCKzUtcw>
X-ME-Received: <xmr:6_Vfai5cCqjVFQ2nAax7GkSvaaLKQzrGlQqHSXUUQMCPk9ZfHAPpRh9Bar6xurY9PtIX0QFK56fz9Okrl4BGUY1zL8c>
X-ME-Proxy-Cause: dmFkZTGBCwxC6oMW01w8JBsONjbwY2XazUSqlhI6hsJJIXJJtbpNM1XHpACObMIF+Q8TzE
    BNuxVp6FNKpEGztukwDgpIlZf90ekeUh1++e8QpTGVO6iIYIzz3RryAtQgBaP+QCD+1IZi
    nlkpOX29IfID919nzPkm+9/IFOg0SyJiHDCKarkFzScQuTg5PDU1Zm6Y29Is7Oy8nRrbW2
    2wv8Ux/xSLsS7mglqFBisgL2s75saNK6tG9X8GqWRjFSj+qdfRMb1NxUF7RuFdhmK7Kfq8
    Tdxefors63EMWTocRgRAHx03tZaf+jgfkJNohVnh16ID5ji+8RLeAqZI5Fz/WfymzsnLRX
    UokJBA3wXC4xcgXiUcQ9uQtkPYnAjSdAP5y6x24mCV43kGGo5tMshUJz3NpZNgKh8IKoj/
    MrwBX5qqQZIhziU+jEQJSMd9Tddq85ej3jD3+FLToqgkI/j+kOac6/+xusL4n/mt1mHLJb
    XD/7uDT1pHDUhVb3ugUVhKD0VEUSi0HAHpyv2D5+en0c9du33o54G6C3sdW9hGoWyjleX2
    BNVj6dtCMInVbIuc0s2leSHo5RYcPxEWT8fpoePZyRkgqLMXBf5m/HFcPv7H/QVzQP+hZX
    WeolXX5En+FWtYH4mo/YBAGednMmw/nv2AWPWOQBb/pR/UI+y1nvMjnvvVpw
X-ME-Proxy: <xmx:6_Vfap3cfOH7JLupDgaFDC1hDDTBTUY9IB-c5dy6Gm-r4C6OWHT6Mw>
    <xmx:6_VfapB64aAWnqWpxVTjRUGDyi70qzrfm8Uur2EsOt7txHf85YXYfw>
    <xmx:6_Vfar16do5d16ZVu3YJ301yYBKYhVpIeKZ7Fx3_q5Kw0qU0jw06Ng>
    <xmx:6_VfajvDiALi8_1GUh80tZp0JgnsscyPaVJt9ruGdc250xjrO34NTw>
    <xmx:6_VfatxKmOczzL9piutgrVQM7SuxpMqXjdOnTL0hqwO8SIj2cNPik8nV>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Jul 2026 18:42:51 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 4/4] btrfs: use GFP_NOWAIT for tree block readahead
Date: Tue, 21 Jul 2026 15:42:15 -0700
Message-ID: <ee8a445ea0791b92cb4902ef8cc5da531f5a12bd.1784673567.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1784673567.git.boris@bur.io>
References: <cover.1784673567.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

extent_buffer readahead should not be able to painfully stall a
search_slot and hog tree locks by getting stuck in direct reclaim.

If the allocation fails, that is fine, we simply fail to do the
readahead in that case.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent_io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1a40250e1e83..3c014bd653ae 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4814,7 +4814,8 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
 		.level = level,
 		.transid = gen
 	};
-	struct btrfs_eb_prealloc pa = { 0 };
+	/* Readahead is best effort so prefer to fail rather than block in reclaim. */
+	struct btrfs_eb_prealloc pa = { .supports_nowait = true };
 	struct extent_buffer *eb;
 	int ret;
 
-- 
2.55.0

