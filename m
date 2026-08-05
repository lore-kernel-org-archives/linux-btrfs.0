Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3AD473C93;
	Wed,  5 Aug 2026 12:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785931785; cv=none; b=l195svv2qPEU9HdpCXizPRl5zYIFq1REO+q4OGDW4UoRbWPRmhkLilpyIpefMW/KSNGmdyALWvZJZ+zo9B7o7K80DZpGiwZUAEKOaa562CqbqnhZL1vzlRBRAHv7IbnMXP4X9tXsGaPJcTTLDfJZXZ45RikRGGT8dlpUySuXoWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785931785; c=relaxed/simple;
	bh=Kjm/KGIUuW5Xpoo9pUroFqTiznBA3R9Ua0Qb2N7JQzQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CPDYk7nog6kSp9FRJUlbzInL0VVXgos4/5GZqIN7uVPvGqZIoIj6brQ58Zffj4zX8eDpzNkXFxB2lt8vVpKTqLrVoZ/JqI8o7hT1fu8Cw4xQM7YIjom1vlERe7uX1dygJvRRSiTGUooqZIgxXOJdhXuT6ByAHFYFdh7c7F0BB1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4F/uN3r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4F/uN3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349481F00A3A;
	Wed,  5 Aug 2026 12:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785931770;
	bh=/O9jtW1Y7DcrHeXrlLsnZ+3XkbzoopO1HR0NaafSByE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=K4F/uN3rlLbMRctZjo/UHdVXYa7IuC6jZRFY1ouRw0TNa3skgiQdPLAh5Rlfa456G
	 yI/AdjQpgLNP258TPpSGVorc4/qc5Pug2RPK98dpnP8ujf9DP40DvRXWWoLSmxzg7K
	 X0i18LI1SIwyUSjXk97+CNYWsjjMzOfwsQ4vATcTRgmLBNJaqBf0FpIKe1F+e9wlpK
	 903uG71LKftYpWkLtWH9N3oiAacHkT8vrKCCn9o4I4XSOdlOoDIHhyGnYWPVeeab8i
	 t6ADkcJqcY6toF28E+JAlIFTNtLsdRswCQkPodKEc90AIevT1rpfsmA5wEb85s6mk9
	 RAd7/lMPDT24Q==
Message-ID: <4deb757dbbd22f1ff5e060b1e2cd6e7c28ef5691.camel@kernel.org>
Subject: Re: [PATCH v2 3/5] btrfs: pre-allocate delayed dir index before
 btree modification
From: Jeff Layton <jlayton@kernel.org>
To: Qu Wenruo <wqu@suse.com>, Chris Mason <clm@fb.com>, David Sterba
	 <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@fb.com
Date: Wed, 05 Aug 2026 08:09:28 -0400
In-Reply-To: <dc3389ba-f29f-4897-9304-c9689eef4f37@suse.com>
References: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
	 <20260804-btrfs-enomem-v2-3-4d923170e8c1@kernel.org>
	 <dc3389ba-f29f-4897-9304-c9689eef4f37@suse.com>
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

On Wed, 2026-08-05 at 09:21 +0930, Qu Wenruo wrote:
>=20
> =E5=9C=A8 2026/8/5 01:14, Jeff Layton =E5=86=99=E9=81=93:
> > Move the delayed dir index allocation in btrfs_insert_dir_item() before
> > the insert_with_overflow() call that modifies the btree. Previously, th=
e
> > allocations happened after the DIR_ITEM was already inserted, meaning a=
n
> > ENOMEM failure left the btree in a partially-modified state that could
> > only be resolved by aborting the transaction.
> >=20
> > Add an optional caller-provided btrfs_dir_index_prealloc parameter to
> > btrfs_insert_dir_item(). When non-NULL, ownership of the prealloc
> > transfers to btrfs_insert_dir_item(). When NULL, it allocates internall=
y.
> > All existing callers pass NULL to preserve the current behavior.
> >=20
> > Remove the btrfs_insert_delayed_dir_index() wrapper, as there are no
> > more callers.
> >=20
> > Assisted-by: LLM
> > Suggested-by: Qu Wenruo <wqu@suse.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/btrfs/delayed-inode.c | 21 ---------------------
> >   fs/btrfs/delayed-inode.h |  5 -----
> >   fs/btrfs/dir-item.c      | 30 ++++++++++++++++++++++++------
> >   fs/btrfs/dir-item.h      |  5 +++--
> >   fs/btrfs/inode.c         |  2 +-
> >   fs/btrfs/transaction.c   |  2 +-
> >   6 files changed, 29 insertions(+), 36 deletions(-)
> >=20
> > diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> > index 95d2dca80444..d9de7f269874 100644
> > --- a/fs/btrfs/delayed-inode.c
> > +++ b/fs/btrfs/delayed-inode.c
> > @@ -1608,27 +1608,6 @@ int btrfs_insert_delayed_dir_index_prealloc(stru=
ct btrfs_trans_handle *trans,
> >   	return ret;
> >   }
> >  =20
> > -/* Will return 0, -ENOMEM or -EEXIST (index number collision, unexpect=
ed). */
> > -int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
> > -				   const char *name, int name_len,
> > -				   struct btrfs_inode *dir,
> > -				   const struct btrfs_disk_key *disk_key, u8 flags,
> > -				   u64 index)
> > -{
> > -	struct btrfs_dir_index_prealloc prealloc;
> > -	int ret;
> > -
> > -	ret =3D btrfs_prealloc_delayed_dir_index(dir, name, name_len, &preall=
oc);
> > -	if (ret)
> > -		return ret;
> > -
> > -	memcpy(prealloc.item->data + sizeof(struct btrfs_dir_item), name,
> > -	       name_len);
> > -
> > -	return btrfs_insert_delayed_dir_index_prealloc(trans, dir, &prealloc,
> > -						       disk_key, flags, index);
> > -}
> > -
> >   static bool btrfs_delete_delayed_insertion_item(struct btrfs_delayed_=
node *node,
> >   						u64 index)
> >   {
> > diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
> > index e310a257c9a6..878d70aee2f9 100644
> > --- a/fs/btrfs/delayed-inode.h
> > +++ b/fs/btrfs/delayed-inode.h
> > @@ -115,11 +115,6 @@ struct btrfs_delayed_item {
> >   };
> >  =20
> >   void btrfs_init_delayed_root(struct btrfs_delayed_root *delayed_root)=
;
> > -int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
> > -				   const char *name, int name_len,
> > -				   struct btrfs_inode *dir,
> > -				   const struct btrfs_disk_key *disk_key, u8 flags,
> > -				   u64 index);
> >  =20
> >   struct btrfs_dir_index_prealloc {
> >   	struct btrfs_delayed_node *node;
> > diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> > index 84f1c64423d3..1b956df2c571 100644
> > --- a/fs/btrfs/dir-item.c
> > +++ b/fs/btrfs/dir-item.c
> > @@ -106,8 +106,11 @@ int btrfs_insert_xattr_item(struct btrfs_trans_han=
dle *trans,
> >    * Will return 0 or -ENOMEM
> >    */
> >   int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
> > -			  const struct fscrypt_str *name, struct btrfs_inode *dir,
> > -			  const struct btrfs_key *location, u8 type, u64 index)
> > +			  const struct fscrypt_str *name,
> > +			  struct btrfs_inode *dir,
> > +			  const struct btrfs_key *location, u8 type,
> > +			  u64 index,
> > +			  struct btrfs_dir_index_prealloc *prealloc)
> >   {
> >   	int ret =3D 0;
> >   	int ret2 =3D 0;
> > @@ -119,6 +122,8 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle=
 *trans,
> >   	struct btrfs_key key;
> >   	struct btrfs_disk_key disk_key;
> >   	u32 data_size;
> > +	const bool need_delayed_index =3D (root !=3D root->fs_info->tree_root=
);
> > +	struct btrfs_dir_index_prealloc local_prealloc;
> >  =20
> >   	key.objectid =3D btrfs_ino(dir);
> >   	key.type =3D BTRFS_DIR_ITEM_KEY;
> > @@ -130,6 +135,18 @@ int btrfs_insert_dir_item(struct btrfs_trans_handl=
e *trans,
> >  =20
> >   	btrfs_cpu_key_to_disk(&disk_key, location);
> >  =20
> > +	/* Pre-allocate the delayed dir index before modifying the btree. */
> > +	if (need_delayed_index && !prealloc) {
>=20
> This is exposed by sashiko.
>=20
> If we have @prealloc passed in, and before we even hit=20
> insert_with_overflow(), the previous btrfs_alloc_path() failed, we=20
> return -ENOMEM directly, leaking the @prealloc.
>=20
>=20

Good catch. It looks like sashiko also flagged some other similar
issues nearby too that we might as well fix while we're in here. I'll
plan to spin up a v3 and resend the series. Thanks very much for the
review so far!

--=20
Jeff Layton <jlayton@kernel.org>
