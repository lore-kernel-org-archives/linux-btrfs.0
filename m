From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Subject: Re: BTRFS, encrypted LVM and disk write cache ?
Date: Fri, 13 May 2011 11:33:30 +0200
Message-ID: <1305279210.3052.28.camel@tethys>
References: <1305179125.3106.3.camel@tethys>
	 <20110512154224.GD19041@dhcp231-156.rdu.redhat.com>
	 <1305236204.3277.1.camel@tethys>
	 <BANLkTimQVkzzhaQiur92KxQ2yBgGap5eRA@mail.gmail.com>
	 <1305277193.3052.24.camel@tethys>
	 <BANLkTi=CF--tqdo0AtnFYbaepMP=-_ZKuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=CF--tqdo0AtnFYbaepMP=-_ZKuw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Le vendredi 13 mai 2011 =C3=A0 16:16 +0700, Fajar A. Nugraha a =C3=A9cr=
it :

> IIRC 2.6.38 has a bug in that you can't use mount option "subvol=3D..=
=2E"
> if the fs/subvolume is newly created, while 2.6.39 works fine. At
> least that's what I experienced, so now I use subvolid to select
> subvolume.

# uname -a
Linux tethys 2.6.38-8-generic #42-Ubuntu SMP Mon Apr 11 03:31:50 UTC
2011 i686 i686 i386 GNU/Linux


# grep btrfs fstab
/dev/VG1/TETHYS	/		btrfs	subvol=3DUBUNTU,compress=3Dzlib,relatime	0 0
/dev/sda2	/boot		btrfs	compress=3Dzlib,relatime			0 0
/dev/VG1/TETHYS	/home		btrfs	subvol=3DHOME,compress=3Dzlib,relatime	0 0
/dev/VG1/TETHYS	/tmp		btrfs	subvol=3DTMP,compress=3Dzlib,relatime	0 0
/dev/VG1/TETHYS	/var		btrfs	subvol=3DVAR,compress=3Dzlib,relatime	0 0

# mount | grep btrfs
/dev/mapper/VG1-TETHYS on / type btrfs
(rw,relatime,subvol=3DUBUNTU,compress=3Dzlib)
/dev/mapper/VG1-TETHYS on /tmp type btrfs
(rw,relatime,subvol=3DTMP,compress=3Dzlib)
/dev/mapper/VG1-TETHYS on /home type btrfs
(rw,relatime,subvol=3DHOME,compress=3Dzlib)
/dev/mapper/VG1-TETHYS on /var type btrfs
(rw,relatime,subvol=3DVAR,compress=3Dzlib)
/dev/sda2 on /boot type btrfs (rw,relatime,compress=3Dzlib)


(Maybe worth noting that /boot actually points to a subvol as well,
which is set as default subvol as grub2 would seem not to manage
non-default subvol)


> A 60GB Corsair Force should be about $140. Highly recommended. Higher
> capacities provide even better cost/GB.

I'll note this for my next national lottery win ;-)))



--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
