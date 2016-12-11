Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40934 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbcLKFQm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 00:16:42 -0500
Date: Sun, 11 Dec 2016 00:16:41 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Roman Mamedov <rm@romanrm.net>, Filipe Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix hole read corruption for compressed inline
 extents
Message-ID: <20161211051641.GA21290@hungrycats.org>
References: <1480309392-4786-1-git-send-email-ce3g8jdj@umail.furryterror.org>
 <20161128172710.202587ce@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fH+ug0VWbLbTAXDy"
In-Reply-To: <20161128172710.202587ce@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fH+ug0VWbLbTAXDy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Ping?

I know at least two people have read this patch, but it hasn't appeared in
the usual integration branches yet, and I've seen no actionable suggestion
to improve it.  I've provided two non-overlapping rationales for it.
Is there something else you are looking for?

This patch is a fix for a simple data corruption bug.  It (or some
equivalent fix for the same bug) should be on its way to all stable
kernels starting from 2.6.32.

Thanks

On Mon, Nov 28, 2016 at 05:27:10PM +0500, Roman Mamedov wrote:
> On Mon, 28 Nov 2016 00:03:12 -0500
> Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:
>=20
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 8e3a5a2..b1314d6 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -6803,6 +6803,12 @@ static noinline int uncompress_inline(struct btr=
fs_path *path,
> >  	max_size =3D min_t(unsigned long, PAGE_SIZE, max_size);
> >  	ret =3D btrfs_decompress(compress_type, tmp, page,
> >  			       extent_offset, inline_size, max_size);
> > +	WARN_ON(max_size > PAGE_SIZE);
> > +	if (max_size < PAGE_SIZE) {
> > +		char *map =3D kmap(page);
> > +		memset(map + max_size, 0, PAGE_SIZE - max_size);
> > +		kunmap(page);
> > +	}
> >  	kfree(tmp);
> >  	return ret;
> >  }
>=20
> Wasn't this already posted as:
>=20
> btrfs: fix silent data corruption while reading compressed inline extents
> https://patchwork.kernel.org/patch/9371971/
>=20
> but you don't indicate that's a V2 or something, and in fact the patch se=
ems
> exactly the same, just the subject and commit message are entirely differ=
ent.
> Quite confusing.
>=20
> --=20
> With respect,
> Roman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--fH+ug0VWbLbTAXDy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhM4TkACgkQgfmLGlazG5xp8gCfayiY6xy+tHvNCBDk1LpH0dam
sZIAn0VvQP/lNHW4bXPAIg0BJPiRZdyo
=kc1n
-----END PGP SIGNATURE-----

--fH+ug0VWbLbTAXDy--
