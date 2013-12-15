Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44498 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3LOUY5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 15:24:57 -0500
Date: Sun, 15 Dec 2013 20:24:56 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Leonidas Spyropoulos <artafinde@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs balance on single device
Message-ID: <20131215202456.GA11281@carfax.org.uk>
References: <CAAeznTpG6A7ygKg1AUx_pAMs_SNwG4a4C5gHPeT+HcKRsD+TWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
In-Reply-To: <CAAeznTpG6A7ygKg1AUx_pAMs_SNwG4a4C5gHPeT+HcKRsD+TWA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 15, 2013 at 08:20:19PM +0000, Leonidas Spyropoulos wrote:
> Hey all,
> 
> Just did a btrfs balance on a single device. Before the balance
> operation here is the df result:
> 
> inglor@tiamat ~$ btrfs fi df /home
> Data: total=19.19GB, used=9.34GB
> System, DUP: total=32.00MB, used=4.00KB
> Metadata, DUP: total=896.00MB, used=227.98MB
> 
> Then I issues a balance operation relocating the chunks across a single device:
> inglor@tiamat ~$ sudo btrfs fi balance /home
> [sudo] password for inglor:
> Done, had to relocate 28 out of 28 chunks
> 
> After I did another df:
> inglor@tiamat ~$ btrfs fi df /home
> Data: total=10.00GB, used=9.34GB
> System, DUP: total=32.00MB, used=4.00KB
> Metadata, DUP: total=384.00MB, used=226.80MB
> 
> Anyone can explain me the Data row of the above output ? It used to be
> 19.19GB and now it's 10.00GB. It's like the partition shrunk!? The
> balance operation finished without issues.

   It freed up some of the unused data chunks, returning them to the
unallocated space on the device.

> Here's some other information:
> 
> inglor@tiamat ~$ sudo btrfs filesystem show
> Label: 'home'  uuid: 458c70e2-7037-4c4d-bba2-3d5288f04510
>     Total devices 1 FS bytes used 9.56GB
>     devid    1 size 21.00GB used 10.81GB path /dev/sda3

   You can see that the filesystem is still the same size as before --
it's just that less of it is allocated.

   There's nothing to worry about here -- it's all working as expected.

   Hugo.

> Label: none  uuid: 699d671b-7064-441d-95ec-c616049fe287
>     Total devices 1 FS bytes used 13.94GB
>     devid    1 size 20.00GB used 20.00GB path /dev/sda2
> 
> Btrfs v0.20-rc1-358-g194aa4a-dirty
> inglor@tiamat ~$ df
> Filesystem     1K-blocks      Used Available Use% Mounted on
> /dev/sda2       20971520  15362816   3960288  80% /
> /dev/sda3       22020096  10256168  11375416  48% /home
> 
> Thanks,
> Leonidas
> 
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- If you're not part of the solution, you're part ---         
                           of the precipiate.                            

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUq4QGFheFHXiqx3kAQKO0xAAnE7wsLEbupVLiaM9ExKXROPR8+hGw9sK
M7Kl1X6LXRMLWEd4ruz8VkMrgDSHlbZPsp1QW7Q1z5ZtO9x4Lj/qPa6cb+EpFqDu
uoOYshcpI0AgK1wj+qiy1Z0c+7SopvYVOjZt3xRSRN/JNlKUyLBJfURQ5c/n5MBv
KDuvf8xbddvt/TcfyMLeg5kTZgsC9HU3W2yjWtuJHgMh4W2cMbHzrAEAS1lYV6Jf
vSfKOSV/bnvpqKWq05Yucg2eg9qbuh7feK5z/ecNiKvWowyHlKxrLbddFXCLm+H9
B09ne2K5g+OScJd8K/2Wg0T0taQRUKshPnN6zMMg3iTQmg0OavsE75bcuGJQtdL3
QeJ/cw+MxJX3zdAtW8lOEl2ds9uovyKIaAikV+acc5vh1cyCqHm4ozCsUFRxeSvJ
ev82S0SScsu66yJ9FOH0+/l8xwmfnqQVaDCQAyzWnIgs+0BPnndWo8wYqibRM/TM
1bnBrBXU6pgxdzPhmwcF1nYa24DAnF70C6LUAn76kqHAql4cK7jh+d0FE6ZnukT+
cRAbCyrp0xZbuRGcGOaj6l8Ayr8CEqVPG/M2j6LcWxxMricnN7+romf0+axWjcos
NK3nEPQ2GP16RBO/R9U2vYNYyta+sLe0nC8t0ufEz6QVzecRJWeZh70V6Gjmu2Mv
LEcrm5fh5t0=
=MUU1
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
