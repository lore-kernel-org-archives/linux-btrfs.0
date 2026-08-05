Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2BA3E5EF6;
	Wed,  5 Aug 2026 22:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785969804; cv=none; b=DZd2iVm7v563iThTEmM8sTCOo4NhkJdKwF6tzgaGrpzR/XHAuw29n6/t3HPwrL9VLIxBhSLDW3/S4l0WRtph/jzMZeS5/PXEIvS06U5a0awn/PGWj6jJ0LBybl+UIn/xuAroez9uR+9a4feebFqNon3wwvPKXwsxjCgVsb2xW6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785969804; c=relaxed/simple;
	bh=TM+hMAxullqPsq2mhbMoANb4iD69sEfJnWOqoOsn6MI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uVcpHhl/MxO2TAPICoDgivR6KFnd3E9+LoUTpEGLiqZGLCC6/buohjAyqAM6P9DS8E7AHYjSEwBPqe63tb/9Ov9WH0f1fUwvBmmwlMvPQtfFb7CJCBKbfZjZaO7xltjIPgZ2OitdVvNZr06ohliFFWLzAVfXPShoG66VQ2vXWn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWae9kgo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWae9kgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B499A1F000E9;
	Wed,  5 Aug 2026 22:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785969803;
	bh=Fk5/Kynw2f8EMH+IoOPTFbncWd5Bp0+aKB0EFPuehcY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oWae9kgoITADS5dmjBb+hMkVPzZ/gf6kXVLOqh5I0PZM7H1Mo/JKf58dEClBw/TjI
	 T3C8YNBry3pkjNXsysahsfddfz+ZoyYwsYB7lha57dXv+J8DblYPp/s3eMDlg00Dve
	 e2LLbjSFiUmfvAiF8aLZueYr9sVp9gMO72y4YWC7CvL0ktHEOtwEKOSKpMreUMxxB6
	 d8adYKTNrLhkU/tfKvIaBrPBXcu5w759tkEGxyHsbv939po9zYL+cKrVxjnbxm43RW
	 vE+zsFZQ5sO50brgPj2xbQT1QyPZyVe69GsA2w622x7bGgffyKSkrRusnB7JKMOesW
	 AIJyOufSOTEZQ==
Message-ID: <aa938a429707345bb706d2a8918c657dc4e0d6f3.camel@kernel.org>
Subject: Re: [PATCH v2 2/5] btrfs: split btrfs_insert_delayed_dir_index()
 into prealloc and commit phases
From: Jeff Layton <jlayton@kernel.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>, Chris
 Mason	 <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@fb.com
Date: Wed, 05 Aug 2026 18:43:21 -0400
In-Reply-To: <2527e1c9-a8cd-40bf-96a1-95f74359d21e@gmx.com>
References: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
	 <20260804-btrfs-enomem-v2-2-4d923170e8c1@kernel.org>
	 <8b16c994-b322-42c9-b134-47dca5f2682e@suse.com>
	 <8ebbafc475baff8aedf5e2b2718db867063fab07.camel@kernel.org>
	 <2527e1c9-a8cd-40bf-96a1-95f74359d21e@gmx.com>
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

On Thu, 2026-08-06 at 08:04 +0930, Qu Wenruo wrote:
>=20
> =E5=9C=A8 2026/8/5 21:24, Jeff Layton =E5=86=99=E9=81=93:
> > On Wed, 2026-08-05 at 08:44 +0930, 'Qu Wenruo' via Kernel Team wrote:
> > >=20
> > > =E5=9C=A8 2026/8/5 01:14, Jeff Layton =E5=86=99=E9=81=93:
> > > > Split btrfs_insert_delayed_dir_index() into three functions using a=
 new
> > > > btrfs_dir_index_prealloc struct to bundle the pre-allocated resourc=
es:
> > > >=20
> > > > - btrfs_prealloc_delayed_dir_index(): performs the two GFP_NOFS
> > > >     allocations (delayed node + delayed item) that can fail with -E=
NOMEM.
> > > > - btrfs_insert_delayed_dir_index_prealloc(): populates the item dat=
a,
> > > >     inserts into the rb-tree, and reserves metadata space. Cannot f=
ail
> > > >     with -ENOMEM since all allocations were done in the prealloc st=
ep.
> > > > - btrfs_free_delayed_dir_index_prealloc(): frees pre-allocated
> > > >     resources when the caller's btree insertion fails.
> > > >=20
> > > > The original btrfs_insert_delayed_dir_index() is refactored into a =
thin
> > > > wrapper that calls the prealloc and commit functions.
> > > >=20
> > > > This split allows callers to move the fallible memory allocations b=
efore
> > > > the point of no return (the DIR_ITEM btree insertion), so that -ENO=
MEM
> > > > can be returned cleanly without aborting the transaction.
> > > >=20
> > > > Assisted-by: LLM
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >    fs/btrfs/delayed-inode.c | 111 +++++++++++++++++++++++++++++++++=
++++----------
> > > >    fs/btrfs/delayed-inode.h |  17 ++++++++
> > > >    2 files changed, 104 insertions(+), 24 deletions(-)
> > > >=20
> > > > diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> > > > index db2ffab0941a..95d2dca80444 100644
> > > > --- a/fs/btrfs/delayed-inode.c
> > > > +++ b/fs/btrfs/delayed-inode.c
> > > > @@ -6,6 +6,7 @@
> > > >   =20
> > > >    #include <linux/slab.h>
> > > >    #include <linux/iversion.h>
> > > > +#include <linux/error-injection.h>
> > > >    #include "ctree.h"
> > > >    #include "fs.h"
> > > >    #include "messages.h"
> > > > @@ -1469,35 +1470,74 @@ static void btrfs_release_dir_index_item_sp=
ace(struct btrfs_trans_handle *trans)
> > > >    	trans->bytes_reserved -=3D bytes;
> > > >    }
> > > >   =20
> > > > -/* Will return 0, -ENOMEM or -EEXIST (index number collision, unex=
pected). */
> > > > -int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *tran=
s,
> > > > -				   const char *name, int name_len,
> > > > -				   struct btrfs_inode *dir,
> > > > -				   const struct btrfs_disk_key *disk_key, u8 flags,
> > > > -				   u64 index)
> > > > +/*
> > > > + * Pre-allocate a delayed node and delayed item for a dir index in=
sertion.
> > > > + * Call this before modifying the btree so that ENOMEM can be retu=
rned
> > > > + * before any on-disk state has changed.
> > > > + *
> > > > + * Returns 0 on success, -ENOMEM on allocation failure.
> > > > + */
> > > > +int btrfs_prealloc_delayed_dir_index(struct btrfs_inode *dir,
> > > > +				     const char *name, int name_len,
> > > > +				     struct btrfs_dir_index_prealloc *prealloc)
> > >=20
> > > We can directly return a btrfs_dir_index_prealloc pointer, which redu=
ce
> > > the parameter list.
> > >=20
> >=20
> > ...but then we'd have to allocate it separately. It's currently
> > allocated on the stack by the caller. I think we ought to keep it this
> > way, but I'm willing to be convinced otherwise.
>=20
> In the end, there are only two callsites using on-stack memory for=20
> prealloc structure, one in btrfs_rename() and one in=20
> btrfs_insert_dir_item().
>=20
> So it would be not that hard to convert to heap memory based solution.
>=20
>=20
> One thing I found a little weird is related to the lifespan management=
=20
> of btrfs_dir_index_prealloc.
>=20
> We have several call sites doing things like:
>=20
> 	struct btrfs_dir_index_prealloc prealloc =3D { };
>=20
> 	ret =3D btrfs_prealloc_delayed_dir_index();
>=20
> 	ret =3D btrfs_add_link(..., prealloc.item ? prealloc : NULL);
> 	prealloc.item =3D NULL;
>=20
> Which looks a little weird to me, as we're using item to indicate if the=
=20
> structure is properly allocated, not the structure itself.
>=20
> If we go regular heap memory allocation, it would be more=20
> straightforward and more common:
>=20
> 	struct btrfs_dir_index_prealloc *prealloc =3D NULL;
>=20
> 	prealloc =3D btrfs_prealloc_delayed_dir_index();
>=20
> 	ret =3D btrfs_add_link(..., prealloc);
> 	prealloc =3D NULL;
>=20
> Feel free to ignore this one, it's mostly preference.
>=20

It's a good point. It is more natural to be able to just look and say
"NULL pointer means no prealloc".

OTOH, the entire reason we're doing this is to deal with low-memory
situations. Do we want to add another heap allocation into this
codepath?

Either way, I'll think about it.

Thanks again for the review!
--
Jeff Layton <jlayton@kernel.org>
