Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35837 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab2FLWI0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 18:08:26 -0400
Date: Wed, 13 Jun 2012 00:08:04 +0200
From: David Sterba <dave@jikos.cz>
To: Chris Mason <chris.mason@fusionio.com>, "Ted Ts'o" <tytso@mit.edu>,
        "kreijack@inwind.it" <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Btrfs and data nocow per inode basis
Message-ID: <20120612220804.GI32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <4FD442F1.7040008@inwind.it>
 <4FD77F45.3060000@libero.it>
 <20120612183209.GC1803@thunk.org>
 <20120612191527.GA11966@thunk.org>
 <20120612204423.GA27777@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120612204423.GA27777@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 12, 2012 at 04:44:23PM -0400, Chris Mason wrote:
> On Tue, Jun 12, 2012 at 01:15:27PM -0600, Ted Ts'o wrote:
> > It appears the NOCOW_FL flag is currently a no-op in the 3.2 kernel?
> 
> It's not a noop, but it is only setting the NODATACOW flag.  It needs to
> set the nodatasum flag as well, just like the mount -o nodatacow mount
> option does.
> 
> I'll fix this up on the kernel side, thanks Ted.

Last time the nocow question popped up, I sent this workaround,

http://article.gmane.org/gmane.comp.file-systems.btrfs/17351
(whole thread http://article.gmane.org/gmane.comp.file-systems.btrfs/17351)

which now seems to be the way to go (as removing the checksums from
existing file is not that easy).

Good to see the NOCOW support going to lsattr/chattr.


david
