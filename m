Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BBD3F0A81
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 19:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776885869; cv=none; b=lHoI1mjBGvF/Go/xQ1GYMDdyiaVpR+yZzG2xEKpOgwLNB7YmmwRJl9VY35S78N/DK2GuzB6ADkQTxCMhm6Xfv2lsj4PjdYKdU34vX/pKZ8F0RyPtOuvPP5BD1uSn0pOuKi7DAmNt7psAUbSAjwV82VvivNf4D2uJoYQVgLCk48w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776885869; c=relaxed/simple;
	bh=k1vN4Aqbk+kLyx1JZ3YIfk0NrbIv8EmcEE2Hqt8lRVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYNkxNqawJu95YorI+tefOOv00SkKOdoiT86Os0u98Aq/R79j0ae4E+/tHT9QMPPnSWoh4QQY6Y5qSadx9qw8bks5rZhSvb2C8rRv3xg8JdhSPHPCtavPTRJKfdGn1DgBv9Q0ZHeKymqRIqEW5RR6r4uWhfIi4PWRc4hw7TngTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=woyc7M42; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=oLQdchv2; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="woyc7M42";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oLQdchv2"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C29E114000E5;
	Wed, 22 Apr 2026 15:24:20 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 22 Apr 2026 15:24:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776885860; x=1776972260; bh=eYRo92E86U
	F/ra0jTt2JpIhxhpCn/xOv3F1041250RM=; b=woyc7M42RM5E662juJJ02qXcPG
	eZnfV8v4bzMv381TBlRBlOUqO4+bCXM+lt0eRyVxBVD0Q8VF+wIH1ODs1WxZh97k
	ZJhi1DDjLsOU4S48OHKYFOUxYN1PxJGFI7o2c5QHkigdvkddWHIWcC5/ascLN/B/
	iQ3zzlTJrLOcaaxnAA8Com3AKth0Af4ODyTY1y/WxDaz2X/UzChH508D+cETt/k1
	6yOY2PL3S5PiWPMpi8yxH4IKDuBU6Li5NWC4Sm8mPM8GHPNalcdGekYXodjt9Ods
	TI7mQZFZEFg51MmgnUnBBXGnH0UomuD4xFhSTqAmfK5sVQDlfa7CgfrYiliA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776885860; x=1776972260; bh=eYRo92E86UF/ra0jTt2JpIhxhpCn/xOv3F1
	041250RM=; b=oLQdchv2SBHioMrGjbmbL7YPUtwYDC/tdgl1j1x3wuB7EHqteff
	Z6pYjTri6mRaWGJVO1GiWqWeaFbQ9uTfaXPb2jct2unM6MSacIX/fNB0viMqmUhb
	/YblooBE1FAF9FEVO0nWVG6jHWzyCUa0R5FxR8EkOJb8OF+nLOsqL+uPTSZ724eQ
	+Oup7hXanIKuMkcadgAKbLEn6BxNwTd0b+uOZxNLgSaxI2OwEwcD9KS1o1LEmTSD
	ncdhWiLvgYedriiuSxxb76HxHc2lPnCz1s8ubPdAcL3yAMVW47fGackvZZhhYlZW
	mk+yjNATT73MQFK21UqK7EOZwH7axZWKtbA==
X-ME-Sender: <xms:ZCDpaf15D_1DQNb1dyUCMiM_eiCrYw1aDzSyXI26BFgWlmR9sND_3A>
    <xme:ZCDpaUHe_1qZVoAeMb8qgt3vliKiV_s-Mi_FgkBzoWABqqxFqLYK-ePCMUkx9iN97
    x4rpNNrLwaB4aAFvcYzj6lU6-B40_odW4RESOREzQsW1wu6boUivQ>
X-ME-Received: <xmr:ZCDpadj91Ba97WAgPZ1Nwa2m77n3Xduo6urK2Zh2aHgM0eaWm0uTQWygT_M199nDOAeKl3V2qnoXB-Re15tjZU3FMHs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeihedutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeutddvtdehgedvvdetuefgvefggfegudekjefhgefgje
    ekgeelgfeigeegudevheenucffohhmrghinhepmhgvrhhlihhnshdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepmhgrrhgtpggsthhrfhhssehmvghrlhhinhhsrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:ZCDpaf9tuo8KQWXRCtJ12hJWeJn-LKXGdIzzAmNzVCcsSNd70rIIfA>
    <xmx:ZCDpaUptDiRsc6m0jS6wVQ5y-wStsCfDYB6C9BhLzZefLfvCI9_-Ww>
    <xmx:ZCDpae_vJNoe8-3kBsnNXTqCppk9RCETJFPTAN7PD3IEhlQztj-USQ>
    <xmx:ZCDpaYWVM1_6piCFCc3x38mulN0dI9gQJpqK6Y6hLvx-tib1hYt2lg>
    <xmx:ZCDpabNK4vEe8tVh9XVPjftlRkU7QqeAUNAXrlzU-C2mIRCe4vqLpFzD>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Apr 2026 15:24:20 -0400 (EDT)
Date: Wed, 22 Apr 2026 12:23:44 -0700
From: Boris Burkov <boris@bur.io>
To: Marc MERLIN <marc_btrfs@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Deleted snapshots stay in squota, mayube because of bees?
Message-ID: <20260422192344.GA1392535@zen.localdomain>
References: <20260416012535.GB1065998@zen.localdomain>
 <aeEaqCJAWaWbz1vO@merlins.org>
 <20260416213632.GA1654609@zen.localdomain>
 <aeFY4uSTSIz4Ccat@merlins.org>
 <20260417215127.GA2310330@zen.localdomain>
 <aeK2QgUCefpVY4KX@merlins.org>
 <20260417231603.GA2376753@zen.localdomain>
 <aeLNxjmUGGhnW5ss@merlins.org>
 <20260422022627.GA1034721@zen.localdomain>
 <aekA8mS4hppTjbA-@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aekA8mS4hppTjbA-@merlins.org>

On Wed, Apr 22, 2026 at 10:10:10AM -0700, Marc MERLIN wrote:
> Hi Boris,
> 
> I noticed another issue, when I do a btrfs send to this volume
> which was created cleanly from scratch with squota, if I have
> an incomplete btrfs receive subvolume (copy failed half way),
> when I delete it, it does from
> <under deletion> to <squota space holder>.
> You'll notice I have now two <squota space holder> which just so happen
> to be 297.04MiB each.
> 
> I do run bees, so there is a very small chance bees took data from
> debian64 and dupedd it against another subvolume and then can't delete
> all the data, but in this example backup/debian64_kodi_ro.20260327_10:11:40
> was last, so any duped data should have been duped against a previous
> snapshot, and ideally not leave leftover squota data after deletion,
> unless bees somehow is making those references the other way around
> and the new copy becomes the master copy for squota?
> 
> But even then, it looks a bit weird that now I have two
> 0/263        297.04MiB    297.04MiB   <squota space holder>
> 0/269        287.84MiB    287.84MiB   <squota space holder>
> of almost the same space
> 
> Is that still working as intended and I don't quite grasp how?

We can't delete a qgroup that still has usage, and subvols own their
extents forever. So assuming no bugs, this means that some other
subvolume is referencing the extents originally owned by these
subvolumes. I agree that this sounds relatively unlikely for a failed
receive target you immediately deleted.

I believe that btrfs check has the ability to reconcile the on-disk
squota owner_refs with the on-disk qgroup values and find any real
discrepancies. So if you run that (without repair please :) ), and it
doesn't complain, I think you do have some legit sharing happening, and
you can try to track that down more directly.

> 
> gargamel:/mnt/btrfs_pool2/backup# btrfs qgroup show .
> Qgroupid    Referenced    Exclusive   Path 
> --------    ----------    ---------   ---- 
> 0/5            1.61GiB      1.61GiB   <toplevel>
> 0/256         16.00KiB     16.00KiB   backup
> 0/258         16.00KiB     16.00KiB   backup-btrfssend
> 0/260          1.06GiB      1.06GiB   .beeshome
> 0/261         63.74GiB     63.74GiB   backup/win_kodi_ro.20260328_21:48:59
> 0/262        229.51GiB    229.51GiB   backup/ubuntu_kodi_ro.20260328_10:19:47
> 0/263        297.04MiB    297.04MiB   <squota space holder> <- this has been there for days
> 0/264        187.38GiB    187.38GiB   backup/0Notmachines_kodi_ro.20260325_20:08:49
> 0/266         10.37GiB     10.37GiB   backup/1Appliances_kodi_ro.20260325_23:22:32
> 0/268        294.27GiB    294.27GiB   backup/debian32_kodi_ro.20260325_23:43:06
> 0/269        295.74GiB    295.74GiB   backup/debian64_kodi_ro.20260327_10:11:40
> gargamel:/mnt/btrfs_pool2/backup# btrfs subvolume delete debian64_kodi_ro.20260327_10:11:40/
> Delete subvolume 269 (no-commit): '/mnt/btrfs_pool2/backup/debian64_kodi_ro.20260327_10:11:40'
> gargamel:/mnt/btrfs_pool2/backup# btrfs qgroup show .
> Qgroupid    Referenced    Exclusive   Path
> --------    ----------    ---------   ----
> 0/5            1.61GiB      1.61GiB   <toplevel>
> 0/256         16.00KiB     16.00KiB   backup
> 0/258         16.00KiB     16.00KiB   backup-btrfssend
> 0/260          1.06GiB      1.06GiB   .beeshome
> 0/261         63.74GiB     63.74GiB   backup/win_kodi_ro.20260328_21:48:59
> 0/262        229.51GiB    229.51GiB   backup/ubuntu_kodi_ro.20260328_10:19:47
> 0/263        297.04MiB    297.04MiB   <squota space holder>
> 0/264        187.38GiB    187.38GiB   backup/0Notmachines_kodi_ro.20260325_20:08:49
> 0/266         10.37GiB     10.37GiB   backup/1Appliances_kodi_ro.20260325_23:22:32
> 0/268        294.27GiB    294.27GiB   backup/debian32_kodi_ro.20260325_23:43:06
> 0/269        295.74GiB    295.74GiB   <under deletion>
> gargamel:/mnt/btrfs_pool2/backup# btrfs qgroup show .
> Qgroupid    Referenced    Exclusive   Path
> --------    ----------    ---------   ----
> 0/5            1.63GiB      1.63GiB   <toplevel>
> 0/256         16.00KiB     16.00KiB   backup
> 0/258         16.00KiB     16.00KiB   backup-btrfssend
> 0/260          1.06GiB      1.06GiB   .beeshome
> 0/261         63.74GiB     63.74GiB   backup/win_kodi_ro.20260328_21:48:59
> 0/262        229.51GiB    229.51GiB   backup/ubuntu_kodi_ro.20260328_10:19:47
> 0/263        297.04MiB    297.04MiB   <squota space holder>
> 0/264        187.38GiB    187.38GiB   backup/0Notmachines_kodi_ro.20260325_20:08:49
> 0/266         10.37GiB     10.37GiB   backup/1Appliances_kodi_ro.20260325_23:22:32
> 0/268        294.27GiB    294.27GiB   backup/debian32_kodi_ro.20260325_23:43:06
> 0/269        287.84MiB    287.84MiB   <squota space holder>
> 0/270        321.80GiB    321.80GiB   backup/debian64_kodi_ro.20260327_10:11:40
> 
> Thanks
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>  
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
