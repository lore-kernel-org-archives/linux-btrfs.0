Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55125 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaCVXiY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 19:38:24 -0400
Date: Sat, 22 Mar 2014 23:38:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jon Nelson <jnelson@jamponi.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: fresh btrfs filesystem, out of disk space, hundreds of gigs free
Message-ID: <20140322233821.GB25400@carfax.org.uk>
References: <CAKuK5J05tCf55T1X_ENNdP4oXCiODXSR48coQ0rgkihcb9EUSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
In-Reply-To: <CAKuK5J05tCf55T1X_ENNdP4oXCiODXSR48coQ0rgkihcb9EUSw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 22, 2014 at 06:21:02PM -0500, Jon Nelson wrote:
> Duncan <1i5t5.duncan <at> cox.net> writes:
> > Jon Nelson posted on Fri, 21 Mar 2014 19:00:51 -0500 as excerpted:
[snip]
> > > Below are the btrfs fi df /  and  btrfs fi show.
> > >
> > >
> > > turnip:~ # btrfs fi df /
> > > Data, single: total=1.80TiB, used=832.22GiB
> > > System, DUP: total=8.00MiB, used=204.00KiB
> > > System, single: total=4.00MiB, used=0.00
> > > Metadata, DUP: total=5.50GiB, used=5.00GiB
> > > Metadata, single: total=8.00MiB, used=0.00
> >
> > FWIW, the system and metadata single chunks reported there are an
> > artifact from mkfs.btrfs and aren't used (used=0.00).  At some point it
> > should be updated to remove them automatically, but meanwhile, a balance
> > should remove them from the listing.  If you do that balance immediately
> > after filesystem creation, at the first mount, you'll be rid of them when
> > there's not a whole lot of other data on the filesystem to balance as
> > well.  That would leave:
> >
> > > Data, single: total=1.80TiB, used=832.22GiB
> > > System, DUP: total=8.00MiB, used=204.00KiB
> > > Metadata, DUP: total=5.50GiB, used=5.00GiB
> >
> > Metadata is the red-flag here.  Metadata chunks are 256 MiB in size, but
> > in default DUP mode, two are allocated at once, thus 512 MiB at a time.
> > And you're under 512 MiB free so you're running on the last pair of
> > metadata chunks, which means depending on the operation, you may need to
> > allocate metadata pretty quickly.  You can probably copy a few files
> > before that, but a big copy operation with many files at a time would
> > likely need to allocate more metadata.
> 
> The size of the chunks allocated is especially useful information. I've not
> seen that anywhere else, and does explain a fair bit.
> 
> > But for a complete picture you need the filesystem show output, below, as
> > well...
> >
> > > turnip:~ # btrfs fi show
> > > Label: none  uuid: 9379c138-b309-4556-8835-0f156b863d29
> > >         Total devices 1 FS bytes used 837.22GiB
> > >         devid    1 size 1.81TiB used 1.81TiB path /dev/sda3
> > >
> > > Btrfs v3.12+20131125
> >
> > OK.  Here we see the root problem.  Size 1.81 TiB, used 1.81 TiB.  No
> > unallocated space at all.  Whichever runs out of space first, data or
> > metadata, you'll be stuck.
> 
> Now it's at this point that I am unclear. I thought the above said:
> "1 device on this filesystem, 837.22 GiB used."
> and
> "device ID #1 is /dev/sda3, is 1.81TiB in size, and btrfs is using 1.81TiB
> of that"
> 
> Which I interpret differently. Can you go into more detail as to how (from
> btrfs fi show) we can say "the _filesystem_ (not the device) is full"?

   From btrfs fi show on its own, you can't. The problem is that the
data/metadata split means that the metadata has run out, and there's
(currently -- see below) no way of reassigning some of the data
allocation to metadata. So the "disk full" condition is "complete
allocation (see btrfs fi show)" *and* "metadata near-full (see btrfs
fi df)".

   An interesting question here is how come the FS allocated all that
space to data when it's a newly-made filesystem with less than half
that space actually used -- did you write lots of other data to it and
then delete it again? If not, I haven't seen overallocation like that
that since 3.9 or so, and it would be good to know what happened.

[snip]
> > Meanwhile, I strongly urge you to read up on the btrfs wiki.  The
> > following is easy to remember and bookmark:
> 
> I read the wiki and related pages many times, but there is a lot of info
> there and I must have skipped over the "if your device is large" section.
> 
> To be honest, it seems like a lot of hoop-jumping and a maintenance burden
> for the administrator. Not being able to draw from "free space pool" for
> either data or metadata seems like a big bummer. I'm hoping that such a
> limitation will be resolved at some near-term future point.

   It's certainly something that's been discussed in the past. I think
Ilya had automatic reclamation of unused allocation (e.g. an autonomic
balance / reallocation) on his to-do list at one point. I don't know
what the status of the work is, though.

[snip]

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Alert status chocolate viridian: Authorised personnel only. ---   
                   Dogs must be carried on escalator.                    

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUy4e7FheFHXiqx3kAQKzoA//cf3hfhr1oQauXi59uV2Z0T08lPC8DL8+
+jGkMWAxvCpBImpE7WiIHCORc1u8ZZpCtwYeBbfaSJbDpaTTJHqYNAUjP0Hgc85V
lrGFcd//7eEnQVNOpGX55fa/lBw/PypCmKqluad16mmWrXXrmjsB4KRcoIt2jVvR
GC+PApAtvzzzeYj2WNwaIviG0yNvkPgJVSGSlGufatugidyiCudCq9xU9cRQSIKf
OTjNgG3xS17yfL7gUnL8h6jR8lTc031UVW5vHnPoeKJf8ed9lRDfOMFX6gsZ7owa
sda7tapo6acON2oIdlsNQuDp3y15EdCn9bE5ULJosTuLzBbVbZ2p+2FK55/OPBgo
JtwIme8iXpzCa2zi7FFANDS6RVubPMke7SOrO3CQYCHQbvVcVIUaT1OcCUfl/KEc
CdvzxPmI2QJNuqVESlBkryZq9XhDUpoaTuWh+UhFiIYBLKQJCe70+RjQCrMEmIf2
vozA/Y0c2yf0CFkCFIvucvZaNDN4bDdJZNF+AoUkimm3f1HkkouHkxGDrpDkZefu
QPe9nkUhnEyCqM6Jr+mN/meAk4lwY9Vra3X/NSKO+pE+bKgJtZYCj0ih5NKSfT1t
TkEZCI6XWVzK5QOWn1updlqLL08lhp2rtviinGK4EOQjf84VA08K5xdgECQ+7j5q
74YsnRvFM1E=
=iZn2
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
