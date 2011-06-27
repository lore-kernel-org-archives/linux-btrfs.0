From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [btrfs-delalloc-]
Date: Mon, 27 Jun 2011 15:21:54 +0200
Message-ID: <201106271521.54497.hka@qbs.com.pl>
References: <4E084786.2070200@corp.mail.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E084786.2070200@corp.mail.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 27 of June 2011 11:04:06 Proskurin Kirill wrote:
> Hello all.
>=20
> What we have:
> SL6 - kernel 2.6.32-131.2.1.el6.x86_64
> btrfs on mdadm RAID5 with 8 HDD - 27T partition.
>=20
> I see this at top:
> 1182 root      20   0     0    0    0 R 100.0  0.0  16:39.73
> [btrfs-delalloc-]
>=20
> And LA is grow. What is this and how can I fix it?

delalloc is a delayed allocation kernel thread -- it probably means som=
ething=20
is writing large amounts of data to the file system

2.6.32 is *old* as far as btrfs is concerned, there have been many bugs=
 fixed=20
and performance improvements since

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
