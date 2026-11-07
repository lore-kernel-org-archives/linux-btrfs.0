Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794012396;
	b=m9+Z5hduOoY19RAbURr6yZ4iTOlDvR0pTet4HS96j8t1haR91rFzH7DTHHnBI6Nzlbkj
	 tNwReCU61s2PZAzfO2FhjIfv/wbV2MQfLaBokndF7uC0Jy4jCJebgbFkOYAC96Qhwj7/t
	 wwzdu7B6R6V4cP6Et8Y/eSdE/UFCrGU0WE2m9Hbeq+r2YllCxoPRBfDyP7oRBVLuKDyx6
	 yRonUxKsGzHplDb2KQGEftD6uT/GgOy34xtFpHRZ/A9RzPDYykaNxGbPHfqydUjFnyezO
	 a4w2wVLqt1P1wxfm9Xz1u61QMlISwbsfLLt0hjcaAwkPmyPjNwSlejx+jtld8C7cwxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794012396;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=m4KnzQSIrzeLqnY9rgsumyRFxMe32mVqhqCCYmUO0tY=;
	b=ajfH93FcD+QdKsEgpS3eIl3ph8iz5T/PtQTXG4ioDQpfbxiGO+aHF6a47pqxZ3DXlGXu
	 udy2jijSsrYJi4hHRPfqK2oUtpa22LcUABCnK0cfazbD2Atl4Kxks1rlNLcfc1/fIsF1y
	 H7nXuiDqUfPuQYCgf0r3nm7B56s0iVktgBghLtxzsxdWjvT6RoziYqlyORE/liyV48JAi
	 WjguxSne9CZcbNiCtnvHdam3loRAV9w2PSwGnIJZ4108pD5CUuSf0/vDtqlxvL0LOHcx2
	 B+i6e6kBbshFn0pozdkQdPSAkGrNPueG4yWzqQs9dM1pWiW10D8+PfcBYYFj84MeXQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=PqVj4zQx;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=UiOfm2E3;
	arc=none smtp.remote-ip=103.168.172.155
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92CB606D812
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Nov 2026 00:46:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E92CB606D812
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=PqVj4zQx;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=UiOfm2E3
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CF2D314000B2
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 19:46:34 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 06 Nov 2026 19:46:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1794012394; x=1794098794; bh=m4KnzQSIrz
	eLqnY9rgsumyRFxMe32mVqhqCCYmUO0tY=; b=PqVj4zQxF+tYW0POI13iaTXz6d
	WdCAgTaX9ECMpQB4KAZbeFIxQXpGzEJwpzPVYwMfULEbV7nFRq8wiM7ZBG3fm9x3
	icf7xOjZCAmQBadAT0ytZsPa5A26JacyYRU5QNH4rUJiXW3DiEgNPYbqjeAfI3iL
	gL1TMP0Hs4tRZxMg2VUyrpILurUEUEyD0Uw0quQjg4WY2DjbiK2eFvMwi1Gkrj0u
	fVyOvwpE2d+0Yi7h0ki9on8II86xHHUptqzzxRI2xIHr873aJ9ruI6krfUgDd2l9
	kZ3FenYMyJR4/+FbhaE0OFk3WkAdA3YqD7KlBKK5p7Dtk/+6DRhc3KkJbTDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794012394; x=1794098794; bh=m4KnzQSIrzeLqnY9rgsumyRFxMe32mVqhqC
	CYmUO0tY=; b=UiOfm2E3Ya9HzFPnWjf7eHZsT7FNt5FLja3CKNgA2U4IXQD5Zfl
	/8kGynX2oChIk3CtF2l3TAPg1fHDYOAT0lK6TJHN82M8k4GASLfjiKTpzHNwQxDK
	6doFxJb7dAfdi53+JmDP0tQEEOS/p2spb1fJlvRn8iHetkRhdJEzsF4buk3z2pY3
	di2YKJT7/wUf5sDJcfAKxx2vnqrXfqiI7oA1XIt5FBnqObqYYbZ1Q7xfNW25Jw0B
	OyWcc/chGjXJcPpCXeyevb1myAj2xRv3xiA7EWMARbsJshMoK43gLQ7xOOT1kCBv
	gL1FSBfu2uZA5SHZOljU6Uk6HkuWwUxxx9g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794012394; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:HchnU/roaeem685P3HLz9jHm6y5aR1MLc1m9ud3v13Q7I5q
	GjDW5iroq2SdwzIMhOQv/u379cJdvnIRhGiL7igMlnM5bWc5tKI2w1a6WpFgyrkU
	KQJUcxCU3JK84uacnqvrJY5GUhM9OzzAHpix6nmX3iKOEUoMRNJQOGXoQFUgFYQ8
	tLy5HhshPhLw4Lzm02dDqPb6Uc2DjGqUYHMemrbTDYrTRnDwXJQVQdeRu78CE5f8
	4j1PZhbSeMfF1Z6jBF1KaEENmUVFNLrXXqFai1/JlEGpDgWzgycftoN4N05/zLBp
	/HO5JtlwtokRdi7zbUxnZOINJa/7c7IdbrvONrQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:OjgGeUrEwcH2VcDdkOvFcit4yDPePMhlOcOz4VgPqf0=:mD/1r/NC3mT70ngWphkhdUqDJXjmR7gThb7yjGfCrUM=;
X-ME-Sender: <xms:6nTuatVvikThkU7lIbV37Af5W9ga6Zgl-XUzELuzkytEVkvp6USi6A>
    <xme:6nTualDzmA9eP8HJ-Tdjv1jnY_Q2VQJQtlPQ7dGYGjKRpwcc_Re_Qe5u2bUQocdp3
    tBhkMYQscggAeOzKTGOcf2bZm2hdmx0N210u542ZN2c3t1bSml5q_qE>
X-ME-Received: <xmr:6nTuamyB9_AJuJ1lleyxAYBijobT2hCRFww-YF4KKKeWCD68QS4eVru3>
X-ME-Proxy-Cause: dmFkZTFdlIyWhpaB0MaFs+gNITzUigP3OQ1e3uajwG/k299BXkUUbVX7oBZURH72Hp7AWE
    CIvqYtCv9/BKXae35T6PAyC1hebTVWsz0UfBG63IH+IPh8VCFvoaAp3s4xKxAbMVvUVgEM
    G4xHZZLmljrHraxJnBCzXJkJUOmFtPHSILTydEST0dvWVkAU2/PXZmg9a5thQL+xLIEcbo
    7/AA51Hay6bRklobxNefYnnBMvMkFJJwYaAuCii24+Akquo8O2ralQoEqZkj1fse5XIm84
    DvInIQhYMGIccUSBDt4MvpiXPK5+OuDbhb4x4VXjGmGPqpailwC2+MdDPj4Xgz5zgm0BGr
    JtLVA6Ci+uWelMgUmFj+WrTqCNfyWg250Mv3OX2Pjgxozn/XQwydx6YguAAtK0/2ebM0y2
    zhS8U54ZROhoCOLcHnY7FQ1Pt/H34+3c/bMElxmP5X3/SP7+vKkOGrZO843EGUa+rAxZps
    8syDoS0eURk+6PJO9UN32o2VBHcT1IGhIHuoIclGxZMkmrkiDIBHbaCYTcwSw4UXA9X8pB
    Pd6UdPUaHEBJeMOLviSOpp2D/o2n29Thr4C/qKz3F2TqqEC7F3UdMkD4qNGOioUS063F0y
    vipr5jNmXew7FxG59ve39ZbHDxSGKNeou8fs18qqbSsaUNRgTI9jtiIPFUXQ
X-ME-Proxy: <xmx:6nTuaqCmA9jhPBE_QwVSKP1s_2hCqdk--r1S361wkfIm0o0vUYDygA>
    <xmx:6nTuarYtIwfNEynMx2aNJSlUX742zOIMizuJ56IkTyaczx_ne9jWgA>
    <xmx:6nTuaqh7ZafozbF4h9P6W1kV30yQjhGPW2aDZyQVziQUsmxvtZggNg>
    <xmx:6nTual6gAZBx9o3T1r_KUsjONObh2NXyuV4M7LEIz9oB60taESLuzQ>
    <xmx:6nTuauaQ5fMA57J0ayspRUihmRsIAJK3lolUHbXlIVvyi3iHbeV20XKP>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 19:46:34 -0500 (EST)
Date: Fri, 6 Nov 2026 16:46:48 -0800
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v6 13/25] btrfs: zoned: wait for a running block group
 reclaim in RECLAIM_ZONES
Message-ID: <20261107004648.GE401465@zen.localdomain>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
 <20261028182111.160492-14-johannes.thumshirn@wdc.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028182111.160492-14-johannes.thumshirn@wdc.com>

On Wed, Oct 28, 2026 at 07:20:59PM +0100, Johannes Thumshirn wrote:
> If the reclaim worker is relocating right now,
> btrfs_reclaim_block_groups() bails out, because it can't either grab
> the reclaim_bgs_lock or blocks on the exclusive operation.
> 
> Wait for it instead of failing the tickets while it is about to free a
> zone.
> 
Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/space-info.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index d5a84fa97462..bb08294cbf9a 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -913,6 +913,7 @@ static void flush_space(struct btrfs_space_info *space_info, u64 num_bytes,
>  		break;
>  	case RECLAIM_ZONES:
>  		if (btrfs_is_zoned(fs_info)) {
> +			flush_work(&fs_info->reclaim_bgs_work);
>  			btrfs_reclaim_sweep(fs_info);
>  			btrfs_delete_unused_bgs(fs_info);
>  			btrfs_reclaim_block_groups(fs_info,
> -- 
> 2.56.0
> 
