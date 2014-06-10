Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41994 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaFJE6n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jun 2014 00:58:43 -0400
Date: Mon, 9 Jun 2014 21:58:33 -0700
From: Marc MERLIN <marc@merlins.org>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        takeuchi_satoru@jp.fujitsu.com
Message-ID: <20140610045833.GB6584@merlins.org>
References: <20140609234007.GD19071@merlins.org>
 <1527084.dhGmUB9IiI@xev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1527084.dhGmUB9IiI@xev>
Subject: Re: btrfs balance crash BUG ON fs/btrfs/relocation.c:1062 or RIP
 build_backref_tree+0x9fc/0xcc4
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 10, 2014 at 10:32:33AM +1000, Russell Coker wrote:
> On Mon, 9 Jun 2014 16:40:07 Marc MERLIN wrote:
> > I did a balance on a system that had 3.11 (yes, I know, it's old). It hung.
> > So, I rebooted with 3.13, and it failed in fs/btrfs/relocation
> > 
> > Problem #1: I cannot stop the relocation. It starts on its own as soon as I
> > mount the FS, and I can't stop it.
> > Is there a bug to fix that?
> 
> The skip_balance mount option prevents a balance from being continued.  On all 
> my systems I have rootflags=skip_balance in the GRUB configuration because so 
> far I have never had a system reboot during a balance for any reason other 
> than a system crash caused by the balance.
 
Aaah, good idea, thank you.

> I think it would be good to have a program comparable to tune2fs that allows 
> us to set the state of such things.  It would be a lot easier than modifying 
> boot loader configuration on lots of systems.

Totally agreed. 

I'll still wait a bit to see if someone wants me to provide more info
from the FS, but having balance crash the system and hard lock it, is
indeed not good.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
