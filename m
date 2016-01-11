Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59245 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795AbcAKWaT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 17:30:19 -0500
Date: Mon, 11 Jan 2016 22:30:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
Message-ID: <20160111223017.GE422@carfax.org.uk>
References: <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk>
 <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk>
 <CAJCQCtSkoAxbc3eXQYPQuYuM12ObBtutZMaavq9iWnQit0zwYw@mail.gmail.com>
 <20160111090318.GG6060@carfax.org.uk>
 <CAJCQCtSbiowwna1JmVdJ=+L-jrXawty9PA9oMMAMW-r8t-kKag@mail.gmail.com>
 <20160111221056.GD422@carfax.org.uk>
 <CAJCQCtSR1fCPH_TgVYYgjmRC-phh5Zdku4f0iHoFg7CjZAQ7hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pql/uPZNXIm1JCle"
In-Reply-To: <CAJCQCtSR1fCPH_TgVYYgjmRC-phh5Zdku4f0iHoFg7CjZAQ7hw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Pql/uPZNXIm1JCle
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 11, 2016 at 03:20:36PM -0700, Chris Murphy wrote:
> On Mon, Jan 11, 2016 at 3:10 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Mon, Jan 11, 2016 at 02:31:41PM -0700, Chris Murphy wrote:
> >> On Mon, Jan 11, 2016 at 2:03 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >> > On Sun, Jan 10, 2016 at 05:13:28PM -0700, Chris Murphy wrote:
> >> >> On Sat, Jan 9, 2016 at 2:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >> >> > On Sat, Jan 09, 2016 at 09:59:29PM +0100, cheater00 . wrote:
> >> >> >> OK. How do we track down that bug and get it fixed?
> >> >> >
> >> >> >    I have no idea. I'm not a btrfs dev, I'm afraid.
> >> >> >
> >> >> >    It's been around for a number of years. None of the devs has, I
> >> >> > think, had the time to look at it. When Josef was still (publicly)
> >> >> > active, he had it second on his list of bugs to look at for many
> >> >> > months -- but it always got trumped by some new bug that could cause
> >> >> > data loss.
> >> >>
> >> >>
> >> >> Interesting. I did not know of this bug. It's pretty rare.
> >> >
> >> >    Not really. It shows up maybe on average once a week on IRC. It
> >> > gets reported much less on the mailing list.
> >>
> >> Is there a pattern? Does it only happen at a 2TiB threshold?
> >
> >    No, and no.
> >
> >    There is, as far as I can tell from some years of seeing reports of
> > this bug, no correlation with RAID level, hardware, OS, kernel
> > version, FS size, usage of the FS at failure, or allocation level of
> > either data or metadata at failure.
> >
> >    I haven't tried correlating with the phase of the moon or the
> > losses on Lloyds Register yet.
> 
> Huh. So it's goofy cakes.
> 
> This is specifically where btrfs_free_extent produces errno -28 no
> space left, and then the fs goes read-only?

   The symptoms I'm using for a diagnosis of this bug are that the FS
runs out of (usually data) space when there's still unallocated space
remaining that it could use for another block group.

   Forced RO isn't usually a symptom, although the FS can get into a
state where you can't modify it (as distinct from being explicitly
read-only).

   Block-group level operations, like balance, device delete, device
add sometimes seem to have some kind of (usually small) effect on the
point at which the error occurs. If you hit the problem and run a
balance, you might end up making things worse by a couple of
gigabytes, or making things better by the same amount, or having no
effect at all.

   Hugo.

-- 
Hugo Mills             | "What are we going to do tonight?"
hugo@... carfax.org.uk | "The same thing we do every night, Pinky. Try to
http://carfax.org.uk/  | take over the world!"
PGP: E2AB1DE4          |

--Pql/uPZNXIm1JCle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWlCz5AAoJEFheFHXiqx3kZXUQAJaD0mFAfFfmjOs1yt7ni/Vb
Wg35Yz3UYM2RkYYhjoaqmGc/Wk+lJZtW4VLcez4LYX2slUgce/YIYaCOPdABU1r1
Foetx2flV80FksdyBRth1MzwMgbHfFmEcQSXOy8uaPKDNsGDgIeY94Ob7ILQ2rQl
EJb5T9Eyb2EwOCs+qoZqrThl3B1REWB/lAX6m+pwZ06TjKzMX2NW4PXbsT9CkCGw
dIuwlI+yqP+jeRMKE8r0tFi3fNcQVBQbNKNP+nhwWrpigQd/HYhz099mpv6CnZ3D
YIS6tWbrcfm4ydBeK+BGYqozC8ti2gTY+s24AZfYCiwMgA1h/ahg3RF7zlaV+Gv2
xaYwHAFQKghGDLbETV0YUujKQdje5R2K1k7b0r18dU9k0rwYeRjRCik24DSnVNwr
DOrs9QZTZlu2uDVAVhUv+udg6VsxoYq80MY7frWz1AFNwvQc9LGoSAOOJgp45esn
kehlP0NcMweGTHK5LQDh635ztn79VndMgm8NXtSQ04Hr79vXsxaG2m7QE/1RVUep
G3+VFNAnbYeH0ggBGedp/+PVvn/kQ6tnuY1lg0pftIwM0RbVA1+lIV/eXMwzwPMH
mC7WTjX8HYJZZiMR/NtC9d6ajl4obw63wrfa5y8jDV5gi3bNKG48/i26g2RRe3zp
hbF4Sf9gW9/R0vSrtv4E
=Xw/4
-----END PGP SIGNATURE-----

--Pql/uPZNXIm1JCle--
