Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:43810 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbcCGI4G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 03:56:06 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1acqxQ-0004sU-LX
	for linux-btrfs@vger.kernel.org; Mon, 07 Mar 2016 09:56:04 +0100
Date: Mon, 7 Mar 2016 09:56:04 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160307085604.GD6939@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160305200909.GJ1902@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160305200909.GJ1902@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 05, 2016 at 09:09:09PM +0100, Marc Haber wrote:
> On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
> >  So understanding the usage is important to figuring out what's
> >  happening. I'd file a bug and include as much information on how the
> >  fs got into this state as possible. And also if possible make a
> >  btrfs-image using the proper flags to blot out the filenames for
> >  privacy.
> 
> That would btrfs-image -s?

btrfs-image -s -t 8 -s /dev/mapper/fanbtr

complains about a mounted filesystem. Will an image made from the
running system with the filesyste mounted help, or do I need to take
down the machine while the image is being made?

Also, threading does not seem to work, despite the -t 8 CPU usage
never increases 100 % in atop.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
