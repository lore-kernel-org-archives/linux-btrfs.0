Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588BB23394A
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 17:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790701501; cv=none; b=Kh7+00TZTQXYQ1k5VhuBcAnueLv0uVkEjOYhR3GwKvpup+Kl70BBB/FL2OYEo+JvHGqqkarsTEWsiClkTlBQyWOwieRYd5pyddJJ4gra/DW93/O45BAgiFKjKKm/QFRl05jhU/6kcAnjtcAfpU2z0wj7RK/ulxhq7yq+LE5rM9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790701501; c=relaxed/simple;
	bh=8metYfbUKWRTuqxoL7CVPV8cx3WBfP9SwgV3sb5UZUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iS2D1YKCt8ETR3LgdITUrmRlHVpLAd2bOvd4Cl9AQV+mn0y2nmS8gaoYS6vvNBdpx0D/aUmOXG2EH5x/GiQDv7jSMN8uc2lII1OXQztKgAXZKCr1sk8Q+ErqCVpK5VHJSMBeebDZ1E7V2Jd/U2zXBnPGOzuao+TbZpxz5uTC/Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=nGa4sXoE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FcncdO1x; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="nGa4sXoE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FcncdO1x"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 5AB05EC01E3;
	Tue, 29 Sep 2026 13:04:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 29 Sep 2026 13:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1790701498; x=1790787898; bh=AjlWxs48tm
	QqtFEtAdi5iLBWt3cBymFAgNSyxGGWRzc=; b=nGa4sXoE9aIpETkhHNMiv2jRv/
	7ZC4/6ujOBaSf6jZG7igWj+XpAMB1UTrsxMe0ae0whszVkUqIquhb4zbDcYdqpIo
	SWHSnPHj1P1lfoL3bEoMbOA5FPsMHachSbOdJ9UXy97555XJkYjISc/tU5glnTUJ
	OtbUbhPHNjFUBssaANs870txGaUPGBAsgwUpB296dg6dt0VOw54o0xRrG7f4t2XC
	DSnUvt0TLRssAZJILJJdwzHOPnXBo1Hf4FllQr8uS558cWuw6qmUp3MPt7XpGAEI
	9emUjNKEu/4+grVwIXeo65heApVuZakH3foDyLQwPfe8S49Vc/XQf8phI1XQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790701498; x=1790787898; bh=AjlWxs48tmQqtFEtAdi5iLBWt3cBymFAgNS
	yxGGWRzc=; b=FcncdO1xu5chViDBzL10QF3QsI9QgZHCsSlR/dxN5KNx55y+fK/
	ycuKP0eP8GBfb1NKnyJliGwB6w15udwDkLYv2XW/PHchKHnR3/MdckaXtrUWo2nt
	RhDFP6vNUxxMAeHODeswYGDSGtGBFx+rjnPiMckZp/OhYR5PX3YsA9rLOsl+ITwg
	hyVaJkWbp6YnTP3S/xCGxg4xP2DQIHX+iSQeB+Kl3IXwr+oNv0SGpo3c7UbPIFBC
	wxVqeDH0C2ovqagFTGHRrxwcqKu+pxrykrAaf4+v0kb5RGNS/yeuBnGZSyh59vmb
	kx7j49jFzu4aawMrK3/4ZLc+hOGQPa+BEWg==
X-ME-Sender: <xms:ue-7anp8v79IQrmx1bHkkY7gBgnW-Hgbo9JetSOhR6jchwamzmk3mg>
    <xme:ue-7apGTp-xh4gr57viw2cv5nU3W6bRWq_0tZiWRDohZDZfaCAomDLmP1Fm_P1dJq
    DAfjLvP7pbsV7Y2ubov9KOPsWFn_-Ki8eF5SvpYhzHu5DOGaM1oAbCG>
X-ME-Received: <xmr:ue-7ahkjGE7Yc7nD1mvFsPVWg8IrY4vyK7dVdck6hvBUMbKQNvWhzNs>
X-ME-Proxy-Cause: dmFkZTEHmpjHvSE8nHC3SHzqWvWdUcOHXAJDw8D5Syuriyo1471YIvTscDk4FEqCQ4Ik5X
    2OiB+r5TgHTrnw8W8fLvVfx6z3KBPuH5zbtXojbbDmJWywgk5hLuq5kY+mKxJyr/iAzTMM
    t2H7+F20dOn5EE0JU/wIbK9Cfo4sX3djBRiYeCXkcYBly9MpA8ijtXHIC3IPnuMhfIK/3+
    oxpEs5KT5NqnohUK3ZNoHJHRTcH9YpqENKvqXEHtaGWp56QvFCY52V62vlQk/MmrfYnxbI
    orbCIQCB9gSNMH2LyWjPXzoE49+Wd1QfYG1ctACoOtpiV1sPL9pv9lAuRUZbNKYyz7ECaQ
    Ms/zSi5uBinj5ACqyLPjjE9/8PAARmPgnPfMn/t8OO/Z1Pdm8M1RkleWnIqsMYSQYzC65P
    oLHE4ckdevgAJy6Obsf421Dzfye1c3h7HiIEs0Ifsuo4X9HlWFlsBZlmGplePSwSLK9mCv
    ONc1X2/kh3VWJ9ljDf4x/tGrv3AM+GqlNwCJQ+4Va2Z4duaBpVyCvJ4cwqQVfcyDtfCqEc
    6yLUqdu8EMQhxFm/863ePHvXiRYiG6uHQcbvKCUfMb7Oy+sQQQwUv7jRujq+MInE9RKfwg
    4fN0BqbCBYvQsEaGmK37VeahcwLjZCwG06xTGF7KygG7HGj6/qB0sc2s+Y8A
X-ME-Proxy: <xmx:ue-7aknrpeECjt2RDNI0MTXPP-6b19WhYi5V82aigz4AphR_8Ughyw>
    <xmx:ue-7aqs_tsSb0oTpo1SgGKrQPZ-9Sk57OjHaPW1xwhBD1OwBhqzDPw>
    <xmx:ue-7avk-AoVBUbF04Qz1J0M3p6ccvzXoFJaqiIiNx9NqhoV9xgNxCw>
    <xmx:ue-7atuP5w9FluEQMPskF8SV3Uaiz2LOCvEFKjfx9lYHZ5RSl9-qgQ>
    <xmx:uu-7atnXrV3ClnBy9tUKY9-s4as8iiSYwfwarTgScMPBYX91pZb-2qA0>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 29 Sep 2026 13:04:57 -0400 (EDT)
Date: Tue, 29 Sep 2026 10:04:50 -0700
From: Boris Burkov <boris@bur.io>
To: Sun YangKai <sunyangkai@fygo.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/6] btrfs: allocator perf improvements
Message-ID: <20260929170450.GA2494917@zen.localdomain>
References: <cover.1790641462.git.boris@bur.io>
 <5736105a-5ba3-463d-90a7-5c70bb034621@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5736105a-5ba3-463d-90a7-5c70bb034621@fygo.io>

On Tue, Sep 29, 2026 at 12:31:16PM +0800, Sun YangKai wrote:
> On 2026/9/29 08:28, Boris Burkov wrote:
> > Working on the bugs to do with large fs-es and unused block groups
> > 
> > https://lore.kernel.org/linux-btrfs/20260916230447.GA1706558@zen.localdomain/T/#t
> > and
> > https://lore.kernel.org/linux-btrfs/cover.1790641111.git.boris@bur.io/T/#t
> > 
> > revealed some low hanging fruit in allocation performance for very large
> > mostly full fs-es. The gist is to try to skip unnecessary operations per block
> > group which adds up with 10s of thousands of obviously skippable block
> > groups. Running 20k fallocates in a loop on a sparse file fs improved from
> > ~40s to ~7s.
> 
> Hi Boris,
> 
> Glad to see this patchset resolves the long existing blockgroup 
> allocator performance issue and I'm really impressed by the numbers of 
> performance improvement.
> 
> IMO we currently go along the list to look for a proper bg that have 
> enough free space, which means we may have to go through thousands of 
> bgs during the allocation, I wonder if it is worthy to use a more 
> efficient method like something sorted by bg's free space to improve the 
> lookup process?

I considered this while working on the size class stuff some years ago.
If you look into the free space cache inside each block group, it does
in fact index by gap size as well as gap offset.

However if you do that at the block group level, then each allocation
requires a write to the global ordering of block groups so that means
having many parallel allocating threads now requires them to fight over
a write lock on that ordered structure. I think that at least rules out
naive solutions.

You could probably resolve it with some more clever scheme like batching
or queuing the work to update the ordering, or maybe some duplicated
view with atomic cut overs.

If you are interested in allocator performance, another thing we should
consider is resurrecting more of
https://lore.kernel.org/linux-btrfs/0102019bb2ff5805-8aa151b8-1fe7-4087-9610-4c3314b3b144-000000@eu-west-1.amazonses.com/

I actually didn't realize that Martin had hit a few of the same things
in that series so now I feel a bit bad about not working harder to
incorporate his work earlier.

If this series of mine goes in, we are ok on the put/get part since I
just got rid of it, and I was planning to get rid of data_rwsem after
https://lore.kernel.org/linux-btrfs/20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu/
goes in. But I have not tried to tackle the scalability of groups_sem
yet, and would probably start by seriously evaluating Martin's patch and
re-sending his work for that one.

> 
> Please correct me if I got anything wrong.
> 
> And thanks for bringing these great patches.
> 
> Sun Yangkai
> 
> > Boris Burkov (6):
> >    btrfs: skip unhelpful size class relaxing allocation loops
> >    btrfs: don't take block group references in find_free_extent()
> >    btrfs: remove redundant checks in find_free_extent() hint path
> >    btrfs: factor the find_free_extent() block group skip into a helper
> >    btrfs: find_free_extent checks full block groups unlocked
> >    btrfs: find_free_extent checks size class unlocked
> > 
> >   fs/btrfs/extent-tree.c | 88 +++++++++++++++++++++++++++++-------------
> >   fs/btrfs/extent-tree.h |  3 ++
> >   2 files changed, 65 insertions(+), 26 deletions(-)
