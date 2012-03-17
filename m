From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: "not enough space" with "data raid0"
Date: Sat, 17 Mar 2012 12:19:09 +0000
Message-ID: <20120317121909.GB3172@carfax.org.uk>
References: <C52pxfli1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C52pxfli1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 17, 2012 at 01:01:00PM +0100, Helmut Hullen wrote:
> Hallo, linux-btrfs,
> 
> I've (once more) created my test system:
> 
>   mkfs.btrfs -d raid0 -m raid1 /dev/sdb1 /dev/sdc1
> 
> 73 GB + 146 GB.
> 
> Then I mounted it and copied about 150 GByte onto it. But copying was  
> incomplete, the job ended with "no space on ..."
> 
> 
> # btrfs fi show
> 
> Label: 'Scsi'  uuid: e30586e9-a903-4d17-8ec0-1781457212c6
> 	Total devices 2 FS bytes used 134.86GB
> 	devid    1 size 68.37GB used 68.37GB path /dev/sdb1
> 	devid    2 size 136.73GB used 68.35GB path /dev/sdc1
> 
> Btrfs Btrfs v0.19
> 
> # btrfs fi df <mountpoint>
> 
> Data, RAID0: total=134.68GB, used=134.67GB
> Data: total=8.00MB, used=8.00MB
> System, RAID1: total=8.00MB, used=16.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=1.00GB, used=185.39MB
> Metadata: total=8.00MB, used=0.00
> 
> # df <mountpoint>
> 
> Filesystem     1K-blocks      Used Available Use% Mounted on
> /dev/sdc1      215059324 141597364      8724 100% /mnt/btr
> 
> # fdisk -l
> 
> Disk /dev/sdb: 73.4 GB, 73407868928 bytes
> Disk /dev/sdc: 146.8 GB, 146814976000 bytes
> 
> -----------------------------------
> 
> Where is the problem, how can I use the full space?

   You can't. btrfs requires RAID-0 to be at least two devices wide
(otherwise it's not striped at all, which is the point of RAID-0). If
you want to use the full capacity of both disks and don't care about
the performance gain from striping, use -d single (which is the
default). If you do care about the performance gain from striping,
then you're going to have to lose some usable space.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I am but mad north-north-west:  when the wind is southerly, I ---  
                       know a hawk from a handsaw.                       

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPZIE8IKyzvlFcI40RAlQfAKC+u/KXRV0FYk6bldOflM7khEVNpgCdFmFN
SEiQdtMLgMQ9EUqxT5OFYqM=
=Evky
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
