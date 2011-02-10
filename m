From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [PATCH] Btrfs-progs new btrfs_error() macro to deprecate fprintf(stderr, ...)
Date: Thu, 10 Feb 2011 16:07:43 +0100
Message-ID: <201102101607.44204.hka@qbs.com.pl>
References: <1297349695.28159.21.camel@monotop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Cc: linux-btrfs@vger.kernel.org
To: Eduardo Silva <eduardo.silva@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297349695.28159.21.camel@monotop>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, February 10, 2011 15:54:55 Eduardo Silva wrote:
> Hi,
>=20
> This patch add a new macro called btrfs_error(...) which deprecate th=
e
> use of fprintf(stderr, ...)
>=20
> regards,
>=20
> Eduardo

Sorry, but I don't see a reason for such change. IMHO it only makes the=
 code=20
_less_ readable.

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
