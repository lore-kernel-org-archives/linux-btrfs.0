From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: btrfs-convert processing time
Date: Mon, 20 Feb 2012 14:21:55 +0100
Message-ID: <1365193.nZ6gtcoe3h@k85hala03>
References: <4F4241D1.4080506@daevel.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F4241D1.4080506@daevel.fr>
List-ID: <linux-btrfs.vger.kernel.org>

(sorry for the duplicate, previous one has broken signature)
On Monday 20 of February 2012 13:51:29 Olivier Bonvalet wrote:
> Hi,
>=20
> I'm trying to convert two ext4 FS to btrfs, but I'm surprised by the
> time needed to do that conversion.
>=20
> The first FS is on a 500GiB block device, and btrfs-convert is runnin=
g
> since more than 48h :
> root      1978 25.6 47.7 748308 732556 ?       D    Feb18 944:44
> btrfs-convert /dev/vg-backup/backup
>=20
> The second is on a 340GiB block device, and the processing time is si=
milar :
> root     30192  5.2  3.0  73180 61520 pts/0    R    Feb18 121:04
> btrfs-convert /dev/vg-balor/backup
>=20
>=20
> Is it "normal", or is there a problem during the processing ?
>=20
> Thanks,
> Olivier

How much free space did those FS have? How many files were on them (was=
 they=20
dominated by small or large files)?

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
