Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:60596 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbcCMVFj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 17:05:39 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afDCk-00058d-4j
	for linux-btrfs@vger.kernel.org; Sun, 13 Mar 2016 22:05:38 +0100
Date: Sun, 13 Mar 2016 22:05:37 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Message-ID: <20160313210537.GW2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <pan$9abbc$75454df4$bbede296$bf2d7878@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <pan$9abbc$75454df4$bbede296$bf2d7878@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2016 at 05:12:35PM +0000, Duncan wrote:
> Marc Haber posted on Sun, 13 Mar 2016 12:58:10 +0100 as excerpted:
> > I see the same metadata spread as with the old filesystem in btrfs fi
> > df,
> > totl at 23 and used at 2.38 GiB. What I find strange is that this
> > filesystem has Data, System and Metadata in "single" profile, is this
> > the new default for a 200 GiB file system?
> 
> Single is default for data.  Metadata (and system) will normally default 
> to dup on a single device, raid1 on multi-device, EXCEPT on detected 
> SSDs, where it defaults to single as well, because the firmware on some 
> ssds will dedup it in any case.  If you know your ssd isn't one of the 
> deduping ones (as I do, here), you can of course overrule that by 
> specifying modes at mkfs.btrfs time.

It was both times the same Samsung 840 EVO. Has this SSD detection
been added recently, or did older versions of mkfs.btrfs not detect an
SSD through a crypto layer, maybe?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
