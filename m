From: Diwaker Gupta <diwaker@maginatics.com>
Subject: Re: Error mounting multi-device fs after restart
Date: Tue, 8 Feb 2011 14:11:18 -0800
Message-ID: <AANLkTikpJ3n20OqfuXOFmymD-Q4BSKzyy2wfcPj-t4ys@mail.gmail.com>
References: <AANLkTi=vSb0i-joekFrZRmwcAE+5w8FwV2FFWcbMvC6n@mail.gmail.com>
	<AANLkTikkUFDTiGqRkMk-VtvxSFS3vNGp0QCn=HPef89V@mail.gmail.com>
	<201102082251.38094.hka@qbs.com.pl>
	<AANLkTi=a2D+NnF5m6iE3m=tmDQK+HRRa0pPm004hsdNV@mail.gmail.com>
	<AANLkTi=rG+NODydGFUNr_LsMgJZ7=B1ae3H7reDOr-pp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hubert Kario <hka@qbs.com.pl>, linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=rG+NODydGFUNr_LsMgJZ7=B1ae3H7reDOr-pp@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>> The system was running overnight when I first hit the problem. On
>> subsequent reboots, I've only waited less than half an hour. Usually
>> the mount is instantaneous, so I wasn't sure if waiting would help a=
t
>> all. The error messages did not indicate that the system could recov=
er
>> at that stage. If there's even a slight chance that the fs would
>> eventually mount, I'm happy to let it run for a day or two. Note tha=
t
>> if I mount using the 'degraded' option, the mount succeeds but
>> subsequent attempts to read the data fail.
>
> Huh. =A0How do those attempts fail?

Same way when I try to do a regular mount: the read blocks and I see a
continuous stream of the 'parent transid verify failed' messages in
dmesg.

> Try mounting ro, or degraded,ro, and reading the data off. =A0That
> worked for me recently on a broken btrfs raid10 (and didn't on anothe=
r
> one, so your mileage may vary).

Ok I'll give these a shot. I still don't quite understand what it
means if btrfsck aborts; if it can't find the superblock on any of the
drives, how would btrfs ever be able to mount the fs?

Diwaker
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
