Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54918 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaBHLrA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Feb 2014 06:47:00 -0500
Date: Sat, 8 Feb 2014 11:46:34 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.net>
Cc: Kai Krakow <hurikhan77+btrfs@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
Message-ID: <20140208114634.GH6490@carfax.org.uk>
References: <20140206021516.304732cd@natsu>
 <52F3EED4.7030603@fb.com>
 <agsfsa-mks.ln1@hurikhan77.spdns.de>
 <20140208173310.1f90af3b@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5lq+205vWdkqwtk"
In-Reply-To: <20140208173310.1f90af3b@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--r5lq+205vWdkqwtk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 08, 2014 at 05:33:10PM +0600, Roman Mamedov wrote:
> On Fri, 07 Feb 2014 21:32:42 +0100
> Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:
> 
> > It should show the raw space available. Btrfs also supports compression and 
> > doesn't try to be smart about how much compressed data would fit in the free 
> > space of the drive. If one is using RAID1, it's supposed to fill up with a 
> > rate of 2:1. If one is using compression, it's supposed to fill up with a 
> > rate of maybe 1:5 for mostly text files.
> 
> Imagine a small business with some 30-40 employees. There is a piece of paper
> near the door at the office so that everyone sees it when entering or leaving,
> which says:
> 
> "Dear employees,
> 
> Please keep in mind that on the fileserver '\\DepartmentC', in the directory
> '\PublicStorage7' the free space you see as being available needs to be divided
> by two; On the server '\\DepartmentD', in '\StorageArchive' and '\VideoFiles',
> multiplied by two-thirds. For more details please contact the IT operations
> team. Further assistance will be provided at the monthly training seminar.
> 
> Regards,
> John S, CTO.'

   In my experience, nobody who uses a shared filesystem *ever* looks
at the amount of free space on it, until it fills up, at which point
they may look at the free space and see "0". Or most likely, they'll
be alerted to the issue by an email from the systems people saying,
"please will everyone delete unnecessary files from the shared drive,
because it's full up."

   Having a more accurate estimate of the free space is a laudable
aim, and in principle I agree with attempts to do it, but I think the
argument above isn't exactly a strong one in practice.

   Even in the current code with only one RAID setting available for
data, if you have parity RAID, you've got to look at the number of
drives with available free space to make an estimate of available
space. I think your best bet, ultimately, is to write code to give
either a pessimistic (lower bound) or optimistic (upper bound)
estimate of available space based on the profiles in use and the
current distribution of free/unallocated space, and stick with that. I
think I'd prefer to see a pessimistic bound, although that could break
anything like an installer that attempts to see how much free space
there is before proceeding.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- This year,  I'm giving up Lent. ---                 

--r5lq+205vWdkqwtk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUvYZGlheFHXiqx3kAQLoqg/+NK2JfxvgDKCs04oPKcXtyD44T8Y303dA
nyCoHaXWLX6R5Hp0F6FT/f8264FiTgSWNvdvRHkLJS1aIqzZcVbfbBDjfg1Vtmqv
a7TTQRa11YKvZAD4YnR2eLTCOgVluNgVFTvEC4CwIS2Qf4FdSl+ZFMXYEIX4/wVI
1qRUWFUUM0FonnJDiU6sUn9LBrsV9jyO0i1yKLPHxqoBOkMYK7ugDFBPDLTDGrFk
n/eYp2rMRUt1tw3M0NPty8I9qoFCunVgzku9uMv7kMwtMTkGF9LlHOpjCM8IPor1
iPsD1aSkLZNhklVvlK45OfA4Bb5E8mH4gjsnR5RNRRa+TPCB1uJjbgp+gJ7EwQqd
dR4mJ8Ft5OgvO9yXuCR6efa6QFWQBUbWqQyrNUoVuvtbWSLIzScI1vwCBRgGq7z4
qD35/5vfgThvcy/Llmtk0o8KYyKjr5eD4q/B6CFP2eH3PgTnE7KnGe2v+8aWzgh5
uUqROW+orxgFrvA+invH2pi2vc7yjwhoItgDf0wI9QqJoj8IH3fAeDL9SBMrANoP
QNl3Uu6+VIx/sy96lGDPqgcqlVkMukXGhh/AFeQTXqWAxCj0qY23PFGG8IsGEYCU
0cwMV+6xfhTRRgkeLNR1EFACfw2t+uZg/b9y5z+3s+bbkddsSV3pvjEaOOAe3E3D
b7dQYgmftx4=
=lMGa
-----END PGP SIGNATURE-----

--r5lq+205vWdkqwtk--
