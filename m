Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56981 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbdFTXZl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 19:25:41 -0400
Date: Tue, 20 Jun 2017 23:25:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: waxhead <waxhead@dirtcellar.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Exactly what is wrong with RAID5/6
Message-ID: <20170620232525.GF7140@carfax.org.uk>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
In-Reply-To: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 21, 2017 at 12:57:19AM +0200, waxhead wrote:
> I am trying to piece together the actual status of the RAID5/6 bit of BTRFS.
> The wiki refer to kernel 3.19 which was released in February 2015 so
> I assume that the information there is a tad outdated (the last
> update on the wiki page was July 2016)
> https://btrfs.wiki.kernel.org/index.php/RAID56
> 
> Now there are four problems listed
> 
> 1. Parity may be inconsistent after a crash (the "write hole")
> Is this still true, if yes - would not this apply for RAID1 / RAID10
> as well? How was it solved there , and why can't that be done for
> RAID5/6

   Yes, it's still true, and it's specific to parity RAID, not the
other RAID levels. The issue is (I think) that if you write one block,
that block is replaced, but then the other blocks in the stripe need
to be read for the parity block to be recalculated, before the new
parity can be written. There's a read-modify-write cycle involved
which isn't inherent for the non-parity RAID levels (which would just
overwrite both copies).

   One of the proposed solutions for dealing with the write hole in
btrfs's parity RAID is to ensure that any new writes are written to a
completely new stripe. The problem is that this introduces a whole new
level of fragmentation if the FS has lots of small writes (because
your write unit is limited to a complete stripe, even for a single
byte update).

   There are probably others here who can explain this better. :)

> 2. Parity data is not checksummed
> Why is this a problem? Does it have to do with the design of BTRFS somehow?
> Parity is after all just data, BTRFS does checksum data so what is
> the reason this is a problem?

   It increases the number of unrecoverable (or not-guaranteed-
recoverable) cases. btrfs's csums are based on individual blocks on
individual devices -- each item of data is independently checksummed
(even if it's a copy of something else). On parity RAID
configurations, if you have a device failure, you've lost a piece of
the parity-protected data. To repair it, you have to recover from n-1
data blocks (which are checksummed), and one parity block (which
isn't). This means that if the parity block happens to have an error
on it, you can't recover cleanly from the device loss, *and you can't
know that an error has happened*.

> 3. No support for discard? (possibly -- needs confirmation with cmason)
> Does this matter that much really?, is there an update on this?
> 
> 4. The algorithm uses as many devices as are available: No support
> for a fixed-width stripe.
> What is the plan for this one? There was patches on the mailing list
> by the SnapRAID author to support up to 6 parity devices. Will the
> (re?) resign of btrfs raid5/6 support a scheme that allows for
> multiple parity devices?

   That's a problem because it limits the practical number of devices
you can use. When the stripe size gets too large, you're having to
read/modify/(re)write every device on an update, even for very small
updates -- as this ratio of update-size to read-size goes up, the FS
has increasingly bad performance. Your personal limits of what's
acceptable will vary, but I'd be surprised to find anyone with, say,
40 parity RAID devices who finds their performance acceptable. Limit
the stripe width, and you can limit the performance degradation from
lots of devices.

   Even with a limited stripe width, however, you're still looking at
decreasing reliability as the number of devices increases...

   It shouldn't be *massively* hard to implement, but there's a load
of opportunities around managing RAID options in general that would
probably need to be addressed at the same time (e.g. per-subvol RAID
settings, more general RAID parameterisation). It's going to need some
fairly major properties handling, plus rewriting the chunk allocator
and pushing the allocator decisions quite a way up from where they're
currently made.

> I do have a few other questions as well...
> 
> 5. BTRFS does still (kernel 4.9) not seem to use the device ID to
> communicate with devices.
> 
> If you on a multi device filesystem yank out a device, for example
> /dev/sdg and it reappear as /dev/sdx for example btrfs will still
> happily try to write to /dev/sdg even if btrfs fi sh /mnt shows the
> correct device ID. What is the status for getting BTRFS to properly
> understand that a device is missing?

   I don't know about this one.

> 6. RAID1 needs to be able to make two copies always. E.g. if you
> have three disks you can loose one and it should still work. What
> about RAID10 ? If you have for example 6 disk RAID10 array, loose
> one disk and reboots (due to #5 above). Will RAID10 recognize that
> the array now is a 5 disk array and stripe+mirror over 2 disks (or
> possibly 2.5 disks?) instead of 3? In other words, will it work as
> long as it can create a RAID10 profile that requires a minimum of
> four disks?

   Yes. RAID-10 will work on any number of devices (>=4), not just an
even number. Obviously, if you have a 6-device array and lose one,
you'll need to deal with the loss of redundancy -- either add a new
device and rebalance, or replace the missing device with a new one, or
(space permitting) rebalance with existing devices.

   Hugo.

-- 
Hugo Mills             | Let me past! There's been a major scientific
hugo@... carfax.org.uk | break-in!
http://carfax.org.uk/  | Through! Break-through!
PGP: E2AB1DE4          |                                          Ford Prefect

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZSa7lAAoJEFheFHXiqx3kHT4P/A4EUKFeT+eMxCVER8/U9K9h
fISKtu8JZGYrMlWziV+Z92wu0KrCrpbl8P0pp3yZfoa6dsqXz+N8Y4ghWeMc/aQn
ZzoMhTy4Oqs5F8MU4TZqNeF7NRf+3zS0kNzonaAA3JSIehq3F39/8zSRZHu+q9mC
HzjtWmbsBtE2j9FZD/Xlh4bzENsJjkTiDV/REZkQzX1ifqzcHMK31e+JwlkdzDhq
ZV+UZoFP4vB1xgK3Zow3wfCI1hdRyfoBDK7/K3/HMsudEroAh29Lc/8mJr2yXq3k
AXfu7q+ZIyCQm4TYNFZQDWwPeBU9PeoCd6lLChCQvU4xLtEWM+HzDFXz0/YJOyCK
MuE5ncB7B2ZkPK+FoaUsd4kUY6LhMCzdvNPWc9gIPemyozFgBraAb5CWzkqgu1cb
jQSHWCb//F48LoWpa+KuhLMOdsk5FmUO49Y6qF0YIhnWETqrW1hI0BLktabKUEYC
vnlXmlfkBzXC4cPxuOSY/7+mN0pPWd0cLt/bdiC2x0ilAs7SARA1F3DmuxX5+H5g
akM1jkt527hGTFJIthN49FpqdLu64Cn7E+HSRb8czZPIRq9Dqtgqshh4RxGOZtV6
RQobNaLNXxRRidd22RpDI+uQ7qc4yGKV6Nk1sBTK3TIZPVhL6gWYYNpTVnrYr7+o
eXIk/VzfLKhjFxsCIN3A
=olN7
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
