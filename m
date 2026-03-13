Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94441E8826
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 18:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773428148; cv=none; b=lN2MTPezRALoDc2IBr1Ct92wZZ1smNZ7HpBnhcw3RgTr+Vd4Zgh5o0VIQO60VmdYeJ+fyjbcOf4Ulfw8UEm0flidlrT4hzhjtwgHorbBhrTRbgFT14cVNZveHRR8K+I9BbhDwdc59Hgwbgiqna9qX0fBhLY3vtDu/vzDqMyN/Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773428148; c=relaxed/simple;
	bh=5WJDe8u06vwRnyu3ojwaY9txLiysIkg7AKxQxIuKbYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4CqO0poWApP+cuhajl2a4W9oDPOEiW/aDwb9Dqvjx9Wj0nj8vrJrUt2ksoPyLi0dIp+H6lDD9OjQNhsNCoCK5ZswMCbWbTMs4sa1UuAItt5+wx3IiaVqZq1SBtaODuYTWA41I94nIFjs/X9RAjeAi/JaB7l3mSHKcEBSVcVHks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=fsg6ng77; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CvQP4zpJ; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="fsg6ng77";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CvQP4zpJ"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 00C2714001F1;
	Fri, 13 Mar 2026 14:55:46 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 13 Mar 2026 14:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1773428145; x=1773514545; bh=fjxU/wbLoI
	xDf4MdSeDzlSGa20xSyYLYkdRsZmBMMQ4=; b=fsg6ng77782BYa6ta1h+rpnFBW
	LKHWww8gF+dXsqhK2IVm4MjkiuU3vm+YcvKypiltWA6SecG1HFCErqcC2etuogmz
	qK5Rcy2QWIiO1DXS2Ll4ps2H3BujZX+pZeVd0/W8iHHsI501u2J4xhxSuNOLR5I0
	4Jm6jDvZ2qPiY4qSN5RcfgnDMyCgD7+QjC5+D7Br5IQo9hIg2RinPJ+PL1I+FjHJ
	bVTwmnwPGa25RJdmoxt86SiI/+iEYoer8DsAvMjTeJWmRqAVbzWG6tywMHWDW1aL
	GbRs+hx/lHb0oGllAuNSXbHG6Yzyd1FNwbq0a4o/mX/Vf9QbRIaUpKaOlhQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1773428145; x=1773514545; bh=fjxU/wbLoIxDf4MdSeDzlSGa20xSyYLYkdR
	sZmBMMQ4=; b=CvQP4zpJFe9UE1bU1eWXUTTFqmTi0Kck4L4XfgudywLspnymPeR
	9qC2bM1pFaVgZdUcSnqA6xqvdf2uSVBDgq2kNQH2oZrq9gDi5Wpvc/Q5d9r2DG5D
	D1VuXNcsZH4A+c1Ptjp8ZU8pRJR/p7Yf5oZyeDt/z4iDF/GKFhx6Dg8E68DHkfuT
	VqO0UxbCBkkJyH9PiAWGrg+6CZLDezPuJKEktszftNyeZHuTD80xOxTproYs+TZB
	LUK6xzUP4OK+Y2jUBn/F0Q2jiXKvu5ZF98XpKpXVeivBT49JnCmNa40Xvegu5OKQ
	Z2s9P7LDemm2YwFQfDQafJ13Vr2qSxqfK/Q==
X-ME-Sender: <xms:sV20aZjxlFTZm-jL2fRXo1q4_T7pw6WseuGvT2rbvP3GOol0UadnYg>
    <xme:sV20aUANLTWDLdBP6of8KqxqUuQpONhwKIfm0ANWHl5PAh30UPhir0b0V6xFgntyw
    Xd0llwDnY9rXI11wh7HGCWuxOqTGOibb8P0jn1fHkHM96RIqDpeAmQ>
X-ME-Received: <xmr:sV20aWsaXwkI-MrfOQPiQLeHPaiiEd841wq8z_n0FvvdoiCbrtcQOsf9bbtxyxeXxKdxEfIbTBXaw_EOXDO-12wDDqM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvledtgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeekvd
    ekffejleelhfevhedvjeduhfejtdfhvdevieeiiedugfeugfdtjefgfeeljeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprhhgohhlugifhihnsehsuhhsvgdruggvpdhrtghpthhtoheplhhinhhugidqsghtrh
    hfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:sV20aZaquLtnoAGjojaMVpN_s23bvY52VqvkXwtDmZSUHVbvWJah_A>
    <xmx:sV20aZXj8Rbl5MuWDQZPjuithr2l1fue_g719JofRkCHSynvDHWX9A>
    <xmx:sV20ad6vabgPjctGLDJsr1F9enRQxPhF_QIRgx-d7E_yDC0zQJ2D_g>
    <xmx:sV20aUgIPvnlprY-lCkrxHdygssQCmmuR5vrMJVqM1b2fMdJnpDxOQ>
    <xmx:sV20ac6r-oEuHBjEvNYpzuQo5QsVsmru5TUBdGAx83o_6eE_bGa4vzeu>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Mar 2026 14:55:45 -0400 (EDT)
Date: Fri, 13 Mar 2026 11:56:11 -0700
From: Boris Burkov <boris@bur.io>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: fix a crash in the trace event
 btrfs_sync_file()
Message-ID: <20260313185538.GA2267895@zen.localdomain>
References: <3srimnopvbtufn345f73ahr33w57vryl2fxxn2flp2gyc2lr3o@6glyzvqevghe>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3srimnopvbtufn345f73ahr33w57vryl2fxxn2flp2gyc2lr3o@6glyzvqevghe>

On Fri, Mar 13, 2026 at 02:11:39PM -0400, Goldwyn Rodrigues wrote:
> If overlay is used on top of btrfs, dentry->d_sb translates to overlay's
> super block and fsid assignment will lead to a crash.
> 
> Use file_inode(file)->i_sb to always get btrfs_sb.
> 

Is there a relevant Fixes: commit here?

> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Reviewed-by: Boris Burkov <boris@bur.io>

> ---
> Changes since v2:
> - Use of dget_parent() to get the parent of the inode
> Changes since v1:
> - Changed subject to include trace
> - Use file_inode() to get inode pointer
> 
>  include/trace/events/btrfs.h | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index 125bdc166bfe..0864700f76e0 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -769,12 +769,15 @@ TRACE_EVENT(btrfs_sync_file,
>  	),
>  
>  	TP_fast_assign(
> -		const struct dentry *dentry = file->f_path.dentry;
> -		const struct inode *inode = d_inode(dentry);
> +		struct dentry *dentry = file_dentry(file);
> +		struct inode *inode = file_inode(file);
> +		struct dentry *parent = dget_parent(dentry);
> +		struct inode *parent_inode = d_inode(parent);
>  
> -		TP_fast_assign_fsid(btrfs_sb(file->f_path.dentry->d_sb));
> +		dput(parent);
> +		TP_fast_assign_fsid(btrfs_sb(inode->i_sb));
>  		__entry->ino		= btrfs_ino(BTRFS_I(inode));
> -		__entry->parent		= btrfs_ino(BTRFS_I(d_inode(dentry->d_parent)));
> +		__entry->parent		= btrfs_ino(BTRFS_I(parent_inode));
>  		__entry->datasync	= datasync;
>  		__entry->root_objectid	= btrfs_root_id(BTRFS_I(inode)->root);
>  	),
> -- 
> 2.53.0
