Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36814 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab2LQQXx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 11:23:53 -0500
Date: Mon, 17 Dec 2012 16:23:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Sebastien Luttringer <sebastien.luttringer@smartjog.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Feeback on RAID1 feature of Btrfs
Message-ID: <20121217162350.GJ19051@carfax.org.uk>
References: <kanf24$o8e$1@news.dmz-ext.fr.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cDtQGJ/EJIRf/Cpq"
In-Reply-To: <kanf24$o8e$1@news.dmz-ext.fr.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cDtQGJ/EJIRf/Cpq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 17, 2012 at 04:51:33PM +0100, Sebastien Luttringer wrote:
> Hello,
> 
> I'm testing Btrfs RAID1 feature on 3 disks of ~10GB. Last one is not
> exactly 10GB (would be too easy).
> 
> About the test machine, it's a kvm vm running an up-to-date archlinux
> with linux 3.7 and btrfs-progs 0.19.20121005.
> 
> #uname -a
> Linux seblu-btrfs-1 3.7.0-1-ARCH #1 SMP PREEMPT Tue Dec 11 15:05:50 CET
> 2012 x86_64 GNU/Linux
> 
> Filesystem was created with :
> 
> # mkfs.btrfs -L test -d raid1 -m raid1 /dev/vd[bcd]
> 
> I downloaded a lot of linux kernel tarball and untared in into this
> filesystem until it tell me enough:
> 
> drwxr-xr-x 1 root root  330 2007-10-09 20:31 linux-2.6.23
> -rw-r--r-- 1 root root  44M 2007-10-09 20:48 linux-2.6.23.tar.bz2
> drwxr-xr-x 1 root root  344 2008-01-24 22:58 linux-2.6.24
> -rw-r--r-- 1 root root  45M 2008-01-24 23:16 linux-2.6.24.tar.bz2
> drwxr-xr-x 1 root root  352 2008-04-17 02:49 linux-2.6.25
> 
> Some output of btrfs tools
> 
> # btrfs fi sh
> Label: 'test'  uuid: 7d72c625-4dd7-4db0-b4a2-075e26572b99
> 	Total devices 3 FS bytes used 11.57GB
> 	devid    3 size 10.00GB used 9.76GB path /dev/vdd
> 	devid    2 size 10.00GB used 10.00GB path /dev/vdc
> 	devid    1 size 9.77GB used 9.77GB path /dev/vdb
> 
> # btrfs fi df .
> Data, RAID1: total=13.50GB, used=10.56GB
> Data: total=8.00MB, used=0.00
> System, RAID1: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=1.25GB, used=1.01GB
> Metadata: total=8.00MB, used=0.00
> 
> I have choosen a _raid1_ filesystem, so I expect every disk be able to
> die and fs still usuable without data lost.

   This is where your expectations and reality have their differences.

> I used chksfv[1] to make checksum of tarball on disk and check my data
> are safe.
> 
> I killed the first disk via libvirt.
> # virsh detach-disk  seblu-btrfs-1 vdb
> 
> Btrfs detect missing disk \o/
> 
> # btrfs fi sh
> Label: 'test'  uuid: 7d72c625-4dd7-4db0-b4a2-075e26572b99
> 	Total devices 3 FS bytes used 11.57GB
> 	devid    3 size 10.00GB used 8.01GB path /dev/vdd
> 	devid    2 size 10.00GB used 9.26GB path /dev/vdc
> 	*** Some devices missing
> 
> Listing all files and cksum on tarballs are good.
> 
> # cksfv -f ~/checksum
> Everything OK
> 
> We have raid1, so we can expect kill one disk (the smaller). Let's go.
> 
> # virsh detach-disk  seblu-btrfs-1 vdd
> 
> # btrfs fi sh
> Label: 'test'  uuid: 7d72c625-4dd7-4db0-b4a2-075e26572b99
> 	Total devices 3 FS bytes used 11.57GB
> 	devid    3 size 10.00GB used 8.01GB path /dev/vdd
> 	devid    2 size 10.00GB used 9.26GB path /dev/vdc
> 	*** Some devices missing

[snip]

   Yes, this is the expected behaviour.

> I get the feeling that RAID1 only allow one disk removing. Which is more
> a RAID5 feature.

   The RAID-1 support in btrfs makes exactly two copies of each item
of data, so you can lose at most one disk from the array safely. Lose
any more, and you're likely to have lost data, as you've found out.

> I'm afraid Btrfs raid1 will not be working before the end of the world.

   It does work (as you demonstrated with the first disk being
removed) -- but just not as you thought it should. Now, you can argue
that "RAID-1" isn't a good name to use here, but there's no good name
in RAID terminology to describe what we actually have here.

   I believe that Chris has done some work on allowing (tunable)
multiple copies of data in RAID-1 mode, but that's not been published
yet. It was part of the extended RAID work that he was working on. I
think we're hoping for RAID-5 and RAID-6 to arrive in this merge
window, but that's been said before (and it hasn't been stable enough
for release before). I think Chris was going to leave the n-copies
RAID-1 feature for a later release, and just get RAID-5/6 out first.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- "Le Corbusier's plan for improving Paris involved the ---      
                assassination of the city, and its rebirth                
                            as tower blocks."                            

--cDtQGJ/EJIRf/Cpq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUM9HFr9z9OVl50rAAQIZ5A/9FD8vpNWbiXHWIfPyJ28k4qidTasaw9KH
LTB7gDb9F6EoVQq6A8hGAF3/h/8LUvgG0JGeixBmckhMIf/1+N0VcgirykkAFAgM
nVOW9S+oibkUnymoxwYspLvNCK5PWsz9D1LKbMtsBRGC8WVUN4V0RokhHrKooqTC
LA2ANzOndC8tqf0fv8Hi0/xgnfbXtwL1mi6GbYf3gVQhD3LwSpfX6hgCfjZm3LjM
wfpzUqUiyYUKytRWWDi69hkfNIuLznGBcAi+AtSEC0nsdHZ6umSsfug15/FlIRXq
JBh8K5F6BXS0NdISREH4jh8DZHAg5EU1/UFryYC5z/0SQQUE/eeVdrXdyooNX/HK
I+uW++brIlfcuNdRkLDvbiJVFeBoZOS3KdLeut7b4ZIPd9QdeRSC2NQziNgDKw0M
i3lN0Sk4j7/OTx8vKj7W8GE63VhAYkvEMC0eGMicWS34xnXk6D3nvBr5w9f2tkHl
Wz/68x0iDtvBeA5wCfjLwm9PLa0FS+IyUS4wQ6YeYlTZ50W7nt9c4XAZoqmstv9Z
SzN6u73D2udBbNVPtjFiTVWOc+HMFztzB99lAjgjXvu+epi/a31RKRm5mL72np7x
VH9n+ebc6PQkSVd2F3dO7ZHISG7JkoiLCFQ1r8uHPNjFuB/m3rX9Q1YzrTfSensx
FvdaDQgnHWU=
=0Rck
-----END PGP SIGNATURE-----

--cDtQGJ/EJIRf/Cpq--
