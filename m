Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D2730568B
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 18:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778870325; cv=none; b=ihmomLwVDxccapf0iowRdKIsBB1ZY1WanocpXHhR9Je1TE8fQ5l7sJopATr58qurn57nnMQkfDyns+BeK0G86r46i/sPiRfFV/KHPguncKTpVu3YUfjZOHv0V2twQKl/7j2IShY7ZnvAmpWNo87FTyYRAvFDqYc+0FDq6FxEKOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778870325; c=relaxed/simple;
	bh=YhPxZREZahmlWfIgc4+2NuZkVUH7hOCBNH1luVoLrBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bqyBtXpTTMWM/odZSs0tWkPiUUe+XWsYwkQ0x55y44nWSzmNok3zIGNgkxny6Kq4ps4f+3cvZCageuYzPmBdS4Ivjedy+6P6eDLUI0JrPaiI7k+BEvWEXJBv886iLlZN9NE/NoJ9l7IcY98ukwCwKZnPI7KpxyPyIYUH60v8+Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=LgxXydwa; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EfeoAktW; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="LgxXydwa";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EfeoAktW"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id BABF7EC0017;
	Fri, 15 May 2026 14:38:41 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 15 May 2026 14:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1778870321; x=1778956721; bh=htzE2WoeSe
	wZGh/kA6qRosNnUKKyj5E9+up8q2KO7lc=; b=LgxXydwajYi84XnA5JTFREpSK4
	5OafNYQo8Vb/IGF+YBQzCrKq8RZTitG3WL/OqAPh1RQVQgwnvus+nNgkFNGYNEbg
	dlpNeTokfW3BC7CO9GeHV/fFvKmXdda3NMhCwtZLdGZYynL9nUP4ON5iTWpFqs5I
	EtimZam+XvC9bHLrjMim3j/Qx9WtmR13mXD4xhInC3yiqq7UO2vNmVujq56oazs4
	+jU4dd4Qp6wBeDzHashNeOSXO7qV4cxeLg2bE46srmiy+jECnb3WcpHYIaaBqkNP
	4cwuoDzj2F2qYP85CWc3cPXl1WNodFhW3Ey7WNGGL/w3JS4/xTzPfPe8b1xQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778870321; x=1778956721; bh=htzE2WoeSewZGh/kA6qRosNnUKKyj5E9+up
	8q2KO7lc=; b=EfeoAktWxZI3V20RHhgxv3k+HnW3nP97H5RmdNTa1ko8wEQN0FB
	qwUuEjtVuuBvy2j82KTDATMK2P4u9Dvxj99BKylDV65Uda1Jkw+dBWbqWHGwtJl5
	dVCrmtLzdR/kEK0uRjPYKRTB53SusFKxV3vDey6GyCwoZH67488VSCTBPieMNsSo
	07InvRMoeBqEuuStGGGm7FPZM87ZC3L7wR/BJrnzxrqZ00ENPAuH86yvEapKDaLX
	3hBHxzC+iJH70I5c441EXtJYm7PmL0hlbEMYbXR3FBazcd3dDA+QfD5FP79Zo620
	5av9kyG4dimyAzdqgkl3VqbBD5QVzo8IfAA==
X-ME-Sender: <xms:MWgHarwP-lqo-uBrCbpCj2bxQFtvmI9qbsrRHUZdjVrpJz77EnNxtw>
    <xme:MWgHaiWWVH7wrEtw3G9wMJmtYLcMs3-pugYeQpIGJU3tBWUW8E1v1kxoZQ_QcA32k
    gqxBgJrG56DwL0KgryQqAco2gUgUCueAk6rLISSPeAIfd3aw4Vbpa4>
X-ME-Received: <xmr:MWgHarjpkdxpM9CQXvYqTJwHveggPB3c8bsKCsAJwjQcj5APVKLlmfXAoE9XcLh9oXgnsqzYiP_RuvQ2acF3-sXgH5c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddufeduudegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeekvd
    ekffejleelhfevhedvjeduhfejtdfhvdevieeiiedugfeugfdtjefgfeeljeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepjhhohhgrnhhnvghsrdhthhhumhhshhhirhhnseifuggtrdgtohhmpdhrtghpthhtoh
    eplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehfughmrghnrghnrgesshhushgvrdgtohhmpdhrtghpthhtohepughsthgvrhgsrgessh
    hushgvrdgtohhmpdhrtghpthhtohephhgrnhhsrdhhohhlmhgsvghrghesfigutgdrtgho
    mhdprhgtphhtthhopegulhgvmhhorghlsehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hnrghohhhirhhordgrohhtrgesfigutgdrtghomhdprhgtphhtthhopehhtghhsehlshht
    rdguvg
X-ME-Proxy: <xmx:MWgHaiDxpHwEbuzpDanFAIHtJfhO_j8iiOmAhwR2KGFZiFJQLrDdjg>
    <xmx:MWgHahv5m3SkBY7wcyi1i6r5_onoZUhmKMJ1CR83Nb165yvaqYm-Kw>
    <xmx:MWgHamdQ07f7prxsXajJmz7FXj6pAo2guXHdolZIMjcpnC2phIyDHQ>
    <xmx:MWgHam8W7RL95Vk7HoPYKNAEY_zkOTkOez697y_eRN8eDuuu_fho-w>
    <xmx:MWgHajsB5eG4PEyoIdzQ-d9E-MZORbwpaX0vpUffOBNlmocbkgP8jYJt>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 15 May 2026 14:38:40 -0400 (EDT)
Date: Fri, 15 May 2026 11:38:27 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 7/7] btrfs: zoned: add RECLAIM_ZONES and RESET_ZONES
 to first async reclaim loop
Message-ID: <20260515183827.GE1197064@zen.localdomain>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
 <20260513123445.43197-8-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513123445.43197-8-johannes.thumshirn@wdc.com>

On Wed, May 13, 2026 at 02:34:45PM +0200, Johannes Thumshirn wrote:
> On zoned filesystems, when waiting for space tickets during data
> relocation, the async reclaim flush state machine may starve if
> RECLAIM_ZONES and RESET_ZONES states are not executed early in the flush
> sequence.
> 
> Currently do_async_reclaim_data_space() only executes RECLAIM_ZONES and
> RESET_ZONES in later flush states (FLUSH_DELALLOC and beyond), but by
> the time these states are reached, the ticket wait may have already
> deadlocked waiting for space that can only be freed by zone reset.

This explanation is a bit confusing to me. Does your previous fix
prevent all known deadlocks? If not, can you describe the remaining
deadlock in more detail? If having these flush states in the general
flush state list causes a deadlock, we should not leave them there, even
if we add this earlier pass.

I assume the issue is that some other flusher can't make progress when
we are out of zones and also lands on a ticket, and so async reclaim is
stuck on a ticket and the only way to make progress is to reset a zone
(hopefully) or reclaim a zone (painfully?)

Maybe we need some high level flushing logic like "needs zoned help now
please"? i.e., if we are low/out of free zones, do only zone flushing,
otherwise do regular flushing (including zoned stuff if necessary/wise?)

> 
> Fix this by adding RECLAIM_ZONES and RESET_ZONES to the first async
> reclaim loop (FLUSH_ALLOC) for zoned filesystems, ensuring zone reset
> happens early enough to free space for pending allocation tickets.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> 
> This patch was AI assisted and I'm not sure this is the correct thing to
> do (the flushing, not the use of AI), hence the RFC tag. 
> 
>  fs/btrfs/space-info.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index ec811a77ebb1..a1235f114f3e 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -1451,6 +1451,17 @@ static void do_async_reclaim_data_space(struct btrfs_space_info *space_info)
>  
>  	while (!space_info->full) {
>  		flush_space(space_info, U64_MAX, ALLOC_CHUNK_FORCE, false);
> +		/*
> +		 * For zoned filesystems, also run RECLAIM_ZONES and RESET_ZONES
> +		 * in the first loop to avoid starvation. Zoned filesystems have
> +		 * sequential write requirements, so space cannot be reused until
> +		 * zones are reset. Running these states early ensures zones are
> +		 * reclaimed and reset before we get into a starvation situation.
> +		 */
> +		if (btrfs_is_zoned(fs_info)) {
> +			flush_space(space_info, U64_MAX, RECLAIM_ZONES, false);
> +			flush_space(space_info, U64_MAX, RESET_ZONES, false);
> +		}

Just to set a common ground on the existing algorithm:
The current logic is to allocate a chunk (which may satisfy tickets)
then check if we have any tickets left. If not tickets left, great we're
done. Else, allocate another chunk (till full). Finally, go into the
various flushers if we can't allocate a chunk.

The way you have changed it, you tack on the two zoned specific flushes
right after allocating a chunk, regardless of the continued presense of
tickets. That feels off to me. I don't know enough about zoned to
accurately judge how you want to order it, but I think the question you
want to answer for yourself is:

If there are totally free bgs on a zoned fs, do I want to run
reclaim/reset zones before or after allocating them?

Given the fixed number of zones, I would assume reset zones at least
should come before grabbing a fresh bg? (Unless that fails in a free
zone aware way?)

OTOH, if you put zoned reclaim before chunk alloc, we may block data
allocations on pretty expensive reclaim work when we could just make
progress now by allocating a chunk.

Long term, I am planning to refactor space flushing to try to make the
separate work less sequential and driven by the demand for the
particular type of flushing, but that is way longer term than your
immediate need. I am just saying that to hopefully make the pain of the
"ordering" aspect a bit more clear in greater context, it's not zoned
specific. (it's bad to keep running delalloc first if we have a bunch
of ordered extents out and should instead run delayed refs or commmit a
txn to unpin, e.g.)

>  		spin_lock(&space_info->lock);
>  		if (list_empty(&space_info->tickets)) {
>  			space_info->flush = false;
> -- 
> 2.54.0
> 
