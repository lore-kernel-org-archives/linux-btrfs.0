From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [PATCH] btrfs-convert: add reiserfs support
Date: Mon, 17 May 2010 12:52:32 +0200
Message-ID: <201005171252.32598.hka@qbs.com.pl>
References: <20100517062600.GA4921@flcl.lan>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org, jason.mcmullan@gmail.com
To: Sean Bartell <wingedtachikoma@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100517062600.GA4921@flcl.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 17 May 2010 08:26:00 Sean Bartell wrote:
> What hasn't been tested:
> - Multiple real-world filesystems (I only have one)
> - 8192-byte blocks (ReiserFS crashes horribly on mount)

Well, AFAIK 8192 blocks are supported only on platforms that have 8kb m=
emory=20
pages (e.g. Alpha), it's a bug it even tries to mount it on x86.

Regards,=20
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
