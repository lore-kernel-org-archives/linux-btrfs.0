Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43816 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbbELOlp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 10:41:45 -0400
Date: Tue, 12 May 2015 07:41:41 -0700
From: Marc MERLIN <marc@merlins.org>
To: Matt McKinnon <matt@techsquare.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20150512144141.GG15670@merlins.org>
References: <55512147.5030708@techsquare.com>
 <20150511234604.GF15670@merlins.org>
 <55515093.4060504@techsquare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55515093.4060504@techsquare.com>
Subject: Re: btrfs send/receive error
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 11, 2015 at 09:00:03PM -0400, Matt McKinnon wrote:
> >Marc
> 
> Send box is 3.16.6 .  Receive box is 3.17.4 .
> 
> Just upgraded the receiving box to 4.0.2 which didn't fix it, so
> I'll schedule a reboot of the sending box.

Yeah, usually these problems are because the sender sent a sequence of
events that doesn't make sense and can't be replicated by the receiver.
Hopefully the server upgrade will fix it.

Otherwise Filipe will be very interested in getting the output of btrfs
send -v -v from the sending and receiving side just around the time
where it dies.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
