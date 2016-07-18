Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aarghimedes.fi ([62.75.165.48]:45527 "EHLO aarghimedes.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbcGRS42 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 14:56:28 -0400
Subject: Re: Status of SMR with BTRFS
To: Matthias Prager <linux@matthiasprager.de>, Henk Slager <eye1tm@gmail.com>
References: <91da7783-ffa1-7d35-a364-344c61e7ddbe@matthiasprager.de>
 <CAPmG0jb+FMOMNWhsOhE1gzsry_x862pjSO_wV8_PFbyaBoEmUg@mail.gmail.com>
 <5c31c6fd-5f4a-0fb6-07c9-a56964f30262@matthiasprager.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jukka Larja <roskakori@aarghimedes.fi>
Message-ID: <578D24CB.8030106@aarghimedes.fi>
Date: Mon, 18 Jul 2016 21:49:47 +0300
MIME-Version: 1.0
In-Reply-To: <5c31c6fd-5f4a-0fb6-07c9-a56964f30262@matthiasprager.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

18.7.2016, 0.44, Matthias Prager kirjoitti:

> the Seagate SMR drives are fast enough to handle Gbit-LAN
> speeds if they are served mostly large sequential chunks by the file
> system, which f2fs actually manages to do (cold storage in my scenario
> too). Btrfs does too many scattered writes for this to work without
> bandages (i.e. caching or snapshotting) (although I do see the advantage
> in having checksums for data which you write once and then read like
> once every year).

I have two 8 TB Seagate Archive drives (which did cause me lots of extra 
work, before I got everything patched and/or hardware to work correctly) in 
Btrfs raid1[0] configuration. They serve as backup for DVR (and for testing, 
as a backup of a backup of my Windows laptop) with around 4 TB of 
recordings. Original rsync ran at about network speed. Both drives were 
writing a bit over 100 MB/s for the whole time.

Backups are updated once per day, few GBs of recordings and around 5000 
small files from laptop changed, removed or created. I'm sort of waiting for 
something to explode, but so far it seems to be working fine. Maybe I'll put 
some real backups there some day.

[0] No need to tell me this shouldn't be done. It's for testing purposes.

-- 
      ...Elämälle vierasta toimintaa...
     Jukka Larja, Roskakori@aarghimedes.fi

"Later subverted by himself; when he tried to march through the Makran 
desert *SPOILER ALERT*. Ouch..."
"Buddy, Alexander is literally ancient history. There are limits to the 
spoiler tag."
- TV Tropes Wiki, Never Tell Me The Odds, Aleksanteri suuresta -
