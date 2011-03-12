From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [PATCH v1 0/3] btrfs-progs: scrub interface
Date: Sat, 12 Mar 2011 21:39:34 +0100
Message-ID: <201103122139.35220.hka@qbs.com.pl>
References: <cover.1299954564.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1299954564.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 12 of March 2011 19:31:32 Jan Schmidt wrote:
> This patch set for btrfs-progs is meant to be used together with the =
scrub
> kernel patches submitted by Arne Jansen (latest Subject: [PATCH v3 0/=
6]
> btrfs: scrub).
>=20
(snip)
>=20
>  Makefile     |    4 +-
>  btrfs.c      |   12 +
>  btrfs_cmds.c |    3 +-
>  btrfs_cmds.h |    4 +
>  ctree.h      |    2 +-
>  ioctl.h      |   68 +++-
>  scrub.c      | 1425
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 7 files
> changed, 1513 insertions(+), 5 deletions(-)
>  create mode 100644 scrub.c

Please, update the man pages.

Regards,
--=20
Hubert Kario
QBS - Quality Business Software
ul. Ksawer=F3w 30/85
02-656 Warszawa
POLAND
tel. +48 (22) 646-61-51, 646-74-24
fax +48 (22) 646-61-50
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
