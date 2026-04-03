Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14EC23BD1D
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 22:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775256294; cv=none; b=Bgdn1Og9OizgJ+j1trwN0G5RkmNzZdALYZeuwOytlqgpXarWfPopjSTb4VelEvDb0QF5qJHrUPMnzP6gjTmJLCIcONq9SfztGKB2L30jhqYn4Mmpxkcp1qRsIQyXJ/oJ/Q9xlPYGXV2UcnCKbf2LXujlt0RAZpvAyFmUvBnWq6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775256294; c=relaxed/simple;
	bh=/fALC5vcr36hWuIvlRoI0BnB2YuVoKuMkUD9XjywZLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bD8KXviEYqQ2+Oew0Tk/eRmTx3axjuCtbmu22qH+O1l7DoMj9jtIVxbnflSK1hCt7utNapumm61dee4SOW/J9SqtDCjcSPiXQO5pzNEOSqGMXNFarF37Ov3C8oAOKY1r2faOcgtm9RL6fsejJnQpnCZSJQMFFJ8MAWxeGijDYQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=iEg9W1A5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ae2esCcF; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="iEg9W1A5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ae2esCcF"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 206DF1400164;
	Fri,  3 Apr 2026 18:44:52 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 03 Apr 2026 18:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1775256292;
	 x=1775342692; bh=S/OwT/tFt3JwRaNLiW2FoVSGpqAiQzj3Rr4k//b4sIc=; b=
	iEg9W1A57avEuJ6PiGDHMA0uq3oqBqlCMyQ6iT9wFpc2lrVpy/KKe+mhN7OZcnig
	6/JkWTxXtqS8S4kOm+XsGP2k019VhMInf1A9BMuZ9UjnOBemNn3Kc3Nfm5+fD0O9
	1AaaiOyPR2/vBxoYAcjMbgfCaheKrMOdB3g1QdD+B0guU+S0fSTVz2TnCe9VSvUC
	sAgAxMsncncTL1INZJOYKZwnAzhZg7oWHb4rsbK866ndBkKZzLdfKOTxSLrm1NjE
	bO6Z9qXBVNwVIL4qhonSkGnFdKADRqNv3JC7svJ9I8/xqpkPjwoKUiRJp3gX0BAV
	yb9GJVvKXDTXH9GIewc1wg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775256292; x=
	1775342692; bh=S/OwT/tFt3JwRaNLiW2FoVSGpqAiQzj3Rr4k//b4sIc=; b=a
	e2esCcFchkik999CIyCM9If5FpKEFK5bqgBpC9bHvFK2g5+SLpkwPmV6zK7+mNuL
	g24iRlU7zErkXLyxQxlR0RrppcDqlx/dDKA/K+a1koXWd0EKR/okDHukLJw4EQaO
	RTGYsDIoWdDe8UZ41BVgr0VFoMt0O0EJf/X3JFbb+MtVJb2zkclR4RUbKiml9ljv
	yIdozvektPjkINJKCN0Tu3euA5uCsQt6pgjZDAzFYawiSUCQMGwaaCMvdP8DRQRr
	WK0tSls/eLDV0fDbl2OrQ1ZvOGAnL3JIxpirY9n6XKEL6XUQOHK4mDNWcG4wSRoz
	9h39W7BFc1B3gO/lO4jeQ==
X-ME-Sender: <xms:40LQaRqJak-hx_6L98EuafjN5DNUod5XK8-gpKyQctUnz4BzOhjrTQ>
    <xme:40LQabGzUykUArZwaIDimBH5KR2iq-pF-VDqAgCnUSoiT3rfQQoYGwFa9tBr6N725
    rfOBAFovFCPLlp2qC_w2J7yUOGQHIPTVuXB8fF1o565V1AaCs2C5aes>
X-ME-Received: <xmr:40LQabmQviUYywxJDilyIMZzWPKinLBmgjXdQRnGf-rcWOSI07OIIzzZMkbLbL6_5rICRgi3SbCXFP1jgSgOVONIVy4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpedule
    fhtdfhteduvdethfeftdeitdethedvtdekvdeltddvveegtdeuuddtiedtieenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepqhhufigvnhhruhhordgsthhrfhhssehgmhigrdgtohhmpdhrtghpthhtohepmhgrrh
    hksehhrghrmhhsthhonhgvrdgtohhmpdhrtghpthhtoheplhhinhhugidqsghtrhhfshes
    vhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:40LQaWlYgAnFopV0Xmnrcr7WfU8F7uqRoJTH71_9UEh2IRhmb1V9Vg>
    <xmx:40LQaUt2QVQ47RtEi2ywoLNIIpyU_kCKYms1QD6R8LLCHwITI8W5dQ>
    <xmx:40LQaRlB3NGgZBw3hY_3IkMUX40OFAmdMv3Xavn6EYLpnNX56yZ_8w>
    <xmx:40LQaXs3I1yBBHNNrDAxtRVddqt27rUbyLf8NrpQq_pnst5w3miN1g>
    <xmx:5ELQaZ2V63VS0ZAhaQpDZPU7BXbcA57_TSPDvMVeEx_DdFtsh-hux_jv>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Apr 2026 18:44:51 -0400 (EDT)
Date: Fri, 3 Apr 2026 15:44:49 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
Message-ID: <20260403224449.GA1806609@zen.localdomain>
References: <20260320125058.90053-1-mark@harmstone.com>
 <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
 <3ad267b6-cc59-495f-b385-9b4b4686a473@gmx.com>
 <39496ce5-74c2-4300-ba39-032edace4cfe@harmstone.com>
 <a1675480-628b-46ba-95c7-f5ee29d6bf14@gmx.com>
 <97ff76b9-5c07-4083-a020-3499ff595460@harmstone.com>
 <e6b4ae42-8b83-487c-92b7-6f91c70e1b6f@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e6b4ae42-8b83-487c-92b7-6f91c70e1b6f@gmx.com>

On Fri, Apr 03, 2026 at 08:16:26AM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/4/3 03:35, Mark Harmstone 写道:
> > On 25/03/2026 9.04 pm, Qu Wenruo wrote:
> [...]
> > > 
> > > That's done by progs through fiemap. There will be a flag ENCODED
> > > for compressed file extents.
> > 
> > No, this still won't work I'm afraid. The ioctl is answering the
> > question "what's the csum of the sector no. such-and-such in this
> > file?". That can't be answered for compressed extents, as the csums are
> > on the compressed data.
> 
> My point is, since you are not trying to fetching the csum of compressed
> extent in the first place, you don't need to bother that situation at all.
> 
> And even for compressed extents, it is still possible to fetch the csum,
> after all we're just search the csum tree for a given logical bytenr.
> 
> There will be some extra concerns like fiemap can not return the real
> compressed length, but again we ruled our compressed extents in the first
> place.
> 

I may be misinterpreting, but I feel like the question at hand is how
much hardening the ioctl requires to be correct, and how much work it
can delegate to userspace.

Suppose we make it require root, I think we could make the interface
much simpler and just use the logical offsets instead of a file based
interface, and we can leave it up to userspace entirely to figure out
which ranges they care about.

OTOH, if we agree we want the csums ioctl to be unprivileged, which
means that the interface must assume that the input could be bad, on
overlapping extents, not marked up properly, etc... In that case, I do
not quite know *exactly* what is redundant with fiemap, what is exactly
necessary for safety vs for caller convenience, etc.

Basically, I think the options are roughly:

- Mark's proposal: A smart, convenient GET_CSUMS that does everything
  turnkey and as helpfully as possible. Lots of redundance with fiemap.
  Safe to make unprivileged.
- Qu's review: Require the user to do the fiemap part themselves and
  don't make GET_CSUMS quite as turnkey. It is unclear to me whether it
  is possible to make such a version unprivileged safely *without*
  the fiemap redundancy.
- Boris's strawman: A dumb, inconvenient GET_CSUMS that expects a lot of
  userspace but doesn't check anything and definitely needs root. If we
  do go root-only, I feel like this might be the best interface?

And the questions are:
1. How badly do we want non-root? In practice, mkfs is root when writing
disks but not necessarily when writing image files, so it's a bit of a
toss up there. At meta we tend to end up sad when mkfs has root-only
functionality that we want.
2. What is the bare minimum processing needed to safely allow non-root
callers with arbitrarily wrong input? I don't see how we can assume they
will use fiemap correctly and not hit bookends, or set correct tags on
the input, for a few examples.

Thanks,
Boris

> > 
> > There might be a use case for "fetch the csums for a compressed extent",
> > but it'd be something different.
> > 
> > My concern about relying on ENCODED is that that would also be set when
> > we implement encryption. For an encrypted uncompressed extent the csum
> > *would* be meaningful.
> > 
> > > > The reason is that they may be "bookended", and you would leak
> > > > information about other files if you returned the whole of the
> > > > csums for the compressed extent. This is the reason why encoded
> > > > read needs root.
> > > 
> > > Nope, for the fiemap call, we will never reach any bookend extents.
> > 
> > I really don't think the FIEMAP call achieves anything here. The kernel
> > still has to do a lookup in the FS tree to determine what the logical
> > address of the extent is.
> 
> The point is to minimize the work in kernel.
> 
> We already have a ioctl to do the fs tree lookup, and it is definitely
> enough for non-compressed extents, and that's fiemap ioctl.
> 
> Thus I do not want to introduce new codes just to do a similar thing again.
> 
> > We can't allow (non-root) users to read the csums of arbitrary sectors.
> 
> And that's your choice on the csum ioctl, I have no preference, since fiemap
> doesn't require root privilege anyway, if you want root check I see no
> problem either since it's more secure.
> 
> Thanks,
> Qu
