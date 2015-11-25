Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58311 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbbKYPO1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 10:14:27 -0500
Date: Wed, 25 Nov 2015 15:14:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Mario <dev@kicherer.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Imbalanced RAID1 with three unequal disks
Message-ID: <20151125151425.GZ24333@carfax.org.uk>
References: <56559D40.9050305@kicherer.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m7GK0ytKUM7VScCy"
In-Reply-To: <56559D40.9050305@kicherer.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--m7GK0ytKUM7VScCy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 25, 2015 at 12:36:32PM +0100, Mario wrote:
> 
> Hi,
> 
> I pushed a subvolume using send/receive to an 8 TB disk, added
> two 4 TB disks and started a balance with conversion to RAID1.
> 
> Afterwards, I got the following:
> 
>   Total devices 3 FS bytes used 5.40TiB
>   devid    1 size 7.28TiB used 4.54TiB path /dev/mapper/yellow4
>   devid    2 size 3.64TiB used 3.17TiB path /dev/mapper/yellow1
>   devid    3 size 3.64TiB used 3.17TiB path /dev/mapper/yellow2
> 
>   Btrfs v3.17
>   Data, RAID1: total=5.43TiB, used=5.39TiB
>   System, RAID1: total=64.00MiB, used=800.00KiB
>   Metadata, RAID1: total=14.00GiB, used=5.55GiB
>   GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> In my understanding, the data isn't properly balanced and I
> only get around 5.9TB of usable space. As suggested in #btrfs,
> I started a second balance without filters and got this:
> 
>   Total devices 3 FS bytes used 5.40TiB
>   devid    1 size 7.28TiB used 5.41TiB path /dev/mapper/yellow4
>   devid    2 size 3.64TiB used 2.71TiB path /dev/mapper/yellow1
>   devid    3 size 3.64TiB used 2.71TiB path /dev/mapper/yellow2
> 
>   Data, RAID1: total=5.41TiB, used=5.39TiB
>   System, RAID1: total=32.00MiB, used=784.00KiB
>   Metadata, RAID1: total=7.00GiB, used=5.54GiB
>   GlobalReserve, single: total=512.00MiB, used=0.00B
> 
>   /dev/mapper/yellow4  7,3T    5,4T  969G   86% /mnt/yellow
> 
> Now, I get 6.3TB of usable space but, in my understand, I should
> get around 7.28 TB or am I missing something here? Also, a second
> balance shouldn't change the data distribution, right?

   The first balance, because it was converting, didn't get the final
outcome right. (Possibly an area for further research on appropriate
algorithms for balance). The second one appears to have done the right
thing. It actually threw me slightly, because your free space isn't
equal on all the devices, but on reflection, that's expected in this
case. You have dev 1 double the size of devs 2 and 3, so in each
RAID-1 block group, one chunk will go on dev 1, and the other chunk
will go on one of the other two devices (spread evenly). This means
that *eventually*, they'll hit all devices with equal free space, but
only when everything's filled up completely. It's just on the edge
case between getting equal free space on all devices and having
unusable space (which you'd have if that 8TB drive was any larger).

   So, yes, all normal and all good.

   As to remaining free space from df, I'm fairly sure that the
algorithm for computing free space for df is just plain wrong. I've
spotted it not quite getting the answer right before. That seems to be
the case here, too; just more so. You have something just under 2 TiB
of usable space on the FS, according to my calculations.

> I'm using kernel v4.3 with a patch [1] from kernel bugzilla [2] for
> the 8 TB SMR drive. The send/receive of a 5 TB subvolume worked
> flawlessly with the patch. Without, I got a lot of errors in dmesg
> within the first 200GB of transferred data. The OS is a x86_64
> Ubuntu 15.04.

   That's useful to know, in case anyone else shows up with write
errors on SMR devices.

   Hugo.

> Thank you!
> Mario
> 
> [1] http://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/commit/?h=bugzilla-93581&id=7c4fbd50bfece00abf529bc96ac989dd2bb83ca4
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=93581

-- 
Hugo Mills             | I was cursed with poetry very young. It creates
hugo@... carfax.org.uk | unrealistic expectations.
http://carfax.org.uk/  |                                   Victor Frankenstein
PGP: E2AB1DE4          |                                        Penny Dreadful

--m7GK0ytKUM7VScCy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWVdBRAAoJEFheFHXiqx3kS9QP/2bf2Tr0nm6AWnE0Sd/72Xaj
PVo2MloLoMu6rk26NTQ5Erf2DEJJaQ4a6pxayDIgBqv/rWc055V+/wz8EiUmDFMP
j7NioUFTDx2h+sMnlMay/UyiNC9VtL6lERH5IPMyYKedbs7KFQ8dyYfkH0Ybp5tz
5/LB0RUUkXrKC0HKnBr123mzWjepbNGAGukb0rVAE4QXw1eUnGE5Es2RVnxjcPIL
sHoHDz1N4ZMljobt5HUEwQhr+WtkWxN3Z0o7O3cTjgnw5H+ZILQ/ZSnkeFoSu7MN
dKlOweu/bsfRICguOPC5amH8D9SdChGq58uJpwA1t/GSTSjQZGvvyNNLqXu88qOZ
chJ/FLkUav5QyIOxzwI113qTyqeABlYMkSD3YqeFifytk2mp2SvcmLE25pp7zaoN
gas3J4kr/aq7D0fLsuddMFGBENkwz04FbM5YZFanIAcc7WIDq3+fJkbtescE1P7w
48a3Ij2yDzZtfQmlrWnbaqywrJMiF/916RCrdPZjzkCZKhv4VGSwjTl1HD9UTjM/
hteoGrohGAHvEqVzWqOdi97JUX9klF84rNbFDkAkdlLu17+zhA+R+j1xwfkOpeQJ
hp1CFPzyTc11075WwZ+lPN/NMGjm6Dxa5AwNBhnAbgsYAO8p1fVZUGE9r75jPPzB
U7URTr61R3HB+95gLkkM
=/udS
-----END PGP SIGNATURE-----

--m7GK0ytKUM7VScCy--
