Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34833 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753758AbeDSXTc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 19:19:32 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1f9Ipv-00014O-Hr
        for linux-btrfs@vger.kernel.org; Thu, 19 Apr 2018 23:19:31 +0000
Date: Thu, 19 Apr 2018 23:19:31 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: Recovery from full metadata with all device space consumed?
Message-ID: <20180419231931.GJ13551@carfax.org.uk>
References: <20180419220848.GB24508@bottomless.cesspool.net>
 <20180419224357.GI13551@carfax.org.uk>
 <20180419231239.GD24508@bottomless.cesspool.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="utPK4TBebyzZxMrE"
In-Reply-To: <20180419231239.GD24508@bottomless.cesspool.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--utPK4TBebyzZxMrE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 19, 2018 at 04:12:39PM -0700, Drew Bloechl wrote:
> On Thu, Apr 19, 2018 at 10:43:57PM +0000, Hugo Mills wrote:
> >    Given that both data and metadata levels here require paired
> > chunks, try adding _two_ temporary devices so that it can allocate a
> > new block group.
> 
> Thank you very much, that seems to have done the trick:
> 
> # fallocate -l 4GiB /var/tmp/btrfs-temp-1
> # fallocate -l 4GiB /var/tmp/btrfs-temp-2
> # losetup -f /var/tmp/btrfs-temp-1
> # losetup -f /var/tmp/btrfs-temp-2
> # btrfs device add /dev/loop0 /broken
> Performing full device TRIM (4.00GiB) ...
> # btrfs device add /dev/loop1 /broken
> Performing full device TRIM (4.00GiB) ...
> # btrfs balance start -v -dusage=1 /broken
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=1

   Excellent. Don't forget to "btrfs dev delete" the devices after
you're finished the balance. You could damage the FS (possibly
irreparably) if you destroy the devices without doing so.

> I'm guessing that'll take a while to complete, but meanwhile, in another
> terminal:
> 
> # btrfs fi show /broken
> Label: 'mon_data'  uuid: 85e52555-7d6d-4346-8b37-8278447eb590
> 	Total devices 6 FS bytes used 69.53GiB
> 	devid    1 size 931.51GiB used 731.02GiB path /dev/sda1
> 	devid    2 size 931.51GiB used 731.02GiB path /dev/sdb1
> 	devid    3 size 931.51GiB used 730.03GiB path /dev/sdc1
> 	devid    4 size 931.51GiB used 730.03GiB path /dev/sdd1
> 	devid    5 size 4.00GiB used 1.00GiB path /dev/loop0
> 	devid    6 size 4.00GiB used 1.00GiB path /dev/loop1
> 
> # btrfs fi df /broken
> Data, RAID0: total=2.77TiB, used=67.00GiB
> System, RAID1: total=8.00MiB, used=192.00KiB
> Metadata, RAID1: total=4.00GiB, used=2.49GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> Do I understand correctly that this could require up to 3 extra devices,
> if for instance you arrived in this situation with a RAID6 data profile?
> Or is the number even higher for profiles like RAID10?

   The minimum number of devices for each RAID level is:

single, DUP:     1
RAID-0, -1, -5:  2
RAID-6:          3
RAID-10:         4

   Hugo.

-- 
Hugo Mills             | Gentlemen! You can't fight here! This is the War
hugo@... carfax.org.uk | Room!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                        Dr Strangelove

--utPK4TBebyzZxMrE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJa2SQDAAoJEFheFHXiqx3kTnwP/0QYlnL6OxFMLBNB8tetH4IJ
msDB/IN7Xj2YOQl5dLVsZgvZLZ3ayds5YKnCrwRlusOOlAL35cjkKF0/2oxmQnpL
+CB3HY4guSNvadROaIaR3qzrVIgWgxqSpSNn5lZ0n0yzzII2GTqvMfPcrD5Bf35c
Jt2OZqd4NaWrTrIGkLKM1ZMaC9mq/T9pfGK5U8jfGQRdav9yB/uoVISvFqagD3aN
cPxUyxH3F2VhyovT3X0384P1WPLzc4PC/UXx3wef4O0UfOEWziO2fHqOLcF87ji4
vFRe/NIx6SPpEVEZfcsmOdW+OOFPY+bYrMFMyV/OC+nVQV9ClLXfGLDB2ut43ggf
LNDdScIXeCKO7zlAs8JfKWu4O3uYweabJDVCbuwqoPRiZ9Q+TGljKLj+lVqr+jW+
bV50pK06vC+waYrx0JvudoA0XS3kf0P0UV8Sij5RCfy+mB9UeogHOckm20ZruOGp
5UH1QZX3ADInPHCU6Cws192pn1htVBMTFCUEh7HZBSp6Za7RQHVmGVQqiMBZquhv
t/YA1itzu91/QijHcG8OHTPdKn41zk3Wdq0bhXG587Eeb9uWF5zXCOn5SclS41E0
d6Pc1WL0Vm0ZYzU7FpUXM/1DZ2FQiiIrlbmXqgWLvH0gvQDWA11h+M1JPOI2XmFQ
F7S7H6f4vi6sCKa4oi2A
=Vjl4
-----END PGP SIGNATURE-----

--utPK4TBebyzZxMrE--
