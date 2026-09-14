Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EE549CF4C
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 22:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789424918; cv=none; b=TSjL/Ef9BaJjpW9wuhQYkpa22ykr2Km20YwVow7hW6LJY4bkkE4sBWAzvQwv+hSoIN8fSCLSrw3u4ERCji0lYV4zk5Ujw40z7GqGD2hEFAIXFrTBPDcZyaFISR6OivwsjEFNTWtgmZe0ea7ocjiTW37BEGCNVv1kM6S0U0Ah9I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789424918; c=relaxed/simple;
	bh=4OxqsoxM6AuH37gEJjvWG2axu8iZE1AFNPkJY2qJgkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D5LAP99qC0EkcNgd1g2VZaqFpgzLZJ8sKXkv9CNTGp+mACtxoq4wftQNj0nCDx9LBc/bxvcZ0MF5woDsI++TG0Xd25grI7v2sitKsfigyWC0MQGdB+weLkjBooj1K6yKXTvpGcrlloZlurSP9XS+UhBcJ+O15v6TKgOJBIWi1Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=XlcH/fgH; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=V9gFKc6x; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="XlcH/fgH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="V9gFKc6x"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 4D0CCEC06A5;
	Mon, 14 Sep 2026 18:28:36 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 14 Sep 2026 18:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1789424916; x=1789511316; bh=YTxVzMsxfZ
	9DNibHLETTNxzpL/+iaqNn+whPgV30eh0=; b=XlcH/fgH7uWQyibuBrwOLiQd8S
	Gkph0i78DFzMP9zfmXRjoPrEq/K1dsL+BOB8FFiFURwOfy+9xy1KdCK35lylvqCS
	5O8EzGtbeU31snRaVFFBGK8nonoOC5eL3r+cZKKIHkQ9wbCJpPWkHBVPtV6mH9zp
	YSgufE/30GHme2yJzQ//bufZb3Ok7KQmNYHiycp0ieddATANnorE2cdCeCpCOHcV
	lhgGa1L/iz2K1HjpUZOtXfizs10BoV9XCO5gYUQKWC2F3BKvnoK7sRA+WKtrljsg
	n3obqMixpcrmMJtpCJLA8leXnWimsaHiVlvgqTF+9JlqB++R+O3ZUj9ZniCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789424916; x=1789511316; bh=YTxVzMsxfZ9DNibHLETTNxzpL/+iaqNn+wh
	PgV30eh0=; b=V9gFKc6xwJSTTccyle4o9a53JUXiGUT5DLTS+tBvo6o0z/FeUSr
	THzD3v8b6UxUBvkKqrOQcG5dqCr6wFcFovMedhGrm39/LfApkQll/rHD6ut3JpCh
	5qR+f2sDiLSV1qF9qOGlyg5Lwe2MoI9tKQNriEPdXS2uEB+PBeD2DoolSLkcUXX0
	rF1lijWD9FJ3KSy6tLBhKFTtatwL06+07rVk04XzEh5MAcMGBYuL84S/bNAvwUnn
	V4bX/zn6BtAyqxZUV+AmAkv2MRMtQYexhDUhSsRiNqo5U6mBrKjht6TuHugsUwgv
	NMIJNlg1fA3BKAOkJAC2rkD9DXkZmweoZTQ==
X-ME-Sender: <xms:FHWoarVAPd8SC4EyjETYJz5C_oIWwtnnZ3wZxajL5LTxRKJTZNRq3g>
    <xme:FHWoapnKporCQHkgMovfxT8xVJXN6Fac3IMqKVjTbDWn1McAGvfDhDF4SSXnFqG9k
    jr4X70DLNauoGm_jJ9RGc7qciAuQdlYnF5Q0O6wlVBiChrhua6WwBd->
X-ME-Received: <xmr:FHWoalCvXorRYhyBrwjuSiH2QlFlBCaqrf_cinJzONiJfEY6BCNmI5k>
X-ME-Proxy-Cause: dmFkZTFuiWjdnDiBJKZwB/2zrRRyg3Y8nIH+qoNF3WzGnMhqU9SM/Zfu1ZobKnyNt4QTZ+
    Zbzfq8BQgA64nZ/MBcgiQgeTZNjie8Z18nhTKKcXCnlwFTFPAEgN+LhPNIgKto1aX2DomO
    VkFxLIJII8ngJKRz4D/RCk97svjBiVLW4yUZJwpKDUmoPOQFl9TP6dMk24At4CrqxYt9Rf
    ZUtIgI+MMO/5vO6MzGFim1NqrjogfLO+naeaJ2vkKM6ypVskdnO0PyRZ4wM2NeW1iqYRj2
    ARCxDxyMh8mZymep3amuuX4+h5gWsSykgGTGCtuY/+o2kmKgBE2Mu78HhLHPPlvgbCs6Ho
    A6G9sIdcq8T8qzRQ8/WnMLKTG0k4IA75KN0t2F0A1DtN3BBKa2gmao1eoMvM8m4KiGjmIW
    XtnM31a/5YJ3bnbnSG/ZEpb5Br06G0RiYuERoUOVmxAujK2UFKplrO2d4dQnuDe/a9N3Q/
    KXsOoeQTVkDDNFGoSnuUFTIak1NnbeS1pgnhCtGiNz4R5ijm25aZgdkFNBi8H9Yjq4Ma/D
    /U6bJcDi8jT6Uv8Eusd3BTXtB94it9Mzoc6tK9Bc8Cuo7gaT83ytO24WsNo86lR7TqdqcD
    ab2Qgai8s9ypGdmox6Iu9JFWvACMJy/ZRIr/JxPOiS2zkcVXv00H3Zh4Waew
X-ME-Proxy: <xmx:FHWoahfObCEOZ5jQ_M3ZfzCUHgKqXM4D3o2t6Vp1IXhCIj5Snt-6Sg>
    <xmx:FHWoaoLndtVLvXBE5sIcM_L6PUQHReRLXTLMde3j1NoZwSsLIxK5ZA>
    <xmx:FHWoasdJD31RN5ns8pp4XCwo5Tve8lDgpnlhnsh8FUuR3MqJ3X5Wwg>
    <xmx:FHWoan3m02zWiN6nMXSp9z83esg1Vr10VRhlVJVavSs_r2b-Kh5CwQ>
    <xmx:FHWoasBnBkRal6TW6LgEL6p0AFJABpAKcWzco5yGwMa1XvTctTMoGrOu>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Sep 2026 18:28:35 -0400 (EDT)
Date: Mon, 14 Sep 2026 15:28:54 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: fix and simplify heuristic_collect_sample()
Message-ID: <20260914222854.GB151269@zen.localdomain>
References: <cover.1789003160.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1789003160.git.wqu@suse.com>

On Thu, Sep 10, 2026 at 11:35:51AM +0930, Qu Wenruo wrote:
> The first one fixes an off-by-one problem related to
> inode_need_compress() and heuristic_collect_sample().
> Thankfully that off-by-one is not causing any real problems.
> 
> The second one enhances heuristic_collect_sample() to handle large
> folios in a more efficient way, inspired by the recent cleanup from Tal.

Reviewed-by: Boris Burkov <boris@bur.io>

> 
> Qu Wenruo (2):
>   btrfs: fix off-by-one end related to inode_need_compress()
>   btrfs: simplify heuristic_collect_sample() to handle large folios
>     better
> 
>  fs/btrfs/compression.c | 51 +++++++++++++++++-------------------------
>  fs/btrfs/inode.c       |  5 ++++-
>  2 files changed, 25 insertions(+), 31 deletions(-)
> 
> -- 
> 2.55.0
> 
