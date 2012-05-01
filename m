From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: btrfs support for efficient SSD operation (data blocks alignment)
Date: Tue, 01 May 2012 19:20:45 +0200
Message-ID: <3479445.PMGU8eoLln@bursa01>
References: <jgui4j$th5$1@dough.gmane.org> <201202101918.57855.Martin@lichtvoll.de> <jnp52p$mrp$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Martin <m_btrfs@ml1.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jnp52p$mrp$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 01 of May 2012 18:04:25 Martin wrote:
> Are 16kByte blocks/sectors useful to btrfs?
>=20
> Or rather, can btrfs usefully use 16kByte blocks?

Yes, and they are already supported using -l and -n flags:

mkfs.btrfs -l $((4*4096)) -n $((4*4096)) /dev/sda1

You can set sector size to 16kb but this requires 16kb memory pages.

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
