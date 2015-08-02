Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49481 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbbHBTGr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Aug 2015 15:06:47 -0400
Date: Sun, 2 Aug 2015 19:06:45 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Data single *and* raid?
Message-ID: <20150802190645.GD14352@carfax.org.uk>
References: <55BD277F.2040201@friedels.name>
 <20150801203258.GA14352@carfax.org.uk>
 <CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
 <pan$7fbcf$6323c57d$e51a436f$80a59676@cox.net>
 <CAJCQCtQOa8_fcX_O9zop=mT0ABp=3XtJZ5N2SE2nrX7-0TvSpw@mail.gmail.com>
 <20150801223413.GC14352@carfax.org.uk>
 <pan$b8fa$cc3e43af$7e32a698$96ba80bb@cox.net>
 <CAJCQCtQqkUY=oRKFAx-0UaT-87STiDgD-vQ+gknkE5V2SzPb4A@mail.gmail.com>
 <pan$2c3c8$edc30c0$3c253f51$8a661bd4@cox.net>
 <CAJCQCtSrt5OcUtURko3PjOtvCZBJ6quTn=AdT5P=+Ek3HuNuCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lc9FT7cWel8HagAv"
In-Reply-To: <CAJCQCtSrt5OcUtURko3PjOtvCZBJ6quTn=AdT5P=+Ek3HuNuCQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lc9FT7cWel8HagAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 02, 2015 at 12:31:13PM -0600, Chris Murphy wrote:
> On Sat, Aug 1, 2015 at 9:46 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> > If it was setup with something earlier (not sure about 4.1.0, was it
> > affected?
> 
> No.
> 
> > but 4.0.x and earlier should be fine for setup), however, once
> > on a new kernel the usual ENOSPC workarounds can be given a try.  That
> > would include a first balance start -dusage=0 -musage=0, and if that
> > didn't free up at least a gig on a second device,
> 
> If I'm following this correctly, the reproduce steps would be to
> create a single device Btrfs that's ~94% full, add two devices, then
> convert to raid5. I think what's going on here is empty single profile
> data chunks aren't being deallocated, and it's effectively a 2 device
> raid5.

   This isn't supported by the btrfs fi df output: all of the
allocated space is used.

   Hugo.

> So actually, you're right, either -dusage=0 might fix it, or better,
> newer kernel that automatically deallocated empty/converted single
> profile data chunks. But right now it will take another balance in the
> end because it looks like this is effectively a 2 device raid5, with
> the 3rd drive full of single only chunks (which might be empty?).

-- 
Hugo Mills             | I'll take your bet, but make it ten thousand francs.
hugo@... carfax.org.uk | I'm only a _poor_ corrupt official.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                              Capt. Renaud, Casablanca

--lc9FT7cWel8HagAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVvmpEAAoJEFheFHXiqx3k9B4P/jbDMQf9SUX4kAVERRB20mpA
MiE8d/CelzyNqPeaZS/rI/m8rbLm6b8tJZJVoqmij4RNYGxiRN6RMj2PM5KExvz9
KolY2Bq6lzd6oNHqxezJ/f5jTh9QTT8AVeuv2v3aCUGpzzGk1lRxbDgzMITw+h9G
TIoTwxd8tLEoHEpY9aXGeWmpD2F+PMzo6M1YveQMGN9DSPp2QOFyGpbl40+pkO21
5lZwjILqMiI3rNDZBNM2VyjWdPBiaXkmyFop/UqhDcZvwMU4Y10DdYg8Ki0cs5il
6Ox/nvvyhOk8Cmkni2drFO+DSOma/l3/dmiCtvdq5u9xwA+nMrWvj3UMAoBHNMDQ
HIDimAUN6wuOKaZCjwwDASVdQkdzQKO7GNkkg4JyF1TGrKRDE7SmKpAVUHY7zSIG
VryrokT4s/uGJWYAosWp4+K09DcaAVIWrsQdVwG+acHrBrM66QtDcqVWHq91VIIp
5moH9ZWI0QjQwAq6zewdflWKIVMmAYIhnPTOYKmromqI6v1mkyYKcSZTKIMOmwzt
PTTZUEcZVjZAxFG0YgNYQPW0IA2Hg6xO/ukkavxi5p12CBUl+YiPZw1O7H9ZDIIh
nOklYtiJQtA1Qz62tZCgI9/Ahd21eHArGg4teIJJbK8DRWchAy9t4nuzJsYE5yWJ
nQkhPELzLJN/7/rs9jvH
=8RmN
-----END PGP SIGNATURE-----

--lc9FT7cWel8HagAv--
