Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57310 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2JCL4T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 07:56:19 -0400
Date: Wed, 3 Oct 2012 12:56:15 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
Message-ID: <20121003115615.GB25498@carfax.org.uk>
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
In-Reply-To: <1349264596-9383-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Looks good. Only a few comments, inline.

On Wed, Oct 03, 2012 at 01:43:14PM +0200, Goffredo Baroncelli wrote:
> $ ./btrfs filesystem df --help
> usage: btrfs filesystem disk-usage [-d][-s][-k] <path> [<path>..]
> 
>     Show space usage information for a mount point(s).
> 
>     -k  Set KB (1024 bytes) as unit
>     -s  Don't show the summary section
>     -d  Don't show the detail section

   These are kind of logical, but I think would be hard to remember
the right way round. I would suggest swapping the actions of the
switches, and rewording the help:

-s Show only summary section
-d Show only detail section

> $ ./btrfs filesystem df /
> Path: /
> Summary:
>   Disk_size:                 72.57GB

                                    ^ space between the value and the
                                      unit (as ISO says), throughout.
                                      This also makes it easier to
                                      parse, if anyone wants to.

   Also, use kB, MB, GB, TB for powers-of-ten based units, and KiB,
MiB, GiB, TiB for powers-of-two based units, please. I don't care
which you report in, but please do make the distinction. (And note
that it's kB with a lower case k, but KiB with an upper case K). This
brings us in line with the relevant ISO and IEEE standards.

>   Disk_allocated:            25.10GB
>   Disk_unallocated:          47.48GB
>   Logical_size:              23.06GB
>   Used:                      11.01GB
>   Free_(Estimated):          55.66GB    (Max: 59.52GB, Min: 35.78GB)
>   Data_to_disk_ratio:           92 %
> 
> Details:
>   Chunk-type  Mode      Chunk-size Logical-size        Used
>   Data        Single       21.01GB      21.01GB     10.34GB
>   System      DUP          80.00MB      40.00MB      4.00KB
>   System      Single        4.00MB       4.00MB        0.00
>   Metadata    DUP           4.00GB       2.00GB    686.93MB
>   Metadata    Single        8.00MB       8.00MB        0.00

   Why are the field headings here using - where the field headings in
the first section used _? Should you be using _ in both places?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- The most exciting phrase to hear in science, the one that ---    
               heralds new discoveries,  is not "Eureka!",               
                          but "That's funny..."                          

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUGwn3r9z9OVl50rAAQIddA/+OWzhMa4562b+wpzixdAN6vauQ2Wh0FNd
XKSyfk3jTtw92+DZyYxHlFiliSFD/G7twIy8Fcft4XhjX/sroDrpPKzO6e1u5MZj
boYhstvoKIDA7nHOnoS3AJELmN8Hh48mMRlT+dxe/i5U4QJUSWp7j5Dc36QVtpQz
yYS49L/cOvcxQR0Vessn2l67TErP7Yu9SObm+RABPWjjK/+GHPpZpJCYhq/wtnYe
UIlII53ZpI9cbq9Ugk0gFJXrl1fCjPmcBaUhPtuEVfhQxn2dT8iO6uc85sYsioSr
Tmtto1wZgCiJvMRScBFmLtfAtEN8Pu3Ft5jOMUPm+lDyApf/UGPT3Lr7pd1+Uzjd
eTxievFYKUvD8z88VZRx0WAmBcHGvmF8Gsd5BDC57zHQ/uDE4SKTwKFfwXEDH/Nm
1BL0k4EzCZtMwN8GuPNikKs70vEr74UmUtKrcMVf5ypeOhrngfbjSNXo/lNGSg15
SjlTEM3clGioCqe54zGdzHWmZ5NYT8yTd3OqNAlx870qltg5mIgnOc6uOscMsFXM
n+0XYxQLJShTPpqfSjm9JQux/YUoy1pCqjb2Pda8LnINMhsvkrV19o4FMynvxMpb
MbN1VAednb7DUZ3XIdWca/XzImc7ezhnxTrlR9lQvaWt6BwJlYRr/xi23CRD1+i+
O7vUbFaFDdg=
=gD4M
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
