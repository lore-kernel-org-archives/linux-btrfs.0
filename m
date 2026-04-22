Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B1F3803DF
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 19:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776886773; cv=none; b=aq0boIp2vBVo1dLGg4xxf89UpZbIB/uBufcgDIo1iJXRxrzKtPT0eKHCsGaYZAdTAI64nSD84q63A26OH6fThedIKUaJA/cBga0ijbJXjFeCiwtySG2ICb2wEKx+Ohdyni+Ea558tLVmZD21PWAPMdPI4yl7MPdxberRQaGC4xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776886773; c=relaxed/simple;
	bh=ro68M/qgsSHpSxl0ehLqo7SGmpxXkfhkQRvraVUSw7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cBBGMAchHT9LkB97YZ8yduea8Ur5clwx2cnlpzpSCYoalmrnDpyveqJipwYTeS8TSVouhM14JpUik1WQg6qLTKrQ7/e+Zx7soPd12xe9SRx8NzN62crr3PKqZiPhCAF+2poeY8+vLlhdKbaZL9UBCyMjKCnF9cCiF//qM90b3u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=OCcisHCt; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=b8nur7mj; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="OCcisHCt";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="b8nur7mj"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E810B140005D;
	Wed, 22 Apr 2026 15:39:29 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 22 Apr 2026 15:39:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776886769; x=1776973169; bh=J/Hwf2ljIL
	5waCTUfuTCnQDGEbOn5tiSXknWW2XQLI8=; b=OCcisHCtwbpQbXDO0WggR9f8mP
	lNBVGZUl9oJ2P8aUKDwlz9P/6u+wD+ukjt/yoz5sr10/TV5y20/USYSXnKsWetD5
	JQCiTBrsJV4+1QZ/KNKAFZ9/zbCKMkXSBaIcTLzw3WLqP+mqIQaLOQ22Z4quZIh5
	7mmOLDv2vCSqXApihcMesVhWtj2mfhf0bqjqC1QXK4UC1sK/PipH1aVd8UIv3oMi
	0NWmy9f+jGHCm14BBX/VyS8TTKcgSEFk6wAmC7zX7vhm5aXI94F23cZoKmlbup5A
	oFA8jEX9HBgYpcqFPmgYsaZIYu8qbaozE9sYYi2ySoGvrk6I31n9e9Swslkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776886769; x=1776973169; bh=J/Hwf2ljIL5waCTUfuTCnQDGEbOn5tiSXkn
	WW2XQLI8=; b=b8nur7mj9I6FoFw5ibTkuAsyZXJ3cFk3kouvlo2ihWjtBPqKmmH
	DDu4ptqdAOy601uulMevSmV5fQnSs1yjwR1Vj87HJLXD4XS+TQk63U+kbXorSngc
	Ia6o/MaW89WcWTrXyUiHJkqAnSuYU7zD60UoR29ZBNf4FiE3nhU4EL91f5ayY7Wm
	smpIR5jO9nJyRCDGyWX1G+fXM9nv/rl5ylbqPNXkCCUUuwqb2INeYvgi0HXOAOeb
	Wo3kBSX9zfHSqN4ExMscYwUqExt+aKcJkDgwIE1GQspjpsChhOQ5uNely77//ho3
	ekwxAuD549UeAJZjfiiAx4gK7COosgQ5cNg==
X-ME-Sender: <xms:8SPpaTzjGb_VYypuBb2Rez20qpVfrcZOl6XuhQFj-gtNmpjZvgLCIQ>
    <xme:8SPpaRRIEfz3YxHVu66lxB8QAl2khguG1NZhItjkiBeeMfH74lcNmqpBX_sGBx5Aj
    rpLBzaWOJ540OG8vKOhQINe1QS8ioylv0zTsdl8OySVHKiLown9dJo>
X-ME-Received: <xmr:8SPpaa-e1tgagbKlQBkdvng1-eCkdJupAk133Qx2LkBySQNEh37Y4KkGUc3PH00e2-mJ-q4UVn0qXOB-Aoljy51jBNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeihedufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeutddvtdehgedvvdetuefgvefggfegudekjefhgefgje
    ekgeelgfeigeegudevheenucffohhmrghinhepmhgvrhhlihhnshdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepmhgrrhgtpggsthhrfhhssehmvghrlhhinhhsrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:8SPpaYoTIVmqQvijBrc_DRnUAIvBAy6fclxupPyCoLwvpLWodQtXBQ>
    <xmx:8SPpaXnLoUNueahJPN2zWVVfAyNGwfDnedhf4mmsrgNe2ua9ZTwfhg>
    <xmx:8SPpafJD1kcgFs7BL_THEXMp3ONrDpduf4PDyLECDJ_g83ixRZl5ow>
    <xmx:8SPpacwM83HScq15s5OaQkevVLeN0MizvKOqGadpAyMf3alVPLGTnQ>
    <xmx:8SPpaXI_ra5XC7lDXBcP9E8ROTpiC9PfAHoJ3uSgsUE_pbPSQK6U58Il>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Apr 2026 15:39:29 -0400 (EDT)
Date: Wed, 22 Apr 2026 12:38:53 -0700
From: Boris Burkov <boris@bur.io>
To: Marc MERLIN <marc_btrfs@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Deleted snapshots stay in squota, mayube because of bees?
Message-ID: <20260422193853.GA1478152@zen.localdomain>
References: <20260416213632.GA1654609@zen.localdomain>
 <aeFY4uSTSIz4Ccat@merlins.org>
 <20260417215127.GA2310330@zen.localdomain>
 <aeK2QgUCefpVY4KX@merlins.org>
 <20260417231603.GA2376753@zen.localdomain>
 <aeLNxjmUGGhnW5ss@merlins.org>
 <20260422022627.GA1034721@zen.localdomain>
 <aekA8mS4hppTjbA-@merlins.org>
 <20260422192344.GA1392535@zen.localdomain>
 <aekh8CX_LmbtMbQ_@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aekh8CX_LmbtMbQ_@merlins.org>

On Wed, Apr 22, 2026 at 12:30:56PM -0700, Marc MERLIN wrote:
> On Wed, Apr 22, 2026 at 12:23:44PM -0700, Boris Burkov wrote:
> > > Is that still working as intended and I don't quite grasp how?
> > 
> > We can't delete a qgroup that still has usage, and subvols own their
> > extents forever. So assuming no bugs, this means that some other
> > subvolume is referencing the extents originally owned by these
> > subvolumes. I agree that this sounds relatively unlikely for a failed
> > receive target you immediately deleted.
>  
> Right, especially a read only snapshot (btrfs receive), which I 1000%
> know I did not re-snapshot again or re-share/re-use in any way.
> The only culprit I can find is bees whose job is indeed to link blocks
> across subvolumes.
> So maybe the way bees works, it make squota think the new subvolume
> is the main owner and when that that is deleted, it doesn't know (as
> per documentation) to re-assign those blocks to the older subvolume
> those blocks were shared with after bees linked them.
> 
> > I believe that btrfs check has the ability to reconcile the on-disk
> > squota owner_refs with the on-disk qgroup values and find any real
> > discrepancies. So if you run that (without repair please :) ), and it
> > doesn't complain, I think you do have some legit sharing happening, and
> > you can try to track that down more directly.
> 
> Assuming bees/beesd is to blame (the only reasonable culprit I can find,
> but then again it's doing its job), are you saying btrfs check can do
> a one time pass and re-assign block quotas to the remainin volume so
> they are not "lost" for squota?

No, I'm saying that there are two explanations for your observations:
1. You have legitimate shared extents owned by the deleted snapshot.
   Presumably caused by bees as you guess.
2. A squotas bug where we have usage recorded for your qgroup but no
   matching extent in the extent tree.

btrfs check will walk the extent tree and add up the extent usage based
on the squota owner refs and compare that to the value stored on the
qgroup. The squotas invariant is that those are equal. If it complains,
that means there is an extent attributed to a subvolume that isn't in
the qgroup number or there is some usage in the qgroup number that
doesn't have an appropriately tagged extent. The system is inconsistent.

That is all check will look for. If it complains about squotas on those
subvols, then you have hit the buggy case 2. If it doesn't, I would
strongly suspect case 1. At that point we would have to use different
tools to track down the shared extent, as squotas does not help with
that, really.

> 
> Also, I understand the whole point of squota is not to take the huge
> amount of resources regular quota does, but is there a way (now, or
> planned) to do an expensive and occasional "re-assign/re-align" blocks 
> to where they belong when squota lost track due to how it works? Is that
> the btrfs check you're referring to? (but then again btrfs check is read
> only, is it not?)

As currently designed, squotas is quite dogmatic about never re-owning
an extent from the original creator. That is the core design conceit and
simplification that allows it to be fast. There are likely narrow cases
where we could do efficient or on-demand re-owning but nothing like that
is currently planned. This would primarily serve the case where an
extent gets shared but the original owner is removed. In general, that
case is most accurately handled by traditional qgroups, but that can
cause performance problems on some workloads.

> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>  
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
