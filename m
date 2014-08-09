Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37264 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaHISVu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Aug 2014 14:21:50 -0400
Date: Sat, 9 Aug 2014 11:21:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140809182113.GI12778@merlins.org>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
 <2242759.aOKEuU2TTR@xev>
 <20140809143206.GJ11855@bitfolk.com>
 <CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
 <CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
 <pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 09, 2014 at 05:01:24PM +0000, Duncan wrote:
> Jose Ildefonso Camargo Tolosa posted on Sat, 09 Aug 2014 11:06:37 -0500 as
> excerpted:
> 
> > 3.16 (still in development)
> 
> ??
> 
> 3.16 has been out for nearly a week now and we're nearing half-way thru 
> the 3.17 commit-window.  Based on the kernel git I have here, Linus' 
> commit officially changing the makefile entry to 3.16 was on Sunday, Aug 
> 3, at 15:25:02 -0700.
> 
> The last pre-3.16 commit was a merge of two timer-related fixes from the 
> tip-tree at 9:58:20 -0700 that morning.
> 
> So where does your "still in development" come from?

You could argue that since 3.16.0 does not have the recently found
deadlock patch that's been plaging 15 and 16 (14 not as much for me),
it's not usable for some (it ran about 1 day on my laptop before
deadlocking, and maybe an hour at most on my server).

I sure hope that deadlock patch is going to be added to the 3.16.x tree,
I'm not super stocked with being stuck at 3.14.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
