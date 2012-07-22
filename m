Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43300 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2GVUob (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jul 2012 16:44:31 -0400
Date: Sun, 22 Jul 2012 13:44:28 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        mbroz@redhat.com, Calvin Walton <calvin.walton@kepstin.ca>,
        jeff@deserettechnology.com
Subject: Re: brtfs on top of dmcrypt with SSD -> ssd or nossd + crypt performance?
Message-ID: <20120722204428.GC3925@merlins.org>
References: <20120202124241.GW16796@shiny> <20120718220446.GB3888@merlins.org> <20120722185848.GA10089@merlins.org> <201207222135.11159.Martin@lichtvoll.de> <20120202124241.GW16796@shiny> <20120718220446.GB3888@merlins.org> <20120722185848.GA10089@merlins.org> <201207222135.11159.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201207222135.11159.Martin@lichtvoll.de> <201207222135.11159.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 22, 2012 at 09:35:10PM +0200, Martin Steigerwald wrote:
> Or use atop to have a complete system overview during the hdparm run. You 
> may want to use its default 10 seconds delay.
 
atop looked totally fine and showed that a long dd took 6% CPU of one core.

> Anyway, hdparm is only a very rough measurement. (Test time 2 / 3 seconds 
> is really short.)
> 
> Did you repeat tests three or five times and looked at the deviation?

Yes. I also ran dd with 1GB, and got the exact same number.

Thanks for confirming that it is indeed way faster for you, and you're going
through the filesystem layer which makes it slower compared to my doing dd
against the raw device.

But anyway, while my question about using 'nossd' is on topic here, speed of
raw device falling dramatically once encrypted isn't really relevant here,
so I'll continue on the dm-crypt mailing list.

Thanks
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
