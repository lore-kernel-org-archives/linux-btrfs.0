Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792688799;
	b=WwT6yHpBcxtoCRLs9/NAHBM4bzEYO9RNa2/ML8ExhRHTR3ZgNEjNJZqsYIy/DPB1KpNy
	 POqVFe9l1V1NQZHbDYJdVrBsdd++wdKSr/nUYdeGCcC2khdftWvxAyfLM2/l3KiQ0wxYM
	 X8YqV0JFGJzK6IW1W5g4DMLmdqCviuQl/usFu7bvVIbVvUrlMHqqDDHhcYdhQBrUdRO8Y
	 FORnNPc9ZwGnlCNHpNsktoe0dxNvCQzmt3sSRUM4pUZY/TWy7XhNfcmZPxWMRPdMyqERK
	 yTfv6Yuy4BRXi5AMucpHh8WM7IIXfUkauBnwkUTy2EZpK/DyHGpqhmmszBjIOO3y2Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688799;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=8ARvaOKjKUpF+O0s0kxgU9u6MN0y8k8iFbPnSyB2aq8=;
	b=UqZmZ86em467eFVYgCSW5H2+a1+JTGaSbecUOZZmcTzKjwP6Vcjq4+CaDS1DIDx97UkW
	 em+DlcyHTc+lFE9LIG3M2CNvXhT7R9UY3hmR6Y79RXQLaYMV1nTA6SWNDjv7i5xYuw4Wo
	 O96O1jFboOD+9Gc80Yk8TpgvY0snwXmjrWNFvJN/X5jtxKoJOMqb4trgO1Ll+l8mMbwpT
	 k8d03ZyvmYmGU1imKFGqDXU6pI99uxcIXwUcJH7gagNZF8OrqYPgZ84iE9WR4CkZpEBWj
	 dGDD1oLMcWXL8/q05Zr/h5qhphaAej116HgImz/tju7LiiA23e9tP5lXjy/0FVhPZhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=qMAvIkeJ;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b="Y8B/fwPJ";
	arc=none smtp.remote-ip=103.168.172.147
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E171606A320
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 17:06:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E171606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=qMAvIkeJ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Y8B/fwPJ
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 985C2EC0123
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 13:06:38 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 22 Oct 2026 13:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1792688798; x=
	1792775198; bh=8ARvaOKjKUpF+O0s0kxgU9u6MN0y8k8iFbPnSyB2aq8=; b=q
	MAvIkeJsX4jSJcFjmorZQmRLOrwLK6Ts0d4vxXN3v0IjHD1R1S8XRUKOS5SD8XRD
	vIs4xnsmCwtq1s0ORN3UhTeneTbfvEb5+B9QCC79eUIyYGuaZnEVO21XiP7h+sxK
	SquzU3nTGhf2g5ntPZVuJjwMCVIYA077kUzjXDHm9KbnaZc9bQv6VGEMf1OxSYTI
	ftL1zJdrh5DdRZnDbcAt4rZGxMAmCUsefvBYBwwb8cZtzElwnloLRQ08YmZwIlb4
	gvuRqbDwKGe7yjR2+2mZ0xyT+CeRqLFkqcI/cfBaPP67UXkb4/qjI2iw9y2HuG7v
	L3vxycdzSpIdv1RsIqLzg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1792688798; x=1792775198; bh=8ARvaOKjKUpF+O0s0kxgU9u6MN0y
	8k8iFbPnSyB2aq8=; b=Y8B/fwPJ2eB6ZBzNI9KIvwD9Tdjcc8Id1v95oZ97gd7S
	7V4Rd3NvccUVXdodj/vMcqYwohkUUe+Ww++FaDXcwijUbOgF3MotcF3YipJHy+96
	eKm2P7n/tC2R6YhJxDSBcvRqd/QpwcbrWquRmsfBBkuHYwbt77zJxcBmbrOrwug+
	Ls8GBOFAvXoaabFrR9VXfSS8u6JcrVL9qfDii39/g5+N+TmChCJYOsKSYSH7Z002
	DPWSSBZyhk4Q2lmOFD1aMH+AUZ+A6lH9Bh+5f/alU/FTpmpjBNq5WLwwZp+KI9vO
	g4DrHkwftioSuDB24o6S2Vo5il/OIXzYhd1vUP9ZFw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792688798; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm3:rsa-sha256:iISOP74hXSRfUoUadmYg2NRBYSeBAPU+QR/DCSAzVv3MIXh
	TkK96pOLc07MvZGhO8HV3UBWxrNtVLW9W60jyryj/AUBswbHrqTqlMPzhZTvLVDq
	qhHimYDsr8eBYlXtnuEy+UfgJKsO9CwR7IXNCRph4enzhljRBF5RCqa+YVFdzSKT
	rYB2jwstTqXpigkKA6wKQSCw4QpCMp/ljb1tVVnQUgxIcYNE/3+ZnBc2oUwp5jKb
	28uWRAjEuMQ9UIQffCDPNOkeFGQ7ff45/r6Srv+QgcpeLEdrfRdm9x6rwzS71NSx
	F1/faKmeN+M+ZAEw4Ld/JLYagv9/Mq6gd8rZ5cQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=content-transfer-encoding,date,feedback-id,from,in-reply-to,
	message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Rs8hDppF5An+x+9j8Y2FkjqOWZ0VFFpd2U5ebbVOMco=:u8lrvsudK4Zl19ZPFPrEzDzF/y29dKhoJNfo2NnN3vA=;
X-ME-Sender: <xms:nkLaaqUpFHlug2xat020tCCbtNtc2kk5gw42gYwmBU889Z_Dcbj6eQ>
    <xme:nkLaasmYr_1610EYZxHhUyMuHGmsFZilbLj_DCc8E6XUpr28z293VKyOLnn3bOLhX
    1_lHN3dUcELCMJ8lMKT2mtUL1SjdfDXJCN_8J3j3O-8NztfyFR080ln>
X-ME-Received: <xmr:nkLaasCZnSJg1ImPrPG1ZNo5wuXsIWIQJHtCYKEgc2Gx8efo1GFswam8>
X-ME-Proxy-Cause: dmFkZTEe4W4ijRj8LZWD4Lo9X8GUtUjJiOBEFgPoavKCOJyoNm0WKmUICZqjwAr1fZEtzN
    wX9psAuB6tGQcZKT04iwQ+nzS1nXqKBzO4k7TataXP7fQkA2HyVZ2udM8mwy84Ds+Oxk82
    /C5tnpFc/t9o1GhxCHWBjcvs0TX5V1ixUkXuiT5gcSJTdP1VU+IXQ7UmaSJRUsfJxTTgmk
    a0eZ4LANsWxq1NCnYhrjdh0JSaR2kq3OvXMAGUryItB1L+2jmIPVcVltxBrTsxaDNpZCxy
    iGE4xsxYB+SVoTBf5HYE6bbggKmUDOCKzyfNCMaar8wuusR9vJhsSaHMSh49K56q6PNmMZ
    opxMXhT7lawwXQATe9tyMQMWvYS5DwPHPYUJmw4kTqs7Ihnbog3wLrypKZ553sGbqs6rEp
    QNa9nNZ4qoNyRTdIFw9H9JMfdEFBXSJYKhCqWSGvNNE4Pbztt4OQJNVE21LgGwxy4oFEz6
    93xHzt3r2cxpdLTRzLU8tZGImziJckypnUr+qNClxISpbPt8/R1TqOrni3ofm/dDAIg68m
    90VijkXKzEUQ/c4184AL7hDez/a7ILWEBkWwUZMjEKOJnSd7dSdTPTFPKj3BB8tDjJEDFp
    BmGVOl7V7Ojf3JqtivYZ02nbbb3jGx8mQ7UTESS7hFkOFIV2Z7wW+FRzz9uQ
X-ME-Proxy: <xmx:nkLaasc_F7ox3caZbVOvADOx9Z3ui9kUbu0xTo-LRpX1Oc-zLBuhlw>
    <xmx:nkLaanJvbWY4gv87tPQrleQ79vIYOi3UVoUibO8lNEi8afnsdNUfGQ>
    <xmx:nkLaavfKaCVhbfbrC4GZ8cLG3jUZva5YCfqtOM2alUA-hx5U1Zgg2Q>
    <xmx:nkLaau0HQT1lka6ldEuVMXuCJj42_HZsKPEoDw4IZS3OPbPrx7DHtw>
    <xmx:nkLaaoV4h0XZIX3SNgC2WcvZ66haZo7PILRcxwzea9m73u_w3hbty9jz>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 13:06:38 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 6/7] btrfs: find_free_extent checks size class unlocked
Date: Thu, 22 Oct 2026 10:07:04 -0700
Message-ID: <98fd2c6d3af6bad4465e849ae80fb24bf711023d.1792688736.git.boris@bur.io>
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

Similar to the free space check, it doesn't hurt to skip a block group
for having the wrong size class even if it maybe was just about to
get reset to no size class. Furthermore, setting the size class already
admits that races are possible and that there is no guarantee of
perfection of matching size classes, just that we only set it once per
bg per reset.

This can also help quickly iterate past thousands of wrong size class
bgs in a large fs without taking bg locks on each pass.

Measured on a 30T single-device filesystem on a tmpfs-backed loop device:
  20k sequential 1G fallocates:                            6.7s -> 7.0s
  sync of 20k new 64K files after 20k full 1G bgs:         3.7s -> 3.8s
  sync of 20k new 64K files after 20k 1000M fallocates:   13.2s -> 4.8s

Assisted-by: LLM
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent-tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8b57798c2d94..80f2c735f432 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4334,6 +4334,9 @@ static bool find_free_extent_skip_block_group(struct btrfs_block_group *block_gr
 			ffe_ctl->total_free_space = max(ffe_ctl->total_free_space,
 							free_space);
 			skip = true;
+		} else if (!find_free_extent_check_size_class(ffe_ctl, block_group)) {
+			ffe_ctl->size_class_skipped = true;
+			skip = true;
 		}
 	}
 	if (!skip)
-- 
2.56.0

