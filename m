Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33221 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753533AbbJOCtd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 22:49:33 -0400
Date: Wed, 14 Oct 2015 22:47:49 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: State of Dedup / Defrag
Message-ID: <20151015024749.GB4400@hungrycats.org>
References: <CAGfcS_kADCxYy2yvTsHLdTTk=OEpx8FyspRfhvjLhbCQwdspKw@mail.gmail.com>
 <20151014050916.GA4400@hungrycats.org>
 <CAGfcS_nBFR7-aBVcTgU=htQBDWjzQnB_ePpdWKESVx+x4nROpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
In-Reply-To: <CAGfcS_nBFR7-aBVcTgU=htQBDWjzQnB_ePpdWKESVx+x4nROpw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2015 at 08:29:20AM -0400, Rich Freeman wrote:
> On Wed, Oct 14, 2015 at 1:09 AM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> >
> > I wouldn't try to use dedup on a kernel older than v4.1 because of these
> > fixes in 4.1 and later:
>=20
> I would assume that these would be ported to the other longterm
> kernels like 3.18 at some point?

I wouldn't assume anything.  Backports seem to be kind of random.  ;)

I think most (all?) of the relevant patches do apply to v3.18, but I
haven't tested this kernel very much since v4.0 became usable.

> > Do dedup a photo or video file collection.  Don't dedup
> > a live database server on a filesystem with compression enabled...yet.
>=20
> LIkewise.  Typically I just dedup the entire filesystem, so it sounds
> like we're not quite there yet.  Would it make sense to put this on
> the wiki in the gotchas section?

Sounds good.

> > Using dedup and defrag at the same time is still a bad idea.  The featu=
res
> > work against each other
>=20
> You mentioned quite a bit about autodefrag.  I was thinking more in
> terms of using explicit defrag, as was done by dedup in the past.  It
> looks like duperemove doesn't actually do this, perhaps because it is
> also considered unsafe these days.

I wouldn't describe dedup+defrag as unsafe.  More like insane.  You won't
lose any data, but running both will waste a lot of time and power.
Either one is OK without the other, or applied to non-overlapping sets
of files, but they are operations with opposite results.

Explicit defrag always undoes dedup, so you never want to defrag a file
after dedup has removed duplicate extents from it.  The btrfs command-line
tool doesn't check for shared extents in defrag, and neither does the
kernel ioctl.

Defrag before dedup is a more complex situation that depends on the dedup
strategy of whichever dedup tool you are using.  A file-based dedup tool
doesn't have to care about extent boundaries, so you can just run defrag
and then dedup--in that order.

An extent-based dedup tool will become less efficient after defrag and
some capabilities will be lost, e.g.  it will not be able to dedup
data between VM image files or other files on the host filesystem.
Extents with identical content but different boundaries cannot be deduped.
There are fewer opportunities to find duplicate extents because defrag
combines smaller extents into bigger ones.

A block-based dedup tool explicitly arranges the data into extents
by content, so extents become entirely duplicate or entirely unique.
This is different from what defrag does.  If both are run on the same
data they will disagree on physical data layout and constantly undo
each other's work.

When data is defragged, it appears in find-new output as "new" data
(the same as if the data had been written to a file the usual way).
An incremental dedup tool that integrates defrag and find-new at the
same time has to carefully prevent itself from consuming its own output
in an endless feedback loop.

> Thanks, I was just trying to get a sense for where this was at.  It
> sounds like we're getting to the point where it could be used in
> general, but for now it is probably best to run it manually on stuff
> that isn't too busy.

IMHO the kernel part of dedup as of v4.1 is in a better state than some
other features, e.g. balance or resize.  I can run dedup continuously
for months without issues, but I plan for lockups and reboots every day
when doing balances or resizes.  :-/

> --
> Rich
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlYfE9UACgkQgfmLGlazG5zVVgCg6sEIoYxPritYVZm3izVmOY1H
cWMAoM5YJtlRqqPsybF2L7Rx+6Qedaxa
=ynWO
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
