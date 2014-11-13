Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39279 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaKMKiV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 05:38:21 -0500
Date: Thu, 13 Nov 2014 10:38:19 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Kline, Matthew" <matthew.kline@flukenetworks.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs balance fails with no space errors (despite having plenty)
Message-ID: <20141113103819.GA1401@carfax.org.uk>
References: <E8C63C11EA3FB04DBDFEDECEFD927FD1139F9841@US-EVT-EXM04-P.global.tektronix.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
In-Reply-To: <E8C63C11EA3FB04DBDFEDECEFD927FD1139F9841@US-EVT-EXM04-P.global.tektronix.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 06:48:47PM +0000, Kline, Matthew wrote:
> Yesterday I converted my ext4 root and home partitions on my home machine
> to btrfs using btrfs-convert. After confirming that everything went well,
> I followed the wiki instructions to nuke the 'ext2_saved" subvolume,
> then defraggad and rebalanced. Everything went according to plan on my root
> partition, but my home partition claimed to have run out of space
> when rebalancing.
> 
> I did some digging and tried the following to resolve the problem,
> but to no avail. So far I have:
> 
> - Made sure I deleted the subvolume (a common cause of this problem).
>   `sudo btrfs subvolume list -a /home` exits with no output.
> 
> - Made sure I defragged the newly converted btrfs partition before attempting
>   to rebalance it.
> 
> - Made sure that I actually have space on the partition.
>   It is only about 60% full - see sdb1 below:
> 
>   ~ % sudo btrfs fi show
>   Label: none  uuid: 3a154348-9bd4-4c3f-aaf8-e9446d3797db
>       Total devices 1 FS bytes used 9.49GiB
>       devid    1 size 87.47GiB used 11.03GiB path /dev/sda3
> 
>   Label: none  uuid: cc90ee50-bbda-46d6-a7e6-fe1c8578d75b
>       Total devices 1 FS bytes used 124.98GiB
>       devid    1 size 200.00GiB used 127.03GiB path /dev/sdb1
> 
> - Made sure I have metadata space (as suggested on the problem FAQ):
> 
>   ~ % sudo btrfs fi df /home
>   Data, single: total=126.00GiB, used=124.58GiB
>   System, single: total=32.00MiB, used=20.00KiB
>   Metadata, single: total=1.00GiB, used=404.27MiB
>   GlobalReserve, single: total=136.00MiB, used=0.00B
> 
> - Ran partial rebalances using the `-dusage` flag
>   (as suggested on the problem FAQ),
>   which successfully balanced a handful of blocks.
> 
> - Checked the system log - nothing interesting comes up.
>   btrfs happily chugs along with "found xxx extents" and
>   "relocating block group xxxxx flags 1" messages before unceremoniously
>   ending with "7 enospc errors during balance".
> 
> In spite of all of this, a full rebalance still fails when it's about 95% done.
> I'm at a complete loss as to what could be causing it - I know that it's not
> completely necessary (especially with a single drive),
> and `btrfs scrub` finds no errors with the file system,
> but the wiki gives the impression that it's a good idea after you convert from
> ext.

   I'm fairly sure it's a bug. We've had several reports of something
like this, particularly with respect to converted filesystems. I know
that failed balances with apparently plenty of space are reasonably
high up on josef's list of things to investigate. I would recommend at
minimum putting this report on bugzilla.kernel.org as well. The other
thing you could do, which may help with debugging, is to take a copy
of the metadata:

$ btrfs-image -c9 -t4 /dev/sdb1 /path/to/image.img

and hang on to it just in case josef (or whoever else looks at it)
needs another sample to debug with.

> Is there something I'm missing?

   I don't think so. This is probably a bug -- I'd guess in the FS
(because we've seen something similar on non-converted FSes), but
maybe set up more easily by the conversion process.

   Hugo.

> Other obligatory info: I'm on Arch Linux using btrfs 3.17.1. uname -a is
> 
> Linux kline-arch 3.17.2-1-ARCH #1 SMP PREEMPT Thu Oct 30 20:49:39 CET 2014
> x86_64 GNU/Linux

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                       --- Strive for apathy! ---                        

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUZIoaAAoJEFheFHXiqx3kSPAP/jezloMJKLP1Sp9f9UkL3WrF
XJ0TMam42K3HQ5U3oSvLx+fcd+0Z/p7E0QbiQAMH/T2HtW4+CNj/sEcIkUr+52oq
g7f9uiKrwUloL4x1ob/sFcJokLzhrM4It875nqZSau1tyQ3QSdy/WZO2AG2EMr3g
m42t+EJK32jq/0MaB/ISYmijkOsKnfwgx3e9+A0Z61yWKL9nyr14EnVfMxhsvnxo
X3n93Jqhm8YAqREEAB3Ysglu8I8dwy1w+iIiA4ibmtUySlBBUu2Upgd9EiveuqEU
Uuie9ml5oqNPZ5panzRUkjPxtw2L6Y2CXuPWWk0NEJE3ZHcmic+8+F2GoP3UdXe5
EhDXllZUgCKvZxy7hhvbiBjMaFGeJHqbsrBXSPv+Sj4MQvkiPSkFTpPtN3HKGpUQ
aRuADjdsznkPJaukcugsdtzKY2r+Nb6DbUEC9iYSRWG6qdRxkK107Y4Y8L4u6jfy
x9Z8LwRTDHjQjY3C5/KRq+F/eWgrfIrscSWcbxn9HNsUiwCBcVcNezIDQnkNHVEg
7zQfhMCgBQFb3hoPqkZf0LUIlfzUHPojYu7kGuU8G+xZ70NE4x+Lm/sUavB1A9Nh
Ggg4s2Q5bUh5UiSrYWHsaOCOuibZiIomD8glTwbZtm4+cmkLp5prBzlbsjOoS540
sntH/nyxhdHlUkMQVzPo
=7x9W
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
