From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: bcp command not installed by Makefile
Date: Fri, 11 Jun 2010 14:12:07 +0200
Message-ID: <201006111412.07560.hka@qbs.com.pl>
References: <AANLkTimRn1NJsivc6HD8W5K3QKQoPdmvfK54o6TOY37c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Palmer Cox <palmercox@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimRn1NJsivc6HD8W5K3QKQoPdmvfK54o6TOY37c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 11 of June 2010 03:46:11 Palmer Cox wrote:
> Is there a reason the bcp command isn't installed when running make
> install?  If not, here is a really simple patch to add it to the
> install.
>=20
> -Palmer Cox

Does 'bcp' can do anything additional that the 'cp --reflink=3Dalways'?

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
