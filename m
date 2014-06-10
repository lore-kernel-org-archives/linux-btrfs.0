Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41161 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934533AbaFJAci (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jun 2014 20:32:38 -0400
From: Russell Coker <russell@coker.com.au>
To: Marc MERLIN <marc@merlins.org>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        takeuchi_satoru@jp.fujitsu.com
Subject: Re: btrfs balance crash BUG ON fs/btrfs/relocation.c:1062 or RIP build_backref_tree+0x9fc/0xcc4
Date: Tue, 10 Jun 2014 10:32:33 +1000
Message-ID: <1527084.dhGmUB9IiI@xev>
In-Reply-To: <20140609234007.GD19071@merlins.org>
References: <20140609234007.GD19071@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 9 Jun 2014 16:40:07 Marc MERLIN wrote:
> I did a balance on a system that had 3.11 (yes, I know, it's old). It hung.
> So, I rebooted with 3.13, and it failed in fs/btrfs/relocation
> 
> Problem #1: I cannot stop the relocation. It starts on its own as soon as I
> mount the FS, and I can't stop it.
> Is there a bug to fix that?

The skip_balance mount option prevents a balance from being continued.  On all 
my systems I have rootflags=skip_balance in the GRUB configuration because so 
far I have never had a system reboot during a balance for any reason other 
than a system crash caused by the balance.

I think it would be good to have a program comparable to tune2fs that allows 
us to set the state of such things.  It would be a lot easier than modifying 
boot loader configuration on lots of systems.

Also rootflags=skip_balance will abort the boot if you run kernel 3.2.0 and 
that caused me some annoyance when I applied it to all systems including the 
one with a stock Debian/Wheezy configuration.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

