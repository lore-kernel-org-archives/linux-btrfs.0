From: Diwaker Gupta <diwaker@maginatics.com>
Subject: Re: Error mounting multi-device fs after restart
Date: Tue, 8 Feb 2011 13:59:45 -0800
Message-ID: <AANLkTi=a2D+NnF5m6iE3m=tmDQK+HRRa0pPm004hsdNV@mail.gmail.com>
References: <AANLkTi=vSb0i-joekFrZRmwcAE+5w8FwV2FFWcbMvC6n@mail.gmail.com>
	<AANLkTikkUFDTiGqRkMk-VtvxSFS3vNGp0QCn=HPef89V@mail.gmail.com>
	<201102082251.38094.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201102082251.38094.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

> Define *indefinitely*.

Meaning the messages continued for as long as the system was under obse=
rvation.

> Are the drives not working?

I believe they are. Working in the sense that I can read off data
using 'dd', I can inspect partition tables etc.

> If the drives are working, have you tried waiting 2-3 days, possibly =
longer?
> 10TB is a *lot* of data

The system was running overnight when I first hit the problem. On
subsequent reboots, I've only waited less than half an hour. Usually
the mount is instantaneous, so I wasn't sure if waiting would help at
all. The error messages did not indicate that the system could recover
at that stage. If there's even a slight chance that the fs would
eventually mount, I'm happy to let it run for a day or two. Note that
if I mount using the 'degraded' option, the mount succeeds but
subsequent attempts to read the data fail.

> getting the FS mountable is your best bet at the moment (apart from d=
iving in
> the drive with dd in one hand and hexdump in the other...)

sigh, I feared as much.

>> >
>> > I'm happy to provide any other information required. Please CC me =
on
>> > replies as I'm not subscribed to the list.
>> >
>> > Thanks,
>> > Diwaker
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> --
> Hubert Kario
> QBS - Quality Business Software
> 02-656 Warszawa, ul. Ksawer=F3w 30/85
> tel. +48 (22) 646-61-51, 646-74-24
> www.qbs.com.pl
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
