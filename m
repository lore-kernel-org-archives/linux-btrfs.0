Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A0839A7E7
	for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2026 23:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779321475; cv=none; b=gDvqeUP0uRANsqD99Fje4kau5ZR2CpAK5ZXCT0LI4Yr9ODiqZW4m8F1al7bHgae31GNm5LGgqmB3sYW4fgxK25QgnDeDJIfA8JSOlF9A3XMSk4WXdId1YKMvfdTsn54cN6+cyJxipXRk7PdB3b+udqm/XDR8G2RGoLrkKKuOYE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779321475; c=relaxed/simple;
	bh=GoHQlf5ef/GiHcepA9imQfUutQe5Fx+3VOdO+PtcW4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxJiiOVIB4CqnV1ncTmdsOsZ91w6a5tlc3GPRwJYbAeoF5lmAqjitFqXaxgK8wn9pjIWVtFV1rgpPRQKuV/xK9GP9WhRCW/YHI4gsxOwYpn1YCNGLOrOcoKq6KarOTahAMmPBA3taraQbpjfkDkAZRcXXuZCPkdlV9w20yBjxyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=YFzdydRI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=c2a8dsY9; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="YFzdydRI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="c2a8dsY9"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id F06981400101;
	Wed, 20 May 2026 19:57:52 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 20 May 2026 19:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1779321472;
	 x=1779407872; bh=bTm2D8k/IBcZcbCItgZrQmC5nsuL8UPuFp7Xlnls2bQ=; b=
	YFzdydRINTDKbi5v1np9SVqC7lGLxQCbxbQOolWJIEsAJ5x/zZboRsj5fo5gbJmN
	6SHNvdvsI+Oh8ztHPotESbvos5fY7PBHA4ZiSA5iaQIge4AreFndzwrjubLhDyCM
	7QRtcV+Rd90JAXynWv+G/wnlslHumpbUzPt7GxFYxWOWy1DxG4Uhb4pUrDPw2KNx
	d3ZwmxcEcJ7yRfS0HFGFvD1VS0gPXN+4yA6OYsmfDAjMPO+KJiRC7dPktau0dc24
	uQQxp9Rv1jgz+jP059vLCAzw4BdN0OY9uNih3MYkznsNG1+QPL5mYnbs5DHMnUY9
	d8EBRQCcdp+5FrtUVh3ZAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779321472; x=
	1779407872; bh=bTm2D8k/IBcZcbCItgZrQmC5nsuL8UPuFp7Xlnls2bQ=; b=c
	2a8dsY9as3UXNp9DF9+p58zwC0CiSrzX4yZ2Sc59Ipy7LtkyhrXAvLzQw12p0i7I
	5Bb/CmEm8NnfSAFH9DAZKICzla7nMGgw5/tuL9rE67tIOY9GyQLdVQ11tiG5Cfay
	Ozi2r6SLf+3hDmIcuiPeECHYnbxHPtuB8qNem5Wsmf4BZIP3Elk+BZ572uExvZta
	f8E8DlESo7kNpJHLR154WL1q3zLp8f6k3KJQJ71cK6myo7KuygZpEyehGjuq9QLL
	NVcx8TmWbIpH2J2W/fe4pCdtDneN6157vDXPuuzP6UG/Kv1L8gMJhz6uvHranuK/
	y3rZMTINa39Y/mmBGdunA==
X-ME-Sender: <xms:gEoOarrAha7nQLEJt7ElPmPA-jkBUWPtRBzkXjYqEzs-S53cE76EgA>
    <xme:gEoOarrKJUrXDsoIiIPK_zWe-kBHZyEEenJy_LCrUJgeVPrMEccYZZj4Fd6T46sdw
    XP7U-l8kaZyfkD7gKCrPvEwP1n9xe3m4m2B_3QqoK3ywBVp2mMjvFs>
X-ME-Received: <xmr:gEoOal1j--nTPPy314yEGj3SQx_1S8uWSlWJlycepw_NzNSiKNK9FFlBFxsyfUPEmPPoiU2R1-UT2CyeZn2KLd-qz9o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeeitdduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepud
    elhfdthfetuddvtefhfedtiedtteehvddtkedvledtvdevgedtuedutdeitdeinecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopeifqhhusehsuhhsvgdrtghomhdprhgtphhtthhopehlihhnuhigqdgsthhrfhhsse
    hvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:gEoOaqAl5eJoquTHWyrnxHkOVRlKrRYzxCpmU1hw3Jk4B8dCm_Kzng>
    <xmx:gEoOatdCpdTBWu_9MTJbIAKpBv3JV2mLgygy4iNhTv3y1aYOmPQtLA>
    <xmx:gEoOaviKNrL6LDYk9oyTRU8EPeEkQwB2cKS2gP8g10H4kxLSFbZ1VQ>
    <xmx:gEoOalquSOp7zqBBvL07a_K4Bhiwu5HWgTluWyZa_HjjxuKVM-NK_Q>
    <xmx:gEoOaq019px2vS7EaGC8RNaFWxpcNRGFkE3RLBSAQ9-EL2M4RmO7YidL>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 20 May 2026 19:57:52 -0400 (EDT)
Date: Wed, 20 May 2026 16:57:50 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/6] btrfs: add delayed ordered extent support
Message-ID: <20260520235750.GA1739234@zen.localdomain>
References: <cover.1778902677.git.wqu@suse.com>
 <82ca7628a7a96eb8cde8c1a53f7db544fa2f6ef5.1778902677.git.wqu@suse.com>
 <20260520220020.GB1479855@zen.localdomain>
 <a56287a3-f836-4bc6-9e04-b3939b00aa4c@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a56287a3-f836-4bc6-9e04-b3939b00aa4c@suse.com>

On Thu, May 21, 2026 at 09:16:36AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/5/21 07:30, Boris Burkov 写道:
> > On Sat, May 16, 2026 at 01:15:15PM +0930, Qu Wenruo wrote:
> > > A delayed ordered extent has the following features:
> > > 
> > > - A new BTRFS_ORDERED_DELAYED flag
> > >    And this new flag must be set along with the BTRFS_ORDERED_REGULAR flag.
> > > 
> > > - No allocation of any on-disk space
> > >    As a delayed ordered extent doesn't take any on-disk space yet, it
> > >    won't release any reserved data/meta space either.
> > > 
> > > - Zero or more real OEs can be added to the parent
> > >    If a real OE is allocated, it must be inside the parent OE.
> > >    And such real OE will go through the regular data/meta space
> > >    reservation path.
> > > 
> > > - Children OEs will not be added to the per-inode OE rb-tree nor
> > >    per-root list
> > >    Only the parent OE is added to the per-inode rb-tree and per-root
> > >    list.
> > >    So anything waiting for ordered extents should only work on the parent
> > >    one.
> > > 
> > >    There is a special corner case to btrfs_wait_ordered_extents(), as
> > >    delayed parent OEs have 0 disk_bytenr and disk_num_bytes, they will
> > >    be considered out of the [0, U64_MAX] range.
> > >    Thus we have to always wait for any delayed OEs of a root, no matter
> > >    if a block group range is given or not.
> > > 
> > > - When the parent OE finishes, all children OEs will also be finished
> > >    And reserved space handling is all handled by the children OEs.
> > > 
> > > - Any range not covered by child OE will be manually cleaned up
> > > 
> > > Above features allow us to use the existing ordered extent interfaces
> > > to allocate new real OEs, and wait for them properly.
> > 
> > I am getting comfortable with the idea of the nested OEs, and thanks for
> > seriously investigating the question of splitting. Sorry if I
> > underestimated the difficulty while asking about it before.
> > 
> > Reading this all again gave me another idea that may possibly help with
> > making things as clear and simple as possible.
> > 
> > I'll blab a bit to set the idea up :)
> > 
> > So a classic OE represents a range of a file that is under IO (just
> > about 1:1 with bio submitted, finished on bio done)
> 
> To be a little strict, the classic OE is not 1:1 with bio submitted.
> 
> The truth is, we can have super large OE, up to 128MIB. But our bio can only
> be as large as 1MiB for the worst cases.
> Thus we will have a lot of smaller bios submitted for the same OE.
> 

Yes, my bad, I was thinking about the "submitting" but not the bio
coverage.

> > 
> > This new delayed OE lacks the submitted IO (or even space alloc), but
> > is composed of "real" OEs which are not in the rb-tree. This means the
> > old finish_one_ordered code can just run on the children and the only
> > weird part is that deleting the rb_node is a no-op. But the outer one
> > looks enough like an OE that everyone who looks for an OE finds one and
> > can treat the delayed one transparently by trying to force it written
> > or wait for it.
> 
> Exactly.
> 
> > 
> > What if instead of having both of these be kinds of OEs, we just split
> > up the concepts? One is a range of a file which can have one or more OEs
> > in it and lives in the rb-tree. The other is the classic OE and
> > represents the I/O, finishing it places the extents, csums, delayed
> > refs, etc.. Another way of framing this idea is why not have all IOs use
> > a parent OE with a single child covering the whole range?
> 
> I have a similar idea for the long run, to migrate the non-compressed writes
> into the layer OEs (or split OEs), so that we can handle the truncation
> cases better, without allocating a larger than needed data extent.
> 
> However going all in on layered OEs will need quite some extra work in
> simplifying the structure, a lot of members in the parent OE is no longer
> required and should be simplified for layered OE solution.
> 
> 
> > That way you
> > always have a parent/child and don't have as much code that has to treat
> > them transparently. When you look up in the rbtree you always expect a
> > parent.
> > 
> > This is of course a wider change (all ordered extent users suddenly care)
> > so it affects more code. However by not hiding the problem on a flag on
> > the OE, the OE functions don't have to be a mess of "if parent X else Y"
> > style logic. If the users of OEs use a narrow interface anyway
> > (presumably mostly just starting, waiting, cancelling), they don't care
> > too much which exact object they do that to.
> 
> If we're fine with the current layered OE solution, I'm totally fine going
> that path, migrating all writes to layered OE, and simplify the structure.
> 

Sounds good to me, I will review the rest of the series with this in
mind.

> Thanks,
> Qu
> 
> > 
> > Thanks,
> > Boris
> > 
> 
> 
