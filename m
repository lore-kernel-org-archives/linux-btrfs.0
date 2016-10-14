Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47756 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753369AbcJNTzr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 15:55:47 -0400
Date: Fri, 14 Oct 2016 15:55:45 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161014195544.GZ21290@hungrycats.org>
References: <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com>
 <20161012043718.GW21290@hungrycats.org>
 <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com>
 <20161012171936.GD26140@hungrycats.org>
 <16a02312-a74c-6e2d-08ae-7fa479823341@cn.fujitsu.com>
 <20161013210346.GY21290@hungrycats.org>
 <d1646e74-004d-737f-671a-4ca30f518819@cn.fujitsu.com>
 <CAJCQCtRxN+5+8Kfr8TM8+gVx62CUQ+Vhkiz7auWJa_tYKZVsXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7ohyzAr2DuZRs7WU"
In-Reply-To: <CAJCQCtRxN+5+8Kfr8TM8+gVx62CUQ+Vhkiz7auWJa_tYKZVsXA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7ohyzAr2DuZRs7WU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 14, 2016 at 01:16:05AM -0600, Chris Murphy wrote:
> OK so we know for raid5 data block groups there can be RMW. And
> because of that, any interruption results in the write hole. On Btrfs
> thought, the write hole is on disk only. If there's a lost strip
> (failed drive or UNC read), reconstruction from wrong parity results
> in a checksum error and EIO. That's good.
>=20
> However, what happens in the metadata case? If metadata is raid5, and
> there's a crash or power failure during metadata RMW, same problem,
> wrong parity, bad reconstruction, csum mismatch, and EIO. So what's
> the effect of EIO when reading metadata?=20

The effect is you can't access the page or anything referenced by
the page.  If the page happens to be a root or interior node of
something important, large parts of the filesystem are inaccessible,
or the filesystem is not mountable at all.  RAID device management and
balance operations don't work because they abort as soon as they find
the first unreadable metadata page.

In theory it's still possible to rebuild parts of the filesystem offline
using backrefs or brute-force search.  Using an old root might work too,
but in bad cases the newest viable root could be thousands of generations
old (i.e. it's more likely that no viable root exists at all).

> And how common is RMW for metadata operations?

RMW in metadata is the norm.  It happens on nearly all commits--the only
exception seems to be when both ends of a commit write happen to land
on stripe boundaries accidentally, which is less than 1% of the time on
3 disks.

> I wonder where all of these damn strange cases where people can't do
> anything at all with a normally degraded raid5 - one device failed,
> and no other failures, but they can't mount due to a bunch of csum
> errors.

I'm *astonished* to hear about real-world successes with raid5 metadata.
The total-loss failure reports are the result I expect.

The current btrfs raid5 implementation is a thin layer of bugs on top
of code that is still missing critical pieces.  There is no mechanism to
prevent RMW-related failures combined with zero tolerance for RMW-related
failures in metadata, so I expect a btrfs filesystem using raid5 metadata
to be extremely fragile.  Failure is not likely--it's *inevitable*.

The non-RMW-aware allocator almost maximizes the risk of RMW data loss.
Every transaction commit contains multiple tree root pages, which
are the most critical metadata that could be lost due to RMW failure.
There is a window at least a few milliseconds wide, and potentially
several seconds wide, where some data on disk is in an unrecoverable
state due to RMW.  This happens twice a minute with the default commit
interval and 99% of commits are affected.  That's a million opportunities
per machine-year to lose metadata.  If a crash lands on one of those,
boom, no more filesystem.

I expect one random crash (i.e. a crash that is not strongly correlated
to RMW activity) out of 30-2000 (depending on filesystem size, workload,
rotation speed, btrfs mount parameters) will destroy a filesystem under
typical conditions.  Real world crashes tend not to be random (i.e. they
are strongly correlated to RMW activity), so filesystem loss will be
much more frequent in practice.


>=20
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--7ohyzAr2DuZRs7WU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgBOEAACgkQgfmLGlazG5zwsgCeOgnxh/GIeRvi4lL6FQXD0r/w
t8wAnigzBScN7A99RJuiXOfOe3qzVHel
=Eig1
-----END PGP SIGNATURE-----

--7ohyzAr2DuZRs7WU--
