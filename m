Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaGaLmk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 07:42:40 -0400
Date: Thu, 31 Jul 2014 13:42:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Cyril Scetbon <cyril.scetbon@free.fr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is Btrfs stable ?
Message-ID: <20140731114238.GB1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CC47E18A-CB01-4B75-8067-0DE43AF341C6@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CC47E18A-CB01-4B75-8067-0DE43AF341C6@free.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 31, 2014 at 12:32:27PM +0200, Cyril Scetbon wrote:
> I'm sorry cause I suppose it's a recurrent question. However I've been
> looking into the linux kernel code and didn't see anything concerning
> an experimental status for Btrfs. However, when I format a device with
> mkfs.btrfs I get a message saying it's experimental that comes from
> http://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/tree/mkfs.c#n1442

The mkfs.btrfs tool is probably the last instance where the experimental
tag exists, but should be removed so it's consistent with kernel and the
documentation. Thanks for the notice.

> But you say that it's no longer unstable at
> https://btrfs.wiki.kernel.org/index.php/Main_Page#Stability_status,
> right ?

That's right.
