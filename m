Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41852 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752168AbcKRWc0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 17:32:26 -0500
Date: Fri, 18 Nov 2016 17:32:24 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: kreijack@inwind.it
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] RAID5/6 scrub race fix
Message-ID: <20161118223224.GO21290@hungrycats.org>
References: <20161115025024.25299-1-quwenruo@cn.fujitsu.com>
 <20161117231310.GN21290@hungrycats.org>
 <dc2a9254-fd86-a448-c327-d3ea2ea20ddd@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SSjFkhywpXnVG+rz"
In-Reply-To: <dc2a9254-fd86-a448-c327-d3ea2ea20ddd@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SSjFkhywpXnVG+rz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 18, 2016 at 07:09:34PM +0100, Goffredo Baroncelli wrote:
> Hi Zygo
> On 2016-11-18 00:13, Zygo Blaxell wrote:
> > On Tue, Nov 15, 2016 at 10:50:22AM +0800, Qu Wenruo wrote:
> >> Fix the so-called famous RAID5/6 scrub error.
> >>
> >> Thanks Goffredo Baroncelli for reporting the bug, and make it into our
> >> sight.
> >> (Yes, without the Phoronix report on this,
> >> https://www.phoronix.com/scan.php?page=3Dnews_item&px=3DBtrfs-RAID-56-=
Is-Bad,
> >> I won't ever be aware of it)
> >=20
> > If you're hearing about btrfs RAID5 bugs for the first time through
> > Phoronix, then your testing coverage is *clearly* inadequate.
> >=20
> > Fill up a RAID5 array, start a FS stress test, pull a drive out while
> > that's running, let the FS stress test run for another hour, then try
> > to replace or delete the missing device.  If there are any crashes,
> > corruptions, or EIO during any part of this process (assuming all the
> > remaining disks are healthy), then btrfs RAID5 is still broken, and
> > you've found another bug to fix.
> >=20
> > The fact that so many problems in btrfs can still be found this way
> > indicates to me that nobody is doing this basic level of testing
> > (or if they are, they're not doing anything about the results).
>=20
> [...]
>=20
> Sorry but I don't find useful this kind of discussion.  Yes BTRFS
> RAID5/6 needs a lot of care. Yes, *our* test coverage is far to be
> complete; but this is not a fault of a single person; and Qu tried to
> solve one issue and for this we should say only tanks..
>
> Even if you don't find valuable the work of Qu (and my little one :-)
> ), this required some time and need to be respected.

I do find this work valuable, and I do thank you and Qu for it.
I've been following it with great interest because I haven't had time
to dive into it myself.  It's a use case I used before and would like
to use again.

Most of my recent frustration, if directed at anyone, is really directed
at Phoronix for conflating "one bug was fixed" with "ready for production
use today," and I wanted to ensure that the latter rumor was promptly
quashed.

This is why I'm excited about Qu's work:  on my list of 7 btrfs-raid5
recovery bugs (6 I found plus yours), Qu has fixed at least 2 of them,
maybe as many as 4, with the patches so far.  I can fix 2 of the others,
for a total of 6 fixed out of 7.

Specifically, the 7 bugs I know of are:

	1-2. BUG_ONs in functions that should return errors (I had
	fixed both already when trying to recover my broken arrays)

	3. scrub can't identify which drives or files are corrupted
	(Qu might have fixed this--I won't know until I do testing)

	4-6. symptom groups related to wrong data or EIO in scrub
	recovery, including Goffredo's (Qu might have fixed all of these,
	but from a quick read of the patch I think at least two are done).

	7. the write hole.

I'll know more after I've had a chance to run Qu's patches through
testing, which I intend to do at some point.

Optimistically, this means there could be only *one* bug remaining
in the critical path for btrfs RAID56 single disk failure recovery.
That last bug is the write hole, which is why I keep going on about it.
It's the only bug I know exists in btrfs RAID56 that has neither an
existing fix nor any evidence of someone actively working on it, even
at the design proposal stage.  Please, I'd love to be wrong about this.

When I described the situation recently as "a thin layer of bugs on
top of a design defect", I was not trying to be mean.  I was trying to
describe the situation *precisely*.

The thin layer of bugs is much thinner thanks to Qu's work, and thanks
in part to his work, I now have confidence that further investment in
this area won't be wasted.

> Finally, I don't think that we should compare the RAID-hole with this
> kind of bug(fix). The former is a design issue, the latter is a bug
> related of one of the basic feature of the raid system (recover from
> the lost of a disk/corruption).
>
> Even the MD subsystem (which is far behind btrfs) had tolerated
> the raid-hole until last year.=20

My frustration against this point is the attitude that mdadm was ever
good enough, much less a model to emulate in the future.  It's 2016--there
have been some advancements in the state of the art since the IBM patent
describing RAID5 30 years ago, yet in the btrfs world, we seem to insist
on repeating all the same mistakes in the same order.

"We're as good as some existing broken-by-design thing" isn't a really
useful attitude.  We should aspire to do *better* than the existing
broken-by-design things.  If we didn't, we wouldn't be here, we'd all
be lurking on some other list, running ext4 or xfs on mdadm or lvm.

> And its solution is far to be cheap
> (basically the MD subsystem wrote the data first in the journal
> then on the disk... which is the kind of issue that a COW filesystem
> would solve).

Journalling isn't required.  It's sufficient to fix the interaction
between the existing CoW and RAID5 layers (except for some datacow and
PREALLOC cases).  This is "easy" in the sense that it requires only
changes to the allocator (no on-disk format change), but "hard" in the
sense that it requires changes to the allocator.

See https://www.spinics.net/lists/linux-btrfs/msg59684.html
(and look a couple of references upthread)


> BR G.Baroncelli
>
>
>
>
>
>
> -- gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5 --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

--SSjFkhywpXnVG+rz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgvgXgACgkQgfmLGlazG5yM3gCfd9iRzPdoUi1Wa27qYL9qNUBG
23EAnigJAxRFhvWjYk7RKY4PObjrf0vE
=oicC
-----END PGP SIGNATURE-----

--SSjFkhywpXnVG+rz--
