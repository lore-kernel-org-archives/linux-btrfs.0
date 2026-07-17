Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C2E4AEEF;
	Fri, 17 Jul 2026 23:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784329500; cv=none; b=C5fsVB45vgW6L+YXHgsLDxP7e9JuZjB2lITpxEH+avFvHyTf0ld5bMge2xeXibApoj5dY738XMu8VI5VRmvI58IkG5dVjVbE5AB5yWaVnIZFcrUF2fSVbipdC5urI/UrELv1Nv2+2rX7RA7AR6QclEhIl44KYOCqhLiDBvZ5d6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784329500; c=relaxed/simple;
	bh=iiE7va83wphnTnZKptwhaqSCOl35arQufbS/IShykHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0I+//wyFKINyNWmkb4A7uP7djjNAAoT72FCkaJrTid8yTfG+O9GftHrinYl3c9KvOp1bTQA7XAyCvoIjadMIe9Wp7UNsHBjA4IN7pfVTNV19gPM7SeiiU4NC0UpJbroREo2Fjg182OFbtiEK/bXZ9zZGhe1ZdAlbk8PLJIch9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=MuIZUfQR; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bZFLal3E; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="MuIZUfQR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bZFLal3E"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5983F7A0097;
	Fri, 17 Jul 2026 19:04:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 17 Jul 2026 19:04:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784329497; x=1784415897; bh=qhvzNNnPNS
	Cy5/f6E7i+yUHzhZPqHp12pWT62nb5m/0=; b=MuIZUfQRl7uPjAshFAhDTwLYCQ
	2kt84w+bCbCD6i6gLxrDn3zQBrqy1MxYQCzIDZQN+Z270DdMXrVeTb1YHD+tFfU4
	+2EAy42oDXu3dr7JuDOtfOJcPgsFdsOePJBdldOHYE2xwKphT9Js0S2dBjk64WIT
	ho6UamSa4apC6Sv8P2dCtClnq27DVuDAOVup1eSoLpClvRfgcN7rcJ61Dpt7Gzdn
	zETVkdIoC1Vr6uajqP1znWYeKo8bqPNYFk6nQ1/qCb1OUicwlC/o80iTq9m6olzf
	N34Rox1n/Rc/nBw8kYT1gUmjxN0NY1lTQnLDFXitSYz7Z9atznTmN9V62wrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784329497; x=1784415897; bh=qhvzNNnPNSCy5/f6E7i+yUHzhZPqHp12pWT
	62nb5m/0=; b=bZFLal3EMDsB+oumszBnRp5VEr/JOpoUv9JjO4TZ8Gf3JLrqiQ8
	faYZT0rbtDrDkCkBukuJBcpxUlug9V28qZ4mrp7nVtUQLjuSCSmZdVnVQwQTjugN
	0ACMFWaREFemzUo7Hl7J2yQbsz4tFCa8iHY6E/d1c9BoCEQbYx69LmnsbHjDyGUl
	kqo0M9zaosTKhjZaIflQKqKXgSV4vIrSv4rkl+Mj/kQ1UL84CbQ7BevHBUjMWy6c
	WYtDURe1hbygOx8DRpqS7VWTGM4/WXBV7xahQJCLsIke51ex294cTsTEXtMZSaLR
	GJrUNGcDZJKPW4tW5CY04KYw8MG/3LW4Djw==
X-ME-Sender: <xms:GLVaagai75M_8rvspTkWPluj3fDg30JUVijJUNKWen8OHYMk7fEwuA>
    <xme:GLVaakvQDr6XHRoHrmmmitZ6gwYxx25MXgoyFy650NzK7Z_T8JzeX0ITxTDTHFqKS
    WEFtsVNk7tpu_dQQubkNBNxTP5GfZS4qpUg9mMlVkVdy0rLCnRlTEw>
X-ME-Received: <xmr:GLVaaiPhC7EdNHCU5sw75NZC-Xgd5Ypa9z3GkjZdLVb1vpsV2FX6RJj0cKv0JfX2sncJvUIRMZ2R2GxTHpvOhZuPAPg>
X-ME-Proxy-Cause: dmFkZTFxFWWyz9Sfsm36j91s7K3csbYo6NGvSXwA6jD5c024qr/SHjVR1f+7KLixJgf9r1
    mceOIjfSsXXtM+LsaMIFaOzZQHjMj/ZutPR/ZS5vaJHQ/xWFBM+Uag8G2kpeHPUzjMxHgD
    xc5xv3q9E6nvvkOsaXFbpIMixVUFbbpWzl7iETAjXSy04xW97cwuqe8n+rsbByrddKtRZm
    EoqxMHvGK84AMW86bf3vkYIAw3kbAdPRgjmETI80GO5c/PsvH1jRDG3kBlNukvCprpx7/V
    jr4fYaFsH4nubrIRXtfkVW8Wq8BgExZWEaE1aWueLQ1KMyq5n1pzyxFn9+rjLIuBswfjGH
    I2UTN8AHDeO7FJumdnH5X+Ttup5C91VD2d/JZl2Yn1Qi78Y+Lbu5smbMsNBdSzbKSU84/T
    o7+ksi6Ykw/Tc5PN6ydyXq6ypC6rG68eOYAOZIJOv9EvHqCq1GwYX0CkoX/2diLqM4gCoN
    jJ/t+fzh8XndOx4Nu39ka/MOyk+J1It7Y4H70uzMdfyu9SUW2VHpjAYu0HMPdp2BtcP85/
    +PFvKSyG6DxX+DVR9gelZUP1eVQiVOOFB2tx79Oj88uGRHznyggtryV334VuqIaXUZGKKy
    YHN2SgQkzpqc1O5OavRswo/EUTsl9IrchAGw92QmP9whN1IgFWw8FfxkQu5Q
X-ME-Proxy: <xmx:GLVaar5syIOv9QBU_nE6qvFGTWOsRkMcDoadK2O8kgoxXmGS7DOYdg>
    <xmx:GLVaaoR3OT-uXcp69_zfYhTb5oiD0X-shtK7xBYpCIVpxncAwGVNCw>
    <xmx:GLVaaoB_VjE6Qnv9qjR2BjEu1sIayiYDiUHKGh8gqtmoGM-8dh3OxQ>
    <xmx:GLVaaoElpS0hU_tzp96_0ghb5VBiXxY6u_agGMZsPx0vusW1lR8tsg>
    <xmx:GbVaaibYJDxgi4Swo3YshJ6zzQF0rnBhMnqzFwSmotF5I1fZzQ6GKhbQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Jul 2026 19:04:56 -0400 (EDT)
Date: Fri, 17 Jul 2026 16:04:55 -0700
From: Boris Burkov <boris@bur.io>
To: Jeff Layton <jlayton@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@fb.com
Subject: Re: [PATCH 3/4] btrfs: handle ENOMEM from btrfs_insert_dir_item()
 without aborting
Message-ID: <20260717230455.GA251596@zen.localdomain>
References: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
 <20260717-btrfs-enomem-v1-3-cdc9c0e265d0@kernel.org>
 <20260717201805.GB142812@zen.localdomain>
 <c0672fee4d99be98cc85f7f22f31667121ae4100.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0672fee4d99be98cc85f7f22f31667121ae4100.camel@kernel.org>

On Fri, Jul 17, 2026 at 06:40:42PM -0400, Jeff Layton wrote:
> On Fri, 2026-07-17 at 13:18 -0700, Boris Burkov wrote:
> > On Fri, Jul 17, 2026 at 12:52:38PM -0400, Jeff Layton wrote:
> > > Now that btrfs_insert_dir_item() returns -ENOMEM before modifying the
> > > btree (thanks to delayed dir index pre-allocation), callers can handle
> > > ENOMEM gracefully instead of aborting the transaction.
> > > 
> > > In btrfs_add_link(), add -ENOMEM to the set of recoverable errors
> > > alongside -EEXIST and -EOVERFLOW. The fail_dir_item cleanup path
> > > unwinds the inode_ref/root_ref and returns the error to userspace.
> > > 
> > > In btrfs_create_new_inode(), when btrfs_add_link() fails with -ENOMEM,
> > > convert the newly-created inode into an orphan instead of aborting.
> > > This is done by clearing nlink and adding an orphan item, which ensures
> > > btrfs_evict_inode() will delete the INODE_ITEM and INODE_REF, and
> > > crash-recovery will clean it up via orphan processing. If
> > > btrfs_orphan_add() itself fails, we fall back to aborting.
> > > 
> > > This turns a filesystem-killing transaction abort into a graceful
> > > -ENOMEM return to userspace for create(), mkdir(), mknod(), symlink(),
> > > and link() operations under memory pressure.
> > > 
> > > Assisted-by: LLM
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/btrfs/inode.c | 17 +++++++++++++++--
> > >  1 file changed, 15 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > > index b7b4e6177135..4d9947ae08f7 100644
> > > --- a/fs/btrfs/inode.c
> > > +++ b/fs/btrfs/inode.c
> > > @@ -6676,7 +6676,20 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
> > >  	} else {
> > >  		ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode), name,
> > >  				     false, BTRFS_I(inode)->dir_index);
> > > -		if (unlikely(ret)) {
> > > +		if (ret == -ENOMEM) {
> > > +			/*
> > > +			 * The ENOMEM came before the DIR_ITEM was inserted,
> > > +			 * so the btree has our INODE_ITEM + INODE_REF but no
> > > +			 * directory entry. Convert this into an orphan so
> > > +			 * eviction (or crash-recovery) cleans up the inode.
> > > +			 */
> > > +			clear_nlink(inode);
> > > +			ret = btrfs_orphan_add(trans, BTRFS_I(inode));
> > > +			if (unlikely(ret))
> > > +				btrfs_abort_transaction(trans, ret);
> > 
> > I feel like the crux of this series to me is whether you have practical
> > conditions where the allocation of the delayed_node is failing, but the
> > allocations involved in btrfs_orphan_add() succeed. It allocates a
> > btrfs_path and has to walk the btree which might have to read the node
> > at every level which might need to allocate 16k extent buffers and
> > extent buffer objects and xarray storage for each one. For size
> > reference, on my build (maybe debug..?) a delayed_node is 552 bytes,
> > while a btrfs_path is 112 and an extent_buffer is 432. So they are
> > pretty similar in size (not to mention the 16k of node file backed
> > memory we are sort of likely to have to allocate if we are under
> > reclaim)
> > 
> > Were you able to reproduce this issue and help in practice or is this a
> > theoretical / structural improvement?
> > 
> 
> I didn't really try to reproduce this in earnest. We only see it in our
> fleet under heavy memory pressure, and even then at such low frequency,
> I doubt our chances of hitting this on anything other than a huge set
> of machines.
> 
> So, theoretical / structural, but we have record of filesystem aborts
> where the stack indicates that this would have prevented it. Userland
> would have gotten an -ENOMEM back but the fs wouldn't have aborted.
> 

My concern is not that we don't hit ENOMEM in btrfs_add_link(), since
like you said we can observe that in abort logs. I am worried that even
if we try to handle it gracefully, we will just ENOMEM in
btrfs_orphan_add() and abort anyway. That is why I was wanting to see
some more concrete evidence this actually helps to make it worth the
complexity.

> I see that there are some ALLOW_ERROR_INJECTION() calls in btrfs. We
> could wire some of these functions up with that, which would make this
> easier to test. I'll look into that in the meantime.
> 
> > With that said, all the prealloc wiring looks good to me in general, and
> > it seems to be a pretty clean win for the "name exists" case in the next
> > patch.
> > 
> > 
> 
> Thanks for the review!
> 
> > > +			ret = -ENOMEM;
> > > +			goto discard;
> > > +		} else if (unlikely(ret)) {
> > >  			btrfs_abort_transaction(trans, ret);
> > >  			goto discard;
> > >  		}
> > > @@ -6738,7 +6751,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
> > >  
> > >  	ret = btrfs_insert_dir_item(trans, name, parent_inode, &key,
> > >  				    btrfs_inode_type(inode), index, NULL);
> > > -	if (ret == -EEXIST || ret == -EOVERFLOW)
> > > +	if (ret == -EEXIST || ret == -EOVERFLOW || ret == -ENOMEM)
> > >  		goto fail_dir_item;
> > >  	else if (unlikely(ret)) {
> > >  		btrfs_abort_transaction(trans, ret);
> > > 
> > > -- 
> > > 2.55.0
> > > 
> 
> -- 
> Jeff Layton <jlayton@kernel.org>
