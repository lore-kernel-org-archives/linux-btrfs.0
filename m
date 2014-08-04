Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:60806 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaHDFB6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 01:01:58 -0400
From: Russell Coker <russell@coker.com.au>
To: george@chinilu.com
Reply-To: russell@coker.com.au
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Scan not being performed properly on boot
Date: Mon, 04 Aug 2014 15:01:53 +1000
Message-ID: <3123040.QXoTpzZbhi@xev>
In-Reply-To: <53DF0D55.3050504@chinilu.com>
References: <53DEF7DD.5070002@peter-r.co.uk> <30613326.hzdtJptJHK@xev> <53DF0D55.3050504@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 3 Aug 2014 21:34:29 George Mitchell wrote:
> I see what you are saying.  Its a hack.  But I suspect that most of the 
> distros are not yet accommodating btrfs with their standard mkinitrd 
> process.  At this point modifying grub2 config does solve the problem.  
> If you know a reasonably easy way to fix initrd so that it can interpret 
> UUID and LABEL, I would certainly be all ears.

Debian/Wheezy works with BTRFS when using UUID= to specify the root 
filesystem.  Wheezy was released in May 2013, Ubuntu 14.04 was released in 
April 2014 and as Ubuntu is based on Debian it should have at least the same 
features as an older version of Debian.

I think that most Distributions are supporting BTRFS.  Debian/Wheezy has 
support for BTRFS (although I recommend that you don't use it unless you plan 
to take a kernel from Testing), most Debian derivatives will support it, 
Fedora supports it.

It's probably better to make a list of distributions that DON'T support BTRFS, 
it'll be a shorter list.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

