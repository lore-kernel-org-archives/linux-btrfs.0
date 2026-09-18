Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B33C4078DA;
	Fri, 18 Sep 2026 19:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789758817; cv=none; b=PiJJXRphdQrkG03jIcFi1kQgdg1vAZYdOB/cMHtb8q6NOCD4p2dNNcV/yAncyvZVYDq4MbMHiY5HERpmZRqibGgmcv0C/qf6Cg9noaFLSbqWN0AJx2zEN0iFoY1iTTw2W0KmleNtclAssSlCRK1tPmd5EPTz8DIMswwUfoTY3Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789758817; c=relaxed/simple;
	bh=ypWBO+e7Bovj7JbSht7N4ucJApYBb7+KAB606NK3mpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DllgGNEQs5G/mFvS+UpSWjO3qEv3SA1iV58Q6Fvkk6OnvScR/7JR22ICOkSvSBt1y+x6C12TnPunhn0n/42sCnKrQNy0cZrB8ShTM3B8S4nGRlxAX+Zzgxp6BSuWPyc+bxEyXFKCWMoGjDf2RhdRLN7ebqkSVCF9zqBbf0SrgmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=FnbU5zU8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=UUTn6e0u; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="FnbU5zU8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UUTn6e0u"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8D7C67A00B3;
	Fri, 18 Sep 2026 15:13:32 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 18 Sep 2026 15:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1789758812; x=1789845212; bh=zbQw5bsCmw
	yMqn3fZqqtDfVh5dJ9aftS0TuIvTXR55M=; b=FnbU5zU8zkxf2CJ6b9SOM7O5+F
	AeAeHnc1tN68A3Xp2WMGNaHXHaAQgCKoERSxVx564cxlpfleiAyDRjwdbbOceRR4
	zqDKGcOt4Gyx08Atrb50orQMbENoV4A3ruo1oRnx9ZgfXAxGUrhlxcV56TvFmTma
	KerZeVLwp1Uv58lLDcWkSIPnUaPgqYk+oUPgy5UhJdB3AWhT8dhUdVhthn5OxY/A
	EbA2fQeOnfj3dkYfPhTs2o0bspewHc9OmYeQ1Jg7kpb8HCciNbeK7QHRhomI6qrL
	pMnho4JSJVZX+rAAxc7g2y4P0ygmzxgXIC/l8qfmvM3qn5tvLDyMJ1Wx991w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789758812; x=1789845212; bh=zbQw5bsCmwyMqn3fZqqtDfVh5dJ9aftS0Tu
	IvTXR55M=; b=UUTn6e0uVgP0OrUrqFo/FvNl1IRmSo3+7fmteb6UzbWoVqQ7VdQ
	tIGMaoWCQP7XUgjKt9FJxLbuoDrjCVEhs7byxeOxxA/a1Hiqft9pwFlMXLv0oXrT
	2ZCC3wldk+pOauK2aLpxv0d5//4ruzp0ct+7BOmQIBvmP2cZR8f4xMA1mV6O5IsP
	XqcrV0mfOMU0jm7s7495lPQ4iZw+FrqAQOzHv6vdgeUcXYgb35LDG5bk6Kq2TJVe
	HeDkQDzV28koMmyjU5jYDDalVFXo5h4eUXsiuH4WlUQOBVVoqVtY6uHiu7ypmCUP
	vHWEKPPf92sjrWZBkiiLDTmUtZ4wToRS/Iw==
X-ME-Sender: <xms:W42tamjhPT_vptwFrFKIJh7He6sFmm5Xy31pHqkYRt_ChMkTLI9M3g>
    <xme:W42tamFkJRALQx4yMdh277_5zJhmsNaCChAdikzg5qBHy3mzavz4BUsj-8d6hjayB
    Nwn3PwtKBGaBdmc93cUa3xi2wSvL8yrSQEvyKAfjqwtxwNSaiMXqsk>
X-ME-Received: <xmr:W42takShE7N98vGuVS5KEvOXal9_CCwxk0k8EiOXEX3UxGQnOmyO-Gc>
X-ME-Proxy-Cause: dmFkZTFYAgdrwYS9Q+qC2s0sfBujxpW3HYjRb9jmdB+U9OFh78SRfbKJK0tx2V5/J8DeQQ
    rX9i9/jR8gamHkO/TJs56/AjkxHntCVOf97AQEKbve+aCUL0PblN+6oMNM6beRTKenM0en
    pbW4aYhy73s4053WP1gLtb5CHQRCrqRliSLI0zQyT9NlWhQcN7ooJU5RtU2mwi5r1BM1+R
    ad9QcpjXc5bBf2xYjy8tLlhzddsq7A+ps0JeCVf00ZJNi3ABmwbMr3alYAX6TcDfK37ahF
    INEIPju3vJmHW58AhFsSNUe4qSCmZZU8XDLU+SsbnXLqSlXyZZJDVPCiAucWdQFvarKdnP
    sEO2v8KpowI3aW74CZUFNSg23+rro41FveSuQGK3YmlQl8NBGJzTBDmLwy2slEuCCYbLi2
    PXgZRvEksFGeAGHnVvE4WY9igSJJJFn+gG8BoJrBA7Wuu1JudR4LyOL295PZ2qqhsws7EX
    QC/r/+CX+zXfuHD4b0fw4TmLgu/l3/obCox8A8MkXBPsQEgqaRZy4yEaHPfH6GDo+yzr4g
    YyDsIOtXOowOEInQSiyrsIY1Ja7I1u9NzcM7Z8cTn1KsKK1Lis4K8z090WbAqothjAjnhS
    6YhbFBkDLJffcyVupYzqxdJdbfgqNUmSk2+obDhsMvzKWRlmY3m9BNYrmMIA
X-ME-Proxy: <xmx:W42tarzf1_mMNOj6HSE5kAt2laPkt1aoUNb64ahVh84ErojGdRF_bg>
    <xmx:W42taoe5e8VgDLJyIOxAC3j4Mti6cTSxSnaYL6XVgw3cYXYBBgwXuQ>
    <xmx:W42tamNGiTkYpDfGP1v4_8nCs7OBp0umdeOGzOFDv8yri1637nazxQ>
    <xmx:W42tars6txRish0LExiG7c5cQdNHLq2mj4An-VomNiWtR4TtNKtmwQ>
    <xmx:XI2tamzGAStdedKZfikY9rqhECcaCfAwxMJO-d_nH7HrxY26gsCHwJGK>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 15:13:30 -0400 (EDT)
Date: Fri, 18 Sep 2026 12:13:42 -0700
From: Boris Burkov <boris@bur.io>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, wqu@suse.com, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix root reference leak in
 handle_indirect_tree_backref()
Message-ID: <20260918191342.GB2956775@zen.localdomain>
References: <20260916171319.2086756-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916171319.2086756-1-vulab@iscas.ac.cn>

On Wed, Sep 16, 2026 at 05:13:19PM +0000, Wentao Liang wrote:
> handle_indirect_tree_backref() walks up the tree from @cur, storing the
> reference returned by btrfs_get_fs_root() in lower->root when the top
> of the searched path is reached, and dropping it once a node already in
> the backref cache is found.  If the walk instead reaches
> BTRFS_MAX_LEVEL without hitting either of those two exits, the
> reference is neither stored nor dropped and is leaked on return.

Are you able to reproduce this bug? If so, can you include that
information in the commit message.

> 
> Drop the reference and return -EUCLEAN if the walk reaches
> BTRFS_MAX_LEVEL without finding the root of the tree.
> 
> Fixes: 1b60d2ec982a ("btrfs: backref: rename and move handle_one_tree_block()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  fs/btrfs/backref.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 273924ca912c..e889fbec4fe1 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -3426,6 +3426,12 @@ static int handle_indirect_tree_backref(struct btrfs_trans_handle *trans,
>  		lower = upper;
>  		upper = NULL;
>  	}
> +	/* We walked up to BTRFS_MAX_LEVEL without reaching the tree root. */
> +	if (level == BTRFS_MAX_LEVEL) {
> +		btrfs_put_root(root);
> +		ret = -EUCLEAN;
> +		goto out;
> +	}
>  out:
>  	btrfs_release_path(path);
>  	return ret;
> -- 
> 2.34.1
> 
