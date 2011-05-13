From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: BTRFS, encrypted LVM and disk write cache ?
Date: Fri, 13 May 2011 13:54:44 +0700
Message-ID: <BANLkTimQVkzzhaQiur92KxQ2yBgGap5eRA@mail.gmail.com>
References: <1305179125.3106.3.camel@tethys>
	<20110512154224.GD19041@dhcp231-156.rdu.redhat.com>
	<1305236204.3277.1.camel@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305236204.3277.1.camel@tethys>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 13, 2011 at 4:36 AM, Sw=E2mi Petaramesh <swami@petaramesh.o=
rg> wrote:
> However shifting from ext3 to BTRFS has been enough to turn my perfec=
tly
> stable system into a perfectly unstable and crash-prone system :-/

Well, first of all, btrfs is still under heavy development. Add to
that the fact that you use Ubuntu Natty, which also have some known
bugs. There should be some hints there on what the outcome would be :P

Anyway, I'm using linux-image-2.6.38-9-generic from natty-proposed,
with btrfs as "/", separate /boot/grub on ext4, and Corsair Force SSD.
It works great so far. If you're used to ext4 speed, then you'll
notice that btrfs is considerably slower. That's why I use SSD to add
some I/O speed (currently booting to gnome classic desktop only takes
about 30 seconds).

So in summary, if you have problems but still want to try btrfs, try
upgrading your kernel. If you think it's too slow to be usable, then
the best you can try right now is use SSD.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
