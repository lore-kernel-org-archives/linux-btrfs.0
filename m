Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47766 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbeH2OAk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 10:00:40 -0400
Date: Wed, 29 Aug 2018 10:04:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: DRDY errors are not consistent with scrub results
Message-ID: <20180829100429.GO7524@carfax.org.uk>
References: <CAJCQCtQ=CiB5cY8RL4tzps21d=umjzNM=BKjdUBCc7WiP0QF9A@mail.gmail.com>
 <CAJCQCtSGV1gz66X9BJAJosuhMTvd2=Me-X2tVDwJ0Eg9PA7BPA@mail.gmail.com>
 <CAN4oSBfAS75x7+D2Ms93NGB5H5MG-AOR5mHg2czGCECg6api3Q@mail.gmail.com>
 <CAJCQCtT3PrcFwFq3oAyPyQTNBRdSjevFEE7V5_AoKD6hEDgvyA@mail.gmail.com>
 <CAN4oSBdLEXS8DzZ+8Y-z5BxSe_7EUsA4ZEp4OAhWOhhZMwkM=w@mail.gmail.com>
 <CAJCQCtRPxtqqfCE_fRwzbfFAFMHCdO34T+riXQfd6-=BJX37SQ@mail.gmail.com>
 <CAN4oSBezSLqwLaYu-OPrgomcK-RnaJhkukMoun=8JKQbMfqSWA@mail.gmail.com>
 <CAJCQCtTZap+DRVe9yj-GjvJsvL=A+SoTzdTY=u2KjUV5WQhMsw@mail.gmail.com>
 <CAN4oSBdvw2BnL7NJeFNmWbnQfhiZzGM=bi4kPVLb3G1BykBL=g@mail.gmail.com>
 <pan$a7e58$50ac50ff$7213aaae$e428330b@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="L5nTHegdhbHhzmSD"
In-Reply-To: <pan$a7e58$50ac50ff$7213aaae$e428330b@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--L5nTHegdhbHhzmSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 29, 2018 at 09:58:58AM +0000, Duncan wrote:
> Cerem Cem ASLAN posted on Wed, 29 Aug 2018 09:58:21 +0300 as excerpted:
> 
> > Thinking again, this is totally acceptable. If the requirement was a
> > good health disk, then I think I must check the disk health by myself.
> > I may believe that the disk is in a good state, or make a quick test or
> > make some very detailed tests to be sure.
> 
> For testing you might try badblocks.  It's most useful on a device that 
> doesn't have a filesystem on it you're trying to save, so you can use the 
> -w write-test option.  See the manpage for details.
> 
> The -w option should force the device to remap bad blocks where it can as 
> well, and you can take your previous smartctl read and compare it to a 
> new one after the test.
> 
> Hint if testing multiple spinning-rust devices:  Try running multiple 
> tests at once.  While this might have been slower on old EIDE, at least 
> with spinning rust, on SATA and similar you should be able to test 
> multiple devices at once without them slowing down significantly, because 
> the bottleneck is the spinning rust, not the bus, controller or CPU.  I 
> used badblocks years ago to test my new disks before setting up mdraid on 
> them, and with full disk tests on spinning rust taking (at the time) 
> nearly a day a pass and four passes for the -w test, the multiple tests 
> at once trick saved me quite a bit of time!

   Hah. Only a day? It's up to 2 days now.

   The devices get bigger. The interfaces don't get faster at the same
rate. Back in the late '90s, it was only an hour or so to run a
badblocks pass on a big disk...

   Hugo.

-- 
Hugo Mills             | Nostalgia isn't what it used to be.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--L5nTHegdhbHhzmSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJbhm+tAAoJEFheFHXiqx3kSrYQALc4V4KzU3IsTdstlQqmtmST
a45FMUQcgZvIHiX8DMqVustDGWZAYaZRZBTNFFkVhgAjxrmCuIvMjnbbJO8XNYD6
NM+pnijh9zUMvYtS9aiGNUXeZVs6KIs/p3zANZ1I59nVkKkI1yD4CS7v4xh5giL2
DuqCgqfuIRYf1dT2byuJyQFQRWynLfcWdWoV9B3y8fv+pFlDTf7z3/bDCGQiWfwl
suLNBT8xhCdaoUGxKoDoYWlgjwYgOndplRtZvkRP2PVpgAEA1FGLvUF8X1Rx8YOH
M6WiK54npbVLxgio0uliKJvle/iVg61iWHMtb8RipZjy3zbcQYssrl5aQc8jJss0
aSWngGiSC1LIL93s6F7T15DSTPDlwgZk+2r6Vegz/rHXcbDPCjFuKMgLLg/6J5ZO
ZhhQGTHS9ZavPaH9uFLxlmdsvqsVuJc0dFSBfx8gHU9gTPws+kU65r2XF/pu31jg
GSFnUduYwMKZz2u/E+CfEVcWQokxsngv2UBYKOwF7azalqDMBeIpLI1Mjxc3Qxti
QsAqaVxJ0saR+6reVI5GIrfZUYNBIMghPOXDBcrVtod6EgUwE3VHROJPJEmHSQ0V
cVIVMtwf/CUwhZnK/inoFitc7Bv9IctVsCIaQUrjaTFdKUBrocaBCvcWhAmtR8uY
M46lZNrq/sZwomSNbYoV
=9yDz
-----END PGP SIGNATURE-----

--L5nTHegdhbHhzmSD--
