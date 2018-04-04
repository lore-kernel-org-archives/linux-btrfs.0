Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46958 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751098AbeDDGU3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Apr 2018 02:20:29 -0400
Date: Wed, 4 Apr 2018 02:20:27 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Status of RAID5/6
Message-ID: <20180404062024.GL2446@hungrycats.org>
References: <20180401034544.GA28769@hungrycats.org>
 <CAJCQCtSrcFD7jTbrqsWZFWrKUrMp4wW0QhkPApB-pgA-O3WksA@mail.gmail.com>
 <CAJCQCtTXQGbVjRLegC25DDokcv4Wph6O04s=C_rzp8n5jRpt5Q@mail.gmail.com>
 <20180402054521.GC28769@hungrycats.org>
 <df74c8a6-b748-20c5-8bef-eb261b645b29@inwind.it>
 <7c76dae7-b38c-d514-4284-1cd093f5bcac@gmail.com>
 <20180402222250.GH2446@hungrycats.org>
 <20180403003102.GI2446@hungrycats.org>
 <242e2515-fad2-e98d-3e59-c0838362afdc@inwind.it>
 <CAJCQCtR+iFAHFQJw1LdmMmca1NQQgTqGZ0kNUnxn-ctU5Dze1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jtcAeju3WzRmRF+o"
In-Reply-To: <CAJCQCtR+iFAHFQJw1LdmMmca1NQQgTqGZ0kNUnxn-ctU5Dze1g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jtcAeju3WzRmRF+o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 03, 2018 at 09:08:01PM -0600, Chris Murphy wrote:
> On Tue, Apr 3, 2018 at 11:03 AM, Goffredo Baroncelli <kreijack@inwind.it>=
 wrote:
> > On 04/03/2018 02:31 AM, Zygo Blaxell wrote:
> >> On Mon, Apr 02, 2018 at 06:23:34PM -0400, Zygo Blaxell wrote:
> >>> On Mon, Apr 02, 2018 at 11:49:42AM -0400, Austin S. Hemmelgarn wrote:
> >>>> On 2018-04-02 11:18, Goffredo Baroncelli wrote:
> >>>>> I thought that a possible solution is to create BG with different
> >>>> number of data disks. E.g. supposing to have a raid 6 system with 6
> >>>> disks, where 2 are parity disk; we should allocate 3 BG
> >>>>> BG #1: 1 data disk, 2 parity disks
> >>>>> BG #2: 2 data disks, 2 parity disks,
> >>>>> BG #3: 4 data disks, 2 parity disks
> >>>>>
> >>>>> For simplicity, the disk-stripe length is assumed =3D 4K.
> >>>>>
> >>>>> So If you have a write with a length of 4 KB, this should be placed
> >>>> in BG#1; if you have a write with a length of 4*3KB, the first 8KB,
> >>>> should be placed in in BG#2, then in BG#1.
> >>>>> This would avoid space wasting, even if the fragmentation will
> >>>> increase (but shall the fragmentation matters with the modern solid
> >>>> state disks ?).
> >>> I don't really see why this would increase fragmentation or waste spa=
ce.
> >
> >> Oh, wait, yes I do.  If there's a write of 6 blocks, we would have
> >> to split an extent between BG #3 (the first 4 blocks) and BG #2 (the
> >> remaining 2 blocks).  It also flips the usual order of "determine size
> >> of extent, then allocate space for it" which might require major surge=
ry
> >> on the btrfs allocator to implement.
> >
> > I have to point out that in any case the extent is physically interrupt=
ed at the disk-stripe size. Assuming disk-stripe=3D64KB, if you want to wri=
te 128KB, the first half is written in the first disk, the other in the 2nd=
 disk.  If you want to write 96kb, the first 64 are written in the first di=
sk, the last part in the 2nd, only on a different BG.
> > So yes there is a fragmentation from a logical point of view; from a ph=
ysical point of view the data is spread on the disks in any case.
> >
> > In any case, you are right, we should gather some data, because the per=
formance impact are no so clear.
>=20
> They're pretty clear, and there's a lot written about small file size
> and parity raid performance being shit, no matter the implementation
> (md, ZFS, Btrfs, hardware maybe less so just because of all the
> caching and extra processing hardware that's dedicated to the task).

Pretty much everything goes fast if you put a faster non-volatile cache
in front of it.

> The linux-raid@ list is full of optimizations for this that are use
> case specific. One of those that often comes up is how badly suited
> raid56 are for e.g. mail servers, tons of small file reads and writes,
> and all the disk contention that comes up, and it's even worse when
> you lose a disk, and even if you're running raid 6 and lose two disk
> it's really god awful. It can be unexpectedly a disqualifying setup
> without prior testing in that condition: can your workload really be
> usable for two or three days in a double degraded state on that raid6?
> *shrug*
>=20
> Parity raid is well suited for full stripe reads and writes, lots of
> sequential writes. Ergo a small file is anything less than a full
> stripe write. Of course, delayed allocation can end up making for more
> full stripe writes. But now you have more RMW which is the real
> performance killer, again no matter the raid.

RMW isn't necessary if you have properly configured COW on top.
ZFS doesn't do RMW at all.  OTOH for some workloads COW is a step in a
different wrong direction--the btrfs raid5 problems with nodatacow
files can be solved by stripe logging and nothing else.

Some equivalent of autodefrag that repacks your small RAID stripes
into bigger ones will burn 3x your write IOPS eventually--it just
lets you defer the inevitable until a hopefully more convenient time.
A continuously loaded server never has a more convenient time, so it
needs a different solution.

> > I am not worried abut having different BG; we have problem with these b=
ecause we never developed tool to handle this issue properly (i.e. a daemon=
 which starts a balance when needed). But I hope that this will be solved i=
n future.
> >
> > In any case, the all solutions proposed have their trade off:
> >
> > - a) as is: write hole bug
> > - b) variable stripe size (like ZFS): big impact on how btrfs handle th=
e extent. limited waste of space
> > - c) logging data before writing: we wrote the data two times in a shor=
t time window. Moreover the log area is written several order of magnitude =
more than the other area; there was some patch around
> > - d) rounding the writing to the stripe size: waste of space; simple to=
 implement;
> > - e) different BG with different stripe size: limited waste of space; l=
ogical fragmentation.
>=20
> I'd say for sure you're worse off with metadata raid5 vs metadata
> raid1. And if there are many devices you might be better off with
> metadata raid1 even on a raid6, it's not an absolute certainty you
> lose the file system with a 2nd drive failure - it depends on the
> device and what chunk copies happen to be on it. But at the least if
> you have a script or some warning you can relatively easily rebalance
> ... HMMM
>=20
> Actually that should be a test. Single drive degraded raid6 with
> metadata raid1, can you do a metadata only balance to force the
> missing copy of metadata to be replicated again? In theory this should
> be quite fast.

I've done it, but it's not as fast as you might hope.  Metadata balances
95% slower than data, and seeks pretty hard (stressing the surviving
drives and sucking performance) while it does so.  Also you're likely to
have to fix or work around a couple of btrfs bugs while you do it.

>=20
>=20
> --=20
> Chris Murphy

--jtcAeju3WzRmRF+o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWsRunQAKCRCB+YsaVrMb
nNXeAJ9hY+7OAMPwGsKTL7UcZeQJTeJb6QCeLgUnHhTrqfxbIwc2nGDNqDZKwy4=
=799c
-----END PGP SIGNATURE-----

--jtcAeju3WzRmRF+o--
