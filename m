Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575CA246BD5;
	Fri, 17 Jul 2026 22:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784328046; cv=none; b=nXyYukHgaWBOwdYdfIajeJUdQLxQeRIZVCSSQuefd0OIot0y67oievM660VVZB6td2CSZc7CvYjAlsUG67emCkiUBndkFNJtuUToMsPmQ6+zYKeLorGM0v2bTOsBzQ9Qi9/5wF0t2KnSN/BzEQPk+15oG8ePgXfIMD252OYrIYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784328046; c=relaxed/simple;
	bh=D/l8vdXpyE+IuJPLpLgRIWEvIk1U7A1WSjGhF1jgCSg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xr3wP0i2Gt9pOcEs6NLtXqFjB/1beROqXS536KCtKSlmiQDrCuF78Fb0+azBE/K7qZ8IKnUWMsiLruCpIH7ZR38WtPg8X1rrnxlh7UZbxsEAkaqwCMa/UJysmDMnoQXL9B8PnUEga6sPSKhz39pjGURD8mzMm16kB1uPvz2EjBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oQDdm83m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oQDdm83m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994301F000E9;
	Fri, 17 Jul 2026 22:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784328045;
	bh=tQGo0Ccginkk9S0MTCxAcdRmVex+KXril9NkC06jaqo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oQDdm83m+1riBor3EE9nmAsY/B8Qi4xf/NInXn3NRhBY4M63i0EhujVR/Zr090HIW
	 a77ZwUH3hne/5ZsDReA92DQSWmLANSt7dzEr4jIHwXeZ+PJwByuTjhVP//PXvCb2gL
	 NqX5ZN2Ree62QA4CAzB7fGus+eR5xs/yh9S2afdpf4WiQi6nBh6JZ9klY/Zf0DzoF+
	 Fg0/eQnvJ3Ng7v1v2gSwj9GH/sL9brkaZ2wOhRpvtVhD4Sz/MMwuFlbQ4DlzHkQo1v
	 WLyBWhjNSe9SntXcrASOEn6YUKIiQsFeCD5LJn+KcWIThboHfLryope78mQm6gFTIN
	 du1k/ZBidIKgw==
Message-ID: <c0672fee4d99be98cc85f7f22f31667121ae4100.camel@kernel.org>
Subject: Re: [PATCH 3/4] btrfs: handle ENOMEM from btrfs_insert_dir_item()
 without aborting
From: Jeff Layton <jlayton@kernel.org>
To: Boris Burkov <boris@bur.io>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@fb.com
Date: Fri, 17 Jul 2026 18:40:42 -0400
In-Reply-To: <20260717201805.GB142812@zen.localdomain>
References: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
	 <20260717-btrfs-enomem-v1-3-cdc9c0e265d0@kernel.org>
	 <20260717201805.GB142812@zen.localdomain>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-07-17 at 13:18 -0700, Boris Burkov wrote:
> On Fri, Jul 17, 2026 at 12:52:38PM -0400, Jeff Layton wrote:
> > Now that btrfs_insert_dir_item() returns -ENOMEM before modifying the
> > btree (thanks to delayed dir index pre-allocation), callers can handle
> > ENOMEM gracefully instead of aborting the transaction.
> >=20
> > In btrfs_add_link(), add -ENOMEM to the set of recoverable errors
> > alongside -EEXIST and -EOVERFLOW. The fail_dir_item cleanup path
> > unwinds the inode_ref/root_ref and returns the error to userspace.
> >=20
> > In btrfs_create_new_inode(), when btrfs_add_link() fails with -ENOMEM,
> > convert the newly-created inode into an orphan instead of aborting.
> > This is done by clearing nlink and adding an orphan item, which ensures
> > btrfs_evict_inode() will delete the INODE_ITEM and INODE_REF, and
> > crash-recovery will clean it up via orphan processing. If
> > btrfs_orphan_add() itself fails, we fall back to aborting.
> >=20
> > This turns a filesystem-killing transaction abort into a graceful
> > -ENOMEM return to userspace for create(), mkdir(), mknod(), symlink(),
> > and link() operations under memory pressure.
> >=20
> > Assisted-by: LLM
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/btrfs/inode.c | 17 +++++++++++++++--
> >  1 file changed, 15 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index b7b4e6177135..4d9947ae08f7 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -6676,7 +6676,20 @@ int btrfs_create_new_inode(struct btrfs_trans_ha=
ndle *trans,
> >  	} else {
> >  		ret =3D btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode), name,
> >  				     false, BTRFS_I(inode)->dir_index);
> > -		if (unlikely(ret)) {
> > +		if (ret =3D=3D -ENOMEM) {
> > +			/*
> > +			 * The ENOMEM came before the DIR_ITEM was inserted,
> > +			 * so the btree has our INODE_ITEM + INODE_REF but no
> > +			 * directory entry. Convert this into an orphan so
> > +			 * eviction (or crash-recovery) cleans up the inode.
> > +			 */
> > +			clear_nlink(inode);
> > +			ret =3D btrfs_orphan_add(trans, BTRFS_I(inode));
> > +			if (unlikely(ret))
> > +				btrfs_abort_transaction(trans, ret);
>=20
> I feel like the crux of this series to me is whether you have practical
> conditions where the allocation of the delayed_node is failing, but the
> allocations involved in btrfs_orphan_add() succeed. It allocates a
> btrfs_path and has to walk the btree which might have to read the node
> at every level which might need to allocate 16k extent buffers and
> extent buffer objects and xarray storage for each one. For size
> reference, on my build (maybe debug..?) a delayed_node is 552 bytes,
> while a btrfs_path is 112 and an extent_buffer is 432. So they are
> pretty similar in size (not to mention the 16k of node file backed
> memory we are sort of likely to have to allocate if we are under
> reclaim)
>=20
> Were you able to reproduce this issue and help in practice or is this a
> theoretical / structural improvement?
>=20

I didn't really try to reproduce this in earnest. We only see it in our
fleet under heavy memory pressure, and even then at such low frequency,
I doubt our chances of hitting this on anything other than a huge set
of machines.

So, theoretical / structural, but we have record of filesystem aborts
where the stack indicates that this would have prevented it. Userland
would have gotten an -ENOMEM back but the fs wouldn't have aborted.

I see that there are some ALLOW_ERROR_INJECTION() calls in btrfs. We
could wire some of these functions up with that, which would make this
easier to test. I'll look into that in the meantime.

> With that said, all the prealloc wiring looks good to me in general, and
> it seems to be a pretty clean win for the "name exists" case in the next
> patch.
>=20
>=20

Thanks for the review!

> > +			ret =3D -ENOMEM;
> > +			goto discard;
> > +		} else if (unlikely(ret)) {
> >  			btrfs_abort_transaction(trans, ret);
> >  			goto discard;
> >  		}
> > @@ -6738,7 +6751,7 @@ int btrfs_add_link(struct btrfs_trans_handle *tra=
ns,
> > =20
> >  	ret =3D btrfs_insert_dir_item(trans, name, parent_inode, &key,
> >  				    btrfs_inode_type(inode), index, NULL);
> > -	if (ret =3D=3D -EEXIST || ret =3D=3D -EOVERFLOW)
> > +	if (ret =3D=3D -EEXIST || ret =3D=3D -EOVERFLOW || ret =3D=3D -ENOMEM=
)
> >  		goto fail_dir_item;
> >  	else if (unlikely(ret)) {
> >  		btrfs_abort_transaction(trans, ret);
> >=20
> > --=20
> > 2.55.0
> >=20

--=20
Jeff Layton <jlayton@kernel.org>
