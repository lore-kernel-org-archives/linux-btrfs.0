From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: How to fasten btrfs?
Date: Tue, 25 Jan 2011 15:56:51 +0100
Message-ID: <201101251556.51806.hka@qbs.com.pl>
References: <AANLkTikMucRF3e-w_x7HnfjPZ-8EmQyhSfcTCihQZmTg@mail.gmail.com> <201101251130.37051.hka@qbs.com.pl> <AANLkTik_mfFO+ciZbxuuqqRJDkOGoOW=pfjVv0au80TS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Magicloud Magiclouds <magicloud.magiclouds@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik_mfFO+ciZbxuuqqRJDkOGoOW=pfjVv0au80TS@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, January 25, 2011 15:28:11 Magicloud Magiclouds wrote:
> So you were saying that, even an unlink operation, the system walks
> through all file data blocks? I thought unlink wouldn't have to write
> too much data.

No, but the amount of data to be changed if the number of extents is sm=
all=20
will be lower.

>=20
> On Tue, Jan 25, 2011 at 6:30 PM, Hubert Kario <hka@qbs.com.pl> wrote:
> > On Tuesday 25 of January 2011 07:45:02 Magicloud Magiclouds wrote:
> >> Hi,
> >>   I am using 2.6.36.3 kernel with btrfs, 512MB memory and a very s=
low
> >> disk, no special options for mounting btrfs except noatime. Now I
> >> found it very slow. When I rm a 5GB movie, it took 20 secs.
> >=20
> > try mounting with nodatacow and defragment the directory the file r=
esides
> > in
> >=20
> > Regards
> > --
> > Hubert Kario
> > QBS - Quality Business Software
> > 02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
> > tel. +48 (22) 646-61-51, 646-74-24
> > www.qbs.com.pl

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
