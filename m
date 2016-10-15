Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39440 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751722AbcJODUC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 23:20:02 -0400
Date: Fri, 14 Oct 2016 23:19:07 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161015031906.GA21290@hungrycats.org>
References: <20161012043718.GW21290@hungrycats.org>
 <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com>
 <20161012171936.GD26140@hungrycats.org>
 <16a02312-a74c-6e2d-08ae-7fa479823341@cn.fujitsu.com>
 <20161013210346.GY21290@hungrycats.org>
 <d1646e74-004d-737f-671a-4ca30f518819@cn.fujitsu.com>
 <CAJCQCtRxN+5+8Kfr8TM8+gVx62CUQ+Vhkiz7auWJa_tYKZVsXA@mail.gmail.com>
 <20161014195544.GZ21290@hungrycats.org>
 <CAJCQCtQCRiM2MPJt9cwQC37tTJiJoiZj5X5bwg-NDxpNaLvB7g@mail.gmail.com>
 <CAJCQCtSCmGQmKfNWrzO6Nzodf2Q8rZ0qiNsMoXbZpxxT==QKWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="72pTQ1Q5L511SwPT"
In-Reply-To: <CAJCQCtSCmGQmKfNWrzO6Nzodf2Q8rZ0qiNsMoXbZpxxT==QKWA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--72pTQ1Q5L511SwPT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 14, 2016 at 04:30:42PM -0600, Chris Murphy wrote:
> Also, is there RMW with raid0, or even raid10?=20

No.  Mirroring is writing the same data in two isolated places.  Striping
is writing data at different isolated places.  No matter which sectors
you write through these layers, it does not affect the correctness of
data in any sector at a different logical address.  None of these use
RMW--you read or write only complete sectors and act only on the specific
sectors requested.  Only parity RAID does RMW.

e.g. in RAID0, when you modify block 47, you may actually modify block
93 on a different disk, but there's always a 1:1 mapping between every
logical and physical address.  If there is a crash we go back to an
earlier tree that does not contain block 47/93 so we don't care if the
write was interrupted.

e.g. in RAID1, when you modify block 47, you modify physical block 47 on
two separate disks.  The state of disk1-block47 may be different from
the state of disk2-block47 if the write is interrupted.  If there is a
crash we go back to an earlier tree that does not contain either copy
of block 47 so we don't care about any inconsistency there.

So raid0, single, dup, raid1, and raid10 are OK--they fall into one or
both of the above cases.  CoW works there.  None of these properties
change in degraded mode with the mirroring profiles.

Parity RAID is writing data in non-isolated places.  When you write to
some sectors, additional sectors are implicitly modified in degraded mode
(whether you are in degraded mode at the time of the writes or not).
This is different from the other cases because the other cases never
modify any sectors that were not explicitly requested by the upper layer.
This is OK if and only if the CoW layer is aware of this behavior and
works around it.

> Or is that always CoW
> for metadata and data, just like single and dup?=20

It's always CoW at the higher levels, even for parity RAID.  The problem
is that the CoW layer is not aware of the RMW behavior buried in the
parity RAID layer, so the combination doesn't work properly.

CoW thinks it's modifying only block 47, when in fact it's modifying
an entire stripe in degraded mode.  Let's assume 5-disk RAID5 with a
strip size of one block for this example, and say blocks 45-48 are one
RAID stripe.  If there is a crash, data in blocks 45, 46, 47, and 48
may be irretrievably damaged by inconsistent modification of parity and
data blocks.  When we try to go back to an earlier tree that does not
contain block 47, we will end up with a tree that contains corruption in
one of the blocks 45, 46, or 48.  This corruption will only be visible
when something else goes wrong (parity mismatch, data csum failure,
disk failure, or scrub) so a damaged filesystem that isn't degraded
could appear to be healthy for a long time.

If the CoW layer is aware of this, it can arrange operations such
that no stripe is modified while it is referenced by a committed tree.
Suppose the stripe at blocks 49-52 is empty, so we write our CoW block at
block 49 instead of 47.  Since blocks 50-52 contain no data we care about,
we don't even have to bother reading them (just fill the other blocks
with zero or find some other data to write in the same commit), and we
can eliminate many slow RMW operations entirely*.  If there is a crash
we just fall back to an earlier tree that does not contain block 49.
This tree is not damaged because we left blocks 45-48 alone.

One way to tell this is done right is all data in each RAID stripe will
always belong to exactly zero or one transaction, not dozens of different
transactions as stripes have now.

The other way to fix things is to make stripe RMW atomic so that CoW
works properly.  You can tell this is done right if you can find a stripe
update journal in the disk format or the code.

> If raid0 is always
> CoW, then I don't think it's correct to consider raid5 minus parity to
> be anything like raid0 - in a Btrfs context anyway. Outside of that
> context, I understand the argument.
>=20
>=20
>=20
> --=20
> Chris Murphy

[*] We'd still need parity RAID RMW for nodatacow and PREALLOC because
neither uses the CoW layer.  That doesn't matter for nodatacow because
nodatacow is how users tell us they don't want to read their data any
more, but it has interesting implications for PREALLOC.  Maybe a solution
for PREALLOC is to do the first write strictly in RAID-stripe-sized units?

--72pTQ1Q5L511SwPT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAlgBoCoACgkQgfmLGlazG5wJWACfXOWw/yc7eGB1APjP0C+sSjaE
+0UAmKHgJJlA/hvUVbpoYDcAxaOVRzE=
=6F7e
-----END PGP SIGNATURE-----

--72pTQ1Q5L511SwPT--
