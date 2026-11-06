Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793985152;
	b=cqabkyPZ6EV81x9C3DQhLAVj3eFTifLTPpPt59Q8AfaXKlpuJYBMpoojDNgXByUJFJmb
	 G2DDRI5YoiJpc9UEiUiYSpbeFWLUcNd6O7M0HyDQbBRDzQ9epo7BQW7KGmiqjyyxToGHj
	 rsK+SM3zU+2v8i/CbG0pVoLTKHo0Q4S7XZpyvhQc8F1ddYIeXHC6HRKxq+t3Y8rMJ18Ok
	 s4mhBE4bEUlDXIYa8C8x4oHW8PY+rLQSeB5wxEp1W/bmdvf6hPyvo5BxsD1s2bU1YH7IZ
	 G/tNczVuGahdUMgfyoZkJILcw4n0BoEbAqCT0zrm87nvGkJcRtQkW4JQlD57o2K/F9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793985152;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=BQDrcrEjG+Kx7+u1UxhHBBjG81U229huiJS0+IdWN6Q=;
	b=ZGQrJHx4uFQUOmK8QABNGf0RzJ45vT4SOPN1LeLv1YZpA3f2iDtJtbaXC9m4hrRWqxJg
	 jntkgvzhrHFYwuWIE4uNz3Pur3QnHFZXW2U01/Ug0hrmIKoI84m0I6dTxzYHmUg8oj526
	 4pl5ewZZ4szxdo6E0Wh/qoFnU2M3HEcIFJ1DZmmvfKUPNkBbz4FrpQyzr+CJMW+eiSxlk
	 jv3N7BIV5uCxHVKqUUw4JE5ilwaRSbhPH+1EAwEvqlm/LZTk9sVJrXbwQN2LgFdIAioe9
	 lVvwIPqQCtHPNTaIiVVN13sGlDqIfUdxXiu5XcHVT27c0DPLyWss1HGiKlEqA5losnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=AdPNGmUy;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gxRDp1RS;
	arc=none smtp.remote-ip=202.12.124.145
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136FB606A329
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 17:12:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 136FB606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=AdPNGmUy;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gxRDp1RS
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 0562A1D000BB
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 12:12:30 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 06 Nov 2026 12:12:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1793985150; x=1794071550; bh=BQDrcrEjG+
	Kx7+u1UxhHBBjG81U229huiJS0+IdWN6Q=; b=AdPNGmUyMQ14EYBfQ4KxG8x/BU
	OWaimw3JUXLxB1i7kO60FVZDvyFEjwI5zZ0M9VX9NmHiAtMMk/xaC30AlvF8mw7S
	Xtvh/4x0NJt9drGFi3th35ezWgJZ15OCwTx8KUscJWkY9PrEaO0WlFmLeicsC1VX
	h2hOWU0AkW9yzoYKNDm+cx6RGLKNnqHEXU/zS/LajlBCJFBDrgn0Le7mB/QnWZkT
	CFRIvV2vVIu5xRRwxVULQzTdE6/h7tMNWEU9dcde/VHfHgWdVr2wf7ULkKPJSPtr
	TY8K9z6p+m3NXeo2Lxb0aYP4CDo1yfKt7DnU/XVQ8c4LgEccPSi1j+ANhVLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793985150; x=1794071550; bh=BQDrcrEjG+Kx7+u1UxhHBBjG81U229huiJS
	0+IdWN6Q=; b=gxRDp1RShG//B5yS86FcInEwuLmOKEZJ5SuuYqOPcIcDdQjzg9r
	Z4BPNJKUX6gIQ7osoEtLhbGjZl87gPMYcYaQza1Enf/oQBiXMJzlabYP7/zPJR5E
	WKM9ohv2W3jp8T7yxmqijE5i2/YPrnbAGpsJ9AWayHQ/e0WcU/j382byGXNRkYze
	VmljGoKyjfhJphhG3D55xIaFgWR2OIoBYnzPxblhPYy9LkLohIOB0FSejfVAf++X
	1kfHLM3ijXsIC/ZPwRe9fF1TyuUkQk0bPURdXL9ZrXLjSEgJ8uJM24SdJTvvSbGw
	k/jac1H+YxVRnfb7L3hlCxqNWSfK0RePwnA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793985150; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:jA/EhCXH1sef/qXiTu2NKFAZXA9aQoUa80+HNfpiFWhwcuD
	u2YDKP2HOeKqTeEFGtQTsQeWspZscqbbyaGjv3Qc+um4zn4ahNg97Q1E0400VLTW
	xqoWKpe7bdzUK3m0fzkHbVp0bL3/Zub18r7ueQ3eOpaDu06Jc+w0Oh+Q7B6c+I27
	TtZ2671LJO1JCO4ehKV1J7UCSWyApo3MTm0EiXGcc/wBoBTEqilPecCk994Le1qz
	7DnrzJjMnOFcU3+m/q+7dlMWMZd5YMJqQSr97OpofWCWAFB4pPZD4vgVJhot4nGs
	PlFWtOxckq5f5MfDc7kDSt93wKa2EdL790RvbuQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:6m8C3J7a2Bq6B5OXxjLuVq5fAW4klwkoij/eQzQZ4VM=:mYfn+egV2UNwdm0fR3v8rmJs/DwMC7GLHBPryfzjEoE=;
X-ME-Sender: <xms:fgruakp8LXAX5OeQ30n6_3xVb19KQqtsWutz5kia-bqucpdJmlHU_Q>
    <xme:fgruaiFfEhNJBL2wkodYC5ipw_czL6TWJr97AjHokYnKZuGr4s7yajIIWxEbdL0v-
    DwS17288tY4hJTn7WhH8uRcIkWNH3k_j6XrmiyBNYvJ44bgzrBZM2vQ>
X-ME-Received: <xmr:fgruamkvNCUqaIbIuGkCMk3M6yAB6F4knB6AvSP8UPuNLcdN_4Dv7beD>
X-ME-Proxy-Cause: dmFkZTFZ8cchH+s67C25JMTXIXlJG9h6rg2tTA+6dZldd+0+luUdHghRUtfwu7fljEfIT6
    IP8YRU2+LRllsX1W+LrBGYqjhoe1iqAFktmZy5+Mef6DP0AEHZylo+Ugasj25Zg6uSCNIQ
    z3Yc8422AF/Y3PZUXFvrtIJF08NVpJATTHyzRMMEbpnDUfg0lai/UO3ceEiFw7gJbyjHqh
    tybYIFCMcVmD0yhfOr1y6VHEbwiLOxdCSuid5YQqa3ZADL7I/wsqShaSzeMbihP0LCgBQa
    Zn52ixhr2vDPMSOpJaB7NnJF0DRdFKnx22i6btup++nfHRLKVXytHaVBpBjvhOIEQe9BMe
    OBzEOdg/kMYSt/NpSksTBWxN03mlIBOK9fd2JwFrtlu7ah0hK7NGvzZdHtoh3CgJ/XT8Xd
    aFXPLTi19ogQEykfDcb0R1lV3VH5phHEOd7QUobuzgxe7lzgGGOpPSus7tYdqK62bt9Ckp
    ZmVCoiBXJqs3UPFzrBPl8gm4a5qDQjf6XHima7A5m9FvudQj2uzpKq3CdfzDW7v4sqsdar
    ZOnwxmHqpwyQPaiyxQDupjuwCkM08z0mX1bx0HAoLUP3BCbx/8UY9P4NuZeTkrwmIVG94t
    LYZIDd14GfsVzpFq+MHXfxVowv+D5/J4+cYzK0zeVAFVzaR0xDWkN1Rc3+BQ
X-ME-Proxy: <xmx:fgrualkJZ2US4vgmVWdIpv8mjJ2kj-4U1uJl3OUJqKcb4NB3lF3whw>
    <xmx:fgruantssvUBGnKJJiX-lNqzgp8FplFhtzQIDI4an4PXP7uFiF8h7w>
    <xmx:fgruaokzZKDFQqzk-As1aB7RgNRAGlQqvO5tHIh8X6AhxNnUrbiM3g>
    <xmx:fgruaisRFg_5Yp7JaI-fJgxHSsbwV3L7apQu7lgvCN8V_fyYtdNqDw>
    <xmx:fgruakfN6hcOVDFwa0GO5g_ENfHeQTRfAUgy7Hdzb5bcWL_DRhL9H6Ie>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 12:12:30 -0500 (EST)
Date: Fri, 6 Nov 2026 09:12:44 -0800
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v6 00/25] btrfs: zoned: fixes for generic/747
Message-ID: <20261106171244.GA401465@zen.localdomain>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028182111.160492-1-johannes.thumshirn@wdc.com>

On Wed, Oct 28, 2026 at 07:20:46PM +0100, Johannes Thumshirn wrote:
> At the moment, zoned btrfs places doesn't distinguish between DATA and
> METADATA/SYSTEM block-groups, when allocating a new chunk. Therefore
> METADATA and SYSTEM block-groups can end up on sequential write only
> zones of a drive. This adds a lot of complexity, as we can only append
> to these zones (and not perform random writes) and for METADATA we need
> to write with a queue-depth of 1 using the btrfs_zoned_meta_io_lock().
> 
> Also the write stream for METADATA is not allowed to have any "holes" in
> it and must be aligned to the write pointer, which was a source of hard
> to fix bugs in the past.
> 
> This series introduces a split in the block-group allocation path on
> zoned filesystems. For METADATA and SYSTEM block-groups try to place
> them on conventional zones if the device has them and enough are free.
> Then change the allocation in these block-groups from the zoned
> allocator to the unclustered allocator. The reverse is done for DATA

This sounds awesome!

QQ: Why unclustered? I believe metadata generally uses the clustered
allocator in non-zoned.

Working on reviewing the series now :)

> block-groups, which can be trivially written on sequential write
> required block-groups as we use REQ_OP_ZONE_APPEND for writing DATA with
> a high queue-depth.
> 
> In addition to this, this series reworks how garbage collection works in
> zoned btrfs by a tackling the remaining accounting problems and
> relocation still being triggered not timely enough to evacuate the space
> the user write needs.
> 
> NOTE: this is a combination of
> https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/
> and
> https://lore.kernel.org/linux-btrfs/20261014120353.757931-1-johannes.thumshirn@wdc.com/
> 
> Because it makes more sense to see both patchset as a single feature.
> 
> Changes to v5:
> - Don't overwrite ffe_ctl->policy, pick the allocator per block-group
> - Retry without empty_size in LOOP_NO_EMPTY_SIZE on zoned as well, so non
>   append only block-groups don't hit a premature ENOSPC
> - Perform space_info migration only on ro block-groups
> - Only set data_reloc_bg under relocation_bg_lock if it isn't set yet and
>   undo the space_info migration otherwise
> - Skip a block-group in do_allocation_zoned() instead of ASSERT()ing when
>   data_reloc_bg points to a different block-group, and only clear
>   data_reloc_bg if it points to the current block-group
> - Don't account bytes_super twice when moving a block-group between
>   space_infos
> - Return the free space of a reset block-group to its current space_info
>   if promoting it to the relocation target fails
> - Reword commit messages of "use the regular allocator for conventional
>   metadata block groups" and "return finished relocation block groups to
>   the data space_info"
> 
> Changes to v4:
> - Fixup broken rebase
> 
> Changes to v3:
> - Fix the active-zone reservation race
> - defer RAID activity publication until all stripe write pointers and
>   capacities have been validated.
> 
> Johannes Thumshirn (25):
>   btrfs: zoned: fix possible race for reserved_active_zones
>   btrfs: zoned: don't activate conventional zones of mixed block groups
>   btrfs: zoned: skip the append only metadata writeback path for
>     conventional block groups
>   btrfs: zoned: never activate conventional metadata block groups
>   btrfs: zoned: use the regular allocator for conventional metadata
>     block groups
>   btrfs: zoned: only take the metadata IO lock for append only block
>     groups
>   btrfs: zoned: allow restricting the dev extent search to a zone type
>   btrfs: zoned: prefer conventional zones for metadata chunks
>   btrfs: zoned: use plain mutex lock in check_bg_is_active
>   btrfs: zoned: use plain mutex lock in
>     btrfs_zoned_release_dirty_metadata
>   btrfs: zoned: remove btrfs_zoned_meta_io_(un)lock
>   btrfs: zoned: prefer sequential zones for data chunks
>   btrfs: zoned: wait for a running block group reclaim in RECLAIM_ZONES
>   btrfs: zoned: don't count in-flight data as available in statfs
>   btrfs: zoned: don't recheck the reclaim threshold of full zoned
>     block-groups
>   btrfs: zoned: don't account superblock zones as available data space
>   btrfs: zoned: factor out resetting a block group in place
>   btrfs: zoned: prepare reserving the data relocation block group at
>     runtime
>   btrfs: zoned: promote reset data block groups to the relocation target
>   btrfs: zoned: return finished relocation block groups to the data
>     space_info
>   btrfs: zoned: reuse block groups emptied by reclaim as relocation
>     target
>   btrfs: add btrfs_bg_type_to_num_stripes
>   btrfs: zoned: keep a zone free for relocation when allocating data
>     chunks
>   btrfs: zoned: don't count the relocation zone reserve as available in
>     statfs
>   btrfs: zoned: provide zoned specific reclaim sweep
> 
>  fs/btrfs/block-group.c       |  56 ++-
>  fs/btrfs/block-group.h       |   2 +
>  fs/btrfs/extent-tree.c       |  50 +-
>  fs/btrfs/extent_io.c         |  84 ++--
>  fs/btrfs/extent_io.h         |   2 +
>  fs/btrfs/free-space-cache.c  |  23 +-
>  fs/btrfs/fs.h                |   2 +
>  fs/btrfs/space-info.c        |   3 +-
>  fs/btrfs/super.c             |  30 +-
>  fs/btrfs/tests/zoned-tests.c |  16 +
>  fs/btrfs/volumes.c           | 107 ++++-
>  fs/btrfs/volumes.h           |   1 +
>  fs/btrfs/zoned.c             | 893 ++++++++++++++++++++++++++++-------
>  fs/btrfs/zoned.h             | 118 ++++-
>  14 files changed, 1115 insertions(+), 272 deletions(-)
> 
> -- 
> 2.56.0
> 
