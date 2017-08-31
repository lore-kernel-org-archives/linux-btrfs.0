Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36556 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbdHaULZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 16:11:25 -0400
Date: Thu, 31 Aug 2017 20:11:24 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Eric Wolf <19wolf@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS critical (device sda2): corrupt leaf, bad key order:
 block=293438636032, root=1, slot=11
Message-ID: <20170831201124.GD30990@carfax.org.uk>
References: <CAJ_hD5By15sSvur7849XWQ8jkBoGj0cO5vQfY8MguVDCneMX8Q@mail.gmail.com>
 <20170831183302.GB30990@carfax.org.uk>
 <CAJ_hD5D49amQEq7YMu=d-EhRK-CkJerbT=uAc1+rpg+_12KFsQ@mail.gmail.com>
 <20170831185922.GC30990@carfax.org.uk>
 <CAJ_hD5DLufKpJPHpvFhsq8fj-oL++=NMkMPEHe9y=dCcsbUwtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sXc4Kmr5FA7axrvy"
In-Reply-To: <CAJ_hD5DLufKpJPHpvFhsq8fj-oL++=NMkMPEHe9y=dCcsbUwtg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--sXc4Kmr5FA7axrvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 31, 2017 at 03:21:07PM -0400, Eric Wolf wrote:
> I've previously confirmed it's a bad ram module which I have already
> submitted an RMA for. Any advice for manually fixing the bits?

   What I'd do... use a hex editor and the contents of ctree.h as
documentation to find the byte in question, change it back to what it
should be, mount the FS, try reading the directory again, look up the
csum failure in dmesg, edit the block again to fix up the csum, and
it's done. (Yes, I've done this before, and I'm a massive nerd).

   It's also possible to use Hans van Kranenberg's btrfs-python to fix
up this kind of thing, but I've not done it myself. There should be a
couple of talk-throughs from Hans in various archives -- both this
list (find it on, say, http://www.spinics.net/lists/linux-btrfs/), and
on the IRC archives (http://logs.tvrrug.org.uk/logs/%23btrfs/latest.html).

> Sorry for top leveling, not sure how mailing lists work (again sorry
> if this message is top leveled, how do I ensure it's not?)

   Just write your answers _after_ the quoted text that you're
replying to, not before. It's a convention, rather than a technical
thing...

   Hugo.

> ---
> Eric Wolf
> (201) 316-6098
> 19wolf@gmail.com
> 
> 
> On Thu, Aug 31, 2017 at 2:59 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >    (Please don't top-post; edited for conversation flow)
> >
> > On Thu, Aug 31, 2017 at 02:44:39PM -0400, Eric Wolf wrote:
> >> On Thu, Aug 31, 2017 at 2:33 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >> > On Thu, Aug 31, 2017 at 01:53:58PM -0400, Eric Wolf wrote:
> >> >> I'm having issues with a bad block(?) on my root ssd.
> >> >>
> >> >> dmesg is consistently outputting "BTRFS critical (device sda2):
> >> >> corrupt leaf, bad key order: block=293438636032, root=1, slot=11"
> >> >>
> >> >> "btrfs scrub stat /" outputs "scrub status for b2c9ff7b-[snip]-48a02cc4f508
> >> >> scrub started at Wed Aug 30 11:51:49 2017 and finished after 00:02:55
> >> >> total bytes scrubbed: 53.41GiB with 2 errors
> >> >> error details: verify=2
> >> >> corrected errors: 0, uncorrectable errors: 2, unverified errors: 0"
> >> >>
> >> >> Running "btrfs check --repair /dev/sda2" from a live system stalls
> >> >> after telling me corrupt leaf etc etc then "11 12". CPU usage hits
> >> >> 100% and disk activity remains at 0.
> >> >
> >> >    This error is usually attributable to bad hardware. Typically RAM,
> >> > but might also be marginal power regulation (blown capacitor
> >> > somewhere) or a slightly broken CPU.
> >> >
> >> >    Can you show us the output of "btrfs-debug-tree -b 293438636032 /dev/sda2"?
> >
> >    Here's the culprit:
> >
> > [snip]
> >> item 10 key (890553 EXTENT_DATA 0) itemoff 14685 itemsize 269
> >>    inline extent data size 248 ram 248 compress 0
> >> item 11 key (890554 INODE_ITEM 0) itemoff 14525 itemsize 160
> >>    inode generation 5386763 transid 5386764 size 135 nbytes 135
> >>    block group 0 mode 100644 links 1 uid 100000 gid 100000
> >>    rdev 0 flags 0x0
> >> item 12 key (856762 INODE_REF 31762) itemoff 14496 itemsize 29
> >>    inode ref index 2745 namelen 19 name: dpkg.statoverride.0
> >> item 13 key (890554 EXTENT_DATA 0) itemoff 14340 itemsize 156
> >>    inline extent data size 135 ram 135 compress 0
> > [snip]
> >
> >    Note the objectid field -- the first number in the brackets after
> > "key" for each item. This sequence of values should be non-decreasing.
> > Thus, item 12 should have an objectid of 890554 to match the items
> > either side of it, and instead it has 856762.
> >
> >    In hex, these are:
> >
> >>>> hex(890554)
> > '0xd96ba'
> >>>> hex(856762)
> > '0xd12ba'
> >
> >    Which means you've had two bitflips close together:
> >
> >>>> hex(856762 ^ 890554)
> > '0x8400'
> >
> >    Given that everything else is OK, and it's just one byte affected
> > in the middle of a load of data that's really quite sensitive to
> > errors, it's very unlikely that it's the result of a misplaced pointer
> > in the kernel, or some other subsystem accidentally walking over that
> > piece of RAM. It is, therefore, almost certainly your hardware that's
> > at fault.
> >
> >    I would strongly suggest running memtest86 on your machine -- I'd
> > usually say a minimum of 8 hours, or longer if you possibly can (24
> > hours), or until you have errors reported. If you get errors reported
> > in the same place on multiple passes, then it's the RAM. If you have
> > errors scattered around seemingly at random, then it's probably your
> > power regulation (PSU or motherboard).
> >
> >    Sadly, btrfs check on its own won't be able to fix this, as it's
> > two bits flipped. (It can cope with one bit flipped in the key, most
> > of the time, but not two). It can be fixed manually, if you're
> > familiar with a hex editor and the on-disk data structures.
> >
> >    Hugo.
> >

-- 
Hugo Mills             | "There's a Martian war machine outside -- they want
hugo@... carfax.org.uk | to talk to you about a cure for the common cold."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                           Stephen Franklin, Babylon 5

--sXc4Kmr5FA7axrvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZqG1sAAoJEFheFHXiqx3kz9UQAKxfhuCrDBQdJ9osMTmZ4f6S
HRAlCHf7ZkAIg8P0oCDlDCYXLVeHwgrqiqSf13Ny72/Kt94hLBJ8VNiOL3ONywzm
QqFjOtBFyxzsKbPn5jHmnr0jcubYTa4W61I1Vp86Sjv6dY0Yqgz0trXyJcflOvUq
wHTB1ZoxVboTG4k3HbQMRm+IRVJsxLduS7+WHWU1eJ0yC/0eVWNwEi40gRBpmLjI
wskQ2Q57mGEdP8Ww7wsNZmPUZnRz6et+L32OhJo6b55EUB9Fhn1MexxfY150LcTR
4S8vWd+RNRuj6pe9+JoXnh/ospbDoeToHW6cCC23lRjjc/y/M5ckiXtsrtXYSCrs
FE+LDTeAdS6r8wNB0hmspLZS4ckpBaUt8ZdGK7R8oh1x7esDdc7fJmMDm7V+H7us
7QdPDOpfjidOokv2k6hQircfyunI9iX3osh2sOjliyFs65x88jf64q6rbVuQoq7N
oRQIkTkruJ9xA0yy3T2+HXDkJaHD5MF2a68TA/psTNl2FReJcjGAmi71ScfiRrCn
Tiyu2aIqwSQWisPzRtu+oyygGQE4IeFiAYZnIdEzjZclsarNofiKib4E+UgDgZkT
YFeM4qjMxgfC18i2QUlmdXz5Pq1ll29GEgVc83mKmGXehMo42URWzIWXAHZU8pCm
dS0Eq+ATIqXnjoGOxMcu
=3yEx
-----END PGP SIGNATURE-----

--sXc4Kmr5FA7axrvy--
