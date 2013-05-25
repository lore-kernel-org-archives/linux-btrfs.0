Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59976 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab3EYWrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 18:47:03 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Recommended settings for SSD
Date: Sun, 26 May 2013 00:46:56 +0200
Message-ID: <6555447.0nnTVXRBLE@merkaba>
In-Reply-To: <1751895.r3q1HmeO0C@merkaba>
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com> <pan$1197$73f28aeb$cb95553f$36bb7307@cox.net> <1751895.r3q1HmeO0C@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 25. Mai 2013, 14:13:07 schrieb Martin Steigerwald:
> The SSD is in use for about 2 years. I left about 25 GiB free of the 300 GB it 
> has.
> 
> merkaba:~> smartctl -a /dev/sda | grep Host
> 225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       
> -       261260
> 227 Workld_Host_Reads_Perc  0x0032   100   100   000    Old_age   Always       
> -       49
> 241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       
> -       261260
> 242 Host_Reads_32MiB        0x0032   100   100   000    Old_age   Always       
> -       559520
> 
> So thats 261260 * 32 MiB = 8360320 MiB = 8164,375 GiB = about 8 TiB writes in 
> total.
> 
> Intel claims a useful life of 5 years with 20 GB of host writes per day. For 2 
> years thats 365*20 = 7300 GB. So it seems that I am exceeding this a bit.
> 
> Strange, last time I looked it was way under the specified limit. KDE Nepomuk / 
> Akonadi stuff? Switch of /home to BTRFS? I don´t know. What I know that Akonadi 
> / KDEPIM has gone wild once and wrote 450 GB in a row until I stopped it doing 
> that manually.

Well, all is well: I just calculated for one year. But the SSD is two years old.

That makes: 365*2*20 = 14600 GB. About 8 TiB is way below it :)

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
