Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB61B51C07E
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753022; cv=none; b=ITig7YKiocx90CBNuHPFrTHLDcfw5O5xZ/xvdKIRw8aCMllIlH3Wuk/2FoY2xG5GfqELUs9aHCJ7euUJ6kwWQW86eQqln6uVMWcVgxifzMVtyiC0s+oPQEah1xlXJgof9cyEhTNPvIMYc9REeQCiuEdIJALbUKGXDeCUJTxWKtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753022; c=relaxed/simple;
	bh=wxOSapx8DMkUps6NgP2ajM2KLXNA0MV27haunRBsSfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mM4GC+nTdOoGH/23SOBHBzglHpVP1r9wSttih+iUJVBoKQmnoOKVM+hafGmFFCjh8UgmOnk0aRAJDDlDvx4TcrcdUGgTdwJ8u5USbCzcLcY8bkSXVTAdnVG7IXW6S1TCDJsgnFXyzq0eLmu8MihrUKkRktAA4IvRC7nnFIv+EZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ne3Tny7S; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=UEU6miNf; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ne3Tny7S";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UEU6miNf"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 97D4D7A00D5;
	Fri, 18 Sep 2026 13:36:48 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Fri, 18 Sep 2026 13:36:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1789753008; x=1789839408; bh=UHuz+2nguL
	l4dgSwH/JNn79y7QXx5WkU9TI3YZ98orQ=; b=ne3Tny7SGPOxknb46L4hnbxmOz
	xSYA58+QeZz3p6kg76+Qvw1tO5vf9u3VaOQE4aH5DHAg1NapKFEAULgvYMI/A/bM
	K5d+fmzzM1U2baLunXfnhuFHsrTdOpxAiPViStR74QC5ztDNf+p41WkolY/zi+5Z
	3572q/+Lbj7k8fxXXvPhklm8cd4cS3L5wpuBfG1ScItcKvemeZg5UvfnY4MtGVyT
	owuFEk9h09S5JOhkJPtTsP6TA/aHZFMpJ2rnH9831shg1IjsFtKUQGQIxJumP9/N
	AO/RnHU9mWwfDV3lh00gzf9r8N08UXVoMcfMBH+PIGCwiK49n+BDD0SUFrIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789753008; x=1789839408; bh=UHuz+2nguLl4dgSwH/JNn79y7QXx5WkU9TI
	3YZ98orQ=; b=UEU6miNfLr5tkCFvHxP5RHnr17TDtJAbidcnkNVQrUeCFng5bME
	T9mRnI0tgb7mMF/sREIF1Cs/nxRpPzoTk5VaMO99oshT59h24AGIQuMlHEXUuF6Y
	ug9q2o74R8rKevwTyhWslqrRqPq4koDFqw1cJg8pKbKxJ7wYp6BV5zz214lJBHEr
	nSeh14fOGiGozvhumuYS7HxYU7WA5ooY9cq+VyVDlLRIUAasWKeLJSj3ravPXdNh
	SdZTieKuMAb6vJKCJweZYogDMaeOTFhpC2/J3GR7JcFeHoQlazCTj7gdM6XDTWLi
	DoIqpjcIt19Hsq3ZaB/SKGB39K5Au9wCBhw==
X-ME-Sender: <xms:sHatasnTaAch-C7MyQbPrT2jWeX_adJHExSF2Jkjwyam6dDZHlcIqg>
    <xme:sHatah1iyLlJ7GXeKB-wSFCxC5zdMsC90U9HTfUKaKn49k2z-wTmHt9iELizWTeOQ
    Gc2VsVg1F-VLVt8i-7yrVnGiVb-ZwBHCz05PjrS5h2j1RAJRD-RdUuZ>
X-ME-Received: <xmr:sHataoTKfO8A4r7ARC3EvHNrideCE8feTmuDXq7oKt-d5NkMQ_ZNLYw>
X-ME-Proxy-Cause: dmFkZTFOOwOki6yrQm88hlXsrKVeCwH41OLnQVBNE4F2myfqWjgN84SAHIR7o7obLz47DV
    eVTyPLURn4EMZqQNdg3d88GFQtano5bIl/EFUT1BP12/XbNmp7fv/z0HPoTFrX5ZEauYZF
    gH94qfms2CI/JEhUDdyX3Jb3dxmB2qD2TIQzCcJezcglf2AhkxaGiX60mwWYZcBYkn536G
    rU9SsAQzGwdDKN2uENYh/9lLH3Q2TdF68FCIkxWAYi6u2J9d19ULcU7mkTKpyRTpEkp4uT
    G3L0NdK4cYayUvUCgJdXUdPh9eU0zTXSBqoMMNxBtN2MRl6PnC3DE4pYR2yU48ckPXo1qq
    xKuNv/wiZ49WlfcwHv2MIy5H1VvC+sHKmS7+bCv1hgHLD16Awagk+APRD6LCqjvhhSEWf1
    FpFWjznoKyoCvJtpQKWGxl9n7EyZl1uw+8yZmbko/I1niFiqk5YimOU2aNfZRgQo7cXSaV
    1+uLYoYJXhCiMaxrRRVQcslbQdCsa8zIE9KNzF+LZxp6L/sHfOTsFgD5Eph+InbomgVw4G
    aWkEk57L55TtfJ4fyQ/nJN1j2BSbuKtOXGeme/pQWvLNcJyPn1xTLYc4sPgCQs0c2+7HKn
    LzyLwBEJtMZLjEpagGl/3ibA/wHgUYS51C6sukQEAHNm8eXVZpsGKVqQUKSA
X-ME-Proxy: <xmx:sHatajsbn2fs0_CFYBBI8msVxmcXQVIoKE3ZoxMQKACaM1QmonsZgg>
    <xmx:sHatatYXYD8yVqFQ_vR0RzpwNvaiuatdKLXjL40XQZ55yymXXxlvYQ>
    <xmx:sHataotVNHyMjDZf6PjE4j58oGKXa_kKZcg-pV2JIS8L7DQsbqyMgA>
    <xmx:sHatavEA3CgFUaQCZBuTZtLyrPkqg3rQVx_MbKekWNyl5hCU32uBnA>
    <xmx:sHatao66CfI40pCeUWC_i_6KKuVCtEmpK_WzFtvht9CvnxDUsxymX1rU>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 13:36:47 -0400 (EDT)
Date: Fri, 18 Sep 2026 10:36:55 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: fix barrier usage in
 btrfs_record_root_in_trans()
Message-ID: <20260918173655.GC2900089@zen.localdomain>
References: <cover.1789734239.git.fdmanana@suse.com>
 <ded35d39b9858ee6f20ee3358a8e592a36e8e33c.1789734246.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ded35d39b9858ee6f20ee3358a8e592a36e8e33c.1789734246.git.fdmanana@suse.com>

On Fri, Sep 18, 2026 at 01:28:10PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The barrier usage in btrfs_record_root_in_trans() is wrong, as the writer
> side, in record_root_in_trans(), sets BTRFS_ROOT_IN_TRANS_SETUP, does a
> write barrier and then sets the root's last transaction. This means the
> reader side must check the root's last transaction, issue a read barrier
> and then check for BTRFS_ROOT_IN_TRANS_SETUP. However, currently we issue
> a read barrier and then check the root's last transaction and the bit
> BTRFS_ROOT_IN_TRANS_SETUP, which can be problematic because the CPU is
> free to reorder the checks and the following can happen:
> 
> 1) Before reading the root's last_trans, it checks that
>    BTRFS_ROOT_IN_TRANS_SETUP is not set.
> 
> 2) A writer sets BTRFS_ROOT_IN_TRANS_SETUP, does smp_wmb() and updates
>    the root's last_trans.
> 
> 3) The reader then sees the root's last_trans matches the current
>    transaction and falsely concludes the root setup is completes and
>    returns without waiting for the writer task to complete the setup
>    (calling btrfs_init_reloc_root()).
> 
> So fix the reading ordered as previously described: check the root's
> last_trans, issue read barrier and then check BTRFS_ROOT_IN_TRANS_SETUP
> (the reverse of what the writer side does).

I think a comment on why we can't use release/acquire (u64) but that the
non-atomicity is ok (we only check equality?) might be nice. Otherwise
we are supposed to have some code like i_size_read(), right?

Not blocking at all, just an observation, since those helpers are
supposed to prevent this kind of bug.

> 
> Assisted-by: LLM
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/transaction.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index c1555621ae4e..13203ea9e116 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -511,10 +511,11 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
>  	 * see record_root_in_trans for comments about IN_TRANS_SETUP usage
>  	 * and barriers
>  	 */
> -	smp_rmb();
> -	if (btrfs_get_root_last_trans(root) == trans->transid &&
> -	    !test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
> -		return 0;
> +	if (btrfs_get_root_last_trans(root) == trans->transid) {
> +		smp_rmb();
> +		if (!test_bit(BTRFS_ROOT_IN_TRANS_SETUP, &root->state))
> +			return 0;
> +	}
>  
>  	mutex_lock(&fs_info->reloc_mutex);
>  	ret = record_root_in_trans(trans, root, false);
> -- 
> 2.47.2
> 
