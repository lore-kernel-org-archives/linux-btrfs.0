Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56495 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaHVStX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 14:49:23 -0400
Date: Fri, 22 Aug 2014 11:49:19 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unclean shutdowns cause google-chrome profile to be corrupted in
 various ways
Message-ID: <20140822184919.GE3875@merlins.org>
References: <20140822155040.GU3875@merlins.org>
 <pan$a7366$366442ed$60aa89a1$c636b8e3@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$a7366$366442ed$60aa89a1$c636b8e3@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 22, 2014 at 06:17:38PM +0000, Duncan wrote:
> Marc MERLIN posted on Fri, 22 Aug 2014 08:50:40 -0700 as excerpted:
> 
> > Fairly often (over 20 times for me so far with various kernel versions),
> > when I reboot after a crash, my google-chrome profile is damaged in one
> > of 2 ways:
> > 1) open tabs don't reopen 2) google-chrome says that my profile is
> > corrupted.
> > 
> > In both cases rsyncing ~/.config/google-chrome from the last hourly
> > snapshot has fixed the problem every time.
> 
> I've had a similar issue with firefox, tho I've narrowed it down to a 

Ok, so so far we've had:
1) gogole-chrome
2) firefox
3) mysql

and 3 different people reporting this at least.

Google-chrome is complicated because it has many state files and I
haven't narrowed down which one got corrupted.
In your firefox example, did you find what corruption you got in that
file, or was it just truncated?

For mysql, I got:
InnoDB: Page directory corruption: infimum not pointed to
140708 11:53:58  InnoDB: Page dump in ascii and hex (16384 bytes):
 len 16384; hex 00000000(16KB of 0's).

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
