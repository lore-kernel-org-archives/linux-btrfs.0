From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: ssd option for USB flash drive?
Date: Thu, 19 May 2011 21:53:24 +0200
Message-ID: <201105192153.24797.hka@qbs.com.pl>
References: <20110517220252.GA12323@yahoo.fr> <201105192104.58726.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105192104.58726.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, loks like list mailer doesn't like SMIME messages.

On Thursday 19 of May 2011 21:04:54 Hubert Kario wrote:
> On Wednesday 18 of May 2011 00:02:52 Stephane Chazelas wrote:
> > Hiya,
> >=20
> > I've not found much detail on what the "ssd" btrfs mount option
> > did. Would it make sense to enable it to a fs on a USB flash
> > drive?
>=20
> yes, enabling discard is pointless though (no USB storage supports it
> AFAIK).
>=20
> > I'm using btrfs (over LVM) on a Live Linux USB stick to benefit
> > from btrfs's compression and am trying to improve the
> > performance.
>=20
> ssd mode won't improve performance by much (if any).
>=20
> You need to remember that USB2.0 is limited to about 20-30MiB/s (depe=
nding
> on CPU) so it will be slow no matter what you do
>=20
> > Would anybody have any recommendation on how to improve
> > performance there? Like what would be the best way to
> > enable/increase writeback buffer or any way to make sure writes
> > are delayed and asynchronous? Would disabling read-ahead help?
> > (at which level would it be done?). Any other tip (like
> > disabling atime, aligning blocks/extents, figure out erase block
> > sizes if relevant...)?
>=20
> aligning logical blocks to erase blocks can give some performance but=
 the
> only way to make it really fast is not to use USB
>=20
> > Many thanks in advance,
> > Stephane

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
