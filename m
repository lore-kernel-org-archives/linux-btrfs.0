Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9AF40DFD5
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777069422; cv=none; b=r0BiSK659vYdjCuf3nr1TJxJPelh/97SEpSHBjfd3cMeFL+3ZDbS9NNdlekDfK7RWgoboanyi//D3FwDI2ciyOWPw6UokoIqKwH1F/j1ro7YeTWLitQgI9lL2lbr2XHzIpICao/vGAKPMGpDljNzkp7UZuSdTHE7LmHTM4dOAAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777069422; c=relaxed/simple;
	bh=3yQYafbSc09CyvB7l5fmMjv1i8CsqG10EtASOjphj3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bcx8xxX7m5ny1wv4VtJJ0wrzBuD1VmHKJW7xLHPqkjzD9ja5d3bm3N3n0g8aq0YKtzyek5kG18LnK4xuqyCN9w2Gc8KFGpRD2AOot9qpCy2cD+juZGFdsc2xKMjIXvfSerpfN5WtFrHRFi/qPjnv3YNuNCOkpaLQyaD2EuATRGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=yBYGfWr1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Z88Zrjqc; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="yBYGfWr1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Z88Zrjqc"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 647DAEC0184;
	Fri, 24 Apr 2026 18:23:40 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 24 Apr 2026 18:23:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1777069420;
	 x=1777155820; bh=ySFKXyCDILpHQyygTUwWz0iC+eTRZEyY3hUWsQTuZ8Q=; b=
	yBYGfWr14Qe2dcuEQhxDIHWThf9UIbH7HKt6YQyT7yGChSTBY3gfOclrhgtZ8+lA
	VqWUKkqwGLxnjVwg9m7tU0vwYYY1tiDi7RuyQV2stQZiG3gsDntjGED/xwqb821h
	9mdLM5iB2L6YgCp03UwX6KtX7GfdgtifD07DUkGXJ7WRmhSrNDU7Oso8TnEPzchU
	ZCAS4uMl+l5fBtFc437f1+viZSnR82PLt93t8ouSRo5dn7jgQ939PHMJIUxe5ePO
	bFuU20TdFRRzslDmi5OiUYGw6noZLHaO7U3muTQXBBEyMSeZVBpvYUS38GCJ4bJ2
	/dOVbS+ZyuB1EQxdmBr/QA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777069420; x=
	1777155820; bh=ySFKXyCDILpHQyygTUwWz0iC+eTRZEyY3hUWsQTuZ8Q=; b=Z
	88ZrjqcZWg4/P9N1xOTavONNY8K2Fv1K7t0jFwukSR0aANSsTveiEoulZfkLX8nV
	xonHD3clIr+XHYSxsAg80q5T9n28H7nP8LX1X5KLBCDDH6+pqHAov4zpre81whZe
	O83mwCC9MiPx3FQFdVp2LC3nL6+1jcESMgs91Vz7eeZjljCHxGsDB9X/XSQZB3gN
	jrgDSO3mTkADm2pODpMeqeq/pBgIhEJu9a2sLrrupsy0gxDVNB1+sE11fd/VYfig
	+CdG7Td2wEVmPWaDtk4VDhYM8QP4pi2kRNUXiFBTf/Jc5P9+5c7+Xs20V1l3kh6g
	lIQMkTz1E9PCz/qTUtx0g==
X-ME-Sender: <xms:bO3raTM8d7HjtGUYWKbl-a-NZwlhlsqTOLZ-Oxv6atIxP9YT08CPJg>
    <xme:bO3raVZrsBr8YRxFheEpdNtG5eMJShZf_n_4mZRXTeCXyLnhK9PtBLWQFx0yhLYQ5
    B2bLePPGt6lcoToBvf8fVKH3Fsr0SHPHvoZ_eBXb4zKD7LBvim5Tj4>
X-ME-Received: <xmr:bO3rafr_UpnnG8sCh1018kdVkjPE_7YUZBrSREAgJqO9mQkaPbkTDv6XXDNbmlswv4bswU11S5sLhspjLIFH66K30y4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejuddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertd
    dttdejnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudelhfdthfetuddvtefhfedtiedtteehvddtkedvle
    dtvdevgedtuedutdeitdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeefpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopehquhifvghnrhhuohdrsghtrhhfshesghhm
    gidrtghomhdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:bO3raRYdlIk-Q5f2DQetyDt_q6zvCpPTZs6kEtJvt71kCQ67wy5zew>
    <xmx:bO3rafSh2_TTccNf0dulieyijcZU7qTQWRcwQ8fRpvoMUokelWwtXA>
    <xmx:bO3raQ6uhoTde-92E8-mMcasUtVoBbw0ymfuiK4d_AJajNB1X6jbAg>
    <xmx:bO3racy5c3QV4FhbBrZD3rc5yTf9hZw_lRHk4GACd5kPuYI73ZmSNQ>
    <xmx:bO3raTZ9dgtM_yMaIG6jzSNmdKhnyKh9jD7ZwmZp-jovAoGR_I95li9A>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Apr 2026 18:23:39 -0400 (EDT)
Date: Fri, 24 Apr 2026 15:23:01 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 4/4] btrfs: cap shrink_delalloc iterations to 128M
Message-ID: <20260424222301.GA2978226@zen.localdomain>
References: <cover.1775756789.git.boris@bur.io>
 <b990d13d17d8f6eeb341457801fdaabdf123f8e3.1775756790.git.boris@bur.io>
 <54030bf6-56a5-4633-9bc2-0008ca43191e@gmx.com>
 <d916e8e3-0c25-4540-b829-a13ef058c762@gmx.com>
 <20260424201054.GA2801466@zen.localdomain>
 <2dd6a177-b6f5-4c15-976b-7897c6d468dc@gmx.com>
 <20260424221059.GA2970690@zen.localdomain>
 <8bf661bc-2536-4310-a5cc-638b5cd9d25c@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bf661bc-2536-4310-a5cc-638b5cd9d25c@gmx.com>

On Sat, Apr 25, 2026 at 07:51:01AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/4/25 07:40, Boris Burkov 写道:
> > On Sat, Apr 25, 2026 at 07:36:49AM +0930, Qu Wenruo wrote:
> [...]
> > > At least we got something that both of us can reproduce.
> > > 
> > > Another thing is, for g/027 on arm64 I'm also actively monitoring the CPU
> > > usage through top.
> > > 
> > > Have you experienced very high (~100%) CPU usage on a kworker during g/027?
> > > 
> > 
> > No :(
> > As far as I can tell the system is stuck waiting on a commit. I'll keep
> > trying to repro your symptom.
> > 
> > I'm curious if it goes away for you with Sun's proposed fix, something
> > like setting pages to at least 1 after those to min() operations.
> 
> I go with the following diff:
> 
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index e931deb3d013..2c5214b24239 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -770,6 +770,9 @@ static void shrink_delalloc(struct btrfs_space_info
> *space_info,
>                 u64 items = calc_reclaim_items_nr(fs_info, iter_reclaim) *
> 2;
>                 int async_pages;
> 
> +               if (nr_pages == 0)
> +                       nr_pages = 1;
> +
>                 btrfs_start_delalloc_roots(fs_info, nr_pages, true);
> 
>                 /*
> 
> 
> It solves the dead looping kworker on arm64, now the it's several different
> kworkers taking around 5~15% along with 027 itself taking CPU time.
> 
> But unfortunately the test case itself still seems not to end any time soon.
> 
> I believe the old 3 loops limit is really what makes the difference.
> It's ugly, but at least it seems to work.
> 
> Thanks,
> Qu

Thanks for re-testing. Glad to hear that at least fixes the dead loop.

Honestly I should have known better than to include an unbounded loop,
that was stupid. I even kind of thought it was dumb while doing it but
convinced myself it "must make progress one extent at a time" or
whatever.. Obviously overlooked the min() bug too.
