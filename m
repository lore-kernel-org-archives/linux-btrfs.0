Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB7581724
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 19:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776972552; cv=none; b=QomqyZ1nbFxEWQ1iJRwXV2X/SEcFphwbRtB56xPY6f6w0mf211pxfyVkKSuwtkAZPTufXf4yCWBs4pW1O5QC2/pnVGU22KS0deboetrPRTUSEwIbT5U4mfsmy8YMDg6W2EXd/j2bxw2fW5ATz0iLWhYrUplBR3Pwc7McQ0mTPFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776972552; c=relaxed/simple;
	bh=ReMz7/yyEZNJHEoAy4t/fQz0nQ0qpqwf5Q531ve4UPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WjoLhTk8KktkSbB7JIb+D4yj0qlog5O0ou5ZU9OJHcsGPIBAP4hmmeKscx7Z1A3IIVhlkAj37bHdX7E9OksO7iyQYWKPQH6P0uxQz423CDYOfmYLVH2SeHFmjpEdAysYMD5DHA8xNq6XgBExSMf18+GG3bLXYKETHvIgoeLrdsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=G+Dt1DkH; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rvwcwSR/; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="G+Dt1DkH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rvwcwSR/"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 137101D001BA;
	Thu, 23 Apr 2026 15:29:10 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 23 Apr 2026 15:29:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776972549; x=1777058949; bh=TfcMuGotzA
	tAWdsyauInV3nMHEYszjU95izorcnvhc8=; b=G+Dt1DkHdzHAAU7SxNuykjxIZd
	bh5BT+cbILgTtq002yJhcZZ9YHmKpZd0cTryJKCWQSDPKrdKbjnBLFfku0IpnudN
	yuIjVL9AXXxwJyAaD1QsURW3Ik2XtKW6ScMR65SAYTiKXWubiB5gGkVdKE7X1des
	u4hhwzWHTUBQqw6dU1s26vA6MdqpN6yvAZccAPfjlYUvMAq+sTbSUsf4Nm7oN8mA
	AtnMdBWgPIKiV//8MRaieq2nzyu6I70Q+dpvGWmxL+RTgH3X8mpFg4H6Ks7sbOow
	bAFyBwvM2Z/CvDM6GEur4J6/tDaAK8ROSCtkmqurkVxYw5pwWAkE4H9WxD9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776972549; x=1777058949; bh=TfcMuGotzAtAWdsyauInV3nMHEYszjU95iz
	orcnvhc8=; b=rvwcwSR/XLkT5Z0K07Pqcz4B/jq7K0SmJJd8UWfCjLPey1Pfc00
	y1LdvYShMFVc/kNd4Oi2D/7jjEFjwvEU7a84gVr8EuHowy0eTgNYeACeGjUl2PgT
	ZtavMXxENW5QrXSW1COz3shhHJIdcaSmA5NRAFFL4ptX5J//wGvkOrYjNFc9kPH+
	8T4LTyO+EEJnN4J9HHO3gqmzovhWDXBj37OTWOyifCF1bDKp/YqRgSkJcV75OSNz
	zpCCge0mTN45kQLyj+R/wRGL6Yg19NhHfmJluBLh1SXdscZAUfBwfsgzTKpPkeWf
	jH5nMkZ3aEghwKukTzkVuax6GdLlRuAgVbg==
X-ME-Sender: <xms:BXPqaameRwrSBYj0zmreT3Ml6OOO3MkShZC-y_sBW82O6aR7omhDVA>
    <xme:BXPqaX0DamNJGD-JlNYr8CKiEBCBvDd36dTb1IYpCgRGon_xn91sIkJ1myfo_XL8u
    g1JsALKzgZv9zSkfxnok9fMXAg9Xyr9TLm7Y-5sSZAYcmHmBOGcpg>
X-ME-Received: <xmr:BXPqaWTAymTEsPLkDPX4ngDwn3nWv2U6xvXU_B7QKdnSNw06TmfzjJuPvKaecU5oynB7Pmm7VWAZlyZijw7nJhohYg4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeijeellecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeutddvtdehgedvvdetuefgvefggfegudekjefhgefgje
    ekgeelgfeigeegudevheenucffohhmrghinhepmhgvrhhlihhnshdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepmhgrrhgtpggsthhrfhhssehmvghrlhhinhhsrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:BXPqaZsLOE-Urf0xYpeJ6IOpnB0M6aGOivBvoCveidz_cmMJqycgZg>
    <xmx:BXPqabaw9BvigvxvWRmamyY26m_jFcjT4L9Bf3qBgNedDgWRHegZPQ>
    <xmx:BXPqaeusUhfHGK9je1xZxeLvtmyRlnS7rMshSP3aEePnJtqKsNFpgg>
    <xmx:BXPqadF0x0PCk9qn0KXvlsyMLT6-1fszNjle3QrPOav55GCfImgUmg>
    <xmx:BXPqaV81RqlbzH2_uM6PHW3kWQUmDKza61bfFyy2EUpS74Q3TPn6oeqB>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Apr 2026 15:29:09 -0400 (EDT)
Date: Thu, 23 Apr 2026 12:28:31 -0700
From: Boris Burkov <boris@bur.io>
To: Marc MERLIN <marc_btrfs@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Deleted snapshots stay in squota, mayube because of bees?
Message-ID: <20260423192831.GA2096001@zen.localdomain>
References: <20260417215127.GA2310330@zen.localdomain>
 <aeK2QgUCefpVY4KX@merlins.org>
 <20260417231603.GA2376753@zen.localdomain>
 <aeLNxjmUGGhnW5ss@merlins.org>
 <20260422022627.GA1034721@zen.localdomain>
 <aekA8mS4hppTjbA-@merlins.org>
 <20260422192344.GA1392535@zen.localdomain>
 <aekh8CX_LmbtMbQ_@merlins.org>
 <20260422193853.GA1478152@zen.localdomain>
 <aekrVJnCaGkYWeBp@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aekrVJnCaGkYWeBp@merlins.org>

On Wed, Apr 22, 2026 at 01:11:00PM -0700, Marc MERLIN wrote:
> On Wed, Apr 22, 2026 at 12:38:53PM -0700, Boris Burkov wrote:
> > No, I'm saying that there are two explanations for your observations:
> > 1. You have legitimate shared extents owned by the deleted snapshot.
> >    Presumably caused by bees as you guess.
> > 2. A squotas bug where we have usage recorded for your qgroup but no
> >    matching extent in the extent tree.
>  
> Gotcha.
> 
> > btrfs check will walk the extent tree and add up the extent usage based
> > on the squota owner refs and compare that to the value stored on the
> > qgroup. The squotas invariant is that those are equal. If it complains,
> > that means there is an extent attributed to a subvolume that isn't in
> 
> Gotcha too. When my copy is finally finished, I will run a check and
> report back.
> 
> > As currently designed, squotas is quite dogmatic about never re-owning
> > an extent from the original creator. That is the core design conceit and
> > simplification that allows it to be fast. There are likely narrow cases
> 
> I got that part.
> What I was saying is some out of band way that would be slow and long,
> but only run rarely, to fix things that drifted.
> 
> You mentioned btrfs check, maybe a check --repair option to regenerate
> squotas on an existing filesystem (also awesome if you add squotas later
> and want them to be correct). For extra points, it would be awesome if
> it were while the filesystem remains online, even if that run takes
> days (since it would be a one time run after converting to squota, or a
> very occasional "fix things up to be all clean and accounted for")

My proposal for repair was to clean up clearly broken states like
scrubbing off the owner_refs for missing subvols (basically
conditionally do what the btrfstune did when you notice leaked
extents)

> 
> Is that possible at all? (separately from being worth your time, which
> I'd understand). The biggest plus I see is allowing many people to
> switch to squotas on existing FS without having to wipe and start over
> just to benefit from squota.

I think the tricky part is deciding who should own data blocks. It is,
in my opinion, impossible to arrive at a given FS and properly account
each data block to its originating subvol, with the same result as "as
if you turned on squotas at the start". I think necessary information
would be gone by now in even relatively simple cases involving reflinks.

You could pick arbitrarily, or you could try to make educated guesses
based on the owner of the enclosing metadata tree blocks and their
generations or something, but I think fundamentally it would be a lossy
process.

Perhaps we could add an ioctl that was something like "assign extent E
(or maybe file F's extents) to subvol S" and then userspace could assign
how they want. Or maybe even something subvol oriented like "squota
account subvol S" which would mean "S takes ownership of all unowned
extents reachable by S". And you could iterate your subvols in the order
you wanted. I like those ideas more than the kernel making fundamentally
arbitrary picks.

Ultimately, I would still be sort of worried about the resultant weird
state where you could have a shared metadata block owned by S1 and
shared with S2 (so S2 is a snapshot of S1 and the data must be from S1)
but then the data is accounted to S2. Nothing would freak out about this
now, I don't think, but it's sort of sloppy.

> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>  
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
