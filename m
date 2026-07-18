Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B9F4C92;
	Sat, 18 Jul 2026 00:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784333594; cv=none; b=M7zSlFycpXt6JuBNGtG9h4E07NAMr7ayPj3aktcsPkDrAhgykQN2HH5G4NQo9X+QSNnlkIWkUnyzOrQklNu8YbREgFCCUvACyyH37ax4c4x2eUmEjbijskkUzBwuKUP49I3OxfKj0nB0hXUwEC+VSUgmQYJzCNCwqVbu+jmYAOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784333594; c=relaxed/simple;
	bh=u29VOn7HArRKYHxXNqTDcrpIV4JOPFCMDHAf3H8NE3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=peK3moNyBLwJMdw6i0GklcSASGbU8l7TRoBwFUBd6uyIYfERwPOWPBU8K2+NcvrTOwIa4f+Oi60oDeYV9366IyHMW4c3ac1mf6QuxyZOOPAtiXc3boBDjmXiX4xM9tH1qEtwrZDhMiGilov/cGT8sVB4SGgCYXfwt2ND96Wq+QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=BcNn44nC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=mUiIHUAT; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="BcNn44nC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mUiIHUAT"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id C91F3EC00A9;
	Fri, 17 Jul 2026 20:13:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 17 Jul 2026 20:13:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784333591; x=1784419991; bh=tdWspsLKBl
	P3MMyJg+M8R0G6UyglorfJ+NGerT1PXs4=; b=BcNn44nCM6OeP2rR/QNOkyMN3x
	Rre3zsE+kVukqVOQkscB+gxhkEbMRj6F/RMJ6uZ2Wh3ttUN1GFdwTB7pWxrieGd1
	+sjsMIdAryU0wskQi8Pj1WrBinx1mjcC+BdFCHXf/6MVjeNselk91lG/CTUltHAD
	XjYpvJWVoqFY8Jel+bYI126mJC4KSrG27M3WS2TodVdtFSlF4fi76JOk7C5FcgOE
	loS6qywZaDFCJr2MVfzUglc03MzK/ts9243IYZJKlWLzMX1OZDmE8LWbsQTcFY6+
	TqZc+dc89KUgx4yV170+Sx9UZJ+YkBfR7BTwjUQ3IValiCW1k7idCm8TuLpg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784333591; x=1784419991; bh=tdWspsLKBlP3MMyJg+M8R0G6UyglorfJ+NG
	erT1PXs4=; b=mUiIHUAT4WJDOZ0YAsIKpCRGtzDw17bbW9tnWmGcBZLQCujSPZk
	+gQc0mHQ5BOMXF8SdQU66DwlyQzwace98KWh9F+/G4GJ+gSfkxWU6io4CC4p7GMK
	HQAVimZ2rkwBmso20Is7PPIkBCHwoQ4uhdpS+ctfvvcj6B9Mx95jv5/kDui+YWWE
	cT6lZiX/dH3bs5+SW4IKTvJvFrg9bDuk2dXfYR/Yd+z+98legX/PsU8oAln0AJS9
	UCxDk3LLya9WkhLDU7+ViyVUfR2rezHIt3m2+f5JYjf/iO3LRYW4BM3wVREBdxbB
	XMU5Rh5wne4Ljq2kMXM1bqxoFQeybz0a+LQ==
X-ME-Sender: <xms:F8Vaao5r8XJ2E41FIq9xB4yOl_R-ZH8Vm6VJBq85DeTL2tZXJXh0KA>
    <xme:F8VaajPPQQaHUFMraEKI4RITV5JHnMBK74yxfsvbpBbZt8lXZwQIwqiyeKvqpfgUj
    h9O7jsyzasFRSNJHNHy14B4nvIgQd1nV_4h5jU2rDD2iLvg-fgkJLA>
X-ME-Received: <xmr:F8VaauvZpm2On4oywbmMNGYTeU7kdoCG3_T7WSp1zZfd8wNSN-Uzna_ZSJsb0RawgTx94ODMMza0Y_RaR6mfESKs5Mc>
X-ME-Proxy-Cause: dmFkZTEBqkSNjxJRh47EKc5WCiQqSiqCwK6nq8Ko97MIDBwjkiy6W0xFo43qWJwJLumst1
    U5mEVKUDjA/yiGh7N67eC7PNklFSGyy3mxyuiv7giTiCFNKxAB7ue8ILMPh89SXOWsHS/E
    RHdpkJx+67D1diHEZ0gaNeJL5ZbTwREeri7Mloeoahj9bn79/NXg2eeBxT+dVQGp9YbsLJ
    74wJzylRYHwITZF5FSfau8oynECDTVUSPWIM8KZh3g+W5o3pSFQmhtvrHkEoHkFZjFgkiP
    yns/D+lbnpm1mfnL2ID+93TvX1Dv7a7J5W05GM2kI8QpmiaZHUMRDZ3rdSaxOelFpy2AnO
    2GAWFMh648m+2anQm1nNaI5PpFTLJIg8E2p5CLncSK1BNjiFgQroF04cHPpP3ToxuInZWN
    Y296CeAeoR6tS7YPKFT9BOwY4NEM8nnUqZcfcpuh3WQ89GsXKq1uRIGVWYqHERIakfMuNm
    GrKlEGt+FLAz7sI/3dYawJsKAfpUsy3SIE5t8sfA+ehUA7PGzd7dUO6yLqpYQUN79dLrpD
    jzJhRDQo4G8G4NCGAwkOozjg/wEiUKoCHkfI0LMQsdAUcjdPIIFdv8LIoN4mra0ZsfrJ8I
    AaoyO2K0albtF6Vz3OdGb0RAJ3ABb4HnTuLL1PUMutN3SzL5H4hYtDqOdJOA
X-ME-Proxy: <xmx:F8VaauYJqNUatKle9z_hZLknB76mCuwwFDya7hnErO4TOvfzLTozSg>
    <xmx:F8VaaoxRgZMU3LahWjrOEyrmKXSGckUk9WAxMAT0APLnGWKDuZ-y4A>
    <xmx:F8VaauiEMZGU-4qz-qlZ54pPP04HLsLr4fatM2QT54crkdEX0NRyMw>
    <xmx:F8VaasniofC8nZaE9IAi4DVx2Yok3i2SsiPhMX4hfHAot_Kpf2UgXg>
    <xmx:F8Vaaq5pv2fFsadFlN0uhJA5URkqyNpvvx4p-u57CXDeozY-bsyn9eUS>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Jul 2026 20:13:11 -0400 (EDT)
Date: Fri, 17 Jul 2026 17:13:09 -0700
From: Boris Burkov <boris@bur.io>
To: Jeff Layton <jlayton@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@fb.com
Subject: Re: [PATCH 3/4] btrfs: handle ENOMEM from btrfs_insert_dir_item()
 without aborting
Message-ID: <20260718001309.GA420230@zen.localdomain>
References: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
 <20260717-btrfs-enomem-v1-3-cdc9c0e265d0@kernel.org>
 <20260717201805.GB142812@zen.localdomain>
 <c0672fee4d99be98cc85f7f22f31667121ae4100.camel@kernel.org>
 <20260717230455.GA251596@zen.localdomain>
 <223c999d96a6a69f5824f145cabe3bec891c5956.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <223c999d96a6a69f5824f145cabe3bec891c5956.camel@kernel.org>

On Fri, Jul 17, 2026 at 07:55:35PM -0400, Jeff Layton wrote:
> On Fri, 2026-07-17 at 16:04 -0700, Boris Burkov wrote:
> > On Fri, Jul 17, 2026 at 06:40:42PM -0400, Jeff Layton wrote:
> > > On Fri, 2026-07-17 at 13:18 -0700, Boris Burkov wrote:
> > > > On Fri, Jul 17, 2026 at 12:52:38PM -0400, Jeff Layton wrote:
> > > > > Now that btrfs_insert_dir_item() returns -ENOMEM before modifying the
> > > > > btree (thanks to delayed dir index pre-allocation), callers can handle
> > > > > ENOMEM gracefully instead of aborting the transaction.
> > > > > 
> > > > > In btrfs_add_link(), add -ENOMEM to the set of recoverable errors
> > > > > alongside -EEXIST and -EOVERFLOW. The fail_dir_item cleanup path
> > > > > unwinds the inode_ref/root_ref and returns the error to userspace.
> > > > > 
> > > > > In btrfs_create_new_inode(), when btrfs_add_link() fails with -ENOMEM,
> > > > > convert the newly-created inode into an orphan instead of aborting.
> > > > > This is done by clearing nlink and adding an orphan item, which ensures > > > > > btrfs_evict_inode() will delete the INODE_ITEM and INODE_REF, and
> > > > > crash-recovery will clean it up via orphan processing. If
> > > > > btrfs_orphan_add() itself fails, we fall back to aborting.
> > > > > 
> > > > > This turns a filesystem-killing transaction abort into a graceful
> > > > > -ENOMEM return to userspace for create(), mkdir(), mknod(), symlink(),
> > > > > and link() operations under memory pressure.
> > > > > 
> > > > > Assisted-by: LLM
> > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > ---
> > > > >  fs/btrfs/inode.c | 17 +++++++++++++++--
> > > > >  1 file changed, 15 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > > > > index b7b4e6177135..4d9947ae08f7 100644
> > > > > --- a/fs/btrfs/inode.c
> > > > > +++ b/fs/btrfs/inode.c
> > > > > @@ -6676,7 +6676,20 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
> > > > >  	} else {
> > > > >  		ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode), name,
> > > > >  				     false, BTRFS_I(inode)->dir_index);
> > > > > -		if (unlikely(ret)) {
> > > > > +		if (ret == -ENOMEM) {

So we are now handling ENOMEM from btrfs_add_link()

> > > > > +			/*
> > > > > +			 * The ENOMEM came before the DIR_ITEM was inserted,
> > > > > +			 * so the btree has our INODE_ITEM + INODE_REF but no
> > > > > +			 * directory entry. Convert this into an orphan so
> > > > > +			 * eviction (or crash-recovery) cleans up the inode.
> > > > > +			 */
> > > > > +			clear_nlink(inode);
> > > > > +			ret = btrfs_orphan_add(trans, BTRFS_I(inode));

And when we get ENOMEM, we call btrfs_orphan_add() isntead of
unilaterally aborting. I contend that this call is now likely to ENOMEM

> > > > > +			if (unlikely(ret))
> > > > > +				btrfs_abort_transaction(trans, ret);

And abort here.

> > > > 
> > > > I feel like the crux of this series to me is whether you have practical
> > > > conditions where the allocation of the delayed_node is failing, but the
> > > > allocations involved in btrfs_orphan_add() succeed. It allocates a
> > > > btrfs_path and has to walk the btree which might have to read the node
> > > > at every level which might need to allocate 16k extent buffers and
> > > > extent buffer objects and xarray storage for each one. For size
> > > > reference, on my build (maybe debug..?) a delayed_node is 552 bytes,
> > > > while a btrfs_path is 112 and an extent_buffer is 432. So they are
> > > > pretty similar in size (not to mention the 16k of node file backed
> > > > memory we are sort of likely to have to allocate if we are under
> > > > reclaim)
> > > > 
> > > > Were you able to reproduce this issue and help in practice or is this a
> > > > theoretical / structural improvement?
> > > > 
> > > 
> > > I didn't really try to reproduce this in earnest. We only see it in our
> > > fleet under heavy memory pressure, and even then at such low frequency,
> > > I doubt our chances of hitting this on anything other than a huge set
> > > of machines.
> > > 
> > > So, theoretical / structural, but we have record of filesystem aborts
> > > where the stack indicates that this would have prevented it. Userland
> > > would have gotten an -ENOMEM back but the fs wouldn't have aborted.
> > > 
> > 
> > My concern is not that we don't hit ENOMEM in btrfs_add_link(), since
> > like you said we can observe that in abort logs. I am worried that even
> > if we try to handle it gracefully, we will just ENOMEM in
> > btrfs_orphan_add() and abort anyway. That is why I was wanting to see
> > some more concrete evidence this actually helps to make it worth the
> > complexity.
> > 
> 
> In the case where we handle this gracefully, we won't hit that because
> it will have returned -ENOMEM before that point. But, you do have a
> good point that we could allocate these objects successfully, and then
> hit an error in btrfs_orphan_add() anyway.

I am still a bit confused. I made comments inline closer to the the code.
Sorry if I am being dense or missing the point!

> 
> One thought: It looks like the main allocation in that codepath is
> btrfs_alloc_path()? We could consider preallocating that too -- maybe
> stash it in a new pointer in btrfs_trans_handle?
> 
> Thanks! This is good food for thought.

Take a peek at https://lore.kernel.org/linux-btrfs/cover.1782249000.git.boris@bur.io/

which I need to RESEND :)

Thanks,
Boris

> 
> > > I see that there are some ALLOW_ERROR_INJECTION() calls in btrfs. We
> > > could wire some of these functions up with that, which would make this
> > > easier to test. I'll look into that in the meantime.
> > > 
> > > > With that said, all the prealloc wiring looks good to me in general, and
> > > > it seems to be a pretty clean win for the "name exists" case in the next
> > > > patch.
> > > > 
> > > > 
> > > 
> > > Thanks for the review!
> > > 
> > > > > +			ret = -ENOMEM;
> > > > > +			goto discard;
> > > > > +		} else if (unlikely(ret)) {
> > > > >  			btrfs_abort_transaction(trans, ret);
> > > > >  			goto discard;
> > > > >  		}
> > > > > @@ -6738,7 +6751,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
> > > > >  
> > > > >  	ret = btrfs_insert_dir_item(trans, name, parent_inode, &key,
> > > > >  				    btrfs_inode_type(inode), index, NULL);
> > > > > -	if (ret == -EEXIST || ret == -EOVERFLOW)
> > > > > +	if (ret == -EEXIST || ret == -EOVERFLOW || ret == -ENOMEM)
> > > > >  		goto fail_dir_item;
> > > > >  	else if (unlikely(ret)) {
> > > > >  		btrfs_abort_transaction(trans, ret);
> > > > > 
> > > > > -- 
> > > > > 2.55.0
> > > > > 
> > > 
> > > -- 
> > > Jeff Layton <jlayton@kernel.org>
> 
> -- 
> Jeff Layton <jlayton@kernel.org>
