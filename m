From: cwillu <cwillu@cwillu.com>
Subject: Re: Error mounting multi-device fs after restart
Date: Tue, 8 Feb 2011 16:04:58 -0600
Message-ID: <AANLkTi=rG+NODydGFUNr_LsMgJZ7=B1ae3H7reDOr-pp@mail.gmail.com>
References: <AANLkTi=vSb0i-joekFrZRmwcAE+5w8FwV2FFWcbMvC6n@mail.gmail.com>
	<AANLkTikkUFDTiGqRkMk-VtvxSFS3vNGp0QCn=HPef89V@mail.gmail.com>
	<201102082251.38094.hka@qbs.com.pl>
	<AANLkTi=a2D+NnF5m6iE3m=tmDQK+HRRa0pPm004hsdNV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hubert Kario <hka@qbs.com.pl>, linux-btrfs@vger.kernel.org
To: Diwaker Gupta <diwaker@maginatics.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=a2D+NnF5m6iE3m=tmDQK+HRRa0pPm004hsdNV@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 8, 2011 at 3:59 PM, Diwaker Gupta <diwaker@maginatics.com> wrote:
>> Define *indefinitely*.
>
> Meaning the messages continued for as long as the system was under observation.
>
>> Are the drives not working?
>
> I believe they are. Working in the sense that I can read off data
> using 'dd', I can inspect partition tables etc.
>
>> If the drives are working, have you tried waiting 2-3 days, possibly longer?
>> 10TB is a *lot* of data
>
> The system was running overnight when I first hit the problem. On
> subsequent reboots, I've only waited less than half an hour. Usually
> the mount is instantaneous, so I wasn't sure if waiting would help at
> all. The error messages did not indicate that the system could recover
> at that stage. If there's even a slight chance that the fs would
> eventually mount, I'm happy to let it run for a day or two. Note that
> if I mount using the 'degraded' option, the mount succeeds but
> subsequent attempts to read the data fail.

Huh.  How do those attempts fail?

Try mounting ro, or degraded,ro, and reading the data off.  That
worked for me recently on a broken btrfs raid10 (and didn't on another
one, so your mileage may vary).

There's also the perpetually imminent fsck development which might save the day.
