Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794442136;
	b=W47g3/ObBm8D4OCRt5N36aQfGcRkbu6UyUTRKWZToqF56yP9gFcrAFgNDLOQB5vnUmMN
	 zQ2rt81S1GO2QhBfEhh/mMZPoYQcUdkOI45alOQX2DUsa4CI+TpwiU8Mt4Fn8/GY7wyv9
	 SDBCI74/jWJnaL1/S0Z6tHk1nfLVrPbu+W67ydBqd/ujeWqVWFpK35ykW2AGk0qlMT45U
	 oJwd4Cq7yic9pEPbCah1557UyViZGkLNtxXinw3tiIWKpVV7Bs2yvPnOWLgmRXxMd8ym4
	 VYDVGYOvT7Iiw8TX5Kom5CikFR2qVqnXeVLBsRip2npm1T9fjYW4zXHERCM07M71o8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794442136;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XC8LFKc2NuzjSPoWCAVjbaZiO6hQxmfCY/gsirNYo3A=;
	b=Tzv6LKOHMfmXU22ND68eVZR+jseBMVAXZY9M2qJRIi5Bpm4Jgcf450VUHSQjg65jhkar
	 XWa5l+XahadPALVCzLwZNeH2IAox9TaIhbhrNce5uyS9XmX0CG57AOdBsEZ8C7QhjshZv
	 jEcI6n3DtijwMmhpwzNIVyoT8Ml6/DfrivYGYPk7vq+c5rA+Nr0FkWrT6c/ABMDuKLasz
	 koNyjFQ+rw4/SpAmyh64onfvgvJQ4rvktpHrYuISL+No9Fc+RXT8BqWxzbDJpB3JR8Aih
	 1KZotmSXypOzejmtCRTj3GzsYq0O5piKxgTtFf4mOdqcF5A8rdUOn+Fx1wtjfDNs23Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=k6VeOx8+;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=sPDoF1it;
	arc=none smtp.remote-ip=103.168.172.157
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA42606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 00:08:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FA42606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=k6VeOx8+;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=sPDoF1it
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4CB281400170
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 19:08:55 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 11 Nov 2026 19:08:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1794442135; x=1794528535; bh=XC8LFKc2NuzjSPoWCAVjb
	aZiO6hQxmfCY/gsirNYo3A=; b=k6VeOx8+cUsF1XNnI5MYfU6HU7rmHg29itBHA
	lA2mn2FrakbgE7CcdssOkabEp+0PT5cTERnpbGpMtwbSsr713X3QHFJW1afkTIUc
	xNmcIxdU63D5JTl00BS8lpZb+kwlOBfUX3SPfGvhyuTzhDil00TLMa4Sc9L/QQiT
	J52G4Ss3D9K2ZKt/6jSklg0yX9yUB/g87/AKHo3KdBIr6yR4lcMogvpanLtrWFkA
	QY3mzkfRjvKiQN79VhsZGxqBUV2gWhbcAEa7X+zwTKNR94a1LPd+26u57Glbdn0z
	jwZ2+kk8hgEsHQT9/MICzGQcSN1cpV55zbXKHrlFurlGVBlVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794442135; x=1794528535; bh=XC8LFKc2NuzjSPoWCAVjbaZiO6hQxmfCY/g
	sirNYo3A=; b=sPDoF1itttJDLyAajTUS91SMcDpC+R9H7I9ZQK6FSU99DOSdspG
	ID2yAWp0kv8rDvNl+SF65V0Xkdtc3XBZKWJBrBG98QUWEBmXkrGF1TBpHjLXRuNh
	oUHst7Zx8MLdcbB/hFZiOuwJwNgOXAi6qrbuJRKeZhA3q0UcakRotWUTDVQsJpuT
	gADGE5tKsNRrlGxRXZdX7Pt2QibT6RQV91xOw6/KcTgalrE5A5rDuJocrErLtqWi
	Q3VgSrSOpGMGRQSg6u6OjTfPg3YBEqG7sasBjwv42TSswztf3aLLdhQxZX4bvJSe
	FMkVjRKubRRj9vgwySbJdC6HHesoEghZ8UA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794442135; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:RjTVqiwKGTCFZ4FfuUxsofLEMch7mrPxZ49glV+3kRw6tqJ
	aAP2VVfh6FkijVM2y4xLP83zJmOsVJdBAPKV/29FnuXde1x91iGJ68NcAnq7FvS8
	xaaRXxCvH3mwXJHwNiGBeAsgei4O8MuObzDtuT4cXRkcnXxicUxHgwoXcfXWPEgI
	RjQ5s7R/hTs+PqsCbRdmkMoFrkd4n/9ai9SF6P0YxIkrReWvL1xLHjUkqiRKja4E
	mL28uQctoONDiRDft0BBlcKWq2CeD6gfWyuSTfZJR0eUKrMK2QxjfqzuMUx/w2Au
	77eLG68CnTMKGxdcWvdFGVrNp/1zpKeavOSIQ8w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=8;
	hn=content-transfer-encoding,date,feedback-id,from,message-id,
	mime-version,subject,to;
Message-Instance: m=1; h=sha256:reFG24zG1RvXR900FllW6Nxyn5eGCB3ZIQ5atzkd6HU=:Mu7XUWQXvY3XuVRMf6Cy+hN3f9RRCCZL0CyXCqzYq+4=;
X-ME-Sender: <xms:lwP1aiK9UFxYRoXSbKnajw1rtpa3u6g1IjgCg0nCTuQ7A76tuImWvg>
    <xme:lwP1agKzOIjnA8SOTr8v0hpCxlIkcOmMkmF2X0HA15r8ICZewrsQdQE37vgjrSetx
    9KH8DXqvAWEHrafe0AiM4rnY_5MmWy1VNDXQC-sBdnFs1qlTF--wyLstQ>
X-ME-Received: <xmr:lwP1agX6GOfmN-jrfqpo_ct66_La-e9uYz0u4ozUwE8ZHlPhGgMb8O_J>
X-ME-Proxy-Cause: dmFkZTEsMtRaIBMH7gqSK7kJN7FNTHMEL8RzL+keeIORg2lhep0jido/rqCRpjPCxH80AO
    xoNoaLleeuMysF1G9Y1FwHzR3XC5JZL6mDZgQHOIVGmu9jZDQP5UIjtgopXdu2g5/D4ZqS
    LAQSYJPwhvN4clxgJRXxs04qz7MIv0it7kvpb+SMdSRkPY0+J6+PeNvb4Hm61UlJAjvLNa
    1X696An/sqYOcH9EeWE6bfRsBs8JN2R8wz44htV16drpUWFUInZK08kargaJETmkiI5ATf
    1FVfUcApdoeO43ZKTgoDPsDs0mvGs3TQVTUe/sgR/e7JLLNXYtBruHzQzlavWoJJr8fwkW
    qRM7yaYFGKNKrchc4S7wA1yfnXhCrjQQUSWuQq/uuJXGs+Fr6ffwKF28BGrGsyiHuC4dfW
    6qRlZM/pOLyO1u6EFN+xjC/DnbryEoFNLuo5ZbibO9T7HGIgjr9h4ULfTxvo6aTxMf96P9
    61s6dm5bcrSSNvn6VGB2pDAi2pB6+djptlU3If+1luLWeLMzdoINWq703lyLPpJuFVKzJr
    mcoqucIstTYIwb1oKoHJY9y3aMfKfj142+3Wj/+a6DPl8LqmvaQuICavG5yf0YpYPrMJRx
    WcQ9aZi/9/vJMcbA7pfC9wur/Dk/7DBETVo6vJsg3BnBUU3jLfKo74AhVp/w
X-ME-Proxy: <xmx:lwP1aig7udCZylAUS7jav6qffBOyQnjWciAhrWzNAD1Pdro8Wx6a_A>
    <xmx:lwP1ar-dqmxaB1M4FPOUo9geXvcn2SHSXkZL1UOSJ9ciTPGpt9k6Xw>
    <xmx:lwP1asCvCjq3CydooYYuxlnAy70FkyVgg_Vx4oB-HkDioPVMv9MHiw>
    <xmx:lwP1aoIHCLH0UqfE_sSpjrIDd7X34lzClOmk9Csfx-794TV_2K4Dsg>
    <xmx:lwP1asIHYoEm24n9_r-L2Mpq2KvkG4w9UQJraGK-C6JxksSSb3TWNuII>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 19:08:54 -0500 (EST)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH] btrfs: fix block group ref leak when scrub races with unused bg deletion
Date: Wed, 11 Nov 2026 16:08:55 -0800
Message-ID: <52f2ee4b5d0879b99ea8c863ee40403bb06c5345.1794441990.git.boris@bur.io>
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

btrfs_delete_unused_bgs() takes a block group off fs_info->unused_bgs
with list_del_init() and, when discard is on, later moves it onto the
transaction's deleted_bgs list and takes a reference for that list
membership. Meanwhile, it is possible for scrub to add it back to the
unused block groups list:

         CLEANER                               SCRUB
  btrfs_delete_unused_bgs()
    list_del_init(&bg->bg_list)
                                        scrub_enumerate_chunks()
                                          btrfs_mark_bg_unused(bg)
                                            if (list_empty(&bg->bg_list))
                                              btrfs_get_block_group(bg)
                                              list_add_tail(unused_bgs)
    list_move(&bg->bg_list, deleted_bgs)
    btrfs_get_block_group(bg)

Other users of list_move() for bg->bg_list (like btrfs_mark_bg_unused
itself) ensure that the list was empty under the bg spin lock to decide
whether it merits a fresh reference for being linked to the list, and
we need to apply that pattern here as well.

Note that this is not abstracted to a helper function because some of
the callers have additional logic deciding whether to link it or not and
I think a twice used, twice unused helper would be more confusing than it
would be helpful.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-821034ac-556f-4d72-af2c-d04468879af8
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/block-group.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 027830a53f7d..0b3b8843d221 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1830,12 +1830,15 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 			/*
 			 * A concurrent scrub might have added us to the list
 			 * fs_info->unused_bgs, so use a list_move operation
-			 * to add the block group to the deleted_bgs list.
+			 * to add the block group to the deleted_bgs list. In
+			 * that case the list reference moves along with it,
+			 * so only take a new one if we were not on any list.
 			 */
+			if (list_empty(&block_group->bg_list))
+				btrfs_get_block_group(block_group);
 			list_move(&block_group->bg_list,
 				  &trans->transaction->deleted_bgs);
 			spin_unlock(&fs_info->unused_bgs_lock);
-			btrfs_get_block_group(block_group);
 		}
 end_trans:
 		/*
-- 
2.56.0

