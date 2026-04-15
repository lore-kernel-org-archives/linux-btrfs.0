Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEEC239E9A
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278695; cv=none; b=KeVwqlJha/YXYLpbkc/NDZ+IA6NvGHy7l+Z8wi7/2bq4TkVkc45RH/3XoqPucmpeeYVSxKcQh/Ry81IOpemI9iKz4HZasvXlemuvcCy+3wKW917aOu2RvKLP/0L3tUKj/VmekawE9Bwfqu3BKpov/KpKrTXUP2NiwXxucZsSoEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278695; c=relaxed/simple;
	bh=2YzokII3ou9Gok5vcdrWKVGxayBpnFkn6aNG+vfg1NE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tymy4ARBcZgJutBuwwUmlyzzuFF7mms8pV9m1Llggo0Njg7hFosYvababiZOFbE57Lz4+IUvSQ+8b5Z4l0Fun7UpmTr1MBKzZOjPC1UWCc4yVfd9ljlcu480NwvJbIV9K7Gnj8Fwz4A5K5GgMNFtZ65ba26xwpNdC62+0/HZ6Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=i5dhh+Hx; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JhhAUpH6; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="i5dhh+Hx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JhhAUpH6"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id BD2081D001C6;
	Wed, 15 Apr 2026 14:44:52 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 15 Apr 2026 14:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1776278692; x=1776365092; bh=DWOyqd+E2I
	ADa+P1TJsDq+fwx/nYC31L/vNIeT0O4EQ=; b=i5dhh+HxOfqWywi25feKSKztMN
	D2uIl+5BiVqRNzDMRrKdoppk0m8h9i7xN3BVjnsk+VfECqoXlpMO10kio5HbHGEP
	xDAvz3Ti7OY+LltdIZfDzb11JfbKMDsFhuHfoUt/NKja2oo6nfseVQ56kHbekG2/
	dUXq0TGjefv9AhNLZCxlxLWGewSvccvfYYNwN53Dud1r1S2aeZYyT9Sp0WR2SKSi
	LA2AnG7lwtEvrb1j0pWq0iFSU+hfoVSo6hLsP6B4y2bh2/HoUGXFBlD5a/ycSvhs
	tqXXAtUHjfas7CW7wpZ+4fTJ4GLkD8yHq9sOjoD5iR8dHGOG96vWM65hTnRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776278692; x=1776365092; bh=DWOyqd+E2IADa+P1TJsDq+fwx/nYC31L/vN
	IeT0O4EQ=; b=JhhAUpH6HdxDCoSyjJnw3m9Lgk4j1t38MPT5N4XUQYpJzdjPXRy
	m3yWfOknVmtBhYB9krmZwi9F80THtxw3UYWxnh9b1u91PyNl4zuKIvhtshS1R6yK
	hjuKdA3dWMCekPgOL+NyiK5tMrAamQ0C/fqVsSfKsgcM70c4f/eHpTfaZX7Ek0jv
	OJvQt0vFu07kSnsnhOFXkcR7vxN7uk97dJT3/cazL0gPzPy4s+OP1Fe+z7FSWxBL
	QuXROLkbE9745dFvteKpbEZBTHqtB7itN7djRaP9MUdnqGq8wgSQOUVvpaaAWa0a
	B0xzueXJcgGsCqj6IC4W8U4M/Z7Y/p4TN+A==
X-ME-Sender: <xms:o9zfaf6FWhmGH_wPLZRP3CA8hJFsAmvdmExYLLONq9H3MKkSakewfQ>
    <xme:o9zfaa64F8MzavZKkLuhiYJ0iH1hSL1zj8M-_6OUbDHZYuL7aAkCyJ6dv_5lu2M50
    dltUZyji2LXSu3q9U7Mbr53_Sp_mYfwnGiCT6DEyyoOzeR5XNK7AB83>
X-ME-Received: <xmr:o9zfaRRfLhmB5x6U6kQpPZP1USxhcxCuRmOZqPlbFpKB99UfqQILeTH5UTx3pmvB6Fi-JzRfHlfpzFND94qAkUPlXI8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeggeekhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepuedtvd
    dtheegvddvteeugfevgffggedukeejhfeggfejkeeglefgieeggeduveehnecuffhomhgr
    ihhnpehmvghrlhhinhhsrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedu
    tddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhgrrhgtpggsthhrfhhssehmvg
    hrlhhinhhsrdhorhhgpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehjohhsvghfsehtohigihgtphgrnhgurgdrtg
    homhdprhgtphhtthhopeifqhhusehsuhhsvgdrtghomhdprhgtphhtthhopehquhifvghn
    rhhuohdrsghtrhhfshesghhmgidrtghomhdprhgtphhtthhopehfughmrghnrghnrgeskh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhishhtshestgholhhorhhrvghmvgguihgv
    shdrtghomhdprhgtphhtthhopegtvgefghekjhgujhesuhhmrghilhdrfhhurhhrhihtvg
    hrrhhorhdrohhrghdprhgtphhtthhopehrmhesrhhomhgrnhhrmhdrnhgvth
X-ME-Proxy: <xmx:o9zfaS-EDCM5n43lXGbq3fN0C8YqPjtP2SJnLi0tjKHNg8vt3OMOwQ>
    <xmx:o9zfaSZE5VE4jm7L7kTQ-WjDrQizHF_B84KzBrpo7hkNfAPQkHUpKg>
    <xmx:o9zfaTquWAMRrlrqvYcDS93w4dKEp8uC_qnqHF4pdwJdFhDfx5EWog>
    <xmx:o9zfaWSOEPqWc3DkMts3v3s77arxmYmtyy9ulGQdEsX_wPaf-4soCA>
    <xmx:pNzfab36hvV2Gydzw5RFDjUp_bRt-kSLrAAZ0Pdcw7JIJ4rgLo7PXQ_E>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Apr 2026 14:44:51 -0400 (EDT)
Date: Wed, 15 Apr 2026 11:44:27 -0700
From: Boris Burkov <boris@bur.io>
To: Marc MERLIN <marc_btrfs@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, QuWenruo <wqu@suse.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Filipe Manana <fdmanana@kernel.org>,
	Chris Murphy <lists@colorremedies.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	Roman Mamedov <rm@romanrm.net>, Su Yue <suy.fnst@cn.fujitsu.com>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <20260415184427.GA842130@zen.localdomain>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <ad0tdWyavEngGlQ-@merlins.org>
 <20260413184731.GA3448810@zen.localdomain>
 <ad1GxXgWNBfgrRtN@merlins.org>
 <ad8gcwTFOLUhBHGA@merlins.org>
 <20260415170510.GA780391@zen.localdomain>
 <ad_SEOvBQtzsxWkY@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad_SEOvBQtzsxWkY@merlins.org>

On Wed, Apr 15, 2026 at 10:59:44AM -0700, Marc MERLIN wrote:
> On Wed, Apr 15, 2026 at 10:05:10AM -0700, Boris Burkov wrote:
> > 1258303029248 is the logical address we were freeing so its backrefs in
> > the extent tree will be interesting. As will whatever subvol tree it is
> > in, as will the qgroup tree entry for that subvolid. If you can share a
> > full dump then I can find all that myself.
>  
> Note that I fixed the laptop, thankfully didn't have to rebuild this
> filesystem.  
> 
> Sorry, not very good with the debug tools. Was that the right command?
> merlin:/mnt/btrfs_pool3# btrfs inspect-internal dump-tree -t 1258303029248 /dev/mapper/pool3
> btrfs-progs v6.14
> total bytes 4074040004608
> bytes used 2415294197760
> uuid 49741c78-3949-4d7d-b77a-160ce071dee0
> merlin:/mnt/btrfs_pool3#
> 
> 

For a giant fs where we don't want to dump all the metadata or it would
be difficult to share the resulting gigabytes of text, I would still get
quite a bit of benefit from:

btrfs inspect-internal dump-tree -t 2 /dev/tst/lol
and
btrfs inspect-internal dump-tree -t 8 /dev/tst/lol

which will dump the extent trees and quota trees respectively. The other
useful thing is to find the extent in question in the extent tree and
see which subvols refer to it via the backrefs and dump those trees. But
that is relatively less important. If the extent tree dumps way too
much, then doing a grep -C 50 for 15506102321152 would likely be enough
to show us the relevant backrefs.

> > ditto for the logical address that broke on the rpi, but if that is a
> > gigantic fs, maybe doing the dump will be pretty unwieldy..
> 
> That's the bigger one indeed, still waiting read only until I'm told I
> can wipe it, or should wait for debug data request. It's been too long
> already and I had spare drives, so I started a full restore on a new
> set of drives and will swap them in for the current one I can't mount
> read/write but can keep it around for debugging / potential future 
> check --repair patch

If there is no rush to wipe it, then let's keep it around until I rule
out whether a repair patch makes sense? Sorry if I misunderstood the
state. If there *is* a rush to wipe it, then let's confirm we got what
we needed out of tree dumping first, if possible.

> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>  
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
