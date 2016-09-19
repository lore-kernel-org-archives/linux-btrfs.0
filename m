Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39638 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751790AbcISUPD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 16:15:03 -0400
Date: Mon, 19 Sep 2016 16:15:01 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Waxhead <waxhead@online.no>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Is stability a joke? (wiki updated)
Message-ID: <20160919201501.GB4703@hungrycats.org>
References: <20160912142714.GE16983@twin.jikos.cz>
 <20160912162747.GF16983@twin.jikos.cz>
 <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
 <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
 <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
 <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com>
 <CAJCQCtR_hMPj8Nrf=U1L=WvDWq48Ns1K25p4JtKEJnVwb1231Q@mail.gmail.com>
 <20160919040855.GF21290@hungrycats.org>
 <7c55ba5a-9193-d88f-e92f-b5f34f99ce57@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
In-Reply-To: <7c55ba5a-9193-d88f-e92f-b5f34f99ce57@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 19, 2016 at 01:38:36PM -0400, Austin S. Hemmelgarn wrote:
> >>I'm not sure if the brfsck is really all that helpful to user as much
> >>as it is for developers to better learn about the failure vectors of
> >>the file system.
> >
> >ReiserFS had no working fsck for all of the 8 years I used it (and still
> >didn't last year when I tried to use it on an old disk).  "Not working"
> >here means "much less data is readable from the filesystem after running
> >fsck than before."  It's not that much of an inconvenience if you have
> >backups.
> For a small array, this may be the case.  Once you start looking into double
> digit TB scale arrays though, restoring backups becomes a very expensive
> operation.  If you had a multi-PB array with a single dentry which had no
> inode, would you rather be spending multiple days restoring files and
> possibly losing recent changes, or spend a few hours to check the filesystem
> and fix it with minimal data loss?

I'd really prefer to be able to delete the dead dentry with 'rm' as root,
or failing that, with a ZDB-like tool or ioctl, if it's the only known
instance of such a bad metadata object and I already know where it's
located.

Usually the ultimate failure mode of a btrfs filesystem is a read-only
filesystem from which you can read most or all of your data, but you
can't ever make it writable again because of fsck limitations.

The one thing I do miss about every filesystem that isn't ext2/ext3 is
automated fsck that prioritizes availability, making the filesystem
safely writable even if it can't recover lost data.  On the other
hand, fixing an ext[23] filesystem is utterly trivial compared to any
btree-based filesystem.


--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfgR0UACgkQgfmLGlazG5y5GgCgxjc6FcTdByOQNwzCpCCOicrE
/OgAnilIcP/DAA+s7JvWVf9/r2thEDoZ
=rGDv
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
