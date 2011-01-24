From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Bug in mkfs.btrfs?!
Date: Mon, 24 Jan 2011 10:38:35 +0100
Message-ID: <20110124093835.GA24477@scooter>
References: <20110122144513.GA2539@scooter>
 <20110122145222.GB2539@scooter>
 <20110122151124.GC29985@carfax.org.uk>
 <20110122155612.GA3664@scooter>
 <20110123181827.GF29985@carfax.org.uk>
 <4D3CA568.7050506@libero.it>
 <20110123232720.GH29985@carfax.org.uk>
 <20110123235848.GB2560@scooter>
 <AANLkTimXNxakkozObyZCDK+sJqNU5edJrY4ywgERdELC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimXNxakkozObyZCDK+sJqNU5edJrY4ywgERdELC@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Counter question: Why should I? :)


I used dm-crypt with luks some time ago, but it is really slooow. So I =
talked with
the dm-crypt devs. and they gave me the hint to test loop-aes, for more=
 speed. It is
about 4x faster for me :)

And I don't see any advantages using dm-crypt instead of loop-aes.



=46elix

On 24. January 2011 - 08:53, Fajar A. Nugraha wrote:
> Date: Mon, 24 Jan 2011 08:53:41 +0700
> From: "Fajar A. Nugraha" <list@fajar.net>
> To: Felix Blanke <felixblanke@gmail.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: Bug in mkfs.btrfs?!
>=20
> On Mon, Jan 24, 2011 at 6:58 AM, Felix Blanke <felixblanke@gmail.com>=
 wrote:
> > I tried the newest version 2.19-rc1. There seems to be some kind of=
 "fix":
> >
> > scooter ~ # /home/fame/tmp/util-linux-2.19-rc1/mount/losetup -a
> > /dev/loop0: [0010]:3154
> > (/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-pa*), =
encryption =A0(type
> > 16)
>=20
> > If the path is to long they add a '*' :) Do you think that will sol=
ve the problem?
>=20
> It shouldn't.
>=20
> However, since you're using loopback for encryption, why not use
> dm-crypt instead?
>=20
> --=20
> Fajar
---end quoted text---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
