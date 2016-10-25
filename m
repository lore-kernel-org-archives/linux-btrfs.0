Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34563 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932604AbcJYB0Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 21:26:16 -0400
Received: by mail-oi0-f47.google.com with SMTP id t73so67847189oie.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Oct 2016 18:26:15 -0700 (PDT)
Date: Mon, 24 Oct 2016 21:26:06 -0400
From: Nicholas Steeves <nsteeves@gmail.com>
To: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Scrubbing Errors after restoring backup
Message-ID: <20161025012606.GA6752@DigitalMercury.dynalias.net>
References: <CAA3ktqnHVmYS_LdVq5AmWLb0fY27Rw_vy-YqKHHqwDy696+LTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
In-Reply-To: <CAA3ktqnHVmYS_LdVq5AmWLb0fY27Rw_vy-YqKHHqwDy696+LTA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24 October 2016 at 17:53, Stefan Malte Schumacher <stefan.m.schumacher@g=
mail.com> wrote:
> Hello
>
> For reference please see this post.
> https://mail-archive.com/linux-btrfs@vger.kernel.org/msg58461.html
> Please note that I downgraded to btrfs-progs 4.6.1 as advised.
>
> After exchanging the malfunctioning drive I re-created the filesystem
> and restored the backup from my NAS. (I didnt entirely trust the
> filesystem after so many errors) On completing the restoration I
> manually started scrubbing, which ended with hundreds of checksum and
> read errors on /dev/sda.
> The drive checks out fine in smart and passed through all scheduled
> SMART Self-Tests. The model is not identical to the two drives
> recently added to the system - the new drives are WD Blue, the four
> original ones are WD Greens.
>
> I have resetted the output from btrfs dev stats and restarted the
> scrubbing process. I am unsure how to interpret or explain the errors
> of the last scrub run. I scrubbed regularly each month for nearly
> three years and never had any errors. I would be grateful for any
> advice how to proceed.
>
> Yours sincerely
> Stefan

Hi Stefan,

What kernel version are you using?  Was the backup a file-level
archive or a btrfs send stream?  I'm confused about the evolution your
hardware.  Originally you had four disk raid1?  Or a dix disk raid1?
The one that failed was /dev/sdf, which seems to suggest:

/dev/sdc - WD green
/dev/sdd - WD green
/dev/sde - WD green
/dev/sdf - WD green <- failed

I would expect that the new volume is something like:

/dev/sdc - New unnamed model or 3 year old WD Green?
/dev/sdd - New unnamed model or 3 year old WD Green?
/dev/sde - New WD Blue
/dev/sdf - New WD Blue

Did you move the sata cables to use:

/dev/sda - Unknown. New disk or 3 year old disk?
/dev/sdb - Unknown. New disk or 3 year old disk?
/dev/sdc - New WD Blue
/dev/sdd - New WD Blue

And this is a freshly-created btrfs volume?  When you restored from
backup, your hard drive firmware should have detected any bad sectors
and relocated the write to a reserve sector, and I'm assuming none of
the logs have anything in them that would indicate a failed
write.  If sda is from the 3 year old batch of WD greens I would
distrust it.  Frequent culprits of similar problems are flaky sata
cables or a flaky PSU.  In the case of flaky sata cables, dmesg
(usually?) shows PHY and "hard resetting link" errors.

I also wonder if the sata0 port on your motherboard might be bad.  The
only reason I mention this is because I've seen two H67/P67
cougarpoint chipset motherboards lose their sata0 channel.  It also
happens with other brands' chipsets...

Whatever the case, when stuff like this happened to me I've always
used something like a combination of a cpuburnP6 per logical CPU,
memtester (in Linux; do this after a clean 24h memtest86+ run), a huge
and intense bonnie++ run, with as many things plugged into the USB
ports as possible--including charging at least one high-power
device--while burning a DVD and/or running something that stresses the
GPU...to try to shake down potential PSU issues.  Maybe passmark
(under Linux) has similar functionality with an easier interface?
I've also used parallel diskscan (https://github.com/baruch/diskscan)
runs to test old disks and to check for statistical anomalies.  If you
do:

1. use tape to number your cables; record which drives are connected
into which sata ports with which cables.  Do simultaneous runs of
diskscan on /dev/disk/by-id/$relevant_disks, check dmesg, and record
the results.
2. unplug sata cables from drives and shuffle; document specifics and
test.
3. unplug sata cables from motherboard and shuffle; document
specifics and test.

For the cost of new sata cables, you might as well just buy new ones
because then these tests can be used to check for bad ones among the
new cables; it's a better use of time, because it's possible that
you'll detect a bad cable, replace it, test the new cable, and find
out that the new cable is defective.  Fountain of Bad Luck=E2=84=A2 <- If
something can fail, it will fail when I use it ;-)

That said, I've never tested a WD green drive...the reds' performance
smoothly decreases towards the end of the drive (outer tracks are
quite a bit faster than inner tracks).  For all I know the greens have
erratic performance baked into their power-saving design...  If
there's consistently a latency spike at the same location for the test
associated with a particular drive that can indicate a relocated bad
sector.  Does anyone know if this method reliably indicates when a
drive is lying about its SMART 5 Reallocated_Sector_Ct report?

Cheers,
Nicholas

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJYDrSuAAoJEFqIMEdffRBh/V4P/0pL23ffhuCauQfsVc/2RUx6
EYP+Ft4YfiG1oCD6Ht6OrWwEKdEZXCnoNWTDBb89ZBnPYBYlwIJEf3jEIthfeF/U
obIMl+AmVKg82igSqaTk3wnKGsVOIg0zSJw39OixD05A/lzHio0jqz4+qbYNvs7y
/YJ7ikTEXnp2jCgqG376wRZAoHM9pjy2KoB5d54s/BvkO15ClpTkhE49NJgpEopm
BRRcF2ASZ7l5QHL0aoPnoXR5IMEZlRy2daA6gvTuiltdQs3/O4gZnHscpjRBvLSF
BjsTsULu9fnBveqr7D1TVjcJIm2EXVcE3kwG94ayktzc5sH719OdM4yr9ZNGKXiw
AtfpUqXXYlfqtdrFJqKrom4xEAqSkEw/4h/UK4tXmujDJLY9m2yTzFCv/h0iknbX
2jAB0h76HmgknDXh/69UypWczhqqYROOAjRMe1tpEKVHWZuVZCyxCB/BjmANUCH9
Hlx1EJAjfaAiS7LBEeFhSCQs1B+yhg0WzfPeECora+jZYOjH7kYF3oP3bbB2bEbE
yxZ7H/tijmSeXTzt//WkJ6ixKnVrBmsVfqTrULok4Yne5oCCtrfMD7CcV1I+RW/p
GS5uEdzygp/5+Pm32ngkzMpxqo//+bDzNPlJWKXr90mYsJfOVtcMq3TW1E0b5c69
v9ENYrx8PLlqbYik9uIQ
=reJY
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
