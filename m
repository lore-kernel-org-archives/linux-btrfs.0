Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35568 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaHWMea (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 08:34:30 -0400
Date: Sat, 23 Aug 2014 05:34:28 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unclean shutdowns cause google-chrome profile to be corrupted in
 various ways
Message-ID: <20140823123428.GK3875@merlins.org>
References: <20140822155040.GU3875@merlins.org>
 <pan$a7366$366442ed$60aa89a1$c636b8e3@cox.net>
 <20140822184919.GE3875@merlins.org>
 <pan$644c4$e5e83b2d$34cd9e4d$75795b7@cox.net>
 <20140823031055.GH3875@merlins.org>
 <pan$3fa9$3263e6a0$42fec4bc$6017376e@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$3fa9$3263e6a0$42fec4bc$6017376e@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 23, 2014 at 05:56:28AM +0000, Duncan wrote:
> Of course that begs the question of whether it was a normal COW file or 
> if you had it NOCOW.  Setting it NOCOW (of course doing the correct set 

I had it at the default of COW, both chrome and mysql.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
