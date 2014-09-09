Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36008 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaIIV53 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Sep 2014 17:57:29 -0400
Date: Tue, 9 Sep 2014 22:57:25 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Clemens Eisserer <linuxhippy@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC on mostly empty file system
Message-ID: <20140909215725.GE5783@carfax.org.uk>
References: <3150960.nnNb4J6vhp@wuerfel>
 <4255785.FLXNWijYCD@wuerfel>
 <CAFvQSYQX9e__9vUedcqN2onUA4v2yyt2wz7wGdzAkTHzLL+ggw@mail.gmail.com>
 <10095560.XRujO0W0CE@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qGV0fN9tzfkG3CxV"
In-Reply-To: <10095560.XRujO0W0CE@wuerfel>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 09, 2014 at 11:49:10PM +0200, Arnd Bergmann wrote:
> Ok, now I'm in the bad state again (after running a 'make allmodconfig'
> kernel build:
> 
> Label: none  uuid: 1d88cccb-3d0e-42d9-8252-a226dc5c2e47
>         Total devices 1 FS bytes used 8.79GB
>         devid    1 size 67.14GB used 67.14GB path /dev/sdc6

   All the space on the FS has been allocated to some purpose or other.

> Data: total=65.11GB, used=7.99GB

   Here, you have 65 GiB allocated to data, but only 8 GiB of that
used. The FS won't automatically free up any of that (yet -- it's one
of the project ideas).

> System, DUP: total=8.00MB, used=12.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=821.48MB

   Here, you're running close to full with metadata -- the FS needs
some space to write new copies of metadata block in order to modify
anything. It can't get enough space to do that, because there's
nowhere for any more metadata allocation to come from (because it's
all allocated --see my first comment).

   So... you need to free up some data chunks. You can do this with:

# btrfs balance start -dusage=5 /mountpoint

   Take a look at the output of btrfs fi df and btrfs fi show
afterwards, and see how much the Data allocation has reduced by, and
how much unallocated space you have left afterwards. You may want to
increase the number in the above balance command to some higher value,
to free up even more chunks (it limits the balance to chunks less than
n% full -- so the command above will only touch chunks with 5% actual
data or less). This is in the FAQ.

   Hugo.

> Metadata: total=8.00MB, used=0.00
> : total=200.00MB, used=0.00

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Comic Sans goes into a bar,  and the barman says, "We don't ---   
                         serve your type here."                          

--qGV0fN9tzfkG3CxV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVA93xFheFHXiqx3kAQKLsQ/9Fhv08og3sd4U8VjRpZKx/gAjnwtk5UBV
wVCzRHp4BNc88l3X9QkyyjjFGm14d+uy1Uiq50QdXa2C2J/o5B8Vt9y0PNeFa48N
CNHF9/Tar6tB1kFu8l5gs00/cN03OyOoHNMEFrTpWzc60+vi1Iwr0j+ZXmHWlrQE
INWx1haT1FqWT+JCySapXUhtZNmKO+qrqBpJe/I4r7xLSEHvJMg6YRtSuKk85FxE
6ZKRPdF35PS1Hd2G8tRBWkiZRiVCsFFCJ3xdoeci2dEOxmByVMJ5tWGhZQHI+CUl
DWXblwSD27Q3u8ERSTFB62W8IfFp0OT7NubER0JE3xxAG+Yn+nJSYr0fa96eVvbk
PPGki0ibrhl3QM/Nu8BE3NUONaZkVNnFYrLmSTzUtEv9cLX1iJfRFDPbPjaDZbBk
4bNb60uQABQVWNMAS1TK4pS2G3M3tbf62hY1TVSfMs7Vdd33xDnTdxzPnrE+Hi19
ychrAvp/cbFxbLSnIiNVJ40ZwebFWBT6z+M/BrhGbj3kYHdntsEy55ORGFWiWAyU
YbyA+X9Cc57jqPkO/xwfjqVS8HcBwY3v3XWr97/xb/tuO35TrwilguSmmBjahVUp
SBs+AcDrePD8l9+mHENleMUXZr+LRT6hsNayozw6hol3zjtHAR1TnwJvPN+GiLf2
BatYuA0ODgg=
=2HQI
-----END PGP SIGNATURE-----

--qGV0fN9tzfkG3CxV--
