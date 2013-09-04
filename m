Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33591 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762663Ab3IDNcL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 09:32:11 -0400
Date: Wed, 4 Sep 2013 14:32:07 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Giuseppe Fierro <giuseppe@fierro.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs prog
Message-ID: <20130904133207.GC6389@carfax.org.uk>
References: <CAN3gubkkb5jKPddRcDVBqr=r7c6_jFP6-hMaiWQ4mie6Fk90pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
In-Reply-To: <CAN3gubkkb5jKPddRcDVBqr=r7c6_jFP6-hMaiWQ4mie6Fk90pA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2013 at 01:57:42PM +0200, Giuseppe Fierro wrote:
> I'm using btrfs on ubuntu 13.04 with btrfs prog v0.20-rc1
> This is my configuration using 2 disks in raid1 mode:
> 
> > gspe@jura:/mnt$ sudo btrfs f show
> > Label: 'UbuntuDSK'  uuid: f4a3c832-f6ab-4b1d-9eb7-f9ba7d1cba01
> > Total devices 2 FS bytes used 205.41GB
> > devid    1 size 2.70TB used 214.03GB path /dev/sdb2
> > devid    2 size 2.70TB used 214.01GB path /dev/sda2
> > Btrfs v0.20-rc1
> 
> 
> Some btrfs command behave strange:
> If i want to check free space using df, i get:
> 
> > gspe@jura:/mnt$ sudo btrfs filesystem df /
> > Data, RAID1: total=212.00GB, used=204.42GB
> > Data: total=8.00MB, used=0.00
> > System, RAID1: total=8.00MB, used=36.00KB
> > System: total=4.00MB, used=0.00
> > Metadata, RAID1: total=2.00GB, used=1010.04MB
> > Metadata: total=8.00MB, used=0.00

   What do you think is wrong with this output? It looks OK to me:

   From the btrfs fi show at the top, you have 214 GB allocated on
each device. The btrfs fi df shows you how that allocation is used:
212 GB (*2, because it's RAID-1) is allocated to data, with 204 GB
holding useful data. The remaining 2 GB (*2) is allocated to metadata,
and 1 GB of that is actually used.

> If I would like to show the subvolume, i get
> 
> > gspe@jura:/mnt$ sudo btrfs subvolume list /
> > gspe@jura:/mnt$
>
> nothing is shown!!!

   Try using the -a option. It got added a while ago, and has been a
complete pain in the neck ever since...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- The English language has the mot juste for every occasion. ---    

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUic2V1heFHXiqx3kAQKOdhAArAVsS6SEP8+DHD0w+HGa61KXNmZtNI9c
oo82PF1KazZEs1cTt4w0IVfl60MWiIw6tW5QNhHkviHWoFlKNgd/QenanVBQKBTa
tY8vtCB+LR4lfLMbcCdF2nxny9+Fst3giJwQzrpG//owMyjzO0jyFbfiir917uQk
27HPQS94UOM/J1ENKKVGGbZkENbtOoaa3iO/ZXlSrbR57RnwtsoB8IU5qMLoVQbK
UaNd02DE3oiRoP1ROdJ1sC6STW51DrifjA+jZvvA89UWGtGoyqtWQCPHnH4b+IBp
wcUEQPziLuDhlzzesTQT1Dn+WGIhl53BONz32HvzEvkW+pOEFq7/BUM/Qeqp/h7D
SsQuCCvUKJTepeJThkRcxwyfBdcBQcdBlzVxRXuVVFJ+xjKadazUNQjOEn1e4Gdx
hc5eIdNjYbShTSIRAj/jz2+2VSO0m0SEDTNBaO/YjD79U8kGl45K9LLC7XC2hepO
l2fX6+qphNtVBiu5CS651Phe6LZoY3vM4/LX6+Medm/N7JuYJ4x2N+fD5VEq+gqH
5lCJicVG8B096AbV3GAmT5obWk6HqsvsJYFTz/f7lv7y0hgJB2YKgzVW6isaXXYH
lG8EpX1GlYC+C6h5DvuK/Xf01rEnQ/Perq9OCwQEnxyDoubEmszPmDqeTMB1IABs
2Xrf3I820AM=
=kzOF
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
