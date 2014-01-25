Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35153 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaAYOBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 09:01:15 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Cc: Kai Krakow <hurikhan77+btrfs@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Options for SSD - autodefrag etc?
Date: Sat, 25 Jan 2014 15:01:13 +0100
Message-ID: <3664592.9YULOPb9vW@merkaba>
In-Reply-To: <CAK5rZE6bF+z6Y9=X7SxtRPHE=1nNRPMmASC0VU8u90HQ_LbzVA@mail.gmail.com>
References: <52E2B73E.1050903@gmail.com> <7uuara-hf5.ln1@hurikhan77.spdns.de> <CAK5rZE6bF+z6Y9=X7SxtRPHE=1nNRPMmASC0VU8u90HQ_LbzVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 25. Januar 2014, 15:33:08 schrieb Imran Geriskovan:
> Every write on a SSD block reduces its data retension capability.
> 
> No concrete figures but it is assumed to be
> - 10 years for new devices
> - 1 year at rated usage. (There are much lower figures around)

Where do you have these figures from?

For the Intel SSD 320 in this ThinkPad T520 I read about a minimal usable live 
of 5 years with 20 GB host writes each day in the tech specs. Thats 7300 GB a 
year or 7,3 TB. I assume metric system here.

According to smartctl it has written

241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       
-       360158

360158 * 32 MiB (hmmm, now according to smartctl output this is MiB) which 
gives almost 11 TiB (10,99).

The SSD is over 2,5 years old. Thats less than 5 TiB a year.

So that would lay within the range you say. Although the Intel SSD 320 isn´t 
basically a new device in my eyes.


Thats with KDE session with Akonadi and desktop search, sometimes even two KDE 
sessions and a load of applications running at times.


Anyway that SSDs still thinks it is well *new*:

233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       
-       0


Thats the same media wearout indicator (which takes into account the amount of 
Erase cycles according to Intel docs) it had at the first day I used it.


So I am basically not concerned.


While autodefrag mal cause additional writes… that would not even be the main 
reason for me not to use it at the moment. I am just not convinced that it 
gives any noticable benefit. And given that… of course it doesn´t make sense to 
me to have it cause additional writes to the SSD.

But I am not using it due to avoiding those additional writes in the first 
place.


My most important recommendation regarding SSDs still is: Keep some space 
free. Yeah, SSD manufacturers are doing this. But in another Intel SSD PDF I 
saw some graphs that convinced me in an instant that leaving free about 20% is 
a good idea. But heck, due to the current fill status of this SSD I do not even 
adhere to my own recommendation at the moment.

Then a occasional fstrim, maybe mount with noatime (cause who cares about it 
at all?)…

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
