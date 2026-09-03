Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9470433E9D
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 20:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788468815; cv=none; b=rbyjoavuLeCddt5S/LsAED3zpHGkFoE6zDeuIpSUuJodOFAkIl0pYdKRiUdK5g5uLxRG4MYFf5bzdZUPhZaW960xTu+1Z9vG4HTN9/maK/6jbd1EU24StQjm4HOK+Wd7wqDhjo0H8klK7Cakl4bs43Z5AVbCuBl8v4W18rNX3EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788468815; c=relaxed/simple;
	bh=KhvpbCeVQnEf/qLLRkYzuxwB2meKBYRbJdq3TG4sflQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AL8RILjQge+iAxgQE25WsA2J9E8i/Ij54qnyg7dJzNjPFhN2t/rlua2QdCkkwKQtokQbgTGJLMC58aMLtLR6G4PJ8E06vpEeo8GhR5K5IXTbmvJbsiOoknEBFAowv7C/RKobuCCzRF5JBm/vqnjNSCkFJRAJXYkbWFBJgSFkwU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=mBlTeJXa; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=yS2Xw4ow; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="mBlTeJXa";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="yS2Xw4ow"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 469921D00113;
	Thu,  3 Sep 2026 16:53:27 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 03 Sep 2026 16:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1788468807; x=1788555207; bh=qon3LIhoxL
	pdTPaIdBM0Kcn9XtVBNoReGyH0vNOxGRo=; b=mBlTeJXapnI15p+RceecmTSXut
	cOiujfzZjsCn/Ln3e5xcQMwsIrA4h71KraHkN6b33NKNVi2z/HFPnfkWa9GJN9Wk
	COKXp+M5KLwL5zZkBIvJHi1W8iiYnQApzpHuOjeLFHEduONHffe+bPUJeLDDeX4i
	iOA0Y8lE+NxyxOE6J2ydN3CgVQ8mHx3szQmL3topwFbJArVoNrbI6kx1RCnVxpAU
	iWPQQj2nUAoHoR5LtN51D6U/KYeo6jPGL3nDKiiCNpoGeInN05YrGAQULsKccOgw
	9ruzCNmUNTbDfGs7jjqBDQH4dEfFFmgXUWou6ADhxGkm/RKMCznI++HoOnnQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788468807; x=1788555207; bh=qon3LIhoxLpdTPaIdBM0Kcn9XtVBNoReGyH
	0vNOxGRo=; b=yS2Xw4owe92SAAXEtATDROSF14icexzRaW2Lyo0dMPlJk3T8b1B
	XDNuZQyHFohLOSYPS02C7XX0l96bDyJGreMtCxTsvuh3vA2oPR7UJYhOioNCbF8D
	xkqroC7Nt36nAO4mYZxsm87HhogAwBt3A/vTK6hyuXlUBUG/iNfE3tf4/+6Hz3aN
	6BkUFtQ6W7EKY0sjlsHvAgnpNyMJ04riKsmXTRQaS8zD01pW70blUXpbXyZUBiSG
	tlWakbUWM+UKWz+UjroU12KaofOoudvZRJwfVOBRFj3rl87zJF6PGf5gYXOgeM/C
	jOIITtKC/+/X9cvsBByoRecf9B0QqFgL41A==
X-ME-Sender: <xms:R96ZatogQurIBBGmn-UwO8uQu-Z1PS7cY-xrgQIAR-VlDKvBfJvW7Q>
    <xme:R96Zalp4N1UfOqxOWaG7EB_DaO3UMq92I29R1FBOPlLle9nGQYOyhiocB0vvN9FcY
    O4tJZ71NXkdhgwbY9wereYDNVG7zl_XpmMT97d2izx6J_3lNd7oSbWhMg>
X-ME-Received: <xmr:R96Zan0QAFIo2DiRH8vYDbTB97JN6jAmRpnj_1hj_j2RVlvsiM7TN0U>
X-ME-Proxy-Cause: dmFkZTEjlKLoBEbTkCFvSB0kYZM15pXzfCMCvHQDh90Fd3JSjWQI6+XgcYxW9W5MNk6cnY
    oNXWuiL9r90XJMVHUM4I5LLmLwwkUm3Vh6BznxknHt0nYXZ16iIKcA0wmOlTR/OCfLHWFh
    H3xK/ZUaMKwMDgRJXWc4K2L4WE7O/0GdV/9SGhwdt3fSafA5pBfNrFXfc3P8j0yXhWTR33
    j77EQ0neSoS1zciNm5k81GWHXz27hD2JRQC+ktdBnaPz4p0mOLQTileSyhjljcyBX/TlN+
    XOahK2DQO86p/UeRCPjBnqOey9U+xWAD3q7Dll66Fsi+2ZUTaVPpJeahfbXwBroGSM1FWw
    C/6jRDu2ad+0xc/HfpYOWO9FLYvgC2YKmPBmjRKx+p7uaY2u0Y8ydKX4qLGUhtklrbezXu
    tsUrBWiIDT60rz7Ra5sF6AUCT4cofQ6zfMK70ZwyF01xt7azZ2OvWo67uNkWdhZPodsGgh
    IlRfSlKjT0jKllU63wpM61cyLGPHWyhHpDG1LJFt2yIYH1piq/ROfnE6zT+Y2F2ThWlYbg
    x6/uDfsfISFzNLUtp3aWitFUvSU691p821fflzRZf1M3mymwa3BH4CyR83kJIutq0vLbml
    s/K9cXTcW11iVoi3ES/kBFyiSHPLN+45nRO9K5qL9Al04Wul4dRVZWysZEEg
X-ME-Proxy: <xmx:R96ZakCc7bmeC966ZOZ56VlbkMcSs-3zWPFOCWb1j_NrHFeFOLLViQ>
    <xmx:R96ZaveEUxkPBgNNrwG1zKTK1lQDCZC1ytj5Js4wzFjW4ZlEtreD6Q>
    <xmx:R96ZaphyUTWFWPaFFRCg3Lu0qQLRIi2NTrkl_h1KpGGrpa9Z82irBw>
    <xmx:R96ZanoNVzCMAixL6K0inYDe3ZN1axjY7KEPGmkMwAV12nxysIWgeA>
    <xmx:R96Zape_2giQjqnfM9hzJCQM3ZFrB0LYGW7MrGEzxopb7bxVngckG2GL>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 16:53:26 -0400 (EDT)
Date: Thu, 3 Sep 2026 13:52:40 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/3] btrfs: avoid unnecessary transaction commit and
 tree-checker updates
Message-ID: <20260903205240.GB3237930@zen.localdomain>
References: <cover.1788449622.git.fdmanana@suse.com>
 <cover.1788451065.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1788451065.git.fdmanana@suse.com>

On Thu, Sep 03, 2026 at 05:00:30PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Details in the change logs.

Sorry for the redundant review, I somehow also got your previous standalone
version in my filtered email set for reviews.

I like the WARN version as well, I briefly considered asking for that
but figured ASSERT got the point across anyway :)

Reviewed-by: Boris Burkov <boris@bur.io>

Thanks

> 
> V3: Fix misplaced parenthesis in patch 2/3, making a condition always
>     evaluate to false.
> 
> V2: Updated patch 1 due to sashiko's complain about lacking
>     checks in tree-checker for inode ref key offsets and unnecessarily
>     trigger assert failure instead of falling back to transaction commit.
> 
>     Added tree-checker patches to validate inode ref keys and inode extref items.
> 
> Filipe Manana (3):
>   btrfs: fix unnecessary transaction commit fallback from btrfs_log_all_parents()
>   btrfs: tree-checker: validate key offset for inode ref keys
>   btrfs: tree-checker: validate parent field for inode extref items
> 
>  fs/btrfs/tree-checker.c | 22 ++++++++++++++++++++++
>  fs/btrfs/tree-log.c     | 16 ++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> -- 
> 2.47.2
> 
