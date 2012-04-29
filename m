From: "Norbert Scheibner" <scno@gmx.net>
Subject: Re: cross-subvolume cp --reflink
Date: Sun, 29 Apr 2012 22:05:34 +0200
Message-ID: <op.wdjl3kx0r07q8e@tron.scheibner.rb>
References: <20120401152749.61790@gmx.net>
 <CALJXSJpjOX3t6Xa=gFF2p13eSb+SJfRc_pc0d5ScShnK-5BwkQ@mail.gmail.com>
 <2272893.XFoXOC5Zif@bursa22>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15;
	format=flowed	delsp=yes
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?iso-8859-15?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>,
	"Hubert Kario" <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2272893.XFoXOC5Zif@bursa22>
List-ID: <linux-btrfs.vger.kernel.org>

Am 29.04.2012, 01:53 Uhr, schrieb Hubert Kario <hka@qbs.com.pl>:

> On Sunday 01 of April 2012 11:42:23 J=E9r=F4me Poulin wrote:
>> On Sun, Apr 1, 2012 at 11:27 AM, Norbert Scheibner <scno@gmx.net> wr=
ote:
>> > Some users tested this patch successfully for week,s or months in =
2 =20
>> or 3
>> > kernel versions since then, true?
>> If this feature must be implented in VFS in another patch, why not
>> just activate what works and make the future patch disable it again?
>
> Why would (should) it be impleemented in VFS? reflink copy is complet=
ely
> different from normal copy and hard link.

I wouldn't make a VFS issue out of that. That should be another discuss=
ion.

But:
> Subvolumes in btrfs are barriers *only* in btrfs and not visible in V=
=46S.

That is just a bug in my opinion, so it should work anyway, but to look=
 at =20
it from VFS point of view is strengthening me in wanting the outstandin=
g =20
patches integrated, as this feature could be supported by VFS in the =20
future.

> IMHO it's strictly btrfs business and not supporting reflink copy bet=
ween
> arbitrary directories is a bug.

I don't know exactly, but I think ZFS is another candidate for "cp =20
--reflink". For some of the log-structured filesystems this could be =20
usefull too, but I don't know if some of them already supports this or =
=20
plan to support this in the future.

Greetings
     Norbert
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
