Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34762 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936454AbcISC6B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Sep 2016 22:58:01 -0400
Date: Sun, 18 Sep 2016 22:57:57 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        David Sterba <dsterba@suse.cz>, Waxhead <waxhead@online.no>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Is stability a joke? (wiki updated)
Message-ID: <20160919025756.GD21290@hungrycats.org>
References: <20160912162747.GF16983@twin.jikos.cz>
 <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
 <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
 <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
 <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com>
 <CAJCQCtR_hMPj8Nrf=U1L=WvDWq48Ns1K25p4JtKEJnVwb1231Q@mail.gmail.com>
 <20160915201657.GK7138@carfax.org.uk>
 <CAJCQCtSKU78Tvak_q=3xnh-Hm6=zXs6ffd1o=uYMpBmp6CxWtA@mail.gmail.com>
 <954df3cd-0554-b86f-9dae-47517f3fbad7@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
In-Reply-To: <954df3cd-0554-b86f-9dae-47517f3fbad7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 16, 2016 at 08:00:44AM -0400, Austin S. Hemmelgarn wrote:
> To be entirely honest, both zero-log and super-recover could probably be
> pretty easily integrated into btrfs check such that it detects when they
> need to be run and does so.  zero-log has a very well defined situation in
> which it's absolutely needed (log tree corrupted such that it can't be
> replayed), which is pretty easy to detect (the kernel obviously does so,
> albeit by crashing). =20

Check already includes zero-log.  It loses a little data that way, but
that is probably better than the alternative (try to teach btrfs check
how to replay the log tree and keep up with kernel changes).

There have been at least two log-tree bugs (or, more accurately,
bugs triggered while processing the log tree during mount) in the 3.x
and 4.x kernels.  The most recent I've encountered was in one of the
4.7-rc kernels.  zero-log is certainly not obsolete.

For a filesystem where availablity is more important than integrity
(e.g. root filesystems) it's really handy to have zero-log as a separate
tool without the huge overhead (and regression risk) of check.


--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlffVDQACgkQgfmLGlazG5xLuQCgv1TTjzDt1Uvv1l/6fLywxeV8
FXgAn2I0d3FZ4k6yarz8bX4Nydy0OLmw
=UYVu
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
