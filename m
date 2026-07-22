Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174A5374E59
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784733604; cv=none; b=Hkp6D+Wm1X991SS4r9udjg5ntaCE+vX7qR67tLGDLab+3f3IHcX1XZjf0dxw3Vt6CkwVHWlfdso3SKAGri0tA2kt/+Ibhpw7fy1cq5TzM0mCn9PW6GsInvr8MajDDtggqDbwDLzkMFh21nVivjj+uLlX9CSCitbbvIXJVulBB0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784733604; c=relaxed/simple;
	bh=MnreOunCh4G7u1kq/0pcpxXSZIQqvH3ICeqDQJ/l36Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EZWyY5/zwY5RDOEO0ERPYejozzvRZGFslzPXUXg5wuVmDHdEj9QHh3pteOHEnckNfwguqthv7ixCqCFDznHCx8jR0o6ziyC8gr8gHn5wjRsRYjc/wVje6etzjJ0KtxSo+C0gf8+oTxVAUBCpHdX+4toL3Cg2V8FhtzhWUPAthNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=VhC+vR4z; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=D9UfIxs+; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="VhC+vR4z";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="D9UfIxs+"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 231ABEC00FF;
	Wed, 22 Jul 2026 11:19:59 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 22 Jul 2026 11:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784733599; x=1784819999; bh=eQSpAm77vo
	vB6qaWoIrx9Q3Rda5XeP9820/cqGGyHB0=; b=VhC+vR4zLPuDFLVf6b2hofgv2/
	vJCReKvcoWM4mh97n5wDEGf6mlt1YY8Gwd0CO9FEzyVx+LZjzcAuzuFHovnpcDYa
	U5pQZJwl3hjKt2nL5dCqkUVt1rjacCcEvwr8910R+zKgPBNuWt6fx3g6jzshxsPS
	UfpOmntvFUgbcmu2zqtkFYIftTk+psHN/0CuQvBH171g8fzMz3HmJpEJX1imyrgn
	zLdvifOp5bxeh8zto5lXs5GAd5QpJAuiWHjsTB0BBjRXHTm6fpjkJTUbTzjDX/3R
	PG7Rc9G/Zj6ZMfunVTzbu6b7scdcmyPgvqREnL2fgmVzjg8m9lWHD42Mqa0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784733599; x=1784819999; bh=eQSpAm77vovB6qaWoIrx9Q3Rda5XeP9820/
	cqGGyHB0=; b=D9UfIxs+1CCql45t/Kykew8km6EChn2ZIPBAV7sXtqv5HM8nqoG
	b13YZ27GIPMJ0E4lMUtikVjrtmPYA8pCSAYBFJ4UFAGTxPO32eT3cnBfrNyMK1em
	NyUUIo2HWOk2uzfdPE619FwcklwvMQ7NI3DQn9FiDJBZC/4FrhSjtU0XNEpKM5rN
	+7fqN77+otQnzVU7ARXXTzF0iVrkTsBLcBubLiqwrzI80JddE/x9Hg+8jv9Y1pfg
	MP8QtjpIaI3vu1LCNg/TJjB6APFXaFqh9IqTPCI5HABfB+Nj7QmGyvqqWBQKXoHD
	eCa1vfKg8Hr7sgqCWE20kUM11JNfM3dC6Hg==
X-ME-Sender: <xms:nt9garng721yOzPq7o22Vm0YUwQs6OSDRUySQBidi7Xd_qc6JM-SJQ>
    <xme:nt9gak2EKMTPTHkv6sE-SKTrZ8b6TsNmZd3752JaQ0UI9CsjSGQRmvftrAwpyph_W
    n5_xnKGkuGjiz5dlJ4J35juPrdyVxipNTpdpJZkzkWX0rU7MJV8FoE>
X-ME-Received: <xmr:nt9gavR4Yt3VrQXbXWWEInGczyTI3ogzN5YNEZp33JB6B8e_vcCZ8xFUxHVNtyD3Gl1WDdmHv1mNgEaxOA8w9CTToY0>
X-ME-Proxy-Cause: dmFkZTFFRIGe//FM48hnHSAkuZsYpwxX6K3Qk+IgOxR9YZb8wMWaz9c4A7qdhfUdAxENNN
    UvMOFq2jpvciftXUAkt2j0UOn5kePrIuArEyq0KLtM6OW0LvUxLhQqdFKd48ll3oZ1skoA
    K/eoEnURwtiUCJSARJcfh1NHiq+x7SIudKgE1N2fUdsikJ6A4cx2Lw02vSpnxWWsYtTL9b
    XC74gKZiNUrnzLnB9t5kdXSSZDEc6F7Gm6IhSx0h0UOvHBGnNLUKzYdpZHl+CRDhTaKrNq
    +DZBtmNGQN7wfPQHKJIfLRxtVNSunG2kP8F15Xz8cbtqV6ec2/LgDUV0a4MTF8T7/gcIrd
    vzAEc4Br78BgMFfb2KGK2678ROz90DmT4AJGNX994VpPggPQPLxIcBuoycP4ofP5zmJEZV
    7IX6ohvMM4pv6InozCkSC/AbbkK4bH3nNNgL+lXmW3hpU7dz6MZGd4RM6BWAlSKXxitvlZ
    2mjNctF57gEE8dxcEcA2aL6LEguy/ARHG4aEnsJl5vmQ5ANhYHsi+wg8H+XU20RB4bJ1FR
    hNyEvSg8E+ZYS/ofKVgk8eeggc1aFMqbWnI7Hv6ILNY/CdrpjCUymjRWCOPAVasWofnKvJ
    JHX9C0c4wjmlhwEz1+1JaBoBQjXEZIIJUwkxjnCqZcvZCybtl60wYkhBx6MA
X-ME-Proxy: <xmx:nt9gausAY_zgrS6LK7BxF9WxhRxCxTQeHY0JQuE7NLIJwHhCmcPr5g>
    <xmx:n99gasYDZfWlVdL3zXgS7RvudGjcVPcfguX78LgtJg1SvNFjbDB9dQ>
    <xmx:n99gartqhgkWfCXvNUh6Za_sgJy6yJJ9brpagwnPr6iho4KdVIH7Rw>
    <xmx:n99gamEmGDwUu0IkHy-SlBiK-LOeJrh7NAvUc42OmLETSc8G2m3baA>
    <xmx:n99gav5X9V7SdsiqX4GPBBjEFUT4Lu8G8G0UbidQIkNhR9Ou0dy-RN76>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Jul 2026 11:19:58 -0400 (EDT)
Date: Wed, 22 Jul 2026 08:19:49 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] btrfs: some optimizations and cleanups for log
 syncing
Message-ID: <20260722151949.GA26033@zen.localdomain>
References: <cover.1784656641.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1784656641.git.fdmanana@suse.com>

On Wed, Jul 22, 2026 at 01:41:36PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Some optimizations for log syncing, specially for non-sdd mounts, and
> some cleanups. Details in the changelogs of each patch.

Reviewed-by: Boris Burkov <boris@bur.io>

> 
> Filipe Manana (7):
>   btrfs: stop sleeping for one jiffy in non-ssd mounts during log commit
>   btrfs: remove log batch counter use for fsync
>   btrfs: do an initial lockless committed log transaction check during log syncing
>   btrfs: check for log writers count first in wait_for_writer()
>   btrfs: move condition for log commit wait into wait_log_commit()
>   btrfs: check for exit condition after waking in wait_log_commit()
>   btrfs: use simple booleans for log_commit field in struct btrfs_root
> 
>  fs/btrfs/ctree.h             |  6 +--
>  fs/btrfs/disk-io.c           |  3 --
>  fs/btrfs/file.c              |  4 --
>  fs/btrfs/transaction.c       |  8 +--
>  fs/btrfs/tree-log.c          | 98 ++++++++++++++----------------------
>  include/trace/events/btrfs.h |  4 +-
>  6 files changed, 42 insertions(+), 81 deletions(-)
> 
> -- 
> 2.47.2
> 
