Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60132 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaHWDK6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 23:10:58 -0400
Date: Fri, 22 Aug 2014 20:10:55 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unclean shutdowns cause google-chrome profile to be corrupted in
 various ways
Message-ID: <20140823031055.GH3875@merlins.org>
References: <20140822155040.GU3875@merlins.org>
 <pan$a7366$366442ed$60aa89a1$c636b8e3@cox.net>
 <20140822184919.GE3875@merlins.org>
 <pan$644c4$e5e83b2d$34cd9e4d$75795b7@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$644c4$e5e83b2d$34cd9e4d$75795b7@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 23, 2014 at 02:52:16AM +0000, Duncan wrote:
> > For mysql, I got:
> > InnoDB: Page directory corruption: 
> > infimum not pointed to 140708 11:53:58
> > InnoDB: Page dump in ascii and hex (16384 bytes):
> > len 16384; hex 00000000(16KB of 0's).
> 
> Is that on ssd or spinning rust, and if ssd, do you run with trim/discard 
> and/or have you filled the device yet if not (since mkfs.btrfs trims the 
> device as part of the process)?  I'm wondering if that's 4 4 KiB btrfs 
> data blocks of trimmed and unwritten SSD?

It's on SSD, I do have trim/discard, I never filled the device.

But I could totally remove trim and see what happens. I'll do that.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
