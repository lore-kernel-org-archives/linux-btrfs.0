Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:32836 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932299AbdAJQC6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 11:02:58 -0500
Date: Tue, 10 Jan 2017 15:29:05 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: mkfs.btrfs/balance small-btrfs chunk size RFC
Message-ID: <20170110152905.GJ19585@carfax.org.uk>
References: <pan$cb31b$a126bd1f$577e9db8$38b890f5@cox.net>
 <db8aff8c-44a5-f488-56de-4a9ec87e44e0@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XIiC+We3v3zHqZ6Z"
In-Reply-To: <db8aff8c-44a5-f488-56de-4a9ec87e44e0@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XIiC+We3v3zHqZ6Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 10, 2017 at 09:57:52AM -0500, Austin S. Hemmelgarn wrote:
> On 2017-01-09 22:55, Duncan wrote:
> >This post is triggered by a balance problem due to oversized chunks that
> >I have currently.
> >
> >Proposal 1: Ensure maximum chunk sizes are less than 1/8 the size of the
> >filesystem (down to where they can't be any smaller, at least).
> >
> >Proposal 2: Drastically reduce default system chunk size on small btrfs.
> >
> >Here's the real-life scenario:  My /boot is 256 MiB mixed-bg-mode DUP.
> >
> >Unfortunately, mkfs.btrfs apparently creates the first mixed chunk as 64
> >MiB, making it unbalancable.  64 MiB duped due to dup mode is 128 MiB,
> >exactly half the btrfs size.  But there's also a 16 MiB system chunk,
> >duped to 32 MiB, so even with a still-empty fs immediately after creation
> >I can't balance that chunk (which isn't entirely empty apparently in
> >ordered to keep it from being erased by the kernel auto-clean or a
> >balance, leaving no record of the chunk mode), because the 1/4 the btrfs
> >chunk dups to 1/2 the btrfs, and with the system chunk as well, there's
> >not half the btrfs left in ordered to create a second chunk along with
> >its dup to balance into.
> >
> >But if I fill the btrfs enough to create another mixed chunk, it's only
> >16 MiB in size, duped to 32 MiB, and btrfs usage shows it going from 64
> >MiB to 80 MiB (16 MiB change, the additional chunk size), with the
> >resulting duped size going from 128 MiB to 160 MiB (32 MiB change, the
> >additional chunk duped size).
> >
> >Now if those first chunks were 32 MiB or even the 16 MiB of the second,
> >there'd obviously be more of them used for the same file content, but as
> >long as I kept enough unallocated space on the btrfs to handle twice the
> >size (due to dup) of the largest chunk, I could still balance all chunks,
> >something that's flat impossible when the first mixed chunk dups to half
> >the btrfs, and there has to be room for the system chunk as well.
> >
> >So if the maximum created chunk size was limited to 1/8 the btrfs size,
> >it would dup to 1/4 the size, and balances should actually be possible.
> >
> >As for proposal 2...
> >
> >The system chunk size is 16 MiB, duped to 32 MiB, despite only a single 4
> >KiB block actually being used.  Locking up 16 MiB, duped to 32 MiB thus
> >1/8 the entire btrfs space of 256 MiB, for a single 4 KiB block, duped to
> >8 KiB, 1/20th of 1 percent of that system chunk used if my math is
> >correct, is ridiculous on a sub-GiB btrfs.
> >
> >I don't know what the minimum chunk size actually is, but something like
> >1 MiB system chunk size, if possible, would be far more reasonable in the
> >sub-GiB btrfs context.  Otherwise 2 or even 4 MiB, the latter of which
> >would dup to 8 MiB, would be tolerable, but a 16 MiB system chunk for a
> >single 4 KiB block... and then dup /that/... just ridiculous.
> >
> >It wouldn't be quite so bad if the global reserve (reported at 16 MiB)
> >came from the system chunk instead of metadata (mixed-chunk here), and
> >putting that in the system chunk would make sense since it's effectively
> >system-reserved space, but of course it doesn't work that way, and I'd
> >guess changing that would be a hairy nightmare, far worse than simply
> >clamping down on created chunk sizes a bit, and likely practically
> >impossible to implement at this stage.
> >
> >
> >But I'd expect clamping down on created chunk size, simply adding a check
> >to ensure it's under 1/8 the full btrfs size (down to the minimum allowed
> >chunk size, of course), to be quite practical and reasonably easy to
> >implement.  Similarly altho I'm less sure of how small the minimum system
> >chunk size can be, I expect maximum system chunk size can reasonably be
> >limited to say 4 MiB, if not 1 or 2 MiB, on sub-GiB btrfs.
> >
> >So RFC, how realistic and simple does this look to the devs actually
> >doing the code?  Is it a small enough job it could qualify as a bug fix
> >(as it arguably is, given that the btrfs is /created/ with chunks that
> >are impossible to balance, at present, or at least was around 4.8 time,
> >as I believe that's about when I created the btrfs), be tested and make
> >it into released code within say five kernel cycles, a year's time?
> >Obviously I'm hoping so. =:^)
> >
> I can't personally comment on the code itself right now (I've
> actually never looked at the mkfs code, or any of the stuff that
> deals with the System chunk), but I can make a few general comments
> on this:
> 1. This behavior is still the case as of a Git build from yesterday
> (I just verified this myself with the locally built copy of
> btrfs-progs on my laptop).
> 2. Given the implications of snapshotting and typical usage, I'd say
> it's not likely that the System chunk will need to be much more than
> a single filesystem block on such a small FS.

   The System chunk has nothing to do with snapshotting. It's where
the chunk tree lives. (And the reason it's separate from all the other
metadata is so that the FS can bootstrap the physical-virtual mapping
easily).

   A chunk record is 48 bytes, plus 17 bytes for the key, plus a
32 byte record appended to it for each stripe.

>  I don't use more than
> a single snapshot at a time, but I do have lots of subvolumes on my
> laptop's root filesystem, and it's System chunk usage is still only
> one FS block (16kb in my case)).  That said, ISTR reading somewhere
> that the System chunk is functionally fixed-size (can't be more than
> one chunk, and BTRFS can't resize an existing chunk).

   I don't recall seeing anything about that as a limitation. The
superblock structure appears to be able to support multiple system
chunks -- there's a list of records pointing to the physical location
of each system chunk appended to the end of the superblock. A comment
in ctree.h remarks that "this gives us enough room to translate 14
chunks with 3 stripes each", so there's clearly the expectation that
there may be more than one.

   The largest filesystem I think I've seen anyone mention in the wild
was on the scale of 100 TB, which is going to have about 100k chunks,
which comes out as about 10 MiB of metadata in the chunk tree. So you
definitely wouldn't want to use a 1 MiB chunk size for the system tree
in general. I don't see a problem with shrinking it for small
filesystems, though.

   The only thing I can see might be an issue is where a small FS is
created with, say, a 128 KiB system chunk, and then it's grown into a
large filesystem. You'd have to ensure that any subsequent system
chunk allocations are much larger, otherwise you're going to break the
14(ish) chunk limit in the superblock.

   Hugo.

> 3. In theory, it shouldn't be hard to get mkfs to use different
> sizes when creating the FS.  For at least the System chunk though,
> it may face limitations due to kernel expectations.
> 
> Given the above three points, I'd like to make a slightly different
> proposal:
> Add options to mkfs to specify the size of the initial Data,
> Metadata, and System chunk in the filesystem, and document clearly
> some reasonable numbers based on FS size and intended usage.
> 

-- 
Hugo Mills             | I'm always right. But I might be wrong about that.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--XIiC+We3v3zHqZ6Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYdP3BAAoJEFheFHXiqx3kpWAQAJ6bVoPtKtKiPAmKXWyAXKiG
QYt/8KMqM1CF1HISS860nMFU+1HNOoEsH9BqFfscB/cHc1HikI4LN6UsOgaJ2y1e
hmDh6jSmSJ6xfauL+HG9dYfXhNObYgfu/dvjlJVauodoS+nXmB+SrBjQrELymgH1
dSOb00PNb8V+VYXsUwi/q9scMNqz0lqoAMU0vw/M/ZzqCFwQ3VxiroK5tXbYLRo7
oYUcFOaxuddng7c8JY7NVzVPlBVZJdbiiit6uhZb+yPLg3GF73N0UZtvZdv88VQX
Y2bI1Ww0mJMsVSS440jlqBiZNVxBr6LniLGsWubvlkcJBHI5X0dREEjL6BM8hYzW
FRAyis3OK0plJm/j/qpnJ5j1fiJAWLYZdBveIHp418AjME65KM0JdJ6JLy7QAOIn
z2Gf4R6/GBNtoXXSBZ1WcIS7U2fh8QLpJzMLDD4HNMcGChEEAZDKhS3WzxdjBugm
gFq3wl1AsdjS70XhvtzzCX6Eq1g4+oSdWEHsLAC14UDP1i7vUSPT0c0gu+GJxmBB
L4fZye1dJonIwiG5J/pUCQyLZ61IjxHJ83JfAkxlLt/f/5EjQzgFXTEEmR+h9631
ledAMQvrfdaAdmFKql/kIhktLPFX/Jpn8wDlujnXzrT7QmeBDJ7bsfsuGa023wl/
IkIaZcVoXw0gfaEzWVmY
=I3Gl
-----END PGP SIGNATURE-----

--XIiC+We3v3zHqZ6Z--
