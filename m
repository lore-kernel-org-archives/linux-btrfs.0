Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59722 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750921AbdLAVgQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 16:36:16 -0500
Date: Fri, 1 Dec 2017 21:36:14 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: exclusive subvolume space missing
Message-ID: <20171201213614.GE29898@carfax.org.uk>
References: <20171201161555.GA11892@polanet.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="r7U+bLA8boMOj+mD"
In-Reply-To: <20171201161555.GA11892@polanet.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--r7U+bLA8boMOj+mD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 01, 2017 at 05:15:55PM +0100, Tomasz Pala wrote:
> Hello,
> 
> I got a problem with btrfs running out of space (not THE
> Internet-wide, well known issues with interpretation).
> 
> The problem is: something eats the space while not running anything that
> justifies this. There were 18 GB free space available, suddenly it
> dropped to 8 GB and then to 63 MB during one night. I recovered 1 GB
> with rebalance -dusage=5 -musage=5 (or sth about), but it is being eaten
> right now, just as I'm writing this e-mail:
> 
> /dev/sda2        64G   63G  452M 100% /
> /dev/sda2        64G   63G  365M 100% /
> /dev/sda2        64G   63G  316M 100% /
> /dev/sda2        64G   63G  287M 100% /
> /dev/sda2        64G   63G  268M 100% /
> /dev/sda2        64G   63G  239M 100% /
> /dev/sda2        64G   63G  230M 100% /
> /dev/sda2        64G   63G  182M 100% /
> /dev/sda2        64G   63G  163M 100% /
> /dev/sda2        64G   64G  153M 100% /
> /dev/sda2        64G   64G  143M 100% /
> /dev/sda2        64G   64G   96M 100% /
> /dev/sda2        64G   64G   88M 100% /
> /dev/sda2        64G   64G   57M 100% /
> /dev/sda2        64G   64G   25M 100% /
> 
> while my rough calculations show, that there should be at least 10 GB of
> free space. After enabling quotas it is somehow confirmed:
> 
> # btrfs qgroup sh --sort=excl / 
> qgroupid         rfer         excl 
> --------         ----         ---- 
> 0/5          16.00KiB     16.00KiB 
> [30 snapshots with about 100 MiB excl]
> 0/333        24.53GiB    305.79MiB 
> 0/298        13.44GiB    312.74MiB 
> 0/327        23.79GiB    427.13MiB 
> 0/331        23.93GiB    930.51MiB 
> 0/260        12.25GiB      3.22GiB 
> 0/312        19.70GiB      4.56GiB 
> 0/388        28.75GiB      7.15GiB 
> 0/291        30.60GiB      9.01GiB <- this is the running one
> 
> This is about 30 GB total excl (didn't find a switch to sum this up). I
> know I can't just add 'excl' to get usage, so tried to pinpoint the
> exact files that occupy space in 0/388 exclusively (this is the last
> snapshots taken, all of the snapshots are created from the running fs).

   The thing I'd first go looking for here is some rogue process
writing lots of data. I've had something like this happen to me
before, a few times. First, I'd look for large files with "du -ms /* |
sort -n", then work down into the tree until you find them.

   If that doesn't show up anything unusually large, then lsof to look
for open but deleted files (orphans) which are still being written to
by some process.

   This is very likely _not_ to be a btrfs problem, but instead some
runaway process writing lots of crap very fast. Log files are probably
the most plausible location, but not the only one.

> Now, the weird part for me is exclusive data count:
> 
> # btrfs sub sh ./snapshot-171125
> [...]
>         Subvolume ID:           388
> # btrfs fi du -s ./snapshot-171125 
>      Total   Exclusive  Set shared  Filename
>   21.50GiB    63.35MiB    20.77GiB  snapshot-171125
> 
> 
> How is that possible? This doesn't even remotely relate to 7.15 GiB
> from qgroup.~The same amount differs in total: 28.75-21.50=7.25 GiB.
> And the same happens with other snapshots, much more exclusive data
> shown in qgroup than actually found in files. So if not files, where
> is that space wasted? Metadata?

   Personally, I'd trust qgroups' output about as far as I could spit
Belgium(*).

   Hugo.

(*) No offence indended to Belgium.

-- 
Hugo Mills             | I used to live in hope, but I got evicted.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--r7U+bLA8boMOj+mD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaIctOAAoJEFheFHXiqx3kgVsP/jQmxJHUQqTyZ5TZ0K+jlimh
AHvExxsLUXJR2wMuhikyjzlcW+GOpSYdNn8u4Cm8j5iA1P4YtDx0KIaDs/FDSPe8
keA8A9TJ5ArEGGXiXENWQe3jhYzqQF8X9CH/CNwAAOz4jrYHYZg1gPtM7c0ThE+7
F1F6r3rkxEl8sP+QAOTmqatz2jD1qxvtH9v7O7L0sonjdM/V0l88z1m5aufc2AA9
zOG9UegaAygCsQgScPmZ7XLPdOGVEkncQghLpVCrfQcqeyjwJuNFuOkZuqf5473R
5SM8EtRHOCtI36RowZxWLlXjGuA6SgzYn3rNbuYR6YZsu0Ola1kEwNsaJd4uPscI
7D+nqlAHU/QRz+mL4ONO6Ur2ch0907Hlw2CYA+bAkqxxV6KOqrF+f7bPcHjJtWiF
HPE73mbarsM08kMXLP+Yx5HN957Z53ErRpQHYHFN9HSENimocL/xiTnI2bGYiaEc
G2s218+J6XNardghOIGseTUt9Wh8T0Rzip0cAWvOUDCgPQM1Xxm9kJF55MASIB5M
WO5HpLf/tbD0d5tNQ+i7tLBXKmqZ6V4f/2+R+GV+K/YQ2mcWea3RpSn43edkqTPj
r71IwRQYuijWFjG3hiOZleHdjW/UubzmRZGgSf5K5u1OKA3nFnWd1kuKmzzGw26y
Xn85wVIq/z15q+fEEo4F
=YBtj
-----END PGP SIGNATURE-----

--r7U+bLA8boMOj+mD--
