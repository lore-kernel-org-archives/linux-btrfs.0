From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Content based storage
Date: Wed, 17 Mar 2010 16:25:50 +0100
Message-ID: <201003171625.50257.hka@qbs.com.pl>
References: <hnnijd$jol$1@dough.gmane.org> <hnq3pd$801$1@dough.gmane.org> <201003170948.18819.hjclaes@web.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003170948.18819.hjclaes@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 17 March 2010 09:48:18 Heinz-Josef Claes wrote:
> Hi,
>=20
> just want to add one correction to your thoughts:
>=20
> Storage is not cheap if you think about enterprise storage on a SAN,
> replicated to another data centre. Using dedup on the storage boxes l=
eads
>  to performance issues and other problems - only NetApp is offering t=
his at
>  the moment and it's not heavily used (because of the issues).

there are at least two other suppliers with inline dedup products and t=
here is=20
OSS solution: lessfs

> So I think it would be a big advantage for professional use to have d=
edup
> build into the filesystem - processors are faster and faster today an=
d not
>  the cost drivers any more. I do not think it's a problem to "spend" =
on
>  core of a 2 socket box with 12 cores for this purpose.
> Storage is cost intensive:
> - SAN boxes are expensive
> - RAID5 in two locations is expensive
> - FC lines between locations is expensive (depeding very much on wher=
e you
> are).

In-line dedup is expensive in two ways: first you have to cache the dat=
a going=20
to disk and generate checksum for it, then you have to look if such blo=
ck is=20
already stored -- if the database doesn't fit into RAM (for a VM host i=
t's more=20
than likely) it requires at least few disk seeks, if not a few dozen fo=
r=20
really big databases. Then you should read the block/extent back and co=
mpare=20
them bit for bit. And only then write the data to the disk. That reduce=
s your=20
IOPS by at least an order of maginitude, if not more.=20

=46or post-process dedup you can go as fast as your HDDs will allow you=
=2E And=20
then, when your machine is mostly idle you can go and churn through the=
 data.

IMHO in-line dedup is a good thing only as storage for backups -- when =
you=20
have high probability that the stored data is duplicated (and with a 1:=
10=20
dedup ratio you have 90% probability, it is).

So the CPU cost is only one factor. HDDs are a major bottleneck too.

All things considered, it would be best to have both post-process and i=
n-line=20
data deduplication, but I think, that in-line dedup will see much less =
use.

>=20
> Naturally, you would not use this feature for all kind of use cases (=
eg.
> heavily used database), but I think there is enough need.
>=20
> my 2 cents,
> Heinz-Josef Claes
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
