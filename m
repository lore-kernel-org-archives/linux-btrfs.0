Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39810 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753427AbcK2WyS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 17:54:18 -0500
Date: Tue, 29 Nov 2016 17:54:00 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: RFC: raid with a variable stripe size
Message-ID: <20161129225400.GT8685@hungrycats.org>
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
 <657fcefe-4e6c-ced3-a3c9-2dc1f77e1404@cn.fujitsu.com>
 <CAJCQCtR==9wadS=9swcUhHJ77tGksvHMvNd3ZJrpt3+-U779tA@mail.gmail.com>
 <cf02a446-f83d-0d4b-2b60-70a99e18ab39@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6zn93sY2JrH9m7VZ"
In-Reply-To: <cf02a446-f83d-0d4b-2b60-70a99e18ab39@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6zn93sY2JrH9m7VZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2016 at 02:03:58PM +0800, Qu Wenruo wrote:
> At 11/29/2016 01:51 PM, Chris Murphy wrote:
> >On Mon, Nov 28, 2016 at 5:48 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wro=
te:
> >>
> >>
> >>At 11/19/2016 02:15 AM, Goffredo Baroncelli wrote:
> >>>
> >>>Hello,
> >>>
> >>>these are only my thoughts; no code here, but I would like to share it
> >>>hoping that it could be useful.
> >>>
> >>>As reported several times by Zygo (and others), one of the problem of
> >>>raid5/6 is the write hole. Today BTRFS is not capable to address it.
> >>
> >>
> >>I'd say, no need to address yet, since current soft RAID5/6 can't handl=
e it
> >>yet.
> >>
> >>Personally speaking, Btrfs should implementing RAID56 support just like
> >>Btrfs on mdadm.
> >>See how badly the current RAID56 works?
> >>
> >>The marginally benefit of btrfs RAID56 to scrub data better than tradit=
ion
> >>RAID56 is just a joke in current code base.
> >
> >Btrfs is subject to the write hole problem on disk, but any read or
> >scrub that needs to reconstruct from parity that is corrupt results in
> >a checksum error and EIO. So corruption is not passed up to user
> >space. Recent versions of md/mdadm support a write journal to avoid
> >the write hole problem on disk in case of a crash.
>=20
> That's interesting.
>=20
> So I think it's less worthy to support RAID56 in btrfs, especially
> considering the stability.
>=20
> My widest dream is, btrfs calls device mapper to build a micro RAID1/5/6/=
10
> device for each chunk.
> Which should save us tons of codes and bugs.
>=20
> And for better recovery, enhance device mapper to provide interface to ju=
dge
> which block is correct.
>=20
> Although that's just dream anyway.

It would be nice to do that for balancing.  In many balance cases
(especially device delete and full balance after device add) it's not
necessary to rewrite the data in a block group, only copy it verbatim
to a different physical location (like pvmove does) and update the chunk
tree with the new address when it's done.  No need to rewrite the whole
extent tree.

> Thanks,
> Qu
> >
> >>>The problem is that the stripe size is bigger than the "sector size" (=
ok
> >>>sector is not the correct word, but I am referring to the basic unit of
> >>>writing on the disk, which is 4k or 16K in btrfs).
> >>>So when btrfs writes less data than the stripe, the stripe is not fill=
ed;
> >>>when it is filled by a subsequent write, a RMW of the parity is requir=
ed.
> >>>
> >>>On the best of my understanding (which could be very wrong) ZFS try to
> >>>solve this issue using a variable length stripe.
> >>
> >>
> >>Did you mean ZFS record size?
> >>IIRC that's file extent minimum size, and I didn't see how that can han=
dle
> >>the write hole problem.
> >>
> >>Or did ZFS handle the problem?
> >
> >ZFS isn't subject to the write hole. My understanding is they get
> >around this because all writes are COW, there is no RMW.
> >But the
> >variable stripe size means they don't have to do the usual (fixed)
> >full stripe write for just, for example a 4KiB change in data for a
> >single file. Conversely Btrfs does do RMW in such a case.
> >
> >
> >>Anyway, it should be a low priority thing, and personally speaking,
> >>any large behavior modification involving  both extent allocator and bg
> >>allocator will be bug prone.
> >
> >I tend to agree. I think the non-scalability of Btrfs raid10, which
> >makes it behave more like raid 0+1, is a higher priority because right
> >now it's misleading to say the least; and then the longer term goal
> >for scaleable huge file systems is how Btrfs can shed irreparably
> >damaged parts of the file system (tree pruning) rather than
> >reconstruction.
> >
> >
> >
>=20
>=20

--6zn93sY2JrH9m7VZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg+BwgACgkQgfmLGlazG5yhvwCfWKyCj0TKSlp4/rUR4YvUUZOu
0jcAn2Fv9biWPaul4O0hdGeHmr4ZlZtJ
=ZlJK
-----END PGP SIGNATURE-----

--6zn93sY2JrH9m7VZ--
