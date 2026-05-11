Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A2D402B87
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 15:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778514984; cv=none; b=oLx0bSasNieWts4tFaq9pOH7xIRUiI79k0R5Bb8BRJ4uZvVbD3jy/wFtHEZ7FEgbyOEhWhiBX+p9poTCwb6zjpSsHJwrDW8l7r9F220QiGm+YqTbbThw/nVy+S9MmAQYiy+RZRcDM4+AXrmMQos1W9U7RCmTXz1VJVTJ1CQ8hO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778514984; c=relaxed/simple;
	bh=sHIFkWa0n1uJ3AdIDEFE1d/3h9YoT0IcOcFkfJRRpKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W+aXtg/UJ3WFSeVEdijedgHksvkIezQLA3J+z1tWUMCaPyblNjwXvOdP8MzyHuxZ6QBituJWlGUHwRb5Q638WG/9e6o3iDLCbyIv0EH86Xyh3NpqOFXAoTN/bLiwNsTCCTmgUeWsJmEYfkL1K83drpFwmpYKwhMbmIgDHuJkb58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=jaLlnOrQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=uewpoSmQ; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="jaLlnOrQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="uewpoSmQ"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id EA76614000F5;
	Mon, 11 May 2026 11:56:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 11 May 2026 11:56:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1778514981; x=1778601381; bh=yF2WaZQOcd
	ibewFes8+BIhMlDJACYStJhFrRNUvuYvY=; b=jaLlnOrQn2yi0IheKcx0Z9RZUL
	Gkm8wotRRmCv9y658E+AsyqeutrQI7fqrkZ/WdWbNbdH6JkxFv5IHTtSYOu3VRg6
	pCYMOhfGxSOyikYEWITSL/Fwm6vTedruSW/RtTYnGztVCWX8dlaLOh5wPn3NsXTX
	zikkOzdO5iCV7mWFurcki/tXlz2l8PjnUviyCCuyROQvgGC4jZcQ/48oCPf+FhTO
	zzAo24mx1bgdhY4aIMh+/UncgJQZm/SbNSP2GcthcFdNieYlQQWM4dBmtzkMbX3P
	7kZgMMrHmLhrwORZK44pmV1BkDqNv3Td1e9raNdcYleArQ9eFRN4l+iTFeDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778514981; x=1778601381; bh=yF2WaZQOcdibewFes8+BIhMlDJACYStJhFr
	RNUvuYvY=; b=uewpoSmQ+plaNcPj+IsuC1P3hVVWjcfhy7OMbVY9Fdx6sTswgAU
	ANa1iYolvXuKZfXpPl79IqVvR2HUK1PdjbF+MLAwWNIu21S4U65Zh0IzXHL6M6+D
	U91b7w7UKxSegx4Z1AvdiSue8pPnil87klbQfr93GbgmNbTyHrgR+9pnSGSWiK0h
	yvePKy41FwBlc2q+SuRVMKxJxIT6vKXGhGJVnnoXBJ/tjDcD9UGCJHRwebKC8BeF
	ZcjbS8RZ2mhDR8vJF2zYDzxa1HXsS9FgIKK7rQ5hAy3CUtRwqX22niVza/bKJ8VP
	sEpSvFJyP88mdooxzwNy81RIOjqy6H5l+9g==
X-ME-Sender: <xms:JfwBaj9y19AZ0F0gCT8MP7eroN7qN7KmIY1vQt8is5qKnaC8dq2rMA>
    <xme:JfwBalveB0lNgf5icipdhFU83AaA82Y6AVJbPEbmYypsbKEynprOTWJOK7Zt8-yxB
    a8XJEW_vvWDMGdtIfcrbhzGG5DzTHKkLHJAQVsY7izpjQRoGfVR-SJz>
X-ME-Received: <xmr:JfwBaupkTER5zxwCeyHuwv7239mYvNky-rSNDkUvcEnmagnjQDDy4x9PA4z9K6Z_HhISZ0dtFglghGVyKtJgYVAZqaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduudelfeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepheefveejjeeiieevffehveeftdevhffggfeigeelgf
    dvheffuddvueeihedvieetnecuffhomhgrihhnpehsfhdrnhgvthenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
    dpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepvghr
    rhhorhdvjeesghhmrghilhdrtghomhdprhgtphhtthhopehlihhnuhigqdgsthhrfhhsse
    hvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:JfwBaql8w9JLlNlZUAHyDClL8-igN0Q_WAqkkU_CXwKMXO6xp8_tZA>
    <xmx:JfwBaqxnzsLM9zvNDHWm0p2OqDJItvVgxcr-Rurvo4SeKe_VeobUwA>
    <xmx:JfwBaqmXLruWWc3pYsdIahVaPMn_1vOFWBcY3x1reAqYEeQGGmmoFg>
    <xmx:JfwBarcbechY2LgorhTtRlnLCw1TmMrh24QClLypa2P-nk3uJR2Otw>
    <xmx:JfwBais5I-pR2CnYNtFMAgrxtuxAhvk5ox76O7OCKz7z2K5VVZZKHc2I>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 May 2026 11:56:21 -0400 (EDT)
Date: Mon, 11 May 2026 08:56:15 -0700
From: Boris Burkov <boris@bur.io>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [bug report] btrfs: periodic block_group reclaim
Message-ID: <20260511155615.GB534007@zen.localdomain>
References: <af2VhjMA8YP8NTvW@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af2VhjMA8YP8NTvW@stanley.mountain>

On Fri, May 08, 2026 at 10:49:26AM +0300, Dan Carpenter wrote:
> Hello Boris Burkov,
> 
> Commit e4ca3932ae90 ("btrfs: periodic block_group reclaim") from Feb
> 2, 2024 (linux-next), leads to the following Smatch static checker
> warning:
> 
> 	fs/btrfs/space-info.c:2139 do_reclaim_sweep()
> 	warn: iterator 'bg' changed during iteration
> 
> fs/btrfs/space-info.c
>     2125 static bool do_reclaim_sweep(struct btrfs_space_info *space_info, int raid)
>     2126 {
>     2127         struct btrfs_block_group *bg;
>     2128         int thresh_pct;
>     2129         bool will_reclaim = false;
>     2130         bool urgent;
>     2131 
>     2132         spin_lock(&space_info->lock);
>     2133         urgent = is_reclaim_urgent(space_info);
>     2134         thresh_pct = btrfs_calc_reclaim_threshold(space_info);
>     2135         spin_unlock(&space_info->lock);
>     2136 
>     2137         down_read(&space_info->groups_sem);
>     2138 again:
> --> 2139         list_for_each_entry(bg, &space_info->block_groups[raid], list) {
>     2140                 u64 thresh;
>     2141                 bool reclaim = false;
>     2142 
>     2143                 btrfs_get_block_group(bg);
> 
> We bump the refcount here.
> 
>     2144                 spin_lock(&bg->lock);
>     2145                 thresh = mult_perc(bg->length, thresh_pct);
>     2146                 if (bg->used < thresh && bg->reclaim_mark) {
>     2147                         will_reclaim = true;
>     2148                         reclaim = true;
>     2149                 }
>     2150                 bg->reclaim_mark++;
>     2151                 spin_unlock(&bg->lock);
>     2152                 if (reclaim)
>     2153                         btrfs_mark_bg_to_reclaim(bg);
>     2154                 btrfs_put_block_group(bg);
>                                                ^^
> 
> This decrements the "bg" so now presumably a different thread could free
> it.  The race window between this btrfs_put_block_group() and the
> btrfs_get_block_group() on the next iteration is pretty small.
> Most likely this get/put pair could be removed.  I can't see a reason
> for it.
> 

Hi,

This should be protected by read locking the groups_sem for the duration
of the loop. The code which unlinks block_group->list write locks
groups_sem and has a reference to the bg during that time.

There is at least one other loop that uses this same pattern
(find_free_extent() in fs/btrfs/extent-tree.c). I agree that it doesn't
make the most sense to get/put the refcount if it doesn't really protect
against anything and the rwsem is the actual protection.

There was a patch on the list a few months back that switched to a
per-cpu refcount for block_group->refs, which suggests that getting rid
of some of these logically redundant refcounts could matter for
performance too. I'll take a look soon.

Thanks,
Boris

>     2155         }
>     2156 
>     2157         /*
>     2158          * In situations where we are very motivated to reclaim (low unalloc)
>     2159          * use two passes to make the reclaim mark check best effort.
>     2160          *
>     2161          * If we have any staler groups, we don't touch the fresher ones, but if we
>     2162          * really need a block group, do take a fresh one.
>     2163          */
>     2164         if (!will_reclaim && urgent) {
>     2165                 urgent = false;
>     2166                 goto again;
>     2167         }
>     2168 
>     2169         up_read(&space_info->groups_sem);
>     2170         return will_reclaim;
>     2171 }
> 
> This email is a free service from the Smatch-CI project [smatch.sf.net].
> 
> regards,
> dan carpenter
