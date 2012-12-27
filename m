Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42663 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2L0Qrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 11:47:37 -0500
Message-ID: <50DC7BA0.2080401@petaramesh.org>
Date: Thu, 27 Dec 2012 17:47:28 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Gene Czarcinski <gene@czarc.net>,
        linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Another novice question & comment
References: <50DC5B51.9060506@czarc.net> <20121227150328.GV19051@carfax.org.uk>
In-Reply-To: <20121227150328.GV19051@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 27/12/2012 16:03, Hugo Mills a écrit :
>    Right now, no, there isn't any way of telling which subvolume is
> mounted at a given location.

Er... Check "subvol=" here...

root@tethys:/# mount | grep btrfs
/dev/mapper/VG1-BTR_POOL on / type btrfs
(rw,relatime,subvol=UBUNTU/@,autodefrag,compress=lzo)
/dev/mapper/VG1-BTR_POOL on /tmp type btrfs
(rw,relatime,subvol=UBUNTU/@tmp,compress=lzo)
/dev/sda2 on /boot type btrfs (rw,relatime,subvol=UBUNTU/@boot,autodefrag)
/dev/mapper/VG1-BTR_POOL on /home type btrfs
(rw,relatime,subvol=UBUNTU/@home,autodefrag,compress=lzo)
/dev/mapper/VG1-BTR_POOL on /storage type btrfs
(rw,relatime,subvol=STORAGE,autodefrag,compress=lzo)
/dev/mapper/VG1-BTR_POOL on /data/BIG type btrfs
(rw,noatime,subvol=DATA/BIG,compress=lzo)


-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

