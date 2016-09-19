Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38586 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750708AbcISEI4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 00:08:56 -0400
Date: Mon, 19 Sep 2016 00:08:55 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        David Sterba <dsterba@suse.cz>, Waxhead <waxhead@online.no>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Is stability a joke? (wiki updated)
Message-ID: <20160919040855.GF21290@hungrycats.org>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <20160912162747.GF16983@twin.jikos.cz>
 <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
 <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
 <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
 <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com>
 <CAJCQCtR_hMPj8Nrf=U1L=WvDWq48Ns1K25p4JtKEJnVwb1231Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7cm2iqirTL37Ot+N"
In-Reply-To: <CAJCQCtR_hMPj8Nrf=U1L=WvDWq48Ns1K25p4JtKEJnVwb1231Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7cm2iqirTL37Ot+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 15, 2016 at 01:02:43PM -0600, Chris Murphy wrote:
> Right, well I'm vaguely curious why ZFS, as different as it is,
> basically take the position that if the hardware went so batshit that
> they can't unwind it on a normal mount, then an fsck probably can't
> help either... they still don't have an fsck and don't appear to want
> one.

ZFS has no automated fsck, but it does have a kind of interactive
debugger that can be used to manually fix things.

ZFS seems to be a lot more robust when it comes to handling bad metadata
(contrast with btrfs-style BUG_ON panics).

When you delete a directory entry that has a missing inode on ZFS,
the dirent goes away.  In the ZFS administrator documentation they give
examples of this as a response in cases where ZFS metadata gets corrupted.

When you delete a file with a missing inode on btrfs, something
(VFS?) wants to check the inode to see if it has attributes that might
affect unlink (e.g. the immutable bit), gets an error reading the
inode, and bombs out of the unlink() before unlink() can get rid of the
dead dirent.  So if you get a dirent with no inode on btrfs on a large
filesystem (too large for btrfs check to handle), you're basically stuck
with it forever.  You can't even rename it.  Hopefully it doesn't happen
in a top-level directory.

ZFS is also infamous for saying "sucks to be you, I'm outta here" when
things go wrong.  People do want ZFS fsck and defrag, but nobody seems
to be bothered much about making those things happen.

At the end of the day I'm not sure fsck really matters.  If the filesystem
is getting corrupted enough that both copies of metadata are broken,
there's something fundamentally wrong with that setup (hardware bugs,
software bugs, bad RAM, etc) and it's just going to keep slowly eating
more data until the underlying problem is fixed, and there's no guarantee
that a repair is going to restore data correctly.  If we exclude broken
hardware, the only thing btrfs check is going to repair is btrfs kernel
bugs...and in that case, why would we expect btrfs check to have fewer
bugs than the filesystem itself?

> I'm not sure if the brfsck is really all that helpful to user as much
> as it is for developers to better learn about the failure vectors of
> the file system.

ReiserFS had no working fsck for all of the 8 years I used it (and still
didn't last year when I tried to use it on an old disk).  "Not working"
here means "much less data is readable from the filesystem after running
fsck than before."  It's not that much of an inconvenience if you have
backups.


--7cm2iqirTL37Ot+N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlffZNcACgkQgfmLGlazG5yJ4gCglnbo9gXPWEWCbCJkEFCLiRiS
NhQAoKZcxXUFit3TYCtnYpA9wA12S73o
=jb0W
-----END PGP SIGNATURE-----

--7cm2iqirTL37Ot+N--
