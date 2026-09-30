Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A5550279A
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 18:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793056; cv=none; b=UpYGnLroysM2Ek6EGUP3/G6MU0Wwj5KGokkLwiDdMOY3GQD54YFbxh8j/OhcwY5a6X1CYM75DZMLsZrktAehO54iBfGSBT0fBYe4yce1wgyi5aMJgpo/lbHl2Dvj2OgEMYWRagPym3Uwy/movEWIrm0hZcVkXa2e5jCYI3+Ffzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793056; c=relaxed/simple;
	bh=Qcl2p37T+0rcpPg4c/e4CZBGKxFrv0tVSFiJGX9J7HQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RnF5MXHJMswHRCT88URXu/vDlmmn/4LWDtv9FKzgurlqTPyaNI9uZtBVzEEyFNXWppZqyde2bLTQZAPkR8FeWdoHQDQeT/4+figS3VJsInnna7/8cPw7QBVcQ3r9vI9dGPEGmSU7Uag0X0NBmzTo8hq3fZCWjfgnbVc4d7yDioE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=neNn7Huf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZGHOBrCy; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="neNn7Huf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZGHOBrCy"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id B1B461D000BD;
	Wed, 30 Sep 2026 14:30:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 30 Sep 2026 14:30:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1790793054; x=1790879454; bh=742vHTOB7+
	B/uE7gqY9XBWUVDClcKF5Hh2OhpwT+WWA=; b=neNn7HufVp2BDYzOFaJy5zaLBJ
	Q0tChGs42i6XTA6tlenXyuAf3vHP/5G1uMGh9YNteb+41+2aDEC2OY6kFiraVEfV
	HXyPcIk8bSrC6zifYI/z+2NG2FokuWyguiBoAMBet18pn2X4JvaNIt5zcgke93yC
	gGLFzbFoXqWa4ykE63nPtON00jf93Fms8xvEGgLfMCgdki24R3uTB5qN2wYIo+iN
	V+E9ViWqtmLYQCATPvRnYNDcjj1lRE+ziMC3spnAYMvbNAEKQgXISJdCf/NE5Jg4
	DFPjbSEMEiwK/vuWUZbLjYmmNGZEhdLiIOHHEC5uRyxsXBFmLKsyM7m4Nyjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790793054; x=1790879454; bh=742vHTOB7+B/uE7gqY9XBWUVDClcKF5Hh2O
	hpwT+WWA=; b=ZGHOBrCyFZH2nhkz7mgEV8NvBJKm3WQvg/5/5nydWk6O37hvCpJ
	wKC3cjW3fI7Ap3A43GeUShuatejIaJionpkD4HhpAcYT69BEYgS7TWdHiWyAuyKJ
	QdkJerb3zwYE8rAiIvgOD4DkHQyp5CUR7cx+COBz4gISN90F1nKc2Ge/YKosWopk
	fEEOqAcz0SGlkcJ7/xoIAaIz2yjFWrZAcvyRzy5lMDIMaMDiq5zYPe4RFpWG1PyC
	Aiv2VCD+NWD0e80z56fPOcg+WxTyV3570mmFOBA48u/l8C5ZfigAVELT+w9ZB/N0
	Iu8sU1cwW6+wj2RoM97yksgJHyge0XzDovQ==
X-ME-Sender: <xms:XlW9ahoF8htTt4zfkgmm9SKYGKwLOEhwMJtUVTXcJmyTwBZj8uHBOw>
    <xme:XlW9aponLW-a6M5eAI3XyyB7bE3PhX155188dYu2btSe4B0uhPPiY8BKE8u7OPt3G
    dpO8FD7dNOOCGOgOnTkb-nk4Oomrjpta_j6Ti0I6aVj2sJMw8gTF9so>
X-ME-Received: <xmr:XlW9ar0uDyrykbFN_UeS_bSs36t7eUcOIi0lfD4Q7RWrywKVj44wa9k>
X-ME-Proxy-Cause: dmFkZTFqB0t0zUs5R51PkDDRhuUC81rgdGhPW6NpWJB3NC9qyJkr407jAeP2cpbHnZJ1Ek
    8qmi/0Sz/rsyI0ksCjbWLU4O5eCfccZCxRYVyaYrDYkoamFD7BPtmaFP2N910S0NN5+Yjq
    DyMYKUDA3JmP+X6y80GmGhgGWbA4i1cvHlGUHHoT8Yannxn67vyqApxxDn3LZ5MZkqRilR
    t6TORzWzyWcCJOjIwW331uzjtWgMhtJXpcZthWGYQok9xoqnIgdbj00Y1vDiITNx8T8joE
    K2Ia7zHjOaLjxxULfc/ZQGu9gSwxVPGirfvX8qB2s0LvbNA2EjpDqgCGP3g1XB1axwrGTW
    hmJOyKlnb1W7gyOIMuML+lDTYwHhTvB+Iud7e1Twnu0t8zJ9HkuFb+ynhHYR4v4k3MYS2v
    L4ftfboOWp9zL3tOAT4WN5fQmrTSNiZuHG8Bi5lAMXEUNEEQd7CYj5MQ+tRg14iyW9pjOD
    eIeIwNdfMLIaI4cPhZ/uPoHglbjwyMtNYy52kT2q8ULWtJ5qCDKJULKhtPpvzyrb/48FOu
    tgEcDVIh6DRQ+xegeWKwl2YdUz5FDiMZXLaugPyhC5LLBcQfTJEKpsIi2sodEdQpm791By
    Oav+7A6x2gtvQAfO70xjSjD3Qv04fcinYotdaTK6s0dt6P8r+B095/6UY1Kw
X-ME-Proxy: <xmx:XlW9aoD9irBA8bwLPMqfsUZiuOgJCUCgtrlPZDndzbnpqcRxcrr5vQ>
    <xmx:XlW9ajdttabWnhqFjIH5wQAIIl9tY2Lq_N56s4yJeYKbbPLh4dcsIQ>
    <xmx:XlW9atjVqvnZnmhm1TB39DdYcJL51R8GZ3L_anQ8sZ1zPBOPG6m91g>
    <xmx:XlW9arrPkRjPig7yyAYd4hl_sJgppYUxDQm1jYbWGb-japIxd-8YtQ>
    <xmx:XlW9ag2lWPJNM291xsf1UXLrulhfN8bO-w9ibSroMPULOxWm0cNNvDo0>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Sep 2026 14:30:54 -0400 (EDT)
Date: Wed, 30 Sep 2026 11:30:45 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] btrfs: allow more fine control to
 rescue=usebackuproot
Message-ID: <20260930183045.GC3186434@zen.localdomain>
References: <cover.1788678078.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1788678078.git.wqu@suse.com>

On Sun, Sep 06, 2026 at 04:33:36PM +0930, Qu Wenruo wrote:
> [CHANGELOG]
> v2:
> - Fix a missing use_backup_slot update for rescue=all mount option
>   Which can trigger the ASSERT() on use_backup_slot.
> 
> - Add proper output for btrfs_show_options()
> 
> - Slightly update the commit message of the 2nd patch
>   To address a false alert from Sashiko, where it thinks it's a bug not
>   to load any backup root for the newest slot.
>   For the newest slot, it matches the current generation in the super
>   block, thus every root should be the same as the super block, and no
>   need to load the bytenr from backup.
> 

I generally really like these patches! I sent some ideas for what I
think would be improvements to each, but if you don't like my ideas and
just want to land this, please feel free to add

Reviewed-by: Boris Burkov <boris@bur.io>

Thanks,
Boris

> There is a bug report that for a specific corrupted btrfs, the
> "rescue=usebackuproot" still chose the newest slot (aka, the same tree
> root as the one in the super block) to mount the fs, and resulted
> transid mismatch.
> 
> Meanwhile the reporter used btrfs-mod-sb to modify the fs to use a
> specific backup slot, then the fs can pass btrfs-check.
> 
> This shows the limit of the current automatic backup root detection,
> that as long as all tree root nodes can be loaded, btrfs will consider
> it as a valid backup slot, without trying any other slot.
> 
> And end user has no way to tell btrfs to use a specific slot.
> 
> This patchest address the problem by:
> 
> - Make "rescue=usebackuproot" to always use the second newest slot
>   Which has the highest chance to still get every tree block right
>   without transid error.
> 
> - Introduce new "rescue=usebackuproot_*" mount option
>   Where "*" can be 0/1/2/3.
>   0 means the newest slot (aka, the one matching the super block
>   generation), 1/2/3 means the second/third/fourth(oldest) newest slot.
> 
>   Now "rescue=usebackuproot" is just the same as
>   "rescue=usebackuproot_1".
> 
> Although those "rescue=usebackuproot*" mount options still requires full
> RO.
> For proper recovery, we still need to use "btrfs check", and a new
> option for btrfs-check will be introduced soon to make the backuproot
> usage simpler for progs.
> 
> Qu Wenruo (2):
>   btrfs: always use the second newest slot for rescue=usebackuproot
>   btrfs: introduce more accurate usebackuproot options
> 
>  fs/btrfs/disk-io.c | 106 ++++++++++++++++++++-------------------------
>  fs/btrfs/fs.h      |   1 +
>  fs/btrfs/super.c   |  28 +++++++++++-
>  3 files changed, 74 insertions(+), 61 deletions(-)
> 
> -- 
> 2.55.0
> 
