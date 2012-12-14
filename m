Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kwak.cryptyx.com ([176.9.47.209]:37506 "EHLO kwak.cryptyx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659Ab2LNQmB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Dec 2012 11:42:01 -0500
Message-ID: <50CB56D0.7010509@junod.info>
Date: Fri, 14 Dec 2012 17:41:52 +0100
From: Pascal Junod <pascal@junod.info>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        David Sterba <dave@jikos.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [btrfs] is vulnerable to a hash-DoS attack
References: <50C9D085.3020305@junod.info> <20121213205208.GA27308@shiny> <20121213213430.GB22426@twin.jikos.cz> <20121213220727.GC27308@shiny> <20121214142932.GB19606@shiny>
In-Reply-To: <20121214142932.GB19606@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 14.12.12 15:29, Chris Mason a écrit :

> Ok, I think what was happening on Pascal's machine is that we are
> returning -EOVERFLOW and sometimes aborting the transaction (which turns
> the FS readonly).
> 
> I have that fixed here.  Rename I'm reodering the rename code a little
> bit to also handle the case where there are collisions on rename.

Please tell me if I can help by explaining more about my setup.

Pascal

