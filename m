Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09335208DE
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 18:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792623; cv=none; b=JzA/DGO9ZHabXm51E8pP9+WWftFWQyLbQ3OD3I+7F/5jAn3/M5l+3tVp1W/VXgumZ1gtdAjTmFfNzPVWxopBcZR96Aj6h9a47d/m2fCPUPKEgW3s+dezgbpMtP3i8bZ62MbIt5HAZeVYKBBDvBIRvklrj4+1uERJNrZpoIXXfu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792623; c=relaxed/simple;
	bh=Gqa2Hzn1vbJaug9IYttLXJEbVr4ZX10Xx4CeqyP0PZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I7o9FejnnfDBAC13dsPv+R5W/83DhbtdR2O/3PugWQFeUHI6PANctPYwK7mkXhGd/SScQqrr2+1temhLi/2FUK0I8XOtzSElTeIXsnp3i0cFaw3jk8W8sMBHx/rQORbkAaDmLU/Bx/6XCW7K2ndydMbP/LIOlCpG0ZhA/UKvlHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=umydw8jq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jYrzGWH1; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="umydw8jq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jYrzGWH1"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id BDE321D00009;
	Wed, 30 Sep 2026 14:23:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Wed, 30 Sep 2026 14:23:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1790792619; x=1790879019; bh=wjF98rn73H
	FDRXAxlG5Nt/9P+YCQo5ijKfFMLlXBthk=; b=umydw8jqqPm23CEhYUjYeTfheX
	SBrvoJvCoYiGhZ8yNywssRTkh6j/Mf/SVsP5kovwSceIy0gfmzvIOlHtxzw0//PH
	ZcZ11Gtp/IhjDXSROzVvgOwAabOvJ+YFzToud3sb2iqVW+OGN5BXrONijfFXUcXR
	vLVHpwKNzs8KkQjzriyiQfH0nnxQIQCGfzk7qS2MXxH8+vFmMw2k3mhw7FOzT4xn
	qsAm0B7oFM7qSPUDqWGrDl2xOFDjhYhGkAxoOVRE8egEUxyUrahgO2xBuAiBo644
	Rk8IC6hQw0KMHESrBOM3BtymVRUpBaL2hmdNLiEjlYsTwqT9GSxJRQaER5Jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790792619; x=1790879019; bh=wjF98rn73HFDRXAxlG5Nt/9P+YCQo5ijKfF
	MLlXBthk=; b=jYrzGWH1C33CHm5Frx2Ot7/L5LsTJfYPh7MgQwCva5tsUUHwORp
	tPTO8HMAlqufD8LGqbome0ZOZLy9G/kdL4Z4niMhEJW3e0umDwCn5P47MSYok3Wi
	4bt2LYdd9xGTb/psx4Fe0+Mm8y1LOkwgjk5NYCBRC9Mo1P+4e5Qs34wpFKn4HyXL
	+Hrs8FYZhpKIcoo3jRQuWM4kM0mlEyKjBX0riYOm/Ih57F8SFtTSY6GHFSv+KYf9
	81yWvmf8ZkoxvNRD08WR4zWxg422kcA2FTXAARDqoYsRZkztis0qVp6YoPikmMQT
	/602jxOFV2ayMSIUzGf4LeVH4+FjZfMs3ZA==
X-ME-Sender: <xms:q1O9aiADl7XE8diAm3RyroDkyNwHF2VFCxfMzFoHsI0cb-XCTv2BQA>
    <xme:q1O9aii0Lniw71qQ6VIpfURY2axZD2y2PnPRocUYzPV_VqF3b67gzrkK5Yq4BreWI
    XF4QUl42FC7sEsIWXpk6sWMMSreDJ0lVIvuqmzxXc9ue9NpsyBsrHo>
X-ME-Received: <xmr:q1O9ajOb5xpM5Atk8kIjNp0hm9A-RSGHm8xaY2iPGAVtVKnF36uHuDY>
X-ME-Proxy-Cause: dmFkZTGQ0xzT3N0tenB4a1ef4oR2emIIMddpLAVUtVH3dl/L3a96zgYmHR2KjuRbHliPS+
    IWCGjYuFVmyb0fMT9pYuOHCKaTLg/3QGpQISs0xkfkufa2m3bRN5kOg7KB5kEYwBVDoJ23
    pOHbW8Vijc5ldhVvJMxDDOGuz8CiXcyxNlin/9R+Nw7aH42bL6Dx4hPCx/un0EQoTO/LI3
    Dd/gJi0x/gaE95ylVpuwcVoOOCfcamCdUgsAWaRVWlSrwNV4VXgXk28+l3akFqZqvsIRTT
    ZzbmiTQMUya3YClknGdQdRoPcswSY9jJJI+0ZPWSyxdOCkFLq/KlXeWt+JaaMxZb/L80e8
    JKXYDWNdGBXQRAgsX9E73/wQbziViAFqB6gM9ruKuqqWvVByJ7oxH6KajXWHLT149Bo/xE
    h45KJewCtRSKqK/wvS4krQHZwJZM3G0tXvBCLsjx5U4lwNWiQP2bWtvybDDjlnuOdAz91v
    X2mpvEvKj/FPMRCnjhY28TPb8QVk509xyeeiccISlB2dI3hUug/EGTHqo+RulM3J8hgAIy
    XiAgSRpkZitpeihk8aZz4iFrpwKb1ZFTez8g37pkr0bLy4bkABg7SRWLMlMFvepsUmC5tc
    4pKrWJSAq8m/PmFSkF6khgZxcn4uIc5GZE04goK3O4h2fanK4t4MIVuytiLA
X-ME-Proxy: <xmx:q1O9ar4v6_6n6iQnJYryVayvepMS6sv3jXN2pMpKDvrYxwhxV17y4A>
    <xmx:q1O9ap2F9ofVAlLbbXMThA6fXmdiewrITnp0MkX8aIpssxCfzmCgVA>
    <xmx:q1O9akbdVVDlH2Wlo53cmRO1ScAzsY3PlGWh9A3oQ8wCAVkuDPH6mQ>
    <xmx:q1O9apDNeOWl7nq6mIad5qfeKWCkT8ZrrxMvoG7hOi4QSLnCSjHfWw>
    <xmx:q1O9asOj_TOXABIFKT0JsKzu7yB-BBUIJ6fYihkqogj0Z9fl713loZiz>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Sep 2026 14:23:39 -0400 (EDT)
Date: Wed, 30 Sep 2026 11:23:25 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs: introduce more accurate usebackuproot
 options
Message-ID: <20260930182325.GA3186434@zen.localdomain>
References: <cover.1788678078.git.wqu@suse.com>
 <9c907c139ede11a4b3026bd15b310de034690bc6.1788678078.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c907c139ede11a4b3026bd15b310de034690bc6.1788678078.git.wqu@suse.com>

On Sun, Sep 06, 2026 at 04:33:38PM +0930, Qu Wenruo wrote:
> Previously we had no way to tell btrfs to use which backup slot, but
> always use the newest backup, and retry until all backup roots are
> exhausted.
> 
> This doesn't give any control to the end user, even if the end user
> wants to use a specific backup slot.
> 
> To address this problem, allow more fine-control on usebackuproot rescue
> option by introducing the following 4 rescue mount options:
> 
> - rescue=usebackuproot_0
> - rescue=usebackuproot_1
> - rescue=usebackuproot_2
> - rescue=usebackuproot_3

What do you think about mirroring the compression levels and having the
option parse as rescue=usebackuproot[:N] rather than 4 options?

> 
> The number 0 means the newest slot, which should be the same as the one
> recorded in the super block and no need to load any backup root.
> 
> 1/2/3 means the second/third/fourth(oldest) backup slot to use.
> 
> The existing "rescue=usebackuproot" is just an alias of
> "rescue=usebackuproot_1".
> 
> This will allow users to choose which backup root to use, thus can have
> a better control than blindly choose any slot that can pass the very
> basic root node checks.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
 
