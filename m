Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39576 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbcK1SHf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 13:07:35 -0500
Date: Mon, 28 Nov 2016 13:07:33 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix hole read corruption for compressed inline
 extents
Message-ID: <20161128180732.GN8685@hungrycats.org>
References: <1480309392-4786-1-git-send-email-ce3g8jdj@umail.furryterror.org>
 <20161128172710.202587ce@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6Mt39TZj+HFMr11E"
In-Reply-To: <20161128172710.202587ce@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6Mt39TZj+HFMr11E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

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

The previous commit message discussed the related hole-creation bug,
including a reproducer; however, this patch does not fix the hole-creation
bug and was never intended to.  Despite my follow-up clarification,
reviewers got distracted by the hole-creation bug discussion and didn't
recover, so the patch didn't go anywhere.

This patch only fixes _reading_ the holes after they are created, and
the new commit message and subject line state that much more clearly.

The patch didn't change, so I didn't add 'v2'.  There's no 'v1' with
the same title, so I thought a 'v2' tag would be more confusing than
just starting over.

The hole-creation bug is a very old, low-urgency issue.  btrfs filesystems
in the field have the buggy holes already, and have been creating new
ones from 2009(*) to the present.  I had to ask a few people before I found
one who know whether it was even a bug, or intentional behavior from
the beginning.


(*) 2009 is the oldest commit date I can find that introduces a change
which would only be necessary in the presence of the hole-creation bug.
I have not been able to test kernels before 2012 because they crash
while running my reproducer.

> --=20
> With respect,
> Roman
>=20

--6Mt39TZj+HFMr11E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg8cmQACgkQgfmLGlazG5wa7ACghdFL811K2IUzhEZzFely7PHs
1fsAnj5VrNc/6lezDyT/f/GK9nPm7VOS
=5Bsi
-----END PGP SIGNATURE-----

--6Mt39TZj+HFMr11E--
