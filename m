Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47509 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaBYUk0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 15:40:26 -0500
Date: Tue, 25 Feb 2014 20:40:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marcus Sundman <sundman@iki.fi>
Cc: linux-btrfs@vger.kernel.org, Jim Salter <jim@jrs-s.net>
Subject: Re: No space left on device (again)
Message-ID: <20140225204001.GC13899@carfax.org.uk>
References: <530CC9B0.1080703@iki.fi>
 <530CDB7F.9020807@jrs-s.net>
 <20140225201921.GB13899@carfax.org.uk>
 <530CFCCE.5060707@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5QAgd0e35j3NYeGe"
In-Reply-To: <530CFCCE.5060707@iki.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2014 at 10:27:58PM +0200, Marcus Sundman wrote:
> On 25.02.2014 22:19, Hugo Mills wrote:
> >On Tue, Feb 25, 2014 at 01:05:51PM -0500, Jim Salter wrote:
> >>370GB of 410GB used isn't really "fine", it's over 90% usage.
> >>
> >>That said, I'd be interested to know why btrfs fi show /dev/sda3
> >>shows 412.54G used, but btrfs fi df /home shows 379G used...
> >    This is an FAQ...
> >
> >    btrfs fi show tells you how much is allocated out of the available
> >pool on each disk. btrfs fi df then shows how much of that allocated
> >space (in each category) is used.
> 
> What is the difference between the "used 371.11GB" and the "used
> 412.54GB" displayed by "btrfs fi show"?

   The first and smaller value is (in this case) the sum of all the
"used" values in the output of btrfs fi df. The second is the total
amount of raw disk space that has been allocated. (Yes, this is a bit
of a mess -- there's been discussions recently about improving the
output).

> >    The problem here is also in the FAQ: the metadata is close to full
> >-- typically something like 500-750 MiB of headroom is needed in
> >metadata. The FS can't allocate more metadata because it's allocated
> >everything already (total=used in btrfs fi show), so the solution is
> >to do a filtered balance:
> >
> >btrfs balance start -dusage=5 /mountpoint
> 
> Of course that was the first thing I tried, and it didn't help *at* *all*:
> 
> ># btrfs filesystem balance start -dusage=5 /home
> >Done, had to relocate 0 out of 415 chunks
> >#
> 
> ... and it really didn't free anything.

   OK, so crank up the number to 10 and try again. If that still moves
nothing, then increase again until it frees up something. With an FS
at 90% full or so, particularly if it's seen heavy use, the chances
are reasonable that all of the chunks are over 5% full, so putting the
value up will eventually get to the point of moving at least one
chunk, which should be all that's needed at this point.

   Hugo.

> >>On 02/25/2014 11:49 AM, Marcus Sundman wrote:
> >>>Hi
> >>>
> >>>I get "No space left on device" and it is unclear why:
> >>>
> >>>># df -h|grep sda3
> >>>>/dev/sda3       413G  368G   45G  90% /home
> >>>># btrfs filesystem show /dev/sda3
> >>>>Label: 'home'  uuid: 46279061-51f4-40c2-afd0-61d6faab7f60
> >>>>    Total devices 1 FS bytes used 371.11GB
> >>>>    devid    1 size 412.54GB used 412.54GB path /dev/sda3
> >>>>
> >>>>Btrfs v0.20-rc1
> >>>># btrfs filesystem df /home
> >>>>Data: total=410.52GB, used=369.61GB
> >>>>System: total=4.00MB, used=64.00KB
> >>>>Metadata: total=2.01GB, used=1.50GB
> >>>>#
> >>>So, 'data' and 'metadata' seem to be fine(?), but 'system' is a
> >>>bit low. Is that it? If so, can I do something about it? Or should
> >>>I look somewhere else?
> >>>
> >>>I really wish I could get a warning before running out of disk
> >>>space, instead of everything breaking suddenly when there seems to
> >>>be lots and lots of space left.
> >>>
> >>>- Marcus
> >>>
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Jazz is the sort of music where no-one plays anything the ---    
                             same way once.                              

--5QAgd0e35j3NYeGe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUwz/oVheFHXiqx3kAQI/Ww//Qz2G3GBHwnxQXvI1B71g9M76J2lQD3pI
P9V6kwFuHOx7pIqBeBB95LmWM7T4EQzin5DgI1J9XjOD7CZ1TFXfEFvbbU98a/ds
PYZuGQ8pnLit33mpqvV89lWGSGvXp0TcvaAgoMoalVi6fAEzYfNsoZQrunSa2++m
Erc6emQPZAZ2Urhwbehqnr6KGZCMXsz1LRQOKUbaFihowiFr272BErc2tHirNGM5
sN/a5ODTO0U6sWBAaAJiLT40MXxkOkWju3tu/KoHM+9AUOU0RVc+HqD+vJVbrRtx
ndShRp9bLeBPl7lOLg7y+/h5CxhEl8luqDbJDOltS3agFGTGPeUsSJyDT60Oxt3j
8xlOHO0UNpY8e3+yN2HDbZoVVnQRwfni9hnjGq527NjzjDjRQXinRkhwVenNHPO/
VrjY+JlD1DK/+eE3/5yx1WpdnCX+0Q0hXYQhgjOiiIkyoRxBk7Q0Uwor55SmJU14
/9eBUIuSTuzlwz+swgz6LffdivrxNsTo0d1U9wgwW1mMutCTuZHQQUVRreyr5pQV
jTHYWBcIo214Aqytsuh30e3nnhMQji0lhGaR0XM/idkNN+MV57sLz6yY1nSuDCkW
IIm6TMZNvFMSAtC8Cc3xudTV2OgzCR26B9sWLJMj+HVA1Ti7kODtAk9ocRlW37gq
gW8dkP9LUTg=
=ugVk
-----END PGP SIGNATURE-----

--5QAgd0e35j3NYeGe--
