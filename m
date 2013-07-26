Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59210 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3GZHpM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 03:45:12 -0400
Date: Fri, 26 Jul 2013 08:45:08 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Axelle <aafortinet@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Adding 500G disk to btrfs volume... but I don't get 500G more of
 available space (raid0)
Message-ID: <20130726074508.GJ20517@carfax.org.uk>
References: <CANKzOHASE9pB6TjJ4JbqY1PE6cRsbCsY=KU3NVRjwcb74tikVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yr/DzoowOgTDcSCF"
In-Reply-To: <CANKzOHASE9pB6TjJ4JbqY1PE6cRsbCsY=KU3NVRjwcb74tikVQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yr/DzoowOgTDcSCF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 09:05:03AM +0200, Axelle wrote:
> Hi btrfs folks,
> 
> I'm afraid I have a newbie question... but I can't sort it out? It's
> just about adding a disk to a btrfs volume and not getting the correct
> amount of GB in the end...
> 
> I have a btrfs volume which already consists of two different devices
> and which is mounted on /samples. Its total size is 194G.
> 
> $ df -h
> Filesystem Size Used Avail Use% Mounted on ... /dev/sdc1 194G 165G 20G
> 90% /samples
> 
> Now, I would like to add another 500G to that volume, from another device. I did
> 
> $ sudo mkfs.btrfs -m raid0 -d raid0 /dev/sdb
> $ sudo btrfs device add /dev/sdb /samples
> My filesystem now correctly reports:
> 
> $ sudo btrfs filesystem show
> Label: none  uuid: 545e95c6-d347-4a8c-8a49-38b9f9cb9add
>     Total devices 3 FS bytes used 161.98GB
>     devid    3 size 465.76GB used 0.00 path /dev/sdb
>     devid    2 size 93.13GB used 84.51GB path /dev/sdc1
>     devid    1 size 100.61GB used 84.53GB path /dev/sdc6
> But I miss some space when I do:

   RAID-0 requires at least two devices. If you balance this
configuration, you'll use up the first 93.13 GiB of each device
striping across all three devices, for a total of 3*93.13 = 279.39
GiB. Then /dev/sdc1 becomes full, leaving you with two devices which
have 7.48 GiB and 372.63 GiB respectively. After another 7.48 GiB on
each device (for a total of 2*7.48 = 14.96 GiB), you have filled
/dev/sdc1, leaving only /dev/sdb to work with. Since there's only one
device, it can't be used by RAID-0.

   If you want to use the full space available, you should rebalance
to single usage, which stops the RAID-0 striping, and allocates
linearly:

# btrfs balance start -dconvert=single,soft /samples

   Hugo.

> $ df -h
> Filesystem      Size  Used Avail Use% Mounted on
> ...
> /dev/sdc1       660G  165G   43G  80% /samples
> I added 500G! Why haven't I got more available??
> 
> To debug, I ran this command:
> 
> $ sudo btrfs filesystem df /samples
> Data, RAID0: total=162.00GB, used=159.79GB
> Data: total=8.00MB, used=7.48MB
> System, RAID1: total=8.00MB, used=24.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=3.50GB, used=2.19GB
> Metadata: total=8.00MB, used=0.00
> My data is in RAID0, that's ok. So where have my 500G gone, and how
> can I fix this?
> 
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- Sometimes, when I'm alone, I Google myself. ---           

--yr/DzoowOgTDcSCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUfIpBFheFHXiqx3kAQLJFRAAg0Wvr+/grFrTtOwh1g+76M/O131GBNek
jUiqajxsglEcE1ntzdirpikCTGjrNPu4zyxPw+f6SvykrDCvlGj9Fi2Qo5j4sB7f
qJMFgcPG2ciApQtFkVLfuREMakO/+WrpFh0xa+97WyE9ywHm2OKlPs1bsxmyO0aJ
66AcmMRq9AZmmSCp/G+MfFvcPA0ApBy/v9RZt9wSxZT+qAaue69wt/hKvOaeU+aq
7lYK8Tm+/Mhh4BeKT10A9o6tnLVA5ELucak+DFRZwn4CbfT6YNpB/ubJsTDzjrZ5
hZOaKq5MXRypxo58ZQYrEbiI4eJUSpcRv1r4ZY7lrGlUHPIhYRT06abYZmajdj4p
R04NmbvBdHs+9WW9UsWWeZLFaFI1fesbhsYK77smSRUeK96FclamM4mIs2WpQJdE
mvNcse/SrGXKkyI2pwT2aZvdIghxnhIa5GrTJRyk1vEs9FwEb2LUZPJ9ACWhEfN6
4oRmq+RVgkRSnV1b4lSxHOcxZKBwta3O7WbqZP7MoYgtEf9QXiS71Z1IStz3KR0N
z35ajAMNCIYqjiaMmBW60BNiw+nKUCPGDqbdlHe7NRandrEqcL7nbv96dK5e6Var
HoyCo2M+oY46zQIJRjQ4HOgbH+vnnb6HQJPmnyokWA/w6oQ2SWsAR0ZB5haY4rGG
R2bj2WGPI1E=
=Rs4a
-----END PGP SIGNATURE-----

--yr/DzoowOgTDcSCF--
