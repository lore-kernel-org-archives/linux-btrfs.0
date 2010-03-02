From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: BackupPC, per-dir hard link limit, Debian packaging
Date: Tue, 2 Mar 2010 14:09:22 +0100
Message-ID: <201003021409.22441.hka@qbs.com.pl>
References: <1267496945.9222.155.camel@lifeless-64>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Robert Collins <robertc@robertcollins.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1267496945.9222.155.camel@lifeless-64>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 02 March 2010 03:29:05 Robert Collins wrote:
> As I say, I realise this is queued to get addressed anyway, but it se=
ems
> like a realistic thing for people to do (use BackupPC on btrfs) - eve=
n
> if something better still can be written to replace the BackupPC stor=
e
> in the future. I will note though, that simple snapshots won't achiev=
e
> the deduplication level that BackupPC does, because the fils don't st=
art
> out as the same: they are identified as being identical post-backup.

Isn't the main idea behind deduplication to merge identical parts of fi=
les=20
together using cow? This way you could have many very similar images of=
=20
virtual machines, run the deduplication process and reduce massively th=
e space=20
used while maintaining the differences between images.

If memory serves me right, the plan is to do it in userland on a post-f=
act=20
filesystem, not when the data is being saved. If such a daemon or progr=
am was=20
available you would run it on the system after rsyncing the workstation=
s.

Though the question remains which system would reduce space usage more =
in your=20
use case. From my experience, hardlinks take less space on disk, I don'=
t know=20
whatever it could be possible to optimise btrfs cow system for files th=
at are=20
exactly the same.

>=20
> Cheers,
> Rob
>=20

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl

System Zarz=C4=85dzania Jako=C5=9Bci=C4=85
zgodny z norm=C4=85 ISO 9001:2000
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
