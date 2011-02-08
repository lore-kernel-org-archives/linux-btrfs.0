From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [Fwd: Re: Suggestion for sticky-compression mount setting (default mount options)]
Date: Tue, 8 Feb 2011 22:42:44 +0100
Message-ID: <201102082242.44516.hka@qbs.com.pl>
References: <1297195153.16890.2.camel@KWOLFF03>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Kirk Wolff <kirk@wolffelectronicdesign.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297195153.16890.2.camel@KWOLFF03>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 08 of February 2011 20:59:13 Kirk Wolff wrote:
> forwarded message below:
>=20
>=20
> It would be very useful.
> I also propose the same for `-o ssd` option. USB drive may be used on
> different computers, and we need the way to specify it only once. As =
for
> the options being per-file, I think having them as per subvolume defa=
ults
> looks better: we can override the defaults on per-file basis while ha=
ving
> reasonable defaults for each subvolume. (There may be also global per=
-pool
> defaults, which may be overriden by subvolumes).

I think that if the file is compressed it should remain compressed and =
the "c"=20
attr should be used for that (both to report it and to set it).

There should be a way to specify *which* type of compression to use in =
a=20
sticky way, system wide and whatever to compress newly created files al=
so=20
'-o ssd' definitely should go in the same basket.

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
