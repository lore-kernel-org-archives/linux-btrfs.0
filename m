Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41310 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752362AbcKRB4v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 20:56:51 -0500
Date: Fri, 18 Nov 2016 01:56:46 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, linux-btrfs@vger.kernel.org,
        kreijack@libero.it
Subject: Re: [PATCH 0/2] RAID5/6 scrub race fix
Message-ID: <20161118015646.GZ16645@carfax.org.uk>
References: <20161115025024.25299-1-quwenruo@cn.fujitsu.com>
 <20161117231310.GN21290@hungrycats.org>
 <e1f1b582-78b6-ec53-81ca-f9917a346d71@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="o/BvujNCPFVhiGON"
In-Reply-To: <e1f1b582-78b6-ec53-81ca-f9917a346d71@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--o/BvujNCPFVhiGON
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 18, 2016 at 09:19:11AM +0800, Qu Wenruo wrote:
> 
> 
> At 11/18/2016 07:13 AM, Zygo Blaxell wrote:
> >On Tue, Nov 15, 2016 at 10:50:22AM +0800, Qu Wenruo wrote:
> >>Fix the so-called famous RAID5/6 scrub error.
> >>
> >>Thanks Goffredo Baroncelli for reporting the bug, and make it into our
> >>sight.
> >>(Yes, without the Phoronix report on this,
> >>https://www.phoronix.com/scan.php?page=news_item&px=Btrfs-RAID-56-Is-Bad,
> >>I won't ever be aware of it)
> >
> >If you're hearing about btrfs RAID5 bugs for the first time through
> >Phoronix, then your testing coverage is *clearly* inadequate.
> 
> I'm not fixing everything, I'm just focusing on the exact one bug
> reported by Goffredo Baroncelli.
> 
> Although it seems that, the bug reported by him is in fact two bugs.
> One is race condition I'm fixing, another one is that recovery is
> recovering data correctly, but screwing up parity.
> 
> I just don't understand why you always want to fix everything in one step.

   Fix the important, fundamental things first, and the others
later. This, from my understanding of Zygo's comments, appears to be
one of the others.

   It's papering over the missing bricks in the wall instead of
chipping out the mortar and putting new bricks in. It may need to be
fixed, but it's not the fundamental "OMG, everything's totally broken"
problem. If anything, it's only a serious problem *because* the other
thing (write hole) is still there.

   It just seems like a piece of mis-prioritised effort.

> >Fill up a RAID5 array, start a FS stress test, pull a drive out while
> >that's running, let the FS stress test run for another hour, then try
> >to replace or delete the missing device.  If there are any crashes,
> >corruptions, or EIO during any part of this process (assuming all the
> >remaining disks are healthy), then btrfs RAID5 is still broken, and
> >you've found another bug to fix.
> 
> Then it will be another bug to fix, not the bug I'm fixing.
> Unless you can prove whatever the bug is, is relating to the fix, I
> don't see any help then.
> 
> >
> >The fact that so many problems in btrfs can still be found this way
> >indicates to me that nobody is doing this basic level of testing
> >(or if they are, they're not doing anything about the results).
> >
> >>Unlike many of us(including myself) assumed, it's not a timed bomb buried
> >>deeply into the RAID5/6 code, but a race condition in scrub recovery
> >>code.
> >
> >I don't see how this patch fixes the write hole issue at the core of
> >btrfs RAID56.  It just makes the thin layer of bugs over that issue a
> >little thinner.  There's still the metadata RMW update timebomb at the
> >bottom of the bug pile that can't be fixed by scrub (the filesystem is
> >unrecoverably damaged when the bomb goes off, so scrub isn't possible).
> 
> Not "the core of btrfs RAID56", but "the core of all RAID56".
> 
> And, this is just another unrelated problem, I didn't even want to
> repeat what I've written.

   That's the one that needs fixing *first*, though. (IMO, YMMV,
Contents may have settled in transit).

   Hugo.

> Thanks,
> Qu
> 
> >
> >>The problem is not found because normal mirror based profiles aren't
> >>affected by the race, since they are independent with each other.
> >
> >True.
> >
> >>Although this time the fix doesn't affect the scrub code much, it should
> >>warn us that current scrub code is really hard to maintain.
> >
> >This last sentence is true.  I found and fixed three BUG_ONs in RAID5
> >code on the first day I started testing in degraded mode, then hit
> >the scrub code and had to give up.  It was like a brick wall made out
> >of mismatched assumptions and layering inversions, using uninitialized
> >kernel data as mortar (though I suppose the "uninitialized" data symptom
> >might just have been an unprotected memory access).
> >
> >>Abuse of workquque to delay works and the full fs scrub is race prone.
> >>
> >>Xfstest will follow a little later, as we don't have good enough tools
> >>to corrupt data stripes pinpointly.
> >>
> >>Qu Wenruo (2):
> >>  btrfs: scrub: Introduce full stripe lock for RAID56
> >>  btrfs: scrub: Fix RAID56 recovery race condition
> >>
> >> fs/btrfs/ctree.h       |   4 ++
> >> fs/btrfs/extent-tree.c |   3 +
> >> fs/btrfs/scrub.c       | 192 +++++++++++++++++++++++++++++++++++++++++++++++++
> >> 3 files changed, 199 insertions(+)
> >>

-- 
Hugo Mills             | UDP jokes: It's OK if no-one gets them.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--o/BvujNCPFVhiGON
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYLl/eAAoJEFheFHXiqx3kOI0P/R8ku+Z4znT2OARi5zTd3Wym
kfoMv6GmBQBruooTCmwUau+h7avhvYleJNaFQKNOCCxVMlgznwSplgo7z5tIidTG
oL4DDzOZk9u1bQbC4C8bZtmcfc5Ih1KYtvnIGNx+IyrHCIq+hkjBLJvlqVFQ3h0f
C4DR2byXjXvQVa0WhFpDwGAynsnS0ExEDOarAy1EPYH9455G/USJBm7nmITi87qB
2JxfMLw/JQNcsJcJbaVwZX6TyL28NsplpbV5cTiQbd54uwoYVwcgdbFglLnhsANH
+++rXu2lz3TYiF51xBXBAWNOCe4MOezXheqT/ezwZ5bCtQPRgs1hQWxEceIsqzvE
Gh1EeEXkjJSUIpx8zX3IvXfwZeMSxTGDJECMaYq9AZ+pzh4DxrhIfpc+nK8QXMVk
5JWta0mq4tZgkLBrNiw1jgIJ7xeMrNwiJiJ8xeMcSdHMy703puBcL6saRnChxYV/
kurGx5Y7ebMXoLNOuZryUCjYCkCalkrLuauOKvLFxRK7EYmmPS6jfjgsdwrbaD/D
eF+vYkhGV7BquEqwYT1D7ADKjqaMljKIUYO0jiX2IoRXKUnvik4TqB/uO2IU8Oh6
oYwhrF4Na5KjpkhyOfNm1jRb4qVctlT4zNUult/3ZkGtVD1E6thCFHa5UHWDAhmJ
vyz5s1OtwFWO9vGI3Ov9
=AbA4
-----END PGP SIGNATURE-----

--o/BvujNCPFVhiGON--
