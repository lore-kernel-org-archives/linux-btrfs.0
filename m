Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45363 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762416Ab2KAWc5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 18:32:57 -0400
Date: Thu, 1 Nov 2012 22:32:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: cwillu <cwillu@cwillu.com>, Anand jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [Request for review] [RFC] Add label support for snapshots and
 subvols
Message-ID: <20121101223253.GA28864@carfax.org.uk>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
 <CAE5mzvjJmYGJvgjBGLv8kaUnZPDZu_QaU5s1=mYo55RmujeDNQ@mail.gmail.com>
 <CAG1y0sd-F6WrUFsvwAx+7LGD+V7a6XCoP9=XEkADPEAyEL1G1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
In-Reply-To: <CAG1y0sd-F6WrUFsvwAx+7LGD+V7a6XCoP9=XEkADPEAyEL1G1w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 02, 2012 at 05:28:01AM +0700, Fajar A. Nugraha wrote:
> On Fri, Nov 2, 2012 at 5:16 AM, cwillu <cwillu@cwillu.com> wrote:
> >>  btrfs fi label -t /btrfs/snap1-sv1
> >> Prod-DB-sand-box-testing
> >
> > Why is this better than:
> >
> > # btrfs su snap /btrfs/Prod-DB /btrfs/Prod-DB-sand-box-testing
> > # mv /btrfs/Prod-DB-sand-box-testing /btrfs/Prod-DB-production-test
> > # ls /btrfs/
> > Prod-DB  Prod-DB-production-test
> 
> 
> ... because it would mean possibilty to decouple subvol name from
> whatever-data-you-need (in this case, a label).
> 
> My request, though, is to just implement properties, and USER
> properties, like what we have in zfs. This seems to be a cleaner,
> saner approach. For example, this is on Ubutu + zfsonlinux:
> 
> # zfs create rpool/u
> # zfs set user:label="Some test filesystem" rpool/u
> # zfs get creation,user:label rpool/u
> NAME     PROPERTY    VALUE                  SOURCE
> rpool/u  creation    Fri Nov  2  5:24 2012  -
> rpool/u  user:label  Some test filesystem   local

   Don't we already have an equivalent to that with user xattrs?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- I spent most of my money on drink, women and fast cars. The ---   
                      rest I wasted.  -- James Hunt                      

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUJL4lb9z9OVl50rAAQKEiQ/8DWfM7rdYLmqI0m0CJOfmtsmy6g6LsIe4
YSHb3C9beTTUhzKhkKfttpRte4yXlk1YBibCU9t4/3R5OqrmR6XjPdWgBgiOHDtc
XgAZjB7Y57+L+h2FiC8GBcIqQnTBRwtWozQ/455hWbLDIQIOTU8Hv/Z1wKMGHjwF
LyXiC+JVc4s5Zs80JALG/ZR5841axcVPdR1FUX9Rf69iwvgSnb08vkMqLXanypKQ
oQ+5SCoAvoIW7S1eDxOTGkw8OOcoTHXyD111SS2DAQMpQKSasYERxI5BxiT3qtFf
lAHpWrFvjweQGJcDjXPI4fEqlMaglHtR/YmFqp5FfejsvXJGYtb6P9wTjdBGnmQX
okSJ+trWzI2MEldNpjAZTI0BmhaJFABanWXXdaq4WqHetoCXiQrxDuqWSVBZxOvM
qWindorJkckWnKUAqh2cVsr9Kh19MxBAfPgY2a5v2fiko1jO3AbJnYnK834n41l+
9K2Pmq8AXMJ+Aw16N/FsD6EjxojyWCkzcK4cZaoktoNcsbpeP9toLjDSoofY9UuM
Lfe18GffhHToIb38vPucCBIj76e5x4Ky5BFS/BaHJR79E5Jt1fMaPMjiAr7peWlj
6r3/2SgRhKvUPjyTzJHCGTXns0AgAaPIWQ/tAZbhK1efT/8eax6atOfTXKdHsz7h
VsxmmepB4kw=
=G89N
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
