Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92ED342CA9
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 21:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776462717; cv=none; b=FaH1hjfhkP+jcJ43sfz0OoGGL2yIf7fVsGCotUCA8X/UGht/V//d2gz7jzCvxXafsFXJyhvDxn84gOCBSPy4oDPL+Iff8IXcyKeEmQahrkhwpzD4RSxigrWvL6Pxkv94Hbg9L2B5E8Ehp7zD2CcQlmuuVj7QescggNrRq9PNByo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776462717; c=relaxed/simple;
	bh=uwiYtSsqqYOSzqsn/6k+aoyc4okCP9B9hIebmy2qCPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WG/W3DttPKbBS9L2UB+rFRLnDEAgln2Qd6x2mU77GXB3wp4hDvCHYvbJmAQrdLsNk76SIklteXRsbaHz5616kAKmI1h0VYJebl7/0EOJGXGfWz14cXZn8dVTMpSeVM1nAggV8TXL4gIN1+4m6zNQ5tAUMK1MZckM+qGdC2vR7Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=dsYPvQ2t; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=qbmLCFPe; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="dsYPvQ2t";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="qbmLCFPe"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id F121A1400062;
	Fri, 17 Apr 2026 17:51:54 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 17 Apr 2026 17:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776462714; x=1776549114; bh=xVVwYi7uIO
	qC9EZnIJhKhlCaFRaSc1ODPwv9QoUA45M=; b=dsYPvQ2tJ6UOk7X5f+sSEtOwkg
	iXYKOabEIFX/XzAsTpK0zxMQel47xnNA9L/IlPYDwT5LgUbnleeguIbOhmfaqDKI
	bjS6UI+yi8rG4VHyndId7zu0LPgdAqcu7ZWB/YnUtJQm08y192eYznKw3AOvyYW5
	4dEQeL5M8djcICWOCKANy/meMgyVnrg16C6wXjgR/qnxNRoQpz/EihsisgfqXhov
	m3gS9uvUgAM37Y6787/myot8bsa6k5EgX+GLUi6Ss3VamOG7m8dtwNtqwUPZ0oHE
	VlJMlszdGZkmaKrJLYV6UfNu/g/OaPg/XWnXGwW79AmJ6ZdtMHFgLkcLXTkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776462714; x=1776549114; bh=xVVwYi7uIOqC9EZnIJhKhlCaFRaSc1ODPwv
	9QoUA45M=; b=qbmLCFPeGtE3ke1aPOE1C9OQoLKmnZUJxW1jB21YWvfkNLjMwLS
	rDoHxqpQGARi//wnYvY6yN6rOgLO/rBuRtw9w9gtqa1aTOOEWeHZILnsYBKsFzdN
	7/szXy52vb2bGXiGL7rvR8qzoGV1tVlfAj3vhmfg6yT9yO+9v6X+c9NT44qsma8n
	XPJI8umwM1Z4p8/9iEzQdfbQnqm2Rm60ZkZU4jHyalmvGNRvRklSojDPWnQ8r5Jo
	JT5Qv1HtfKq1agtsHH/l9QsYLEIYijcDkoGE50uHigdVbTiH/QADIdPJ7PvnjVus
	mY8kdpUFVgiF17L3NuOfa6T5+ZV7O2mMlPw==
X-ME-Sender: <xms:eqviaaao4R_BCUGW8Tcosh57JAcRVxLV8KqrxTwjgBoBQTTXg4tjyA>
    <xme:eqviaTaSNZYbHDCXqeBDG6zBGaPm2CJPqRKk_Rwlfdap4uuE_h7Egs1JiIltyQHml
    TQC5NeQDOaZ9nte539vvKMWgyDaYw6VlQ-uuoRCbja4p-xzydfv7LU>
X-ME-Received: <xmr:eqviaSm7POhfVpEIqpvZ7DOhPXkUL1gDiF4dH1da_ufes4PZDhm_CIzU2H5JDT9_DWestO6lWoJ4ybtgu7Ug2TWqeds>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdehuddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeutddvtdehgedvvdetuefgvefggfegudekjefhgefgje
    ekgeelgfeigeegudevheenucffohhmrghinhepmhgvrhhlihhnshdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepmhgrrhgtpggsthhrfhhssehmvghrlhhinhhsrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:eqviaXzPqLGbwuDAi-wZFR79dot_lHwzNziZ903YMWHx9sP2GPUPpg>
    <xmx:eqviaYM9YAcLWWWpQZPVRTjtwe2m8wG57tu06jUFZAkr2gbzWQTXMQ>
    <xmx:eqviaTTOmYfMZpvH-T610I_UYehAYMOSwM9D9owjLm3DON44O8x7KQ>
    <xmx:eqviaeY2RPdZEs1ipdOJEeppt-UpW4NvCB5Notrxm-mEH3H4HEvjIA>
    <xmx:eqviadwB5nWVTx1W3M5Uxj2XrYI3xKVqJcKs9pxTebUNghk8fwnagopP>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Apr 2026 17:51:54 -0400 (EDT)
Date: Fri, 17 Apr 2026 14:51:27 -0700
From: Boris Burkov <boris@bur.io>
To: Marc MERLIN <marc_btrfs@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <20260417215127.GA2310330@zen.localdomain>
References: <20260415184427.GA842130@zen.localdomain>
 <ad_zkh47QZZnns7x@merlins.org>
 <20260415223629.GA956756@zen.localdomain>
 <aeAXawJ9F9K28shr@merlins.org>
 <20260416004552.GA1045221@zen.localdomain>
 <aeA2c8V4FgCctUPG@merlins.org>
 <20260416012535.GB1065998@zen.localdomain>
 <aeEaqCJAWaWbz1vO@merlins.org>
 <20260416213632.GA1654609@zen.localdomain>
 <aeFY4uSTSIz4Ccat@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeFY4uSTSIz4Ccat@merlins.org>

On Thu, Apr 16, 2026 at 02:47:14PM -0700, Marc MERLIN wrote:
> On Thu, Apr 16, 2026 at 02:36:32PM -0700, Boris Burkov wrote:
> > On Thu, Apr 16, 2026 at 10:21:44AM -0700, Marc MERLIN wrote:
> > > No help needed, just showing it happened overnight with balance and squota in 6.19
> > > on my laptop. It looks like squota and balance are simply not compatible until the
> > > fix for squota, lands.
> > > Now that I know more, I rescued the FS and removed squota on my own and it's good again.
> > > 
> > > It looks pretty clear that btrfs balance seems to trigger the bug in
> > > squota:
> > 
> > Thank you for the additional report, this is helpful. I am attempting to
> > reproduce directly with balance to be sure I've got everything.
> > 
> > One question just to be extra careful:
> > In all these situations, were you ever manually managing either the
> > subvolumes or the qgroups? e.g., when, if ever, where you deleting
> > qgroups and / or subvols?
> 
> All 3 filesystems this happened on were btrfs receive recipients, so
> that created snapshots nightly (when it crashed each time).
> Also after btrfs receive, my script deletes the oldest backup that rolls
> out the rotation.
> Then I also have some amount btrfs-snaps that makes hourly/daily/weekly
> snapshots
> 
> So yes, multiple per day per subvolume multipled by many subvolume
> (10-ish)

Just to be extra clear as it is relevant for fully understanding the
repro-space, are you managing these purely with receive / subvol delete
commands? Did you ever delete a qgroup that was straggling around or add
automation to do that (btrfs qgroup destroy <qgid>) or did you ever
disable/enable squotas besides the first time?

Were all the squota enables on existing fs-es?

> 
> I have squotas still running on a single host but I turned off btrfs
> balance nightly cronjob as well as btrfs scrub, and it has not crashed
> yet (it's a 20TB+ backup recipient built from scratch, I woudl love for
> squotas to work on it)
> 
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>  
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
