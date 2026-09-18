Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45260502558
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789751939; cv=none; b=sH0NfDpbFaqTOxOrOQWYSQLt4l1hH/Ck+hiBmtNHaUiGSXoRV4BhmZl6SvMOFVWfNNk8Y7c0AElrRiCeycJLO8e/UPyD5y2BIqRjRf3AbE4MfXb9ZfCprlkegHkv/5A623Rdi7yUD0SqusDAsz9tMDsS6a8L73unwIETkC+jOsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789751939; c=relaxed/simple;
	bh=Zdl0y9NzdjV929NUjPBawED7mIDitPEqLNfoUdwLw8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3BbPQ45NIyt6GW93PXq33UVD8gCOjuMfEImXjnu7m71h2SITxgA7NAuguufjfHxhTFqTaKW50fjTdVgjPuCVXjPm1NV0yYqIw0HErqvbBHtrZ8Q4y9I/iLmosgG1/f1UtBr95IiOjI6jnvHeJGqP0JJX0VDgn79mriHg7DyUAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=t6iabnvQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fYz0cb/B; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="t6iabnvQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fYz0cb/B"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 280231D000AB;
	Fri, 18 Sep 2026 13:18:55 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 18 Sep 2026 13:18:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1789751935; x=1789838335; bh=/bFUISVaW4
	wX+yJ2Y2SJRJXloX/6gn/GjCYKXsq7wPE=; b=t6iabnvQQcOvZtfbICezzTrOZS
	Pz84l0i8GzeetYaav3Po7Vu3iQJauSIez6iFjdb/fu3GCaMu6y2J3+di0t8W9CUI
	gvalsZ9xFc8CcRsheaJsdf3Da7kSW5HXpzn+bqg2l6vsfj3RQ2hzGZhSOX5rAOF4
	CeJEg71/cDpLI6PfyMSE5+rwh0UgrPtLTavxLm5+ZJP86U9g+1uwY0ZCaGhn7g7v
	YJGl05GRXIfVELqt6aQMQQFesfaJTAQKDCVM1bGOpLrpAS3gmfc5L0Sv4FXHpAzc
	hTj2VuWqAivDcPMC85MyTixRUi4IGBOzUe1H/dulJrXf4WCa2y8vIfDNK27A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789751935; x=1789838335; bh=/bFUISVaW4wX+yJ2Y2SJRJXloX/6gn/GjCY
	KXsq7wPE=; b=fYz0cb/BvwtV8m5D5YoorVcRCctSD8RT4g9Ky+uQGqH0nGnOsJA
	buoBVEp79svi5dI6kDb/g8JcJ1OtqUAlRs4SomTQa+CJOGILipx0vkhuEgZTa/3W
	6fGgHOkn3alf9euUv+ug5fBSrR3hzoa9UE++EhHtkzbYQHvIrOoAiMan2VxMxXI8
	k9Dv3tphcpZJApSsfYWmguJIKpa9+tZWv3QnyevZt2Raa8IsyVFqUuahxyUBeSP0
	R1G0BOfTFmm6DYijklyHbBxpUq0EWKovcmcrA986vBdcyKxNy4DWfjr9nwwVykg7
	W7SBt57C3wKuU4uyORSe658LxB48SNpcT7g==
X-ME-Sender: <xms:fnKtatV-cM1fLTaI4LZeXZ8I0KE5FbCiGeEb9LzSZDBOmLtlleoTvg>
    <xme:fnKtajn-yAXPsPhnI3wQfluhRCG_X0wjAHM6E_8Qw93h6wgrfQ7LfABz4vOg9Y15B
    uvuKYHpZvsb4BYE5qOKx34rJyydL3DXj0C3qb3oAqYxWz3MG7w7aL8>
X-ME-Received: <xmr:fnKtanBq0Am_e_WwF57iZKnBjOaA9LiUw_BzEK8xUEUhyVr7VMY-LXE>
X-ME-Proxy-Cause: dmFkZTEpgp9ywCeOdR+CqwJEMHkn3+2+BDhjTKbJLpn74jo1wSLYksKbaODnCu4/wW9JjG
    skty2erz7/oBSmv25YMBRfgbGiahu+UflqtCBnNuPJIvlLwPvD5q0zfJNQ4mOoZoTs71mo
    ++xFqvvkt5l8k2TUB6fnOLhZX7Yi9IYJcrRUWwu8JqfFvbheQ0RLEnaicCvhwIA0vKDD3a
    dO0kMNCB7Wsi77Z0WTzSFeNuBIAVP1+BqJe5OHOp/f+SsW4XICnzmMWNQmQWvabNwdQ7ke
    jSo8Q+1xSgEUkWDHygSyssSsqPQD+7wUdlEzn6pg9d7Kd7RRRkYD1SlMhQJ+Q2OmOTuPh3
    JUE746lHRU45r0Au7Yrkqkz1vZI/QQz2L/+A+fpmHr1xxpNyLm3QfjnMvWeyMqCrAjFJqx
    SCcAkVzYE5llhYDo6XmO1U9ruxdDRhF37F3xytUyvE7lBKTca7EH2gS8r1oFPfHzMq/dGH
    3saNT4CA/XowGfAc5GHi/1OHNYjVypRNnOQiT9qfR09uExwIXFeiQ4bKoR+dkhygG0+zif
    nDjc4CRUsiU7sLs6xpddDi8KQMPCwVKAmd2zvTqJFGC7932s7+JkiEi78LmhOETFTNYQAN
    pOf/uJR2VA7E4P7tUVf7iNjUXKnYMNJLzFh8SUWLTQqyaklr31lDdGJW7Row
X-ME-Proxy: <xmx:fnKtarc6eNSqsPZQTZK-v1FvzTebgRJPEn9WtvO94xsFzdPe_ZFtOQ>
    <xmx:fnKtaqLnazhvyv8GV6xAQoB-wztHyjFVo05uBpZZIkNiyZLMV8ZPEA>
    <xmx:fnKtamcX_Zq1JlKICXEpqs_YqdHe_t09J7uDVwhJKagsRNaSGc0hIA>
    <xmx:fnKtap0zUiG-pWH8hCzcxACw_cRFhYWrP0uA7nk6bXF3Yj6rueMIzQ>
    <xmx:f3KtajqzygLojka9khir1STcpMnVUiQ1wCl9MOKixF2KWqkTlcXyqG3C>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 13:18:54 -0400 (EDT)
Date: Fri, 18 Sep 2026 10:19:06 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: clear BTRFS_ROOT_IN_TRANS_SETUP on early exit
 from record_root_in_trans()
Message-ID: <20260918171906.GB2900089@zen.localdomain>
References: <cover.1789734239.git.fdmanana@suse.com>
 <410734082c3a544458920efe7be7a39222424aeb.1789734245.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <410734082c3a544458920efe7be7a39222424aeb.1789734245.git.fdmanana@suse.com>

On Fri, Sep 18, 2026 at 01:28:09PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we exit early because the transaction that last used the root already
> matches the current transaction, we leave the BTRFS_ROOT_IN_TRANS_SETUP
> bit set in the root (which we just set right before the exit). While this
> does not cause any functional issue, it makes callers of
> btrfs_record_root_in_trans() always lock fs_info->reloc_mutex and call

I found "always" kind of confusing here. It's until one succeeds and
clears the bit right? It kind of makes it sound like it leaks it
forever.

> record_root_in_trans() for nothing, causing unnecessary lock contention.
> One caller of btrfs_record_root_in_trans() is start_transaction(), used to
> start new transaction or joining an existing one, which is a hot path.
> 
> So clear BTRFS_ROOT_IN_TRANS_SETUP on early exit.
> 
> Assisted-by: LLM
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/transaction.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index ca114235bbe1..c1555621ae4e 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -432,6 +432,7 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
>  		spin_lock(&fs_info->fs_roots_radix_lock);
>  		if (btrfs_get_root_last_trans(root) == trans->transid && !force) {
>  			spin_unlock(&fs_info->fs_roots_radix_lock);
> +			clear_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state);
>  			return 0;
>  		}
>  		radix_tree_tag_set(&fs_info->fs_roots_radix,
> -- 
> 2.47.2
> 
