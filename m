Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B82F2777F3
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 01:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768959412; cv=none; b=aamzRTfFEcYVqprP9ejr+Mu0HmBF2ZJbCKxmgGUz6vb/IPGyGvj38bd3BKYGF59yQOzX6TP/nZBEOHFGmsGCWu8gbtL/kqQOMiNxXE5AhenS4Aka1c1SZ8RJjzdA4oz7kYoCjhuwBCXwV4P70kBbJcPvKAKsyPrszuWRvoMDZvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768959412; c=relaxed/simple;
	bh=PhL4zDnua5AOicVZvnKdwGdrHVz4+yN8wIbMDTctUfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwcesqAsgr3PVmg2JOVdT0XuhYZO7fXsNfESQ83xvpdgKwPKnMV+RrgbF7HH4tnK1DlNpfbuJdJQwGhF0GLZMfHFUFVa+r/J0qChvJnQYGA7P5evuc2CBKO2U5erTStPNU6pNutxXiwEEPJlPIAgETdv0I24rKwEgKIWnGwHG4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=XKugl+t/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DdHcSXp8; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="XKugl+t/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DdHcSXp8"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id DF825EC0239;
	Tue, 20 Jan 2026 20:36:45 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 20 Jan 2026 20:36:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1768959405; x=1769045805; bh=a4JgXccFW0
	PVleTH7lKYdjF/uFkCt3dy1ZD9AWzpVhs=; b=XKugl+t/qPfw0NPjciJpDK2mHS
	H/cSnNqKO52uXKFHSSlWD4nwuY6vHgHOilh+kHz/IPmqAQIqsbizIqOA5J+Y5jBt
	olvTcslnlFZjLe+k43SK9pvoNEJSpiWBdq9MvY7APkudZFuPtz6gTmaijX/fao/2
	Kgo2hu3dI+M3Uvka02VDtIxRcupAEDpvep+VuouXZd4JqEM2ri5OEufvTZI5yfy9
	ctK19zdsODFBi17znLFiZviHl7PGH0F6m84B1RXXdHlJoiQi/e4H59+8A72pZq5h
	ztEVUtworcOkj9pl/myND7Kmj497+1Bo2t8VUy1E+ZInwKgPf8Z1rELfv3Zw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1768959405; x=1769045805; bh=a4JgXccFW0PVleTH7lKYdjF/uFkCt3dy1ZD
	9AWzpVhs=; b=DdHcSXp80+TYQzPpmtvub4Uirim3J8duCuEqvgE3mYmseh0NVyS
	gySI6RpNUECVLQ2wxuor55t3i5irdV6XlfBW4WO8gqKrV2As1VacXhyGRGxAx7Ru
	lTmK+cVeSPs4TTvgzduvTrqp5F7GBCh2MLRjy96+bVx57YVNzPTDAEPvWWCtQV/3
	oIG24TIsgrnWuqtzQrckkUSrU08s2rIh11hvKV1uLtyhnjqdwK0GhN6shXnvikXX
	Vg/UhG1iiBqB3cS19ndcW7YokOWp70X4bh7ZgI815tGrTZyX7dX4zZo3l7qd8GCH
	bvzclailFPpWSMWN65V65urabOqTmS17WfQ==
X-ME-Sender: <xms:rS1waQt93lXxzGC8t4rO4s8rBBd70z6-OAVJwtMNNqGjl_LAQquudQ>
    <xme:rS1waTe_yhwoL5rDwe8i9n8RyFW8x5CgEeE9n4LKgMmxDs16M5afiXnZnV9dUAN_k
    S6nPlUNBUy9PJR48HuWFljBrPa3nYyFXRJHeAjodJkHoVRLhDHL0A>
X-ME-Received: <xmr:rS1waZbKG5fkNrurJqRIbVivFZu7cAzX6iAFLcPI5-eyjJiZuGXmPCtu048SP4fpGuzM4UjMpHXbIfsAtsGrAMiUqpo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeduleelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepkedvkeffjeellefhveehvdejudfhjedthfdvveeiie
    eiudfguefgtdejgfefleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopehsuhhnkheijedukeeksehgmhgrihhlrdgt
    ohhmpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdroh
    hrgh
X-ME-Proxy: <xmx:rS1waeVO-kzqmN12zEPDBHLIH8x7ALcymwoyPVJopy88cm1k6JFpWg>
    <xmx:rS1waTjTV-RprXYtnRpKtGMkGKSx6Thc0tYf5b-zFg10aAHg_gw1pA>
    <xmx:rS1waUUqYQYorixlCXVv4jrYYIpzC5PSgeGMHvJoFnN3lIR0Vh1E1A>
    <xmx:rS1waSOwiazbpHg9OFmUsyrIgaE_W8d_qaaDR3zyVvVNLeiusY9N8g>
    <xmx:rS1waXsnijum01D8cL7iFE8zDK-sQuRle6fcXn0ikNH-QbZvGxvLQMr6>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jan 2026 20:36:45 -0500 (EST)
Date: Tue, 20 Jan 2026 17:36:33 -0800
From: Boris Burkov <boris@bur.io>
To: Sun YangKai <sunk67188@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/2] btrfs: fix periodic reclaim condition
Message-ID: <20260121013633.GA937197@zen.localdomain>
References: <20260114035126.20095-1-sunk67188@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114035126.20095-1-sunk67188@gmail.com>

On Wed, Jan 14, 2026 at 11:47:01AM +0800, Sun YangKai wrote:
> This series eliminates wasteful periodic reclaim operations that were occurring
> when already failed to reclaim any new space, and includes several preparatory
> cleanups.
> 
> Patch 1 fixes the core issue.
> Patch 2 is a trival cleanup.

Applied the series to for-next. Thanks again for the fix.

> 
> Changelog
> 
> v4:
> - Remove setting periodic_reclaim_ready to false when failed to reclaim a
>   blockgroup since it's unnecessary. Sugggested by Boris Burkov <boris@bur.io>
> 
> v3:
> - Fix the core issue with minimal changes, suggested by Boris Burkov <boris@bur.io>
> - Drop some cleanups which might conflict with some other recent patches
>   in mail list. I'll send them in a seperate serie.
> 
> Sun YangKai (2):
>   btrfs: fix periodic reclaim condition
>   btrfs: consolidate reclaim readiness checks in btrfs_should_reclaim()
> 
>  fs/btrfs/block-group.c | 18 ++++++++++--------
>  fs/btrfs/space-info.c  | 21 ++++++++++++---------
>  2 files changed, 22 insertions(+), 17 deletions(-)
> 
> -- 
> 2.52.0
> 
