From: Tomasz Torcz <tomek@crocom.com.pl>
Subject: Re: single disk reed solomon codes
Date: Mon, 21 Jul 2008 08:48:43 +0200
Message-ID: <1216622923.6970.19.camel@s1.crocom.com.pl>
References: <3da3b5b40807190521x35477489sc06195bb182a4561@mail.gmail.com>
	 <0cb201c8e9b2$a4272b20$0a00a8c0@ALDI2>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <0cb201c8e9b2$a4272b20$0a00a8c0@ALDI2>
List-ID: <linux-btrfs.vger.kernel.org>

Dnia 2008-07-19, sob o godzinie 17:18 +0200, Gerald Nowitzky pisze:

> In the end, you would add very little security by the price of -at least- 
> cutting half your write performance. Thus, I don't think there is any point 
> in adding redundancy to single disk systems.

  ZFS can store multiple copies of data block within one disk. Using
your words, it's like "Intra-Disk-RAID1". After reading data, when
checksum shows it's corrupted, another copy (hopefully correct) is read
from other disk location.
  This is adding security by the price of half storage capacity. Which
seems like a fair game, given todays 1,5TB HDDs.

-- 
Tomasz Torcz

