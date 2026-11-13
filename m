Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.143
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794611360;
	b=NXHcXJG5davGtlIlaqUjgiiq/fMlqSAun2pqECdVlaxJfayRTominfhgxN1X8S7mInkm
	 6LiiZsaOtwEoo+anSNjICkumj98gUmpCOyDvJxcMzpItzwmJnuvB4WnPapsMztIQnUrUq
	 FBlxp7n5YcZqJHAPDovmcoQN49JuKA5nWTGvHN2PY2pd5LtDlm2MQ13H49iSVqXN+OSJO
	 8FcsjGxucAdS286ebdTGKIcH/1VR5p/z3N11VARZth/ksgwbLYvx7k3R/O8BdnikvW2XT
	 BQoB9Hu82gW0Jd/0BYBc9LAqOGUrlVSk9adnocZAlEP5xwpVVytjVKXCtgAjc0qAhnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794611360;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dXUVmClAerQStwMRhr7jHkDQDMrDs46ErUYnzXeENmA=;
	b=L1KPLG4vtRbYdBYT2l6xrqr+AYdZttwPPV3a/x81En6hkJ84d/IyK2MHz/g9op94OoVT
	 9+95aPQe0M8NbA48icpNyDP24kX7pogbJyPDJ6Gy4QRIYvy4iEPymr4K7eMa8hobSJH3S
	 9MIK1DfzuXTd12RqJukKVZyXrPaDoTnBFdYu86h9bdidySCI450NL0adNVIfvBPhncEvu
	 5LwVpd2a++hV/aaIX/3VvkUOakPBuxVhP9X4670TV1/t1q7JsLpe9qc86ALtULUDyHJpm
	 cdEjfjG7xB463YXawy2n9kWWkOFuH5xN3PWzdd21bDoHOZn8t15vOsNH4mH+dRCOcUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=G6NYG45c;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=uCcs5AfI;
	arc=none smtp.remote-ip=103.168.172.143
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEC1606A32D
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 23:09:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CEC1606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=G6NYG45c;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=uCcs5AfI
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id AE88B138146E
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 18:09:18 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 13 Nov 2026 18:09:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1794611358; x=1794618558; bh=dXUVmClAerQStwMRhr7jH
	kDQDMrDs46ErUYnzXeENmA=; b=G6NYG45c/ecapqTIdpd1zIeU5dxYWFdj2DPkd
	NuIaVLmeGjVSrGdHyHxoPd33cjEWtKd2L6aBzqyqmvLQaVzgP2d7zl03eJrr04xU
	/kXQy+OXyUwkI6kU4bVmE7H/moh9iLc6v5x8NorF9qktY7LUF0vU+iZg5qwg1WjK
	1L3Rk+nZLkpqMXBPmNg7sJ1kJHHDktlTgNImoOLPiWfMmPHip01+KmrG0WWduzL4
	4DkEoZUG15M5zW4TLHHt2GQFaSh7DuCGAhpgRBthv7QM2vCsk2hx8uzfVwtnMHpF
	AzSeIOVbDIFz6vfvkOhCJn6+ADxapd4rhJSQBYKBOuHEbqv7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794611358; x=1794618558; bh=dXUVmClAerQStwMRhr7jHkDQDMrDs46ErUY
	nzXeENmA=; b=uCcs5AfITL5/QOX/iH4lAX9R0nmenWh47H8ivYKjCBHg6Jux58p
	I55ABCnRqf5lblrChI9fAarUIQWI0YewtkxmrRhGV2w2fvwIFx5E+/+hT/Bz9Bak
	w75DfiC5RRIbyP6KUPKfA9AYx7WiOTavUxDT/R9ALoodPKnW92Tdpw87wIPE6vkF
	f+3j47gQlNnE8TlH8oEymDzPyKdLk6dUyEQilJ8djDC5gDOGHgZkq4GTWzlTQrWa
	T/iZKYPNWyU2VG9XxTyIyxyRU52Xw4ywBPLp4baotb03S8kv5HAeBmDXcM8CbIBN
	jKms016/00rsfy/LHUPx7HTmZSCJX2VZWVA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794611358; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:M5c2fNSuGzNo8irloI8pIa0AA7W/A6wJe6c+CgEsZUeAcXT
	jZQElkQKuIxsplOC9VrF8pS2iI0ONDVpqy3ehCjYO0GrB6eln14C//yR+peAcjx6
	VvWy3D620SmibfFDO3zA9OWc5nWprTtTpxbZ2L4xaxI+AhX2Qg07ZbljBvVpFEOR
	53gs1hxbVzCf30pErFSO9JH6J9s3MGBS4O0jkg4gx/ErcvQPWXROuEPbNWl7TGWb
	n3aZHnijQSZlJxpxMpGvpfpy0T5fgnBV3R0M40aj+YwTgg5+Dh+B3egK0+IFCv6V
	iXcDp1+HI5tVgtZRpW1gvVuV6GdfWrJ0wAnpF8A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=8;
	hn=content-transfer-encoding,date,feedback-id,from,message-id,
	mime-version,subject,to;
Message-Instance: m=1; h=sha256:JPswH+IWwLk3DLxo+AQ+9yV8dvp6dlDJV/KBLBaNwBE=:Jek1CESGgGvXtdFOxxkz/VgH/LnSYPkYl83gjBoF5UY=;
X-ME-Sender: <xms:npj3aud_tyTb3_axbhHVQFSxNz4BlDLcGy1nJd8Q8dF84KpXvY8yOg>
    <xme:npj3auOekpIA167Ucr8JKIvbJwl1lULsBGIUoWYF37tMpomCgw0PBIxD-_ryq3YU9
    CjMInOhv-vjc7ZAfiQhyes8tGq1DC6chK7p9nPrLEOMWSt-YFHDV7tf>
X-ME-Received: <xmr:npj3atKOuqp_Too9qX8E85MmrYy2-t_v7D7sGvtfEOFZwkDlb9CDWjKi>
X-ME-Proxy-Cause: dmFkZTEJn7Nx+5IAa4dkhN4x/AA7KJoxoDt9mTAbk3l32yJ4JRTRmg3eIdCNkqVe3vKCN1
    HtXiVXekDaZWVmLQeRO4MI0JsQbxlTP1jXyG2uZqP/W2Trvi/OSDMnz9rZGKp8Sfs2dKrr
    gutKtaIDFsTptnQfmRjOsCTUBmssgr+lyr8Rzvh/FHXjqrhVJSHJRDdxYM5ywl1v88RoAS
    h0r9+XidrWaAjMA7G2h4J+C2BwBt0CTLz7R9uhCB2IIMAzwDmWVpn2ejoz6UrOGZcwkyKA
    1UDGkhsiSca0rQnBud7qOTwsC9VkJnlUcIPF0QkQE4n5M+q9QFBL+a+tyrNl+N7RCY4eAW
    ZiguyYoZhk0KGCKzKMDGSDLy+xgLk2Dg3UlMsrEeok+97237cKuKpc0Zg6mOiQhLFP1ErS
    WV5aNzdrIrzUXtIqUp60e8lIFoGOmndfqTI8JgGowF7kz/Unxf9pnFoRxJT9JFHQxtm/aT
    XyPxSYIAOuVO3MAxslgA/lkMHF7xDJNwbRn/7ELZj6xfwtZRjP46QPqt9eX5rKfv8sfVbm
    gPrIojMDsteoaHifXQ4072cVtCS7EWr41UcOEGaWPjsETOfeAAAjUE6x7G0WYyzhrLt1wf
    prMfRFMTZ7IWpPxHiAFwHOJvMGnuwENNBTcJfyVtXOt8jiwtv64dZXirldsA
X-ME-Proxy: <xmx:npj3anHEMTv41UBwmHJMPM3bO2U0ulb5IdJBkE2xKdPSWP_WWQ6ziA>
    <xmx:npj3atSnoOrLDKnHR964okx0hU3o64Zta_JlyVVx9jWnj5aKWsoPNA>
    <xmx:npj3arHYN2raq8o9IqjKiFgjH0JTK2LmMgIInzmkIsgayW0vRVNopw>
    <xmx:npj3ah_8NoNbmFBaKprScTcc5Jyv1ZeiJVUjRiP-F3QA8MH2VnJUog>
    <xmx:npj3av08KzMK-UsfJipWtBggcqH5fRguSY1Ago6VIOyXFtQm1mu9odTU>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Nov 2026 18:09:18 -0500 (EST)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH] btrfs: fix double release of data space on failed direct IO COW write
Date: Fri, 13 Nov 2026 15:09:19 -0800
Message-ID: <07cff240bcc00f2c18128d339ca6f1544871cdd1.1794611345.git.boris@bur.io>
X-Mailer: git-send-email 2.56.0
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

btrfs_dio_iomap_begin() reserves data space for the whole range
(data_alloc_len) before locking it. For a COW write,
btrfs_new_extent_direct() then converts len of that reservation into a
reserved extent: btrfs_reserve_extent() -> btrfs_add_reserved_bytes()
moves it from bytes_may_use to bytes_reserved. If
btrfs_create_dio_extent() fails after that (ENOMEM allocating the extent
map or the ordered extent), btrfs_new_extent_direct() frees the reserved
extent, which only drops bytes_reserved, and the error propagates to the
err label of btrfs_dio_iomap_begin(), which releases all of
data_alloc_len from bytes_may_use. The len the extent consumed is
released twice.

The success path knows the extent consumed len and releases only
data_alloc_len - len. Make the error path do the same: record in
dio_data how much btrfs_reserve_extent() consumed and release only the
rest from bytes_may_use. The qgroup reservation is still freed for the
whole range: alloc_ordered_extent() either had not released it yet, or
released it and freed it on its own error path, and
btrfs_qgroup_free_data() frees only what is still reserved.

On an otherwise idle filesystem the second release underflows
bytes_may_use at once and btrfs_space_info_update_bytes_may_use() warns
and clamps it to zero. With other reservations outstanding nothing
underflows; the extra release takes len out of another reservation and
the deficit surfaces only when that one is released.

Reproduced with fail_function injecting -ENOMEM into
btrfs_alloc_ordered_extent() for one O_DIRECT 1M write to a new file on
a fresh filesystem, where data bytes_may_use is 0 before the write:

  WARNING: fs/btrfs/space-info.h:282 at btrfs_free_reserved_data_space_noquota+0x218/0x290 [btrfs]
  Call Trace:
   btrfs_free_reserved_data_space+0x47/0x70 [btrfs]
   btrfs_dio_iomap_next+0x7f7/0xd80 [btrfs]
   iomap_iter+0x57/0x3f0
   __iomap_dio_rw+0x24b/0x930
   btrfs_direct_write+0x258/0x530 [btrfs]

The error path this patch changes was rewritten in v5.19 by
commit f5585f4f0ef5 ("btrfs: fix deadlock between concurrent dio writes when low on free data space")
so this patch can apply to stable kernels later than that.

I was inspired to notice this by:
Link: https://lore.kernel.org/linux-btrfs/20261113170926.1468850-1-vlad.wing@gmail.com/T/#u

Fixes: 18513091af94 ("btrfs: update btrfs_space_info's bytes_may_use timely")
CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/direct-io.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 45197d1e0d82..be850dfe22c1 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -12,11 +12,13 @@
 #include "volumes.h"
 #include "bio.h"
 #include "ordered-data.h"
+#include "qgroup.h"
 
 struct btrfs_dio_data {
 	loff_t old_isize;
 	struct extent_changeset *data_reserved;
 	struct btrfs_ordered_extent *ordered;
+	u64 data_space_consumed;
 	bool data_space_reserved;
 	bool nocow_done;
 	bool updated_isize;
@@ -195,6 +197,7 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
 	}
 	if (ret)
 		return ERR_PTR(ret);
+	dio_data->data_space_consumed = ins.offset;
 
 	file_extent.disk_bytenr = ins.objectid;
 	file_extent.disk_num_bytes = ins.offset;
@@ -610,9 +613,13 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
 			       EXTENT_LOCKED | EXTENT_DIO_LOCKED, &cached_state);
 err:
 	if (dio_data->data_space_reserved) {
-		btrfs_free_reserved_data_space(BTRFS_I(inode),
-					       dio_data->data_reserved,
-					       start, data_alloc_len);
+		const u64 consumed = dio_data->data_space_consumed;
+
+		if (consumed < data_alloc_len)
+			btrfs_free_reserved_data_space_noquota(BTRFS_I(inode),
+						data_alloc_len - consumed);
+		btrfs_qgroup_free_data(BTRFS_I(inode), dio_data->data_reserved,
+				       start, data_alloc_len, NULL);
 		extent_changeset_free(dio_data->data_reserved);
 	}
 
-- 
2.56.0

