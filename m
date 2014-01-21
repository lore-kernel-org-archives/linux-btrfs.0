Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58846 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaAUQwY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 11:52:24 -0500
Date: Tue, 21 Jan 2014 16:52:00 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Sandy McArthur <sandymac@gmail.com>,
        Toggenburger Lukas <Lukas.Toggenburger@htwchur.ch>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Working on Btrfs as topic for master thesis
Message-ID: <20140121165200.GF3314@carfax.org.uk>
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
 <52DD148E.3060200@gmail.com>
 <CAPs0BijBB0JTJd_-89Jo3OUozDKN8cCWA27=irBD+UoRShxPiw@mail.gmail.com>
 <52DE6747.4050404@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="udcq9yAoWb9A4FsZ"
In-Reply-To: <52DE6747.4050404@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--udcq9yAoWb9A4FsZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 21, 2014 at 07:25:43AM -0500, Austin S Hemmelgarn wrote:
> On 2014-01-21 01:42, Sandy McArthur wrote:
> > On Mon, Jan 20, 2014 at 7:20 AM, Austin S Hemmelgarn
> > <ahferroin7@gmail.com> wrote:
> >>
> >> On 2014-01-16 14:23, Toggenburger Lukas wrote:
> >>> 3. Improving subvolume handling regarding taking recursive snapshots ( https://btrfs.wiki.kernel.org/index.php/Project_ideas#Take_recursive_snapshots ) and taking snapshots of arbitrary directories ( https://btrfs.wiki.kernel.org/index.php/Project_ideas#Snapshot_arbitrary_directories )
> >>
> >> Another option that I would personally love to see would be support for
> >> write-mostly devices (that is, devices in a RAID1/RAID10 setup that only
> >> get written too unless the data can't be found elsewhere).  This would
> >> in particular provide an alternative to using bcache/dm-cache (namely an
> >> SSD and HDD in RAID1 with the HDD set to write-mostly).
> >> Based on the current development focus, I don't think anybody is working
> >> on this already (I would be, but I don't have either the time or the
> >> skills with kernel programming that would be needed).
> > 
> > Maybe this happens already: Might a similar effect be automatically
> > achieved by tracking per-device I/O load averages and distributing
> > reads based on the I/O loads of possible read devices?
> > 
> That might be the case, it depends on how the I/O load averages are
> calculated.  I actually hadn't realized BTRFS did this, I thought it
> behaved more like MD RAID (that is, distributing the reads among devices
> in a un-weighted round-robin fashion).

   I think David tried that a while ago, and the benchmarks were
actually worse. I'm not sure how much investigation he did into why,
though.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- Quidquid latine dictum sit,  altum videtur. ---           

--udcq9yAoWb9A4FsZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUt6lr1heFHXiqx3kAQL9fxAAjZtaT/EE1L7lFYxTkugRj7v/c3pFDffh
2x9hY9S97ZppGMI0CYbLT7FV9mnPOT3XnmJgoEIYF4Y3X9w+uHIY0Ylqnhx2Bzvz
4pWXbYZjyxZg0yxRItWrLfgOsxejKYnBdXQw4bmxVWapaZnRPbfhPFr4vC34uOIJ
WtE/8/JR/VBBOxQwuaad3hQORxwvPZvPZy0DacMGTlHAKxodibJz+OJ6PWVmhX0O
qhO/iZHk5dZM3/ifkMp9Se5q4xwy7JGyEHutSKoBXE/md371KGb4KB6clgPVgnPS
BxBT1DSpyJuL9yk1sAb3TEHXpKTEaxHI52Lxf0bFLSUZ63IKZV6vX+i8Rj5JivbU
KsF8ed8FNuze6GBsdw9ZX1UYXDE2eAQLJVoftzMN+KMutrLgxLR4ktKFIK9j8AkR
qqaLkjPeH6NAFhX+ffUxcHYsnLvtj8jn4XnziGJqg2IkS6JrFS+/UJRSZ25h8nAQ
Net/HAhf6reBK1GOPcheJnNU/IIcLoguhMEouw+k6V3jUekZpH2W270CuOJDj6eK
xFtgcN1xXVZ1WdkRkulCYbZzbkn/tVIEny0pGJdzzEoVeo1Y/yxstkbmo0jaKCjS
5CYn+Vxs86fiNY7osI7gAAgLjWBfuyDFH3SiEdLXi56ur6cjikXR3VRu5gmRa0LZ
Lolpjr58daA=
=yoI9
-----END PGP SIGNATURE-----

--udcq9yAoWb9A4FsZ--
