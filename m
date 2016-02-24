Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52320 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbcBXB5E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 20:57:04 -0500
Date: Tue, 23 Feb 2016 17:56:58 -0800
From: Marc MERLIN <marc@merlins.org>
To: Kenny MacDermid <kenny.macdermid@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20160224015658.GY22487@merlins.org>
References: <20160224004045.GA20632@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160224004045.GA20632@gmail.com>
Subject: Re: Input/Output errors
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2016 at 08:40:46PM -0400, Kenny MacDermid wrote:
> I'm running btrfs on DM-Crypt Luks running on LVM.
> 
> Occasionally I get files that are unreadable for some period of time.
> Attempting to read from them results in an 
> 
> Input/output error
> 
> Sometimes they'll come back on their own, and sometimes a scrub seems to
> help, but sometimes I just have to delete them.
> 
> Nothing shows up in dmesg when these occur, and I can't predict which
> files it will be, or what causes it.
> 
> It's currently happening running 4.4.1-2-ARCH, but I've seen the same
> thing for many previous kernel versions.
> 
> Does anyone have any suggestions?

That's weird to say the least, you should at least get *something* in
dmesg.
And you are getting other error messages and btrfs kernel messages in
your logs?

When whatever app you have that's trying to read them fails, I assume
they also fail with cat or less?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
