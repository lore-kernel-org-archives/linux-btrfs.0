From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Bug in mkfs.btrfs?!
Date: Mon, 24 Jan 2011 08:53:41 +0700
Message-ID: <AANLkTimXNxakkozObyZCDK+sJqNU5edJrY4ywgERdELC@mail.gmail.com>
References: <20110122144513.GA2539@scooter>
	<20110122145222.GB2539@scooter>
	<20110122151124.GC29985@carfax.org.uk>
	<20110122155612.GA3664@scooter>
	<20110123181827.GF29985@carfax.org.uk>
	<4D3CA568.7050506@libero.it>
	<20110123232720.GH29985@carfax.org.uk>
	<20110123235848.GB2560@scooter>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110123235848.GB2560@scooter>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 24, 2011 at 6:58 AM, Felix Blanke <felixblanke@gmail.com> w=
rote:
> I tried the newest version 2.19-rc1. There seems to be some kind of "=
fix":
>
> scooter ~ # /home/fame/tmp/util-linux-2.19-rc1/mount/losetup -a
> /dev/loop0: [0010]:3154
> (/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-pa*), en=
cryption =A0(type
> 16)

> If the path is to long they add a '*' :) Do you think that will solve=
 the problem?

It shouldn't.

However, since you're using loopback for encryption, why not use
dm-crypt instead?

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
