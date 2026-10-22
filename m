Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792688795;
	b=UNQL3MW5zd94KL6YrD5NRBKEWdJKJS1xcwe+w2D5cJEkUwICJ/fZPk+E9C3jhx3sE5uv
	 if7V+DwlCkJiXNZezOkA40z2fGHnfARpnanUTBk8VnsXiHjCqHzLvaPBIaUY4jIT2Ry5p
	 6rewxDXlZFI74vSr946RIpeXlL33K/iK3e5/ncbkWJ59PYZRiniY30d2YoRyg95lcZVLK
	 oOTiwaAmB06Ohga2fKSRDgvmEERP+qY0m+DU7EeARd2DaAx/ddvmD3LGAoP3AdPCQ/ahp
	 CmFWWfXdWJwb0tLW9ALC4aGvWRol/K8igBeSBJaD8/H9Wts+PkZ2D1qv2Eu9Yot0KXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688795;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=NihY7DTCFeYKtwh8Z9WOj1qWHAq/2T8UcA2ZMYNP0gU=;
	b=yzMru6QVGvvsWfbbVQds2P04HrjYcFGKlp8WGrLs22dmFGeAJr+zl01c8ZU+44NtGcSo
	 FvD8Zt8OvLayJWre6TXqbriPQP2MM9LzWZVZcSH8giB6HbXY7BYdm2cIWj7f3Wog8zQfK
	 w0JJrg5EBk3KnacTJt2g1OcfphXmCv1KNTuHp661aJamK8g9aSIZl2ZNOxJI90Dqs2/Ps
	 1JaBVAvrpnZUPM4AQleZi/R4fP8MJs8KCBtBNPZFkzDnkBtuD3oPd5jBw+XXHPnw1oteF
	 /hklF/dTUUayMi8+apoU0XYaGdH/RxZvM3HQ0nm8YJQwfiTu7alKZ8eIYTEUCiN4vEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=XzxEv3FH;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=PRxozP6A;
	arc=none smtp.remote-ip=103.168.172.147
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABB4606A324
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 17:06:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BABB4606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=XzxEv3FH;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=PRxozP6A
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id EEB99EC0123
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 13:06:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 22 Oct 2026 13:06:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1792688793; x=
	1792775193; bh=NihY7DTCFeYKtwh8Z9WOj1qWHAq/2T8UcA2ZMYNP0gU=; b=X
	zxEv3FHkwii2HD5qb2lRClYIdGLkfatDGJs2vGzm2e8BhgYLgxOt8Y3cA+hCUcbI
	qGHyLD8FmZMtQdI6H+kgJv+her5nrF0d+IFzAvM3Rzgq9ihyL7/1hT+TG9QcfeJv
	wMCzbrSEnBTU/wBNJeMtwv/DfsmjU58AjbcxMeCVxL5i5GcOQKyAqs4LbHH8s6Yq
	y5z24daqyYVmMwitWIA3ydz5IZW3TrbGIm6w6nNSVQPsSzJ+cDxnUR0qmgDUkWbo
	F7a1G1kB7k9Vk6UYcb9j6ZCOflmN78JZOERij2vsHALr3bfs4dP3Jx6lO+7sWnZK
	3DiFk/iGZv89pw1MMrdMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1792688793; x=1792775193; bh=NihY7DTCFeYKtwh8Z9WOj1qWHAq/
	2T8UcA2ZMYNP0gU=; b=PRxozP6ArhbqoU1nBiZ+Uz1Md6uRXsmv8Vows0VbB8PV
	hnNP2zhkO+ALiyOib0cFNw5HCakZYHONOfgUJMV6y6IITmMf/0uNdJsZJoli3j/J
	tG9nvHxz2m2DZm3B76pA9BvWLMlaGSGDxPw0bleYqbONWNaezp7lhhkwMPX/y3nm
	7TH7nmNI/EgWWCzv7o5reg5hKz0T/Mv2ULHO2fabnmIG3eHM4vXzcg9g9WDypUy1
	3kI3v8sas9JE0FV4LAOHwdxGZxkwaEQSy1u6hElGrQk37RIBftZvkhulpMnc02UG
	XjNMObz1TakcYSf9IZV54sVza6f5HjUB7URLAqoNEg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792688793; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm3:rsa-sha256:y3Scn4iO4REYReyge7mV+yTdslj31pad5Uw2+23Sw8ESfF0
	qwoW9kG/F6YGQrxvnBKdGrgsQIC6qCU/P0hc73dkueg8Ql1IHGg24xfv+oJ8xtEa
	gu5karKm0XEvITb/a9KvfPMh6li6EhLRVRgY6KLqYL1UUK8w+NrXg2tFsJCLbbbO
	ucUPCyNlUd+n03+iCQgrUiLVvxNy8/Ec6w1Ml22vCkcxwwon+/elUjYj0IsxD9XS
	pqK4LZDDef6EbB/fcaFGnzk4laPAuvAJZY9NakIDBg1U3JvVuFHPwyf9mWLpOMKF
	T8pvdyvfNT1Zy4r1P1Gnm4+EHwijc1cqUqPI9gQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=content-transfer-encoding,date,feedback-id,from,in-reply-to,
	message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:7/Q94EQwbvf6gpewadWXQaacOeciA8PHZCIH3JwUfk0=:gODwWdoPez3SA9p7rDFzcSgmz7348yx6xJ3HN6tze5c=;
X-ME-Sender: <xms:mULaaohD658vLdD1UVXczr0zipE3ZlaxEUcEzV3UPq4sI8Z9KX7x4A>
    <xme:mULaanCQy3-DJ6R7YcDQcP8Lg84momySYWaW84jSGo_6wnKmtFEskNvCZ06jNVm2H
    vTqwdoAhyuNbFQa573ucx4ScKPz5i8gS6Oa_jI9l1lJxXeCsWF-3ZQF>
X-ME-Received: <xmr:mULaatsV-sgX2fBCf8sUVKDTuGjONX-fdQ7PCg7oPnPuUA-JOoG0iF-_>
X-ME-Proxy-Cause: dmFkZTEe4W4ijRj8LZWD4Lo9X8GUtUjJiOBEFgPoavKCOJyoNm0WKmUICZqjwAr1fZEtzN
    wX9psAuB6tGQcZKT04iwQ+nzS1nXqKBzO4k7TataXP7fQkA2HyVZ2udM8mwy84Ds+Oxk82
    /C5tnpFc/t9o1GhxCHWBjcvs0TX5V1ixUkXuiT5gcSJTdP1VU+IXQ7UmaSJRUsfJxTTgmk
    a0eZ4LANsWxq1NCnYhrjdh0JSaR2kq3OvXMAGUryItB1L+2jmIPVcVltxBrTsxaDNpZCxy
    iGE4xsxYB+SVoTBf5HYE6bbggKmUDOCKzyfNCMaar8wuusR9vJhsSaHMSh49K56q6PNmt8
    p+VuycgRoOnv8eIcA0QeMly1Hinb6RLZlQkDeMS+4vPqTpfFHmhcdOYLyqhC8bEUqTCgmv
    b5hw5F+z1O+zkkNKe/m0HeMlHax1dfhJiWqMIJ6MSLqErrBks/3UbGYOSqI89IDWyAR1GR
    A/U2OfkkusL/zhHCzWcRhgSZZ2IIEQ4ZZln1KWGpsA9LHlVM3xkSsWY8AS87EwpwLmlKht
    HBbKRnRlys8qnGxoCatTzZO1v1gHR1aAidhd1n7xb9KhNmMhnStLqbr1NZsYCM85am0LgF
    CT5I7oBFfWRTDTVWyTVbXPEmy0iaPRg96jzilaSELLq/WdEeVlnLCBGFLPiA
X-ME-Proxy: <xmx:mULaakZZ3HkYGQD1YlqvnIlvq3EPPIsDr-pcOIFXgiCJ-X0xXYecrw>
    <xmx:mULaaoVkVcVBWCVSKhE5j2-Zz3PayJVpyHLudaDGt1hnrZKt3NtKRA>
    <xmx:mULaag4231tJMV4xieS74uYb5SBLimJ6VyDVR75Vu8yEZjDpBj-w4g>
    <xmx:mULaarhKF30ijjUwczKS49cwKN3qHw1uuAyDFCgOoCOQ0z-umD-r0Q>
    <xmx:mULaaqjetLnn0v2Jm8kY4bh3j4OiaqGP_gSFx8Nuy1bStfjzKtgG-_qH>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 13:06:33 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 3/7] btrfs: remove redundant checks in find_free_extent() hint path
Date: Thu, 22 Oct 2026 10:07:01 -0700
Message-ID: <a0dee21cc7589d568fb82101532e171e830eaad0.1792688736.git.boris@bur.io>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792688736.git.boris@bur.io>
References: <cover.1792688736.git.boris@bur.io>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hint is a long lasting loose reference to a block group which can
outlast the block group or race its destruction. Therefore, using it
from the hint must check that it is still attached to the list of block
groups. However, the other checks are not special to hints and can be
shared with block groups reached normally. So make the hint path check
only the thing that is truly relevant to hints.

Assisted-by: LLM
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent-tree.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2c06d3f17746..afa9332ee2ec 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4640,12 +4640,10 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		    block_group->space_info == space_info &&
 		    block_group->cached != BTRFS_CACHE_NO) {
 			down_read(&space_info->groups_sem);
-			if (list_empty(&block_group->list) ||
-			    block_group->ro ||
-			    (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)) {
+			if (list_empty(&block_group->list)) {
 				/*
 				 * someone is removing this block group,
-				 * we can't jump into the have_block_group
+				 * we can't jump into the check_block_group
 				 * target because our list pointers are not
 				 * valid
 				 */
@@ -4655,10 +4653,8 @@ static noinline int find_free_extent(struct btrfs_root *root,
 				ffe_ctl->index = btrfs_bg_flags_to_raid_index(
 							block_group->flags);
 				btrfs_put_block_group(block_group);
-				btrfs_lock_block_group(block_group,
-						       ffe_ctl->delalloc);
 				ffe_ctl->hinted = true;
-				goto have_block_group;
+				goto check_block_group;
 			}
 		} else if (block_group) {
 			btrfs_put_block_group(block_group);
@@ -4676,6 +4672,8 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		struct btrfs_block_group *bg_ret;
 
 		ffe_ctl->hinted = false;
+		ffe_ctl->search_start = block_group->start;
+check_block_group:
 		/* If the block group is read-only, we can skip it entirely. */
 		if (unlikely(block_group->ro ||
 			     (block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED))) {
@@ -4687,7 +4685,6 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		}
 
 		btrfs_lock_block_group(block_group, ffe_ctl->delalloc);
-		ffe_ctl->search_start = block_group->start;
 
 		/*
 		 * this can happen if we end up cycling through all the
-- 
2.56.0

