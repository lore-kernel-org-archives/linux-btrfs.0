Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50292 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbcHOSa7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 14:30:59 -0400
Date: Mon, 15 Aug 2016 18:30:51 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Anand Jain <anand.jain@oracle.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About minimal device number for RAID5/6
Message-ID: <20160815183051.GD20440@carfax.org.uk>
References: <d87a7caa-d414-1dbc-7c7e-a051e382114a@cn.fujitsu.com>
 <d27bad69-1041-7771-aff6-c15beb85fbb1@gmail.com>
 <9fb53c9f-b6c1-6bb9-8c3b-7147b64b601f@oracle.com>
 <a12a63d2-1710-611b-7d94-35db3a2aaa3d@gmail.com>
 <089d5900-8915-bf74-ffb3-044be11b04ae@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2B/JsCI69OhZNC5r"
In-Reply-To: <089d5900-8915-bf74-ffb3-044be11b04ae@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2B/JsCI69OhZNC5r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 15, 2016 at 10:32:25PM +0800, Anand Jain wrote:
> 
> 
> On 08/15/2016 10:10 PM, Austin S. Hemmelgarn wrote:
> >On 2016-08-15 10:08, Anand Jain wrote:
> >>
> >>
> >>>>IMHO it's better to warn user about 2 devices RAID5 or 3 devices RAID6.
> >>>>
> >>>>Any comment is welcomed.
> >>>>
> >>>Based on looking at the code, we do in fact support 2/3 devices for
> >>>raid5/6 respectively.
> >>>
> >>>Personally, I agree that we should warn when trying to do this, but I
> >>>absolutely don't think we should stop it from happening.
> >>
> >>
> >> How does 2 disks RAID5 work ?
> >One disk is your data, the other is your parity.
> 
> 
> >In essence, it works
> >like a really computationally expensive version of RAID1 with 2 disks,
> >which is why it's considered a degenerate configuration.
> 
>    How do you generate parity with only one data ?

   For plain parity calculations, parity is the value p which solves
the expression:

x_1 XOR x_2 XOR ... XOR x_n XOR p = 0

for corresponding bits in the n data volumes. With one data volume,
n=1, and hence p = x_1.

   What's the problem? :)

   Hugo.

> -Anand
> 
> 
> > Three disks in
> >RAID6 is similar, but has a slight advantage at the moment in BTRFS
> >because it's the only way to configure three disks so you can lose two
> >and not lose any data as we have no support for higher order replication
> >than 2 copies yet.

-- 
Hugo Mills             | I always felt that as a C programmer, I was becoming
hugo@... carfax.org.uk | typecast.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--2B/JsCI69OhZNC5r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXsgpbAAoJEFheFHXiqx3kZpEP/3KZunLqv0rq6laKMegK/Daq
14l2NFdVyZ3PxHgl+jUDOG2O+CglfBWQll/DBLclsVG0Dk6WPFUU35tNRP+QmUr2
OjqXAsNu1D4pwVfh3cqrKomNr1tk2+Ngv9/wCkn/RKLrUOVsmJqXbiYs8q2gTp/T
BbxRU/pW8PAgyHXqpqfZSi+P4FRvL24LC+kaT1NlzXxWYSK+xJAk9GHTjpjnFLMM
mc7Xy8YcKhkWC40TPhxKLn//ms863b6ay0OpJWCtIY76Cs01+TsSTZrjb+bHDXS0
MS8YeixvJdwTrr+WM5QT2iUn5fMRKh15iyFiV3bvrGAG6mfxUSEyDk0J8SMd6XN/
S/NpSZGEuRxTHrAZM2W17Wd2cDZH097B7WVJccV+gM3O1v6+vYlM36G5mLyLIjUZ
S8BuQgx2eqf76ayYidvFik3iSyHjXj36AmqLcfomSGmfNZMlY+ckW5fR1jvfXmxJ
jfCKGPTnAwcq9xLYJrHFvq4pKwBpx8Ta3ho/6YCwfpw+ezK8bhoy6As1DYZXJpbG
wnIYp6CPGk3qVJFEGQ+vgZhykn084hxruxpMqWVh4kgvGH8yVe/H1B5wlOxHRq3E
TPSB0tOX87KEdVqvVXmJ5i7Gj0XHhaxM97QXzw9Ow7JzSfMpUTvTx4L+g4hw8zlA
gi3BqanVDaVjiHiaC/qt
=PWe7
-----END PGP SIGNATURE-----

--2B/JsCI69OhZNC5r--
