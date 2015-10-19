Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33577 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbJSPcD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 11:32:03 -0400
Date: Mon, 19 Oct 2015 11:31:21 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: extend balance filter limit to take minimum
 and maximum
Message-ID: <20151019153120.GE4400@hungrycats.org>
References: <cover.1445013000.git.dsterba@suse.com>
 <35832c0abf72cfd1e118d484f6a9ebdd689f8757.1445013000.git.dsterba@suse.com>
 <20151016230837.GD4400@hungrycats.org>
 <20151019091416.GS27761@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ey/N+yb7u/X9mFhi"
In-Reply-To: <20151019091416.GS27761@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ey/N+yb7u/X9mFhi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2015 at 11:14:16AM +0200, David Sterba wrote:
> On Fri, Oct 16, 2015 at 07:08:37PM -0400, Zygo Blaxell wrote:
> > On Fri, Oct 16, 2015 at 06:50:08PM +0200, David Sterba wrote:
> > > The 'limit' filter is underdesigned, it should have been a range for
> > > [min,max], with some relaxed semantics when one of the bounds is
> > > missing. Besides that, using a full u64 for a single value is a waste=
 of
> > > bytes.
> >=20
> > What is min for?
> >=20
> > If we have more than 'max' matching chunks, we'd process 'max' and stop.
>=20
> Right.
>=20
> > If we have fewer than 'min' chunks, we'd process what we have and run o=
ut.
>=20
> If we have fewer than min, we'll do nothing.

Aha.  My mental model of balance was missing the step where chunks are
enumerated and filtered before any real work starts.

> > If we have more than 'min' chunks but fewer than 'max' chunks, why would
> > we stop before we reach 'max' chunks?
>=20
> I must be missing something here. If there are less than 'max' chunks
> (with all filters applied), how are we supposed to reach 'max'?
>=20
> The 'limit' filter is applied after all the other filters. It can be
> used standalone, or with eg. usage. The usecase where I find it useful:
>=20
> * we want to make metadata chunks more compact
> * let's set usage=3D30
> * avoid unnecessary work (which is a bigger performance hit in case
>   of metadata chunks), ie. if there's a single chunk with usage < 30%,
>   let's skip it
>=20
> The command:
>=20
>  $ btrfs balance start -musage=3D30,limit=3D2.. /path
>=20
> So in case there's only one such chunk, balance would just move it
> without any gain.=20

=2E..and if there's two chunks with <50% space used, then we can guarantee
that the data from one fits in the unused space of the other.  With a
bit of math we can figure out what limit-min has to be for any particular
value of usage to guarantee one chunk is always deallocated.  That makes
sense.

> Avoiding the unnecessary work here is IMO a win,
> though it might seem limited. But I'm going to utilize this in the
> btrfsmaintenance package that among others does periodic balancing
> on the background, I believe the effects will be noticeable.

=2E..and this use case did not occur to me because I try to make
sure I never do anything remotely similar to this, even accidentally.

I've learned the hard way not to balance metadata except when reshaping
a filesystem array.  Apart from being egregiously slow and hard to
interrupt, balancing metadata deallocates space that was previously
allocated to metadata.  If you keep doing it on a nearly-full filesystem,
the risk that you'll run out of metadata space in the future increases
to certainty.

The penalty for running out of metadata space is currently much, much
worse than the cost of unused metadata space could ever be.  :-/

"-dusage=3D49,limit=3D2.." is something I might use, though, especially for
small or mostly static filesystems where there might be a shortage of
work for balance (a large filesystem with a moderate rate of modification
doesn't need a min-limit).

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ey/N+yb7u/X9mFhi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlYlDMgACgkQgfmLGlazG5xsGwCeJ5NCoYKEyCzAtQKwKlRr5RXj
SbAAoNcZaNbOlSdXOwXgMrXTx+LQ+Fpy
=d1Ji
-----END PGP SIGNATURE-----

--ey/N+yb7u/X9mFhi--
