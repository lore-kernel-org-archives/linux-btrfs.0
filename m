Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56695 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932677AbdKGAyM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 19:54:12 -0500
Subject: Re: feedback on three different scrub methods
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtTsfNgSBDdnq0uFd1ZRRY0AWbv=rx5X1UUGp1i9hK-4hw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f5558865-088d-66c7-e168-e99da9f7532d@gmx.com>
Date: Tue, 7 Nov 2017 08:54:05 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTsfNgSBDdnq0uFd1ZRRY0AWbv=rx5X1UUGp1i9hK-4hw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UNIW6Ctep6PnuBSBtP7gFBb0BSukMi7j1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UNIW6Ctep6PnuBSBtP7gFBb0BSukMi7j1
Content-Type: multipart/mixed; boundary="doVrhpFhl4fgoUvF0PBiElRjVfGW3qMkU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <f5558865-088d-66c7-e168-e99da9f7532d@gmx.com>
Subject: Re: feedback on three different scrub methods
References: <CAJCQCtTsfNgSBDdnq0uFd1ZRRY0AWbv=rx5X1UUGp1i9hK-4hw@mail.gmail.com>
In-Reply-To: <CAJCQCtTsfNgSBDdnq0uFd1ZRRY0AWbv=rx5X1UUGp1i9hK-4hw@mail.gmail.com>

--doVrhpFhl4fgoUvF0PBiElRjVfGW3qMkU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8807=E6=97=A5 04:17, Chris Murphy wrote:
> I just did scrubs on five different volumes using all three scrub
> methods. There were no errors found, so the test leaves uncertain what
> the error handling differences are between the three scrubs. But at
> the least with no errors, there are also no disagreements between the
> three methods.
>=20
> 1. Speed. Both normal online scrub and the btrfsck --check-data-csum
> methods, I get ~275MB/s transfers per iotop. Whereas with --offline
> scrub I'm seeing 60%-67% of that, or ~170MB/s transfers. That's
> substantially slower. If it were using less CPU or the system more
> responsive, it might be worth that trade off in time. But the CPU %
> and system responsiveness for other tasks seemed the same, it just
> took longer.

First, --check-data-csum will only check the first copy if it's good.
So --check-data-csum is doing a little cheating here.

Further more, IIRC current offline scrub branch doesn't have the extent
cache enabled, and since it's completely relying on extent tree, quite a
lot of time is spent on doing similar tree search and causing extra
random IO.

I can be totally wrong, but if offline scrub rebased to latest
btrfs-progs (v4.13.3), it may have some small improvement.

>=20
> 2. Each method reports different statistics in different formats. And
> that's fine except I can't make heads or tails out of the information
> presented, making it basically useless at least to this user.

Offline scrub in fact can reuse the whole kernel scrub ioctl structure.
So it can completely report the same content as kernel.

However the problem is, for offline scrub, my primary goal is to report
error as detail as possible, to verify kernel scrub.

So it has different output, but it can be improved.

>=20
> [chris@f26s ~]$ sudo /srv/scratch/gitsworking/btrfs-progs/btrfs check
> --check-data-csum /dev/mapper/sdd
> Checking filesystem on /dev/mapper/sdd
> UUID: f5adc913-bbea-4340-8b5f-3411e2cda642
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 601877024768 bytes used, no error found
> total csum bytes: 586444884
> total tree bytes: 1208827904
> total fs tree bytes: 510672896
> total extent tree bytes: 53755904
> btree space waste bytes: 142065358
> file data blocks allocated: 2213492944896
>  referenced 1977848909824
>=20
>=20
> [chris@f26s ~]$ sudo btrfs-progs/btrfs scrub start --offline
> /dev/mapper/sdd
> [sudo] password for chris:
> Scrub result:
> Tree bytes scrubbed: 2417655808
> Tree extents scrubbed: 295124
> Data bytes scrubbed: 2398080548864
> Data extents scrubbed: 751158
> Data bytes without csum: 297271296
> Read error: 0
> Verify error: 0
> Csum error: 0
>=20
> I'm not finding any way these add up. Seems like --offline's tree
> bytes scrubbed + data bytes scrubbed should add up to
> --check-data-csum's found bytes - waste bytes? But no, I have no idea
> what I'm looking at or how it's useful to the user, but OK.

Offline scrub counts all copies for both data and metadata.
So it will be more than btrfs check output.

But to be honest, I didn't review btrfs check numbers, so it may have
something wrong.

Thanks for the feedback,
Qu

>=20
>=20
> I used kernel 4.13.10 and btrfs-progs 4.13.3 for the usual 'btrfs
> scrub start' and the less common 'btrfs check ----check-data-csum'
> methods; and Qu's v4.11.1-89-gf939adf2 with offline_scrub checked out.
>=20
>=20
>=20
>=20


--doVrhpFhl4fgoUvF0PBiElRjVfGW3qMkU--

--UNIW6Ctep6PnuBSBtP7gFBb0BSukMi7j1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloBBC0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjIBwf/akYEjUaLrMfIhAOpS3Ir+KOu
Fqn08ZwjySXX3/Uoh3CsD60EIwZfZbaaHsiQTqwlnuB6RZcz93wCjQNkISjPFSt0
pRQU2quN9wufx0c2TOaE849pIHZ3wMg1z2vHBuG580Sj3GcOK0dfKL5bINUMfslH
FJoglxNmu9FBFTnULk8mesykLwdgB7PLKlcJvbKO4g9V4KapbIYpY+zBKh12UZ3L
8tqHzouIO1huk5cZ+riQ2wwS65zgKcdQLQ25UvijqfMncJ/qoJL7C194dYj0penl
Va6uZCanPM+4P2KcEb3HrWsSDpIjuZHBcfm0RGuF6h1JtYW5NiA+6epkpWC7mQ==
=7pbb
-----END PGP SIGNATURE-----

--UNIW6Ctep6PnuBSBtP7gFBb0BSukMi7j1--
