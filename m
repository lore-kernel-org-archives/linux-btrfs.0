Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA21A388E74;
	Fri, 17 Jul 2026 19:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784317872; cv=none; b=SsB+hQtGuqWb8sMWs15luEhqPLG6ahbW1U6t9dDKAqNDQQ3tsuMxSnotTHgs6eiT4zL8y9TD9zae0+VGmTpjtA8Fx4/9YZGp7IficempZbcoKtXIgE3akVOMdlGOHunx1LN1FDTmnUWocatBMUZn8i+nu8v24jbiXjiUpuk1WFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784317872; c=relaxed/simple;
	bh=pV62I1bqm1RXBPlQ9h2Bz1Ysmo6D/OHQcZqdYBoSxp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZCpCtIJYCCp9R+VJyD9VDPbWkkMB+egZiSTn3+mgyOncmJGHQN4QjAqJkXCW9nsho/od+z/UVvCZiDl+BPB0E5VjZPWs+TpcdVIHim040dcqQDWACqyUY7Eq4agUFiSxo2DAlh1H/726sFPhMPX0l9j/pXfWSyhB0HvKi+FCS6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=lJFJ8e0p; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=mTvH2BXh; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="lJFJ8e0p";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mTvH2BXh"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C58EA7A0059;
	Fri, 17 Jul 2026 15:51:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 17 Jul 2026 15:51:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784317869; x=1784404269; bh=OLVlQmVcA6
	D8vgzrlLhR9CAgVadj3C+V6nFwOTgISY0=; b=lJFJ8e0pTY8vh+7PSGXTeJmReH
	XEp/HQZjh7ggLy7IxdkDF+ptAYfcix8g+PPrPfffbMUW3HXqPOikfY3CIPsqmcKW
	69SZZABeb4FsS/IuI+XUnlZ9QdKoE9nSUy62YVevEQBwGMi3u1Bs6/j9WWjYboFV
	vRAD/6F6ILNASVYsdgsibyFlr0POVWgoUOBbqy1Nhbp/wdA5WTswmxm2EH6WC5jO
	o2LXPaOaAgUjjhjj6DEZNqjyN3sSrorJK0wjonyqoC2bpTiaks3f4qqitBkPNiXO
	ulSqE7nnPrxyU8v4UZnux13EweC7G1XMMxxuDjPTFZzLRFPS3wkqnThlwHBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784317869; x=1784404269; bh=OLVlQmVcA6D8vgzrlLhR9CAgVadj3C+V6nF
	wOTgISY0=; b=mTvH2BXhFIMXWZksTM3yRXZpp2RTBlI4kWAqgDY8CWhuM+ERuWh
	LOEC9RCaLF88q71uKPAUGG5+uMh3obEntVS3Tt3h54ZFZv4UFL1og6KYecLoYiqa
	MhdSRLtEmTOV13B7SeWwc7j1R06cEDsbRJnGND3lys34BjNzMZnf2HJyC4Bh/mDt
	LpAJpQn4XzYfX0lGgcjadcuRh312Ee/9bw/4jyQmjkOCyK+atWJqBlHKSfwb9NlZ
	DN01JsF2CK8LpMlHI4ZeZMauNfHVpitTNiPQ7ICtuuimQDZpN6Dw+sCne6QFT+HS
	SAIEDI9hAI9rNcnRvFN9BLskLQtwjG0CN7w==
X-ME-Sender: <xms:rIdaahdXGFRrVaSWvuWIIvIlEjAg0JyTganxBwfTLwFa8SuFyU0BDQ>
    <xme:rIdaav4sf3YZG9ou6z2cILNJThuLvy1AcvYvbF26XjF5YS1-kqgx5gakwDLsehimG
    zVnwFr1OM4Q2IY_3uc9AOn5UibHwGXrliraTLvRmmMRuGGG59YwGEY>
X-ME-Received: <xmr:rIdaaoswb7y3qsEjYLXBMMMiWN_Svxv6iUHhTFhbnu1rJHK119Hra7SMO5cmEcnMefBVBg40ZQBM6SCMdO8Ite34tSY>
X-ME-Proxy-Cause: dmFkZTEANgQtK1/uqqIhiQM7tyz/wBu8peqz3VQLLWP3arN1HL5+KzIjmDvtciAI0Mj1pZ
    P7lxMQK6ubV5rPUSjnayD0EqN4Yn8uu6NJP+EFmamTBaIqn0kEZzsN25RJuIWeSU8Sxgre
    3Vvw9BGDat/Dv7zZJ88PW0pqtIxqmAyUPLloUTwoU8M4s31Wn8x8ChXb3wou7VvwH8R5w9
    iqOfOxw/RQdpxQFMuvFX/AFc0/TBWXD6CHMEcfTRpwYPks5wZHbWwCMPH9MmW1akfuJHta
    Kxs7uirucuBHW/QtEMKKtKZDnIiqG2ROoq2/IBvroT2P10dGU4doPr5IhwFzlJYowcpbYu
    kJPfmwES60P6dwUKu0qRrsi2f1qrHrD/WCfxXDIV8AwQ58oDYEvKCMzLaw1UBdkjpUlG3k
    KaRQqRORFuWAyP3/0LCFJUmIcGvG66222zJhPKkNtFw/s35PSj+3JMTM569cqQK+l/IFGN
    BJZZlp0MYb97IMnge07EEu2ELlQDreBbQmpEL5delElmReUPtRmJnNIBlxYXRsTv9NO35f
    0V3TIAyjpF+4eX7Ul+lm/gJhzja4IvM5oqiNMwtZKTBAp+Cg8oqeaMe/mw56BhFNVlNoDW
    2FoQR4GS3BDy/S4G9jU9FQky/W6P6grFjo3s/mcJnIbY8Be2WkhGafy858SA
X-ME-Proxy: <xmx:rIdaavjsZb1ZlPvdJNIqWgP9Hud9-4CH9aHSReqmgDHsw8THadSqlA>
    <xmx:rIdaajoRxy8odPHJGYeoOEHVGrLN1feyW5LG3fUy9uyr4WCp9Mhu5A>
    <xmx:rIdaastsHe2xuiEshxoYedyhugBN2dK7XdAs0XbVzjHSaBTqy6LcvA>
    <xmx:rIdaamZy9k0BHkB09B-lfsqzJxbOWk3N8TxCZ3HdRElueUx3C4s1sw>
    <xmx:rYdaasygL-2IMcbaWSCkeL1Vd7wQWUXOC3BSiX0UOkNU9wKdrIBONjJA>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Jul 2026 15:51:07 -0400 (EDT)
Date: Fri, 17 Jul 2026 12:51:03 -0700
From: Boris Burkov <boris@bur.io>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhongling0719@126.com,
	David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] btrfs: Add missing sctx check in cleanup path
Message-ID: <20260717195103.GA142812@zen.localdomain>
References: <20260714012850.611545-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714012850.611545-1-zenghongling@kylinos.cn>

On Tue, Jul 14, 2026 at 09:28:50AM +0800, Hongling Zeng wrote:
> Add sctx NULL check in the for loop condition of the sort_clone_roots
> cleanup path for consistency with the else branch
> 
Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> Suggested-by: David Sterba <dsterba@suse.cz>
> ---
>  Change in v2:
>  -Uses the same pattern: for (i = 0; sctx && i < clone_sources_to_rollback; i++)
>   ,suggested by David
> ---
>  fs/btrfs/send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 3ae480c7474b..297704edf1b4 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -8251,7 +8251,7 @@ long btrfs_ioctl_send(struct btrfs_root *send_root, const struct btrfs_ioctl_sen
>  	}
>  
>  	if (sort_clone_roots) {
> -		for (i = 0; i < sctx->clone_roots_cnt; i++) {
> +		for (i = 0; sctx && i < sctx->clone_roots_cnt; i++) {
>  			btrfs_root_dec_send_in_progress(
>  					sctx->clone_roots[i].root);
>  			btrfs_put_root(sctx->clone_roots[i].root);
> -- 
> 2.25.1
> 
