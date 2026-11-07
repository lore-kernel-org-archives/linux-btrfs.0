Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794012908;
	b=aEEZXaQZLZTasRxzxZZzIFqK5WUM+ZByBxiZvks7JO+VDEq/vJgk/9jK4Ha7yKFhOjyf
	 leEhcWGZbDr/8oJLw4qsOaCWBcJE6q/P7W4L38P1UK1lHHbUKv0oXkh9N/Ndrm5gh/Uyp
	 EiI7D0QjrL1t4lrlUMpEsvSpHm1wB+mpUb9WaroF7750fa11F4zVlPgMeoJvYy49N30TT
	 Pcrgnsy36rT9vhKyEZzEUu8w5IYmU5JAv0KYW6z9JqsmHLa24vfFG+nlG7ObaRXYqYpeD
	 RZ+rAIaHj0HXr9B/U4frJxhmxdVb+PXClI70DVLDd+bmB9LTFvtUHvajYGSLbfhVvnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794012908;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=3HQiwCqjs57SqnEUS3DF2lI1kAYac4if6fZJQxeru8Q=;
	b=YT3zmLDJk1AVRwn6+STALxRn76UW/gc/mjCPz1kVg9b+8tPC6LzY3Kl9y08grJ7eLHLI
	 1qfI16WXWS8mJjMpgK2FCMXJSjDRDsXyxeRJhgCnwO+hDo2bM5YR4Li+k0Tc3c8Mc0lCh
	 WYPvD552cDgyAwxfpTV6OXAuX1tXCl+CPk85bQL8Y1L5HAHfGq0RYoyBF488R9B1FgYvy
	 5lA7Dy+GKwkMk+dF5i1YZX2U8oAZMZ/effNedwuT9KBIFdkemoohCHcK17mBAPwm/QVN3
	 ErN+2TbdhAhZPO8YIHFBhALC7gi3bqAA8whBs+dF+FBFcwcgeZG0RZHnjy4vG3Q65CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=XXRefVkp;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=o6rjHVKx;
	arc=none smtp.remote-ip=103.168.172.155
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F87606A83D
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Nov 2026 00:55:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98F87606A83D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=XXRefVkp;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=o6rjHVKx
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D308014000BF
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 19:55:06 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 06 Nov 2026 19:55:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1794012906; x=1794099306; bh=3HQiwCqjs5
	7SqnEUS3DF2lI1kAYac4if6fZJQxeru8Q=; b=XXRefVkphwl5twQgbvCYWaweqB
	BQI4TQHg5kNZ4oZSSXr1fKve7Xgykv5Cd3AnMh4vPMxUKth7UmONbLSWuKLKpzEQ
	QC8Z+PQCXkODO8XalcvqAvbIc5ddYHFtywBdR80a9tmIblNNxnTmeUo2Q0gStr8s
	doX+xDvkhmOJnSveXNCiQ0jje8IIYE9A0bzbtrXRvs7gYIv7XNHr4FQGB8RQ9nZU
	aMAMz+kP7zHEQzWEHKC4PWxPS9viMZYU0G03O1AEM+CmWLziWCNSEND6OJKzVaAQ
	7KFbATX0H6smRiZwfKsc6imzgd8fk3q2QsjmNrOLJj/r1WEOqOenVEvcDBWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794012906; x=1794099306; bh=3HQiwCqjs57SqnEUS3DF2lI1kAYac4if6fZ
	JQxeru8Q=; b=o6rjHVKxwSjkbX3GeatIOTYxwqsqhuZoHm7YnavtoUrX5YxrGED
	mDwOocEvftuuhknVvmzhw8UtzZ5Yxk9VQhcr5106NJTZBZvQY8lO/60nY1pd5W7W
	B/2UXx+R7fI47qjhgQ2FfzJqrwVV3F3wZgnWqIzc9LRD/zjIVHbL03xvVfKQxQaj
	ZCnZj6I121AmvB7GTAPiurEJHXyPU7uKiz39furAz62Ro3dQH4MzJTvYvLoBUMq+
	qcNW6AKnyDYBTD1ERd7nqqDFm6vuKn6tyJstOfaLAV0H+ZF98aPTm6wkM7HGJJda
	Veub0JcAmn3wBX8ginmR35R3rjjQ3EgrgCw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794012906; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:WzhDKWN471V1xnLhKQKmEDce5iNNarJwQh8M0g0PeZBpc8r
	a9b0xLOwLJDC5Zt+PbLGLFlZ3Biac7aXokubHv523Ojr4Ao8oWrWPayzOquRAViL
	QSXCzZZB7ht+B8H2rgnUHTx7VMXl9mtahB8wK0zY2UBAQYN3uZP1uLBS/BuTrqz/
	2+/RYmPf0y0w8Okn1/RV7y1zkEXrCFMqE9ZJwYpML32xWXA7fLmBvdSun2AQxM28
	+AsaNqA/xK0AEUKYk1lxzWrec4hD+fI/FeKukIVxDoYMDCQLbfAbugTX9Wav+qNl
	7wBRc86kiTz+nSqW1XjZ2kGzavUPfRZG2FxUtJA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:7WqaHPZAVtsYGS75eCl4RowFTQwx3ZczeY3KkduR0Ts=:f43bgWRIb1NnAnu60P6nqyBl0i4uzJxb9g2lNcuqUXI=;
X-ME-Sender: <xms:6nbuajyg5KgOtDUMuea0kL12KnH-FW2zcOw4nW8TjAmnJ6K30LwiDA>
    <xme:6nbuaisZcMJAhb-hBhy-NiY4f0Lll97QaCzW4FsqbwUrhFBpz_ZTnHGbdYCG9uteW
    LtrlEZj3n7hNfOIXKwSHe6mRKwYhA7YxEWNOE0IsUV87deiTDengYMe>
X-ME-Received: <xmr:6nbuaqtheTIQMG5X3uqak6PohlHWR1wv7sb-RcG3HwtRuAtQc0v8BIzD>
X-ME-Proxy-Cause: dmFkZTFiOjcnUhZTNOLXsS31w5mwj0103BfHrlWLo/FTUTYU3yf9hD56UyRZ4ee5SsRDKz
    OT9qvH0niot26sEgOiA+tLOV8J2nKlWcd6PFB44F5C/07q3Geyje7wgTNWxoX1QSHm/Gra
    eyXZegRM5s0JAUPIvfL8idUqa3kXzCcCCkdc/uR4payCKpfmUSE4P2VrodNLvcWO//EjU4
    dbEqiOIqXx7t9tjGWxLlv6sfzIKqz+7sahCjY8pIhJIqp/LzxQalzUZ6lJYsoVc+2U2Lpd
    852bCmbh0haGdUx88sWcNJ+hoOcLKXhqwJ37uD2byDuya3WEpXKFieoyBRHp8XW/Woaui3
    qoeZy0AImQteORwCIWTF3KauFnq18B+cVPz7EHIACNmX7zTcGEkASeSz2cBUX9Be9Qylpc
    YwlUVXJaJwvdO4eID+PX/oGLweirOUuVfgmJA+zgXgxhj/9r1d4LUr/DYuentQlkm7ab5U
    y09h3dtpY7xzTBSlJlz7Mkx1PbRfbzwkOZxlWc4xop/evY8vQcR6mh1u7BUySkRne+TLxR
    bz5FssSjdT6NqL3OHTLrEGYiSzbIQ91TRXzMELfMrBcwuYXQaOOqyvlKpnQYbGYV+Vb0yy
    JT5PaCBcGtMgiaRx7zSu0XzLNOuueCUwF0YhyjpeoOdjhVpQ+MgOn8xfT4+w
X-ME-Proxy: <xmx:6nbuanO73Mc8kbmLHy6_1ipqChzd7b8Y0SUwpZqqMlcnDt0YjhIuUw>
    <xmx:6nbuao2dylsLOVoruVk0TrBJrvWOEjuyWr2wYqNNFbUMY1_fiPIjOQ>
    <xmx:6nbuajNEX623WOgIDIMixDNoaUFGg4NdGF_nwwkxx3VVxJgo_W36yQ>
    <xmx:6nbuao3lrO-p_8ibg-LiFZe7iJzW472Ho_Y7Q6DjEQv_dhzcnlAwjA>
    <xmx:6nbuavF6HdEBI0Iqv_5Bw8t-8GcWG1g3RrJYvabLCOUExmTOGZ-NSKmr>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 19:55:06 -0500 (EST)
Date: Fri, 6 Nov 2026 16:55:20 -0800
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v6 15/25] btrfs: zoned: don't recheck the reclaim
 threshold of full zoned block-groups
Message-ID: <20261107005520.GG401465@zen.localdomain>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
 <20261028182111.160492-16-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20261028182111.160492-16-johannes.thumshirn@wdc.com>

On Wed, Oct 28, 2026 at 07:21:01PM +0100, Johannes Thumshirn wrote:
> On a zoned filesystem, nothing can be allocated from a full append only
> block group anymore, so its usage can only go down. There is no need to
> re-check if such a block group still qualifies for being reclaimed, once
> it is on the list it needs to be reclaimed.
> 
Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/block-group.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 772b6cfecaa5..25b44932d0c6 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -2004,8 +2004,13 @@ static int btrfs_reclaim_block_group(struct btrfs_block_group *bg, int *reclaime
>  	 * being freed, pass in a fake giant value to skip that extra
>  	 * check, which is more meaningful when adding to the list in
>  	 * the first place.
> +	 *
> +	 * On zoned, the usage of a full append only block group can only go
> +	 * down, so it still qualifies.
>  	 */
> -	if (!should_reclaim_block_group(bg, bg->length)) {
> +	if (!(btrfs_zoned_bg_is_append_only(bg) &&
> +	      btrfs_zoned_bg_is_full(bg)) &&
> +	    !should_reclaim_block_group(bg, bg->length)) {
>  		spin_unlock(&bg->lock);
>  		spin_unlock(&space_info->lock);
>  		up_write(&space_info->groups_sem);
> -- 
> 2.56.0
> 
