From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: btrfs-convert processing time
Date: Mon, 20 Feb 2012 14:50:02 +0100
Message-ID: <1920178.zXOEpupmQW@k85hala03>
References: <4F4241D1.4080506@daevel.fr> <20458953.qbO19NXijp@k85hala03> <4F424D8D.4030802@daevel.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F424D8D.4030802@daevel.fr>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 20 of February 2012 14:41:33 Olivier Bonvalet wrote:
> On 20/02/2012 14:20, Hubert Kario wrote:
> > On Monday 20 of February 2012 13:51:29 Olivier Bonvalet wrote:
> >> Hi,
> >>=20
> >> I'm trying to convert two ext4 FS to btrfs, but I'm surprised by t=
he
> >> time needed to do that conversion.
> >>=20
> >> The first FS is on a 500GiB block device, and btrfs-convert is run=
ning
> >> since more than 48h :
> >> root      1978 25.6 47.7 748308 732556 ?       D    Feb18 944:44
> >> btrfs-convert /dev/vg-backup/backup
> >>=20
> >> The second is on a 340GiB block device, and the processing time is
> >> similar : root     30192  5.2  3.0  73180 61520 pts/0    R    Feb1=
8
> >> 121:04 btrfs-convert /dev/vg-balor/backup
> >>=20
> >>=20
> >> Is it "normal", or is there a problem during the processing ?
> >>=20
> >> Thanks,
> >> Olivier
> >=20
> > How much free space did those FS have? How many files were on them =
(was
> > they dominated by small or large files)?
> >=20
> > Regards,
>=20
> Lot of small files (like compressed email from Maildir), and lot of
> hardlinks, and probably low free space (near 15% I suppose).
>=20
>=20
> So I think I have my answer :)
>=20

Yes, this is probably the worst possible combination.

Plese keep us updated. Just to have exact numbers for new users.

Regards,
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
