Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36434 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdHaS7X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 14:59:23 -0400
Date: Thu, 31 Aug 2017 18:59:22 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Eric Wolf <19wolf@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS critical (device sda2): corrupt leaf, bad key order:
 block=293438636032, root=1, slot=11
Message-ID: <20170831185922.GC30990@carfax.org.uk>
References: <CAJ_hD5By15sSvur7849XWQ8jkBoGj0cO5vQfY8MguVDCneMX8Q@mail.gmail.com>
 <20170831183302.GB30990@carfax.org.uk>
 <CAJ_hD5D49amQEq7YMu=d-EhRK-CkJerbT=uAc1+rpg+_12KFsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
In-Reply-To: <CAJ_hD5D49amQEq7YMu=d-EhRK-CkJerbT=uAc1+rpg+_12KFsQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   (Please don't top-post; edited for conversation flow)

On Thu, Aug 31, 2017 at 02:44:39PM -0400, Eric Wolf wrote:
> On Thu, Aug 31, 2017 at 2:33 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Thu, Aug 31, 2017 at 01:53:58PM -0400, Eric Wolf wrote:
> >> I'm having issues with a bad block(?) on my root ssd.
> >>
> >> dmesg is consistently outputting "BTRFS critical (device sda2):
> >> corrupt leaf, bad key order: block=293438636032, root=1, slot=11"
> >>
> >> "btrfs scrub stat /" outputs "scrub status for b2c9ff7b-[snip]-48a02cc4f508
> >> scrub started at Wed Aug 30 11:51:49 2017 and finished after 00:02:55
> >> total bytes scrubbed: 53.41GiB with 2 errors
> >> error details: verify=2
> >> corrected errors: 0, uncorrectable errors: 2, unverified errors: 0"
> >>
> >> Running "btrfs check --repair /dev/sda2" from a live system stalls
> >> after telling me corrupt leaf etc etc then "11 12". CPU usage hits
> >> 100% and disk activity remains at 0.
> >
> >    This error is usually attributable to bad hardware. Typically RAM,
> > but might also be marginal power regulation (blown capacitor
> > somewhere) or a slightly broken CPU.
> >
> >    Can you show us the output of "btrfs-debug-tree -b 293438636032 /dev/sda2"?

   Here's the culprit:

[snip]
> item 10 key (890553 EXTENT_DATA 0) itemoff 14685 itemsize 269
>    inline extent data size 248 ram 248 compress 0
> item 11 key (890554 INODE_ITEM 0) itemoff 14525 itemsize 160
>    inode generation 5386763 transid 5386764 size 135 nbytes 135
>    block group 0 mode 100644 links 1 uid 100000 gid 100000
>    rdev 0 flags 0x0
> item 12 key (856762 INODE_REF 31762) itemoff 14496 itemsize 29
>    inode ref index 2745 namelen 19 name: dpkg.statoverride.0
> item 13 key (890554 EXTENT_DATA 0) itemoff 14340 itemsize 156
>    inline extent data size 135 ram 135 compress 0
[snip]

   Note the objectid field -- the first number in the brackets after
"key" for each item. This sequence of values should be non-decreasing.
Thus, item 12 should have an objectid of 890554 to match the items
either side of it, and instead it has 856762.

   In hex, these are:

>>> hex(890554)
'0xd96ba'
>>> hex(856762)
'0xd12ba'

   Which means you've had two bitflips close together:

>>> hex(856762 ^ 890554)
'0x8400'

   Given that everything else is OK, and it's just one byte affected
in the middle of a load of data that's really quite sensitive to
errors, it's very unlikely that it's the result of a misplaced pointer
in the kernel, or some other subsystem accidentally walking over that
piece of RAM. It is, therefore, almost certainly your hardware that's
at fault.

   I would strongly suggest running memtest86 on your machine -- I'd
usually say a minimum of 8 hours, or longer if you possibly can (24
hours), or until you have errors reported. If you get errors reported
in the same place on multiple passes, then it's the RAM. If you have
errors scattered around seemingly at random, then it's probably your
power regulation (PSU or motherboard).

   Sadly, btrfs check on its own won't be able to fix this, as it's
two bits flipped. (It can cope with one bit flipped in the key, most
of the time, but not two). It can be fixed manually, if you're
familiar with a hex editor and the on-disk data structures.

   Hugo.

-- 
Hugo Mills             | "You got very nice eyes, Deedee. Never noticed them
hugo@... carfax.org.uk | before. They real?"
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                 Don Logan, Sexy Beast

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZqFyKAAoJEFheFHXiqx3kiNAQAI0Lj7FJN1iYTIk7h/KBARYc
j5U5Oyg5gwtRbBSWMXGuBLzfuLzDCdfvsuETu8NAPIPRjpkTr2SPWAzH+64G4c/7
JN1pidzZk9h2o0Y8GOEunnSlDkSRRTku5CUnZu/MuALHOiXHvAEFxiwB+WXGG7No
3eyNGip39lZgONDlXIm4RpzXfC0K2wO1eirUZzAnOmZpACSSau5HZ66fN3EwGPmk
IyUGb/CF57hSvxk+KRsn11v/mRSS5vrPXMqDeSQMl5tfIFyXt4WciFXneDJaHITs
MX8MhXZ+pVBIkGky5OwOY+hNJ6vhjDJRh3Epg+BpxLHG8Co4HspIAt9kOVtTU87u
rQs7qt+33SKlojCVIkV2hzWm6YFRV3ICpJ2yga8Iq8wrDnpMb7EBdXouRzNpPfcR
V5l/NUuS8icLNejVtd5s/2L/1HyJOvadN7kvoOKTSm4gl7j3XcSDtB3g6jF3o1TG
Y5D6exnPq2MAvJsR2G5MTcPIYQz/PqJoTpeJZ6ShXySFv9EQeHjK0MACpT4h265E
QMI5rs2dJtZwCIBDDv5T9idaVuuIWxsoC4C5ivB8j235IL5zY7xCyabg1SuTZOMw
PAR4bQ62CxDFQ4YwtWfwKVD9BryPfluyIZM4N6SfBKooDznW6SNFS4yZIyFmN5h7
U5SdTZLDlQBwDvWsbKGT
=0Owi
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
