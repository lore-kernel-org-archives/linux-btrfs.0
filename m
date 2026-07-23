Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720AD484248
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826160; cv=none; b=PbPzHNNoerBmGTBVR4oWyhhBrMAnuDuW2dRlrE8jBV3Cnat9Qk3qEi8BcCo+J0axgRlhauXDYAXVjoLGbYCQlrYMG9PwxuKct96Xrvw7socbonyKMoFDBz/ReJswHhTYyZ+deLlqRjThRJP+w0Gnvq6uIPZLP+SMpnOOKF0owRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826160; c=relaxed/simple;
	bh=LYpJimFIVL7H2Nhbkuh3YGRcz3YeJH0WATjl9/38h5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=crD1FT1UW8P7J4wkHlptMsSIJrEx8jhBiE2JjjguRhAwn5XgRUkMTkPoa7l6oD97QsP8nVYJ/GerHoI5VfYOmkF6ku3pb8o4CdHsQV0UuvTZ65Vq8eGrqdGP4g7q0zIRxqbiCBw3PYPlbKrRbq051DPRuY+FdUQgsAGkXTmVebI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=guHplND1; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XAuRyG0G; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="guHplND1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XAuRyG0G"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id C67D9EC02F6;
	Thu, 23 Jul 2026 13:02:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 23 Jul 2026 13:02:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784826149; x=1784912549; bh=20/2Gw3o/J
	U1HHuXp7MVfRkB71OLIU//9I+N2uoaXYs=; b=guHplND1El2cuFn4DlodEHJ+Kj
	hZcp6Gzngd8/ofP3MGKl8vb2fp7aT8VHa5dyitdwFeZJK6u54a2PmgZaEvfa2XCL
	A5rHLxHX3ALb9jWxk6L9rZEF72iIJ93Vf7LVXzvgWl2OMsBuEbedPdHItF/FaerV
	4qm1rjjfJwRr28IjQMj9IcHPW/cYsftaRV3K159kxA3ulHOiqwICHPKLqVAD+/Y9
	HJm4Ym10lxHFWpF+4lbMcXZIDnygPy//E4k3yO+EMKo/jOSvh9Eb1Bk3tRzymn9j
	K88S9/4wbW0RRXcjEGqkWhD0Pb9uSN4sE7QRAhN69kxXmQTid7MRKD7ifFXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784826149; x=1784912549; bh=20/2Gw3o/JU1HHuXp7MVfRkB71OLIU//9I+
	N2uoaXYs=; b=XAuRyG0GGcFaTKukWlqEqCEl6oLioQd6D/5b6HVEJOVR48l8sbA
	8jPADblKPvZEhFZK8pFRGgayxIrdhLpnhSSAZdTPy0JYrcKbFxAD7mGXPSgpM3Cc
	6kIyp7u1YfFrQBz7dLwziCKW5nyHqUZHRyh7/M7fYCEmDove0bYMFoc5exCIT/EP
	2BCj/bmZ6fmlGCAqSUGHGNtyXj49wSg+9XmJnSmq8jmVoomPyTlWCPX0XXV4/d+3
	WJzS8E5biFeIYFcAG7QsM5yAZ3dmDrzQAI7yGR8GEkiPcLAPZ54sGfMwCt7ZPghD
	83VALns9yWGu5FrJnbmoy8kAsRpZb5DjIxQ==
X-ME-Sender: <xms:JUlianRUTHA1hB_Ww-6yGwidlCqZcNmmdW-wPQE94gB5poZoo0vl4A>
    <xme:JUliasduwc5YvNhb7LaTjnQV8ZksEM0jbb62gXj-pdzqnA_25v1UMSz7XUz6o3Kh4
    KvJToJ760bjfVWWZD2svvkP9_own0spGbd0HxJ42ZLaums6l1F9mBw>
X-ME-Received: <xmr:JUliampPGszbQYyFO0lDytWhcUtRrUTpTy8IFgAApGDyUldKpk3GplNYQel7BW2ir6gi5U2YKZX7kUZpXwtm-ehdN2s>
X-ME-Proxy-Cause: dmFkZTEkkDjtgXS8gmLpxzTpJb4mxL/rQvFZjO/WU/rzSXm6YRqPAOqCvuZWVFI4EYMBTn
    aQcgR5/GDcmdLU1SfHvG5Kbv0KF3goR9wv6EqkKBsfWgJaghG3ySH1d7S6lhGeRchTfGmm
    rDaaye1tm+Bw7nmBzZF4v7oFYG0vwL8chtCQUHxZ7z9pvihYJLvdOLKZlulecazhQD2pOV
    1niIHbrJ+mtgz6zFLi+9pXcAEWju/ZwOA14KUvV5I1wq72wxVIpUKoj4e0U1Bp+EKP6Ie2
    ZJK2Rpd7NLifjJazWkoq6mshd0iT85Vxu3QHL4zjN0FieObmVBSHYizSedpRxS1HvZO2kp
    IiSNXPrqnrSTH46la7i5NG/HxaXDfppt/HnHRECoHRi1pvzVsG6LIMNzMsxIX88g+NLGL9
    gcvoxcaXyjO5/QLFE3FqhmcDZ/7jsKq8ijC40MhDYsHq6CgRHS0oHjCM1SYd/ux/7ynYzE
    X/UIJCIP6Ijib9j1ojjtipfB9uTeAmQ319rGiuJDXwEszEX5csHCgbibJHwQ3U2bjYJjgb
    TlHpP/rw31nJQUbMKXAdAhezlUQAx17T/cPM0RBsAa9Jk+meMvx99gTRxgGgvmuM2Fc+Oc
    0/MrfLdaq9LSh2ZAZOQWzKrTKd6U6YdzSB4/UCxOy1u0AYXLiIcRlgXgdXMQ
X-ME-Proxy: <xmx:JUliat97MpAz0m6wG94xiWxQm_Ah9Arx8sjmmgi6Q9-kodInwnOEgQ>
    <xmx:JUliaifn0rot7kPFtKAC3R1tX8I88Ifrw0tHWpVKlA-YlCviYZY6ew>
    <xmx:JUlianKUnYBocrj2xh-GO-C-BmHlkUnoMbArfIFGeYE21rcn70YiYQ>
    <xmx:JUliaigXlxkN2966PulD-BCnzPrxht3umEcD1pIOzJ4gGdmHQKEeCg>
    <xmx:JUliagyBiAhaK1NmUWMZH2c9bwAJeUO0MuSQiOgzrxh6UXA9eQMz9Ite>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jul 2026 13:02:29 -0400 (EDT)
Date: Thu, 23 Jul 2026 10:02:18 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v2 3/4] btrfs: zoned: drop stranded dirty metadata
 buffers at unmount
Message-ID: <20260723170218.GC752950@zen.localdomain>
References: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
 <20260723155428.94187-4-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723155428.94187-4-johannes.thumshirn@wdc.com>

On Thu, Jul 23, 2026 at 05:54:27PM +0200, Johannes Thumshirn wrote:
> On a zoned filesystem a freed tree block is kept dirty and flagged
> EXTENT_BUFFER_ZONED_ZEROOUT so a later writeback zeroes it out and
> advances the zone write pointer. Unsynced tree-log updates (e.g. from
> rename or link) leave such buffers behind when the log is freed at
> commit, and across log generations they can end up ahead of the write
> pointer behind a hole, so btree_writepages() can never write them.
> During normal operation the space is later reclaimed by a zone reset; at
> unmount it is not, and the buffers survive to the final iput() of the
> btree inode, which hangs in folio_wait_writeback() once the endio
> workqueues are stopped.
> 
> They cannot be written back from where they are freed (free_log_tree(),
> inside the committing transaction) without deadlocking against that
> commit, and they are stale anyway, not referenced by the committed
> superblock. Drop their dirty state in close_ctree(), before
> btrfs_stop_all_workers().
> 

Immediate fix looks fine, but the underlying issue is a little hacky.
Can we detect that we have staled them from free_log_tree() and release
the dirty there? Am I correct in understanding that this means we can
overestimate dirty? By an arbitrary amount if I do lots of unsynced
tree log updates?

Either way,
Reviewed-by: Boris Burkov

> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/disk-io.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8d0afc2842cc..01d01e10d000 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4549,6 +4549,13 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>  	free_root_pointers(fs_info, true);
>  	btrfs_free_fs_roots(fs_info);
>  
> +	/*
> +	 * Drop metadata left stranded ahead of a zone write pointer while the
> +	 * endio workqueues are still up, so the final iput() of the btree inode
> +	 * below does not hang submitting a write that can no longer complete.
> +	 */
> +	btrfs_zoned_release_dirty_metadata(fs_info);
> +
>  	/*
>  	 * We must make sure there is not any read request to
>  	 * submit after we stop all workers.
> -- 
> 2.55.0
> 
